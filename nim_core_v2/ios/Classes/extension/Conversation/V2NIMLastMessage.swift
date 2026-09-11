// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMLastMessage {
  func toDictionary() -> [String: Any] {
    var dict: [String: Any] = [
      #keyPath(messageType): messageType.rawValue,
      #keyPath(lastMessageState): lastMessageState.rawValue,
      #keyPath(messageRefer): messageRefer.toDic(),
      #keyPath(subType): subType,
      #keyPath(sendingState): sendingState.rawValue,
      #keyPath(text): text ?? "",
      #keyPath(revokeAccountId): revokeAccountId ?? "",
      #keyPath(revokeType): revokeType.rawValue,
      #keyPath(serverExtension): serverExtension ?? "",
      #keyPath(callbackExtension): callbackExtension ?? "",
      #keyPath(senderName): senderName ?? "",
    ]

    if let videoAttachemnt = attachment as? V2NIMMessageVideoAttachment {
      dict[#keyPath(attachment)] = videoAttachemnt.toDic()
    } else if let audioAttachment = attachment as? V2NIMMessageAudioAttachment {
      dict[#keyPath(attachment)] = audioAttachment.toDic()
    } else if let fileAttachment = attachment as? V2NIMMessageFileAttachment {
      dict[#keyPath(attachment)] = fileAttachment.toDic()
    } else if let imageAttachment = attachment as? V2NIMMessageImageAttachment {
      dict[#keyPath(attachment)] = imageAttachment.toDic()
    } else if let callAttachment = attachment as? V2NIMMessageCallAttachment {
      dict[#keyPath(attachment)] = callAttachment.toDic()
    } else if let locationAttachment = attachment as? V2NIMMessageLocationAttachment {
      dict[#keyPath(attachment)] = locationAttachment.toDic()
    } else if let notiAttachment = attachment as? V2NIMMessageNotificationAttachment {
      dict[#keyPath(attachment)] = notiAttachment.toDic()
    } else if let defualtDic = attachment?.toDic() {
      dict[#keyPath(attachment)] = defualtDic
    }
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMLastMessage {
    let lastMessage = V2NIMLastMessage()
    if let messageType = dict[#keyPath(messageType)] as? Int,
       let messageType = V2NIMMessageType(rawValue: messageType) {
      lastMessage.setValue(messageType.rawValue, forKey: #keyPath(V2NIMLastMessage.messageType))
    }
    if let lastMessageState = dict[#keyPath(lastMessageState)] as? Int,
       let state = V2NIMLastMessageState(rawValue: lastMessageState) {
      lastMessage.setValue(state.rawValue, forKey: #keyPath(V2NIMLastMessage.lastMessageState))
    }
    if let messageReferDic = dict[#keyPath(messageRefer)] as? [String: Any] {
      let messageRef = V2NIMMessageRefer.fromDic(messageReferDic)
      lastMessage.setValue(messageRef, forKey: #keyPath(V2NIMLastMessage.messageRefer))
    }
    if let subType = dict[#keyPath(subType)] as? Int {
      lastMessage.setValue(subType, forKey: #keyPath(V2NIMLastMessage.subType))
    }
    if let sendingState = dict[#keyPath(sendingState)] as? Int,
       let sendingState = V2NIMMessageSendingState(rawValue: sendingState) {
      lastMessage.setValue(sendingState.rawValue, forKey: #keyPath(V2NIMLastMessage.sendingState))
    }
    if let text = dict[#keyPath(text)] as? String {
      lastMessage.setValue(text, forKey: #keyPath(V2NIMLastMessage.text))
    }
    if let attachment = dict[#keyPath(attachment)] as? [String: Any],
       let attachment = FLTStorageService.getRealAttachment(attachment) {
      lastMessage.setValue(attachment, forKey: #keyPath(V2NIMLastMessage.attachment))
    }
    if let revokeAccountId = dict[#keyPath(revokeAccountId)] as? String {
      lastMessage.setValue(revokeAccountId, forKey: #keyPath(V2NIMLastMessage.revokeAccountId))
    }
    if let revokeType = dict[#keyPath(revokeType)] as? Int {
      lastMessage.setValue(revokeType, forKey: #keyPath(V2NIMLastMessage.revokeType))
    }
    if let serverExtension = dict[#keyPath(serverExtension)] as? String {
      lastMessage.setValue(serverExtension, forKey: #keyPath(V2NIMLastMessage.serverExtension))
    }
    if let callbackExtension = dict[#keyPath(callbackExtension)] as? String {
      lastMessage.setValue(callbackExtension, forKey: #keyPath(V2NIMLastMessage.callbackExtension))
    }
    if let senderName = dict[#keyPath(senderName)] as? String {
      lastMessage.setValue(senderName, forKey: #keyPath(V2NIMLastMessage.senderName))
    }
    return lastMessage
  }
}
