// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum APNSMethod: String {
  case updateApnsToken
  case updateApnsTokenWithCustomKey
  case updatePushKitToken
  case currentSetting
  case updateApnsSetting
  case currentMultiportConfig
  case updateApnsMultiportConfig
  case registerBadgeCount
}

class FLTAPNSService: FLTBaseService, FLTService {
  var badgeCount = -1

  /// 缓存的 APNs Token，用于处理 SDK 初始化前收到的 Token
  private static var pendingApnsToken: Data?

  /// 是否自动更新 APNs Token，默认为 true
  var autoUpdateApnsToken: Bool = true

  func serviceName() -> String {
    ServiceType.APNSService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any], _ resultCallback: ResultCallback) {
    switch method {
    case APNSMethod.updateApnsToken.rawValue:
      updateApnsToken(arguments, resultCallback)
    case APNSMethod.updateApnsTokenWithCustomKey.rawValue:
      updateApnsTokenWithCustomKey(arguments, resultCallback)
    case APNSMethod.updatePushKitToken.rawValue:
      updatePushKitToken(arguments, resultCallback)
    case APNSMethod.currentSetting.rawValue:
      currentSetting(arguments, resultCallback)
    case APNSMethod.updateApnsSetting.rawValue:
      updateApnsSetting(arguments, resultCallback)
    case APNSMethod.currentMultiportConfig.rawValue:
      currentMultiportConfig(arguments, resultCallback)
    case APNSMethod.updateApnsMultiportConfig.rawValue:
      updateApnsMultiportConfig(arguments, resultCallback)
    case APNSMethod.registerBadgeCount.rawValue:
      registerBadgeCount(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  override func onInitialized() {
    registerBadgeCount()
    // 处理缓存的 APNs Token
    processPendingApnsToken()
  }

  /// 处理系统回调的 APNs Token
  /// 由 SwiftNimCorePlugin 在收到 didRegisterForRemoteNotificationsWithDeviceToken 时调用
  func handleDeviceToken(_ deviceToken: Data) {
    guard autoUpdateApnsToken else {
      print("FLTAPNSService: autoUpdateApnsToken is disabled, skip auto update")
      return
    }

    // 检查 SDK 是否已初始化
    if let nimCore = nimCore, nimCore.isInitialized() {
      // SDK 已初始化，直接更新 Token
      print("FLTAPNSService: SDK initialized, updating APNs token directly")
      NIMSDK.shared().updateApnsToken(deviceToken)
    } else {
      // SDK 未初始化，缓存 Token，等待 onInitialized 时处理
      print("FLTAPNSService: SDK not initialized, caching APNs token")
      FLTAPNSService.pendingApnsToken = deviceToken
    }
  }

  /// 处理缓存的 APNs Token
  private func processPendingApnsToken() {
    guard autoUpdateApnsToken else { return }
    guard let token = FLTAPNSService.pendingApnsToken else { return }

    print("FLTAPNSService: Processing pending APNs token")
    NIMSDK.shared().updateApnsToken(token)
    FLTAPNSService.pendingApnsToken = nil
  }

  private func registerBadgeCount() {
    NIMSDK.shared().apnsManager.registerBadgeCountHandler {
      [weak self] () -> UInt in
      if let count = self?.badgeCount,
         count >= 0 {
        return UInt(count)
      } else {
        let isCloud = NIMSDK.shared().v2Option?.enableV2CloudConversation
        if isCloud == true {
          return UInt(NIMSDK.shared().v2ConversationService.getTotalUnreadCount())
        } else {
          return UInt(NIMSDK.shared().v2LocalConversationService.getTotalUnreadCount())
        }
      }
    }
  }

  func updateApnsToken(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let token = arguments["token"] as? FlutterStandardTypedData else {
      parameterError(resultCallback)
      return
    }
    NIMSDK.shared().updateApnsToken(token.data)
    successCallBack(resultCallback, nil)
  }

  func updateApnsTokenWithCustomKey(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let token = arguments["token"] as? FlutterStandardTypedData else {
      parameterError(resultCallback)
      return
    }
    if let customKey = arguments["key"] as? String {
      NIMSDK.shared().updateApnsToken(token.data, customContentKey: customKey)
    } else {
      NIMSDK.shared().updateApnsToken(token.data, customContentKey: nil)
    }
    successCallBack(resultCallback, nil)
  }

  func updatePushKitToken(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let token = arguments["token"] as? FlutterStandardTypedData else {
      parameterError(resultCallback)
      return
    }
    NIMSDK.shared().updatePushKitToken(token.data)
  }

  func currentSetting(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let setting = NIMSDK.shared().apnsManager.currentSetting() {
      successCallBack(resultCallback, setting.toDictionary())
    } else {
      successCallBack(resultCallback, nil)
    }
  }

  func updateApnsSetting(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let settingArguments = arguments["setting"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    let setting = NIMPushNotificationSetting.fromDictionary(settingArguments)
    NIMSDK.shared().apnsManager.updateApnsSetting(setting)
    successCallBack(resultCallback, nil)
  }

  func currentMultiportConfig(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let config = NIMSDK.shared().apnsManager.currentMultiportConfig() {
      successCallBack(resultCallback, config.toDictionary())
    } else {
      successCallBack(resultCallback, nil)
    }
  }

  func updateApnsMultiportConfig(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let configArguments = arguments["config"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    let config = NIMPushNotificationMultiportConfig.fromDictionary(configArguments)
    NIMSDK.shared().apnsManager.updateApnsMultiportConfig(config)
    successCallBack(resultCallback, nil)
  }

  func registerBadgeCount(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let count = arguments["count"] as? Int else {
      parameterError(resultCallback)
      return
    }

    badgeCount = count
    successCallBack(resultCallback, nil)
  }
}

extension NIMPushNotificationSetting {
  func toDictionary() -> [String: Any] {
    var dict: [String: Any] = [:]
    dict[#keyPath(NIMPushNotificationSetting.type)] = type.rawValue
    dict[#keyPath(NIMPushNotificationSetting.noDisturbing)] = noDisturbing
    dict[#keyPath(NIMPushNotificationSetting.noDisturbingStartH)] = noDisturbingStartH
    dict[#keyPath(NIMPushNotificationSetting.noDisturbingStartM)] = noDisturbingStartM
    dict[#keyPath(NIMPushNotificationSetting.noDisturbingEndH)] = noDisturbingEndH
    dict[#keyPath(NIMPushNotificationSetting.noDisturbingEndM)] = noDisturbingEndM
    dict[#keyPath(NIMPushNotificationSetting.profile)] = profile
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> NIMPushNotificationSetting {
    let setting = NIMPushNotificationSetting()
    if let type = dict[#keyPath(type)] as? Int, let type = NIMPushNotificationDisplayType(rawValue: type) {
      setting.type = type
    }
    if let noDisturbing = dict[#keyPath(noDisturbing)] as? Bool {
      setting.noDisturbing = noDisturbing
    }
    if let noDisturbingStartH = dict[#keyPath(noDisturbingStartH)] as? UInt {
      setting.noDisturbingStartH = noDisturbingStartH
    }
    if let noDisturbingStartM = dict[#keyPath(noDisturbingStartM)] as? UInt {
      setting.noDisturbingStartM = noDisturbingStartM
    }
    if let noDisturbingEndH = dict[#keyPath(noDisturbingEndH)] as? UInt {
      setting.noDisturbingEndH = noDisturbingEndH
    }
    if let noDisturbingEndM = dict[#keyPath(noDisturbingEndM)] as? UInt {
      setting.noDisturbingEndM = noDisturbingEndM
    }
    if let profile = dict[#keyPath(profile)] as? Int, let profile = NIMPushNotificationProfile(rawValue: profile) {
      setting.profile = profile
    }
    return setting
  }
}

extension NIMPushNotificationMultiportConfig {
  func toDictionary() -> [String: Any] {
    var dict: [String: Any] = [:]
    dict[#keyPath(NIMPushNotificationMultiportConfig.shouldPushNotificationWhenPCOnline)] = shouldPushNotificationWhenPCOnline
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> NIMPushNotificationMultiportConfig {
    let config = NIMPushNotificationMultiportConfig()
    if let shouldPushNotificationWhenPCOnline = dict[#keyPath(shouldPushNotificationWhenPCOnline)] as? Bool {
      config.shouldPushNotificationWhenPCOnline = shouldPushNotificationWhenPCOnline
    }
    return config
  }
}
