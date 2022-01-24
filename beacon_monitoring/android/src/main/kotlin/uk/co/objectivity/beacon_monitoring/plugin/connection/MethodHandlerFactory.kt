// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.connection

import uk.co.objectivity.beacon_monitoring.plugin.service.BluetoothService
import uk.co.objectivity.beacon_monitoring.plugin.service.LocationService
import uk.co.objectivity.beacon_monitoring.plugin.service.MonitoringService

class MethodHandlerFactory(
        private val bluetoothService: BluetoothService,
        private val locationService: LocationService,
        private val monitoringService: MonitoringService
) {
    fun create(methodName: MethodName): MethodHandler {
        return when (methodName) {
            MethodName.SET_DEBUG -> SetDebugHandler(monitoringService)
            MethodName.IS_BLUETOOTH_ENABLED -> IsBluetoothEnabledHandler(bluetoothService)
            MethodName.OPEN_BLUETOOTH_SETTINGS -> OpenBluetoothSettingsHandler(bluetoothService)
            MethodName.CHECK_LOCATION_PERMISSION -> CheckLocationPermissionHandler(locationService)
            MethodName.REQUEST_LOCATION_PERMISSION -> RequestLocationPermissionHandler(locationService)
            MethodName.IS_LOCATION_ENABLED -> IsLocationEnabledHandler(locationService)
            MethodName.OPEN_LOCATION_SETTINGS -> OpenLocationSettingsHandler(locationService)
            MethodName.IS_MONITORING_STARTED -> IsMonitoringStartedHandler(monitoringService)
            MethodName.REGISTER_REGION -> RegisterRegionHandler(monitoringService)
            MethodName.REGISTER_ALL_REGIONS -> RegisterRegionHandler(monitoringService)
            MethodName.REMOVE_REGION -> RemoveRegionHandler(monitoringService)
            MethodName.REMOVE_ALL_REGIONS -> RemoveRegionHandler(monitoringService)
            MethodName.START_BACKGROUND_MONITORING -> StartBackgroundMonitoringHandler(monitoringService)
            MethodName.STOP_BACKGROUND_MONITORING -> StopBackgroundMonitoringHandler(monitoringService)
            else -> NotImplementedHandler
        }
    }
}
