// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/method_channel/method_channel_team_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class TeamServicePlatform extends Service {
  TeamServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static TeamServicePlatform _instance = MethodChannelTeamService();

  static TeamServicePlatform get instance => _instance;

  static set instance(TeamServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<NIMResult<NIMCreateTeamResult>> createTeam(
      NIMCreateTeamOptions createTeamOptions, List<String> members) async {
    throw UnimplementedError('createTeam() is not implemented');
  }

  Future<NIMResult<List<NIMTeam>>> queryTeamList() async {
    throw UnimplementedError('queryTeamList() is not implemented');
  }

  Future<NIMResult<NIMTeam>> queryTeam(String teamId) async {
    throw UnimplementedError('queryTeam() is not implemented');
  }

  Future<NIMResult<NIMTeam>> searchTeam(String teamId) async {
    throw UnimplementedError('searchTeam() is not implemented');
  }

  Future<NIMResult<void>> dismissTeam(String teamId) async {
    throw UnimplementedError('dismissTeam() is not implemented');
  }

  Future<NIMResult<NIMTeam>> applyJoinTeam(
      String teamId, String postscript) async {
    throw UnimplementedError('applyJoinTeam() is not implemented');
  }

  Future<NIMResult<void>> passApply(String teamId, String account) async {
    throw UnimplementedError('passApply() is not implemented');
  }

  Future<NIMResult<void>> rejectApply(
      String teamId, String account, String reason) async {
    throw UnimplementedError('rejectApply() is not implemented');
  }

  Future<NIMResult<List<String>>> addMembersEx(String teamId,
      List<String> accounts, String msg, String customInfo) async {
    throw UnimplementedError('addMembersEx() is not implemented');
  }

  Future<NIMResult<NIMTeamMember>> queryTeamMember(
      String teamId, String account) async {
    throw UnimplementedError('queryTeamMember() is not implemented');
  }

  Future<NIMResult<void>> acceptInvite(String teamId, String inviter) async {
    throw UnimplementedError('acceptInvite() is not implemented');
  }

  Future<NIMResult<void>> declineInvite(
      String teamId, String inviter, String reason) async {
    throw UnimplementedError('declineInvite() is not implemented');
  }

  Future<NIMResult<Map<String, String>>> getMemberInvitor(
      String teamId, List<String> accids) async {
    throw UnimplementedError('getMemberInvitor() is not implemented');
  }

  Future<NIMResult<void>> removeMembers(
      String teamId, List<String> members) async {
    throw UnimplementedError('removeMembers() is not implemented');
  }

  Future<NIMResult<void>> quitTeam(String teamId) async {
    throw UnimplementedError('quitTeam() is not implemented');
  }

  Future<NIMResult<List<NIMTeamMember>>> queryMemberList(String teamId) async {
    throw UnimplementedError('queryMemberList() is not implemented');
  }

  Future<NIMResult<void>> updateMemberNick(
      String teamId, String account, String nick) async {
    throw UnimplementedError('updateMemberNick() is not implemented');
  }

  Future<NIMResult<void>> updateMyMemberExtension(
      String teamId, Map<String, Object> extension) async {
    throw UnimplementedError('updateMemberNick() is not implemented');
  }

  /// 群成员资料变化观察者通知。
  /// 上层APP如果管理了群成员资料的缓存，可通过此接口更新缓存。
  /// observer 观察者, 参数为有更新的群成员资料列表
  /// [register] true为注册，false为注销
  // ignore: close_sinks
  final StreamController<List<NIMTeamMember>> onMemberUpdate =
      StreamController<List<NIMTeamMember>>.broadcast();

  Future<NIMResult<List<NIMTeamMember>>> transferTeam(
      String tid, String account, bool quit) async {
    throw UnimplementedError('transferTeam() is not implemented');
  }

  Future<NIMResult<List<NIMTeamMember>>> addManagers(
      String teamId, List<String> accounts) async {
    throw UnimplementedError('addManagers() is not implemented');
  }

  Future<NIMResult<List<NIMTeamMember>>> removeManagers(
      String teamId, List<String> managers) async {
    throw UnimplementedError('removeManagers() is not implemented');
  }

  Future<NIMResult<void>> muteTeamMember(
      String teamId, String account, bool mute) async {
    throw UnimplementedError('muteTeamMember() is not implemented');
  }

  Future<NIMResult<List<NIMTeamMember>>> queryMutedTeamMembers(
      String teamId) async {
    throw UnimplementedError('queryMutedTeamMembers() is not implemented');
  }

  Future<NIMResult<void>> muteAllTeamMember(String teamId, bool mute) async {
    throw UnimplementedError('muteAllTeamMember() is not implemented');
  }

  Future<NIMResult<void>> updateTeamFields(
      String teamId, NIMTeamUpdateFieldRequest request) async {
    throw UnimplementedError('updateTeamFields() is not implemented');
  }

  //ignore: close_sinks
  final StreamController<List<NIMTeam>> onTeamListUpdate =
      StreamController<List<NIMTeam>>.broadcast();

  //ignore: close_sinks
  final StreamController<List<NIMTeam>> onTeamListRemove =
      StreamController<List<NIMTeam>>.broadcast();

  //ignore: close_sinks
  final StreamController<List<NIMTeamMember>> onTeamMemberUpdate =
      StreamController<List<NIMTeamMember>>.broadcast();

  //ignore: close_sinks
  final StreamController<List<NIMTeamMember>> onTeamMemberRemove =
      StreamController<List<NIMTeamMember>>.broadcast();

  ///群组通知消息
  /// 群组通知的消息类型是 MsgTypeEnum.notification ，用户入群成功之后，任何关于群的变动(含自己入群的动作)，云信服务器都会下发一条群通知消息。
  ///
  /// 目前支持触发群通知消息的事件有：
  ///
  /// NotificationType 枚举	附件类	事件说明
  /// AcceptInvite	MemberChangeAttachment	接受邀请后入群（需要被邀请人同意的模式）
  /// InviteMember	MemberChangeAttachment	邀请成员入群（无需被邀请人同意的模式）
  /// AddTeamManager	MemberChangeAttachment	添加管理员
  /// KickMember	MemberChangeAttachment	被踢出群
  /// TransferOwner	MemberChangeAttachment	转让群主
  /// PassTeamApply	MemberChangeAttachment	申请加入群成功
  /// RemoveTeamManager	MemberChangeAttachment	移除管理员
  /// DismissTeam	DismissAttachment	解散群
  /// LeaveTeam	LeaveTeamAttachment	退出群
  /// MuteTeamMember	MuteMemberAttachment	群内禁言/解禁
  /// UpdateTeam	UpdateTeamAttachment	群信息资料更新
  // ignore: close_sinks
  final StreamController<List<NIMMessageReceipt>> observeTeamNotification =
      StreamController<List<NIMMessageReceipt>>.broadcast();

  Future<NIMResult<void>> muteTeam(
      String teamId, NIMTeamMessageNotifyTypeEnum notifyType) async {
    throw UnimplementedError('muteTeam() is not implemented');
  }

  Future<NIMResult<List<String>>> searchTeamIdByName(String name) async {
    throw UnimplementedError('searchTeamIdByName() is not implemented');
  }

  /// 用户在客户端本地可以搜索与关键字匹配的所有群：
  /// 通过群名称反查群组ID
  /// name 群组名称
  /// 群ID列表
  Future<NIMResult<List<NIMTeam>>> searchTeamsByKeyword(String keyword) async {
    throw UnimplementedError('searchTeamsByKeyword() is not implemented');
  }

  /// 修改自己的群昵称
  ///
  /// [teamId] 所在群组ID
  /// [nick] 新的群昵称
  Future<NIMResult<void>> updateMyTeamNick(String teamId, String nick) async {
    throw UnimplementedError('updateMyTeamNick() is not implemented');
  }
}
