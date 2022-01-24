// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

library beacon_monitoring_platform_interface;

import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'src/method_channel_beacon_monitoring.dart';
import 'src/model.dart';

export 'src/model.dart';

abstract class BeaconMonitoringPlatform extends PlatformInterface {
  BeaconMonitoringPlatform() : super(token: _token);

  /// The default instance of [BeaconMonitoringPlatform] to use.
  ///
  /// Defaults to [MethodChannelBeaconMonitoring].
  static BeaconMonitoringPlatform _instance = MethodChannelBeaconMonitoring();

  static final Object _token = Object();

  /// The default instance of [BeaconMonitoringPlatform] to use.
  ///
  /// Defaults to [MethodChannelBeaconMonitoring].
  static BeaconMonitoringPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [BeaconMonitoringPlatform] when they register themselves.
  static set instance(BeaconMonitoringPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Turn off and on debug mode.
  Future<void> setDebug(bool debug) => throw UnimplementedError();

  /// The activity of the bluetooth should be checked before calling the [startBackgroundMonitoring] method.
  /// iOS: This method asks for bluetooth permission if it is required.
  /// Returns `true` if bluetooth is enabled.
  Future<bool> get isBluetoothEnabled => throw UnimplementedError();

  /// Works only on Android.
  /// Opens bluetooth settings to enable it.
  Future<void> openBluetoothSettings() => throw UnimplementedError();

  /// Location service permissions should be checked before starting the monitoring.
  /// The required permissions for background use are [always],
  /// and for foreground use are [whileInUse].
  Future<LocationPermission> checkLocationPermission() =>
      throw UnimplementedError();

  /// Ask for location permissions. What permissions should be granted by the user should be displayed earlier.
  Future<void> requestLocationPermission() => throw UnimplementedError();

  /// The activity of the location service should be checked before calling the [startBackgroundMonitoring] method.
  /// Returns `true` if bluetooth is enabled.
  Future<bool> get isLocationEnabled => throw UnimplementedError();

  /// Works only on Android.
  /// Open location service settings to enable it.
  Future<void> openLocationSettings() => throw UnimplementedError();

  /// Works only on iOS.
  /// Open application settings to enable location service and bluetooth.
  Future<void> openApplicationSettings() => throw UnimplementedError();

  /// Registration of region for listening.
  Future<void> registerRegion(Region region) => throw UnimplementedError();

  /// Registration of regions for listening.
  Future<void> registerAllRegions(List<Region> regions) =>
      throw UnimplementedError();

  /// Removing the region from listening.
  Future<void> removeRegion(Region region) => throw UnimplementedError();

  /// Removing the regions from listening.
  Future<void> removeAllRegions(List<Region> regions) =>
      throw UnimplementedError();

  /// Returns `true` if monitoring is started.
  Future<bool> get isMonitoringStarted => throw UnimplementedError();

  /// Terminates background beacon monitoring service.

  /// Starts the background beacon monitoring service and calls the [monitoringCallback] function on change of beacon state.
  /// You can learn more about the background processes in Flutter at https://flutter.dev/docs/development/packages-and-plugins/background-processes
  ///
  /// [BluetoothDisabledException] is thrown when bluetooth is disabled.
  /// [LocationDisabledException] is thrown when location is disabled.
  /// [LocationPermissionDeniedException] is thrown when we don't have accurate permissions to location.
  ///
  /// Param [monitoringCallback] must be a static method or a function (cannot be an anonymous function or an object method).
  Future<void> startBackgroundMonitoring(
    void Function(MonitoringResult result) monitoringCallback,
  ) =>
      throw UnimplementedError();
  Future<void> stopBackgroundMonitoring() => throw UnimplementedError();

  /// Stream of monitoring results.
  /// Does not work in the background.
  /// Starts monitoring while listening to the stream, if monitoring is not started.
  /// Suspends call of the `monitoringCallback` function from [startBackgroundMonitoring] after listening to the stream.
  /// Cancel the stream subscription to terminate beacon monitoring.
  Stream<MonitoringResult> monitoring() => throw UnimplementedError();

  /// Stream of ranging results.
  /// Does not work in the background.
  /// Starts monitoring while listening to the stream, if monitoring is not started.
  /// Cancel the stream subscription to terminate beacon monitoring.
  Stream<RangingResult> ranging() => throw UnimplementedError();
}
