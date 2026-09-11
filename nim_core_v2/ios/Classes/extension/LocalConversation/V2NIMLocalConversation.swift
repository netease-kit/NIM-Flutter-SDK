// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMLocalConversation {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(conversationId)] = conversationId
    keyPaths[#keyPath(type)] = type.rawValue
    keyPaths[#keyPath(name)] = name
    keyPaths[#keyPath(avatar)] = avatar
    keyPaths[#keyPath(mute)] = mute
    keyPaths[#keyPath(stickTop)] = stickTop
    keyPaths[#keyPath(localExtension)] = localExtension
    keyPaths[#keyPath(unreadCount)] = unreadCount
    keyPaths[#keyPath(createTime)] = createTime * 1000.0
    keyPaths[#keyPath(updateTime)] = updateTime * 1000.0
    keyPaths[#keyPath(sortOrder)] = sortOrder
    keyPaths[#keyPath(lastMessage)] = lastMessage?.toDictionary()
    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ dict: [String: Any]) -> V2NIMLocalConversation {
    let conversation = V2NIMLocalConversation()

    if let conversationId = dict[#keyPath(conversationId)] as? String {
      conversation.setValue(conversationId, forKey: #keyPath(V2NIMLocalConversation.conversationId))
    }

    if let type = dict[#keyPath(type)] as? Int,
       let type = V2NIMConversationType(rawValue: type) {
      conversation.setValue(type.rawValue, forKey: #keyPath(V2NIMLocalConversation.type))
    }

    if let name = dict[#keyPath(name)] as? String {
      conversation.setValue(name, forKey: #keyPath(V2NIMLocalConversation.name))
    }

    if let avatar = dict[#keyPath(avatar)] as? String {
      conversation.setValue(avatar, forKey: #keyPath(V2NIMLocalConversation.avatar))
    }

    if let mute = dict[#keyPath(mute)] as? Bool {
      conversation.setValue(mute, forKey: #keyPath(V2NIMLocalConversation.mute))
    }

    if let stickTop = dict[#keyPath(stickTop)] as? Bool {
      conversation.setValue(stickTop, forKey: #keyPath(V2NIMLocalConversation.stickTop))
    }

    if let localExtension = dict[#keyPath(localExtension)] as? String {
      conversation.setValue(localExtension, forKey: #keyPath(V2NIMLocalConversation.localExtension))
    }

    if let unreadCount = dict[#keyPath(unreadCount)] as? Int {
      conversation.setValue(unreadCount, forKey: #keyPath(V2NIMLocalConversation.unreadCount))
    }

    if let createTime = dict[#keyPath(createTime)] as? Int {
      conversation.setValue(TimeInterval(createTime / 1000), forKey: #keyPath(V2NIMLocalConversation.createTime))
    }

    if let updateTime = dict[#keyPath(updateTime)] as? Int {
      conversation.setValue(TimeInterval(updateTime / 1000), forKey: #keyPath(V2NIMLocalConversation.updateTime))
    }

    if let sortOrder = dict[#keyPath(sortOrder)] as? Int {
      conversation.setValue(sortOrder, forKey: #keyPath(V2NIMLocalConversation.sortOrder))
    }

    if let lastMessageDic = dict[#keyPath(lastMessage)] as? [String: Any] {
      let lastMessage = V2NIMLastMessage.fromDictionary(lastMessageDic)
      conversation.setValue(lastMessage, forKey: #keyPath(V2NIMLocalConversation.lastMessage))
    }

    return conversation
  }
}
