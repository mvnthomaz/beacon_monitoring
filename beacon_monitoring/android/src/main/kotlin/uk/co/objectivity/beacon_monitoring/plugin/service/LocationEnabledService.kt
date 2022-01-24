// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.service

import android.content.Context
import android.location.LocationManager
import android.os.Build
import android.provider.Settings
import androidx.annotation.RequiresApi

interface LocationEnabledService {
    fun check(): Boolean
}

class LocationEnabledServiceProvider(
        context: Context,
        private val buildVersionProvider: BuildVersionProvider
) {
    private val locationEnabledServicePOrAbove = LocationEnabledServicePOrAbove(context)
    private val locationEnabledCheckBeforeP = LocationEnabledServiceBeforeP(context)

    fun create(): LocationEnabledService {
        return if (buildVersionProvider.isPOrAbove()) {
            locationEnabledServicePOrAbove
        } else {
            locationEnabledCheckBeforeP
        }
    }
}

private class LocationEnabledServicePOrAbove(
        private val context: Context
) : LocationEnabledService {
    @RequiresApi(Build.VERSION_CODES.P)
    override fun check(): Boolean {
        return getLocationManager()?.isLocationEnabled ?: false
    }

    private fun getLocationManager() =
            context.getSystemService(Context.LOCATION_SERVICE) as? LocationManager
}

private class LocationEnabledServiceBeforeP(
        private val context: Context
) : LocationEnabledService {
    override fun check(): Boolean {
        return getLocationMode() != Settings.Secure.LOCATION_MODE_OFF
    }

    private fun getLocationMode() =
            Settings.Secure.getInt(context.contentResolver, Settings.Secure.LOCATION_MODE)
}

