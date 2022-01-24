// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.service

import uk.co.objectivity.beacon_monitoring.plugin.connection.PluginException
import uk.co.objectivity.beacon_monitoring.plugin.connection.PluginExceptionCode
import uk.co.objectivity.beacon_monitoring.plugin.model.LocationPermission
import uk.co.objectivity.beacon_monitoring.plugin.model.MonitoringResult
import uk.co.objectivity.beacon_monitoring.plugin.model.RangingResult
import uk.co.objectivity.beacon_monitoring.plugin.model.RegionModel

class MonitoringService(
        private val localStorageService: LocalStorageService,
        private val beaconClient: BeaconClient,
        private val bluetoothService: BluetoothService,
        private val locationService: LocationService
) {
    var monitoringNotifier: ((MonitoringResult) -> Unit)?
        get() {
            return beaconClient.monitoringNotifier
        }
        set(value) {
            beaconClient.monitoringNotifier = value
        }

    var rangingNotifier: ((RangingResult) -> Unit)?
        get() {
            return beaconClient.rangingNotifier
        }
        set(value) {
            beaconClient.rangingNotifier = value
        }

    fun setDebug(debug: Boolean) {
        beaconClient.isDebugMode = debug
    }

    fun isMonitoringEnabled(): Boolean {
        return beaconClient.isMonitoringEnabled()
    }

    fun addRegions(regions: List<RegionModel>) {
        regions.map { it.toAltBeaconRegion() }.forEach { beaconClient.addRegion(it) }
    }

    fun removeRegion(regions: List<RegionModel>) {
        regions.map { it.toAltBeaconRegion() }.forEach { beaconClient.removeRegion(it) }
    }

    fun startBackgroundMonitoring(backgroundCallbackId: Long, monitoringCallbackId: Long) {
        allRequirementsMet(
                LocationPermission.ALWAYS,
                onError = { throw PluginException(it) }
        )

        localStorageService.backgroundCallbackId = backgroundCallbackId
        localStorageService.monitoringCallbackId = monitoringCallbackId

        beaconClient.enableBackgroundMonitoring()
    }

    fun allRequirementsMet(
            locationPermission: LocationPermission = LocationPermission.WHILE_IN_USE,
            onSuccess: (() -> Unit)? = null,
            onError: ((pluginException: PluginExceptionCode) -> Unit)? = null
    ): Boolean {
        if (!bluetoothService.isEnabled()) {
            onError?.invoke(PluginExceptionCode.BLUETOOTH_DISABLED)
            return false
        }

        if (!locationService.isEnabled()) {
            onError?.invoke(PluginExceptionCode.LOCATION_DISABLED)
            return false
        }

        if (!locationPermissionMet(locationPermission)) {
            onError?.invoke(PluginExceptionCode.LOCATION_PERMISSION_DENIED)
            return false
        }

        onSuccess?.invoke()
        return true
    }

    fun stopBackgroundMonitoring() {
        localStorageService.backgroundCallbackId = -1
        localStorageService.monitoringCallbackId = -1

        beaconClient.disableBackgroundMonitoring()
    }

    private fun locationPermissionMet(locationPermission: LocationPermission): Boolean {
        return when (locationService.checkPermission()) {
            LocationPermission.ALWAYS -> locationPermission == LocationPermission.ALWAYS || locationPermission == LocationPermission.WHILE_IN_USE
            LocationPermission.WHILE_IN_USE -> locationPermission == LocationPermission.WHILE_IN_USE
            LocationPermission.DENIED -> false
        }
    }
}
