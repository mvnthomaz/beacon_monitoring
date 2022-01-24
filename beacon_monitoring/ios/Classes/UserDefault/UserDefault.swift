// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Foundation

@propertyWrapper
struct UserDefault<T> {

    // MARK: - Public Properties
    let key: String
    let defaultValue: T

    // MARK: - Instance Initialization
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    // MARK: - Wrapped Value
    var wrappedValue: T {
        set { UserDefaults.standard.set(newValue, forKey: key) }
        get { return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
    }
}
