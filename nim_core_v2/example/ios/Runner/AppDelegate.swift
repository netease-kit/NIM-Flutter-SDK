// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
    FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    print("document path : ",documentPath)
    GeneratedPluginRegistrant.register(with: self)
    writeTestFile()
      
      UNUserNotificationCenter.current().delegate = self
      UNUserNotificationCenter.current().requestAuthorization(options: [UNAuthorizationOptions.badge,  UNAuthorizationOptions.sound, UNAuthorizationOptions.alert]) { granted, error in
          if (granted) {
              print("granted permission")
          }
      }
      
    application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let flutterData = FlutterStandardTypedData.init(bytes: deviceToken)
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: "com.netease.NIM.demo/settings",
                                                  binaryMessenger: controller.binaryMessenger)
        methodChannel.invokeMethod("updateAPNsToken", arguments: flutterData)
    }
    
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("register APNS fail: " , error)
    }
    
    func writeTestFile() {
        let fileNames = ["test.mp4","test.jpg","test.mp3"]
        fileNames.forEach { name in
            didWriteTestFle(name)
        }
    }
    
    func didWriteTestFle(_ name: String){
        
        if  let from = Bundle.main.path(forResource: name, ofType: nil){
            let to = (documentPath as NSString).appendingPathComponent(name)
            let filemanager = FileManager.default
            if filemanager.fileExists(atPath: to) == false {
                do {
                    try filemanager.copyItem(atPath: from, toPath: to)
                } catch let error {
                    print("write test file error : ", error)
                }
            }
        }
    }
}
