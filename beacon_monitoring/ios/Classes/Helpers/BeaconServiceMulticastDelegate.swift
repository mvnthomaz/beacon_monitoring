// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import CoreLocation

final class BeaconServiceMulticastDelegate: NSObject, BeaconServiceDelegate {

    // MARK: - Private Properties
    private let multicast = MulticastDelegate<BeaconServiceDelegate>()

    // MARK: - Public Methods
    func add(_ delegate: BeaconServiceDelegate) {
        multicast.add(delegate)
    }
    func remove(_ delegateToRemove: BeaconServiceDelegate) {
        multicast.remove(delegateToRemove)
    }

    // MARK: - BeaconServiceDelegate Methods
    func beaconService(_ service: BeaconService, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        multicast.invoke { $0.beaconService?(service, didRangeBeacons: beacons, in: region) }
    }
    func beaconService(_ service: BeaconService, didDetermineState state: CLRegionState, for region: CLBeaconRegion) {
        multicast.invoke { $0.beaconService?(service, didDetermineState: state, for: region) }
    }
    func beaconService(_ service: BeaconService, didEnterRegion region: CLBeaconRegion) {
        multicast.invoke { $0.beaconService?(service, didEnterRegion: region) }
    }
    func beaconService(_ service: BeaconService, didExitRegion region: CLBeaconRegion) {
        multicast.invoke { $0.beaconService?(service, didExitRegion: region) }
    }
}
