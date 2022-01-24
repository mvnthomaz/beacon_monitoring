// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import CoreLocation
import Foundation

struct FlutterRegion: Codable {

    // MARK: - Public Properties
    let identifier: String
    let ids: [String]

    // MARK: - Instance Initialization
    init(beaconRegion: CLBeaconRegion) {
        identifier = beaconRegion.identifier
        ids = FlutterRegion.extractIds(from: beaconRegion)
    }

    // MARK: - Private Methods
    private static func extractIds(from beaconRegion: CLBeaconRegion) -> [String] {
        var ids: [String?] = []
        ids.append(beaconRegion.proximityUUID.uuidString)
        ids.append(beaconRegion.major?.stringValue)
        ids.append(beaconRegion.minor?.stringValue)
        return ids.compactMap { $0 }
    }

}
