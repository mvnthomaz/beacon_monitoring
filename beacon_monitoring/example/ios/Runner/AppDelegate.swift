import UIKit
import Flutter
import beacon_monitoring

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    // MARK: - UIApplicationDelegate Methods
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // ...
        setupNotificationService()
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
    private func setupNotificationService() {
        UNUserNotificationCenter.current().delegate = self
    }

    // MARK: - UNUserNotificationCenterDelegate Methods
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        super.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
        completionHandler([.alert, .sound]) // shows banner even if app is in foreground
    }
}
