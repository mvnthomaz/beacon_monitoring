// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Flutter

final class FlutterEventChannelFactory {


    // MARK: - Public Methods
    func setupMonitoringEventChannel(binaryMessenger: FlutterBinaryMessenger, beaconService: BeaconService) {
        buildEventChannel(
            name: Config.ChannelName.monitoring,
            binaryMessenger: binaryMessenger,
            streamHandler: MonitoringStreamHandler(beaconService: beaconService))
    }

    func setupRangingEventChannel(binaryMessenger: FlutterBinaryMessenger, beaconService: BeaconService) {
        buildEventChannel(
            name: Config.ChannelName.ranging,
            binaryMessenger: binaryMessenger,
            streamHandler: RangingStreamHandler(beaconService: beaconService))
    }

    // MARK: - Private Methods
    private func buildEventChannel(
        name: String,
        binaryMessenger: FlutterBinaryMessenger,
        streamHandler: (FlutterStreamHandler & NSObjectProtocol)?) {
        let channel = FlutterEventChannel(name: name, binaryMessenger: binaryMessenger)
        channel.setStreamHandler(streamHandler)
    }

}
