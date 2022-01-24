// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Flutter
import CoreLocation

final class RangingStreamHandler: NSObject {

    // MARK: - Private Properties
    private var events: FlutterEventSink?
    private let beaconService: BeaconService

    // MARK: - Instance Initialization
    init(beaconService: BeaconService) {
        os_log()
        self.beaconService = beaconService
        super.init()
    }

    // MARK: - Dependencies
    private func setupDependencies() {
        os_log()
        beaconService.add(self)
        beaconService.startForegroundRanging { [weak self] _, error in
            guard let self = self, let error = error else { return }
            self.events?(FlutterError.from(error))
        }
    }
    private func removeDependencies() {
        os_log()
        beaconService.remove(self)
        beaconService.stopForegroundRanging()
    }

    // MARK: - Private Methods
    private func setupObserver(events: @escaping FlutterEventSink) {
        os_log()
        self.events = events
    }
    private func removeObservers() {
        os_log()
        events = nil
    }
}

// MARK: - FlutterStreamHandler
extension RangingStreamHandler: FlutterStreamHandler {
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
extension RangingStreamHandler: BeaconServiceDelegate {
    func beaconService(_ service: BeaconService, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        os_log()
        let result = FlutterRangingResult(
            region: FlutterRegion(beaconRegion: region),
            beacons: beacons.map { FlutterBeacon(beacon: $0) })
        events?(result.toFlutterObject())
    }
}
