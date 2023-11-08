// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class MethodChannelQChatChannelService extends QChatChannelServicePlatform {
  @override
  Future onEvent(String method, arguments) {
    return Future.value();
  }

  @override
  String get serviceName => 'QChatChannelService';

  /// 创建频道
  Future<NIMResult<QChatCreateChannelResult>> createChannel(
      QChatCreateChannelParam param) async {
    return NIMResult<QChatCreateChannelResult>.fromMap(
        await invokeMethod('createChannel', arguments: param.toJson()),
        convert: (json) => QChatCreateChannelResult.fromJson(json));
  }

  /// 删除频道
  Future<NIMResult<void>> deleteChannel(QChatDeleteChannelParam param) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('deleteChannel', arguments: param.toJson()));
  }

  /// 修改频道信息
  Future<NIMResult<QChatUpdateChannelResult>> updateChannel(
      QChatUpdateChannelParam param) async {
    //所有为空时返回参数错误
    if (param.custom == null &&
        param.name == null &&
        param.viewMode == null &&
        param.topic == null &&
        param.antiSpamConfig == null) {
      return NIMResult.failure(code: 414, message: 'param error');
    }
    return NIMResult<QChatUpdateChannelResult>.fromMap(
        await invokeMethod('updateChannel', arguments: param.toJson()),
        convert: (json) => QChatUpdateChannelResult.fromJson(json));
  }

  /// 通过频道Id查询频道

  Future<NIMResult<QChatGetChannelsResult>> getChannels(
      QChatGetChannelsParam param) async {
    return NIMResult<QChatGetChannelsResult>.fromMap(
        await invokeMethod('getChannels', arguments: param.toJson()),
        convert: (json) => QChatGetChannelsResult.fromJson(json));
  }

  /// 通过分页接口查询频道
  Future<NIMResult<QChatGetChannelsByPageResult>> getChannelsByPage(
      QChatGetChannelsByPageParam param) async {
    return NIMResult<QChatGetChannelsByPageResult>.fromMap(
        await invokeMethod('getChannelsByPage', arguments: param.toJson()),
        convert: (json) => QChatGetChannelsByPageResult.fromJson(json));
  }

  /// 通过分页接口查询频道成员
  Future<NIMResult<QChatGetChannelMembersByPageResult>> getChannelMembersByPage(
      QChatGetChannelMembersByPageParam param) async {
    return NIMResult<QChatGetChannelMembersByPageResult>.fromMap(
        await invokeMethod('getChannelMembersByPage',
            arguments: param.toJson()),
        convert: (json) => QChatGetChannelMembersByPageResult.fromJson(json));
  }

  /// 查询未读信息
  Future<NIMResult<QChatGetChannelUnreadInfosResult>> getChannelUnreadInfos(
      QChatGetChannelUnreadInfosParam param) async {
    return NIMResult<QChatGetChannelUnreadInfosResult>.fromMap(
        await invokeMethod('getChannelUnreadInfos', arguments: param.toJson()),
        convert: (json) => QChatGetChannelUnreadInfosResult.fromJson(json));
  }

  /// 订阅频道
  /// 大服务器下，只有订阅频道后才能收到该频道的订阅内容（消息、未读数、未读状态）；与你相关的消息不需要订阅频道就可以收到，比如@你的消息（@All的消息不属于与你相关的消息）
  /// 小服务器下，不需要订阅频道就可以收到所有该服务器下所有频道的消息
  /// 订阅正在输入事件不区分大服务器和小服务器，只有订阅了才会收到，默认最多订阅100个频道
  Future<NIMResult<QChatSubscribeChannelResult>> subscribeChannel(
      QChatSubscribeChannelParam param) async {
    return NIMResult<QChatSubscribeChannelResult>.fromMap(
        await invokeMethod('subscribeChannel', arguments: param.toJson()),
        convert: (json) => QChatSubscribeChannelResult.fromJson(json));
  }

  /// 分页检索频道列表
  Future<NIMResult<QChatSearchChannelByPageResult>> searchChannelByPage(
      QChatSearchChannelByPageParam param) async {
    return NIMResult<QChatSearchChannelByPageResult>.fromMap(
        await invokeMethod('searchChannelByPage', arguments: param.toJson()),
        convert: (json) => QChatSearchChannelByPageResult.fromJson(json));
  }

  /// 检索频道内成员
  Future<NIMResult<QChatSearchChannelMembersResult>> searchChannelMembers(
      QChatSearchChannelMembersParam param) async {
    return NIMResult<QChatSearchChannelMembersResult>.fromMap(
        await invokeMethod('searchChannelMembers', arguments: param.toJson()),
        convert: (json) => QChatSearchChannelMembersResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetChannelBlackWhiteMembersByPageResult>>
      getChannelBlackWhiteMembersByPage(
          QChatGetChannelBlackWhiteMembersByPageParam param) async {
    return NIMResult<QChatGetChannelBlackWhiteMembersByPageResult>.fromMap(
        await invokeMethod('getChannelBlackWhiteMembersByPage',
            arguments: param.toJson()),
        convert: (json) =>
            QChatGetChannelBlackWhiteMembersByPageResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetChannelBlackWhiteRolesByPageResult>>
      getChannelBlackWhiteRolesByPage(
          QChatGetChannelBlackWhiteRolesByPageParam param) async {
    return NIMResult<QChatGetChannelBlackWhiteRolesByPageResult>.fromMap(
        await invokeMethod('getChannelBlackWhiteRolesByPage',
            arguments: param.toJson()),
        convert: (json) =>
            QChatGetChannelBlackWhiteRolesByPageResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetChannelCategoriesByPageResult>>
      getChannelCategoriesByPage(
          QChatGetChannelCategoriesByPageParam param) async {
    return NIMResult<QChatGetChannelCategoriesByPageResult>.fromMap(
        await invokeMethod('getChannelCategoriesByPage',
            arguments: param.toJson()),
        convert: (json) =>
            QChatGetChannelCategoriesByPageResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetExistingChannelBlackWhiteMembersResult>>
      getExistingChannelBlackWhiteMembers(
          QChatGetExistingChannelBlackWhiteMembersParam param) async {
    return NIMResult<QChatGetExistingChannelBlackWhiteMembersResult>.fromMap(
        await invokeMethod('getExistingChannelBlackWhiteMembers',
            arguments: param.toJson()),
        convert: (json) =>
            QChatGetExistingChannelBlackWhiteMembersResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetExistingChannelBlackWhiteRolesResult>>
      getExistingChannelBlackWhiteRoles(
          QChatGetExistingChannelBlackWhiteRolesParam param) async {
    return NIMResult<QChatGetExistingChannelBlackWhiteRolesResult>.fromMap(
        await invokeMethod('getExistingChannelBlackWhiteRoles',
            arguments: param.toJson()),
        convert: (json) =>
            QChatGetExistingChannelBlackWhiteRolesResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetUserPushConfigsResult>> getUserChannelPushConfigs(
      QChatGetUserChannelPushConfigsParam param) async {
    return NIMResult<QChatGetUserPushConfigsResult>.fromMap(
        await invokeMethod('getUserChannelPushConfigs',
            arguments: param.toJson()),
        convert: (json) => QChatGetUserPushConfigsResult.fromJson(json));
  }

  @override
  Future<NIMResult<void>> updateChannelBlackWhiteMembers(
      QChatUpdateChannelBlackWhiteMembersParam param) async {
    return NIMResult<void>.fromMap(
      await invokeMethod('updateChannelBlackWhiteMembers',
          arguments: param.toJson()),
    );
  }

  @override
  Future<NIMResult<void>> updateChannelBlackWhiteRoles(
      QChatUpdateChannelBlackWhiteRolesParam param) async {
    return NIMResult<void>.fromMap(await invokeMethod(
        'updateChannelBlackWhiteRoles',
        arguments: param.toJson()));
  }

  @override
  Future<NIMResult<void>> updateUserChannelPushConfig(
      QChatUpdateUserChannelPushConfigParam param) async {
    return NIMResult<void>.fromMap(await invokeMethod(
        'updateUserChannelPushConfig',
        arguments: param.toJson()));
  }

  @override
  Future<NIMResult<QChatSubscribeChannelAsVisitorResult>> subscribeAsVisitor(
      QChatSubscribeChannelAsVisitorParam param) async {
    return NIMResult<QChatSubscribeChannelAsVisitorResult>.fromMap(
        await invokeMethod(
          'subscribeAsVisitor',
          arguments: param.toJson(),
        ),
        convert: (json) => QChatSubscribeChannelAsVisitorResult.fromJson(json));
  }
}
