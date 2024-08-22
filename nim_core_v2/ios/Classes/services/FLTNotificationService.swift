// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

class FLTNotificationService: FLTBaseService, FLTService, V2NIMNotificationListener {
  func onReceive(_ customNotifications: [V2NIMCustomNotification]) {
    notifyEvent(serviceName(), "onReceiveCustomNotifications", ["customNotifications": customNotifications.map { $0.toDictionary() }])
  }

  func onReceive(_ boradcastNotifications: [V2NIMBroadcastNotification]) {
    notifyEvent(serviceName(), "onReceiveBroadcastNotifications", ["broadcastNotifications": boradcastNotifications.map { $0.toDictionary() }])
  }

  func sendCustomNotification(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String, let content = arguments["content"] as? String, let paramsArguments = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let params = V2NIMSendCustomNotificationParams.fromDcitonary(paramsArguments)

    weak var weakSelf = self
    NIMSDK.shared().v2NIMNotificationService.sendCustomNotification(conversationId, content: content, params: params) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any], _ resultCallback: ResultCallback) {
    switch method {
    case "sendCustomNotification":
      sendCustomNotification(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  override func onInitialized() {
    NIMSDK.shared().v2NIMNotificationService.addNoticationListener(self)
  }

  deinit {
    NIMSDK.shared().v2NIMNotificationService.remove(self)
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func serviceName() -> String {
    "NotificationService"
  }
}

extension V2NIMNotificationRouteConfig {
  func toDictionary() -> [String: Any] {
    var dic = [String: Any]()
    dic[#keyPath(routeEnabled)] = routeEnabled
    dic[#keyPath(routeEnvironment)] = routeEnvironment
    return dic
  }

  static func fromDictionary(_ dictionary: [String: Any]) -> V2NIMNotificationRouteConfig {
    let config = V2NIMNotificationRouteConfig()
    if let routeEnabled = dictionary[#keyPath(V2NIMNotificationRouteConfig.routeEnabled)] as? Bool {
      config.routeEnabled = routeEnabled
    }
    if let routeEnvironment = dictionary[#keyPath(V2NIMNotificationRouteConfig.routeEnvironment)] as? String {
      config.routeEnvironment = routeEnvironment
    }
    return config
  }
}

extension V2NIMNotificationAntispamConfig {
  func toDictionary() -> [String: Any] {
    var dic = [String: Any]()
    dic[#keyPath(antispamEnabled)] = antispamEnabled
    dic[#keyPath(antispamCustomNotification)] = antispamCustomNotification
    return dic
  }

  static func fromDictionary(_ dictionary: [String: Any]) -> V2NIMNotificationAntispamConfig {
    let config = V2NIMNotificationAntispamConfig()
    if let antispamEnabled = dictionary[#keyPath(V2NIMNotificationAntispamConfig.antispamEnabled)] as? Bool {
      config.antispamEnabled = antispamEnabled
    }
    if let antispamCustomNotification = dictionary[#keyPath(V2NIMNotificationAntispamConfig.antispamCustomNotification)] as? String {
      config.antispamCustomNotification = antispamCustomNotification
    }
    return config
  }
}

extension V2NIMNotificationPushConfig {
  func toDictionary() -> [String: Any] {
    var dic = [String: Any]()
    dic[#keyPath(pushEnabled)] = pushEnabled
    dic[#keyPath(pushNickEnabled)] = pushNickEnabled
    dic[#keyPath(pushContent)] = pushContent
    dic[#keyPath(pushPayload)] = pushPayload
    dic[#keyPath(forcePush)] = forcePush
    dic[#keyPath(forcePushContent)] = forcePushContent
    dic[#keyPath(forcePushAccountIds)] = forcePushAccountIds
    return dic
  }

  static func fromDictionary(_ dictionary: [String: Any]) -> V2NIMNotificationPushConfig {
    let config = V2NIMNotificationPushConfig()
    if let pushEnabled = dictionary[#keyPath(V2NIMNotificationPushConfig.pushEnabled)] as? Bool {
      config.pushEnabled = pushEnabled
    }
    if let pushNickEnabled = dictionary[#keyPath(V2NIMNotificationPushConfig.pushNickEnabled)] as? Bool {
      config.pushNickEnabled = pushNickEnabled
    }
    if let pushContent = dictionary[#keyPath(V2NIMNotificationPushConfig.pushContent)] as? String {
      config.pushContent = pushContent
    }
    if let pushPayload = dictionary[#keyPath(V2NIMNotificationPushConfig.pushPayload)] as? String {
      config.pushPayload = pushPayload
    }
    if let forcePush = dictionary[#keyPath(V2NIMNotificationPushConfig.forcePush)] as? Bool {
      config.forcePush = forcePush
    }
    if let forcePushContent = dictionary[#keyPath(V2NIMNotificationPushConfig.forcePushContent)] as? String {
      config.forcePushContent = forcePushContent
    }
    if let forcePushAccountIds = dictionary[#keyPath(V2NIMNotificationPushConfig.forcePushAccountIds)] as? [String] {
      config.forcePushAccountIds = forcePushAccountIds
    }
    return config
  }
}

extension V2NIMNotificationConfig {
  func toDictionary() -> [String: Any] {
    var dic = [String: Any]()
    dic[#keyPath(offlineEnabled)] = offlineEnabled
    dic[#keyPath(unreadEnabled)] = unreadEnabled
    return dic
  }

  static func fromDictionary(_ dictionary: [String: Any]) -> V2NIMNotificationConfig {
    let config = V2NIMNotificationConfig()
    if let offlineEnabled = dictionary[#keyPath(V2NIMNotificationConfig.offlineEnabled)] as? Bool {
      config.offlineEnabled = offlineEnabled
    }
    if let unreadEnabled = dictionary[#keyPath(V2NIMNotificationConfig.unreadEnabled)] as? Bool {
      config.unreadEnabled = unreadEnabled
    }
    return config
  }
}

extension V2NIMSendCustomNotificationParams {
  func toDictionary() -> [String: Any] {
    var dic = [String: Any]()
    dic[#keyPath(notificationConfig)] = notificationConfig.toDictionary()
    dic[#keyPath(pushConfig)] = pushConfig.toDictionary()
    dic[#keyPath(antispamConfig)] = antispamConfig.toDictionary()
    dic[#keyPath(routeConfig)] = routeConfig.toDictionary()
    return dic
  }

  static func fromDcitonary(_ dictionary: [String: Any]) -> V2NIMSendCustomNotificationParams {
    let params = V2NIMSendCustomNotificationParams()
    if let notificationConfig = dictionary[#keyPath(V2NIMSendCustomNotificationParams.notificationConfig)] as? [String: Any] {
      params.notificationConfig = V2NIMNotificationConfig.fromDictionary(notificationConfig)
    }
    if let pushConfig = dictionary[#keyPath(V2NIMSendCustomNotificationParams.pushConfig)] as? [String: Any] {
      params.pushConfig = V2NIMNotificationPushConfig.fromDictionary(pushConfig)
    }
    if let antispamConfig = dictionary[#keyPath(V2NIMSendCustomNotificationParams.antispamConfig)] as? [String: Any] {
      params.antispamConfig = V2NIMNotificationAntispamConfig.fromDictionary(antispamConfig)
    }
    if let routeConfig = dictionary[#keyPath(V2NIMSendCustomNotificationParams.routeConfig)] as? [String: Any] {
      params.routeConfig = V2NIMNotificationRouteConfig.fromDictionary(routeConfig)
    }
    return params
  }
}

extension V2NIMCustomNotification {
  func toDictionary() -> [String: Any] {
    var dic = [String: Any]()
    dic[#keyPath(senderId)] = senderId
    dic[#keyPath(receiverId)] = receiverId
    dic[#keyPath(conversationType)] = conversationType.rawValue
    dic[#keyPath(timestamp)] = timestamp * 1000
    dic[#keyPath(content)] = content
    if let routeConfigDic = routeConfig?.toDictionary() {
      dic[#keyPath(routeConfig)] = routeConfigDic
    }
    if let notificationConfigDic = notificationConfig?.toDictionary() {
      dic[#keyPath(notificationConfig)] = notificationConfigDic
    }
    if let pushConfigDic = pushConfig?.toDictionary() {
      dic[#keyPath(pushConfig)] = pushConfigDic
    }
    if let antispamConfigDic = antispamConfig?.toDictionary() {
      dic[#keyPath(antispamConfig)] = antispamConfigDic
    }
    return dic
  }

  static func fromDictionary(_ dictionary: [String: Any]) -> V2NIMCustomNotification {
    let notification = V2NIMCustomNotification()
    if let senderId = dictionary[#keyPath(senderId)] as? String {
      notification.setValue(senderId, forKey: #keyPath(V2NIMCustomNotification.senderId))
    }
    if let receiverId = dictionary[#keyPath(receiverId)] as? String {
      notification.setValue(receiverId, forKey: #keyPath(V2NIMCustomNotification.receiverId))
    }
    if let conversationType = dictionary[#keyPath(conversationType)] as? Int, let conversationType = NIMSessionType(rawValue: conversationType) {
      notification.setValue(conversationType, forKey: #keyPath(V2NIMCustomNotification.conversationType))
    }
    if let timestamp = dictionary[#keyPath(timestamp)] as? Double {
      notification.setValue(timestamp / 1000, forKey: #keyPath(V2NIMCustomNotification.timestamp))
    }
    if let content = dictionary[#keyPath(content)] as? String {
      notification.setValue(content, forKey: #keyPath(V2NIMCustomNotification.content))
    }
    if let routeConfigDic = dictionary[#keyPath(routeConfig)] as? [String: Any] {
      notification.setValue(V2NIMNotificationRouteConfig.fromDictionary(routeConfigDic), forKey: #keyPath(V2NIMCustomNotification.routeConfig))
    }
    if let notificationConfigDic = dictionary[#keyPath(notificationConfig)] as? [String: Any] {
      notification.setValue(V2NIMNotificationConfig.fromDictionary(notificationConfigDic), forKey: #keyPath(V2NIMCustomNotification.notificationConfig))
    }
    if let pushConfigDic = dictionary[#keyPath(pushConfig)] as? [String: Any] {
      notification.setValue(V2NIMNotificationPushConfig.fromDictionary(pushConfigDic), forKey: #keyPath(V2NIMCustomNotification.pushConfig))
    }
    if let antispamConfigDic = dictionary[#keyPath(antispamConfig)] as? [String: Any] {
      notification.setValue(V2NIMNotificationAntispamConfig.fromDictionary(antispamConfigDic), forKey: #keyPath(V2NIMCustomNotification.antispamConfig))
    }
    return notification
  }
}

extension V2NIMBroadcastNotification {
  func toDictionary() -> [String: Any] {
    var dic = [String: Any]()
    dic[#keyPath(id)] = id
    dic[#keyPath(senderId)] = senderId
    dic[#keyPath(timestamp)] = timestamp
    dic[#keyPath(content)] = content
    return dic
  }

  static func fromDictionary(_ dictionary: [String: Any]) -> V2NIMBroadcastNotification {
    let notification = V2NIMBroadcastNotification()
    if let id = dictionary[#keyPath(id)] as? String {
      notification.setValue(id, forKey: #keyPath(V2NIMBroadcastNotification.id))
    }
    if let senderId = dictionary[#keyPath(senderId)] as? String {
      notification.setValue(senderId, forKey: #keyPath(V2NIMBroadcastNotification.senderId))
    }
    if let timestamp = dictionary[#keyPath(timestamp)] as? Double {
      notification.setValue(timestamp, forKey: #keyPath(V2NIMBroadcastNotification.timestamp))
    }
    if let content = dictionary[#keyPath(content)] as? String {
      notification.setValue(content, forKey: #keyPath(V2NIMBroadcastNotification.content))
    }
    return notification
  }
}
