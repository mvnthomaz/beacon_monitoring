// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.service

import android.content.Context
import android.content.Intent
import android.os.Handler
import androidx.core.app.JobIntentService
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor.DartCallback
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterCallbackInformation
import io.flutter.view.FlutterMain
import uk.co.objectivity.beacon_monitoring.plugin.connection.Config
import uk.co.objectivity.beacon_monitoring.plugin.connection.DependencyContainer
import uk.co.objectivity.beacon_monitoring.plugin.connection.MethodName
import uk.co.objectivity.beacon_monitoring.plugin.model.BackgroundCallbackResult
import uk.co.objectivity.beacon_monitoring.plugin.model.MonitoringResult
import uk.co.objectivity.beacon_monitoring.plugin.model.toJson
import java.util.*
import java.util.concurrent.atomic.AtomicBoolean


class BackgroundConnectionService : JobIntentService(), MethodChannel.MethodCallHandler {
    private lateinit var context: Context
    private lateinit var backgroundChannel: MethodChannel
    private lateinit var localStorageService: LocalStorageService
    private val queue = ArrayDeque<BackgroundCallbackResult>()

    companion object {
        private val JOB_ID = UUID.randomUUID().mostSignificantBits.toInt()
        private val isServiceStarted = AtomicBoolean(false)
        private var backgroundFlutterEngine: FlutterEngine? = null

        fun enqueueWork(context: Context, monitoringResult: MonitoringResult) {
            val intent = Intent().apply {
                putExtra(Config.ArgsKey.MONITORING_RESULT, monitoringResult)
            }
            enqueueWork(context, BackgroundConnectionService::class.java, JOB_ID, intent)
        }
    }

    override fun onCreate() {
        super.onCreate()
        initService(this)
    }

    override fun onDestroy() {
        isServiceStarted.set(false)
        super.onDestroy()
    }

    override fun onHandleWork(intent: Intent) {
        val monitoringResult =
                intent.getParcelableExtra<MonitoringResult>(Config.ArgsKey.MONITORING_RESULT)
                        ?: throw IllegalArgumentException()
        val result = BackgroundCallbackResult(
                localStorageService.monitoringCallbackId,
                monitoringResult
        )
        synchronized(isServiceStarted) {
            if (isServiceStarted.get()) {
                Handler(context.mainLooper).post { backgroundChannel.invokeMethod("", result.toJson()) }
            } else {
                queue.add(result)
            }
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (MethodName.fromRawActionName(call.method) == MethodName.BACKGROUND_INITIALIZED) {
            synchronized(isServiceStarted) {
                while (queue.isNotEmpty()) backgroundChannel.invokeMethod("", queue.remove().toJson())
                isServiceStarted.set(true)
            }
        }
    }

    private fun initService(context: Context) {
        synchronized(isServiceStarted) {
            this.context = context
            this.localStorageService = DependencyContainer.getInstance(context).localStorageService

            if (!isServiceStarted.get() && localStorageService.isBackgroundMonitoringEnabled) {
                backgroundFlutterEngine = FlutterEngine(context).also { engine ->
                    FlutterMain.ensureInitializationComplete(context, null)

                    val callbackHandle = localStorageService.backgroundCallbackId
                    val callbackInfo = FlutterCallbackInformation.lookupCallbackInformation(callbackHandle)
                    val dartBundlePath = FlutterMain.findAppBundlePath()

                    val dartCallback = DartCallback(context.assets, dartBundlePath, callbackInfo)
                    engine.dartExecutor.executeDartCallback(dartCallback)
                }
            }
            backgroundFlutterEngine?.let { engine ->
                backgroundChannel = MethodChannel(engine.dartExecutor, Config.Channel.BACKGROUND_CHANNEL_NAME)
                backgroundChannel.setMethodCallHandler(this)
            }
        }
    }
}