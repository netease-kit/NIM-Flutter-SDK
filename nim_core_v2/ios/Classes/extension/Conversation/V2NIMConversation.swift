// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
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
    if let messageType = dict[#keyPath(messageType)] as? Int, let messageType = V2NIMMessageType(rawValue: messageType) {
      lastMessage.setValue(messageType, forKey: #keyPath(V2NIMLastMessage.messageType))
    }
    if let lastMessageState = dict[#keyPath(lastMessageState)] as? Int, let state = V2NIMLastMessageState(rawValue: lastMessageState) {
      lastMessage.setValue(state, forKey: #keyPath(V2NIMLastMessage.lastMessageState))
    }
    if let messageReferDic = dict[#keyPath(messageRefer)] as? [String: Any] {
      let messageRef = V2NIMMessageRefer.fromDic(messageReferDic)
      lastMessage.setValue(messageRef, forKey: #keyPath(V2NIMLastMessage.messageRefer))
    }
    if let subType = dict[#keyPath(subType)] as? Int {
      lastMessage.setValue(subType, forKey: #keyPath(V2NIMLastMessage.subType))
    }
    if let sendingState = dict[#keyPath(sendingState)] as? Int, let sendingState = V2NIMMessageSendingState(rawValue: sendingState) {
      lastMessage.setValue(sendingState, forKey: #keyPath(V2NIMLastMessage.sendingState))
    }
    if let text = dict[#keyPath(text)] as? String {
      lastMessage.setValue(text, forKey: #keyPath(V2NIMLastMessage.text))
    }
    if let attachment = dict[#keyPath(attachment)] as? [String: Any], let attachment = FLTStorageService.getRealAttachment(attachment) {
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

extension V2NIMConversation {
  func toDictionary() -> [String: Any] {
    var dict: [String: Any] = [
      #keyPath(conversationId): conversationId,
      #keyPath(type): type.rawValue,
      #keyPath(name): name ?? "",
      #keyPath(avatar): avatar ?? "",
      #keyPath(mute): mute,
      #keyPath(stickTop): stickTop,
      #keyPath(groupIds): groupIds ?? [],
      #keyPath(localExtension): localExtension,
      #keyPath(serverExtension): serverExtension ?? "",
      #keyPath(unreadCount): unreadCount,
      #keyPath(createTime): createTime * 1000.0,
      #keyPath(updateTime): updateTime * 1000.0,
      #keyPath(sortOrder): sortOrder,
      #keyPath(lastMessage): lastMessage?.toDictionary() as Any,
    ]

    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMConversation {
    let conversation = V2NIMConversation()
    if let conversationId = dict[#keyPath(conversationId)] as? String {
      conversation.setValue(conversationId, forKey: #keyPath(V2NIMConversation.conversationId))
    }
    if let type = dict[#keyPath(type)] as? Int, let type = V2NIMConversationType(rawValue: type) {
      conversation.setValue(type, forKey: #keyPath(V2NIMConversation.type))
    }
    if let name = dict[#keyPath(name)] as? String {
      conversation.setValue(name, forKey: #keyPath(V2NIMConversation.name))
    }
    if let avatar = dict[#keyPath(avatar)] as? String {
      conversation.setValue(avatar, forKey: #keyPath(V2NIMConversation.avatar))
    }
    if let mute = dict[#keyPath(mute)] as? Bool {
      conversation.setValue(mute, forKey: #keyPath(V2NIMConversation.mute))
    }
    if let stickTop = dict[#keyPath(stickTop)] as? Bool {
      conversation.setValue(stickTop, forKey: #keyPath(V2NIMConversation.stickTop))
    }
    if let groupIds = dict[#keyPath(groupIds)] as? [String] {
      conversation.setValue(groupIds, forKey: #keyPath(V2NIMConversation.groupIds))
    }
    if let localExtension = dict[#keyPath(localExtension)] as? String {
      conversation.setValue(localExtension, forKey: #keyPath(V2NIMConversation.localExtension))
    }
    if let serverExtension = dict[#keyPath(serverExtension)] as? String {
      conversation.setValue(serverExtension, forKey: #keyPath(V2NIMConversation.serverExtension))
    }
    if let unreadCount = dict[#keyPath(unreadCount)] as? Int {
      conversation.setValue(unreadCount, forKey: #keyPath(V2NIMConversation.unreadCount))
    }
    if let createTime = dict[#keyPath(createTime)] as? Int {
      conversation.setValue(createTime, forKey: #keyPath(V2NIMConversation.createTime))
    }
    if let updateTime = dict[#keyPath(updateTime)] as? Int {
      conversation.setValue(updateTime, forKey: #keyPath(V2NIMConversation.updateTime))
    }
    if let sortOrder = dict[#keyPath(sortOrder)] as? Int {
      conversation.setValue(sortOrder, forKey: #keyPath(V2NIMConversation.sortOrder))
    }
    if let lastMessageDic = dict[#keyPath(lastMessage)] as? [String: Any] {
      let lastMessage = V2NIMLastMessage.fromDictionary(lastMessageDic)
      conversation.setValue(lastMessage, forKey: #keyPath(V2NIMConversation.lastMessage))
    }
    return conversation
  }
}

extension V2NIMConversationGroup {
  func toDictionary() -> [String: Any] {
    let dict: [String: Any] = [
      #keyPath(groupId): groupId ?? "",
      #keyPath(name): name ?? "",
      #keyPath(serverExtension): serverExtension ?? "",
      #keyPath(createTime): createTime,
      #keyPath(updateTime): updateTime,
    ]
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMConversationGroup {
    let group = V2NIMConversationGroup()
    if let groupId = dict[#keyPath(groupId)] as? String {
      group.setValue(groupId, forKey: #keyPath(V2NIMConversationGroup.groupId))
    }
    if let name = dict[#keyPath(name)] as? String {
      group.setValue(name, forKey: #keyPath(V2NIMConversationGroup.name))
    }
    if let serverExtension = dict[#keyPath(serverExtension)] as? String {
      group.setValue(serverExtension, forKey: #keyPath(V2NIMConversationGroup.serverExtension))
    }
    if let createTime = dict[#keyPath(createTime)] as? Int {
      group.setValue(createTime, forKey: #keyPath(V2NIMConversationGroup.createTime))
    }
    if let updateTime = dict[#keyPath(updateTime)] as? Int {
      group.setValue(updateTime, forKey: #keyPath(V2NIMConversationGroup.updateTime))
    }
    return group
  }
}

extension V2NIMConversationOption {
  func toDictionary() -> [String: Any] {
    let dict: [String: Any] = [
      #keyPath(conversationTypes): conversationTypes ?? [],
      #keyPath(onlyUnread): onlyUnread,
      #keyPath(conversationGroupIds): conversationGroupIds ?? [],
    ]
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMConversationOption {
    let option = V2NIMConversationOption()
    if let conversationTypes = dict[#keyPath(conversationTypes)] as? [NSNumber] {
      option.conversationTypes = conversationTypes
    }
    if let onlyUnread = dict[#keyPath(onlyUnread)] as? Bool {
      option.onlyUnread = onlyUnread
    }
    if let conversationGroupIds = dict[#keyPath(conversationGroupIds)] as? [String] {
      option.conversationGroupIds = conversationGroupIds
    }
    return option
  }
}

extension V2NIMConversationResult {
  func toDictionary() -> [String: Any] {
    var dict: [String: Any] = [
      #keyPath(offset): offset,
      #keyPath(finished): finished,
    ]
    var jsonArray: [[String: Any]] = []
    conversationList?.forEach { conversation in
      let json = conversation.toDictionary()
      jsonArray.append(json)
    }
    dict[#keyPath(conversationList)] = jsonArray

    return dict
  }

  /// 从字典中解析出对象
  /// - Parameter dict: 字典
  /// - Returns: 对象
  static func fromDictionary(_ dict: [String: Any]) -> V2NIMConversationResult {
    let result = V2NIMConversationResult()
    if let offset = dict[#keyPath(offset)] as? Int {
      result.setValue(offset, forKey: #keyPath(V2NIMConversationResult.offset))
    }
    if let finished = dict[#keyPath(finished)] as? Bool {
      result.setValue(finished, forKey: #keyPath(V2NIMConversationResult.finished))
    }
    if let jsonArray = dict[#keyPath(conversationList)] as? [[String: Any]] {
      var conversations = [V2NIMConversation]()
      for json in jsonArray {
        let conversation = V2NIMConversation.fromDictionary(json)
        conversations.append(conversation)
      }
      result.setValue(conversations, forKey: #keyPath(V2NIMConversationResult.conversationList))
    }
    return result
  }
}

extension V2NIMError {
  func toDictionary() -> [String: Any] {
    var dict: [String: Any] = [
      #keyPath(code): code,
      #keyPath(desc): desc,
    ]
    return dict
  }
}

extension V2NIMConversationOperationResult {
  func toDictionary() -> [String: Any] {
    let dict: [String: Any] = [
      #keyPath(conversationId): conversationId,
    ]
    return dict
  }

  /// 从字典中解析出对象
  /// - Parameter dict: 字典
  /// - Returns: 对象
  static func fromDictionary(_ dict: [String: Any]) -> V2NIMConversationOperationResult {
    let result = V2NIMConversationOperationResult()
    if let conversationId = dict[#keyPath(conversationId)] as? String {
      result.setValue(conversationId, forKey: #keyPath(V2NIMConversationOperationResult.conversationId))
    }
    return result
  }
}

extension V2NIMConversationUpdate {
  func toDictionary() -> [String: Any] {
    let dict: [String: Any] = [
      #keyPath(serverExtension): serverExtension as Any,
    ]
    return dict
  }

  /// 从字典中解析出对象
  /// - Parameter dict: 字典
  /// - Returns: 对象
  static func fromDictionary(_ dict: [String: Any]) -> V2NIMConversationUpdate {
    let update = V2NIMConversationUpdate()
    if let serverExtension = dict[#keyPath(serverExtension)] as? String {
      update.setValue(serverExtension, forKey: #keyPath(V2NIMConversationUpdate.serverExtension))
    }
    return update
  }
}

extension V2NIMConversationFilter {
  func toDictionary() -> [String: Any] {
    let dict: [String: Any] = [
      #keyPath(conversationTypes): conversationTypes ?? [],
      #keyPath(conversationGroupId): conversationGroupId ?? "",
      #keyPath(ignoreMuted): ignoreMuted,
    ]
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMConversationFilter {
    let filter = V2NIMConversationFilter()
    if let conversationTypes = dict[#keyPath(conversationTypes)] as? [Int] {
      filter.setValue(conversationTypes, forKey: #keyPath(V2NIMConversationFilter.conversationTypes))
    }
    if let conversationGroupId = dict[#keyPath(conversationGroupId)] as? String {
      filter.setValue(conversationGroupId, forKey: #keyPath(V2NIMConversationFilter.conversationGroupId))
    }
    if let ignoreMuted = dict[#keyPath(ignoreMuted)] as? Bool {
      filter.setValue(ignoreMuted, forKey: #keyPath(V2NIMConversationFilter.ignoreMuted))
    }
    return filter
  }
}

extension V2NIMConversationGroupResult {
  func toDictionary() -> [String: Any] {
    var dict: [String: Any] = [
      #keyPath(group): group?.toDictionary() as Any,
    ]
    var jsonArray: [[String: Any]] = []
    failedList?.forEach { object in
      let json = object.toDictionary()
      jsonArray.append(json)
    }
    dict[#keyPath(failedList)] = jsonArray
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMConversationGroupResult {
    let result = V2NIMConversationGroupResult()
    if let groupDic = dict[#keyPath(group)] as? [String: Any] {
      let group = V2NIMConversationGroup.fromDictionary(groupDic)
      result.setValue(group, forKey: #keyPath(V2NIMConversationGroupResult.group))
    }
    if let failedListArray = dict[#keyPath(failedList)] as? [[String: Any]] {
      var failedList = [V2NIMConversationOperationResult]()
      for object in failedListArray {
        let failed = V2NIMConversationOperationResult.fromDictionary(object)
        failedList.append(failed)
      }
      result.setValue(failedList, forKey: #keyPath(V2NIMConversationGroupResult.failedList))
    }
    return result
  }
}
