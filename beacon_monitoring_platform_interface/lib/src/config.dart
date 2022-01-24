// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

class Config {
  static const String pluginId = 'uk.co.objectivity/beacon_monitoring';

  static const String methodsChannelName = '$pluginId/methods';

  static const String setDebug = 'setDebug';
  static const String isBluetoothEnabled = 'isBluetoothEnabled';
  static const String openBluetoothSettings = 'openBluetoothSettings';
  static const String checkLocationPermission = 'checkLocationPermission';
  static const String requestLocationPermission = 'requestLocationPermission';
  static const String isLocationEnabled = 'isLocationEnabled';
  static const String openLocationSettings = 'openLocationSettings';
  static const String openApplicationSettings = 'openApplicationSettings';
  static const String registerRegion = 'registerRegion';
  static const String registerAllRegions = 'registerAllRegions';
  static const String removeRegion = 'removeRegion';
  static const String removeAllRegions = 'removeAllRegions';
  static const String isMonitoringStarted = 'isMonitoringStarted';
  static const String startBackgroundMonitoring = 'startBackgroundMonitoring';
  static const String stopBackgroundMonitoring = 'stopBackgroundMonitoring';

  static const String bluetoothDisabledExceptionCode = 'bluetoothDisabled';
  static const String locationDisabledExceptionCode = 'locationDisabled';
  static const String locationPermissionDeniedExceptionCode =
      'locationPermissionDenied';

  static const String backgroundMethodsChannelName = '$pluginId/background';
  static const String backgroundInitialized = 'backgroundInitialized';
  static const String backgroundCallbackId = 'backgroundCallbackId';
  static const String monitoringCallbackId = 'monitoringCallbackId';

  static const String monitoringEventChannelName = '$pluginId/monitoring';
  static const String rangingEventChannelName = '$pluginId/ranging';
}
