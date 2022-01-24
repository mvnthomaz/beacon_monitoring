// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Foundation

class DependencyContainer {

    // MARK: - Instance
    static let instance = DependencyContainer()

    // MARK: - Public Properties
    let beaconService: BeaconService
    let bluetoothService: BluetoothService
    let decoder: FlutterDecoder
    let locationService: LocationService
    let preferencesStorage: PreferencesStorage
    let urlOpener: URLOpenerProtocol

    // MARK: - Instance Initalization
    private init() {
        let bluetoothService = BluetoothService(bluetoothPermissionChecker: BluetoothPermissionChecker())
        let locationService = LocationService()
        let permissionsService = PermissionsService(bluetoothService: bluetoothService)
        let preferencesStorage = PreferencesStorage(userDefaults: UserDefaults.standard)

        self.beaconService = BeaconService(locationService: locationService, preferencesStorage: preferencesStorage, permissionsService: permissionsService)
        self.bluetoothService = BluetoothService(bluetoothPermissionChecker: BluetoothPermissionChecker())
        self.decoder = FlutterDecoder()
        self.locationService = locationService
        self.preferencesStorage = preferencesStorage
        self.urlOpener = URLOpener()
    }
}
