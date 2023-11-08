// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core;

///圈组服务器服务
///目前仅支持iOS和Android平台
class QChatServerService {
  factory QChatServerService() {
    if (_singleton == null) {
      _singleton = QChatServerService._();
    }
    return _singleton!;
  }

  QChatServerService._();

  static QChatServerService? _singleton;

  QChatServerServicePlatform _platform = QChatServerServicePlatform.instance;

  /// 接受申请
  ///
  /// [param]
  Future<NIMResult<void>> acceptServerApply(QChatAcceptServerApplyParam param) {
    return _platform.acceptServerApply(param);
  }

  /// 接受邀请
  ///
  /// [param]
  Future<NIMResult<void>> acceptServerInvite(
      QChatAcceptServerInviteParam param) {
    return _platform.acceptServerInvite(param);
  }

  /// 申请加入服务器
  ///
  /// [param]
  Future<NIMResult<QChatApplyServerJoinResult>> applyServerJoin(
      QChatApplyServerJoinParam param) {
    return _platform.applyServerJoin(param);
  }

  /// 创建服务器
  ///
  /// [param]
  Future<NIMResult<QChatCreateServerResult>> createServer(
      QChatCreateServerParam param) {
    return _platform.createServer(param);
  }

  /// 删除服务器
  ///
  /// [param]
  Future<NIMResult<void>> deleteServer(QChatDeleteServerParam param) {
    return _platform.deleteServer(param);
  }

  /// 通过accid查询服务器成员
  ///
  /// [param]
  Future<NIMResult<QChatGetServerMembersResult>> getServerMembers(
      QChatGetServerMembersParam param) {
    return _platform.getServerMembers(param);
  }

  /// 通过分页信息查询服务器成员
  ///
  /// [param]
  Future<NIMResult<QChatGetServerMembersByPageResult>> getServerMembersByPage(
      QChatGetServerMembersByPageParam param) {
    return _platform.getServerMembersByPage(param);
  }

  /// 通过ServerId列表查询服务器
  ///
  /// [param]
  Future<NIMResult<QChatGetServersResult>> getServers(
      QChatGetServersParam param) {
    return _platform.getServers(param);
  }

  /// 通过分页信息查询服务器
  ///
  /// [param]
  Future<NIMResult<QChatGetServersByPageResult>> getServersByPage(
      QChatGetServersByPageParam param) {
    return _platform.getServersByPage(param);
  }

  /// 邀请服务器成员
  ///
  /// [param]
  Future<NIMResult<QChatInviteServerMembersResult>> inviteServerMembers(
      QChatInviteServerMembersParam param) {
    return _platform.inviteServerMembers(param);
  }

  /// 踢除服务器成员
  ///
  /// [param]
  Future<NIMResult<void>> kickServerMembers(QChatKickServerMembersParam param) {
    return _platform.kickServerMembers(param);
  }

  /// 主动离开服务器
  ///
  /// [param]
  Future<NIMResult<void>> leaveServer(QChatLeaveServerParam param) {
    return _platform.leaveServer(param);
  }

  /// 拒绝申请
  ///
  /// [param]
  Future<NIMResult<void>> rejectServerApply(QChatRejectServerApplyParam param) {
    return _platform.rejectServerApply(param);
  }

  /// 拒绝邀请
  ///
  /// [param]
  Future<NIMResult<void>> rejectServerInvite(
      QChatRejectServerInviteParam param) {
    return _platform.rejectServerInvite(param);
  }

  /// 修改服务器信息
  ///
  /// [param]
  Future<NIMResult<QChatUpdateServerResult>> updateServer(
      QChatUpdateServerParam param) {
    return _platform.updateServer(param);
  }

  /// 修改服务器成员信息
  ///
  /// [param]
  Future<NIMResult<QChatUpdateMyMemberInfoResult>> updateMyMemberInfo(
      QChatUpdateMyMemberInfoParam param) {
    return _platform.updateMyMemberInfo(param);
  }

  /// 订阅服务器
  /// 与你相关的系统通知，比如你被邀请加入服务器、你从服务器被踢等，不需要订阅就可以收到
  /// 与你不相关的系统通知，大服务器下需要主动订阅服务器才能收到，小服务器下不需要订阅就可以收到
  ///
  /// [param]
  Future<NIMResult<QChatSubscribeServerResult>> subscribeServer(
      QChatSubscribeServerParam param) {
    return _platform.subscribeServer(param);
  }

  /// 分页检索服务器列表
  ///
  /// [param]
  Future<NIMResult<QChatSearchServerByPageResult>> searchServerByPage(
      QChatSearchServerByPageParam param) {
    return _platform.searchServerByPage(param);
  }

  /// 生成邀请码
  ///
  /// [param]
  Future<NIMResult<QChatGenerateInviteCodeResult>> generateInviteCode(
      QChatGenerateInviteCodeParam param) {
    return _platform.generateInviteCode(param);
  }

  /// 通过邀请码加入服务器
  ///
  /// [param]
  Future<NIMResult<void>> joinByInviteCode(QChatJoinByInviteCodeParam param) {
    return _platform.joinByInviteCode(param);
  }

  /// 修改其他人的服务器成员信息
  ///
  /// [param]
  Future<NIMResult<QChatUpdateServerMemberInfoResult>> updateServerMemberInfo(
      QChatUpdateServerMemberInfoParam param) {
    return _platform.updateServerMemberInfo(param);
  }

  /// 封禁服务器成员
  ///
  /// [param]
  Future<NIMResult<void>> banServerMember(QChatBanServerMemberParam param) {
    return _platform.banServerMember(param);
  }

  /// 解封服务器成员
  ///
  /// [param]
  Future<NIMResult<void>> unbanServerMember(QChatUnbanServerMemberParam param) {
    return _platform.unbanServerMember(param);
  }

  /// 查询服务器封禁成员列表(分页)
  ///
  /// [param]
  Future<NIMResult<QChatGetBannedServerMembersByPageResult>>
      getBannedServerMembersByPage(
          QChatGetBannedServerMembersByPageParam param) {
    return _platform.getBannedServerMembersByPage(param);
  }

  /// 更新用户服务器推送配置
  ///
  /// [param]
  Future<NIMResult<void>> updateUserServerPushConfig(
      QChatUpdateUserServerPushConfigParam param) {
    return _platform.updateUserServerPushConfig(param);
  }

  /// 获取用户服务器推送配置列表
  ///
  /// [param]
  Future<NIMResult<QChatGetUserPushConfigsResult>> getUserServerPushConfigs(
      QChatGetUserServerPushConfigsParam param) {
    return _platform.getUserServerPushConfigs(param);
  }

  /// 检索服务器成员列表
  ///
  /// [param]
  Future<NIMResult<QChatSearchServerMemberByPageResult>>
      searchServerMemberByPage(QChatSearchServerMemberByPageParam param) {
    return _platform.searchServerMemberByPage(param);
  }

  // /// 查询服务器下的申请邀请记录
  // ///
  // /// [param]
  // Future<NIMResult<QChatGetInviteApplyRecordOfServerResult>>
  //     getInviteApplyRecordOfServer(
  //         QChatGetInviteApplyRecordOfServerParam param) {
  //   return _platform.getInviteApplyRecordOfServer(param);
  // }
  //
  // /// 查询我的申请邀请记录
  // ///
  // /// [param]
  // Future<NIMResult<QChatGetInviteApplyRecordOfSelfResult>>
  //     getInviteApplyRecordOfSelf(QChatGetInviteApplyRecordOfSelfParam param) {
  //   return _platform.getInviteApplyRecordOfSelf(param);
  // }

  /// 清空服务器未读数
  ///
  /// [param]
  Future<NIMResult<QChatServerMarkReadResult>> markRead(
      QChatServerMarkReadParam param) {
    return _platform.markRead(param);
  }

  /// 订阅服务器下的所有频道的消息
  ///
  /// [param]
  Future<NIMResult<QChatSubscribeAllChannelResult>> subscribeAllChannel(
      QChatSubscribeAllChannelParam param) {
    return _platform.subscribeAllChannel(param);
  }

  /// 以游客身份订阅服务器
  ///
  /// [param]
  Future<NIMResult<QChatSubscribeServerAsVisitorResult>> subscribeAsVisitor(
      QChatSubscribeServerAsVisitorParam param) {
    return _platform.subscribeAsVisitor(param);
  }

  /// 以游客身份加入服务器
  ///
  /// [param]
  Future<NIMResult<QChatEnterServerAsVisitorResult>> enterAsVisitor(
      QChatEnterServerAsVisitorParam param) {
    return _platform.enterAsVisitor(param);
  }

  /// 以游客身份离开服务器
  ///
  /// [param]
  Future<NIMResult<QChatLeaveServerAsVisitorResult>> leaveAsVisitor(
      QChatLeaveServerAsVisitorParam param) {
    return _platform.leaveAsVisitor(param);
  }
}
