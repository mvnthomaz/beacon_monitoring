 # beacon_monitoring

A Flutter plugin for monitoring beacons (iBeacon) on mobile platforms.
Supports iOS and Android.

# Usage

## Installation

Add `beacon_monitoring` as a dependency to your pubspec.yaml:

```yaml
dependencies:
  beacon_monitoring: latest
```

##  iOS Setup

#### 1. Update Info.plist
> For deployment targets earlier than iOS 13, add both NSBluetoothAlwaysUsageDescription and NSBluetoothPeripheralUsageDescription to your app’s Information Property List file. Devices running earlier versions of iOS rely on NSBluetoothPeripheralUsageDescription, while devices running later versions rely on NSBluetoothAlwaysUsageDescription. [Read on Apple Documentation](https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothperipheralusagedescription)

* [NSLocationAlwaysAndWhenInUseUsageDescription](https://developer.apple.com/documentation/bundleresources/information_property_list/nslocationalwaysandwheninuseusagedescription)
* [NSLocationWhenInUseUsageDescription](https://developer.apple.com/documentation/bundleresources/information_property_list/nslocationwheninuseusagedescription)
* [NSBluetoothAlwaysUsageDescription](https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothalwaysusagedescription)
* [NSBluetoothPeripheralUsageDescription](https://developer.apple.com/documentation/bundleresources/information_property_list/nsbluetoothperipheralusagedescription)

Go to information property list `Info.plist` and add keys with human-readable messages (`Info.plist -> Open as -> Source Code`): 

```
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>A message that tells the user why the app is requesting access to the user’s location information at all times.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>A message that tells the user why the app is requesting access to the user’s location information while the app is running in the foreground.</string>
<key>NSBluetoothAlwaysUsageDescription</key>
<string>A message that tells the user why the app needs access to Bluetooth.</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>A message that tells the user why the app is requesting the ability to connect to Bluetooth peripherals.</string>
```
#### 2. Update Capability
1. Go to `Signing & Capabilities`
2. Click `+ Capability`
3. Add `Background Modes` capability
4. Select `Location updates`

#### 3. Update AppDelegate
1. Open `AppDelegate.swift`
2. Import `beacon_monitoring`
2. Add static method to register plugins
```swift
static func registerPlugins(with registry: FlutterPluginRegistry) {
  GeneratedPluginRegistrant.register(with: registry)
}
```
3. Register your AppDelegate as a registry
```swift 
AppDelegate.registerPlugins(with: self)
```
4. Set `BeaconMonitoringPlugin` registrant callback
```swift 
BeaconMonitoringPlugin.setPluginRegistrantCallback { registry in
  AppDelegate.registerPlugins(with: registry)
}
```

So your `AppDelegate.swift` should look like: 
```swift
import UIKit
import Flutter
import beacon_monitoring

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    // MARK: - UIApplicationDelegate Methods
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // ...
        setupAppDelegateRegistry()
        setupBeaconMonitoringPluginCallback()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - Register Plugins
    static func registerPlugins(with registry: FlutterPluginRegistry) {
        GeneratedPluginRegistrant.register(with: registry)
    }

    // MARK: - Private Methods
    private func setupAppDelegateRegistry() {
        AppDelegate.registerPlugins(with: self)
    }
    private func setupBeaconMonitoringPluginCallback() {
        BeaconMonitoringPlugin.setPluginRegistrantCallback { registry in
            AppDelegate.registerPlugins(with: registry)
        }
    }
}
```


## Description
The *beacon_monitoring* plugin can monitor for beacons while the app works in the foreground and in the background mode.

The foreground monitoring we do by intercepting the events produced by a stream as presented below:
```dart
monitoring().listen((event) {
    print("Monitoring stream received: $event");  
});
``` 

For the background monitoring we need to implement the callback method and pass it as an argument to *startBackgroundMonitoring* method:
```dart
void backgroundMonitoringCallback(MonitoringResult result) {
    print('Background monitoring received: $result');
}

startBackgroundMonitoring(backgroundMonitoringCallback);
```

You can find the full code with usage examples for the foreground and background mode in the project example folder.

## How to use
First, register the monitored regions. The region is represented by beacon's identifier and its ids (ids are optional).

Let's assume that we have two iBeacons:
```
iBeacon one: UUID: 400CD186-C779-024B-2F19-89DCF74987E9
iBeacon two: UUID: D66BA202-6589-677F-C735-17E3856F065C
```

Registering these beacons in our plugin can be done as presented below:
```dart
import 'package:beacon_monitoring/beacon_monitoring.dart';

void activateBeacon() async{
    // now we define our region
    Region regionOne = Region(
        identifier: '400CD186-C779-024B-2F19-89DCF74987E9');
    Region regionTwo = Region(
        identifier: 'D66BA202-6589-677F-C735-17E3856F065C');
    
    List<Region> regions = [regionOne, regionTwo];
    
    // register defined regions
    await registerAllRegions(regions);
...
}
```

Now, we have to implement the callback code where we handle all the events from beacons.
Callback event handler must be a static method or a function (cannot be an anonymous function or an object method).
You can learn more about the background processes in Flutter at [background-processes](https://flutter.dev/docs/development/packages-and-plugins/background-processes)
```dart
// beacons are handled by this method
void handleEventCallback(MonitoringResult result) {
    print(result.type);
}
```

Then call `startBackgroundMonitoring` method where we pass our callback:
```dart
import 'package:beacon_monitoring/beacon_monitoring.dart';

startBackgroundMonitoring(handleEventCallback);
```

The whole example code:
```dart
import 'package:beacon_monitoring/beacon_monitoring.dart';

void activateBeacon() async{
    // now we define our region
    Region regionOne = Region(
        identifier: '400CD186-C779-024B-2F19-89DCF74987E9');
    Region regionTwo = Region(
        identifier: 'D66BA202-6589-677F-C735-17E3856F065C');
    
    List<Region> regions = [regionOne, regionTwo];
    
    // register defined regions
    await registerAllRegions(regions);
    
    // here we define a method which handles the beacon's event
    startBackgroundMonitoring(handleEventCallback);
}

// beacons are handled by this method
void handleEventCallback(MonitoringResult result) {
    print('$result');
}
```

From now on, each event related with the registered beacon will be handled by `handleEventCallback` method.
If we come in a range of a beacon, the method `handleEventCallback` will be invoked with data in `MonitoringResult`.

## Additional info

To be able to monitor the beacons both, the Bluetooth and Location need to be turned on and available for the app.

The plugin delivers methods to handle the fact of asking for the required permission.

Bluetooth can be checked using `isBluetoothEnabled()` method and turned on with `openBluetoothSettings()` method for Android and `openApplicationSettings()` for iOS.

Location can be checked using `isLocationEnabled()` method and turned on with `openLocationSettings()` method for Android and `openApplicationSettings()` for iOS.

Similar approach applies to requesting Location permissions. The plugin delivers the functions `checkLocationPermission()` and `requestLocationPermission()`.

Example:
```dart
import 'package:beacon_monitoring/beacon_monitoring.dart';
import 'dart:io' show Platform;

final bluetoothEnabled = await isBluetoothEnabled();
final locationEnabled = await isLocationEnabled();
final locationPermission = await checkLocationPermission();

/// If you are using a process in the background, you should check the permission of `LocationPermission.always` instead of `LocationPermissions.whileInUse`.
if (locationPermission != LocationPermission.whileInUse) {
    await requestLocationPermission();
}

if (Platform.isAndroid) {
    if(!bluetoothEnabled) openBluetoothSettings();
    if(!locationEnabled) openLocationSettings();
} else if (Platform.isIOS) {
    if(!bluetoothEnabled || !locationEnabled) openApplicationSettings();
}
```

## From the Team

At Objectivity we are very busy delivering innovative and modern solutions to our customers. Still, we will do our best to respond to your questions and close the issues, if any. We tried to cover the code with Unit Tests the best we could.

Please, be patient when requesting some help.

We hope you like it.
