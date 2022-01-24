// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import 'package:beacon_monitoring_platform_interface/beacon_monitoring_platform_interface.dart';

export 'package:beacon_monitoring_platform_interface/beacon_monitoring_platform_interface.dart';

/// Turn off and on debug mode.
Future<void> setDebug(bool debug) =>
    BeaconMonitoringPlatform.instance.setDebug(debug);

/// The activity of the bluetooth  should be checked before calling the [startBackgroundMonitoring] method.
/// iOS: This method asks for bluetooth permission if it is required.
/// Returns `true` if bluetooth is enabled.
Future<bool> isBluetoothEnabled() =>
    BeaconMonitoringPlatform.instance.isBluetoothEnabled;

/// Works only on Android.
/// Opens bluetooth settings to enable it.
Future<void> openBluetoothSettings() =>
    BeaconMonitoringPlatform.instance.openBluetoothSettings();

/// Location service permissions should be checked before starting the monitoring.
/// The required permissions for background use are [always],
/// and for foreground use are [whileInUse].
Future<LocationPermission> checkLocationPermission() =>
    BeaconMonitoringPlatform.instance.checkLocationPermission();

/// Ask for location permissions. What permissions should be granted by the user should be displayed earlier.
Future<void> requestLocationPermission() =>
    BeaconMonitoringPlatform.instance.requestLocationPermission();

/// The activity of the location service should be checked before calling the [startBackgroundMonitoring] method.
/// Returns `true` if bluetooth is enabled.
Future<bool> isLocationEnabled() =>
    BeaconMonitoringPlatform.instance.isLocationEnabled;

/// Works only on Android.
/// Open location service settings to enable it.
Future<void> openLocationSettings() =>
    BeaconMonitoringPlatform.instance.openLocationSettings();

/// Works only on iOS.
/// Open application settings to enable location service and bluetooth.
Future<void> openApplicationSettings() =>
    BeaconMonitoringPlatform.instance.openApplicationSettings();

/// Registration of region for listening.
Future<void> registerRegion(Region region) =>
    BeaconMonitoringPlatform.instance.registerRegion(region);

/// Registration of regions for listening.
Future<void> registerAllRegions(List<Region> regions) =>
    BeaconMonitoringPlatform.instance.registerAllRegions(regions);

/// Removing the region from listening.
Future<void> removeRegion(Region region) =>
    BeaconMonitoringPlatform.instance.removeRegion(region);

/// Removing the regions from listening.
Future<void> removeAllRegions(List<Region> regions) =>
    BeaconMonitoringPlatform.instance.removeAllRegions(regions);

/// Returns `true` if monitoring is started.
Future<bool> isMonitoringStarted() =>
    BeaconMonitoringPlatform.instance.isMonitoringStarted;

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
    BeaconMonitoringPlatform.instance
        .startBackgroundMonitoring(monitoringCallback);

/// Terminates background beacon monitoring service.
Future<void> stopBackgroundMonitoring() =>
    BeaconMonitoringPlatform.instance.stopBackgroundMonitoring();

/// Stream of monitoring results.
/// Does not work in the background.
/// Starts monitoring while listening to the stream, if monitoring is not started.
/// Suspends call of the `monitoringCallback` function from [startBackgroundMonitoring] after listening to the stream.
/// Cancel the stream subscription to terminate beacon monitoring.
Stream<MonitoringResult> monitoring() =>
    BeaconMonitoringPlatform.instance.monitoring();

/// Stream of ranging results.
/// Does not work in the background.
/// Starts monitoring while listening to the stream, if monitoring is not started.
/// Cancel the stream subscription to terminate beacon monitoring.
Stream<RangingResult> ranging() => BeaconMonitoringPlatform.instance.ranging();
