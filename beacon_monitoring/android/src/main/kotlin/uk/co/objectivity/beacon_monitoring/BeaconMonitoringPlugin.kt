// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.Registrar
import uk.co.objectivity.beacon_monitoring.plugin.connection.Config
import uk.co.objectivity.beacon_monitoring.plugin.connection.DependencyContainer
import uk.co.objectivity.beacon_monitoring.plugin.connection.EventChannelName

class BeaconMonitoringPlugin : FlutterPlugin, ActivityAware {
    private lateinit var methodChannel: MethodChannel
    private lateinit var dependencyContainer: DependencyContainer
    private val eventChannels = mutableListOf<EventChannel>()

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            BeaconMonitoringPlugin().init(registrar.context(), registrar.messenger())
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        init(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)
    }

    private fun init(context: Context, binaryMessenger: BinaryMessenger) {
        dependencyContainer = DependencyContainer.getInstance(context)

        methodChannel = MethodChannel(binaryMessenger, Config.Channel.METHODS_CHANNEL_NAME)
        methodChannel.setMethodCallHandler(dependencyContainer.methodCallHandler)

        EventChannelName.values().forEach {
            eventChannels.add(
                    EventChannel(binaryMessenger, it.channelName).apply {
                        setStreamHandler(getStreamHandler(it))
                    })
        }
    }

    private fun getStreamHandler(eventChannelName: EventChannelName) =
            when (eventChannelName) {
                EventChannelName.MONITORING_CHANNEL_NAME ->
                    dependencyContainer.monitoringStreamHandler
                EventChannelName.RANGING_CHANNEL_NAME ->
                    dependencyContainer.rangingStreamHandler
            }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        dependencyContainer.monitoringService.monitoringNotifier = null
        dependencyContainer.monitoringService.rangingNotifier = null

        eventChannels.forEach { it.setStreamHandler(null) }
        eventChannels.clear()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        dependencyContainer.bluetoothService.bind(binding)
        dependencyContainer.locationService.bind(binding)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        dependencyContainer.bluetoothService.bind(binding)
        dependencyContainer.locationService.bind(binding)
    }

    override fun onDetachedFromActivity() {
        dependencyContainer.bluetoothService.unbind()
        dependencyContainer.locationService.unbind()
    }

    override fun onDetachedFromActivityForConfigChanges() {
        dependencyContainer.bluetoothService.unbind()
        dependencyContainer.locationService.unbind()
    }
}
