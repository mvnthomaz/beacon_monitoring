// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import CoreLocation
import Foundation

extension CLBeaconRegion {
    convenience init(flutterRegion: FlutterRegion) {
        let identifier = flutterRegion.identifier
        guard let proximityUUIDString = flutterRegion.ids[safe: 0], let proximityUUID = UUID(uuidString: proximityUUIDString) else {
            fatalError("proximityUUID must be provided")
        }
        let majorString = flutterRegion.ids[safe: 1]
        let major = majorString.flatMap({CLBeaconMajorValue($0)})
        let minorString = flutterRegion.ids[safe: 2]
        let minor = minorString.flatMap({CLBeaconMinorValue($0)})
        if let major = major, let minor = minor {
            self.init(proximityUUID: proximityUUID, major: major, minor: minor, identifier: identifier)
        }

        if let major = major {
            self.init(proximityUUID: proximityUUID, major: major, identifier: identifier)
        }

        self.init(proximityUUID: proximityUUID, identifier: identifier)
    }
}
