// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Foundation

struct FlutterBackgroundMonitoringResult: Codable {

    // MARK: - Public Properties
    let monitoringCallbackId: Int64
    let monitoringResult: FlutterMonitoringResult

}
