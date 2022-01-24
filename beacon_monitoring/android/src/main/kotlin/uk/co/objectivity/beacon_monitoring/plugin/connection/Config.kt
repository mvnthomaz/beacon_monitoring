// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.connection

object Config {
    const val PLUGIN_ID = "uk.co.objectivity/beacon_monitoring"

    object Channel {
        const val METHODS_CHANNEL_NAME = "$PLUGIN_ID/methods"
        const val BACKGROUND_CHANNEL_NAME = "$PLUGIN_ID/background"
        const val MONITORING_CHANNEL_NAME = "$PLUGIN_ID/monitoring"
        const val RANGING_CHANNEL_NAME = "$PLUGIN_ID/ranging"
    }

    object Action {
        const val SET_DEBUG = "setDebug"

        const val IS_BLUETOOTH_ENABLED = "isBluetoothEnabled"
        const val OPEN_BLUETOOTH_SETTINGS = "openBluetoothSettings"

        const val CHECK_LOCATION_PERMISSION = "checkLocationPermission"
        const val REQUEST_LOCATION_PERMISSION = "requestLocationPermission"
        const val IS_LOCATION_ENABLED = "isLocationEnabled"
        const val OPEN_LOCATION_SETTINGS = "openLocationSettings"

        const val REGISTER_REGION = "registerRegion"
        const val REGISTER_ALL_REGIONS = "registerAllRegions"
        const val REMOVE_REGION = "removeRegion"
        const val REMOVE_ALL_REGIONS = "removeAllRegions"
        const val IS_MONITORING_STARTED = "isMonitoringStarted"
        const val BACKGROUND_INITIALIZED = "backgroundInitialized"
        const val START_BACKGROUND_MONITORING = "startBackgroundMonitoring"
        const val STOP_BACKGROUND_MONITORING = "stopBackgroundMonitoring"
    }

    object PluginExceptionCode {
        const val BLUETOOTH_DISABLED = "bluetoothDisabled"
        const val LOCATION_DISABLED = "locationDisabled"
        const val LOCATION_PERMISSION_DENIED = "locationPermissionDenied"
    }

    object ArgsKey {
        const val BACKGROUND_CALLBACK_ID = "backgroundCallbackId"
        const val MONITORING_CALLBACK_ID = "monitoringCallbackId"
        const val MONITORING_RESULT = "monitoringResult"
    }
}
