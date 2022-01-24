// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import CoreLocation

struct FlutterBeacon: Codable {

    // MARK: - Public Properties
    let ids: [String]
    let rssi: Int
    let accuracy: CLLocationAccuracy

    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case ids
        case rssi
        case accuracy = "distance"
    }

    // MARK: - Instance Initialization
    init(beacon: CLBeacon) {
        self.ids = FlutterBeacon.extractIds(from: beacon)
        self.rssi = beacon.rssi
        self.accuracy = max(0, beacon.accuracy)
    }

    init(ids: [String],
         rssi: Int,
         accuracy: CLLocationAccuracy) {
        self.ids = ids
        self.rssi = rssi
        self.accuracy = max(0, accuracy)
    }

    // MARK: - Private Methods
    private static func extractIds(from beacon: CLBeacon) -> [String] {
        var ids: [String] = []
        ids.append(beacon.proximityUUID.uuidString)
        ids.append(beacon.major.stringValue)
        ids.append(beacon.minor.stringValue)
        return ids
    }
}
