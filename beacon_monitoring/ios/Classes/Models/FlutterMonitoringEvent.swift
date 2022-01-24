// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Foundation

enum FlutterMonitoringEvent: String, Codable {
    case didEnterRegion
    case didExitRegion
    case didDetermineState
}
