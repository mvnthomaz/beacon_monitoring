// Copyright (c) 2020 Objectivity. All rights reserved.
// Use of this source code is governed by The MIT License (MIT) that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:beacon_monitoring_platform_interface/beacon_monitoring_platform_interface.dart';
import 'package:beacon_monitoring_platform_interface/src/config.dart';
import 'package:beacon_monitoring_platform_interface/src/method_channel_beacon_monitoring.dart';
import 'package:beacon_monitoring_platform_interface/src/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _defaultResponses = <String, dynamic>{
  Config.setDebug: null,
  Config.isBluetoothEnabled: true,
  Config.openBluetoothSettings: null,
  Config.checkLocationPermission: 'whileInUse',
  Config.requestLocationPermission: null,
  Config.isLocationEnabled: true,
  Config.openLocationSettings: null,
  Config.openApplicationSettings: null,
  Config.registerRegion: null,
  Config.registerAllRegions: null,
  Config.removeRegion: null,
  Config.removeAllRegions: null,
  Config.isMonitoringStarted: true,
  Config.startBackgroundMonitoring: null,
  Config.stopBackgroundMonitoring: null,
};

final _regions = [
  Region(
    identifier: 'region_id_1',
    ids: [
      'beacon_id_1_1',
      'beacon_id_1_2',
      'beacon_id_1_3',
    ],
  ),
  Region(
    identifier: 'region_id_2',
    ids: [
      'beacon_id_2_1',
      'beacon_id_2_2',
      'beacon_id_2_3',
    ],
  ),
  Region(
    identifier: 'region_id_3',
    ids: [
      'beacon_id_3_1',
      'beacon_id_3_2',
      'beacon_id_3_3',
    ],
  ),
];

void _monitoringCallback(MonitoringResult result) {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$BeaconMonitoringPlatform', () {
    test('$MethodChannelBeaconMonitoring is the default instance', () {
      expect(
        BeaconMonitoringPlatform.instance,
        isInstanceOf<MethodChannelBeaconMonitoring>(),
      );
    });
  });

  group('$MethodChannelBeaconMonitoring', () {
    const MethodChannel channel = MethodChannel(Config.methodsChannelName);
    final List<MethodCall> log = <MethodCall>[];
    final Map<String, dynamic> responses =
        Map<String, dynamic>.from(_defaultResponses);

    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      final dynamic response = responses[methodCall.method];
      if (response != null && response is PlatformException) {
        return Future<dynamic>.error(response);
      }
      return Future<dynamic>.value(response);
    });

    final MethodChannelBeaconMonitoring beaconMonitoring =
        MethodChannelBeaconMonitoring();

    tearDown(() {
      log.clear();
    });

    [true, false].forEach((value) {
      test('${Config.setDebug} -> $value', () async {
        await beaconMonitoring.setDebug(value);
        expect(
          log,
          <Matcher>[isMethodCall(Config.setDebug, arguments: value)],
        );
      });
    });

    [true, false].forEach((value) {
      test('${Config.isBluetoothEnabled} -> $value', () async {
        responses[Config.isBluetoothEnabled] = value;
        final result = await beaconMonitoring.isBluetoothEnabled;
        expect(
          log,
          <Matcher>[isMethodCall(Config.isBluetoothEnabled, arguments: null)],
        );
        expect(
          result,
          value,
        );
      });
    });

    test(Config.openBluetoothSettings, () async {
      await beaconMonitoring.openBluetoothSettings();
      expect(
        log,
        <Matcher>[isMethodCall(Config.openBluetoothSettings, arguments: null)],
      );
    });

    [
      LocationPermission.denied,
      LocationPermission.always,
      LocationPermission.whileInUse
    ].forEach((value) {
      test('${Config.checkLocationPermission} -> ${describeEnum(value)}',
          () async {
        responses[Config.checkLocationPermission] = describeEnum(value);
        var result = await beaconMonitoring.checkLocationPermission();
        expect(
          log,
          <Matcher>[
            isMethodCall(Config.checkLocationPermission, arguments: null),
          ],
        );
        expect(
          result,
          value,
        );
      });
    });

    test(Config.requestLocationPermission, () async {
      await beaconMonitoring.requestLocationPermission();
      expect(
        log,
        <Matcher>[
          isMethodCall(Config.requestLocationPermission, arguments: null),
        ],
      );
    });

    [true, false].forEach((value) {
      test('${Config.isLocationEnabled} -> $value', () async {
        responses[Config.isLocationEnabled] = value;
        final result = await beaconMonitoring.isLocationEnabled;
        expect(
          log,
          <Matcher>[isMethodCall(Config.isLocationEnabled, arguments: null)],
        );
        expect(
          result,
          value,
        );
      });
    });

    test(Config.openLocationSettings, () async {
      await beaconMonitoring.openLocationSettings();
      expect(
        log,
        <Matcher>[isMethodCall(Config.openLocationSettings, arguments: null)],
      );
    });

    test(Config.openApplicationSettings, () async {
      await beaconMonitoring.openApplicationSettings();
      expect(
        log,
        <Matcher>[
          isMethodCall(Config.openApplicationSettings, arguments: null)
        ],
      );
    });

    test(Config.registerRegion, () async {
      final region = _regions[0];
      await beaconMonitoring.registerRegion(region);
      expect(
        log,
        <Matcher>[
          isMethodCall(Config.registerRegion, arguments: region.toString())
        ],
      );
    });

    test(Config.registerAllRegions, () async {
      await beaconMonitoring.registerAllRegions(_regions);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            Config.registerAllRegions,
            arguments: _regions.toString().replaceAll(' ', ''),
          ),
        ],
      );
    });

    test(Config.removeRegion, () async {
      final region = _regions[0];
      await beaconMonitoring.removeRegion(region);
      expect(
        log,
        <Matcher>[
          isMethodCall(Config.removeRegion, arguments: region.toString())
        ],
      );
    });

    test(Config.removeAllRegions, () async {
      await beaconMonitoring.removeAllRegions(_regions);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            Config.removeAllRegions,
            arguments: _regions.toString().replaceAll(' ', ''),
          ),
        ],
      );
    });

    [true, false].forEach((value) {
      test('${Config.isMonitoringStarted} -> $value', () async {
        responses[Config.isMonitoringStarted] = value;
        final result = await beaconMonitoring.isMonitoringStarted;
        expect(
          log,
          <Matcher>[isMethodCall(Config.isMonitoringStarted, arguments: null)],
        );
        expect(
          result,
          value,
        );
      });
    });

    test(Config.startBackgroundMonitoring, () async {
      await beaconMonitoring.startBackgroundMonitoring(_monitoringCallback);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            Config.startBackgroundMonitoring,
            arguments: <String, dynamic>{
              Config.backgroundCallbackId: PluginUtilities.getCallbackHandle(
                      backgroundCallbackDispatcher)!
                  .toRawHandle(),
              Config.monitoringCallbackId:
                  PluginUtilities.getCallbackHandle(_monitoringCallback)!
                      .toRawHandle(),
            },
          )
        ],
      );
    });

    [
      [
        Config.bluetoothDisabledExceptionCode,
        const BluetoothDisabledException()
      ],
      [Config.locationDisabledExceptionCode, const LocationDisabledException()],
      [
        Config.locationPermissionDeniedExceptionCode,
        const LocationPermissionDeniedException()
      ],
    ].forEach((value) {
      test(
        '${Config.startBackgroundMonitoring} Exception -> throws ${value[0]}',
        () async {
          responses[Config.startBackgroundMonitoring] =
              PlatformException(code: value[0] as String);

          _expectException(
            beaconMonitoring.startBackgroundMonitoring(_monitoringCallback),
            value[1],
          );
        },
      );
    });

    test(Config.stopBackgroundMonitoring, () async {
      await beaconMonitoring.stopBackgroundMonitoring();
      expect(
        log,
        <Matcher>[
          isMethodCall(
            Config.stopBackgroundMonitoring,
            arguments: null,
          ),
        ],
      );
    });

    test('monitoring stream', () async {
      final event = MonitoringResult(
        region: _regions[0],
        type: MonitoringEvent.didEnterRegion,
      );

      _initializeMockedEventChannel(
        Config.monitoringEventChannelName,
        event.toString(),
      );

      final result = await beaconMonitoring.monitoring().first;
      expect(
        result.toJson(),
        event.toJson(),
      );
    });

    test('ranging stream', () async {
      final event = RangingResult(
        region: _regions[0],
        beacons: [
          Beacon(ids: ['beacon_id_2_1'], rssi: 10, distance: 1.2)
        ],
      );

      _initializeMockedEventChannel(
        Config.rangingEventChannelName,
        event.toString(),
      );

      final result = await beaconMonitoring.ranging().first;
      expect(
        result.toJson(),
        event.toJson(),
      );
    });
  });
}

void _expectException(Future<void> future, dynamic exception) async {
  try {
    await future;
    fail("exception not thrown");
  } catch (e) {
    expect(e, exception);
  }
}

void _initializeMockedEventChannel(
  String channelName,
  String data,
) {
  const standardMethod = StandardMethodCodec();

  ServicesBinding.instance!.defaultBinaryMessenger.setMockMessageHandler(
    channelName,
    (ByteData? message) async {
      final MethodCall methodCall = standardMethod.decodeMethodCall(message);
      if (methodCall.method == 'listen') {
        _emitEvent(channelName, standardMethod.encodeSuccessEnvelope(data));
        _emitEvent(channelName, null);
        return standardMethod.encodeSuccessEnvelope(null);
      } else if (methodCall.method == 'cancel') {
        return standardMethod.encodeSuccessEnvelope(null);
      } else {
        fail('Expected listen or cancel');
      }
    },
  );
}

void _emitEvent(String channelName, ByteData? event) {
  ServicesBinding.instance!.defaultBinaryMessenger.handlePlatformMessage(
    channelName,
    event,
    (ByteData? reply) {},
  );
}
