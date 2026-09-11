// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

class MethodChannelChatroomService extends ChatroomServicePlatform {
  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onSendMessageProgress':
        var messageProgress = NIMSendMessageProgress.fromJson(
            Map<String, dynamic>.from(arguments));
        MessageServicePlatform.instance.onSendMessageProgress
            .add(messageProgress);
        break;
      case 'onReceiveMessages':
        assert(arguments is Map);
        _onReceiveMessagesController.add(ChatroomReceiveMessagesEvent.fromJson(
            Map<String, dynamic>.from(arguments)));
        break;
      case 'onSendMessage':
        assert(arguments is Map);
        _onSendMessageController.add(ChatroomSendMessageEvent.fromJson(
            Map<String, dynamic>.from(arguments)));
        break;
      case 'onChatroomMemberEnter':
        assert(arguments is Map);
        _onChatroomMemberEnterController.add(ChatroomMemberEnterEvent.fromJson(
            Map<String, dynamic>.from(arguments)));
        break;
      case 'onChatroomMemberExit':
        assert(arguments is Map);
        _onChatroomMemberExitController.add(ChatroomMemberExitEvent.fromJson(
            Map<String, dynamic>.from(arguments)));
        break;
      case 'onChatroomMemberRoleUpdated':
        assert(arguments is Map);
        _onChatroomMemberRoleUpdatedController.add(
            ChatroomMemberRoleUpdatedEvent.fromJson(
                Map<String, dynamic>.from(arguments)));
        break;

      case 'onSelfChatBannedUpdated':
        assert(arguments is Map);
        _onSelfChatBannedUpdatedController.add(
            SelfChatBannedUpdatedEvent.fromJson(
                Map<String, dynamic>.from(arguments)));
        break;

      case 'onChatroomMemberInfoUpdated':
        assert(arguments is Map);
        _onChatroomMemberInfoUpdatedController.add(
            ChatroomMemberInfoUpdatedEvent.fromJson(
                Map<String, dynamic>.from(arguments)));
        break;

      case 'onSelfTempChatBannedUpdated':
        assert(arguments is Map);
        _onSelfTempChatBannedUpdatedController.add(
            SelfTempChatBannedUpdatedEvent.fromJson(
                Map<String, dynamic>.from(arguments)));
        break;

      case 'onChatroomInfoUpdated':
        assert(arguments is Map);
        _onChatroomInfoUpdatedController.add(ChatroomInfoUpdatedEvent.fromJson(
            Map<String, dynamic>.from(arguments)));
        break;

      case 'onMessageRevokedNotification':
        assert(arguments is Map);
        _onMessageRevokedNotificationController.add(
            ChatroomMessageRevokedNotificationEvent.fromJson(
                Map<String, dynamic>.from(arguments)));
        break;

      case 'onChatroomChatBannedUpdated':
        assert(arguments is Map);
        _onChatroomChatBannedUpdatedController.add(
            ChatroomChatBannedUpdatedEvent.fromJson(
                Map<String, dynamic>.from(arguments)));
        break;

      case 'onChatroomTagsUpdated':
        assert(arguments is Map);
        _onChatroomTagsUpdatedController.add(ChatroomTagsUpdatedEvent.fromJson(
            Map<String, dynamic>.from(arguments)));
        break;
      default:
        throw UnimplementedError();
    }
    return Future.value();
  }

  @override
  String get serviceName => 'V2NIMChatroomService';

  /// 发送聊天室消息
  Future<NIMResult<V2NIMSendChatroomMessageResult>> sendMessage(
      int instanceId,
      V2NIMChatroomMessage message,
      V2NIMSendChatroomMessageParams params) async {
    return NIMResult.fromMap(
        await invokeMethod('sendMessage', arguments: {
          'instanceId': instanceId,
          'message': message.toJson(),
          'params': params.toJson()
        }),
        convert: (json) => V2NIMSendChatroomMessageResult.fromJson(json));
  }

  /// 取消聊天室消息附件上传
  Future<NIMResult<void>> cancelMessageAttachmentUpload(
      int instanceId, V2NIMChatroomMessage message) async {
    return NIMResult.fromMap(await invokeMethod('cancelMessageAttachmentUpload',
        arguments: {'instanceId': instanceId, 'message': message.toJson()}));
  }

  /// 分页获取聊天室成员列表
  Future<NIMResult<V2NIMChatroomMemberListResult>> getMemberListByOption(
      int instanceId, V2NIMChatroomMemberQueryOption queryOption) async {
    return NIMResult.fromMap(
        await invokeMethod('getMemberListByOption', arguments: {
          'instanceId': instanceId,
          'queryOption': queryOption.toJson()
        }),
        convert: (json) => V2NIMChatroomMemberListResult.fromJson(json));
  }

  /// 查询历史消息
  Future<NIMResult<List<V2NIMChatroomMessage>>> getMessageList(
      int instanceId, V2NIMChatroomMessageListOption option) async {
    return NIMResult.fromMap(
        await invokeMethod('getMessageList',
            arguments: {'instanceId': instanceId, 'option': option.toJson()}),
        convert: (json) => (json['messageList'] as List<dynamic>?)
            ?.map((e) => V2NIMChatroomMessage.fromJson(
                (e as Map).cast<String, dynamic>()))
            .toList());
  }

  /// 更新聊天室成员角色
  Future<NIMResult<void>> updateMemberRole(int instanceId, String accountId,
      V2NIMChatroomMemberRoleUpdateParams updateParams) async {
    return NIMResult.fromMap(await invokeMethod('updateMemberRole', arguments: {
      'instanceId': instanceId,
      'accountId': accountId,
      'updateParams': updateParams.toJson()
    }));
  }

  /// 设置聊天室成员黑名单状态
  Future<NIMResult<void>> setMemberBlockedStatus(int instanceId,
      String accountId, bool blocked, String? notificationExtension) async {
    return NIMResult.fromMap(
        await invokeMethod('setMemberBlockedStatus', arguments: {
      'instanceId': instanceId,
      'accountId': accountId,
      'blocked': blocked,
      'notificationExtension': notificationExtension
    }));
  }

  /// 设置成员禁言状态
  Future<NIMResult<void>> setMemberChatBannedStatus(int instanceId,
      String accountId, bool chatBanned, String? notificationExtension) async {
    return NIMResult.fromMap(
        await invokeMethod('setMemberChatBannedStatus', arguments: {
      'instanceId': instanceId,
      'accountId': accountId,
      'notificationExtension': notificationExtension,
      'chatBanned': chatBanned
    }));
  }

  /// 设置成员临时禁言状态
  Future<NIMResult<void>> setMemberTempChatBanned(
      int instanceId,
      String accountId,
      int tempChatBannedDuration,
      bool notificationEnabled,
      String? notificationExtension) async {
    return NIMResult.fromMap(
        await invokeMethod('setMemberTempChatBanned', arguments: {
      'instanceId': instanceId,
      'accountId': accountId,
      'notificationExtension': notificationExtension,
      'tempChatBannedDuration': tempChatBannedDuration,
      'notificationEnabled': notificationEnabled
    }));
  }

  /// 更新聊天室信息
  Future<NIMResult<void>> updateChatroomInfo(
      int instanceId,
      V2NIMChatroomUpdateParams updateParams,
      NIMAntispamConfig? antispamConfig) async {
    return NIMResult.fromMap(
        await invokeMethod('updateChatroomInfo', arguments: {
      'instanceId': instanceId,
      'updateParams': updateParams.toJson(),
      'antispamConfig': antispamConfig?.toJson()
    }));
  }

  /// 更新聊天室信息
  Future<NIMResult<void>> updateSelfMemberInfo(
      int instanceId,
      V2NIMChatroomSelfMemberUpdateParams updateParams,
      NIMAntispamConfig? antispamConfig) async {
    return NIMResult.fromMap(
        await invokeMethod('updateSelfMemberInfo', arguments: {
      'instanceId': instanceId,
      'updateParams': updateParams.toJson(),
      'antispamConfig': antispamConfig?.toJson()
    }));
  }

  /// 根据账号列表查询成员信息
  Future<NIMResult<List<V2NIMChatroomMember>>> getMemberByIds(
      int instanceId, List<String> accountIds) async {
    return NIMResult.fromMap(
        await invokeMethod('getMemberByIds',
            arguments: {'instanceId': instanceId, 'accountIds': accountIds}),
        convert: (json) => (json['memberList'] as List<dynamic>?)
            ?.map((e) => V2NIMChatroomMember.fromJson(
                (e as Map).cast<String, dynamic>()))
            .toList());
  }

  /// 踢出聊天室成员
  Future<NIMResult<void>> kickMember(
      int instanceId, String accountId, String? notificationExtension) async {
    return NIMResult.fromMap(await invokeMethod('kickMember', arguments: {
      'instanceId': instanceId,
      'accountId': accountId,
      'notificationExtension': notificationExtension
    }));
  }

  /// 设置聊天室标签临时禁言
  Future<NIMResult<void>> setTempChatBannedByTag(
      int instanceId, V2NIMChatroomTagTempChatBannedParams params) async {
    return NIMResult.fromMap(await invokeMethod('setTempChatBannedByTag',
        arguments: {'instanceId': instanceId, 'params': params.toJson()}));
  }

  /// 根据tag查询群成员列表
  Future<NIMResult<V2NIMChatroomMemberListResult>> getMemberListByTag(
      int instanceId, V2NIMChatroomTagMemberOption option) async {
    return NIMResult.fromMap(
        await invokeMethod('getMemberListByTag',
            arguments: {'instanceId': instanceId, 'option': option.toJson()}),
        convert: (json) => V2NIMChatroomMemberListResult.fromJson(json));
  }

  /// 查询某个标签下的成员人数
  Future<NIMResult<int>> getMemberCountByTag(int instanceId, String tag) async {
    return NIMResult.fromMap(
        await invokeMethod('getMemberCountByTag',
            arguments: {'instanceId': instanceId, 'tag': tag}),
        convert: (json) => json['memberCount'] as int);
  }

  /// 更新坐标信息
  Future<NIMResult<void>> updateChatroomLocationInfo(
      int instanceId, V2NIMChatroomLocationConfig locationConfig) async {
    return NIMResult.fromMap(await invokeMethod('updateChatroomLocationInfo',
        arguments: {
          'instanceId': instanceId,
          'locationConfig': locationConfig.toJson()
        }));
  }

  /// 更新聊天室tag信息
  Future<NIMResult<void>> updateChatroomTags(
      int instanceId, V2NIMChatroomTagsUpdateParams updateParams) async {
    return NIMResult.fromMap(await invokeMethod('updateChatroomTags',
        arguments: {
          'instanceId': instanceId,
          'updateParams': updateParams.toJson()
        }));
  }

  /// 根据标签查询消息列表
  Future<NIMResult<List<V2NIMChatroomMessage>>> getMessageListByTag(
      int instanceId, V2NIMChatroomTagMessageOption messageOption) async {
    return NIMResult.fromMap(
        await invokeMethod('getMessageListByTag', arguments: {
          'instanceId': instanceId,
          'messageOption': messageOption.toJson()
        }),
        convert: (json) => (json['messageList'] as List<dynamic>?)
            ?.map((e) => V2NIMChatroomMessage.fromJson(
                (e as Map).cast<String, dynamic>()))
            .toList());
  }

  ///  添加聊天室监听
  Future<NIMResult<void>> addChatroomListener(int instanceId) async {
    return NIMResult.fromMap(await invokeMethod('addChatroomListener',
        arguments: {'instanceId': instanceId}));
  }

  /// 移除聊天室监听
  Future<NIMResult<void>> removeChatroomListener(int instanceId) async {
    return NIMResult.fromMap(await invokeMethod('removeChatroomListener',
        arguments: {'instanceId': instanceId}));
  }

  final _onReceiveMessagesController =
      StreamController<ChatroomReceiveMessagesEvent>.broadcast();
  Stream<ChatroomReceiveMessagesEvent> get onReceiveMessages =>
      _onReceiveMessagesController.stream;

  final _onSendMessageController =
      StreamController<ChatroomSendMessageEvent>.broadcast();
  Stream<ChatroomSendMessageEvent> get onSendMessage =>
      _onSendMessageController.stream;

  final _onChatroomMemberEnterController =
      StreamController<ChatroomMemberEnterEvent>.broadcast();
  Stream<ChatroomMemberEnterEvent> get onChatroomMemberEnter =>
      _onChatroomMemberEnterController.stream;

  final _onChatroomMemberExitController =
      StreamController<ChatroomMemberExitEvent>.broadcast();
  Stream<ChatroomMemberExitEvent> get onChatroomMemberExit =>
      _onChatroomMemberExitController.stream;

  final _onChatroomMemberRoleUpdatedController =
      StreamController<ChatroomMemberRoleUpdatedEvent>.broadcast();
  Stream<ChatroomMemberRoleUpdatedEvent> get onChatroomMemberRoleUpdated =>
      _onChatroomMemberRoleUpdatedController.stream;

  final _onSelfChatBannedUpdatedController =
      StreamController<SelfChatBannedUpdatedEvent>.broadcast();
  Stream<SelfChatBannedUpdatedEvent> get onSelfChatBannedUpdated =>
      _onSelfChatBannedUpdatedController.stream;

  final _onChatroomMemberInfoUpdatedController =
      StreamController<ChatroomMemberInfoUpdatedEvent>.broadcast();
  Stream<ChatroomMemberInfoUpdatedEvent> get onChatroomMemberInfoUpdated =>
      _onChatroomMemberInfoUpdatedController.stream;

  final _onSelfTempChatBannedUpdatedController =
      StreamController<SelfTempChatBannedUpdatedEvent>.broadcast();
  Stream<SelfTempChatBannedUpdatedEvent> get onSelfTempChatBannedUpdated =>
      _onSelfTempChatBannedUpdatedController.stream;

  final _onChatroomInfoUpdatedController =
      StreamController<ChatroomInfoUpdatedEvent>.broadcast();
  Stream<ChatroomInfoUpdatedEvent> get onChatroomInfoUpdated =>
      _onChatroomInfoUpdatedController.stream;

  final _onMessageRevokedNotificationController =
      StreamController<ChatroomMessageRevokedNotificationEvent>.broadcast();
  Stream<ChatroomMessageRevokedNotificationEvent>
      get onMessageRevokedNotification =>
          _onMessageRevokedNotificationController.stream;

  final _onChatroomChatBannedUpdatedController =
      StreamController<ChatroomChatBannedUpdatedEvent>.broadcast();
  Stream<ChatroomChatBannedUpdatedEvent> get onChatroomChatBannedUpdated =>
      _onChatroomChatBannedUpdatedController.stream;

  final _onChatroomTagsUpdatedController =
      StreamController<ChatroomTagsUpdatedEvent>.broadcast();
  Stream<ChatroomTagsUpdatedEvent> get onChatroomTagsUpdated =>
      _onChatroomTagsUpdatedController.stream;
}
