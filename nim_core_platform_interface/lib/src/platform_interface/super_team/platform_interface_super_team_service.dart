// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/method_channel/method_channel_super_team_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class SuperTeamServicePlatform extends Service {
  SuperTeamServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static SuperTeamServicePlatform _instance = MethodChannelSuperTeamService();

  static SuperTeamServicePlatform get instance => _instance;

  static set instance(SuperTeamServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  ///获取自己加入的群的列表
  Future<NIMResult<List<NIMSuperTeam>>> queryTeamList() async {
    throw UnimplementedError('queryTeamList() is not implemented');
  }

  ///根据群id列表批量查询群信息
  Future<NIMResult<List<NIMSuperTeam>>> queryTeamListById(
      List<String> idList) async {
    throw UnimplementedError('queryTeamListById() is not implemented');
  }

  ///查询群资料，如果本地没有群组资料，则去服务器查询。
  ///如果自己不在这个群中，该接口返回的可能是过期资料，如需最新的，请调用searchTeam(String teamId)接口
  Future<NIMResult<NIMSuperTeam>> queryTeam(String teamId) async {
    throw UnimplementedError('queryTeam() is not implemented');
  }

  ///从服务器上查询群资料信息
  Future<NIMResult<NIMSuperTeam>> searchTeam(String teamId) async {
    throw UnimplementedError('searchTeam() is not implemented');
  }

  ///申请加入一个群，直接加入或者进入等待验证状态时，返回群信息
  Future<NIMResult<NIMSuperTeam>> applyJoinTeam(
      String teamId, String postscript) async {
    throw UnimplementedError('applyJoinTeam() is not implemented');
  }

  ///通过用户的入群申请<br>
  /// 仅管理员和拥有者有此权限
  Future<NIMResult<void>> passApply(String teamId, String account) async {
    throw UnimplementedError('passApply() is not implemented');
  }

  ///拒绝用户的入群申请
  /// 仅管理员和拥有者有此权限
  Future<NIMResult<void>> rejectApply(
      String teamId, String account, String reason) async {
    throw UnimplementedError('rejectApply() is not implemented');
  }

  ///邀请成员
  Future<NIMResult<List<String>>> addMembers(
      String teamId, List<String> accountList, String msg) async {
    throw UnimplementedError('addMembers() is not implemented');
  }

  ///接受别人的入群邀请
  Future<NIMResult<void>> acceptInvite(String teamId, String inviter) async {
    throw UnimplementedError('acceptInvite() is not implemented');
  }

  ///拒绝入群邀请
  Future<NIMResult<void>> declineInvite(
      String teamId, String inviter, String reaseon) async {
    throw UnimplementedError('declineInvite() is not implemented');
  }

  ///移除成员，只有群主有此权限
  Future<NIMResult<void>> removeMembers(
      String teamId, List<String> members) async {
    throw UnimplementedError('removeMembers() is not implemented');
  }

  ///主动退群
  Future<NIMResult<void>> quitTeam(String teamId) async {
    throw UnimplementedError('quitTeam() is not implemented');
  }

  ///获取群组成员列表
  Future<NIMResult<List<NIMSuperTeamMember>>> queryMemberList(
      String teamId) async {
    throw UnimplementedError('queryMemberList() is not implemented');
  }

  ///获取指定群组成员
  Future<NIMResult<NIMSuperTeamMember>> queryTeamMember(
      String teamId, String account) async {
    throw UnimplementedError('queryTeamMember() is not implemented');
  }

  ///分页获取群组成员（Windows & macOS暂不支持）
  Future<NIMResult<List<NIMSuperTeamMember>>> queryMemberListByPage(
      String teamId, int offset, int limit) async {
    throw UnimplementedError('queryMemberListByPage() is not implemented');
  }

  /// 群组管理员修改群内其他成员的群昵称。
  /// 仅群管理员和拥有者有此权限
  Future<NIMResult<void>> updateMemberNick(
      String teamId, String account, String nick) async {
    throw UnimplementedError('updateMemberNick() is not implemented');
  }

  /// 群修改自己的群昵称
  Future<NIMResult<void>> updateMyTeamNick(String teamId, String nick) async {
    throw UnimplementedError('updateMyTeamNick() is not implemented');
  }

  ///修改自己的群成员扩展字段（自定义属性, 最长32个字符）
  Future<NIMResult<void>> updateMyMemberExtension(
      String teamId, Map<String, Object> extension) async {
    throw UnimplementedError('updateMyMemberExtension() is not implemented');
  }

  /// 群成员资料变化观察者通知。
  /// 上层APP如果管理了群成员资料的缓存，可通过此接口更新缓存。
  /// observer 观察者, 参数为有更新的群成员资料列表
  /// [register] true为注册，false为注销
  //ignore: close_sinks
  final StreamController<List<NIMSuperTeamMember>> onMemberUpdate =
      StreamController<List<NIMSuperTeamMember>>.broadcast();

  /// 移除群成员的观察者通知。
  /// observer 观察者, 参数为被移除的群成员
  //ignore: close_sinks
  final StreamController<List<NIMSuperTeamMember>> onMemberRemove =
      StreamController<List<NIMSuperTeamMember>>.broadcast();

  ///拥有者将群的拥有者权限转给另外一个人，转移后，另外一个人成为拥有者
  ///原拥有者变成普通成员。若参数quit为true，原拥有者直接退出该群
  Future<NIMResult<List<NIMSuperTeamMember>>> transferTeam(
      String tid, String account, bool quit) async {
    throw UnimplementedError('transferTeam() is not implemented');
  }

  ///拥有者添加管理员
  Future<NIMResult<List<NIMSuperTeamMember>>> addManagers(
      String teamId, List<String> accountList) async {
    throw UnimplementedError('addManagers() is not implemented');
  }

  ///移除管理员
  ///拥有者撤销管理员权限
  Future<NIMResult<List<NIMSuperTeamMember>>> removeManagers(
      String teamId, List<String> accountList) async {
    throw UnimplementedError('removeManagers() is not implemented');
  }

  ///禁言指定成员
  ///支持管理员和群主对普通成员的禁言、解除禁言操作。
  Future<NIMResult<void>> muteTeamMember(
      String teamId, List<String> accountList, bool mute) async {
    throw UnimplementedError('muteTeamMember() is not implemented');
  }

  ///禁言群全体成员
  ///将整个群禁言，该操作仅群主或者管理员有权限。禁言操作成功之后，会回调群更新接口，影响方法
  Future<NIMResult<void>> muteAllTeamMember(String teamId, bool mute) async {
    throw UnimplementedError('muteAllTeamMember() is not implemented');
  }

  ///查询被禁言群成员
  ///该操作只返回被禁言的用户，群整体禁言情况请通过 Team#getMuteMode 和 Team#isAllMute 查询
  Future<NIMResult<List<NIMSuperTeamMember>>> queryMutedTeamMembers(
      String teamId) async {
    throw UnimplementedError('queryMutedTeamMembers() is not implemented');
  }

  ///编辑多个资料
  Future<NIMResult<void>> updateTeamFields(
      String teamId, NIMTeamUpdateFieldRequest request) async {
    throw UnimplementedError('updateTeamFields() is not implemented');
  }

  ///监听群资料变化
  //ignore: close_sinks
  final StreamController<List<NIMSuperTeam>> onSuperTeamUpdate =
      StreamController<List<NIMSuperTeam>>.broadcast();

  ///监听移除群的变化
  //ignore: close_sinks
  final StreamController<NIMSuperTeam> onSuperTeamRemove =
      StreamController<NIMSuperTeam>.broadcast();

  ///群消息免打扰
  ///设置指定群消息通知类型
  Future<NIMResult<void>> muteTeam(
      String teamId, NIMTeamMessageNotifyTypeEnum notifyType) async {
    throw UnimplementedError('muteTeam() is not implemented');
  }

  ///用户可以查询到具有指定群名称的群ID的列表（Windows & macOS暂不支持）
  Future<NIMResult<List<String>>> searchTeamIdByName(String name) async {
    throw UnimplementedError('searchTeamIdByName() is not implemented');
  }

  /// 用户在客户端本地可以搜索与关键字匹配的所有群：
  /// 通过群名称反查群组ID
  /// name 群组名称
  /// 群ID列表
  Future<NIMResult<List<NIMSuperTeam>>> searchTeamsByKeyword(
      String keyword) async {
    throw UnimplementedError('searchTeamsByKeyword() is not implemented');
  }
}
