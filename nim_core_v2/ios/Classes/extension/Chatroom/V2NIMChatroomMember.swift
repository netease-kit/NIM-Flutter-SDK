// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomMember {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomMember {
    let member = V2NIMChatroomMember()

    if let roomId = arguments["roomId"] as? String {
      member.setValue(roomId,
                      forKeyPath: #keyPath(V2NIMChatroomMember.roomId))
    }

    if let accountId = arguments["accountId"] as? String {
      member.setValue(accountId,
                      forKeyPath: #keyPath(V2NIMChatroomMember.accountId))
    }

    if let memberRole = arguments["memberRole"] as? Int,
       let memberRole = V2NIMChatroomMemberRole(rawValue: memberRole) {
      member.setValue(memberRole.rawValue,
                      forKeyPath: #keyPath(V2NIMChatroomMember.memberRole))
    }

    if let memberLevel = arguments["memberLevel"] as? Int {
      member.setValue(memberLevel,
                      forKeyPath: #keyPath(V2NIMChatroomMember.memberLevel))
    }

    if let roomNick = arguments["roomNick"] as? String {
      member.setValue(roomNick,
                      forKeyPath: #keyPath(V2NIMChatroomMember.roomNick))
    }

    if let roomAvatar = arguments["roomAvatar"] as? String {
      member.setValue(roomAvatar,
                      forKeyPath: #keyPath(V2NIMChatroomMember.roomAvatar))
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      member.setValue(serverExtension,
                      forKeyPath: #keyPath(V2NIMChatroomMember.serverExtension))
    }

    if let isOnline = arguments["isOnline"] as? Bool {
      member.setValue(isOnline,
                      forKeyPath: #keyPath(V2NIMChatroomMember.isOnline))
    }

    if let blocked = arguments["blocked"] as? Bool {
      member.setValue(blocked,
                      forKeyPath: #keyPath(V2NIMChatroomMember.blocked))
    }

    if let chatBanned = arguments["chatBanned"] as? Bool {
      member.setValue(chatBanned,
                      forKeyPath: #keyPath(V2NIMChatroomMember.chatBanned))
    }

    if let tempChatBanned = arguments["tempChatBanned"] as? Bool {
      member.setValue(tempChatBanned,
                      forKeyPath: #keyPath(V2NIMChatroomMember.tempChatBanned))
    }

    if let tempChatBannedDuration = arguments["tempChatBannedDuration"] as? Int {
      member.setValue(tempChatBannedDuration,
                      forKeyPath: #keyPath(V2NIMChatroomMember.tempChatBannedDuration))
    }

    if let tags = arguments["tags"] as? [String] {
      member.setValue(tags,
                      forKeyPath: #keyPath(V2NIMChatroomMember.tags))
    }

    if let notifyTargetTags = arguments["notifyTargetTags"] as? String {
      member.setValue(notifyTargetTags,
                      forKeyPath: #keyPath(V2NIMChatroomMember.notifyTargetTags))
    }

    if let enterTime = arguments["enterTime"] as? Int {
      member.setValue(enterTime / 1000,
                      forKeyPath: #keyPath(V2NIMChatroomMember.enterTime))
    }

    if let updateTime = arguments["updateTime"] as? Int {
      member.setValue(updateTime / 1000,
                      forKeyPath: #keyPath(V2NIMChatroomMember.updateTime))
    }

    if let valid = arguments["valid"] as? Bool {
      member.setValue(valid,
                      forKeyPath: #keyPath(V2NIMChatroomMember.valid))
    }

    if let multiEnterInfoList = arguments["multiEnterInfo"] as? [[String: Any]] {
      let multiEnterInfo = multiEnterInfoList.map { V2NIMChatroomEnterInfo.fromDic($0) }
      member.setValue(multiEnterInfo,
                      forKeyPath: #keyPath(V2NIMChatroomMember.multiEnterInfo))
    }

    return member
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(roomId)] = roomId
    keyPaths[#keyPath(accountId)] = accountId
    keyPaths[#keyPath(memberRole)] = memberRole.rawValue
    keyPaths[#keyPath(roomId)] = roomId
    keyPaths[#keyPath(memberLevel)] = memberLevel
    keyPaths[#keyPath(roomNick)] = roomNick
    keyPaths[#keyPath(roomAvatar)] = roomAvatar
    keyPaths[#keyPath(serverExtension)] = serverExtension
    keyPaths[#keyPath(isOnline)] = isOnline
    keyPaths[#keyPath(blocked)] = blocked
    keyPaths[#keyPath(chatBanned)] = chatBanned
    keyPaths[#keyPath(tempChatBanned)] = tempChatBanned
    keyPaths[#keyPath(tempChatBannedDuration)] = tempChatBannedDuration
    keyPaths[#keyPath(tags)] = tags
    keyPaths[#keyPath(notifyTargetTags)] = notifyTargetTags
    keyPaths[#keyPath(enterTime)] = enterTime * 1000
    keyPaths[#keyPath(updateTime)] = updateTime * 1000
    keyPaths[#keyPath(valid)] = valid

    if let multiEnterInfo = multiEnterInfo {
      var multiEnterInfoList = [[String: Any]]()
      for info in multiEnterInfo {
        if let info = info as? V2NIMChatroomEnterInfo {
          multiEnterInfoList.append(info.toDic())
        }
      }
      keyPaths[#keyPath(V2NIMChatroomMember.multiEnterInfo)] = multiEnterInfoList
    }
    return keyPaths
  }
}
