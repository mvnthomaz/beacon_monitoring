// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.model

import com.squareup.moshi.JsonClass
import org.altbeacon.beacon.Beacon

fun Beacon.toModel() = BeaconModel(identifiers.map { it.toString() }, rssi, distance, txPower, bluetoothAddress)

@JsonClass(generateAdapter = true)
data class BeaconModel(
        val ids: List<String>,
        val rssi: Int,
        val distance: Double,
        val txPower: Int,
        val bluetoothAddress: String?)