// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.connection

import android.content.Context
import org.altbeacon.beacon.BeaconManager
import uk.co.objectivity.beacon_monitoring.plugin.service.*

class DependencyContainer private constructor(context: Context) {
    val bluetoothService: BluetoothService
    val methodCallHandler: MethodCallHandler
    val localStorageService: LocalStorageService
    val beaconClient: BeaconClient
    val monitoringService: MonitoringService
    val locationService: LocationService
    val monitoringStreamHandler: MonitoringStreamHandler
    val rangingStreamHandler: RangingStreamHandler

    init {
        val beaconManager = BeaconManager.getInstanceForApplication(context)
        val notificationService = NotificationService(context)
        val permissionService = PermissionService(context)
        val buildVersionProvider = BuildVersionProvider()
        val locationEnabledService = LocationEnabledServiceProvider(context, buildVersionProvider)
                .create()

        this.bluetoothService = BluetoothService(context)
        this.locationService = LocationService(
                buildVersionProvider,
                permissionService,
                locationEnabledService
        )
        this.localStorageService = LocalStorageService(context)
        this.beaconClient = BeaconClient(
                context,
                beaconManager,
                localStorageService,
                notificationService
        )
        this.monitoringService = MonitoringService(
                localStorageService,
                beaconClient,
                bluetoothService,
                locationService
        )
        val methodHandlerFactory = MethodHandlerFactory(
                bluetoothService,
                locationService,
                monitoringService
        )
        this.methodCallHandler = MethodCallHandler(methodHandlerFactory)
        this.monitoringStreamHandler = MonitoringStreamHandler(monitoringService)
        this.rangingStreamHandler = RangingStreamHandler(monitoringService)
    }

    companion object {
        @Volatile
        private var INSTANCE: DependencyContainer? = null

        fun getInstance(context: Context) = INSTANCE ?: synchronized(this) {
            INSTANCE ?: DependencyContainer(context).also { INSTANCE = it }
        }
    }
}
