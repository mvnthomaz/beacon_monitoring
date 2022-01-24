// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Flutter

final class RegisterAllRegionsMethodCallHandler: FlutterMethodCallHandlerProtocol {

    // MARK: - Private Properties
    private let decoder: FlutterDecoder
    private let beaconService: BeaconService

    // MARK: - Instance Initialization
    init(decoder: FlutterDecoder, beaconService: BeaconService) {
        self.decoder = decoder
        self.beaconService = beaconService
    }

    // MARK: - FlutterMethodCallHandlerProtocol Methods
    func handleMethodCall(_ arguments: Any?, result: @escaping FlutterResult) {
        if let regions = decoder.decodeBeaconRegions(arguments: arguments) {
            os_log()
            beaconService.registerAllRegions(regions)
            result(FlutterResultModel.void())
        } else {
            result(FlutterError.exceptionInvalidArguments())
            os_log("\(FlutterError.exceptionInvalidArguments())")
        }
    }
}
