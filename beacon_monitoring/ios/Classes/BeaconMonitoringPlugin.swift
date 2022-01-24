// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import CoreLocation
import Flutter
import UIKit

// MARK: - FlutterPluginAppLifeCycleDelegate
public class BeaconMonitoringPlugin: FlutterPluginAppLifeCycleDelegate {

    // MARK: - Private Properties
    private static var pluginRegistrantCallback: FlutterPluginRegistrantCallback?

    private let dependencyContainer = DependencyContainer.instance
    private let eventChannelFactory = FlutterEventChannelFactory()
    private let monitoringBackgroundHandler: MonitoringBackgroundHandler

    // MARK: - Lifecyce
    private init(registrar: FlutterPluginRegistrar) {
        monitoringBackgroundHandler = MonitoringBackgroundHandler(
            beaconService: dependencyContainer.beaconService,
            preferencesStorage: dependencyContainer.preferencesStorage)

        super.init()
        self.setupDependencies()
        self.setupEventChannels(binaryMessenger: registrar.messenger())
    }

    // MARK: - Dependencies
    private func setupDependencies() {
        monitoringBackgroundHandler.delegate = self
    }

    // MARK: - Event Channels
    private func setupEventChannels(binaryMessenger: FlutterBinaryMessenger) {
        eventChannelFactory.setupMonitoringEventChannel(
            binaryMessenger: binaryMessenger,
            beaconService: dependencyContainer.beaconService)

        eventChannelFactory.setupRangingEventChannel(
            binaryMessenger: binaryMessenger,
            beaconService: dependencyContainer.beaconService)
    }
}

// MARK: - FlutterPlugin
extension BeaconMonitoringPlugin: FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let mainChannel = FlutterMethodChannel(
            name: Config.ChannelName.methods,
            binaryMessenger: registrar.messenger())
        let instance = BeaconMonitoringPlugin(registrar: registrar)
        registrar.addMethodCallDelegate(instance, channel: mainChannel)
        registrar.addApplicationDelegate(instance)
    }

    public static func setPluginRegistrantCallback(_ callback: @escaping FlutterPluginRegistrantCallback) {
        BeaconMonitoringPlugin.pluginRegistrantCallback = callback
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let methodCallHandler = FlutterMethodCallHandler(
            dependencyContainer: dependencyContainer,
            monitoringBackgroundHandler: monitoringBackgroundHandler)
        methodCallHandler.handle(call, result: result)
    }
}

// MARK: - MonitoringBackgroundHandlerMethodCallDelegate
extension BeaconMonitoringPlugin: MonitoringBackgroundHandlerMethodCallDelegate {
    func monitoringBackgroundHandler(
        _ handler: MonitoringBackgroundHandler,
        shouldRegisterPlugin engine: FlutterEngine) {
        BeaconMonitoringPlugin.pluginRegistrantCallback?(engine)
    }
}
