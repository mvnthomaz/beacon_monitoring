// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Foundation

protocol URLOpenerProtocol {
    func openSettings()
}

class URLOpener: URLOpenerProtocol {

    // MARK: - Private Properties
    private let application = UIApplication.shared

    // MARK: - URLOpenerProtocol Methods
    func openSettings() {
        if let openSettingsURL = URL(string: UIApplication.openSettingsURLString) {
            application.openURL(openSettingsURL)
        }
    }
}
