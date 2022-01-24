// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.service

import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import org.hamcrest.CoreMatchers.`is`
import org.junit.Assert.assertThat
import org.junit.Test
import org.mockito.Mockito.*

private const val REQUEST_CODE_BLUETOOTH = 6607

class BluetoothServiceTest {
    private val context = mock(Context::class.java)

    private val bluetoothService = BluetoothService(context)

    @Test
    fun shouldCheckIfBluetoothIsEnabled() {
        val bluetoothManager = mock(BluetoothManager::class.java)
        val bluetoothAdapter = mock(BluetoothAdapter::class.java)
        `when`(context.getSystemService(Context.BLUETOOTH_SERVICE)).thenReturn(bluetoothManager)
        `when`(bluetoothManager.adapter).thenReturn(bluetoothAdapter)
        `when`(bluetoothAdapter.isEnabled).thenReturn(true)

        val result = bluetoothService.isEnabled()

        assertThat(result, `is`(true))
    }

    @Test
    fun shouldBindServiceToActivity() {
        val activityPluginBinding = mock(ActivityPluginBinding::class.java)

        bluetoothService.bind(activityPluginBinding)

        verify(activityPluginBinding).addActivityResultListener(bluetoothService)
    }

    @Test
    fun shouldUnbindServiceFromActivity() {
        val activityPluginBinding = mock(ActivityPluginBinding::class.java)
        bluetoothService.bind(activityPluginBinding)

        bluetoothService.unbind()

        verify(activityPluginBinding).removeActivityResultListener(bluetoothService)
    }

    @Test
    fun shouldOpenBluetoothSettings() {
        val activityPluginBinding = mock(ActivityPluginBinding::class.java)
        val activity = mock(Activity::class.java)
        bluetoothService.bind(activityPluginBinding)
        `when`(activityPluginBinding.activity).thenReturn(activity)
        `when`(activity.startActivityForResult(any(), eq(REQUEST_CODE_BLUETOOTH))).then {
            bluetoothService.onActivityResult(REQUEST_CODE_BLUETOOTH, Activity.RESULT_OK, null)
        }

        var callbackCalled = false
        bluetoothService.openSettings { callbackCalled = true }

        assertThat(callbackCalled, `is`(true))
    }
}
