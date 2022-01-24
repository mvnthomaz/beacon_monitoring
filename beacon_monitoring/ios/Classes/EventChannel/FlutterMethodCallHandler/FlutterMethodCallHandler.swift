// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Flutter

protocol FlutterMethodCallHandlerProtocol {
    func handleMethodCall(_ arguments: Any?, result: @escaping FlutterResult)
}

final class FlutterMethodCallHandler {

    // MARK: - Private Properties
    private let dependencyContainer: DependencyContainer
    private let monitoringBackgroundHandler: MonitoringBackgroundHandler

    // MARK: - Instance Initialization
    init(dependencyContainer: DependencyContainer, monitoringBackgroundHandler: MonitoringBackgroundHandler) {
        self.dependencyContainer = dependencyContainer
        self.monitoringBackgroundHandler = monitoringBackgroundHandler
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let handler = self.handler(call, result: result)
        handler?.handleMethodCall(call.arguments, result: result)
    }

    // MARK: - Private Methods
    private func handler(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> FlutterMethodCallHandlerProtocol? {
        os_log("\(call.method) - \(String(describing: call.arguments))")

        let decoder = dependencyContainer.decoder
        let bluetoothService = dependencyContainer.bluetoothService
        let beaconService = dependencyContainer.beaconService
        let urlOpener = dependencyContainer.urlOpener
        let preferencesStorage = dependencyContainer.preferencesStorage
        let locationService = dependencyContainer.locationService

        switch call.method {

        // debug
        case Config.Method.Foreground.setDebug:
            return SetDebugMethodCallHandler(preferencesStorage: preferencesStorage)

        // bluetooth
        case Config.Method.Foreground.isBluetoothEnabled:
            return IsBluetoothEnabledMethodCallHandler(bluetoothService: bluetoothService)

        // location
        case Config.Method.Foreground.isLocationEnabled:
            return IsLocationEnabledMethodCallHandler(locationService: locationService)
        case Config.Method.Foreground.checkLocationPermission:
            return CheckLocationPermissionMethodCallHandler(locationService: locationService)
        case Config.Method.Foreground.requestLocationPermission:
            return RequestLocationPermissionMethodCallHandler(locationService: locationService)

        // settings
        case Config.Method.Foreground.openApplicationSettings:
            return OpenSettingsMethodCallHandler(urlOpener: urlOpener)
        case Config.Method.Foreground.openBluetoothSettings:
            return OpenSettingsMethodCallHandler(urlOpener: urlOpener)
        case Config.Method.Foreground.openLocationSettings:
            return OpenSettingsMethodCallHandler(urlOpener: urlOpener)

        // regions
        case Config.Method.Foreground.registerRegion:
            return RegisterRegionMethodCallHandler(decoder: decoder, beaconService: beaconService)
        case Config.Method.Foreground.registerAllRegions:
            return RegisterAllRegionsMethodCallHandler(decoder: decoder, beaconService: beaconService)
        case Config.Method.Foreground.removeRegion:
            return RemoveRegionMethodCallHandler(decoder: decoder, beaconService: beaconService)
        case Config.Method.Foreground.removeAllRegions:
            return RemoveAllRegionsMethodCallHandler(decoder: decoder, beaconService: beaconService)

        // monitoring
        case Config.Method.Foreground.isMonitoringStarted:
            return IsMonitoringStartedMethodCallHandler(preferencesStorage: preferencesStorage)
        case Config.Method.Foreground.startBackgroundMonitoring:
            return StartBackgroundMonitoringMethodCallHandler(decoder: decoder, monitoringBackgroundHandler: monitoringBackgroundHandler)
        case Config.Method.Foreground.stopBackgroundMonitoring:
            return StopBackgroundMonitoringMethodCallHandler(monitoringBackgroundHandler: monitoringBackgroundHandler)

        default:
            result(FlutterMethodNotImplemented)
            return nil
        }
    }
}
