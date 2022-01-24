// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import CoreBluetooth
import Foundation

protocol BluetoothServiceProtocol {
    var isBluetoothEnabled: Bool { get }
}

protocol BluetoothServiceDelegate: class {
    func bluetoothServiceDidUpdateState(_ service: BluetoothService)
}

class BluetoothService: NSObject {

    // MARK: - Public Properties
    weak var delegate: BluetoothServiceDelegate?

    // MARK: - Private Properties
    private let bluetoothPermissionChecker: BluetoothPermissionCheckerProtocol
    private let centralManager = CBCentralManager()

    // MARK: - Instance Initialization
    init(bluetoothPermissionChecker: BluetoothPermissionChecker) {
        self.bluetoothPermissionChecker = bluetoothPermissionChecker
        super.init()
        self.centralManager.delegate = self
    }
}

// MARK: - BluetoothServiceProtocol
extension BluetoothService: BluetoothServiceProtocol {
    var isBluetoothEnabled: Bool {
        os_log("isBluetoothEnabled: \(bluetoothPermissionChecker.isBluetoothEnabled(centralManager))")
        return bluetoothPermissionChecker.isBluetoothEnabled(centralManager)
    }
}

// MARK: - CBCentralManagerDelegate
extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        delegate?.bluetoothServiceDidUpdateState(self)
    }
}
