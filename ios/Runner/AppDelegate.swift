import Flutter
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import NaverThirdPartyLogin
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let iosChannel = FlutterMethodChannel(name: "doctor.flutter.dev",
                                                  binaryMessenger: controller.binaryMessenger)
        iosChannel.setMethodCallHandler {
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            if call.method == "talk" {
//                let args = call.arguments as? Dictionary<String, Any>
//                let uid = args!["uid"] as? String
//                self?.showChannelTalk(_uid: uid ?? "1234")
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
//         if let appKey = Bundle.main.object(forInfoDictionaryKey: "66bed5a0bb50d14d57e723a72ec24ce8") as? String {
//                             KakaoSDKCommon.initSDK(appKey: appKey)
//                     }
        KakaoSDK.initSDK(appKey: "${66bed5a0bb50d14d57e723a72ec24ce8}")
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
//         if url.absoluteString.hasPrefix("kakao") { //if AuthApi.isKakaoTalkLoginUrl(url) {
//             return AuthController.handleOpenUrl(url: url)
//         }
//         if (AuthApi.isKakaoTalkLoginUrl(url)) {
//             return AuthController.handleOpenUrl(url: url)
//         }
//         return NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
        var result = false

        if url.absoluteString.hasPrefix("kakao"){
            result = super.application(app, open: url, options: options)
                }
        if !result {
            result = NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
            
        }
        return result

    }

}
