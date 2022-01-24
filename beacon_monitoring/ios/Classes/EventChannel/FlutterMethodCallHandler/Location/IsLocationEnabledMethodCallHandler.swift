// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Flutter

final class IsLocationEnabledMethodCallHandler: FlutterMethodCallHandlerProtocol {

    // MARK: - Private Properties
    private let locationService: LocationService

    // MARK: - Instance Initialization
    init(locationService: LocationService) {
        self.locationService = locationService
    }

    // MARK: - FlutterMethodCallHandlerProtocol Methods
    func handleMethodCall(_ arguments: Any?, result: @escaping FlutterResult) {
        result(NSNumber(value: locationService.isLocationEnabled()))
        os_log("\(locationService.isLocationEnabled())")
    }
}

