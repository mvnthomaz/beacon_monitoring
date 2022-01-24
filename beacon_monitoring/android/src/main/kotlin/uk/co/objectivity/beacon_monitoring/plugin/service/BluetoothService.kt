// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.service

import android.annotation.SuppressLint
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry

private const val REQUEST_CODE_BLUETOOTH = 6607

class BluetoothService(private val context: Context) : PluginRegistry.ActivityResultListener {
    private lateinit var activityPluginBinding: ActivityPluginBinding

    private var bluetoothCallback: ((enabled: Boolean) -> Unit)? = null

    @SuppressLint("MissingPermission")
    fun isEnabled(): Boolean {
        return bluetoothManager()?.adapter?.isEnabled ?: false
    }

    private fun bluetoothManager() =
            context.getSystemService(Context.BLUETOOTH_SERVICE) as? BluetoothManager

    fun openSettings(callback: ((enabled: Boolean) -> Unit)) {
        bluetoothCallback = callback
        val intent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
        activityPluginBinding.activity.startActivityForResult(intent, REQUEST_CODE_BLUETOOTH)
    }

    fun bind(binding: ActivityPluginBinding) {
        activityPluginBinding = binding
        activityPluginBinding.addActivityResultListener(this)
    }

    fun unbind() {
        activityPluginBinding.removeActivityResultListener(this)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        val bluetoothEnabled = requestCode == REQUEST_CODE_BLUETOOTH && resultCode == Activity.RESULT_OK
        bluetoothCallback?.invoke(bluetoothEnabled)
        bluetoothCallback = null
        return true
    }
}
