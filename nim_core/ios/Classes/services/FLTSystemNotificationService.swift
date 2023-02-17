// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum SystemNotificationType: String {
  case QuerySystemMessagesIOSAndDesktop = "querySystemMessagesIOSAndDesktop"
  case QuerySystemMessageByTypeIOSAndDesktop = "querySystemMessageByTypeIOSAndDesktop"
  case QuerySystemMessageUnread = "querySystemMessageUnread"
  case QuerySystemMessageUnreadCount = "querySystemMessageUnreadCount"
  case QuerySystemMessageUnreadCountByType = "querySystemMessageUnreadCountByType"
  case ResetSystemMessageUnreadCount = "resetSystemMessageUnreadCount"
  case ResetSystemMessageUnreadCountByType = "resetSystemMessageUnreadCountByType"
  case SetSystemMessageRead = "setSystemMessageRead"
  case ClearSystemMessages = "clearSystemMessages"
  case ClearSystemMessagesByType = "clearSystemMessagesByType"
  case DeleteSystemMessage = "deleteSystemMessage"
  case SetSystemMessageStatus = "setSystemMessageStatus"
  case SendCustomNotification = "sendCustomNotification"
}

class FLTSystemNotificationService: FLTBaseService, FLTService {
//    override init() {
//        super.init()
//        NIMSDK.shared().systemNotificationManager.add(self)
//    }

  override func onInitialized() {
    NIMSDK.shared().systemNotificationManager.add(self)
  }

  deinit {
    NIMSDK.shared().systemNotificationManager.remove(self)
  }

  // MARK: Service Protocol

  func serviceName() -> String {
    ServiceType.SystemNotificationService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case SystemNotificationType.QuerySystemMessagesIOSAndDesktop.rawValue:
      querySystemMessagesIOSAndDesktop(arguments, resultCallback)
    case SystemNotificationType.QuerySystemMessageByTypeIOSAndDesktop.rawValue:
      querySystemMessageByTypeIOSAndDesktop(arguments, resultCallback)
    case SystemNotificationType.QuerySystemMessageUnread.rawValue:
      querySystemMessageUnread(arguments, resultCallback)
    case SystemNotificationType.QuerySystemMessageUnreadCount.rawValue:
      querySystemMessageUnreadCount(arguments, resultCallback)
    case SystemNotificationType.QuerySystemMessageUnreadCountByType.rawValue:
      querySystemMessageUnreadCountByType(arguments, resultCallback)
    case SystemNotificationType.ResetSystemMessageUnreadCount.rawValue:
      resetSystemMessageUnreadCount(arguments, resultCallback)
    case SystemNotificationType.ResetSystemMessageUnreadCountByType.rawValue:
      resetSystemMessageUnreadCountByType(arguments, resultCallback)
    case SystemNotificationType.SetSystemMessageRead.rawValue:
      setSystemMessageRead(arguments, resultCallback)
    case SystemNotificationType.ClearSystemMessages.rawValue:
      clearSystemMessages(arguments, resultCallback)
    case SystemNotificationType.ClearSystemMessagesByType.rawValue:
      clearSystemMessagesByType(arguments, resultCallback)
    case SystemNotificationType.DeleteSystemMessage.rawValue:
      deleteSystemMessage(arguments, resultCallback)
    case SystemNotificationType.SetSystemMessageStatus.rawValue:
      setSystemMessageStatus(arguments, resultCallback)
    case SystemNotificationType.SendCustomNotification.rawValue:
      sendCustomNotification(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  // MARK: Public Method

  func querySystemMessagesIOSAndDesktop(_ arguments: [String: Any],
                                        _ resultCallback: ResultCallback) {
    let limit = arguments["limit"] as? Int ?? 0
    let notification = NIMSystemNotification()
    if let systemMessage = arguments["systemMessage"] as? [String: Any],
       let time = systemMessage["time"] as? Int {
      notification.setValue(time, forKeyPath: "timestamp")
    } else {
      notification.setValue(Date().timeIntervalSince1970, forKeyPath: "timestamp")
    }
    if let systemMessageList = NIMSDK.shared().systemNotificationManager
      .fetchSystemNotifications(notification, limit: limit) {
      let result = NimResult(["systemMessageList": systemMessageList.map { noti in
        noti.toDic()
      }], 0, nil)
      resultCallback.result(result.toDic())
    } else {
      resultCallback.result(NimResult.success())
    }
  }

  func querySystemMessageByTypeIOSAndDesktop(_ arguments: [String: Any],
                                             _ resultCallback: ResultCallback) {
    let limit = arguments["limit"] as? Int ?? 0
    let notification = NIMSystemNotification()
    if let systemMessage = arguments["systemMessage"] as? [String: Any],
       let time = systemMessage["time"] as? Int {
      notification.setValue(time, forKeyPath: "timestamp")
    } else {
      notification.setValue(Date().timeIntervalSince1970, forKeyPath: "timestamp")
    }
    var filter: NIMSystemNotificationFilter?
    if let systemMessageTypeList = arguments["systemMessageTypeList"] as? [String] {
      filter = NIMSystemNotificationFilter()
      filter!.notificationTypes = systemMessageTypeList.map { type in
        NSNumber(value: convertType(type: type).rawValue)
      }
    }
    if let systemMessageList = NIMSDK.shared().systemNotificationManager
      .fetchSystemNotifications(notification, limit: limit, filter: filter) {
      let result = NimResult(["systemMessageList": systemMessageList.map { noti in
        noti.toDic()
      }], 0, nil)
      resultCallback.result(result.toDic())
    } else {
      resultCallback.result(NimResult.success())
    }
  }

  func querySystemMessageUnread(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    // dart层没有limit，咨询SDK开发@陈吉力后此处传max
    let systemMessageList = NIMSDK.shared().systemNotificationManager
      .fetchSystemNotifications(nil, limit: Int.max)
    if systemMessageList != nil,
       systemMessageList!.count > 0 {
      var unreadList = [[String: Any?]]()
      for message in systemMessageList! {
        if !message.read,
           let json = message.toDic() {
          unreadList.append(json)
        }
      }
      let result = NimResult(["systemMessageList": unreadList], 0, nil)
      resultCallback.result(result.toDic())
    } else {
      resultCallback.result(NimResult.success().toDic())
    }
  }

  func querySystemMessageUnreadCount(_ arguments: [String: Any],
                                     _ resultCallback: ResultCallback) {
    let systemMessageList = NIMSDK.shared().systemNotificationManager.allUnreadCount()
    let result = NimResult(systemMessageList, 0, nil)
    resultCallback.result(result.toDic())
  }

  func querySystemMessageUnreadCountByType(_ arguments: [String: Any],
                                           _ resultCallback: ResultCallback) {
    if let systemMessageTypeList = arguments["systemMessageTypeList"] as? [String] {
      let filter = NIMSystemNotificationFilter()
      filter.notificationTypes = systemMessageTypeList.map { type in
        NSNumber(value: convertType(type: type).rawValue)
      }
      let systemMessageList = NIMSDK.shared().systemNotificationManager.allUnreadCount(filter)
      let result = NimResult(systemMessageList, 0, nil)
      resultCallback.result(result.toDic())
    } else {
      resultCallback.result(NimResult.error(-1, "systemMessageTypeList invalid").toDic())
    }
  }

  func resetSystemMessageUnreadCount(_ arguments: [String: Any],
                                     _ resultCallback: ResultCallback) {
    NIMSDK.shared().systemNotificationManager.markAllNotificationsAsRead()
    let result = NimResult(nil, 0, nil)
    resultCallback.result(result.toDic())
  }

  func resetSystemMessageUnreadCountByType(_ arguments: [String: Any],
                                           _ resultCallback: ResultCallback) {
    if let systemMessageTypeList = arguments["systemMessageTypeList"] as? [String] {
      let filter = NIMSystemNotificationFilter()
      filter.notificationTypes = systemMessageTypeList.map { type in
        NSNumber(value: convertType(type: type).rawValue)
      }
      NIMSDK.shared().systemNotificationManager.markAllNotifications(asRead: filter)
      let result = NimResult(nil, 0, nil)
      resultCallback.result(result.toDic())
    } else {
      resultCallback.result(NimResult.error(-1, "systemMessageTypeList invalid").toDic())
    }
  }

  func setSystemMessageRead(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let messageId = arguments["messageId"] as? Int {
      let notification = NIMSystemNotification()
      notification.setValue(messageId, forKeyPath: "serial")
      NIMSDK.shared().systemNotificationManager.markNotifications(asRead: notification)
      let result = NimResult(nil, 0, nil)
      resultCallback.result(result.toDic())
    } else {
      resultCallback.result(NimResult.error(-1, "messageId invalid").toDic())
    }
  }

  func clearSystemMessages(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    NIMSDK.shared().systemNotificationManager.deleteAllNotifications()
    let result = NimResult(nil, 0, nil)
    resultCallback.result(result.toDic())
  }

  func clearSystemMessagesByType(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let systemMessageTypeList = arguments["systemMessageTypeList"] as? [String] {
      let filter = NIMSystemNotificationFilter()
      filter.notificationTypes = systemMessageTypeList.map { type in
        NSNumber(value: convertType(type: type).rawValue)
      }
      NIMSDK.shared().systemNotificationManager.deleteAllNotifications(filter)
      let result = NimResult(nil, 0, nil)
      resultCallback.result(result.toDic())
    } else {
      resultCallback.result(NimResult.error(-1, "systemMessageTypeList invalid").toDic())
    }
  }

  func deleteSystemMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let messageId = arguments["messageId"] as? Int {
      let notification = NIMSystemNotification()
      notification.setValue(messageId, forKeyPath: "serial")
      NIMSDK.shared().systemNotificationManager.delete(notification)
      let result = NimResult(nil, 0, nil)
      resultCallback.result(result.toDic())
    } else {
      resultCallback.result(NimResult.error(-1, "messageId invalid").toDic())
    }
  }

  func setSystemMessageStatus(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let messageId = arguments["messageId"] as? Int {
      let systemMessageStatus = arguments["systemMessageStatus"] as? String ?? ""
      let notification = NIMSystemNotification()
      notification.setValue(messageId, forKeyPath: "serial")
      switch systemMessageStatus {
      case "init":
        notification.handleStatus = 0
      case "passed":
        notification.handleStatus = 1
      case "declined":
        notification.handleStatus = 2
      case "ignored":
        notification.handleStatus = 3
      case "expired":
        notification.handleStatus = 4
      case "extension1":
        notification.handleStatus = 5
      case "extension2":
        notification.handleStatus = 6
      case "extension3":
        notification.handleStatus = 7
      case "extension4":
        notification.handleStatus = 8
      case "extension5":
        notification.handleStatus = 9
      default:
        notification.handleStatus = 0
      }
      resultCallback.result(NimResult.success().toDic())
    } else {
      resultCallback.result(NimResult.error(-1, "messageId invalid").toDic())
    }
  }

  func sendCustomNotification(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let notification = arguments["customNotification"] as? [String: Any] {
      let sessionId = notification["sessionId"] as? String ?? ""
      let type = notification["sessionType"] as? String ?? ""
      let sessionType = try? NIMSessionType.getType(type)
      let session = NIMSession(sessionId, type: sessionType ?? NIMSessionType.P2P)
      NIMSDK.shared().systemNotificationManager.sendCustomNotification(
        NIMCustomSystemNotification.createCustomSystemNotification(notification)!,
        to: session
      ) { error in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          let result = NimResult(nil, 0, nil)
          resultCallback.result(result.toDic())
        }
      }
    }
  }

  func convertType(type: String) -> NIMSystemNotificationType {
    switch type {
    case "applyJoinTeam":
      return NIMSystemNotificationType.teamApply
    case "rejectTeamApply":
      return NIMSystemNotificationType.teamApplyReject
    case "teamInvite":
      return NIMSystemNotificationType.teamInvite
    case "declineTeamInvite":
      return NIMSystemNotificationType.teamIviteReject
    case "addFriend":
      return NIMSystemNotificationType.friendAdd
    case "superTeamApply":
      return NIMSystemNotificationType.superTeamApply
    case "superTeamApplyReject":
      return NIMSystemNotificationType.superTeamApplyReject
    case "superTeamInvite":
      return NIMSystemNotificationType.superTeamInvite
    case "superTeamInviteReject":
      return NIMSystemNotificationType.superTeamIviteReject
    default:
      return NIMSystemNotificationType.superTeamIviteReject
    }
  }
}

extension FLTSystemNotificationService: NIMSystemNotificationManagerDelegate {
  func onReceive(_ notification: NIMSystemNotification) {
    notifyEvent(serviceName(), "onReceiveSystemMsg", notification.toDic())
  }

  func onReceive(_ notification: NIMCustomSystemNotification) {
    notifyEvent(serviceName(), "onCustomNotification", notification.toDic())
  }

  func onSystemNotificationCountChanged(_ unreadCount: Int) {
    notifyEvent(serviceName(), "onUnreadCountChange", ["result": unreadCount])
  }
}
