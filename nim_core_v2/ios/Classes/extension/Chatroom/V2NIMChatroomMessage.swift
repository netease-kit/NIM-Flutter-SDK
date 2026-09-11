// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomMessage {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomMessage {
    let message = V2NIMChatroomMessage()

    if let messageClientId = arguments["messageClientId"] as? String {
      message.setValue(messageClientId,
                       forKeyPath: #keyPath(V2NIMChatroomMessage.messageClientId))
    }

    if let senderClientType = arguments["senderClientType"] as? Int {
      message.setValue(senderClientType,
                       forKeyPath: "clientType")
    }

    if let createTime = arguments["createTime"] as? Int {
      message.setValue(TimeInterval(createTime / 1000),
                       forKeyPath: #keyPath(V2NIMChatroomMessage.createTime))
    }

    if let senderId = arguments["senderId"] as? String {
      message.setValue(senderId,
                       forKeyPath: #keyPath(V2NIMChatroomMessage.senderId))
    }

    if let roomId = arguments["roomId"] as? String {
      message.setValue(roomId,
                       forKeyPath: #keyPath(V2NIMChatroomMessage.roomId))
    }

    if let isSelf = arguments["isSelf"] as? Bool {
      message.setValue(isSelf,
                       forKeyPath: #keyPath(V2NIMChatroomMessage.isSelf))
    }

    if let attachmentUploadState = arguments["attachmentUploadState"] as? Int,
       let attachmentUploadState = V2NIMMessageAttachmentUploadState(rawValue: attachmentUploadState) {
      message.setValue(attachmentUploadState.rawValue,
                       forKeyPath: #keyPath(V2NIMChatroomMessage.attachmentUploadState))
    }

    if let sendingState = arguments["sendingState"] as? Int,
       let sendingState = V2NIMMessageSendingState(rawValue: sendingState) {
      message.setValue(sendingState.rawValue,
                       forKeyPath: #keyPath(V2NIMChatroomMessage.sendingState))
    }

    if let messageType = arguments["messageType"] as? Int,
       let messageType = V2NIMMessageSendingState(rawValue: messageType) {
      message.setValue(messageType.rawValue,
                       forKeyPath: #keyPath(V2NIMChatroomMessage.messageType))
    }

    if let subType = arguments["subType"] as? Int {
      message.subType = subType
    }

    if let text = arguments["text"] as? String {
      message.text = text
    }

    if let attachment = arguments["attachment"] as? [String: Any],
       let type = arguments["messageType"] as? Int,
       let messageType = V2NIMMessageType(rawValue: type) {
      switch messageType {
      case .MESSAGE_TYPE_AUDIO:
        message.attachment = V2NIMMessageAudioAttachment.fromDictionary(attachment)
      case .MESSAGE_TYPE_FILE:
        message.attachment = V2NIMMessageFileAttachment.fromDict(attachment)
      case .MESSAGE_TYPE_IMAGE:
        message.attachment = V2NIMMessageImageAttachment.fromDictionary(attachment)
      case .MESSAGE_TYPE_VIDEO:
        message.attachment = V2NIMMessageVideoAttachment.fromDictionary(attachment)
      case .MESSAGE_TYPE_LOCATION:
        message.attachment = V2NIMMessageLocationAttachment.fromDict(attachment)
      case .MESSAGE_TYPE_NOTIFICATION:
        if let nimCoreMessageType = attachment["nimCoreMessageType"] as? Int,
           nimCoreMessageType == 105,
           let type = attachment["type"] as? Int,
           let type = V2NIMChatroomMessageNotificationType(rawValue: type) {
          switch type {
          case .CHATROOM_MESSAGE_NOTIFICATION_TYPE_MESSAGE_REVOKE:
            message.attachment = V2NIMChatroomMessageRevokeNotificationAttachment.fromDictionary(attachment)
          case .CHATROOM_MESSAGE_NOTIFICATION_TYPE_QUEUE_CHANGE:
            message.attachment = V2NIMChatroomQueueNotificationAttachment.fromDictionary(attachment)
          case .CHATROOM_MESSAGE_NOTIFICATION_TYPE_CHAT_BANNED:
            message.attachment = V2NIMChatroomChatBannedNotificationAttachment.fromDictionary(attachment)
          case .CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_ENTER:
            message.attachment = V2NIMChatroomMemberEnterNotificationAttachment.fromDictionary(attachment)
          case .CHATROOM_MESSAGE_NOTIFICATION_TYPE_MEMBER_INFO_UPDATED:
            message.attachment = V2NIMChatroomMemberRoleUpdateAttachment.fromDictionary(attachment)
          default:
            message.attachment = V2NIMChatroomNotificationAttachment.fromDict(attachment)
          }
        } else {
          message.attachment = V2NIMMessageNotificationAttachment.fromDict(attachment)
        }
      case .MESSAGE_TYPE_CALL:
        message.attachment = V2NIMMessageCallAttachment.fromDict(attachment)
      default:
        message.attachment = V2NIMMessageAttachment.fromDic(attachment)
      }
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      message.serverExtension = serverExtension
    }

    if let callbackExtension = arguments["callbackExtension"] as? String {
      message.setValue(callbackExtension,
                       forKeyPath: #keyPath(V2NIMChatroomMessage.callbackExtension))
    }

    if let routeConfig = arguments["routeConfig"] as? [String: Any] {
      message.setValue(V2NIMMessageRouteConfig.fromDic(routeConfig),
                       forKeyPath: #keyPath(V2NIMChatroomMessage.routeConfig))
    }

    if let antispamConfig = arguments["antispamConfig"] as? [String: Any] {
      message.setValue(V2NIMMessageAntispamConfig.fromDic(antispamConfig),
                       forKeyPath: #keyPath(V2NIMChatroomMessage.antispamConfig))
    }

    if let notifyTargetTags = arguments["notifyTargetTags"] as? String {
      message.notifyTargetTags = notifyTargetTags
    }

    if let messageConfig = arguments["messageConfig"] as? [String: Any] {
      message.setValue(V2NIMChatroomMessageConfig.fromDic(messageConfig),
                       forKeyPath: #keyPath(V2NIMChatroomMessage.messageConfig))
    }

    if let userInfoConfig = arguments["userInfoConfig"] as? [String: Any] {
      message.userInfoConfig = V2NIMUserInfoConfig.fromDic(userInfoConfig)
    }

    if let locationInfo = arguments["locationInfo"] as? [String: Any] {
      message.locationInfo = V2NIMLocationInfo.fromDic(locationInfo)
    }

    return message
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(messageClientId)] = messageClientId
    keyPaths[#keyPath(senderClientType)] = senderClientType
    keyPaths[#keyPath(createTime)] = createTime * 1000
    keyPaths[#keyPath(senderId)] = senderId
    keyPaths[#keyPath(roomId)] = roomId
    keyPaths[#keyPath(isSelf)] = isSelf
    keyPaths[#keyPath(attachmentUploadState)] = attachmentUploadState.rawValue
    keyPaths[#keyPath(sendingState)] = sendingState.rawValue
    keyPaths[#keyPath(messageType)] = messageType.rawValue
    keyPaths[#keyPath(subType)] = subType
    keyPaths[#keyPath(text)] = text
    keyPaths[#keyPath(attachment)] = attachment?.toDic()
    keyPaths[#keyPath(serverExtension)] = serverExtension
    keyPaths[#keyPath(callbackExtension)] = callbackExtension
    keyPaths[#keyPath(routeConfig)] = routeConfig?.toDic()
    keyPaths[#keyPath(antispamConfig)] = antispamConfig?.toDic()
    keyPaths[#keyPath(notifyTargetTags)] = notifyTargetTags
    keyPaths[#keyPath(messageConfig)] = messageConfig?.toDic()
    keyPaths[#keyPath(userInfoConfig)] = userInfoConfig?.toDic()
    keyPaths[#keyPath(locationInfo)] = locationInfo?.toDic()
    return keyPaths
  }
}
