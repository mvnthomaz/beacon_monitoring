// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Foundation

struct Config {

    static let pluginId = "uk.co.objectivity/beacon_monitoring"

    struct Callback {
        struct Background {
            static let dispatcherId = "backgroundCallbackId"
            static let callbackId   = "monitoringCallbackId"
        }
    }

    struct ChannelName {
        static let background = "\(pluginId)/background"
        static let methods = "\(pluginId)/methods"
        static let monitoring = "\(pluginId)/monitoring"
        static let ranging = "\(pluginId)/ranging"
    }

    struct Engine {
        struct Name {
            static let background = "\(pluginId).Flutter.Engine.Background"
        }
    }

    struct Method {
        struct Foreground {
            static let setDebug = "setDebug"

            static let isBluetoothEnabled = "isBluetoothEnabled"

            static let isLocationEnabled = "isLocationEnabled"
            static let checkLocationPermission = "checkLocationPermission"
            static let requestLocationPermission = "requestLocationPermission"

            static let openApplicationSettings = "openApplicationSettings"
            static let openBluetoothSettings = "openBluetoothSettings"
            static let openLocationSettings = "openLocationSettings"

            static let registerRegion = "registerRegion"
            static let registerAllRegions = "registerAllRegions"
            static let removeRegion = "removeRegion"
            static let removeAllRegions = "removeAllRegions"

            static let isMonitoringStarted = "isMonitoringStarted"
            static let startBackgroundMonitoring = "startBackgroundMonitoring"
            static let stopBackgroundMonitoring = "stopBackgroundMonitoring"
        }

        struct Background {
            static let initialized = "backgroundInitialized"
        }
    }

    struct UserDefaults {
        struct Key {
            static let dispatcherId = "\(pluginId).dispatcherId"
            static let callbackId = "\(pluginId).callbackId"
            static let isBackgroundMonitoringStarted = "\(pluginId).isBackgroundMonitoringStarted"
            static let isForegroundMonitoringStarted = "\(pluginId).isForegroundMonitoringStarted"
            static let isForegroundRangingStarted = "\(pluginId).isForegroundRangingStarted"
            static let isDebugEnabled = "\(pluginId).isDebugEnabled"
        }
    }

}
