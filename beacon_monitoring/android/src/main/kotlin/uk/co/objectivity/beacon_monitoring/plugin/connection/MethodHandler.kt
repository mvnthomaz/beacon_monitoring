// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

package uk.co.objectivity.beacon_monitoring.plugin.connection

import com.squareup.moshi.Moshi
import com.squareup.moshi.Types
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import org.json.JSONTokener
import uk.co.objectivity.beacon_monitoring.plugin.model.RegionModel
import uk.co.objectivity.beacon_monitoring.plugin.service.BluetoothService
import uk.co.objectivity.beacon_monitoring.plugin.service.LocationService
import uk.co.objectivity.beacon_monitoring.plugin.service.MonitoringService
import java.io.IOException
import java.lang.reflect.Type

fun MethodChannel.Result.success() = success(null)
fun MethodChannel.Result.error(code: String) = error(code, null, null)
fun MethodChannel.Result.error(code: String, message: String) = error(code, message, null)

interface MethodHandler {
    fun handle(call: MethodCall, result: MethodChannel.Result)
}

abstract class ValueMethodHandler : MethodHandler {
    inline fun <reified T : Any?> getValue(json: String?) =
            json?.let { Moshi.Builder().build().adapter(T::class.java).fromJson(it) }

    inline fun <reified T : Any?> getValue(json: String?, type: Type) =
            json?.let { Moshi.Builder().build().adapter<T>(type).fromJson(it) }
}

object NotImplementedHandler : MethodHandler {
    override fun handle(call: MethodCall, result: MethodChannel.Result) {
        result.notImplemented()
    }
}

class SetDebugHandler(private val monitoringService: MonitoringService) : RegionHandler() {
    override fun handle(call: MethodCall, result: MethodChannel.Result) {
        monitoringService.setDebug(call.arguments<Boolean>())
    }
}

class IsBluetoothEnabledHandler(private val bluetoothService: BluetoothService) : MethodHandler {
    override fun handle(call: MethodCall, result: MethodChannel.Result) {
        result.success(bluetoothService.isEnabled())
    }
}

class OpenBluetoothSettingsHandler(private val bluetoothService: BluetoothService) : MethodHandler {
    override fun handle(call: MethodCall, result: MethodChannel.Result) {
        bluetoothService.openSettings { result.success(it) }
    }
}

class CheckLocationPermissionHandler(private val locationService: LocationService) : MethodHandler {
    override fun handle(call: MethodCall, result: MethodChannel.Result) {
        result.success(locationService.checkPermission().rawName)
    }
}

class RequestLocationPermissionHandler(
        private val locationService: LocationService
) : MethodHandler {
    override fun handle(call: MethodCall, result: MethodChannel.Result) {
        locationService.requestPermission { granted: Boolean ->
            if (granted) {
                result.success()
            } else {
                result.error("location_permission_not_granted", "The location permissions have not been granted")
            }
        }
    }
}

class IsLocationEnabledHandler(
        private val locationService: LocationService
) : MethodHandler {
    override fun handle(call: MethodCall, result: MethodChannel.Result) {
        result.success(locationService.isEnabled())
    }
}

class OpenLocationSettingsHandler(
        private val locationService: LocationService
) : MethodHandler {
    override fun handle(call: MethodCall, result: MethodChannel.Result) {
        locationService.openSettings()
        result.success()
    }
}

abstract class RegionHandler : ValueMethodHandler() {
    protected fun handleRegion(
            call: MethodCall,
            result: MethodChannel.Result,
            action: (List<RegionModel>) -> Unit
    ) {
        try {
            val json = call.arguments as? String
            action(parseJson(json))
            parseJson(json)
        } catch (exception: IOException) {
            result.error("invalid_argument_format", exception.message ?: "")
        }

        result.success()
    }

    private fun parseJson(json: String?): List<RegionModel> {
        val regions = when (JSONTokener(json).nextValue()) {
            is JSONArray -> {
                val type = Types.newParameterizedType(List::class.java, RegionModel::class.java)
                getValue<List<RegionModel>>(json, type)
            }
            is JSONObject -> getValue<RegionModel>(json)?.let { listOf(it) }
            else -> throw IOException("Error during parsing args: $json")
        }
        return regions ?: emptyList()
    }
}

class RegisterRegionHandler(private val monitoringService: MonitoringService) : RegionHandler() {
    override fun handle(call: MethodCall, result: MethodChannel.Result) {
        handleRegion(call, result) { monitoringService.addRegions(it) }
    }
}

class RemoveRegionHandler(private val monitoringService: MonitoringService) : RegionHandler() {
    override fun handle(call: MethodCall, result: MethodChannel.Result) {
        handleRegion(call, result) { monitoringService.removeRegion(it) }
    }
}

class IsMonitoringStartedHandler(private val monitoringService: MonitoringService) : MethodHandler {
    override fun handle(call: MethodCall, result: MethodChannel.Result) {
        result.success(monitoringService.isMonitoringEnabled())
    }
}

class StartBackgroundMonitoringHandler(private val monitoringService: MonitoringService) : MethodHandler {
    override fun handle(call: MethodCall, result: MethodChannel.Result) {
        val backgroundCallbackId = call.argument<Long>(Config.ArgsKey.BACKGROUND_CALLBACK_ID)
                ?: throw IllegalArgumentException("Missing background callback key argument")
        val monitoringCallbackId = call.argument<Long>(Config.ArgsKey.MONITORING_CALLBACK_ID)
                ?: throw IllegalArgumentException("Missing monitoring callback key argument")

        try {
            monitoringService.startBackgroundMonitoring(backgroundCallbackId, monitoringCallbackId)
        } catch (pluginException: PluginException) {
            result.error(pluginException.code.value)
        }

        result.success()
    }
}

class StopBackgroundMonitoringHandler(private val monitoringService: MonitoringService) : MethodHandler {
    override fun handle(call: MethodCall, result: MethodChannel.Result) {
        monitoringService.stopBackgroundMonitoring()
        result.success()
    }
}
