// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Flutter

final class CheckLocationPermissionMethodCallHandler: FlutterMethodCallHandlerProtocol {

    // MARK: - Private Properties
    private let locationService: LocationService

    // MARK: - Instance Initialization
    init(locationService: LocationService) {
        self.locationService = locationService
    }

    // MARK: - FlutterMethodCallHandlerProtocol Methods
    func handleMethodCall(_ arguments: Any?, result: @escaping FlutterResult) {
        let authorizationStatus = locationService.authorizationStatus()
        let locationPermission = FlutterLocationPermission.from(authorizationStatus)
        result(locationPermission.rawValue)
        os_log(locationPermission.rawValue)
    }
}
