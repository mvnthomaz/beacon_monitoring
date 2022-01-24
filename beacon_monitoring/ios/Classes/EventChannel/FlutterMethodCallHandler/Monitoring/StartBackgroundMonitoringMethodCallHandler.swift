// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Flutter

final class StartBackgroundMonitoringMethodCallHandler: FlutterMethodCallHandlerProtocol {

    // MARK: - Private Properties
    private let decoder: FlutterDecoder
    private let monitoringBackgroundHandler: MonitoringBackgroundHandler

    // MARK: - Instance Initialization
    init(decoder: FlutterDecoder, monitoringBackgroundHandler: MonitoringBackgroundHandler) {
        self.decoder = decoder
        self.monitoringBackgroundHandler = monitoringBackgroundHandler
    }

    // MARK: - FlutterMethodCallHandlerProtocol Methods
    func handleMethodCall(_ arguments: Any?, result: @escaping FlutterResult) {
        os_log()
        guard let parameters = decoder.decodeCallbackDispatcherParameters(arguments: arguments) else {
            result(FlutterError.exceptionInvalidArguments())
            os_log("\(FlutterError.exceptionInvalidArguments())")
            return
        }
        saveCallbackDispatcherParameters(parameters: parameters)
        startBackgroundMonitoring(result: result)
    }

    // MARK: - Private Methods
    private func saveCallbackDispatcherParameters(parameters: CallbackDispatcher.Parameters) {
        os_log("\(parameters)")
        CallbackDispatcher.dispatcherId = parameters.dispatcherId
        CallbackDispatcher.callbackId = parameters.callbackId
    }
    private func startBackgroundMonitoring(result: @escaping FlutterResult) {
        os_log()
        monitoringBackgroundHandler.startBackgroundMonitoring { didStartMonitoring, monitoringError in
            self.handleStartMonitoringResult(didStartMonitoring, monitoringError: monitoringError, result: result)
        }
    }
    private func handleStartMonitoringResult(_ didStartMonitoring: Bool, monitoringError: BeaconService.Error?, result: @escaping FlutterResult) {
        os_log()
        if didStartMonitoring {
            result(FlutterResultModel.void())
        } else if let monitoringError = monitoringError {
            result(FlutterError.from(monitoringError))
        } else {
            result(FlutterError.exceptionUnexpected())
        }
    }
}
