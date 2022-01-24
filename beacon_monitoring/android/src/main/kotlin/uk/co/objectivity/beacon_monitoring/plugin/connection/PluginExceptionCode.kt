// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.connection

enum class PluginExceptionCode(val value: String) {
    BLUETOOTH_DISABLED(Config.PluginExceptionCode.BLUETOOTH_DISABLED),
    LOCATION_DISABLED(Config.PluginExceptionCode.LOCATION_DISABLED),
    LOCATION_PERMISSION_DENIED(Config.PluginExceptionCode.LOCATION_PERMISSION_DENIED)
}
