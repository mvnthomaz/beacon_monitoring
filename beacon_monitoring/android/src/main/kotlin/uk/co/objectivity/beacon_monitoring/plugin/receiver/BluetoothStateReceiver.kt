// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.receiver

import android.bluetooth.BluetoothAdapter
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import uk.co.objectivity.beacon_monitoring.plugin.connection.DependencyContainer

class BluetoothStateReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (BluetoothAdapter.ACTION_STATE_CHANGED == intent.action) {
            val state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR)
            toggleBeaconMonitoring(context, BluetoothAdapter.STATE_ON == state)
        }
    }

    private fun toggleBeaconMonitoring(context: Context, enable: Boolean) {
        val dependencyContainer = DependencyContainer.getInstance(context)
        val monitoringService = dependencyContainer.monitoringService
        val beaconClient = dependencyContainer.beaconClient

        if (enable && monitoringService.allRequirementsMet()) {
            beaconClient.enableMonitoring()
        } else {
            beaconClient.disableMonitoring()
        }
    }
}
