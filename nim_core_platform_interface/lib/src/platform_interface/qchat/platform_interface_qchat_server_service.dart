// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/method_channel/method_channel_qchat_server_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class QChatServerServicePlatform extends Service {
  QChatServerServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static QChatServerServicePlatform _instance =
      MethodChannelQChatServerService();

  static QChatServerServicePlatform get instance => _instance;

  static set instance(QChatServerServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<NIMResult<void>> acceptServerApply(
      QChatAcceptServerApplyParam param) async {
    throw UnimplementedError('acceptServerApply is not implemented');
  }

  Future<NIMResult<void>> acceptServerInvite(
      QChatAcceptServerInviteParam param) async {
    throw UnimplementedError('acceptServerInvite is not implemented');
  }

  Future<NIMResult<QChatApplyServerJoinResult>> applyServerJoin(
      QChatApplyServerJoinParam param) async {
    throw UnimplementedError('applyServerJoin is not implemented');
  }

  Future<NIMResult<QChatCreateServerResult>> createServer(
      QChatCreateServerParam param) async {
    throw UnimplementedError('createServer is not implemented');
  }

  Future<NIMResult<void>> deleteServer(QChatDeleteServerParam param) async {
    throw UnimplementedError('deleteServer is not implemented');
  }

  Future<NIMResult<QChatGetServerMembersResult>> getServerMembers(
      QChatGetServerMembersParam param) async {
    throw UnimplementedError('getServerMembers is not implemented');
  }

  Future<NIMResult<QChatGetServerMembersByPageResult>> getServerMembersByPage(
      QChatGetServerMembersByPageParam param) async {
    throw UnimplementedError('getServerMembersByPage is not implemented');
  }

  Future<NIMResult<QChatGetServersResult>> getServers(
      QChatGetServersParam param) async {
    throw UnimplementedError('getServers is not implemented');
  }

  Future<NIMResult<QChatGetServersByPageResult>> getServersByPage(
      QChatGetServersByPageParam param) async {
    throw UnimplementedError('getServersByPage is not implemented');
  }

  Future<NIMResult<QChatInviteServerMembersResult>> inviteServerMembers(
      QChatInviteServerMembersParam param) async {
    throw UnimplementedError('inviteServerMembers is not implemented');
  }

  Future<NIMResult<void>> kickServerMembers(
      QChatKickServerMembersParam param) async {
    throw UnimplementedError('kickServerMembers is not implemented');
  }

  Future<NIMResult<void>> leaveServer(QChatLeaveServerParam param) async {
    throw UnimplementedError('leaveServer is not implemented');
  }

  Future<NIMResult<void>> rejectServerApply(
      QChatRejectServerApplyParam param) async {
    throw UnimplementedError('rejectServerApply is not implemented');
  }

  Future<NIMResult<void>> rejectServerInvite(
      QChatRejectServerInviteParam param) async {
    throw UnimplementedError('rejectServerInvite is not implemented');
  }

  Future<NIMResult<QChatUpdateServerResult>> updateServer(
      QChatUpdateServerParam param) async {
    throw UnimplementedError('updateServer is not implemented');
  }

  Future<NIMResult<QChatUpdateMyMemberInfoResult>> updateMyMemberInfo(
      QChatUpdateMyMemberInfoParam param) async {
    throw UnimplementedError('updateMyMemberInfo is not implemented');
  }

  Future<NIMResult<QChatSubscribeServerResult>> subscribeServer(
      QChatSubscribeServerParam param) async {
    throw UnimplementedError('subscribeServer is not implemented');
  }

  Future<NIMResult<QChatSearchServerByPageResult>> searchServerByPage(
      QChatSearchServerByPageParam param) async {
    throw UnimplementedError('searchServerByPage is not implemented');
  }

  Future<NIMResult<QChatGenerateInviteCodeResult>> generateInviteCode(
      QChatGenerateInviteCodeParam param) async {
    throw UnimplementedError('generateInviteCode is not implemented');
  }

  Future<NIMResult<void>> joinByInviteCode(
      QChatJoinByInviteCodeParam param) async {
    throw UnimplementedError('joinByInviteCode is not implemented');
  }

  Future<NIMResult<QChatUpdateServerMemberInfoResult>> updateServerMemberInfo(
      QChatUpdateServerMemberInfoParam param) async {
    throw UnimplementedError('updateServerMemberInfo is not implemented');
  }

  Future<NIMResult<void>> banServerMember(
      QChatBanServerMemberParam param) async {
    throw UnimplementedError('banServerMember is not implemented');
  }

  Future<NIMResult<void>> unbanServerMember(
      QChatUnbanServerMemberParam param) async {
    throw UnimplementedError('unbanServerMember is not implemented');
  }

  Future<NIMResult<QChatGetBannedServerMembersByPageResult>>
      getBannedServerMembersByPage(
          QChatGetBannedServerMembersByPageParam param) async {
    throw UnimplementedError('getBannedServerMembersByPage is not implemented');
  }

  Future<NIMResult<void>> updateUserServerPushConfig(
      QChatUpdateUserServerPushConfigParam param) async {
    throw UnimplementedError('updateUserServerPushConfig is not implemented');
  }

  Future<NIMResult<QChatGetUserPushConfigsResult>> getUserServerPushConfigs(
      QChatGetUserServerPushConfigsParam param) async {
    throw UnimplementedError('getUserServerPushConfigs is not implemented');
  }

  Future<NIMResult<QChatSearchServerMemberByPageResult>>
      searchServerMemberByPage(QChatSearchServerMemberByPageParam param) async {
    throw UnimplementedError('searchServerMemberByPage is not implemented');
  }

  // Future<NIMResult<QChatGetInviteApplyRecordOfServerResult>>
  //     getInviteApplyRecordOfServer(
  //         QChatGetInviteApplyRecordOfServerParam param) async {
  //   throw UnimplementedError('getInviteApplyRecordOfServer is not implemented');
  // }
  //
  // Future<NIMResult<QChatGetInviteApplyRecordOfSelfResult>>
  //     getInviteApplyRecordOfSelf(
  //         QChatGetInviteApplyRecordOfSelfParam param) async {
  //   throw UnimplementedError('getInviteApplyRecordOfSelf is not implemented');
  // }

  Future<NIMResult<QChatServerMarkReadResult>> markRead(
      QChatServerMarkReadParam param) async {
    throw UnimplementedError('markRead is not implemented');
  }

  Future<NIMResult<QChatSubscribeAllChannelResult>> subscribeAllChannel(
      QChatSubscribeAllChannelParam param) async {
    throw UnimplementedError('subscribeAllChannel is not implemented');
  }

  Future<NIMResult<QChatSubscribeServerAsVisitorResult>> subscribeAsVisitor(
      QChatSubscribeServerAsVisitorParam param) async {
    throw UnimplementedError('subscribeAsVisitor is not implemented');
  }

  Future<NIMResult<QChatEnterServerAsVisitorResult>> enterAsVisitor(
      QChatEnterServerAsVisitorParam param) async {
    throw UnimplementedError('enterAsVisitor is not implemented');
  }

  Future<NIMResult<QChatLeaveServerAsVisitorResult>> leaveAsVisitor(
      QChatLeaveServerAsVisitorParam param) async {
    throw UnimplementedError('leaveAsVisitor is not implemented');
  }
}
