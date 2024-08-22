// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension NIMRecentSession: NimDataConvertProtrol {
  @objc static func modelPropertyBlacklist() -> [String] {
    [
      #keyPath(NIMRecentSession.session),
      #keyPath(NIMRecentSession.lastMessage),
      #keyPath(NIMRecentSession.lastMessageType),
      #keyPath(NIMRecentSession.updateTime),
      #keyPath(NIMRecentSession.unreadCount),
      "compareTimeWhenBeAdded",
    ]
  }

  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["sessionId"] = session?.sessionId ?? ""
      if let sessionType = session?.sessionType,
         let flt_sessionType = FLT_NIMSessionType.convertFLTSessionType(sessionType) {
        jsonObject["sessionType"] = flt_sessionType.rawValue
      }
      jsonObject["lastMessageId"] = lastMessage?.messageId
      jsonObject["senderAccount"] = lastMessage?.from ?? ""
      jsonObject["senderNickname"] = lastMessage?.senderName ?? ""

      if let contnet = lastMessage?.content {
        jsonObject["lastMessageContent"] = contnet
      } else {
        jsonObject["lastMessageContent"] = lastMessage?.convertLastMessage()
      }
      if let sendTime = lastMessage?.timestamp {
        jsonObject["lastMessageTime"] = Int(sendTime * 1000)
      }
      if let type = lastMessage?.messageType,
         let flt_type = FLT_NIMMessageType.convert(type) {
        jsonObject["lastMessageType"] = flt_type.rawValue
      }
      if lastMessage != nil {
        let flt_status = FLT_NIMMessageStatus.convertFLTStatus(lastMessage!)
        jsonObject["lastMessageStatus"] = flt_status.rawValue
      }

      jsonObject["lastMessageAttachment"] = [:]
      if let dic = lastMessage?.toDic(),
         let attachment = dic["messageAttachment"] as? [String: Any?] {
        jsonObject["lastMessageAttachment"] = attachment
      }
      jsonObject["unreadCount"] = unreadCount
      jsonObject["extension"] = localExt ?? ["ext": serverExt]
      return jsonObject
    }
    return nil
  }

  // 跟Android同步，需要两层
  func toDicEx() -> [String: Any] {
    var map = [String: Any]()
    map["sessionId"] = session?.sessionId ?? ""
    map["sessionTypePair"] = session?.sessionId
    if let sessionType = session?.sessionType,
       let flt_sessionType = FLT_NIMSessionType.convertFLTSessionType(sessionType) {
      map["sessionType"] = flt_sessionType.rawValue
    }
    map["updateTime"] = Int(updateTime * 1000)
    map["ext"] = serverExt
    if let contnet = lastMessage?.content {
      map["lastMsg"] = contnet
    } else {
      map["lastMsg"] = lastMessage?.convertLastMessage()
    }
    if lastMessageType == .normalMessage,
       lastRevokeNotification == nil {
      map["lastMsgType"] = 0
    } else if lastMessageType == .revokeNotication,
              lastMessage == nil {
      map["lastMsgType"] = 1
    }
    map["revokeNotification"] = lastRevokeNotification?.toDic()
    map["recentSession"] = toDic()
    return map
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMRecentSession.yx_model(withJSON: json) {
      if let sessionId = json["sessionId"] as? String,
         let sessionType = json["sessionType"] as? String,
         let flt_session = FLT_NIMSessionType(rawValue: sessionType),
         let realSessionType = flt_session.convertToNIMSessionType() {
        let session = NIMSession(sessionId, type: realSessionType)
        model.setValue(session, forKey: "_session")
      }
      let message = NIMMessage()
      model.lastMessage = message
      if let messageId = json["lastMessageId"] as? String {
        message.setValue(messageId, forKey: "_messageId")
      }
      if let from = json["senderAccount"] as? String {
        message.from = from
      }
      if let senderName = json["senderNickname"] as? String {
        message.setValue(senderName, forKey: "_senderName")
      }
      if let content = json["lastMessageContent"] as? String {
        message.content = content
      }
      if let timestamp = json["lastMessageContent"] as? TimeInterval {
        message.timestamp = timestamp
      }
      if let messageType = json["lastMessageType"] as? String,
         let flt_type = FLT_NIMMessageType(rawValue: messageType) {
        message.setValue(flt_type.convertToNIMMessageType, forKey: "_messageType")
      }
      if let status = json["lastMessageStatus"] as? String,
         let flt_status = FLT_NIMMessageStatus(rawValue: status),
         let nim_status = flt_status.convertToNIMMessageStatus() {
        message.status = nim_status
      }
      if let unread = json["unreadCount"] as? Int {
        model.setValue(unread, forKey: "_unreadCount")
      }
      if let localExt = json["extension"] as? [String: Any] {
        model.setValue(localExt, forKey: "_localExt")
      }
      if let sendTime = json["lastMessageTime"] as? Int {
        message.timestamp = Double(sendTime) / 1000.0
      }
      return model
    }
    return nil
  }
}
