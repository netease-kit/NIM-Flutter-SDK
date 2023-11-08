// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

import 'package:nim_core_platform_interface/src/method_channel/method_channel_qchat_channel_service.dart';

abstract class QChatChannelServicePlatform extends Service {
  QChatChannelServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static QChatChannelServicePlatform _instance =
      MethodChannelQChatChannelService();

  static QChatChannelServicePlatform get instance => _instance;

  static set instance(QChatChannelServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 创建频道
  Future<NIMResult<QChatCreateChannelResult>> createChannel(
      QChatCreateChannelParam param) {
    throw UnimplementedError('createChannel is not implemented');
  }

  /// 删除频道
  Future<NIMResult<void>> deleteChannel(QChatDeleteChannelParam param) {
    throw UnimplementedError('deleteChannel is not implemented');
  }

  /// 修改频道信息
  Future<NIMResult<QChatUpdateChannelResult>> updateChannel(
      QChatUpdateChannelParam param) {
    throw UnimplementedError('updateChannel is not implemented');
  }

  /// 通过频道Id查询频道

  Future<NIMResult<QChatGetChannelsResult>> getChannels(
      QChatGetChannelsParam param) {
    throw UnimplementedError('getChannels is not implemented');
  }

  /// 通过分页接口查询频道
  Future<NIMResult<QChatGetChannelsByPageResult>> getChannelsByPage(
      QChatGetChannelsByPageParam param) {
    throw UnimplementedError('getChannelsByPage is not implemented');
  }

  /// 通过分页接口查询频道成员
  Future<NIMResult<QChatGetChannelMembersByPageResult>> getChannelMembersByPage(
      QChatGetChannelMembersByPageParam param) {
    throw UnimplementedError('getChannelMembersByPage is not implemented');
  }

  /// 查询未读信息
  Future<NIMResult<QChatGetChannelUnreadInfosResult>> getChannelUnreadInfos(
      QChatGetChannelUnreadInfosParam param) {
    throw UnimplementedError('getChannelUnreadInfos is not implemented');
  }

  /// 订阅频道
  /// 大服务器下，只有订阅频道后才能收到该频道的订阅内容（消息、未读数、未读状态）；与你相关的消息不需要订阅频道就可以收到，比如@你的消息（@All的消息不属于与你相关的消息）
  /// 小服务器下，不需要订阅频道就可以收到所有该服务器下所有频道的消息
  /// 订阅正在输入事件不区分大服务器和小服务器，只有订阅了才会收到，默认最多订阅100个频道
  Future<NIMResult<QChatSubscribeChannelResult>> subscribeChannel(
      QChatSubscribeChannelParam param) {
    throw UnimplementedError('subscribeChannel is not implemented');
  }

  /// 分页检索频道列表
  Future<NIMResult<QChatSearchChannelByPageResult>> searchChannelByPage(
      QChatSearchChannelByPageParam param) {
    throw UnimplementedError('searchChannelByPage is not implemented');
  }

  /// 检索频道内成员
  Future<NIMResult<QChatSearchChannelMembersResult>> searchChannelMembers(
      QChatSearchChannelMembersParam param) {
    throw UnimplementedError('searchChannelMembers is not implemented');
  }

  /// 更新频道黑白名单身份组

  Future<NIMResult<void>> updateChannelBlackWhiteRoles(
      QChatUpdateChannelBlackWhiteRolesParam param);

  /// 分页查询频道黑白名单身份组列表

  Future<NIMResult<QChatGetChannelBlackWhiteRolesByPageResult>>
      getChannelBlackWhiteRolesByPage(
          QChatGetChannelBlackWhiteRolesByPageParam param);

  /// 批量查询频道黑白名单身份组列表

  Future<NIMResult<QChatGetExistingChannelBlackWhiteRolesResult>>
      getExistingChannelBlackWhiteRoles(
          QChatGetExistingChannelBlackWhiteRolesParam param);

  /// 更新频道黑白名单成员

  Future<NIMResult<void>> updateChannelBlackWhiteMembers(
      QChatUpdateChannelBlackWhiteMembersParam param);

  /// 分页查询频道黑白名单成员列表

  Future<NIMResult<QChatGetChannelBlackWhiteMembersByPageResult>>
      getChannelBlackWhiteMembersByPage(
          QChatGetChannelBlackWhiteMembersByPageParam param);

  /// 批量查询频道黑白名单成员列表

  Future<NIMResult<QChatGetExistingChannelBlackWhiteMembersResult>>
      getExistingChannelBlackWhiteMembers(
          QChatGetExistingChannelBlackWhiteMembersParam param);

  /// 更新用户频道推送配置

  Future<NIMResult<void>> updateUserChannelPushConfig(
      QChatUpdateUserChannelPushConfigParam param);

  /// 获取用户频道推送配置列表

  Future<NIMResult<QChatGetUserPushConfigsResult>> getUserChannelPushConfigs(
      QChatGetUserChannelPushConfigsParam param);

  /// 分页查询服务器下频道类别列表

  Future<NIMResult<QChatGetChannelCategoriesByPageResult>>
      getChannelCategoriesByPage(QChatGetChannelCategoriesByPageParam param);

  Future<NIMResult<QChatSubscribeChannelAsVisitorResult>> subscribeAsVisitor(
      QChatSubscribeChannelAsVisitorParam param);
}
