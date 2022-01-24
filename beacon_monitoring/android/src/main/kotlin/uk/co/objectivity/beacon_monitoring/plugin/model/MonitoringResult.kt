// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.model

import android.os.Parcelable
import com.squareup.moshi.FromJson
import com.squareup.moshi.JsonClass
import com.squareup.moshi.Moshi
import com.squareup.moshi.ToJson
import kotlinx.android.parcel.Parcelize
import org.altbeacon.beacon.MonitorNotifier

fun MonitoringResult.toJson(): String = Moshi.Builder()
        .add(MonitoringEvent.Adapter())
        .add(MonitoringState.Adapter())
        .build()
        .adapter(MonitoringResult::class.java)
        .toJson(this)

enum class MonitoringEvent(val readableName: String) {
    didEnterRegion("Enter Region"),
    didExitRegion("Exit Region"),
    didDetermineState("Determine State");

    class Adapter {
        @FromJson
        fun fromJson(json: String): MonitoringEvent = valueOf(json)

        @ToJson
        fun toJson(value: MonitoringEvent): String = value.toString()
    }
}

enum class MonitoringState(private val value: Int) {
    inside(MonitorNotifier.INSIDE),
    outside(MonitorNotifier.OUTSIDE);

    companion object {
        fun fromInt(value: Int) = values().first { it.value == value }
    }

    class Adapter {
        @FromJson
        fun fromJson(json: String): MonitoringState = valueOf(json)

        @ToJson
        fun toJson(value: MonitoringState): String = value.toString()
    }
}

@Parcelize
@JsonClass(generateAdapter = true)
data class MonitoringResult(
        val region: RegionModel,
        val type: MonitoringEvent,
        val state: MonitoringState? = null
) : Parcelable