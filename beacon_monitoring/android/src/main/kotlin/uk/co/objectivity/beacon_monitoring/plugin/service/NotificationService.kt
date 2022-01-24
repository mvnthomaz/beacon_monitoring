// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.service

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import uk.co.objectivity.beacon_monitoring.plugin.model.MonitoringResult
import uk.co.objectivity.beacon_monitoring.plugin.model.RangingResult
import kotlin.math.round

private const val NOTIFICATION_GROUP_KEY = "uk.co.objectivity.beacon_monitoring.NOTIFICATION_GROUP"
private const val FOREGROUND_NOTIFICATION_CHANNEL_ID = "Beacon Monitoring Service"
private const val DEBUG_NOTIFICATION_CHANNEL_ID = "Beacon Service Debug"
private const val MONITORING_NOTIFICATION_ID = 701
private const val RANGING_NOTIFICATION_ID = 702
const val FOREGROUND_NOTIFICATION_ID = 660

class NotificationService(private val context: Context) {
    private var rangingTimestamp = System.currentTimeMillis()
    private val rangingPeriod = 3000

    fun showMonitoringNotification(result: MonitoringResult) {
        NotificationManagerCompat.from(context).apply {
            notify(MONITORING_NOTIFICATION_ID, getMonitoringNotification(result))
        }
    }

    fun showRangingNotification(result: RangingResult) {
        if (shouldShowNotification(result)) {
            NotificationManagerCompat.from(context).apply {
                notify(RANGING_NOTIFICATION_ID, getRangingNotification(result))
            }
        }
    }

    fun hideRangingNotification() {
        NotificationManagerCompat.from(context).apply { cancel(RANGING_NOTIFICATION_ID) }
    }

    fun getForegroundNotification(): Notification {
        createNotificationChannel(
            FOREGROUND_NOTIFICATION_CHANNEL_ID,
            NotificationManagerCompat.IMPORTANCE_MIN
        )
        return NotificationCompat.Builder(context, FOREGROUND_NOTIFICATION_CHANNEL_ID)
            .setSmallIcon(getIcon())
            .setContentTitle(getBackgroundMonitoringTitle())
            .setContentIntent(getStartAppIntent())
            .build()
    }

    private fun getMonitoringNotification(result: MonitoringResult): Notification {
        createNotificationChannel(
            DEBUG_NOTIFICATION_CHANNEL_ID,
            NotificationManagerCompat.IMPORTANCE_LOW
        )
        return NotificationCompat.Builder(context, DEBUG_NOTIFICATION_CHANNEL_ID)
            .setSmallIcon(getIcon())
            .setContentTitle("Beacon ${result.type.readableName}")
            .setContentText(result.region.identifier)
            .setGroup(NOTIFICATION_GROUP_KEY)
            .build()
    }

    private fun getRangingNotification(result: RangingResult): Notification {
        createNotificationChannel(
            DEBUG_NOTIFICATION_CHANNEL_ID,
            NotificationManagerCompat.IMPORTANCE_LOW
        )
        return NotificationCompat.Builder(context, DEBUG_NOTIFICATION_CHANNEL_ID)
            .setSmallIcon(getIcon())
            .setContentTitle("Ranging in region ${result.region.identifier}")
            .setStyle(NotificationCompat.InboxStyle().also {
                result.beacons.forEach { beacon ->
                    it.addLine("${beacon.ids[0]} - ${round(beacon.distance * 100) / 100} m")
                }
            })
            .build()
    }

    private fun createNotificationChannel(channelId: String, importance: Int) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(channelId, channelId, importance)
            val manager = context.getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }
    }

    private fun getIcon(): Int {
        val res = context.resources
        val packageName = context.packageName
        val notifyIconId = res.getIdentifier("ic_notification", "drawable", packageName)
        val appIconId = res.getIdentifier("ic_launcher", "mipmap", packageName)
        return if (notifyIconId != 0) notifyIconId else appIconId
    }
    
    private fun getBackgroundMonitoringTitle(): String {
        val res = context.resources
        val packageName = context.packageName
        val titleStringId = res.getIdentifier("beacons_monitoring", "string", packageName)
        return if (titleStringId != 0) res.getString(titleStringId) else "Beacons monitoring"
    }

    private fun getStartAppIntent(): PendingIntent? {
        val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        return PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
    }

    private fun shouldShowNotification(result: RangingResult): Boolean {
        val timestamp = System.currentTimeMillis()
        return if (timestamp - rangingTimestamp > rangingPeriod && !result.beacons.isNullOrEmpty()) {
            rangingTimestamp = timestamp
            true
        } else {
            false
        }
    }
}