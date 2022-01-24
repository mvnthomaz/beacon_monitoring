// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Foundation
import CoreLocation

final class FlutterDecoder {

    // MARK: - Private Properties
    private let jsonDecoder = JSONDecoder()

    // MARK: - Public Methods
    func decodeBeaconRegion(arguments: Any?) -> CLBeaconRegion? {
        guard let flutterRegion = decode(FlutterRegion.self, from: arguments) else { return nil }
        return CLBeaconRegion(flutterRegion: flutterRegion)
    }
    func decodeBeaconRegions(arguments: Any?) -> [CLBeaconRegion]? {
        guard let flutterRegions = decode([FlutterRegion].self, from: arguments) else { return nil }
        return flutterRegions.map { CLBeaconRegion(flutterRegion: $0) }
    }
    func decodeCallbackDispatcherParameters(arguments: Any?) -> CallbackDispatcher.Parameters? {
        if let parameters = arguments as? [String: Int64],
            let dispatcherId = parameters[Config.Callback.Background.dispatcherId],
            let callbackId = parameters[Config.Callback.Background.callbackId]  {
            return CallbackDispatcher.Parameters(dispatcherId: dispatcherId, callbackId: callbackId)
        }
        return nil
    }

    // MARK: - Private Methods
    private func decode<T: Codable>(_ type: T.Type, from callArguments: Any?) -> T? {
        guard let jsonString = callArguments as? String,
            let jsonData = jsonString.data(using: .utf8),
            let results = try? jsonDecoder.decode(type, from: jsonData) else {
                return nil
        }
        return results
    }
}
