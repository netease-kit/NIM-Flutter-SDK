// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core;

class TeamService {
  factory TeamService() {
    if (_singleton == null) {
      _singleton = TeamService._();
    }
    return _singleton!;
  }

  TeamService._();

  static TeamService? _singleton;

  TeamServicePlatform get _platform => TeamServicePlatform.instance;

  /// 群资料变动观察者通知。新建群和群更新的通知都通过该接口传递
  /// observer 观察者, 参数为有更新的群资料列表
  Stream<List<NIMTeam>> get onTeamListUpdate =>
      TeamServicePlatform.instance.onTeamListUpdate.stream;

  /// 移除群的观察者通知。自己退群，群被解散，自己被踢出群时，会收到该通知
  /// observer 观察者, 参数为被移除的群资料，此时群的isMyTeam接口返回false
  Stream<List<NIMTeam>> get onTeamListRemove =>
      TeamServicePlatform.instance.onTeamListRemove.stream;

  /// 群成员资料变动观察者通知。群成员资料变动时，会收到该通知
  Stream<List<NIMTeamMember>> get onTeamMemberUpdate =>
      TeamServicePlatform.instance.onTeamMemberUpdate.stream;

  /// 移除群成员的观察者通知。自己被移除群时，会收到该通知
  /// ios端收到回调时NIMTeamMember中仅id 和 account 有效
  Stream<List<NIMTeamMember>> get onTeamMemberRemove =>
      TeamServicePlatform.instance.onTeamMemberRemove.stream;

  /// 创建一个群组
  /// 云信群组分为两类：普通群和高级群，两种群组的消息功能都是相同的，区别在于管理功能。普通群所有人都可以拉人入群，除群主外，其他人都不能踢人；
  /// 高级群则拥有完善的成员权限体系及管理功能。创建群的接口相同，传入不同的类型参数即可。
  ///
  /// [fields] ,[NIMTeamFieldEnum]	群组预设资料, key为数据字段，value对应的值，该值类型必须和field中定义的fieldType一致。
  /// [type] ,[NIMTeamTypeEnum]	要创建的群组类型
  /// [members]	邀请加入的成员帐号列表

  ///  可以设置回调函数，如果成功，参数为创建的群组资料
  Future<NIMResult<NIMCreateTeamResult>> createTeam(
      {required NIMCreateTeamOptions createTeamOptions,
      required List<String> members}) async {
    return _platform.createTeam(createTeamOptions, members);
  }

  /// 从本地获取所有群组
  /// 获取自己加入的群的列表
  /// 可以设置回调函数，如果成功，参数为自己加入的群的列表
  ///
  Future<NIMResult<List<NIMTeam>>> queryTeamList() {
    return _platform.queryTeamList();
  }

  /// 查询群资料，如果本地没有群组资料，则去服务器查询。
  /// 如果自己不在这个群中，该接口返回的可能是过期资料，如需最新的，请调用{@link #searchTeam(String)}接口
  /// [teamId] 群ID
  Future<NIMResult<NIMTeam>> queryTeam(String teamId) {
    return _platform.queryTeam(teamId);
  }

  /// 从服务器上查询群资料信息
  /// teamId 群ID
  Future<NIMResult<NIMTeam>> searchTeam(String teamId) {
    return _platform.searchTeam(teamId);
  }

  /// 解散群，只有群主有此权限
  /// 可以设置回调函数，监听操作结果
  Future<NIMResult<void>> dismissTeam(String teamId) {
    return _platform.dismissTeam(teamId);
  }

  /// 用户申请加入群。
  /// teamId 申请加入的群ID
  ///postscript 申请附言
  Future<NIMResult<NIMTeam>> applyJoinTeam(String teamId, String postscript) {
    return _platform.applyJoinTeam(teamId, postscript);
  }

  /// 通过用户的入群申请
  /// 仅管理员和群主有此权限
  Future<NIMResult<void>> passApply(String teamId, String account) {
    return _platform.passApply(teamId, account);
  }

  /// 拒绝用户的入群申请
  /// 仅管理员和拥有者有此权限
  Future<NIMResult<void>> rejectApply(
      String teamId, String account, String reason) {
    return _platform.rejectApply(teamId, account, reason);
  }

  /// 添加成员并设置自定义字段
  /// teamId	群组ID
  /// accounts	待加入的群成员帐号列表
  /// msg	邀请附言 ，不需要的话设置为空
  /// customInfo	自定义扩展字段，不需要的话设置为空
  Future<NIMResult<List<String>>> addMembersEx(
      {required String teamId,
      required List<String> accounts,
      required String msg,
      required String customInfo}) {
    return _platform.addMembersEx(teamId, accounts, msg, customInfo);
  }

  /// 接受别人的入群邀请
  Future<NIMResult<void>> acceptInvite(String teamId, String inviter) {
    return _platform.acceptInvite(teamId, inviter);
  }

  ///拒绝入群邀请
  ///[teamId] 群组ID
  ///[inviter] 邀请我的用户帐号
  ///[reason]  拒绝理由，长度不得超过5000
  Future<NIMResult<void>> declineInvite(
      String teamId, String inviter, String reason) async {
    return _platform.declineInvite(teamId, inviter, reason);
  }

  /// 获取群成员入群邀请人（为空表示主动入群，没有邀请人）
  /// teamId
  /// accids 查询用户accid列表，最多两百
  ///  返回用户的对应关系，key为accid value是inviteAccid
  Future<NIMResult<Map<String, String>>> getMemberInvitor(
      String teamId, List<String> accids) {
    return _platform.getMemberInvitor(teamId, accids);
  }

  /// 移除成员，只有创建者有此权限
  Future<NIMResult<void>> removeMembers(String teamId, List<String> members) {
    return _platform.removeMembers(teamId, members);
  }

  /// 退出群
  /// teamId 群ID
  Future<NIMResult<void>> quitTeam(String teamId) {
    return _platform.quitTeam(teamId);
  }

  /// 获取指定群的成员信息列表. <br>
  /// 该操作有可能只是从本地数据库读取缓存数据，也有可能会从服务器同步新的数据, 因此耗时可能会比较长。
  /// teamId 群ID
  /// 可以设置回调函数，如果成功，参数为群的成员信息列表
  Future<NIMResult<List<NIMTeamMember>>> queryMemberList(String teamId) {
    return _platform.queryMemberList(teamId);
  }

  /// 查询群成员资料。如果本地群成员资料已过期会去服务器获取最新的。
  /// [teamId]  群ID
  /// [account] 群成员帐号
  Future<NIMResult<NIMTeamMember>> queryTeamMember(
      String teamId, String account) {
    return _platform.queryTeamMember(teamId, account);
  }

  /// 群组管理员修改群内其他成员的群昵称。
  /// 仅群管理员和群主有此权限
  /// [teamId]  所在群组ID
  /// [account] 要修改的群成员帐号
  /// [nick]    新的群昵称
  Future<NIMResult<void>> updateMemberNick(
      String teamId, String account, String nick) {
    return _platform.updateMemberNick(teamId, account, nick);
  }

  ///修改自己的群成员扩展字段（自定义属性）
  /// teamId    所在群组ID
  /// extension 新的扩展字段（自定义属性）
  Future<NIMResult<void>> updateMyMemberExtension(
      String teamId, Map<String, Object> extension) {
    return _platform.updateMyMemberExtension(teamId, extension);
  }

  /// 群主将群的群主权限转给另外一个人，转移后，另外一个人成为群主。
  /// 原群主变成普通成员。若参数quit为true，原群主直接退出该群。
  /// InvocationFuture 可以设置回调函数，如果成功，视参数quit值：
  /// quit为false：参数仅包含原群主和当前群主的(即操作者和account)，权限已被更新。
  /// quit为true: 参数为空。
  Future<NIMResult<List<NIMTeamMember>>> transferTeam(
      String teamId, String account, bool quit) {
    return _platform.transferTeam(teamId, account, quit);
  }

  /// 群主添加管理员
  /// 仅群主有此权限
  /// teamId   群ID
  /// accounts 待提升为管理员的用户帐号列表
  /// Future 可以设置回调函数,如果成功，参数为新增的群管理员列表
  Future<NIMResult<List<NIMTeamMember>>> addManagers(
      String teamId, List<String> accounts) {
    return _platform.addManagers(teamId, accounts);
  }

  /// 群主撤销管理员权限
  /// 仅群主有此权限
  /// teamId   群ID
  /// managers 待撤销的管理员的帐号列表
  /// 可以设置回调函数，如果成功，参数为被撤销的群成员列表(权限已被降为Normal)。
  Future<NIMResult<List<NIMTeamMember>>> removeManagers(
      String teamId, List<String> managers) {
    return _platform.removeManagers(teamId, managers);
  }

  ///禁言、解除禁言
  Future<NIMResult<void>> muteTeamMember(
      String teamId, String account, bool mute) {
    return _platform.muteTeamMember(teamId, account, mute);
  }

  /// 对整个群禁言、解除禁言，对普通成员生效，只有群组、管理员有权限
  /// teamId 群组 ID
  /// mute   true表示禁言，false表示解除禁言
  Future<NIMResult<void>> muteAllTeamMember(String teamId, bool mute) {
    return _platform.muteAllTeamMember(teamId, mute);
  }

  /// 查询被禁言群成员列表
  /// 该操作，只返回调用TeamService#muteTeamMember(String, String, boolean) 禁言的用户。
  /// teamId    群ID
  /// 群成员信息列表
  Future<NIMResult<List<NIMTeamMember>>> queryMutedTeamMembers(String teamId) {
    return _platform.queryMutedTeamMembers(teamId);
  }

  /// 批量更新群组资料，可一次性更新多个字段的值。
  /// teamId    群ID
  /// request 需要更新的属性及其值
  Future<NIMResult<void>> updateTeamFields(
      String teamId, NIMTeamUpdateFieldRequest request) {
    return _platform.updateTeamFields(teamId, request);
  }

  /// 设置指定群消息通知类型，支持多端同步
  /// notifyType   通知类型枚举
  Future<NIMResult<void>> muteTeam(
      String teamId, NIMTeamMessageNotifyTypeEnum notifyType) {
    return _platform.muteTeam(teamId, notifyType);
  }

  /// 通过群名称反查群组ID
  /// name 群组名称
  /// 群ID列表
  Future<NIMResult<List<String>>> searchTeamIdByName(String name) {
    return _platform.searchTeamIdByName(name);
  }

  /// 用户在客户端本地可以搜索与关键字匹配的所有群：
  /// 通过群名称反查群组ID
  /// name 群组名称
  /// 群ID列表
  Future<NIMResult<List<NIMTeam>>> searchTeamsByKeyword(String keyword) {
    return _platform.searchTeamsByKeyword(keyword);
  }

  /// 修改自己的群昵称
  ///
  /// [teamId] 所在群组ID
  /// [nick] 新的群昵称
  Future<NIMResult<void>> updateMyTeamNick(String teamId, String nick) {
    return _platform.updateMyTeamNick(teamId, nick);
  }
}
