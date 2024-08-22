// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

@HawkEntryPoint()
class TeamService {
  factory TeamService() {
    if (_singleton == null) {
      _singleton = TeamService._();
    }
    return _singleton!;
  }

  static TeamService? _singleton;

  TeamService._();

  TeamServicePlatform get _platform => TeamServicePlatform.instance;

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
    return _platform.createTeam(
        createTeamParams, inviteeAccountIds, postscript, antispamConfig);
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
    return _platform.updateTeamInfo(
        teamId, teamType, updateTeamInfoParams, antispamConfig);
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
    return _platform.leaveTeam(teamId, teamType);
  }

  /**
   *  获取群组信息
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   */
  Future<NIMResult<NIMTeam>> getTeamInfo(
      String teamId, NIMTeamType teamType) async {
    return _platform.getTeamInfo(teamId, teamType);
  }

  /**
   *  根据群组id获取群组信息
   *
   *  @param teamIds 群组Id列表
   *  @param teamType 群组类型
   */
  Future<NIMResult<List<NIMTeam>>> getTeamInfoByIds(
      List<String> teamIds, NIMTeamType teamType) async {
    return _platform.getTeamInfoByIds(teamIds, teamType);
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
    return _platform.dismissTeam(teamId, teamType);
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
    return _platform.inviteMember(
        teamId, teamType, inviteeAccountIds, postscript);
  }

  /**
   *  同意邀请入群
   *
   *  @param invitationInfo 邀请信息
   */
  Future<NIMResult<NIMTeam>> acceptInvitation(
      NIMTeamJoinActionInfo invitationInfo) async {
    return _platform.acceptInvitation(invitationInfo);
  }

  /**
   *  拒绝邀请入群请求
   *
   *  @param invitationInfo 邀请信息
   *  @param postscript 拒绝邀请入群的附言
   */
  Future<NIMResult<void>> rejectInvitation(
      NIMTeamJoinActionInfo invitationInfo, String? postscript) async {
    return _platform.rejectInvitation(invitationInfo, postscript);
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
    return _platform.kickMember(teamId, teamType, memberAccountIds);
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
    return _platform.applyJoinTeam(teamId, teamType, postscript);
  }

  /**
   *  接受入群申请请求
   *
   *  @param applicationInfo 申请信息
   */
  Future<NIMResult<void>> acceptJoinApplication(
      NIMTeamJoinActionInfo applicationInfo) async {
    return _platform.acceptJoinApplication(applicationInfo);
  }

  /**
   *  拒绝入群申请
   *
   *  @param applicationInfo 申请信息
   *  @param postscript 拒绝申请加入的附言
   */
  Future<NIMResult<void>> rejectJoinApplication(
      NIMTeamJoinActionInfo applicationInfo, String? postscript) async {
    return _platform.rejectJoinApplication(applicationInfo, postscript);
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
    return _platform.updateTeamMemberRole(
        teamId, teamType, memberAccountIds, memberRole);
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
    return _platform.transferTeamOwner(teamId, teamType, accountId, leave);
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
    return _platform.updateSelfTeamMemberInfo(
        teamId, teamType, memberInfoParams);
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
    return _platform.updateTeamMemberNick(
        teamId, teamType, accountId, teamNick);
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
    return _platform.setTeamChatBannedMode(teamId, teamType, chatBannedMode);
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
    return _platform.setTeamMemberChatBannedStatus(
        teamId, teamType, accountId, chatBanned);
  }

  /**
   *  获取当前已经加入的群组列表
   *
   *  @param teamTypes 群类型列表，nil或空列表表示获取所有
   */
  Future<NIMResult<List<NIMTeam>>> getJoinedTeamList(
      List<NIMTeamType> teamTypes) async {
    return _platform.getJoinedTeamList(teamTypes);
  }

  /**
   *  获取当前已经加入的群组个数
   *
   *  @param teamTypes 群类型列表，nil或空列表表示获取所有
   */
  Future<NIMResult<int>> getJoinedTeamCount(List<NIMTeamType> teamTypes) async {
    return _platform.getJoinedTeamCount(teamTypes);
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
    return _platform.getTeamMemberList(teamId, teamType, queryOption);
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
    return _platform.getTeamMemberListByIds(teamId, teamType, accountIds);
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
    return _platform.getTeamMemberInvitor(teamId, teamType, accountIds);
  }

  /**
   *  获取群加入相关信息
   *
   *  @param queryOption 查询参数
   */
  Future<NIMResult<NIMTeamJoinActionInfoResult>> getTeamJoinActionInfoList(
      NIMTeamJoinActionInfoQueryOption queryOption) async {
    return _platform.getTeamJoinActionInfoList(queryOption);
  }

  /**
   *  根据关键字搜索群信息
   *
   *  @param keyword 关键字
   */
  Future<NIMResult<List<NIMTeam>>> searchTeamByKeyword(String keyword) async {
    return _platform.searchTeamByKeyword(keyword);
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
    return _platform.searchTeamMembers(searchOption);
  }

  /**
   *  同步开始
   */
  @HawkApi(ignore: true)
  Stream<void> get onSyncStarted => _platform.onSyncStarted.stream;

  /**
   *  同步完成
   */
  @HawkApi(ignore: true)
  Stream<void> get onSyncFinished => _platform.onSyncFinished.stream;

  /**
   *  同步失败
   */
  @HawkApi(ignore: true)
  Stream<void> get onSyncFailed => _platform.onSyncFailed.stream;

  /**
   *  群组创建回调
   */
  @HawkApi(ignore: true)
  Stream<NIMTeam> get onTeamCreated => _platform.onTeamCreated.stream;

  /**
   *  群组解散回调
   *  @discussion 仅teamId和teamType字段有效
   */
  @HawkApi(ignore: true)
  Stream<NIMTeam> get onTeamDismissed => _platform.onTeamDismissed.stream;

  /**
   *  加入群组回调
   */
  @HawkApi(ignore: true)
  Stream<NIMTeam> get onTeamJoined => _platform.onTeamJoined.stream;

  /**
   *  离开群组回调
   *  @discussion 主动离开群组或被管理员踢出群组
   */
  @HawkApi(ignore: true)
  Stream<TeamLeftReuslt> get onTeamLeft => _platform.onTeamLeft.stream;

  /**
   *  群组信息更新回调
   *
   *  @param team 更新信息群组
   */
  @HawkApi(ignore: true)
  Stream<NIMTeam> get onTeamInfoUpdated => _platform.onTeamInfoUpdated.stream;

  /**
   *  群组成员加入回调
   */
  @HawkApi(ignore: true)
  Stream<List<NIMTeamMember>> get onTeamMemberJoined =>
      _platform.onTeamMemberJoined.stream;

  /**
   *  群组成员被踢回调
   */
  @HawkApi(ignore: true)
  Stream<TeamMemberKickedResult> get onTeamMemberKicked =>
      _platform.onTeamMemberKicked.stream;

  /**
   *  群组成员退出回调
   */
  @HawkApi(ignore: true)
  Stream<List<NIMTeamMember>> get onTeamMemberLeft =>
      _platform.onTeamMemberLeft.stream;

  /**
   *  群组成员信息变更回调
   */
  @HawkApi(ignore: true)
  Stream<List<NIMTeamMember>> get onTeamMemberInfoUpdated =>
      _platform.onTeamMemberInfoUpdated.stream;

  /**
   *  入群操作回调
   */
  @HawkApi(ignore: true)
  Stream<NIMTeamJoinActionInfo> get onReceiveTeamJoinActionInfo =>
      _platform.onReceiveTeamJoinActionInfo.stream;
}
