import 'dart:async';
import 'dart:io' show Platform;
import 'dart:ui';

import 'package:beacon_monitoring/beacon_monitoring.dart';
import 'package:beacon_monitoring_example/notification.dart';
import 'package:beacon_monitoring_example/notification_types.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _showNotification(MonitoringResult result) async {
  final position = result.state == MonitoringState.inside ? "ARE IN" : "LEFT";
  await NotificationService()
      .showNotification(result.hashCode, "You $position the beacon region", "", NotificationType.BATTERY);
}

void backgroundMonitoringCallback(MonitoringResult result) {
  _showNotification(result);
  print('Background monitoring received: $result');
}

class _MyAppState extends State<MyApp> {
  var _bluetoothEnabled = 'UNKNOWN';
  var _locationEnabled = 'UNKNOWN';
  var _locationPermission = 'UNKNOWN';
  var _debug = false;

  StreamSubscription? _monitoringStreamSubscription;
  StreamSubscription? _rangingStreamSubscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var locationPermission = await checkLocationPermission();
    var bluetoothEnabled = await isBluetoothEnabled();
    var locationEnabled = await isLocationEnabled();

    setDebug(_debug);

    if (locationPermission != LocationPermission.always) {
      await requestLocationPermission();
    }

    if (Platform.isAndroid) {
      if (!bluetoothEnabled) openBluetoothSettings();
      if (!locationEnabled) openLocationSettings();
    } else if (Platform.isIOS) {
      if (!bluetoothEnabled || !locationEnabled) openApplicationSettings();
    }

    locationPermission = await checkLocationPermission();
    bluetoothEnabled = await isBluetoothEnabled();
    locationEnabled = await isLocationEnabled();

    setState(() {
      _locationPermission = describeEnum(locationPermission);
      _bluetoothEnabled = bluetoothEnabled ? 'ENABLED' : 'DISABLED';
      _locationEnabled = locationEnabled ? 'ENABLED' : 'DISABLED';
    });

    if (!mounted) return;
  }

  void _turnDebugOn() {
    setDebug(true);
    setState(() {
      _debug = true;
    });
  }

  void _turnDebugOff() {
    setDebug(false);
    setState(() {
      _debug = false;
    });
  }

  void _startBackgroundMonitoring() {
    startBackgroundMonitoring(backgroundMonitoringCallback).catchError(
      (e) => debugPrint(
        'startBackgroundMonitoring catchError: $e',
      ),
    );
  }

  void _stopBackgroundMonitoring() {
    stopBackgroundMonitoring();
  }

  bool _isListeningMonitoringStream() {
    return _monitoringStreamSubscription != null;
  }

  void _startListeningMonitoringStream() {
    if (!_isListeningMonitoringStream()) {
      setState(() {
        _monitoringStreamSubscription = monitoring().listen(
          (event) {
            print("Monitoring stream received: $event");
          },
          onError: (e) => debugPrint(
            '_startListeningMonitoringStream catchError: $e',
          ),
        );
      });
    }
  }

  void _stopListeningMonitoringStream() {
    if (_isListeningMonitoringStream()) {
      _monitoringStreamSubscription?.cancel();
      setState(() {
        _monitoringStreamSubscription = null;
      });
    }
  }

  bool _isListeningRangingStream() {
    return _rangingStreamSubscription != null;
  }

  void _startListeningRangingStream() {
    if (!_isListeningRangingStream()) {
      setState(() {
        _rangingStreamSubscription = ranging().listen(
          (event) {
            print("Ranging stream received: $event");
          },
          onError: (e) => debugPrint(
            '_startListeningRangingStream catchError: $e',
          ),
        );
      });
    }
  }

  void _stopListeningRangingStream() {
    if (_isListeningRangingStream()) {
      _rangingStreamSubscription?.cancel();
      setState(() {
        _rangingStreamSubscription = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    NotificationService().requestIosPermission();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ListView(
            children: [
              Text('Bluetooth enabled: $_bluetoothEnabled'),
              Text('Location enabled: $_locationEnabled'),
              Text('Location permission: $_locationPermission'),
              _createDebugButton(),
              _createBackgroundMonitoringButtons(),
              _createListeningMonitoringStreamButton(),
              _createGenericButton(
                'REGISTER ALL REGIONS',
                _registerVirtualBeaconsRegions,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createDebugButton() {
    if (_debug) {
      return ElevatedButton(
        onPressed: () => _turnDebugOff(),
        child: Text("Turn debug off"),
      );
    } else {
      return ElevatedButton(
        onPressed: () => _turnDebugOn(),
        child: Text("Turn debug on"),
      );
    }
  }

  Widget _createBackgroundMonitoringButtons() {
    return Row(
      children: [
        Flexible(
          child: ElevatedButton(
            onPressed: () => _startBackgroundMonitoring(),
            child: Text(
              "Start background monitoring",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Flexible(
          child: ElevatedButton(
            onPressed: () => _stopBackgroundMonitoring(),
            child: Text(
              "Stop background monitoring",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _createListeningMonitoringStreamButton() {
    if (!_isListeningMonitoringStream()) {
      return ElevatedButton(
        onPressed: () => _startListeningMonitoringStream(),
        child: Text("Start listening on monitoring stream"),
      );
    } else {
      return ElevatedButton(
        onPressed: () => _stopListeningMonitoringStream(),
        child: Text("Stop listening on monitoring stream"),
      );
    }
  }

  Widget _createListeningRangingStreamButton() {
    if (!_isListeningRangingStream()) {
      return ElevatedButton(
        onPressed: () => _startListeningRangingStream(),
        child: Text("Start listening on ranging stream"),
      );
    } else {
      return ElevatedButton(
        onPressed: () => _stopListeningRangingStream(),
        child: Text("Stop listening on ranging stream"),
      );
    }
  }

  Widget _createGenericButton(String text, Function onPressed) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(text),
    );
  }

  void _registerVirtualBeaconsRegions() async {
    Region regionOne = Region(identifier: '2fc03570-8ae7-407f-a375-3d2d74d8fc0f');
    // Region regionTwo =  RegionIBeacon(
    //   identifier: '2fc03570-8ae7-407f-a375-3d2d74d8fc0f',
    //   proximityUUID: '2fc03570-8ae7-407f-a375-3d2d74d8fc0f',
    // );

    List<Region> regions = [regionOne, /*regionTwo*/];

    await registerAllRegions(regions);
  }

  // https://community.estimote.com/hc/en-us/articles/200908836-How-to-turn-my-iPhone-into-a-Virtual-Beacon-
  RegionIBeacon _virtualBeacon() => RegionIBeacon(
        identifier: "Virtual Beacon",
        proximityUUID: '2fc03570-8ae7-407f-a375-3d2d74d8fc0f',
      );
}
