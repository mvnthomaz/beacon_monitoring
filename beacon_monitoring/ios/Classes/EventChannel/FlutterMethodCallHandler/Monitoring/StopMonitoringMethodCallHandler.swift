// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Flutter

final class StopBackgroundMonitoringMethodCallHandler: FlutterMethodCallHandlerProtocol {

    // MARK: - Private Properties
    private let monitoringBackgroundHandler: MonitoringBackgroundHandler

    // MARK: - Instance Initialization
    init(monitoringBackgroundHandler: MonitoringBackgroundHandler) {
        self.monitoringBackgroundHandler = monitoringBackgroundHandler
    }

    // MARK: - FlutterMethodCallHandlerProtocol Methods
    func handleMethodCall(_ arguments: Any?, result: @escaping FlutterResult) {
        os_log()
        monitoringBackgroundHandler.stopBackgroundMonitoring()
        result(FlutterResultModel.void())
    }
}
