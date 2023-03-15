// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core;

class SuperTeamService {
  factory SuperTeamService() {
    if (_singleton == null) {
      _singleton = SuperTeamService._();
    }
    return _singleton!;
  }

  SuperTeamService._();

  static SuperTeamService? _singleton;

  SuperTeamServicePlatform get _platform => SuperTeamServicePlatform.instance;

  ///获取自己加入的群的列表
  Future<NIMResult<List<NIMSuperTeam>>> queryTeamList() async {
    return _platform.queryTeamList();
  }

  ///根据群id列表批量查询群信息
  ///[idList] 群id列表
  Future<NIMResult<List<NIMSuperTeam>>> queryTeamListById(
      List<String> idList) async {
    return _platform.queryTeamListById(idList);
  }

  ///查询群资料，如果本地没有群组资料，则去服务器查询。
  ///如果自己不在这个群中，该接口返回的可能是过期资料，如需最新的，请调用searchTeam(String teamId)接口
  ///[teamId] 群组ID
  Future<NIMResult<NIMSuperTeam>> queryTeam(String teamId) async {
    return _platform.queryTeam(teamId);
  }

  ///从服务器上查询群资料信息
  ///[teamId] 群组ID
  Future<NIMResult<NIMSuperTeam>> searchTeam(String teamId) async {
    return _platform.searchTeam(teamId);
  }

  ///申请加入一个群，直接加入或者进入等待验证状态时，返回群信息
  ///[teamId] 群组ID
  ///[postscript] 附言，长度不得超过5000
  Future<NIMResult<NIMSuperTeam>> applyJoinTeam(
      String teamId, String postscript) async {
    return _platform.applyJoinTeam(teamId, postscript);
  }

  ///通过用户的入群申请<br>
  /// 仅管理员和拥有者有此权限
  /// [teamId] 群组ID
  /// [account] 申请入群的用户ID
  Future<NIMResult<void>> passApply(String teamId, String account) async {
    return _platform.passApply(teamId, account);
  }

  ///拒绝用户的入群申请
  /// 仅管理员和拥有者有此权限
  /// [teamId] 群组ID
  /// [account] 申请入群的用户ID
  /// [reason]  拒绝理由，长度不得超过5000
  Future<NIMResult<void>> rejectApply(
      String teamId, String account, String reason) async {
    return _platform.rejectApply(teamId, account, reason);
  }

  ///邀请成员
  ///[teamId] 群组ID
  ///[accountList] 待加入的群成员帐号列表
  ///[msg] 附言，长度不得超过5000
  Future<NIMResult<List<String>>> addMembers(
      String teamId, List<String> accountList, String msg) async {
    return _platform.addMembers(teamId, accountList, msg);
  }

  ///接受别人的入群邀请
  ///[teamId] 群组ID
  ///[inviter] 邀请我的用户帐号
  Future<NIMResult<void>> acceptInvite(String teamId, String inviter) async {
    return _platform.acceptInvite(teamId, inviter);
  }

  ///拒绝入群邀请
  ///[teamId] 群组ID
  ///[inviter] 邀请我的用户帐号
  ///[reason]  拒绝理由，长度不得超过5000
  Future<NIMResult<void>> declineInvite(
      String teamId, String inviter, String reaseon) async {
    return _platform.declineInvite(teamId, inviter, reaseon);
  }

  ///移除成员，只有群主有此权限
  ///[teamId] 群组ID
  ///[members] 被踢出的成员帐号列表
  Future<NIMResult<void>> removeMembers(
      String teamId, List<String> members) async {
    return _platform.removeMembers(teamId, members);
  }

  ///主动退群
  ///[teamId] 群组ID
  Future<NIMResult<void>> quitTeam(String teamId) async {
    return _platform.quitTeam(teamId);
  }

  ///获取群组成员列表
  ///[teamId] 群组ID
  Future<NIMResult<List<NIMSuperTeamMember>>> queryMemberList(
      String teamId) async {
    return _platform.queryMemberList(teamId);
  }

  ///获取指定群组成员
  ///[teamId] 群组ID
  ///[account] 群成员帐号
  Future<NIMResult<NIMSuperTeamMember>> queryTeamMember(
      String teamId, String account) async {
    return _platform.queryTeamMember(teamId, account);
  }

  ///分页获取群组成员
  ///[teamId] 群组ID
  ///[offset] 偏移位置
  ///[limit]  获取条数，每次最多200
  Future<NIMResult<List<NIMSuperTeamMember>>> queryMemberListByPage(
      String teamId, int offset, int limit) async {
    return _platform.queryMemberListByPage(teamId, offset, limit);
  }

  /// 群组管理员修改群内其他成员的群昵称。
  /// 仅群管理员和拥有者有此权限
  /// [teamId]    所在群组ID
  /// [account] 要修改的群成员帐号
  /// [nick]   新的群昵称
  Future<NIMResult<void>> updateMemberNick(
      String teamId, String account, String nick) async {
    return _platform.updateMemberNick(teamId, account, nick);
  }

  /// 群修改自己的群昵称
  /// [teamId]    所在群组ID
  /// [nick]   新的群昵称
  Future<NIMResult<void>> updateMyTeamNick(String teamId, String nick) async {
    return _platform.updateMyTeamNick(teamId, nick);
  }

  ///修改自己的群成员扩展字段（自定义属性, 最长32个字符）
  ///[teamId]    所在群组ID
  ///[extension] 新的扩展字段（自定义属性）
  Future<NIMResult<void>> updateMyMemberExtension(
      String teamId, Map<String, Object> extension) async {
    return _platform.updateMyMemberExtension(teamId, extension);
  }

  /// 群成员资料变化观察者通知。
  /// 上层APP如果管理了群成员资料的缓存，可通过此接口更新缓存。
  /// observer 观察者, 参数为有更新的群成员资料列表
  /// [register] true为注册，false为注销
  Stream<List<NIMSuperTeamMember>> get onMemberUpdate =>
      SuperTeamServicePlatform.instance.onMemberUpdate.stream;

  /// 移除群成员的观察者通知。
  /// observer 观察者, 参数为被移除的群成员
  Stream<List<NIMSuperTeamMember>> onMemberRemove =
      SuperTeamServicePlatform.instance.onMemberRemove.stream;

  ///拥有者将群的拥有者权限转给另外一个人，转移后，另外一个人成为拥有者
  ///原拥有者变成普通成员。
  ///[teamId] 群Id
  ///[account] 新任拥有者的用户帐号
  ///[quit]    转移时是否要同时退出该群
  Future<NIMResult<List<NIMSuperTeamMember>>> transferTeam(
      String teamId, String account, bool quit) async {
    return _platform.transferTeam(teamId, account, quit);
  }

  ///拥有者添加管理员
  ///[teamId] 群Id
  ///[accountList] 待提升为管理员的用户帐号列表
  Future<NIMResult<List<NIMSuperTeamMember>>> addManagers(
      String teamId, List<String> accountList) async {
    return _platform.addManagers(teamId, accountList);
  }

  ///移除管理员
  ///拥有者撤销管理员权限
  ///[teamId] 群Id
  ///[accountList] 待撤销的管理员的帐号列表
  Future<NIMResult<List<NIMSuperTeamMember>>> removeManagers(
      String teamId, List<String> accountList) async {
    return _platform.removeManagers(teamId, accountList);
  }

  ///禁言指定成员
  ///支持管理员和群主对普通成员的禁言、解除禁言操作。
  ///[teamId] 群Id
  ///[accountList] 被禁言、被解除禁言的账号列表
  ///[mute] true表示禁言，false表示解除禁言
  Future<NIMResult<void>> muteTeamMember(
      String teamId, List<String> accountList, bool mute) async {
    return _platform.muteTeamMember(teamId, accountList, mute);
  }

  ///禁言群全体成员
  ///将整个群禁言，该操作仅群主或者管理员有权限。禁言操作成功之后，会回调群更新接口
  ///[teamId] 群Id
  ///[mute] true表示禁言，false表示解除禁言
  Future<NIMResult<void>> muteAllTeamMember(String teamId, bool mute) async {
    return _platform.muteAllTeamMember(teamId, mute);
  }

  ///查询被禁言群成员
  ///该操作只返回被禁言的用户，群整体禁言情况请通过 Team#getMuteMode 和 Team#isAllMute 查询
  ///[teamId] 群Id
  Future<NIMResult<List<NIMSuperTeamMember>>> queryMutedTeamMembers(
      String teamId) async {
    return _platform.queryMutedTeamMembers(teamId);
  }

  ///编辑多个资料
  Future<NIMResult<void>> updateTeamFields(
      String teamId, NIMTeamUpdateFieldRequest request) async {
    return _platform.updateTeamFields(teamId, request);
  }

  ///监听群资料变化
  Stream<List<NIMSuperTeam>> get onSuperTeamUpdate =>
      SuperTeamServicePlatform.instance.onSuperTeamUpdate.stream;

  ///监听移除群的变化
  Stream<NIMSuperTeam> get onSuperTeamRemove =>
      SuperTeamServicePlatform.instance.onSuperTeamRemove.stream;

  ///群消息免打扰
  ///设置指定群消息通知类型
  ///[teamId] 群Id
  ///[notifyType] 群消息类型
  Future<NIMResult<void>> muteTeam(
      String teamId, NIMTeamMessageNotifyTypeEnum notifyType) async {
    return _platform.muteTeam(teamId, notifyType);
  }

  ///用户可以查询到具有指定群名称的群ID的列表 (iOS 暂不支持)
  ///[name] 群名称
  Future<NIMResult<List<String>>> searchTeamIdByName(String name) async {
    return _platform.searchTeamIdByName(name);
  }

  /// 用户在客户端本地可以搜索与关键字匹配的所有群：（iOS暂不支持）
  /// [keyword] 要搜索的关键字
  Future<NIMResult<List<NIMSuperTeam>>> searchTeamsByKeyword(
      String keyword) async {
    return _platform.searchTeamsByKeyword(keyword);
  }
}
