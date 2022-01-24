// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

library method_channel_beacon_monitoring;

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../beacon_monitoring_platform_interface.dart';
import 'config.dart';
import 'model.dart';

const MethodChannel _methodChannel = MethodChannel(Config.methodsChannelName);

const EventChannel _monitoringEventChannel =
    EventChannel(Config.monitoringEventChannelName);

const EventChannel _rangingEventChannel =
    EventChannel(Config.rangingEventChannelName);

void backgroundCallbackDispatcher() {
  const MethodChannel _backgroundMethodChannel =
      MethodChannel(Config.backgroundMethodsChannelName);
  WidgetsFlutterBinding.ensureInitialized();

  _backgroundMethodChannel.setMethodCallHandler((MethodCall call) async {
    try {
      final json = jsonDecode(call.arguments);
      final result = BackgroundCallbackResult.fromJson(json);
      final handle = CallbackHandle.fromRawHandle(result.monitoringCallbackId);
      final callback = PluginUtilities.getCallbackFromHandle(handle);
      callback!(result.monitoringResult);
    } catch (e) {
      debugPrint(e.toString());
    }
  });

  _backgroundMethodChannel.invokeMethod(Config.backgroundInitialized);
}

class MethodChannelBeaconMonitoring extends BeaconMonitoringPlatform {
  Stream<MonitoringResult>? _monitoringStream;
  Stream<RangingResult>? _rangingStream;

  @override
  Future<void> setDebug(bool debug) {
    return _methodChannel.invokeMethod<void>(
      Config.setDebug,
      debug,
    );
  }

  @override
  Future<bool> get isBluetoothEnabled {
    return _methodChannel
        .invokeMethod<bool>(
          Config.isBluetoothEnabled,
        )
        .then((value) => value == true);
  }

  @override
  Future<void> openBluetoothSettings() {
    return _methodChannel.invokeMethod<bool>(
      Config.openBluetoothSettings,
    );
  }

  @override
  Future<LocationPermission> checkLocationPermission() {
    return _methodChannel
        .invokeMethod(
          Config.checkLocationPermission,
        )
        .then((value) => LocationPermissionExtension.parse(value));
  }

  @override
  Future<void> requestLocationPermission() {
    return _methodChannel.invokeMethod(
      Config.requestLocationPermission,
    );
  }

  @override
  Future<bool> get isLocationEnabled {
    return _methodChannel
        .invokeMethod<bool>(
          Config.isLocationEnabled,
        )
        .then((value) => value == true);
  }

  @override
  Future<void> openLocationSettings() {
    return _methodChannel.invokeMethod<bool>(
      Config.openLocationSettings,
    );
  }

  @override
  Future<void> openApplicationSettings() {
    return _methodChannel.invokeMethod<bool>(
      Config.openApplicationSettings,
    );
  }

  @override
  Future<void> registerRegion(Region region) {
    return _methodChannel.invokeMethod<void>(
      Config.registerRegion,
      jsonEncode(region),
    );
  }

  @override
  Future<void> registerAllRegions(List<Region> regions) {
    return _methodChannel.invokeMethod<void>(
      Config.registerAllRegions,
      jsonEncode(regions),
    );
  }

  @override
  Future<void> removeRegion(Region region) {
    return _methodChannel.invokeMethod<void>(
      Config.removeRegion,
      jsonEncode(region),
    );
  }

  @override
  Future<void> removeAllRegions(List<Region> regions) {
    return _methodChannel.invokeMethod<void>(
      Config.removeAllRegions,
      jsonEncode(regions),
    );
  }

  @override
  Future<bool> get isMonitoringStarted {
    return _methodChannel
        .invokeMethod<bool>(
          Config.isMonitoringStarted,
        )
        .then((value) => value == true);
  }

  @override
  Future<void> startBackgroundMonitoring(
    void Function(MonitoringResult result) monitoringCallback,
  ) async {
    final args = {
      Config.backgroundCallbackId: _getCallbackId(
        backgroundCallbackDispatcher,
      ),
      Config.monitoringCallbackId: _getCallbackId(monitoringCallback),
    };

    try {
      await _methodChannel.invokeMethod<void>(
        Config.startBackgroundMonitoring,
        args,
      );
    } on PlatformException catch (e) {
      if (PluginException.supports(e.code)) {
        throw PluginException.fromCode(e.code);
      } else {
        rethrow;
      }
    }
    return;
  }

  int _getCallbackId(dynamic callback) {
    return PluginUtilities.getCallbackHandle(callback)!.toRawHandle();
  }

  @override
  Future<void> stopBackgroundMonitoring() {
    return _methodChannel.invokeMethod<void>(
      Config.stopBackgroundMonitoring,
    );
  }

  @override
  Stream<MonitoringResult> monitoring() {
    if (_monitoringStream == null) {
      _monitoringStream = _monitoringEventChannel
          .receiveBroadcastStream()
          .map((event) => MonitoringResult.fromJson(jsonDecode(event)));
    }

    return _monitoringStream!;
  }

  @override
  Stream<RangingResult> ranging() {
    if (_rangingStream == null) {
      _rangingStream = _rangingEventChannel
          .receiveBroadcastStream()
          .map((event) => RangingResult.fromJson(jsonDecode(event)));
    }

    return _rangingStream!;
  }
}
