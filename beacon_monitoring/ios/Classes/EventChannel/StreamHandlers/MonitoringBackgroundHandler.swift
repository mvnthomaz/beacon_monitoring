// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Flutter
import CoreLocation

protocol MonitoringBackgroundHandlerMethodCallDelegate: class {
    func monitoringBackgroundHandler(_ handler: MonitoringBackgroundHandler, shouldRegisterPlugin engine: FlutterEngine)
}

final class MonitoringBackgroundHandler: NSObject {

    // MARK: - FlutterEngineState
    private enum FlutterEngineState: Int {
        case notInitialized
        case initializing
        case initialized
    }

    // MARK: - Public Properties
    weak var delegate: MonitoringBackgroundHandlerMethodCallDelegate?

    // MARK: - Private Properties
    private let logger: NotificationService
    private let beaconService: BeaconService
    private let preferencesStorage: PreferencesStorage
    private var backgroundFlutterEngine: FlutterEngine?
    private var backgroundMethodChannel: FlutterMethodChannel?

    private var backgroundFlutterEngineState: FlutterEngineState = .notInitialized
    private var pendingMonitoringResults: [FlutterMonitoringResult] = []

    // MARK: - Instance Initialization
    init(beaconService: BeaconService, preferencesStorage: PreferencesStorage) {
        self.logger = NotificationService()
        self.beaconService = beaconService
        self.preferencesStorage = preferencesStorage
        super.init()
        continueBackgroundMonitoring()
    }

    // MARK: - Public Methods
    func startBackgroundMonitoring(onComplete: @escaping BeaconServiceStartMonitoringResult) {
        os_log()
        setupBeaconServiceListener()
        beaconService.startBackgroundMonitoring(onComplete: onComplete)
    }
    func stopBackgroundMonitoring() {
        os_log()
        removeBeaconServiceListener()
        beaconService.stopBackgroundMonitoring()
    }

    // MARK: - Private Methods
    private func continueBackgroundMonitoring() {
        if preferencesStorage.isBackgroundMonitoringStarted {
            setupBeaconServiceListener()
        }
    }
    private func setupBackgroundMethodChannel() {
        os_log()
        guard let dispatcherId = CallbackDispatcher.dispatcherId else { return }
        let info = FlutterCallbackCache.lookupCallbackInformation(dispatcherId)
        backgroundFlutterEngineState = .initializing

        // setup engine
        let flutterEngine = FlutterEngine(name: Config.Engine.Name.background, project: nil, allowHeadlessExecution: true)
        flutterEngine.run(withEntrypoint: info?.callbackName, libraryURI: info?.callbackLibraryPath)
        delegate?.monitoringBackgroundHandler(self, shouldRegisterPlugin: flutterEngine)

        // setup background method channel
        let channel = FlutterMethodChannel(
            name: Config.ChannelName.background,
            binaryMessenger: flutterEngine.binaryMessenger)
        channel.setMethodCallHandler { call, result in
            switch call.method {
            case Config.Method.Background.initialized:
                self.cleanupPendingMonitoringResults()
                result(nil)
            default:
                self.cleanupBackgroundMethodChannel()
                result(FlutterMethodNotImplemented)
            }
        }

        backgroundFlutterEngine = flutterEngine
        backgroundMethodChannel = channel
    }
    private func cleanupPendingMonitoringResults() {
        os_log()
        pendingMonitoringResults.forEach { sendMonitoringEvent($0) }
        pendingMonitoringResults.removeAll()
        cleanupBackgroundMethodChannel()
    }
    private func cleanupBackgroundMethodChannel() {
        os_log()
        backgroundFlutterEngineState = .notInitialized
        backgroundFlutterEngine?.destroyContext()
        backgroundMethodChannel = nil
    }
    private func handleMonitoringEvent(_ event: FlutterMonitoringResult) {
        os_log("\(event.region.identifier): type: \(event.type)")
        switch backgroundFlutterEngineState {
        case .notInitialized:
            cacheMonitoringEvent(event)
            setupBackgroundMethodChannel()
        case .initializing:
            cacheMonitoringEvent(event)
        case .initialized:
            sendMonitoringEvent(event)
        }
    }
    private func sendMonitoringEvent(_ event: FlutterMonitoringResult) {
        guard let callbackId = CallbackDispatcher.callbackId else { return }
        let backgroundMonitoringResult = FlutterBackgroundMonitoringResult(monitoringCallbackId: callbackId, monitoringResult: event)
        backgroundMethodChannel?.invokeMethod("", arguments: backgroundMonitoringResult.toFlutterObject())
    }
    private func cacheMonitoringEvent(_ event: FlutterMonitoringResult) {
        pendingMonitoringResults.append(event)
    }
}

// MARK: - BeaconService Listener
private extension MonitoringBackgroundHandler {
    func setupBeaconServiceListener() {
        beaconService.add(self)
    }
    func removeBeaconServiceListener() {
        beaconService.remove(self)
    }
}

// MARK: - BeaconServiceDelegate
extension MonitoringBackgroundHandler: BeaconServiceDelegate {
    func beaconService(_ service: BeaconService, didDetermineState state: CLRegionState, for region: CLBeaconRegion) {
        let event = FlutterMonitoringResult(beaconRegion: region, type: .didDetermineState, state: .init(state))
        handleMonitoringEvent(event)
    }
    func beaconService(_ service: BeaconService, didEnterRegion region: CLBeaconRegion) {
        logger.trigger(title: region.identifier, message: "didEnterRegion")
        os_log("\(region.identifier): didEnterRegion")
        let event = FlutterMonitoringResult(beaconRegion: region, type: .didEnterRegion, state: nil)
        handleMonitoringEvent(event)
    }
    func beaconService(_ service: BeaconService, didExitRegion region: CLBeaconRegion) {
        logger.trigger(title: region.identifier, message: "didExitRegion")
        os_log("\(region.identifier): didExitRegion")
        let event = FlutterMonitoringResult(beaconRegion: region, type: .didExitRegion, state: nil)
        handleMonitoringEvent(event)
    }
}
