// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import CoreBluetooth

protocol BluetoothPermissionCheckerProtocol {
    func isBluetoothEnabled(_ centralManager: CBCentralManager) -> Bool
}

final class BluetoothPermissionChecker {

    // MARK: - BluetoothPermissionCheckerBeforeiOS13
    private class BluetoothPermissionCheckerBeforeiOS13: BluetoothPermissionCheckerProtocol {
        func isBluetoothEnabled(_ centralManager: CBCentralManager) -> Bool {
            return centralManager.state == .poweredOn
        }
    }

    // MARK: - BluetoothPermissionCheckerBeforeiOS13_1
    @available(iOS 13.0, *)
    private class BluetoothPermissionCheckerBeforeiOS13_1: BluetoothPermissionCheckerProtocol {
        func isBluetoothEnabled(_ centralManager: CBCentralManager) -> Bool {
            return centralManager.state == .poweredOn &&
                centralManager.authorization == .allowedAlways
        }
    }

    // MARK: - BluetoothPermissionCheckerAfteriOS13_1
    @available(iOS 13.1, *)
    private class BluetoothPermissionCheckerAfteriOS13_1: BluetoothPermissionCheckerProtocol {
        func isBluetoothEnabled(_ centralManager: CBCentralManager) -> Bool {
            return centralManager.state == .poweredOn &&
                CBCentralManager.authorization == .allowedAlways
        }
    }

    // MARK: - Factory Methods
    class func buildBluetoothPermissionChecker() -> BluetoothPermissionCheckerProtocol {
        if #available(iOS 13.1, *) {
            return BluetoothPermissionCheckerAfteriOS13_1()
        } else if #available(iOS 13.0, *) {
            return BluetoothPermissionCheckerBeforeiOS13_1()
        } else {
            return BluetoothPermissionCheckerBeforeiOS13()
        }
    }

}

// MARK: - BluetoothPermissionCheckerProtocol
extension BluetoothPermissionChecker: BluetoothPermissionCheckerProtocol {
    func isBluetoothEnabled(_ centralManager: CBCentralManager) -> Bool {
        let permissionChecker = BluetoothPermissionChecker.buildBluetoothPermissionChecker()
        return permissionChecker.isBluetoothEnabled(centralManager)
    }
}
