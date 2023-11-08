// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
part of nim_core;

///圈组频道服务
///仅支持Android 和 iOS
@HawkEntryPoint()
class QChatChannelService {
  factory QChatChannelService() {
    if (_singleton == null) {
      _singleton = QChatChannelService._();
    }
    return _singleton!;
  }

  QChatChannelService._();

  static QChatChannelService? _singleton;

  QChatChannelServicePlatform _platform = QChatChannelServicePlatform.instance;

  /// 创建频道
  /// 回调返回创建成功的频道
  Future<NIMResult<QChatCreateChannelResult>> createChannel(
      QChatCreateChannelParam param) {
    return _platform.createChannel(param);
  }

  /// 删除频道
  Future<NIMResult<void>> deleteChannel(QChatDeleteChannelParam param) {
    return _platform.deleteChannel(param);
  }

  /// 修改频道信息
  Future<NIMResult<QChatUpdateChannelResult>> updateChannel(
      QChatUpdateChannelParam param) {
    return _platform.updateChannel(param);
  }

  /// 通过频道Id查询频道
  /// 回调返回查询到的频道列表
  Future<NIMResult<QChatGetChannelsResult>> getChannels(
      QChatGetChannelsParam param) {
    return _platform.getChannels(param);
  }

  /// 通过分页接口查询频道
  /// 回调返回查询到的频道列表
  Future<NIMResult<QChatGetChannelsByPageResult>> getChannelsByPage(
      QChatGetChannelsByPageParam param) {
    return _platform.getChannelsByPage(param);
  }

  /// 通过分页接口查询频道成员
  /// 回调返回查询到的频道成员
  Future<NIMResult<QChatGetChannelMembersByPageResult>> getChannelMembersByPage(
      QChatGetChannelMembersByPageParam param) {
    return _platform.getChannelMembersByPage(param);
  }

  /// 查询未读信息
  /// 回调返回查询到的历史消息
  Future<NIMResult<QChatGetChannelUnreadInfosResult>> getChannelUnreadInfos(
      QChatGetChannelUnreadInfosParam param) {
    return _platform.getChannelUnreadInfos(param);
  }

  /// 订阅频道
  /// 大服务器下，只有订阅频道后才能收到该频道的订阅内容（消息、未读数、未读状态）；与你相关的消息不需要订阅频道就可以收到，比如@你的消息（@All的消息不属于与你相关的消息）
  /// 小服务器下，不需要订阅频道就可以收到所有该服务器下所有频道的消息
  /// 订阅正在输入事件不区分大服务器和小服务器，只有订阅了才会收到，默认最多订阅100个频道
  /// 回调中返回订阅结果
  Future<NIMResult<QChatSubscribeChannelResult>> subscribeChannel(
      QChatSubscribeChannelParam param) {
    return _platform.subscribeChannel(param);
  }

  /// 分页检索频道列表
  Future<NIMResult<QChatSearchChannelByPageResult>> searchChannelByPage(
      QChatSearchChannelByPageParam param) {
    return _platform.searchChannelByPage(param);
  }

  /// 检索频道内成员
  Future<NIMResult<QChatSearchChannelMembersResult>> searchChannelMembers(
      QChatSearchChannelMembersParam param) {
    return _platform.searchChannelMembers(param);
  }

  /// 更新频道黑白名单身份组

  Future<NIMResult<void>> updateChannelBlackWhiteRoles(
      QChatUpdateChannelBlackWhiteRolesParam param) {
    return _platform.updateChannelBlackWhiteRoles(param);
  }

  /// 分页查询频道黑白名单身份组列表

  Future<NIMResult<QChatGetChannelBlackWhiteRolesByPageResult>>
      getChannelBlackWhiteRolesByPage(
          QChatGetChannelBlackWhiteRolesByPageParam param) {
    return _platform.getChannelBlackWhiteRolesByPage(param);
  }

  /// 批量查询频道黑白名单身份组列表

  Future<NIMResult<QChatGetExistingChannelBlackWhiteRolesResult>>
      getExistingChannelBlackWhiteRoles(
          QChatGetExistingChannelBlackWhiteRolesParam param) {
    return _platform.getExistingChannelBlackWhiteRoles(param);
  }

  /// 更新频道黑白名单成员

  Future<NIMResult<void>> updateChannelBlackWhiteMembers(
      QChatUpdateChannelBlackWhiteMembersParam param) {
    return _platform.updateChannelBlackWhiteMembers(param);
  }

  /// 分页查询频道黑白名单成员列表

  Future<NIMResult<QChatGetChannelBlackWhiteMembersByPageResult>>
      getChannelBlackWhiteMembersByPage(
          QChatGetChannelBlackWhiteMembersByPageParam param) {
    return _platform.getChannelBlackWhiteMembersByPage(param);
  }

  /// 批量查询频道黑白名单成员列表

  Future<NIMResult<QChatGetExistingChannelBlackWhiteMembersResult>>
      getExistingChannelBlackWhiteMembers(
          QChatGetExistingChannelBlackWhiteMembersParam param) {
    return _platform.getExistingChannelBlackWhiteMembers(param);
  }

  /// 更新用户频道推送配置

  Future<NIMResult<void>> updateUserChannelPushConfig(
      QChatUpdateUserChannelPushConfigParam param) {
    return _platform.updateUserChannelPushConfig(param);
  }

  /// 获取用户频道推送配置列表

  Future<NIMResult<QChatGetUserPushConfigsResult>> getUserChannelPushConfigs(
      QChatGetUserChannelPushConfigsParam param) {
    return _platform.getUserChannelPushConfigs(param);
  }

  /// 以游客身份订阅频道

  Future<NIMResult<QChatSubscribeChannelAsVisitorResult>> subscribeAsVisitor(
      QChatSubscribeChannelAsVisitorParam param) {
    return _platform.subscribeAsVisitor(param);
  }

  //// 分页查询服务器下频道类别列表

  // Future<NIMResult<QChatGetChannelCategoriesByPageResult>>
  //     getChannelCategoriesByPage(QChatGetChannelCategoriesByPageParam param) {
  //   return _platform.getChannelCategoriesByPage(param);
  // }
}
