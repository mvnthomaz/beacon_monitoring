// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Foundation

struct CallbackDispatcher {

    struct Parameters: Codable {
        let dispatcherId: Int64
        let callbackId: Int64
    }

    @UserDefault(Config.UserDefaults.Key.dispatcherId, defaultValue: nil)
    static var dispatcherId: Int64?

    @UserDefault(Config.UserDefaults.Key.callbackId, defaultValue: nil)
    static var callbackId: Int64?

}
