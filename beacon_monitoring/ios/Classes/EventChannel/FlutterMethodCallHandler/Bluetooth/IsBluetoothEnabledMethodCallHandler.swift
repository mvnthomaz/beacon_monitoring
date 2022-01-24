// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Flutter

final class IsBluetoothEnabledMethodCallHandler: FlutterMethodCallHandlerProtocol {

    // MARK: - Private Properties
    private let bluetoothService: BluetoothService

    // MARK: - Instance Initialization
    init(bluetoothService: BluetoothService) {
        self.bluetoothService = bluetoothService
    }

    // MARK: - FlutterMethodCallHandlerProtocol Methods
    func handleMethodCall(_ arguments: Any?, result: @escaping FlutterResult) {
        os_log("\(bluetoothService.isBluetoothEnabled)")
        result(NSNumber(value: bluetoothService.isBluetoothEnabled))
    }
}
