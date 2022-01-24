// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Flutter

extension FlutterError {

    // MARK: - ExceptionCode
    private struct ExceptionCode {
        static let bluetoothDisabled = "bluetoothDisabled"
        static let invalidArguments = "invalidArguments"
        static let locationDisabled = "locationDisabled"
        static let locationPermissionDenied = "locationPermissionDenied"
        static let unexpected = "unexpected"
    }

    // MARK: - Errors
    static func exceptionBluetoothDisabled() -> FlutterError {
        return FlutterError(code: ExceptionCode.bluetoothDisabled, message: nil, details: nil)
    }
    static func exceptionLocationDisabled() -> FlutterError {
        return FlutterError(code: ExceptionCode.locationDisabled, message: nil, details: nil)
    }
    static func exceptionLocationPermissionDenied() -> FlutterError {
        return FlutterError(code: ExceptionCode.locationPermissionDenied, message: nil, details: nil)
    }
    static func exceptionInvalidArguments() -> FlutterError {
        return FlutterError(code: ExceptionCode.invalidArguments, message: nil, details: nil)
    }
    static func exceptionUnexpected() -> FlutterError {
        return FlutterError(code: ExceptionCode.unexpected, message: nil, details: nil)
    }

    // MARK: - Factory Methods
    static func from(_ beaconServiceError: BeaconService.Error) -> FlutterError {
        os_log("\(beaconServiceError)")
        switch beaconServiceError {
        case .bluetoothIsDisabled:
            return exceptionBluetoothDisabled()
        case .monitoringIsNotAvailable:
            return exceptionLocationDisabled()
        case .rangingIsNotAvailable:
            return exceptionLocationDisabled()
        case .locationServicesAreDisabled:
            return exceptionLocationDisabled()
        case .locationServicesAreDenied:
            return exceptionLocationPermissionDenied()
        case .locationServicesAreNotDetermined:
            return exceptionLocationDisabled()
        case .locationServicesAreRestricted:
            return .exceptionLocationPermissionDenied()
        case .locationServicesAreNotAuthorizedWhenInUse:
            return exceptionLocationPermissionDenied()
        case .locationServicesAreNotAuthorizedAlways:
            return exceptionLocationPermissionDenied()

        }
    }
}
