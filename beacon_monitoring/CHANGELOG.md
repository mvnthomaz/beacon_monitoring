## 1.0.0

* Initial release.

## 1.0.1

* iOS - Remove `registrar` property from `MonitoringBackgroundHandler` instance init
* iOS - Make `locationManager` property in `LocationService` not `lazy` to setup `locationManager.delegate` at service init
* iOS - Add `preferencesStorage` property to `MonitoringBackgroundHandler` instance init
* iOS - Add automatic setup of `beaconService` delegate to `MonitoringBackgroundHandler` instance init to automatically setup listener

## 2.0.0

* iOS - bugfix, Plugin does not range beacons on iOS
* Null safety migration
