// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK
import YXAlog_iOS

class FLTChatRoomServiceListener: NSObject {
  private let service: FLTChatRoomService
  private let instanceId: Int

  init(_ service: FLTChatRoomService, _ instanceId: Int) {
    self.service = service
    self.instanceId = instanceId
  }
}

// MARK: - V2NIMChatroomListener

extension FLTChatRoomServiceListener: V2NIMChatroomListener {
  /**
   * 本端发送消息状态回调
   *
   * 来源： 发送消息， 插入消息
   */
  func onSend(_ message: V2NIMChatroomMessage) {
    service.notifyEvent(service.serviceName(), "onSendMessage", ["instanceId": instanceId,
                                                                 "message": message.toDic()])
  }

  /**
   * 收到新消息
   *
   * @param messages 收到的消息内容
   * @see V2NIMChatroomMessage
   */
  func onReceiveMessages(_ messages: [Any]) {
    var messagesMap = [[String: Any]]()
    for message in messages {
      if let message = message as? V2NIMChatroomMessage {
        messagesMap.append(message.toDic())
      }
    }
    service.notifyEvent(service.serviceName(), "onReceiveMessages", ["instanceId": instanceId,
                                                                     "messages": messagesMap])
  }

  /**
   *  聊天室成员进入
   *
   *  @param member 聊天室成员
   */
  func onChatroomMemberEnter(_ member: V2NIMChatroomMember) {
    service.notifyEvent(service.serviceName(), "onChatroomMemberEnter", ["instanceId": instanceId,
                                                                         "member": member.toDic()])
  }

  /**
   *  聊天室成员退出
   *
   *  @param accountId 聊天室成员账号id
   */
  func onChatroomMemberExit(_ accountId: String) {
    service.notifyEvent(service.serviceName(), "onChatroomMemberExit", ["instanceId": instanceId,
                                                                        "accountId": accountId])
  }

  /**
   *  聊天室成员角色更新
   *
   *  @param previousRole 之前的角色类型
   *  @param member 当前的成员信息
   */
  func onChatroomMemberRoleUpdated(_ previousRole: V2NIMChatroomMemberRole, member: V2NIMChatroomMember) {
    service.notifyEvent(service.serviceName(), "onChatroomMemberRoleUpdated", ["instanceId": instanceId,
                                                                               "previousRole": previousRole.rawValue,
                                                                               "member": member.toDic()])
  }

  /**
   *  成员信息更新
   *
   *  @param member 聊天室成员
   */
  func onChatroomMemberInfoUpdated(_ member: V2NIMChatroomMember) {
    service.notifyEvent(service.serviceName(), "onChatroomMemberInfoUpdated", ["instanceId": instanceId,
                                                                               "member": member.toDic()])
  }

  /**
   *  自己的禁言状态变更
   *
   *  @param chatBanned 禁言状态
   */
  func onSelfChatBannedUpdated(_ chatBanned: Bool) {
    service.notifyEvent(service.serviceName(), "onSelfChatBannedUpdated", ["instanceId": instanceId,
                                                                           "chatBanned": chatBanned])
  }

  /**
   *  自己的临时禁言状态变更
   *
   *  @param tempChatBanned 临时禁言状态
   *  @param tempChatBannedDuration 临时禁言时长
   */
  func onSelfTempChatBannedUpdated(_ tempChatBanned: Bool, tempChatBannedDuration: Int) {
    service.notifyEvent(service.serviceName(), "onSelfTempChatBannedUpdated", ["instanceId": instanceId,
                                                                               "tempChatBanned": tempChatBanned,
                                                                               "tempChatBannedDuration": tempChatBannedDuration])
  }

  /**
   *  聊天室信息已更新
   *
   *  @param chatroomInfo 更新后的聊天室信息
   */
  func onChatroomInfoUpdated(_ chatroomInfo: V2NIMChatroomInfo) {
    service.notifyEvent(service.serviceName(), "onChatroomInfoUpdated", ["instanceId": instanceId,
                                                                         "info": chatroomInfo.toDic()])
  }

  /**
   *  聊天室整体禁言状态更新
   *
   *  @param chatBanned 禁言状态
   */
  func onChatroomChatBannedUpdated(_ chatBanned: Bool) {
    service.notifyEvent(service.serviceName(), "onChatroomChatBannedUpdated", ["instanceId": instanceId,
                                                                               "chatBanned": chatBanned])
  }

  /**
   *  消息撤回
   *
   *  @param messageClientId 被撤回消息的客户端id
   *  @param messageTime 被撤回消息的时间
   */
  func onMessageRevokedNotification(_ messageClientId: String, messageTime: TimeInterval) {
    service.notifyEvent(service.serviceName(), "onMessageRevokedNotification", ["instanceId": instanceId,
                                                                                "messageClientId": messageClientId,
                                                                                "messageTime": messageTime * 1000])
  }

  /**
   *  更新角色标签
   *
   *  @param tags 更新后的标签
   */
  func onChatroomTagsUpdated(_ tags: [String]) {
    service.notifyEvent(service.serviceName(), "onChatroomTagsUpdated", ["instanceId": instanceId,
                                                                         "tags": tags])
  }
}
