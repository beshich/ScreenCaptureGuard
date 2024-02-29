# ScreenCaptureGuard (Guard on recording/capture screen)

## Description:

> The class in which we check when the user makes a recording or screenshot.

## Usage:

     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ScreenCaputreGuard.shared.startPreventing()
        return true
    }

> ### You can call anywhere in your class to suit your needs

We prohibit the capture and recording of our screen: 
`ScreenCaputreGuard.shared.startPreventing()`

Allow the capture and recording of our screen:
 `ScreenCaputreGuard.shared.stopPreventing()`
