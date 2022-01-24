// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.service

import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

class PermissionService(private val context: Context) {
    fun isGranted(permission: String) = ContextCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED

    fun requestPermission(
            activity: Activity,
            permissions: Array<out String>,
            requestCode: Int
    ) {
        ActivityCompat.requestPermissions(
                activity,
                permissions,
                requestCode
        )
    }
}
