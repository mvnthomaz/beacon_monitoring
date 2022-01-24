// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Foundation

final class PreferencesStorage {

    // MARK: - Public Properties
    @UserDefault(Config.UserDefaults.Key.isBackgroundMonitoringStarted, defaultValue: false)
    var isBackgroundMonitoringStarted: Bool

    @UserDefault(Config.UserDefaults.Key.isForegroundMonitoringStarted, defaultValue: false)
    var isForegroundMonitoringStarted: Bool

    @UserDefault(Config.UserDefaults.Key.isForegroundRangingStarted, defaultValue: false)
    var isForegroundRangingStarted: Bool

    @UserDefault(Config.UserDefaults.Key.isDebugEnabled, defaultValue: false)
    var isDebugEnabled: Bool

    // MARK: - Private Properties
    private let userDefaults: UserDefaults

    // MARK: - Instance Initialization
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    // MARK: - Public Properties
    func isMonitoringStarted() -> Bool {
        return isBackgroundMonitoringStarted || isForegroundMonitoringStarted || isForegroundRangingStarted
    }
    func hasMonitoringListener() -> Bool {
        return isBackgroundMonitoringStarted || isForegroundMonitoringStarted || isForegroundRangingStarted
    }

}
