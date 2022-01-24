// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.service

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.provider.Settings
import androidx.core.app.ActivityCompat
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import uk.co.objectivity.beacon_monitoring.plugin.model.LocationPermission

private const val REQUEST_CODE_PERMISSION = 7250

class LocationService(
        private val buildVersionProvider: BuildVersionProvider,
        private val permissionService: PermissionService,
        private val locationEnabledService: LocationEnabledService
) : PluginRegistry.RequestPermissionsResultListener {
    private lateinit var activityPluginBinding: ActivityPluginBinding

    private var permissionCallback: ((hasPermission: Boolean) -> Unit)? = null

    fun bind(binding: ActivityPluginBinding) {
        activityPluginBinding = binding
        activityPluginBinding.addRequestPermissionsResultListener(this)
    }

    fun unbind() {
        activityPluginBinding.removeRequestPermissionsResultListener(this)
    }

    fun checkPermission(): LocationPermission {
        val fineLocationGranted = isFineLocationGranted()
        val backgroundLocationGranted = isBackgroundLocationGranted()

        return if (fineLocationGranted && backgroundLocationGranted) {
            LocationPermission.ALWAYS
        } else if (fineLocationGranted) {
            LocationPermission.WHILE_IN_USE
        } else {
            LocationPermission.DENIED
        }
    }

    fun requestPermission(callback: ((granted: Boolean) -> Unit)) {
        if (buildVersionProvider.isQOrAbove()) {
            requestPermission(
                    callback,
                    Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.ACCESS_BACKGROUND_LOCATION
            )
        } else {
            requestPermission(callback, Manifest.permission.ACCESS_FINE_LOCATION)
        }
    }

    fun isEnabled(): Boolean {
        return locationEnabledService.check()
    }

    fun openSettings() {
        val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        activityPluginBinding.activity.startActivity(intent)
    }

    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<out String>?,
            grantResults: IntArray?
    ): Boolean {
        if (REQUEST_CODE_PERMISSION == requestCode
                && permissions?.isNotEmpty() == true
                && grantResults?.isNotEmpty() == true
        ) {
            for (i in permissions.indices) {
                if (shouldShowRationale(permissions[i]) || grantResults[i] != PackageManager.PERMISSION_GRANTED) {
                    permissionCallback?.invoke(false)
                    return true
                }
            }
            permissionCallback?.invoke(true)
            return true
        }
        permissionCallback?.invoke(false)
        return true
    }

    private fun requestPermission(
            callback: ((hasPermission: Boolean) -> Unit),
            vararg permissions: String
    ) {
        permissionCallback = callback
        permissionService.requestPermission(
                activityPluginBinding.activity,
                permissions,
                REQUEST_CODE_PERMISSION
        )
    }

    private fun shouldShowRationale(permission: String): Boolean {
        return ActivityCompat.shouldShowRequestPermissionRationale(
                activityPluginBinding.activity,
                permission
        )
    }

    private fun isFineLocationGranted() = permissionService.isGranted(Manifest.permission.ACCESS_FINE_LOCATION)

    private fun isBackgroundLocationGranted() =
            if (buildVersionProvider.isQOrAbove()) {
                permissionService.isGranted(Manifest.permission.ACCESS_BACKGROUND_LOCATION)
            } else {
                true
            }
}
