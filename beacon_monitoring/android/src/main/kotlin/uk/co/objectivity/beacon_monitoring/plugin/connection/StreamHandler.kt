// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.connection

import io.flutter.plugin.common.EventChannel
import uk.co.objectivity.beacon_monitoring.plugin.model.toJson
import uk.co.objectivity.beacon_monitoring.plugin.service.MonitoringService

abstract class RequirementsAwareStreamHandler(private val monitoringService: MonitoringService) :
        EventChannel.StreamHandler {
    abstract fun onRequirementsMet(arguments: Any?, events: EventChannel.EventSink?)

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        monitoringService.allRequirementsMet(
                onSuccess = { onRequirementsMet(arguments, events) },
                onError = { events?.error(it.value, null, null) }
        )
    }
}

class MonitoringStreamHandler(
        private val monitoringService: MonitoringService
) : RequirementsAwareStreamHandler(monitoringService) {
    override fun onRequirementsMet(arguments: Any?, events: EventChannel.EventSink?) {
        monitoringService.monitoringNotifier = { events?.success(it.toJson()) }
    }

    override fun onCancel(arguments: Any?) {
        monitoringService.monitoringNotifier = null
    }
}

class RangingStreamHandler(
        private val monitoringService: MonitoringService
) : RequirementsAwareStreamHandler(monitoringService) {
    override fun onRequirementsMet(arguments: Any?, events: EventChannel.EventSink?) {
        monitoringService.rangingNotifier = { events?.success(it.toJson()) }
    }

    override fun onCancel(arguments: Any?) {
        monitoringService.rangingNotifier = null
    }
}
