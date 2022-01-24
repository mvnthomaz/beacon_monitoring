// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import CoreLocation
import Foundation

struct FlutterMonitoringResult: Codable {

    enum Event: String, Codable {
        case didEnterRegion
        case didExitRegion
        case didDetermineState
    }

    enum State: String, Codable {
        case unknown
        case inside
        case outside

        init(_ regionState: CLRegionState) {
            switch regionState {
            case .unknown:
                self = .unknown
            case .inside:
                self = .inside
            case .outside:
                self = .outside
            }
        }
    }

    // MARK: - Private Properties
    private let identifier: String = UUID().uuidString

    // MARK: - Public Properties
    let region: FlutterRegion
    let type: Event
    let state: State?

    // MARK: - Instance Initialization
    init(region: FlutterRegion, type: Event, state: State?) {
        self.region = region
        self.type = type
        self.state = state
    }
    init(beaconRegion: CLBeaconRegion, type: Event, state: State?) {
        self.region = FlutterRegion(beaconRegion: beaconRegion)
        self.type = type
        self.state = state
    }
}

// MARK: - Equatable
extension FlutterMonitoringResult: Equatable {
    static func == (lhs: FlutterMonitoringResult, rhs: FlutterMonitoringResult) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
