// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import Flutter

final class OpenSettingsMethodCallHandler: FlutterMethodCallHandlerProtocol {

    // MARK: - Private Properties
    private let urlOpener: URLOpenerProtocol

    // MARK: - Instance Initialization
    init(urlOpener: URLOpenerProtocol) {
        self.urlOpener = urlOpener
    }

    // MARK: - FlutterMethodCallHandlerProtocol Methods
    func handleMethodCall(_ arguments: Any?, result: @escaping FlutterResult) {
        os_log()
        urlOpener.openSettings()
        result(FlutterResultModel.void())
    }
}
