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
  }

  private func registerBadgeCount() {
    NIMSDK.shared().apnsManager.registerBadgeCountHandler {
      [weak self] () -> UInt in
      if let count = self?.badgeCount,
         count >= 0 {
        return UInt(count)
      } else {
        return UInt(NIMSDK.shared().conversationManager.allUnreadCount())
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
    if let customKey = arguments["customKey"] as? String {
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
