// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.connection

enum class EventChannelName(val channelName: String) {
    MONITORING_CHANNEL_NAME(Config.Channel.MONITORING_CHANNEL_NAME),
    RANGING_CHANNEL_NAME(Config.Channel.RANGING_CHANNEL_NAME)
}