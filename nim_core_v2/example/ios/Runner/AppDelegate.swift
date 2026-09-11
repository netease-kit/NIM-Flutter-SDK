// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import UIKit
import Flutter

@main
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
      
    // 注册远程推送通知
    // NIM SDK 会自动监听 APNs Token 回调并更新到服务器，无需手动处理
    application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    // 注意：不再需要手动处理 APNs Token
    // NIM SDK Plugin 会自动监听 didRegisterForRemoteNotificationsWithDeviceToken 回调
    // 并将 token 更新到云信服务器
    
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
