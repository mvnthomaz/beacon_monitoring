// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.service

import android.content.Context
import uk.co.objectivity.beacon_monitoring.plugin.connection.Config

private const val SHARED_PREFS_FILE_NAME = "beacon_plugin"
private const val BACKGROUND_MONITORING_ENABLED_KEY = "background_monitoring_enabled"
private const val DEBUG_ENABLED_KEY = "debug_enabled"

private fun Context.preferences() =
        getSharedPreferences(SHARED_PREFS_FILE_NAME, Context.MODE_PRIVATE)

class LocalStorageService(private val context: Context) {
    var backgroundCallbackId: Long
        get() = context.preferences().getLong(Config.ArgsKey.BACKGROUND_CALLBACK_ID, -1)
        set(value) {
            context.preferences().edit().putLong(Config.ArgsKey.BACKGROUND_CALLBACK_ID, value).apply()
        }

    var monitoringCallbackId: Long
        get() = context.preferences().getLong(Config.ArgsKey.MONITORING_CALLBACK_ID, -1)
        set(value) {
            context.preferences().edit().putLong(Config.ArgsKey.MONITORING_CALLBACK_ID, value).apply()
        }

    var isBackgroundMonitoringEnabled: Boolean
        get() = context.preferences().getBoolean(BACKGROUND_MONITORING_ENABLED_KEY, false)
        set(value) {
            context.preferences().edit().putBoolean(BACKGROUND_MONITORING_ENABLED_KEY, value).apply()
        }

    var isInDebugMode: Boolean
        get() = context.preferences().getBoolean(DEBUG_ENABLED_KEY, false)
        set(value) {
            context.preferences().edit().putBoolean(DEBUG_ENABLED_KEY, value).apply()
        }
}
