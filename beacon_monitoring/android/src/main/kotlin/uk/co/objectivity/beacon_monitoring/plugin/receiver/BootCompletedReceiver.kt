// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import uk.co.objectivity.beacon_monitoring.plugin.connection.DependencyContainer

class BootCompletedReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val monitoringService = DependencyContainer.getInstance(context).monitoringService
        val localStorageService = DependencyContainer.getInstance(context).localStorageService

        if (Intent.ACTION_BOOT_COMPLETED == intent.action
                && monitoringService.allRequirementsMet()
                && localStorageService.isBackgroundMonitoringEnabled) {
            DependencyContainer.getInstance(context).beaconClient.enableMonitoring()
        }
    }
}
