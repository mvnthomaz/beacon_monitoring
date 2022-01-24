// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import CoreLocation

protocol PermissionsServiceProtocol {
    func checkAllowedPermissions(authorizationStatus: CLAuthorizationStatus) throws
}

final class PermissionsService {

    // MARK: - Private Properties
    private let bluetoothService: BluetoothService

    // MARK: - Instance Initialization
    init(bluetoothService: BluetoothService) {
        self.bluetoothService = bluetoothService
    }

    // MARK: - Private Methods
    private func checkIsBluetoothEnabled() throws {
        os_log()
        guard bluetoothService.isBluetoothEnabled else {
            throw BeaconService.Error.bluetoothIsDisabled
        }
    }
    private func checkIsMonitoringAvailable() throws {
        os_log()
        guard CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) else {
            throw BeaconService.Error.monitoringIsNotAvailable
        }
    }
    private func checkIsRangingAvailable() throws {
        os_log()
        guard CLLocationManager.isRangingAvailable() else {
            throw BeaconService.Error.rangingIsNotAvailable
        }
    }
    private func checkLocationServicesAvailability() throws {
        os_log()
        guard CLLocationManager.locationServicesEnabled() else {
            throw BeaconService.Error.locationServicesAreDisabled
        }
    }
    private func checkLocationServicesAuthorization(authorizationStatus: CLAuthorizationStatus) throws {
        os_log("expectedAuthorizationStatus: \(authorizationStatus.rawValue)")
        assert(
            authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways,
            "authorizationStatus must be `authorizedWhenInUse` or `authorizedAlways`")

        let actualAuthorizationStatus = CLLocationManager.authorizationStatus()
        let expectedAuthorizationStatus = authorizationStatus

        switch (actualAuthorizationStatus, expectedAuthorizationStatus) {
        case (.notDetermined, _):
            throw BeaconService.Error.locationServicesAreNotDetermined
        case (.restricted, _):
            throw BeaconService.Error.locationServicesAreRestricted
        case (.denied, _):
            throw BeaconService.Error.locationServicesAreDenied
        case (.authorizedWhenInUse, .authorizedWhenInUse):
            break
        case (.authorizedWhenInUse, .authorizedAlways):
            throw BeaconService.Error.locationServicesAreNotAuthorizedAlways
        case (.authorizedAlways, .authorizedWhenInUse):
            break
        case (.authorizedAlways, .authorizedAlways):
            break
        default:
            break
        }
    }

}

// MARK: - PermissionsServiceProtocol
extension PermissionsService: PermissionsServiceProtocol {
    func checkAllowedPermissions(authorizationStatus: CLAuthorizationStatus) throws {
        os_log()
        try checkIsBluetoothEnabled()
        try checkIsMonitoringAvailable()
        try checkIsRangingAvailable()
        try checkLocationServicesAvailability()
        try checkLocationServicesAuthorization(authorizationStatus: authorizationStatus)
    }
}
