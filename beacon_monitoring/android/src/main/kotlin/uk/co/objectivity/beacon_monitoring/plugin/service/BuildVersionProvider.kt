// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.service

import android.os.Build

class BuildVersionProvider {
    fun isQOrAbove(): Boolean = Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q
    fun isPOrAbove(): Boolean = Build.VERSION.SDK_INT >= Build.VERSION_CODES.P
}