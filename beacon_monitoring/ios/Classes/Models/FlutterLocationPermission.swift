// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import CoreLocation

enum FlutterLocationPermission: String, Codable {

    // MARK: - Values
    case denied
    case always
    case whileInUse

    // MARK: - Factory Method
    static func from(_ authorizationStatus: CLAuthorizationStatus) -> FlutterLocationPermission {
        switch authorizationStatus {
        case .notDetermined, .restricted, .denied:
            return .denied
        case .authorizedAlways:
            return .always
        case .authorizedWhenInUse:
            return .whileInUse
        @unknown default:
            return .denied
        }
    }

}
