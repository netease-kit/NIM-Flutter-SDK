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

  /// 创建群组
  ///
  /// [createTeamParams] 创建参数
  /// [inviteeAccountIds] 邀请加入账号id列表
  /// [postscript] 邀请入群的附言
  /// [antispamConfig] 反垃圾配置
  Future<NIMResult<NIMCreateTeamResult>> createTeam(
      NIMCreateTeamParams createTeamParams,
      List<String>? inviteeAccountIds,
      String? postscript,
      NIMAntispamConfig? antispamConfig) async {
    return _platform.createTeam(
        createTeamParams, inviteeAccountIds, postscript, antispamConfig);
  }

  /// 更新群组
  ///
  /// [teamId] 群组Id
  /// [teamType] 群组类型
  /// [updateTeamInfoParams] 更新参数
  /// [antispamConfig] 反垃圾配置
  Future<NIMResult<void>> updateTeamInfo(
      String teamId,
      NIMTeamType teamType,
      NIMUpdateTeamInfoParams updateTeamInfoParams,
      NIMAntispamConfig? antispamConfig) async {
    return _platform.updateTeamInfo(
        teamId, teamType, updateTeamInfoParams, antispamConfig);
  }

  /// 退出群组
  ///
  /// [teamId] 群组Id
  /// [teamType] 群组类型
  Future<NIMResult<void>> leaveTeam(String teamId, NIMTeamType teamType) async {
    return _platform.leaveTeam(teamId, teamType);
  }

  /// 获取群组信息
  ///
  /// [teamId] 群组Id
  /// [teamType] 群组类型
  Future<NIMResult<NIMTeam>> getTeamInfo(
      String teamId, NIMTeamType teamType) async {
    return _platform.getTeamInfo(teamId, teamType);
  }

  /// 根据群组id获取群组信息
  ///
  /// [teamIds] 群组Id列表
  /// [teamType] 群组类型
  Future<NIMResult<List<NIMTeam>>> getTeamInfoByIds(
      List<String> teamIds, NIMTeamType teamType) async {
    return _platform.getTeamInfoByIds(teamIds, teamType);
  }

  /// 解散群组
  ///
  /// [teamId] 群组Id
  /// [teamType] 群组类型
  Future<NIMResult<void>> dismissTeam(
      String teamId, NIMTeamType teamType) async {
    return _platform.dismissTeam(teamId, teamType);
  }

  /// 邀请成员加入群组
  ///
  /// [teamId] 群组Id
  /// [teamType] 群组类型
  /// [inviteeAccountIds] 邀请加入账号id列表
  /// [postscript] 邀请入群的附言
  Future<NIMResult<List<String>>> inviteMember(
      String teamId,
      NIMTeamType teamType,
      List<String> inviteeAccountIds,
      String? postscript) async {
    return _platform.inviteMember(
        teamId, teamType, inviteeAccountIds, postscript);
  }

  /// 同意邀请入群
  ///
  /// [invitationInfo] 邀请信息
  Future<NIMResult<NIMTeam>> acceptInvitation(
      NIMTeamJoinActionInfo invitationInfo) async {
    return _platform.acceptInvitation(invitationInfo);
  }

  /// 拒绝邀请入群请求
  ///
  /// [invitationInfo] 邀请信息
  /// [postscript] 拒绝邀请入群的附言
  Future<NIMResult<void>> rejectInvitation(
      NIMTeamJoinActionInfo invitationInfo, String? postscript) async {
    return _platform.rejectInvitation(invitationInfo, postscript);
  }

  /// 踢出群组成员
  ///
  /// [teamId] 群组Id
  /// [teamType] 群组类型
  /// [memberAccountIds] 被踢成员账号列表
  Future<NIMResult<void>> kickMember(String teamId, NIMTeamType teamType,
      List<String>? memberAccountIds) async {
    return _platform.kickMember(teamId, teamType, memberAccountIds);
  }

  /// 申请加入群组
  ///
  /// [teamId] 群组Id
  /// [teamType] 群组类型
  /// [postscript] 申请入群的附言
  Future<NIMResult<NIMTeam>> applyJoinTeam(
      String teamId, NIMTeamType teamType, String? postscript) async {
    return _platform.applyJoinTeam(teamId, teamType, postscript);
  }

  /// 接受入群申请请求
  ///
  /// [applicationInfo] 申请信息
  Future<NIMResult<void>> acceptJoinApplication(
      NIMTeamJoinActionInfo applicationInfo) async {
    return _platform.acceptJoinApplication(applicationInfo);
  }

  /// 拒绝入群申请
  ///
  /// [applicationInfo] 申请信息
  /// [postscript] 拒绝附言
  Future<NIMResult<void>> rejectJoinApplication(
      NIMTeamJoinActionInfo applicationInfo, String? postscript) async {
    return _platform.rejectJoinApplication(applicationInfo, postscript);
  }

  /// 设置成员角色
  ///
  /// [teamId] 群组Id
  /// [teamType] 群组类型
  /// [memberAccountIds] 成员账号列表
  /// [memberRole] 新角色
  Future<NIMResult<void>> updateTeamMemberRole(
      String teamId,
      NIMTeamType teamType,
      List<String> memberAccountIds,
      NIMTeamMemberRole memberRole) async {
    return _platform.updateTeamMemberRole(
        teamId, teamType, memberAccountIds, memberRole);
  }

  /// 移交群主
  ///
  /// [teamId] 群组Id
  /// [teamType] 群组类型
  /// [accountId] 新群主账号id
  /// [leave] 是否退出群
  Future<NIMResult<void>> transferTeamOwner(
      String teamId, NIMTeamType teamType, String accountId, bool leave) async {
    return _platform.transferTeamOwner(teamId, teamType, accountId, leave);
  }

  /// 修改自己的群成员信息
  ///
  /// [teamId] 群组Id
  /// [teamType] 群组类型
  /// [memberInfoParams] 修改参数
  Future<NIMResult<void>> updateSelfTeamMemberInfo(
      String teamId,
      NIMTeamType teamType,
      NIMUpdateSelfMemberInfoParams memberInfoParams) async {
    return _platform.updateSelfTeamMemberInfo(
        teamId, teamType, memberInfoParams);
  }

  /// 修改群成员昵称
  ///
  /// [teamId] 群组Id
  /// [teamType] 群组类型
  /// [accountId] 成员账号
  /// [teamNick] 新昵称
  Future<NIMResult<void>> updateTeamMemberNick(String teamId,
      NIMTeamType teamType, String accountId, String teamNick) async {
    return _platform.updateTeamMemberNick(
        teamId, teamType, accountId, teamNick);
  }

  /// 设置群组聊天禁言模式
  ///
  /// [teamId] 群组Id
  /// [teamType] 群组类型
  /// [chatBannedMode] 禁言模式
  Future<NIMResult<void>> setTeamChatBannedMode(String teamId,
      NIMTeamType teamType, NIMTeamChatBannedMode chatBannedMode) async {
    return _platform.setTeamChatBannedMode(teamId, teamType, chatBannedMode);
  }

  /// 设置群组成员禁言状态
  ///
  /// [teamId] 群组Id
  /// [teamType] 群组类型
  /// [accountId] 成员账号
  /// [chatBanned] 是否禁言
  Future<NIMResult<void>> setTeamMemberChatBannedStatus(String teamId,
      NIMTeamType teamType, String accountId, bool chatBanned) async {
    return _platform.setTeamMemberChatBannedStatus(
        teamId, teamType, accountId, chatBanned);
  }

  /// 获取当前已经加入的群组列表
  ///
  /// [teamTypes] 群组类型列表，null 或空表示获取所有类型
  Future<NIMResult<List<NIMTeam>>> getJoinedTeamList(
      List<NIMTeamType> teamTypes) async {
    return _platform.getJoinedTeamList(teamTypes);
  }

  /// 获取当前已经加入的群组个数
  ///
  /// [teamTypes] 群组类型列表，null 或空表示获取所有类型
  Future<NIMResult<int>> getJoinedTeamCount(List<NIMTeamType> teamTypes) async {
    return _platform.getJoinedTeamCount(teamTypes);
  }

  /// 获取群组成员列表
  ///
  /// [teamId] 群组Id
  /// [teamType] 群组类型
  /// [queryOption] 查询选项
  Future<NIMResult<NIMTeamMemberListResult>> getTeamMemberList(String teamId,
      NIMTeamType teamType, NIMTeamMemberQueryOption queryOption) async {
    return _platform.getTeamMemberList(teamId, teamType, queryOption);
  }

  /// 根据账号id列表获取群组成员列表
  ///
  /// [teamId] 群组Id
  /// [teamType] 群组类型
  /// [accountIds] 账号id列表
  Future<NIMResult<List<NIMTeamMember>>> getTeamMemberListByIds(
      String teamId, NIMTeamType teamType, List<String> accountIds) async {
    return _platform.getTeamMemberListByIds(teamId, teamType, accountIds);
  }

  /// 根据账号id列表获取群组成员邀请人
  ///
  /// [teamId] 群组Id
  /// [teamType] 群组类型
  /// [accountIds] 账号id列表
  Future<NIMResult<Map<String, String>>> getTeamMemberInvitor(
      String teamId, NIMTeamType teamType, List<String> accountIds) async {
    return _platform.getTeamMemberInvitor(teamId, teamType, accountIds);
  }

  /// 获取群加入相关信息
  ///
  /// [queryOption] 查询参数
  Future<NIMResult<NIMTeamJoinActionInfoResult>> getTeamJoinActionInfoList(
      NIMTeamJoinActionInfoQueryOption queryOption) async {
    return _platform.getTeamJoinActionInfoList(queryOption);
  }

  /// 根据关键字搜索群信息
  ///
  /// [keyword] 关键字
  Future<NIMResult<List<NIMTeam>>> searchTeamByKeyword(String keyword) async {
    return _platform.searchTeamByKeyword(keyword);
  }

  /// 根据关键字搜索群成员
  ///
  /// [searchOption] 搜索参数
  Future<NIMResult<NIMTeamMemberListResult>> searchTeamMembers(
      NIMTeamMemberSearchOption searchOption) async {
    return _platform.searchTeamMembers(searchOption);
  }

  /// 添加群组成员关注
  ///
  /// [teamId] 群组id
  /// [teamType] 群组类型
  /// [accountIds] 成员账号id列表
  Future<NIMResult<void>> addTeamMembersFollow(
      String teamId, NIMTeamType teamType, List<String> accountIds) async {
    return _platform.addTeamMembersFollow(teamId, teamType, accountIds);
  }

  /// 移除群组成员关注
  ///
  /// [teamId] 群组id
  /// [teamType] 群组类型
  /// [accountIds] 成员账号id列表
  Future<NIMResult<void>> removeTeamMembersFollow(
      String teamId, NIMTeamType teamType, List<String> accountIds) async {
    return _platform.removeTeamMembersFollow(teamId, teamType, accountIds);
  }

  /// 清空所有群申请
  Future<NIMResult<void>> clearAllTeamJoinActionInfo() async {
    return _platform.clearAllTeamJoinActionInfo();
  }

  /// 清空所有群申请（扩展版），支持按群类型过滤
  ///
  /// [option] 清理条件，为 null 时清理所有申请
  @HawkApi(ignore: false)
  Future<NIMResult<void>> clearAllTeamJoinActionInfoEx(
      NIMTeamClearJoinActionInfoOption? option) async {
    return _platform.clearAllTeamJoinActionInfoEx(option);
  }

  /// 删除群申请
  ///
  /// [application] 需要删除的群申请
  Future<NIMResult<void>> deleteTeamJoinActionInfo(
      NIMTeamJoinActionInfo application) async {
    return _platform.deleteTeamJoinActionInfo(application);
  }

  /// 邀请成员加入群组（扩展）
  ///
  /// [teamId] 群组id
  /// [teamType] 群组类型
  /// [inviteeParams] 被邀请加入群的参数
  Future<NIMResult<List<String>>> inviteMemberEx(String teamId,
      NIMTeamType teamType, NIMTeamInviteParams inviteeParams) async {
    return _platform.inviteMemberEx(teamId, teamType, inviteeParams);
  }

  /// 获取当前自己的群组列表
  ///
  /// 返回群组按创建时间升序排序，仅查本地，需判断群组有效性和是否在群中
  ///
  /// [teamTypes] 群组类型列表，null 或 empty 表示查询所有类型
  Future<NIMResult<List<NIMTeam>>> getOwnerTeamList(
      {List<NIMTeamType>? teamTypes}) {
    return _platform.getOwnerTeamList(teamTypes: teamTypes);
  }

  /// 获取当前自己管理的群组列表（群主 + 管理员）
  ///
  /// 仅查本地，返回群组按创建时间升序排序
  ///
  /// [teamTypes] 群组类型列表，null 或 empty 表示查询所有类型
  Future<NIMResult<List<NIMTeam>>> getManagerTeamList(
      {List<NIMTeamType>? teamTypes}) {
    return _platform.getManagerTeamList(teamTypes: teamTypes);
  }

  /// 从云端查询群组信息
  ///
  /// [teamId] 群组 ID
  /// [teamType] 群组类型
  Future<NIMResult<NIMTeam>> getTeamInfoFromCloud(
      {required String teamId, required NIMTeamType teamType}) {
    return _platform.getTeamInfoFromCloud(teamId: teamId, teamType: teamType);
  }

  /// 本地全文搜索群信息
  ///
  /// [searchParams] 搜索参数，包含关键词、群类型、搜索字段等
  /// 返回匹配的 [NIMTeam] 列表
  Future<NIMResult<List<NIMTeam>>> searchTeams(
      NIMTeamSearchParams searchParams) {
    return _platform.searchTeams(searchParams);
  }

  /// 本地搜索群成员（扩展，支持跨多个群）
  ///
  /// [searchParams] 搜索参数，包含关键词、群引用列表、分页 token 等
  /// 返回以 [NIMTeamRefer] 为 key、匹配成员列表为 value 的 Map
  Future<NIMResult<Map<NIMTeamRefer, List<NIMTeamMember>>>> searchTeamMembersEx(
      NIMSearchTeamMemberParams searchParams) {
    return _platform.searchTeamMembersEx(searchParams);
  }

  /// 同步开始事件流
  @HawkApi(ignore: true)
  Stream<void> get onSyncStarted => _platform.onSyncStarted.stream;

  ///同步完成
  @HawkApi(ignore: true)
  Stream<void> get onSyncFinished => _platform.onSyncFinished.stream;

  /// 同步失败事件流
  @HawkApi(ignore: true)
  Stream<void> get onSyncFailed => _platform.onSyncFailed.stream;

  /// 群组创建回调
  @HawkApi(ignore: true)
  Stream<NIMTeam> get onTeamCreated => _platform.onTeamCreated.stream;

  /// 群组解散回调，仅 teamId 和 teamType 有效
  @HawkApi(ignore: true)
  Stream<NIMTeam> get onTeamDismissed => _platform.onTeamDismissed.stream;

  /// 加入群组回调
  @HawkApi(ignore: true)
  Stream<NIMTeam> get onTeamJoined => _platform.onTeamJoined.stream;

  /// 离开群组回调（主动或被踢）
  @HawkApi(ignore: true)
  Stream<TeamLeftReuslt> get onTeamLeft => _platform.onTeamLeft.stream;

  /// 群组信息更新回调
  @HawkApi(ignore: true)
  Stream<NIMTeam> get onTeamInfoUpdated => _platform.onTeamInfoUpdated.stream;

  /// 群组成员加入回调
  @HawkApi(ignore: true)
  Stream<List<NIMTeamMember>> get onTeamMemberJoined =>
      _platform.onTeamMemberJoined.stream;

  /// 群组成员被踢回调
  @HawkApi(ignore: true)
  Stream<TeamMemberKickedResult> get onTeamMemberKicked =>
      _platform.onTeamMemberKicked.stream;

  /// 群组成员退出回调
  @HawkApi(ignore: true)
  Stream<List<NIMTeamMember>> get onTeamMemberLeft =>
      _platform.onTeamMemberLeft.stream;

  /// 群组成员信息变更回调
  @HawkApi(ignore: true)
  Stream<List<NIMTeamMember>> get onTeamMemberInfoUpdated =>
      _platform.onTeamMemberInfoUpdated.stream;

  /// 入群操作回调
  @HawkApi(ignore: true)
  Stream<NIMTeamJoinActionInfo> get onReceiveTeamJoinActionInfo =>
      _platform.onReceiveTeamJoinActionInfo.stream;
}
