# beacon_monitoring_platform_interface

A common platform interface for the beacon_monitoring plugin.

# Usage

To implement a new platform-specific implementation of beacon_monitoring, 
extend BeaconMonitoringPlatform with an implementation that performs the platform-specific behavior, 
and when you register your plugin, 
set the default BeaconMonitoringPlatform by calling BeaconMonitoringPlatform.instance = MyBeaconMonitoring().
