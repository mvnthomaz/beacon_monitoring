// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.service

import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import org.altbeacon.beacon.*
import org.altbeacon.beacon.startup.BootstrapNotifier
import org.altbeacon.beacon.startup.RegionBootstrap
import uk.co.objectivity.beacon_monitoring.plugin.model.*


private const val I_BEACON_LAYOUT = "m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24"

class BeaconClient(
        private val context: Context,
        private val beaconManager: BeaconManager,
        private val localStorageService: LocalStorageService,
        private val notifyService: NotificationService
) : BeaconConsumer, BootstrapNotifier, RangeNotifier {
    companion object {
        const val BACKGROUND_BETWEEN_SCAN_PERIOD: Long = 3000
        const val BACKGROUND_SCAN_PERIOD: Long = 1500
    }

    private var regionBootstrap: RegionBootstrap? = null
    private val regions = hashSetOf<Region>().apply { addAll(beaconManager.monitoredRegions) }

    var isDebugMode = localStorageService.isInDebugMode
        set(value) {
            field = value.also { localStorageService.isInDebugMode = it }
        }

    var monitoringNotifier: ((MonitoringResult) -> Unit)? = null
        set(value) {
            field = value

            if (value != null) {
                tryEnableMonitoring()
            } else {
                tryDisableMonitoring()
            }
        }

    var rangingNotifier: ((RangingResult) -> Unit)? = null
        set(value) {
            field = value

            if (value != null) {
                tryEnableMonitoring()
            } else {
                tryDisableMonitoring()
            }
        }

    override fun getApplicationContext(): Context = context.applicationContext

    override fun bindService(intent: Intent?, conn: ServiceConnection, flag: Int) =
            applicationContext.bindService(intent, conn, flag)

    override fun unbindService(conn: ServiceConnection) {
        applicationContext.unbindService(conn)
    }

    override fun onBeaconServiceConnect() {
        beaconManager.addRangeNotifier(this)
    }

    override fun didEnterRegion(region: Region?) {
        region?.let {
            beaconManager.startRangingBeaconsInRegion(it)
            val monitoringResult = MonitoringResult(it.toModel(), MonitoringEvent.didEnterRegion)
            notifyMonitoringListeners(monitoringResult)
            if (isDebugMode) notifyService.showMonitoringNotification(monitoringResult)
        }
    }

    override fun didExitRegion(region: Region?) {
        region?.let {
            beaconManager.stopRangingBeaconsInRegion(it)
            val monitoringResult = MonitoringResult(it.toModel(), MonitoringEvent.didExitRegion)
            notifyMonitoringListeners(monitoringResult)
            if (isDebugMode) {
                notifyService.showMonitoringNotification(monitoringResult)
                notifyService.hideRangingNotification()
            }
        }
    }

    override fun didDetermineStateForRegion(state: Int, region: Region?) {
        region?.let {
            val monitoringResult = MonitoringResult(
                    it.toModel(),
                    MonitoringEvent.didDetermineState,
                    MonitoringState.fromInt(state)
            )
            notifyMonitoringListeners(monitoringResult)
        }
    }

    override fun didRangeBeaconsInRegion(beacons: MutableCollection<Beacon>?, region: Region?) {
        region?.let {
            val result = RangingResult(region.toModel(), beacons.orEmpty().map { it.toModel() })
            rangingNotifier?.invoke(result)
            if (isDebugMode) notifyService.showRangingNotification(result)
        }
    }

    fun addRegion(region: Region) = regions.add(region)
            .takeIf { it }
            ?.also { regionBootstrap?.addRegion(region) }

    fun removeRegion(region: Region) = regions.remove(region)
            .takeIf { it }
            ?.also { regionBootstrap?.removeRegion(region) }

    fun enableBackgroundMonitoring() {
        localStorageService.isBackgroundMonitoringEnabled = true

        tryEnableMonitoring()
    }

    fun disableBackgroundMonitoring() {
        localStorageService.isBackgroundMonitoringEnabled = false

        tryDisableMonitoring()
    }

    fun enableMonitoring() {
        setupBeaconManager()
        regionBootstrap = RegionBootstrap(this, regions.toMutableList())
    }

    fun disableMonitoring() {
        regionBootstrap?.disable()
        regionBootstrap = null

        beaconManager.unbind(this)
        beaconManager.disableForegroundServiceScanning()
    }

    fun isMonitoringEnabled() = regionBootstrap != null

    private fun tryEnableMonitoring() {
        if (isMonitoringEnabled()) return

        enableMonitoring()
    }

    private fun tryDisableMonitoring() {
        if (isThereAnyListeners()) return

        disableMonitoring()
    }

    private fun isThereAnyListeners() =
            localStorageService.isBackgroundMonitoringEnabled || monitoringNotifier != null || rangingNotifier != null

    private fun setupBeaconManager() {
        if (beaconManager.isBound(this)) beaconManager.unbind(this)

        beaconManager.beaconParsers.clear()
        beaconManager.beaconParsers.add(BeaconParser().setBeaconLayout(I_BEACON_LAYOUT))

        beaconManager.enableForegroundServiceScanning(
                notifyService.getForegroundNotification(),
                FOREGROUND_NOTIFICATION_ID
        )

        beaconManager.backgroundBetweenScanPeriod = BACKGROUND_BETWEEN_SCAN_PERIOD
        beaconManager.backgroundScanPeriod = BACKGROUND_SCAN_PERIOD

        beaconManager.bind(this)

        BeaconManager.setDebug(isDebugMode)
    }

    private fun notifyMonitoringListeners(monitoringResult: MonitoringResult) {
        monitoringNotifier?.invoke(monitoringResult)
                ?: BackgroundConnectionService.enqueueWork(context, monitoringResult)
    }
}