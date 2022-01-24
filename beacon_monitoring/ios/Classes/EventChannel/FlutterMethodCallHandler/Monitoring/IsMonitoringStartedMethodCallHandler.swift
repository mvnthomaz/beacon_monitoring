// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Flutter

final class IsMonitoringStartedMethodCallHandler: FlutterMethodCallHandlerProtocol {

    // MARK: - Private Properties
    private let preferencesStorage: PreferencesStorage

    // MARK: - Instance Initialization
    init(preferencesStorage: PreferencesStorage) {
        self.preferencesStorage = preferencesStorage
    }

    // MARK: - FlutterMethodCallHandlerProtocol Methods
    func handleMethodCall(_ arguments: Any?, result: @escaping FlutterResult) {
        result(NSNumber(value: preferencesStorage.isMonitoringStarted()))
        os_log("isBackgroundMonitoringStarted \(preferencesStorage.isBackgroundMonitoringStarted)")
        os_log("isForegroundMonitoringStarted \(preferencesStorage.isForegroundMonitoringStarted)")
        os_log("isForegroundRangingStarted \(preferencesStorage.isForegroundRangingStarted)")
        os_log("isMonitoringStarted \(preferencesStorage.isMonitoringStarted())")
    }
}

