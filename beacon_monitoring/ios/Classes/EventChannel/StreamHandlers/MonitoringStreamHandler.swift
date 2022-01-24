// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Flutter
import CoreLocation

final class MonitoringStreamHandler: NSObject {

    // MARK: - Private Properties
    private var events: FlutterEventSink?
    private let beaconService: BeaconService

    // MARK: - Instance Initialization
    init(beaconService: BeaconService) {
        self.beaconService = beaconService
        super.init()
    }

    // MARK: - Dependencies
    private func setupDependencies() {
        beaconService.add(self)
        beaconService.startForegroundMonitoring { [weak self] _, error in
            guard let self = self, let error = error else { return }
            self.events?(FlutterError.from(error))
        }
    }
    private func removeDependencies() {
        beaconService.remove(self)
        beaconService.stopForegroundMonitoring()
    }

    // MARK: - Private Methods
    private func setupObserver(events: @escaping FlutterEventSink) {
        self.events = events
    }
    private func removeObservers() {
        events = nil
    }
    private func sendMonitoringEvent(beaconRegion: CLBeaconRegion, type: FlutterMonitoringResult.Event, state: FlutterMonitoringResult.State?) {
        let region = FlutterRegion(beaconRegion: beaconRegion)
        let monitoringResult = FlutterMonitoringResult(region: region, type: type, state: state)
        events?(monitoringResult.toFlutterObject())
    }
}

// MARK: - FlutterStreamHandler
extension MonitoringStreamHandler: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        os_log()
        setupObserver(events: events)
        setupDependencies()
        return nil
    }
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        os_log()
        removeObservers()
        removeDependencies()
        return nil
    }
}

// MARK: - BeaconServiceDelegate
extension MonitoringStreamHandler: BeaconServiceDelegate {
    func beaconService(_ service: BeaconService, didDetermineState state: CLRegionState, for region: CLBeaconRegion) {
        os_log()
        sendMonitoringEvent(beaconRegion: region, type: .didDetermineState, state: FlutterMonitoringResult.State(state))
    }
    func beaconService(_ service: BeaconService, didEnterRegion region: CLBeaconRegion) {
        os_log()
        sendMonitoringEvent(beaconRegion: region, type: .didEnterRegion, state: nil)
    }
    func beaconService(_ service: BeaconService, didExitRegion region: CLBeaconRegion) {
        os_log()
        sendMonitoringEvent(beaconRegion: region, type: .didExitRegion, state: nil)
    }
}
