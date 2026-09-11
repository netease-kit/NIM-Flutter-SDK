// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

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
      #keyPath(lastReadTime): lastReadTime * 1000.0,
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
    if let type = dict[#keyPath(type)] as? Int,
       let type = V2NIMConversationType(rawValue: type) {
      conversation.setValue(type.rawValue, forKey: #keyPath(V2NIMConversation.type))
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
      conversation.setValue(TimeInterval(createTime / 1000), forKey: #keyPath(V2NIMConversation.createTime))
    }
    if let updateTime = dict[#keyPath(updateTime)] as? Int {
      conversation.setValue(TimeInterval(updateTime / 1000), forKey: #keyPath(V2NIMConversation.updateTime))
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
