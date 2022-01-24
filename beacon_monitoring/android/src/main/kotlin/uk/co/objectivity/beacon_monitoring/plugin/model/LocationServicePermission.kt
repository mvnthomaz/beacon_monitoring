// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.model

enum class LocationPermission(val rawName: String) {
    DENIED("denied"),
    ALWAYS("always"),
    WHILE_IN_USE("whileInUse");
}
