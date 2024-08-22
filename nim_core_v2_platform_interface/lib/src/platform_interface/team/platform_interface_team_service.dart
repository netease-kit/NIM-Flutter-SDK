// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:nim_core_v2_platform_interface/src/method_channel/method_channel_team_service.dart';

abstract class TeamServicePlatform extends Service {
  TeamServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static TeamServicePlatform _instance = MethodChannelTeamService();

  static TeamServicePlatform get instance => _instance;

  static set instance(TeamServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /**
  *  创建群组
  *
  *  @param createTeamParams 创建参数
  *  @param inviteeAccountIds 邀请加入账号id列表
  *  @param postscript 邀请入群的附言
  *  @param antispamConfig 反垃圾配置
  */

  Future<NIMResult<NIMCreateTeamResult>> createTeam(
      NIMCreateTeamParams createTeamParams,
      List<String>? inviteeAccountIds,
      String? postscript,
      NIMAntispamConfig? antispamConfig) async {
    throw UnimplementedError('createTeam() is not implemented');
  }

  /**
  *  更新群组
  *
  *  @param teamId 群组Id
  *  @param teamType 群组类型
  *  @param updateTeamInfoParams 更新参数
  *  @param antispamConfig 反垃圾配置
  */

  Future<NIMResult<void>> updateTeamInfo(
      String teamId,
      NIMTeamType teamType,
      NIMUpdateTeamInfoParams updateTeamInfoParams,
      NIMAntispamConfig? antispamConfig) async {
    throw UnimplementedError('updateTeam() is not implemented');
  }

  /**
  *  退出群组
  *
  *  @param teamId 群组Id
  *  @param teamType 群组类型
  *  @param success 成功回调
  *  @param failure 失败回调
  */

  Future<NIMResult<void>> leaveTeam(String teamId, NIMTeamType teamType) async {
    throw UnimplementedError('leaveTeam() is not implemented');
  }

  /**
   *  获取群组信息
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   */
  Future<NIMResult<NIMTeam>> getTeamInfo(
      String teamId, NIMTeamType teamType) async {
    throw UnimplementedError('getTeamInfo() is not implemented');
  }

  /**
   *  根据群组id获取群组信息
   *
   *  @param teamIds 群组Id列表
   *  @param teamType 群组类型
   */
  Future<NIMResult<List<NIMTeam>>> getTeamInfoByIds(
      List<String> teamIds, NIMTeamType teamType) async {
    throw UnimplementedError('getTeamInfoByIds() is not implemented');
  }

  /**
   *  解散群组
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  Future<NIMResult<void>> dismissTeam(
      String teamId, NIMTeamType teamType) async {
    throw UnimplementedError('dismissTeam() is not implemented');
  }

  /**
   *  邀请成员加入群组
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param inviteeAccountIds 邀请加入账号id列表
   *  @param postscript 邀请入群的附言
   */
  Future<NIMResult<List<String>>> inviteMember(
      String teamId,
      NIMTeamType teamType,
      List<String> inviteeAccountIds,
      String? postscript) async {
    throw UnimplementedError('inviteMember() is not implemented');
  }

  /**
   *  同意邀请入群
   *
   *  @param invitationInfo 邀请信息
   */
  Future<NIMResult<NIMTeam>> acceptInvitation(
      NIMTeamJoinActionInfo invitationInfo) async {
    throw UnimplementedError('acceptInvitation() is not implemented');
  }

  /**
   *  拒绝邀请入群请求
   *
   *  @param invitationInfo 邀请信息
   *  @param postscript 拒绝邀请入群的附言
   */
  Future<NIMResult<void>> rejectInvitation(
      NIMTeamJoinActionInfo invitationInfo, String? postscript) async {
    throw UnimplementedError('rejectInvitation() is not implemented');
  }

  /**
   *  踢出群组成员
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param memberAccountIds 踢出群组的成员账号列表
   */
  Future<NIMResult<void>> kickMember(String teamId, NIMTeamType teamType,
      List<String>? memberAccountIds) async {
    throw UnimplementedError('kickMember() is not implemented');
  }

  /**
   *  申请加入群组
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param postscript 申请入群的附言
   */
  Future<NIMResult<NIMTeam>> applyJoinTeam(
      String teamId, NIMTeamType teamType, String? postscript) async {
    throw UnimplementedError('applyJoinTeam() is not implemented');
  }

  /**
   *  接受入群申请请求
   *
   *  @param applicationInfo 申请信息
   */
  Future<NIMResult<void>> acceptJoinApplication(
      NIMTeamJoinActionInfo applicationInfo) async {
    throw UnimplementedError('acceptJoinApplication() is not implemented');
  }

  /**
   *  拒绝入群申请
   *
   *  @param applicationInfo 申请信息
   *  @param postscript 拒绝申请加入的附言
   */
  Future<NIMResult<void>> rejectJoinApplication(
      NIMTeamJoinActionInfo applicationInfo, String? postscript) async {
    throw UnimplementedError('rejectJoinApplication() is not implemented');
  }

  /**
   *  设置成员角色
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param memberAccountIds 设置成员角色的账号id列表
   *  @param memberRole 设置新的角色类型
   */
  Future<NIMResult<void>> updateTeamMemberRole(
      String teamId,
      NIMTeamType teamType,
      List<String> memberAccountIds,
      NIMTeamMemberRole memberRole) async {
    throw UnimplementedError('updateTeamMemberRole() is not implemented');
  }

  /**
   *  移交群主
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param accountId 新群主的账号id
   *  @param leave 转让群主后，是否同时退出该群
   */
  Future<NIMResult<void>> transferTeamOwner(
      String teamId, NIMTeamType teamType, String accountId, bool leave) async {
    throw UnimplementedError('transferTeamOwner() is not implemented');
  }

  /**
   *  修改自己的群成员信息
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param memberInfoParams 更新参数
   */
  Future<NIMResult<void>> updateSelfTeamMemberInfo(
      String teamId,
      NIMTeamType teamType,
      NIMUpdateSelfMemberInfoParams memberInfoParams) async {
    throw UnimplementedError('updateSelfTeamMemberInfo() is not implemented');
  }

  /**
   *  修改群成员昵称
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param accountId 被修改成员的账号id
   *  @param teamNick 被修改成员新的昵称
   */
  Future<NIMResult<void>> updateTeamMemberNick(String teamId,
      NIMTeamType teamType, String accountId, String teamNick) async {
    throw UnimplementedError('updateTeamMemberNick() is not implemented');
  }

  /**
   *  设置群组聊天禁言模式
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param chatBannedMode 群组禁言模式
   */
  Future<NIMResult<void>> setTeamChatBannedMode(String teamId,
      NIMTeamType teamType, NIMTeamChatBannedMode chatBannedMode) async {
    throw UnimplementedError('setTeamChatBannedMode() is not implemented');
  }

  /**
   *  设置群组成员聊天禁言状态
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param accountId 群成员账号id
   *  @param chatBanned 群组中聊天是否被禁言
   */
  Future<NIMResult<void>> setTeamMemberChatBannedStatus(String teamId,
      NIMTeamType teamType, String accountId, bool chatBanned) async {
    throw UnimplementedError(
        'setTeamMemberChatBannedStatus() is not implemented');
  }

  /**
   *  获取当前已经加入的群组列表
   *
   *  @param teamTypes 群类型列表，nil或空列表表示获取所有
   */
  Future<NIMResult<List<NIMTeam>>> getJoinedTeamList(
      List<NIMTeamType> teamTypes) async {
    throw UnimplementedError('getJoinedTeamList() is not implemented');
  }

  /**
   *  获取当前已经加入的群组个数
   *
   *  @param teamTypes 群类型列表，nil或空列表表示获取所有
   */
  Future<NIMResult<int>> getJoinedTeamCount(List<NIMTeamType> teamTypes) async {
    throw UnimplementedError('getJoinedTeamCount() is not implemented');
  }

  /**
   *  获取群组成员列表
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param queryOption 群组成员查询选项
   */
  Future<NIMResult<NIMTeamMemberListResult>> getTeamMemberList(String teamId,
      NIMTeamType teamType, NIMTeamMemberQueryOption queryOption) async {
    throw UnimplementedError('getTeamMemberList() is not implemented');
  }

  /**
   *  根据账号id列表获取群组成员列表
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param accountIds 账号id列表
   */
  Future<NIMResult<List<NIMTeamMember>>> getTeamMemberListByIds(
      String teamId, NIMTeamType teamType, List<String> accountIds) async {
    throw UnimplementedError('getTeamMemberListByIds() is not implemented');
  }

  /**
   *  根据账号id列表获取群组成员邀请人
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param accountIds 账号id列表
   */
  Future<NIMResult<Map<String, String>>> getTeamMemberInvitor(
      String teamId, NIMTeamType teamType, List<String> accountIds) async {
    throw UnimplementedError('getTeamMemberInvitor() is not implemented');
  }

  /**
   *  获取群加入相关信息
   *
   *  @param queryOption 查询参数
   */
  Future<NIMResult<NIMTeamJoinActionInfoResult>> getTeamJoinActionInfoList(
      NIMTeamJoinActionInfoQueryOption queryOption) async {
    throw UnimplementedError('getTeamJoinActionInfoList() is not implemented');
  }

  /**
   *  根据关键字搜索群信息
   *
   *  @param keyword 关键字
   */
  Future<NIMResult<List<NIMTeam>>> searchTeamByKeyword(String keyword) async {
    throw UnimplementedError('searchTeamByKeyword() is not implemented');
  }

  /**
   *  根据关键字搜索群成员
   *
   *  @param searchOption 搜索参数
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  Future<NIMResult<NIMTeamMemberListResult>> searchTeamMembers(
      NIMTeamMemberSearchOption searchOption) async {
    throw UnimplementedError('searchTeamMembers() is not implemented');
  }

  // 下面是回调，用stream 实现
  /**
   *  同步开始
   */
  StreamController<void> onSyncStarted = StreamController.broadcast();

  /**
   *  同步完成
   */
  StreamController<void> onSyncFinished = StreamController.broadcast();

  /**
   *  同步失败
   */
  StreamController<NIMResult> onSyncFailed = StreamController.broadcast();

  /**
   *  群组创建回调
   */
  StreamController<NIMTeam> onTeamCreated = StreamController.broadcast();

  /**
   *  群组解散回调
   *  @discussion 仅teamId和teamType字段有效
   */
  StreamController<NIMTeam> onTeamDismissed = StreamController.broadcast();

  /**
   *  加入群组回调
   */
  StreamController<NIMTeam> onTeamJoined = StreamController.broadcast();

  /**
   *  离开群组回调
   *  @discussion 主动离开群组或被管理员踢出群组
   */
  StreamController<TeamLeftReuslt> onTeamLeft = StreamController.broadcast();

  /**
   *  群组信息更新回调
   *
   *  @param team 更新信息群组
   */
  StreamController<NIMTeam> onTeamInfoUpdated = StreamController.broadcast();

  /**
   *  群组成员加入回调
   */
  StreamController<List<NIMTeamMember>> onTeamMemberJoined =
      StreamController.broadcast();

  /**
   *  群组成员被踢回调
   */
  StreamController<TeamMemberKickedResult> onTeamMemberKicked =
      StreamController.broadcast();

  /**
   *  群组成员退出回调
   */
  StreamController<List<NIMTeamMember>> onTeamMemberLeft =
      StreamController.broadcast();

  /**
   *  群组成员信息变更回调
   */
  StreamController<List<NIMTeamMember>> onTeamMemberInfoUpdated =
      StreamController.broadcast();

  /**
   *  入群操作回调
   */
  StreamController<NIMTeamJoinActionInfo> onReceiveTeamJoinActionInfo =
      StreamController.broadcast();
}
