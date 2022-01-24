// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.model

import android.os.Parcelable
import com.squareup.moshi.JsonClass
import kotlinx.android.parcel.Parcelize
import org.altbeacon.beacon.Identifier
import org.altbeacon.beacon.Region

fun Region.toModel() = RegionModel(
    uniqueId,
    listOfNotNull(id1?.toString(), id2?.toString(), id3?.toString()),
    bluetoothAddress
)

@Parcelize
@JsonClass(generateAdapter = true)
data class RegionModel(
    val identifier: String,
    val ids: List<String?>? = null,
    val bluetoothAddress: String? = null
) : Parcelable {
    fun toAltBeaconRegion() = Region(identifier, ids?.mapNotNull { Identifier.parse(it) }
        ?: emptyList(), bluetoothAddress)
}
