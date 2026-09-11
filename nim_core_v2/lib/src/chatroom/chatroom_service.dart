// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

class V2NIMChatroomService {
  int instanceId;

  V2NIMChatroomService(this.instanceId);

  /// 本端发送消息进度回调
  @HawkApi(ignore: true)
  Stream<NIMSendMessageProgress> get onSendMessageProgress =>
      ChatroomServicePlatform.instance.onSendMessageProgress.stream;

  ChatroomServicePlatform get _platform => ChatroomServicePlatform.instance;

  /// 收到新消息
  Stream<ChatroomReceiveMessagesEvent> get onReceiveMessages =>
      _onReceiveMessagesController.stream;

  /// 本端发送消息状态回调
  Stream<ChatroomSendMessageEvent> get onSendMessage =>
      _onSendMessageController.stream;

  /// 聊天室成员进入
  Stream<ChatroomMemberEnterEvent> get onChatroomMemberEnter =>
      _onChatroomMemberEnterController.stream;

  /// 聊天室成员离开
  Stream<ChatroomMemberExitEvent> get onChatroomMemberExit =>
      _onChatroomMemberExitController.stream;

  ///成员角色更新
  Stream<ChatroomMemberRoleUpdatedEvent> get onChatroomMemberRoleUpdated =>
      _onChatroomMemberRoleUpdatedController.stream;

  ///自己的禁言状态变更
  Stream<SelfChatBannedUpdatedEvent> get onSelfChatBannedUpdated =>
      _onSelfChatBannedUpdatedController.stream;

  ///成员信息更新
  Stream<ChatroomMemberInfoUpdatedEvent> get onChatroomMemberInfoUpdated =>
      _onChatroomMemberInfoUpdatedController.stream;

  ///自己的临时禁言状态变更
  Stream<SelfTempChatBannedUpdatedEvent> get onSelfTempChatBannedUpdated =>
      _onSelfTempChatBannedUpdatedController.stream;

  ///聊天室信息更新
  Stream<ChatroomInfoUpdatedEvent> get onChatroomInfoUpdated =>
      _onChatroomInfoUpdatedController.stream;

  ///消息撤回回调
  Stream<ChatroomMessageRevokedNotificationEvent>
      get onMessageRevokedNotification =>
          _onMessageRevokedNotificationController.stream;

  /// 聊天室禁言状态更新
  Stream<ChatroomChatBannedUpdatedEvent> get onChatroomChatBannedUpdated =>
      _onChatroomChatBannedUpdatedController.stream;

  ///更新角色标签
  Stream<ChatroomTagsUpdatedEvent> get onChatroomTagsUpdated =>
      _onChatroomTagsUpdatedController.stream;

  final _onReceiveMessagesController =
      StreamController<ChatroomReceiveMessagesEvent>.broadcast();

  final _onSendMessageController =
      StreamController<ChatroomSendMessageEvent>.broadcast();

  final _onChatroomMemberEnterController =
      StreamController<ChatroomMemberEnterEvent>.broadcast();

  final _onChatroomMemberExitController =
      StreamController<ChatroomMemberExitEvent>.broadcast();

  final _onChatroomMemberRoleUpdatedController =
      StreamController<ChatroomMemberRoleUpdatedEvent>.broadcast();

  final _onSelfChatBannedUpdatedController =
      StreamController<SelfChatBannedUpdatedEvent>.broadcast();

  final _onChatroomMemberInfoUpdatedController =
      StreamController<ChatroomMemberInfoUpdatedEvent>.broadcast();

  final _onSelfTempChatBannedUpdatedController =
      StreamController<SelfTempChatBannedUpdatedEvent>.broadcast();

  final _onChatroomInfoUpdatedController =
      StreamController<ChatroomInfoUpdatedEvent>.broadcast();

  final _onMessageRevokedNotificationController =
      StreamController<ChatroomMessageRevokedNotificationEvent>.broadcast();

  final _onChatroomChatBannedUpdatedController =
      StreamController<ChatroomChatBannedUpdatedEvent>.broadcast();

  final _onChatroomTagsUpdatedController =
      StreamController<ChatroomTagsUpdatedEvent>.broadcast();

  @HawkApi(ignore: true)
  List<StreamSubscription> _listeners = [];

  /// 发送聊天室消息
  Future<NIMResult<V2NIMSendChatroomMessageResult>> sendMessage(
      V2NIMChatroomMessage message, V2NIMSendChatroomMessageParams params) {
    return _platform.sendMessage(instanceId, message, params);
  }

  /// 取消聊天室消息附件上传
  Future<NIMResult<void>> cancelMessageAttachmentUpload(
      V2NIMChatroomMessage message) {
    return _platform.cancelMessageAttachmentUpload(instanceId, message);
  }

  /// 分页获取聊天室成员列表
  Future<NIMResult<V2NIMChatroomMemberListResult>> getMemberListByOption(
      V2NIMChatroomMemberQueryOption queryOption) {
    return _platform.getMemberListByOption(instanceId, queryOption);
  }

  /// 查询历史消息
  Future<NIMResult<List<V2NIMChatroomMessage>>> getMessageList(
      V2NIMChatroomMessageListOption option) {
    return _platform.getMessageList(instanceId, option);
  }

  /// 更新聊天室成员角色
  Future<NIMResult<void>> updateMemberRole(
      String accountId, V2NIMChatroomMemberRoleUpdateParams updateParams) {
    return _platform.updateMemberRole(instanceId, accountId, updateParams);
  }

  /// 设置聊天室成员黑名单状态
  Future<NIMResult<void>> setMemberBlockedStatus(String accountId, bool blocked,
      {String? notificationExtension}) {
    return _platform.setMemberBlockedStatus(
        instanceId, accountId, blocked, notificationExtension);
  }

  /// 设置成员禁言状态
  Future<NIMResult<void>> setMemberChatBannedStatus(
      String accountId, bool chatBanned,
      {String? notificationExtension}) {
    return _platform.setMemberChatBannedStatus(
        instanceId, accountId, chatBanned, notificationExtension);
  }

  /// 设置成员临时禁言状态
  Future<NIMResult<void>> setMemberTempChatBanned(
      String accountId, int tempChatBannedDuration, bool notificationEnabled,
      {String? notificationExtension}) {
    return this._platform.setMemberTempChatBanned(instanceId, accountId,
        tempChatBannedDuration, notificationEnabled, notificationExtension);
  }

  /// 更新聊天室信息
  Future<NIMResult<void>> updateChatroomInfo(
      V2NIMChatroomUpdateParams updateParams,
      NIMAntispamConfig? antispamConfig) {
    return _platform.updateChatroomInfo(
        instanceId, updateParams, antispamConfig);
  }

  /// 更新聊天室信息
  Future<NIMResult<void>> updateSelfMemberInfo(
      V2NIMChatroomSelfMemberUpdateParams updateParams,
      NIMAntispamConfig? antispamConfig) {
    return _platform.updateSelfMemberInfo(
        instanceId, updateParams, antispamConfig);
  }

  /// 根据账号列表查询成员信息
  Future<NIMResult<List<V2NIMChatroomMember>>> getMemberByIds(
      List<String> accountIds) {
    return _platform.getMemberByIds(instanceId, accountIds);
  }

  /// 踢出聊天室成员
  Future<NIMResult<void>> kickMember(String accountId,
      {String? notificationExtension}) {
    return _platform.kickMember(instanceId, accountId, notificationExtension);
  }

  /// 设置聊天室标签临时禁言
  Future<NIMResult<void>> setTempChatBannedByTag(
      V2NIMChatroomTagTempChatBannedParams params) {
    return _platform.setTempChatBannedByTag(instanceId, params);
  }

  /// 根据tag查询群成员列表
  Future<NIMResult<V2NIMChatroomMemberListResult>> getMemberListByTag(
      V2NIMChatroomTagMemberOption option) {
    return _platform.getMemberListByTag(instanceId, option);
  }

  /// 查询某个标签下的成员人数
  Future<NIMResult<int>> getMemberCountByTag(String tag) {
    return _platform.getMemberCountByTag(instanceId, tag);
  }

  /// 更新坐标信息
  Future<NIMResult<void>> updateChatroomLocationInfo(
      V2NIMChatroomLocationConfig locationConfig) {
    return _platform.updateChatroomLocationInfo(instanceId, locationConfig);
  }

  /// 更新聊天室tag信息
  Future<NIMResult<void>> updateChatroomTags(
      V2NIMChatroomTagsUpdateParams updateParams) {
    return _platform.updateChatroomTags(instanceId, updateParams);
  }

  /// 根据标签查询消息列表
  Future<NIMResult<List<V2NIMChatroomMessage>>> getMessageListByTag(
      V2NIMChatroomTagMessageOption messageOption) {
    return _platform.getMessageListByTag(instanceId, messageOption);
  }

  ///  添加聊天室监听
  Future<NIMResult<void>> addChatroomListener() {
    return _platform.addChatroomListener(instanceId).then((result) {
      if (result.isSuccess) {
        _listeners.addAll([
          _platform.onChatroomMemberEnter.listen((event) {
            if (event.instanceId == instanceId) {
              _onChatroomMemberEnterController.add(event);
            }
          }),
          _platform.onChatroomMemberExit.listen((event) {
            if (event.instanceId == instanceId) {
              _onChatroomMemberExitController.add(event);
            }
          }),
          _platform.onChatroomMemberRoleUpdated.listen((event) {
            if (event.instanceId == instanceId) {
              _onChatroomMemberRoleUpdatedController.add(event);
            }
          }),
          _platform.onChatroomInfoUpdated.listen((event) {
            if (event.instanceId == instanceId) {
              _onChatroomInfoUpdatedController.add(event);
            }
          }),
          _platform.onChatroomTagsUpdated.listen((event) {
            if (event.instanceId == instanceId) {
              _onChatroomTagsUpdatedController.add(event);
            }
          }),
          _platform.onSelfChatBannedUpdated.listen((event) {
            if (event.instanceId == instanceId) {
              _onSelfChatBannedUpdatedController.add(event);
            }
          }),
          _platform.onSelfTempChatBannedUpdated.listen((event) {
            if (event.instanceId == instanceId) {
              _onSelfTempChatBannedUpdatedController.add(event);
            }
          }),
          _platform.onMessageRevokedNotification.listen((event) {
            if (event.instanceId == instanceId) {
              _onMessageRevokedNotificationController.add(event);
            }
          }),
          _platform.onChatroomMemberInfoUpdated.listen((event) {
            if (event.instanceId == instanceId) {
              _onChatroomMemberInfoUpdatedController.add(event);
            }
          }),
          _platform.onChatroomChatBannedUpdated.listen((event) {
            if (event.instanceId == instanceId) {
              _onChatroomChatBannedUpdatedController.add(event);
            }
          }),
          _platform.onSendMessage.listen((event) {
            if (event.instanceId == instanceId) {
              _onSendMessageController.add(event);
            }
          }),
          _platform.onReceiveMessages.listen((event) {
            if (event.instanceId == instanceId) {
              _onReceiveMessagesController.add(event);
            }
          })
        ]);
      }
      return result;
    });
  }

  /// 移除聊天室监听
  Future<NIMResult<void>> removeChatroomListener() {
    return _platform.removeChatroomListener(instanceId).then((result) {
      if (result.isSuccess) {
        _listeners.forEach((e) => e.cancel());
        _listeners.clear();
      }
      return result;
    });
  }
}
