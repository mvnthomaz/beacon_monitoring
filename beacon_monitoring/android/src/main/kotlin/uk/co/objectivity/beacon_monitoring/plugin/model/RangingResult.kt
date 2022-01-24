// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.model

import com.squareup.moshi.JsonClass
import com.squareup.moshi.Moshi

fun RangingResult.toJson(): String = Moshi.Builder().build().adapter(RangingResult::class.java).toJson(this)

@JsonClass(generateAdapter = true)
data class RangingResult(val region: RegionModel, val beacons: List<BeaconModel>)