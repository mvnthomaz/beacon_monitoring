// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Foundation

struct FlutterRangingResult: Codable {

    // MARK: - Public Properties
    let region: FlutterRegion
    let beacons: [FlutterBeacon]
}
