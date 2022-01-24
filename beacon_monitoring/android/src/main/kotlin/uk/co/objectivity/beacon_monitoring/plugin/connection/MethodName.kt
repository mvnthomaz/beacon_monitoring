// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.connection

enum class MethodName(private val rawActionName: String? = null) {
    SET_DEBUG(Config.Action.SET_DEBUG),

    IS_BLUETOOTH_ENABLED(Config.Action.IS_BLUETOOTH_ENABLED),
    OPEN_BLUETOOTH_SETTINGS(Config.Action.OPEN_BLUETOOTH_SETTINGS),

    CHECK_LOCATION_PERMISSION(Config.Action.CHECK_LOCATION_PERMISSION),
    REQUEST_LOCATION_PERMISSION(Config.Action.REQUEST_LOCATION_PERMISSION),
    IS_LOCATION_ENABLED(Config.Action.IS_LOCATION_ENABLED),
    OPEN_LOCATION_SETTINGS(Config.Action.OPEN_LOCATION_SETTINGS),

    REGISTER_REGION(Config.Action.REGISTER_REGION),
    REGISTER_ALL_REGIONS(Config.Action.REGISTER_ALL_REGIONS),
    REMOVE_REGION(Config.Action.REMOVE_REGION),
    REMOVE_ALL_REGIONS(Config.Action.REMOVE_ALL_REGIONS),
    IS_MONITORING_STARTED(Config.Action.IS_MONITORING_STARTED),
    BACKGROUND_INITIALIZED(Config.Action.BACKGROUND_INITIALIZED),
    START_BACKGROUND_MONITORING(Config.Action.START_BACKGROUND_MONITORING),
    STOP_BACKGROUND_MONITORING(Config.Action.STOP_BACKGROUND_MONITORING),

    UNKNOWN;

    companion object {
        fun fromRawActionName(rawActionName: String): MethodName =
                values().firstOrNull { it.rawActionName == rawActionName }
                        ?: UNKNOWN
    }
}
