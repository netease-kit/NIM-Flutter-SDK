// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension NIMSystemNotification {
  // TODO: 比Android少一个字段，可能是attach
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [#keyPath(NIMSystemNotification.type): "type",
     #keyPath(NIMSystemNotification.timestamp): "time",
     #keyPath(NIMSystemNotification.sourceID): "fromAccount",
     #keyPath(NIMSystemNotification.targetID): "targetId",
     #keyPath(NIMSystemNotification.read): "read", // Android是unread，都需要取反
     #keyPath(NIMSystemNotification.handleStatus): "status",
     #keyPath(NIMSystemNotification.attachment): "attachObject",
     #keyPath(NIMSystemNotification.notificationId): "messageId"]
  }

  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["unread"] = !read
      jsonObject["time"] = Int(timestamp * 1000)
      jsonObject["messageId"] = value(forKeyPath: "serial")
      if let attach = value(forKeyPath: "attachString") {
        jsonObject["attach"] = attach
      }
      jsonObject["content"] = postscript ?? ""
      jsonObject["customInfo"] = notifyExt ?? ""

      switch type {
      case NIMSystemNotificationType.teamApply:
        jsonObject["type"] = "applyJoinTeam"
      case NIMSystemNotificationType.teamApplyReject:
        jsonObject["type"] = "rejectTeamApply"
      case NIMSystemNotificationType.teamInvite:
        jsonObject["type"] = "teamInvite"
      case NIMSystemNotificationType.teamIviteReject:
        jsonObject["type"] = "declineTeamInvite"
      case NIMSystemNotificationType.friendAdd:
        jsonObject["type"] = "addFriend"
      case NIMSystemNotificationType.superTeamApply:
        jsonObject["type"] = "superTeamApply"
      case NIMSystemNotificationType.superTeamApplyReject:
        jsonObject["type"] = "superTeamApplyReject"
      case NIMSystemNotificationType.superTeamInvite:
        jsonObject["type"] = "superTeamInvite"
      case NIMSystemNotificationType.superTeamIviteReject:
        jsonObject["type"] = "superTeamInviteReject"
      default:
        jsonObject["type"] = "undefined"
      }
      switch handleStatus {
      case 0:
        jsonObject["status"] = "init"
      case 1:
        jsonObject["status"] = "passed"
      case 2:
        jsonObject["status"] = "declined"
      case 3:
        jsonObject["status"] = "ignored"
      case 4:
        jsonObject["status"] = "expired"
      case 5:
        jsonObject["status"] = "extension1"
      case 6:
        jsonObject["status"] = "extension2"
      case 7:
        jsonObject["status"] = "extension3"
      case 8:
        jsonObject["status"] = "extension4"
      case 9:
        jsonObject["status"] = "extension5"
      default:
        jsonObject["status"] = "init"
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMSystemNotificationFilter {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [#keyPath(NIMSystemNotificationFilter.notificationTypes): "notificationTypes"]
  }
}

extension NIMCustomSystemNotification {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [#keyPath(NIMCustomSystemNotification.notificationId): "notificationId",
     #keyPath(NIMCustomSystemNotification.timestamp): "time",
     #keyPath(NIMCustomSystemNotification.sender): "fromAccount",
     #keyPath(NIMCustomSystemNotification.receiver): "receiver",
     #keyPath(NIMCustomSystemNotification.receiverType): "receiverType",
     #keyPath(NIMCustomSystemNotification.content): "content",
     #keyPath(NIMCustomSystemNotification.sendToOnlineUsersOnly): "sendToOnlineUserOnly",
     #keyPath(NIMCustomSystemNotification.apnsContent): "apnsText",
     #keyPath(NIMCustomSystemNotification.apnsPayload): "pushPayload",
     #keyPath(NIMCustomSystemNotification.setting): "config"]
  }

  static func createCustomSystemNotification(_ args: [String: Any])
    -> NIMCustomSystemNotification? {
    let notification = NIMCustomSystemNotification.yx_model(with: args)
    // 处理readonly字段
    if let notificationId = args["notificationId"] {
      notification?.setValue(
        notificationId,
        forKeyPath: #keyPath(NIMCustomSystemNotification.notificationId)
      )
    }
    if let time = args["time"] as? Int {
      notification?.setValue(
        time / 1000,
        forKeyPath: #keyPath(NIMCustomSystemNotification.timestamp)
      )
    }
    if let fromAccount = args["fromAccount"] {
      notification?.setValue(
        fromAccount,
        forKeyPath: #keyPath(NIMCustomSystemNotification.sender)
      )
    }
    // Flutter 无此字段，session 字段在发送的时候单独解析
    if let receiver = args["receiver"] {
      notification?.setValue(
        receiver,
        forKeyPath: #keyPath(NIMCustomSystemNotification.receiver)
      )
    }
    if let receiverType = args["receiverType"] {
      notification?.setValue(
        receiverType,
        forKeyPath: #keyPath(NIMCustomSystemNotification.receiverType)
      )
    }
    if let content = args["content"] {
      notification?.setValue(
        content,
        forKeyPath: #keyPath(NIMCustomSystemNotification.content)
      )
    }
    return notification
  }

  // 只处理收的情况
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["sessionType"] = FLT_NIMSessionType.convertFLTSessionType(receiverType)?
        .rawValue
      if receiverType == NIMSessionType.P2P {
        jsonObject["sessionId"] = sender
      } else {
        jsonObject["sessionId"] = receiver
      }
      jsonObject["time"] = Int(timestamp * 1000)
      return jsonObject
    }
    return nil
  }
}

extension NIMCustomSystemNotificationSetting {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [#keyPath(NIMCustomSystemNotificationSetting.shouldBeCounted): "enableUnreadCount",
     #keyPath(NIMCustomSystemNotificationSetting.apnsEnabled): "enablePush",
     #keyPath(NIMCustomSystemNotificationSetting.apnsWithPrefix): "enablePushNick"]
  }
}
