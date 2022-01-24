// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Foundation

enum FlutterErrorType: String, Codable {
    case BLUETOOTH_DISABLED = "BLUETOOTH_DISABLED"
    case INVALID_ARGUMENT_FORMAT = "INVALID_ARGUMENT_FORMAT"
    case LOCATION_PERMISSION_DENIED = "LOCATION_PERMISSION_DENIED"
    case LOCATION_SERVICES_DISABLED = "LOCATION_SERVICES_DISABLED"
    case UNKNOWN = "UNKNOWN"
}
