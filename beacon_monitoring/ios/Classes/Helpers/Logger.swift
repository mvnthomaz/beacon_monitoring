// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Foundation
import os

func os_log(_ message: String = "", file: String = #file, function: String = #function, line: Int = #line) {
    guard DependencyContainer.instance.preferencesStorage.isDebugEnabled else { return }
    let name = file.components(separatedBy: "/").last ?? ""
    debugPrint("💛 [LOG]: [\(name)] [\(line)] - [\(function)] - \(message)")
}
