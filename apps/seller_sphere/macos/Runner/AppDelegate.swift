import Cocoa
import FlutterMacOS
import GoogleMaps

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDOKFS0j8ElSk2DfsL_SiP8Pt3bPWV_c8I")
    
    super.applicationDidFinishLaunching(notification)
    return true
  }
}
