// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Flutter
import NIMSDK
import UIKit

public class SwiftNimCorePlugin: NSObject, FlutterPlugin {
  private static var sharedInstance: SwiftNimCorePlugin?
  private static var pendingApnsToken: Data?

  private var channel: MethodCallHandlerImpl?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftNimCorePlugin()
    sharedInstance = instance
    instance.channel = MethodCallHandlerImpl()
    if let channel = instance.channel?.startListening(registrar).getChannel() {
      registrar.addMethodCallDelegate(instance, channel: channel)
    }
    // 注册应用生命周期代理，自动监听 APNs Token
    registrar.addApplicationDelegate(instance)
    instance.processPendingApnsToken()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    channel?.onMethodCall(call, result)
  }

  public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    channel?.stopListening()
    channel = nil
    if SwiftNimCorePlugin.sharedInstance === self {
      SwiftNimCorePlugin.sharedInstance = nil
    }
  }

  // MARK: - APNs Token 自动处理

  /// 监听系统的 APNs Token 回调，自动更新到 NIM SDK
  @objc(application:didRegisterForRemoteNotificationsWithDeviceToken:)
  public func application(_ application: UIApplication,
                          didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // 将 token 传递给 FLTAPNSService 处理
    if let apnsService = channel?.getAPNSService() {
      apnsService.handleDeviceToken(deviceToken)
    } else {
      SwiftNimCorePlugin.pendingApnsToken = deviceToken
    }
  }

  private func processPendingApnsToken() {
    guard let deviceToken = SwiftNimCorePlugin.pendingApnsToken,
          let apnsService = channel?.getAPNSService() else {
      return
    }
    apnsService.handleDeviceToken(deviceToken)
    SwiftNimCorePlugin.pendingApnsToken = nil
  }
}
