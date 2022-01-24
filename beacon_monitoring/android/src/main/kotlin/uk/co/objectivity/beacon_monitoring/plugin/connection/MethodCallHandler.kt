// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.connection

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MethodCallHandler(private var methodHandlerFactory: MethodHandlerFactory) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val methodName = MethodName.fromRawActionName(call.method)
        val methodHandler = methodHandlerFactory.create(methodName)

        return methodHandler.handle(call, result)
    }
}