// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Flutter

final class SetDebugMethodCallHandler: FlutterMethodCallHandlerProtocol {

    // MARK: - Private Properties
    private let preferencesStorage: PreferencesStorage

    // MARK: - Instance Initialization
    init(preferencesStorage: PreferencesStorage) {
        self.preferencesStorage = preferencesStorage
    }

    // MARK: - FlutterMethodCallHandlerProtocol Methods
    func handleMethodCall(_ arguments: Any?, result: @escaping FlutterResult) {
        let isDebugEnabled = arguments as? Bool ?? false
        preferencesStorage.isDebugEnabled = isDebugEnabled
        result(FlutterResultModel.void())
    }
}

