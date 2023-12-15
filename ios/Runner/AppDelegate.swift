import UIKit
import Flutter
import GoogleMaps  // Add this import
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //TODO: Add local notification
     FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
    GeneratedPluginRegistrant.register(with: registry)}

    GeneratedPluginRegistrant.register(with: self)
     if #available(iOS 10.0, *) {
         UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }

    // TODO: Add your Google Maps API key
    GMSServices.provideAPIKey("AIzaSyDNI_ZWPqvdS6r6gPVO50I4TlYkfkZdXh8")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
