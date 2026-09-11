// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../method_channel/method_channel_chatroom_service.dart';

abstract class ChatroomServicePlatform extends Service {
  ChatroomServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static ChatroomServicePlatform _instance = MethodChannelChatroomService();

  static ChatroomServicePlatform get instance => _instance;

  static set instance(ChatroomServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 本端发送消息进度回调
  final StreamController<NIMSendMessageProgress> onSendMessageProgress =
      StreamController<NIMSendMessageProgress>.broadcast();

  /// 收到新消息
  Stream<ChatroomReceiveMessagesEvent> get onReceiveMessages;

  /// 本端发送消息状态回调
  Stream<ChatroomSendMessageEvent> get onSendMessage;

  /// 聊天室成员进入
  Stream<ChatroomMemberEnterEvent> get onChatroomMemberEnter;

  /// 聊天室成员离开
  Stream<ChatroomMemberExitEvent> get onChatroomMemberExit;

  ///成员角色更新
  Stream<ChatroomMemberRoleUpdatedEvent> get onChatroomMemberRoleUpdated;

  ///自己的禁言状态变更
  Stream<SelfChatBannedUpdatedEvent> get onSelfChatBannedUpdated;

  ///成员信息更新
  Stream<ChatroomMemberInfoUpdatedEvent> get onChatroomMemberInfoUpdated;

  ///自己的临时禁言状态变更
  Stream<SelfTempChatBannedUpdatedEvent> get onSelfTempChatBannedUpdated;

  ///聊天室信息更新
  Stream<ChatroomInfoUpdatedEvent> get onChatroomInfoUpdated;

  ///消息撤回回调
  Stream<ChatroomMessageRevokedNotificationEvent>
      get onMessageRevokedNotification;

  ///聊天室禁言状态更新
  Stream<ChatroomChatBannedUpdatedEvent> get onChatroomChatBannedUpdated;

  ///更新角色标签
  Stream<ChatroomTagsUpdatedEvent> get onChatroomTagsUpdated;

  /// 发送聊天室消息
  Future<NIMResult<V2NIMSendChatroomMessageResult>> sendMessage(int instanceId,
      V2NIMChatroomMessage message, V2NIMSendChatroomMessageParams params) {
    throw UnimplementedError('sendMessage() is not implemented');
  }

  /// 取消聊天室消息附件上传
  Future<NIMResult<void>> cancelMessageAttachmentUpload(
      int instanceId, V2NIMChatroomMessage message) {
    throw UnimplementedError(
        'cancelMessageAttachmentUpload() is not implemented');
  }

  /// 分页获取聊天室成员列表
  Future<NIMResult<V2NIMChatroomMemberListResult>> getMemberListByOption(
      int instanceId, V2NIMChatroomMemberQueryOption queryOption) {
    throw UnimplementedError('getMemberListByOption() is not implemented');
  }

  /// 查询历史消息
  Future<NIMResult<List<V2NIMChatroomMessage>>> getMessageList(
      int instanceId, V2NIMChatroomMessageListOption option) {
    throw UnimplementedError('getMessageList() is not implemented');
  }

  /// 更新聊天室成员角色
  Future<NIMResult<void>> updateMemberRole(int instanceId, String accountId,
      V2NIMChatroomMemberRoleUpdateParams updateParams) {
    throw UnimplementedError('updateMemberRole() is not implemented');
  }

  /// 设置聊天室成员黑名单状态
  Future<NIMResult<void>> setMemberBlockedStatus(int instanceId,
      String accountId, bool blocked, String? notificationExtension) {
    throw UnimplementedError('setMemberBlockedStatus() is not implemented');
  }

  /// 设置成员禁言状态
  Future<NIMResult<void>> setMemberChatBannedStatus(int instanceId,
      String accountId, bool chatBanned, String? notificationExtension) {
    throw UnimplementedError('setMemberChatBannedStatus() is not implemented');
  }

  /// 设置成员临时禁言状态
  Future<NIMResult<void>> setMemberTempChatBanned(
      int instanceId,
      String accountId,
      int tempChatBannedDuration,
      bool notificationEnabled,
      String? notificationExtension) {
    throw UnimplementedError('setMemberTempChatBanned() is not implemented');
  }

  /// 更新聊天室信息
  Future<NIMResult<void>> updateChatroomInfo(
      int instanceId,
      V2NIMChatroomUpdateParams updateParams,
      NIMAntispamConfig? antispamConfig) {
    throw UnimplementedError('updateChatroomInfo() is not implemented');
  }

  /// 更新聊天室信息
  Future<NIMResult<void>> updateSelfMemberInfo(
      int instanceId,
      V2NIMChatroomSelfMemberUpdateParams updateParams,
      NIMAntispamConfig? antispamConfig) {
    throw UnimplementedError('updateSelfMemberInfo() is not implemented');
  }

  /// 根据账号列表查询成员信息
  Future<NIMResult<List<V2NIMChatroomMember>>> getMemberByIds(
      int instanceId, List<String> accountIds) {
    throw UnimplementedError('getMemberByIds() is not implemented');
  }

  /// 踢出聊天室成员
  Future<NIMResult<void>> kickMember(
      int instanceId, String accountId, String? notificationExtension) {
    throw UnimplementedError('kickMember() is not implemented');
  }

  /// 设置聊天室标签临时禁言
  Future<NIMResult<void>> setTempChatBannedByTag(
      int instanceId, V2NIMChatroomTagTempChatBannedParams params) {
    throw UnimplementedError('setTempChatBannedByTag() is not implemented');
  }

  /// 根据tag查询群成员列表
  Future<NIMResult<V2NIMChatroomMemberListResult>> getMemberListByTag(
      int instanceId, V2NIMChatroomTagMemberOption option) {
    throw UnimplementedError('getMemberListByTag() is not implemented');
  }

  /// 查询某个标签下的成员人数
  Future<NIMResult<int>> getMemberCountByTag(int instanceId, String tag) {
    throw UnimplementedError('getMemberCountByTag() is not implemented');
  }

  /// 更新坐标信息
  Future<NIMResult<void>> updateChatroomLocationInfo(
      int instanceId, V2NIMChatroomLocationConfig locationConfig) {
    throw UnimplementedError('updateChatroomLocationInfo() is not implemented');
  }

  /// 更新聊天室tag信息
  Future<NIMResult<void>> updateChatroomTags(
      int instanceId, V2NIMChatroomTagsUpdateParams updateParams) {
    throw UnimplementedError('updateChatroomTags() is not implemented');
  }

  /// 根据标签查询消息列表
  Future<NIMResult<List<V2NIMChatroomMessage>>> getMessageListByTag(
      int instanceId, V2NIMChatroomTagMessageOption messageOption) {
    throw UnimplementedError('getMessageListByTag() is not implemented');
  }

  ///  添加聊天室监听
  Future<NIMResult<void>> addChatroomListener(int instanceId) {
    throw UnimplementedError('addChatroomListener() is not implemented');
  }

  /// 移除聊天室监听
  Future<NIMResult<void>> removeChatroomListener(int instanceId) {
    throw UnimplementedError('removeChatroomListener() is not implemented');
  }
}
