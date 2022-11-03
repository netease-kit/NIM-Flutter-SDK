// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class MethodChannelQChatServerService extends QChatServerServicePlatform {
  @override
  String get serviceName => 'QChatServerService';

  @override
  Future onEvent(String method, arguments) {
    throw UnimplementedError();
  }

  @override
  Future<NIMResult<void>> acceptServerApply(
      QChatAcceptServerApplyParam param) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('acceptServerApply', arguments: param.toJson()));
  }

  @override
  Future<NIMResult<void>> acceptServerInvite(
      QChatAcceptServerInviteParam param) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('acceptServerInvite', arguments: param.toJson()));
  }

  @override
  Future<NIMResult<QChatApplyServerJoinResult>> applyServerJoin(
      QChatApplyServerJoinParam param) async {
    return NIMResult<QChatApplyServerJoinResult>.fromMap(
        await invokeMethod('applyServerJoin', arguments: param.toJson()),
        convert: (json) => QChatApplyServerJoinResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatCreateServerResult>> createServer(
      QChatCreateServerParam param) async {
    return NIMResult<QChatCreateServerResult>.fromMap(
        await invokeMethod('createServer', arguments: param.toJson()),
        convert: (json) => QChatCreateServerResult.fromJson(json));
  }

  @override
  Future<NIMResult<void>> deleteServer(QChatDeleteServerParam param) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('deleteServer', arguments: param.toJson()));
  }

  @override
  Future<NIMResult<QChatGetServerMembersResult>> getServerMembers(
      QChatGetServerMembersParam param) async {
    return NIMResult<QChatGetServerMembersResult>.fromMap(
        await invokeMethod('getServerMembers', arguments: param.toJson()),
        convert: (json) => QChatGetServerMembersResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetServerMembersByPageResult>> getServerMembersByPage(
      QChatGetServerMembersByPageParam param) async {
    return NIMResult<QChatGetServerMembersByPageResult>.fromMap(
        await invokeMethod('getServerMembersByPage', arguments: param.toJson()),
        convert: (json) => QChatGetServerMembersByPageResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetServersResult>> getServers(
      QChatGetServersParam param) async {
    return NIMResult<QChatGetServersResult>.fromMap(
        await invokeMethod('getServers', arguments: param.toJson()),
        convert: (json) => QChatGetServersResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetServersByPageResult>> getServersByPage(
      QChatGetServersByPageParam param) async {
    return NIMResult<QChatGetServersByPageResult>.fromMap(
        await invokeMethod('getServersByPage', arguments: param.toJson()),
        convert: (json) => QChatGetServersByPageResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatInviteServerMembersResult>> inviteServerMembers(
      QChatInviteServerMembersParam param) async {
    return NIMResult<QChatInviteServerMembersResult>.fromMap(
        await invokeMethod('inviteServerMembers', arguments: param.toJson()),
        convert: (json) => QChatInviteServerMembersResult.fromJson(json));
  }

  @override
  Future<NIMResult<void>> kickServerMembers(
      QChatKickServerMembersParam param) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('kickServerMembers', arguments: param.toJson()));
  }

  @override
  Future<NIMResult<void>> leaveServer(QChatLeaveServerParam param) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('leaveServer', arguments: param.toJson()));
  }

  @override
  Future<NIMResult<void>> rejectServerApply(
      QChatRejectServerApplyParam param) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('rejectServerApply', arguments: param.toJson()));
  }

  @override
  Future<NIMResult<void>> rejectServerInvite(
      QChatRejectServerInviteParam param) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('rejectServerInvite', arguments: param.toJson()));
  }

  @override
  Future<NIMResult<QChatUpdateServerResult>> updateServer(
      QChatUpdateServerParam param) async {
    return NIMResult<QChatUpdateServerResult>.fromMap(
        await invokeMethod('updateServer', arguments: param.toJson()),
        convert: (json) => QChatUpdateServerResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatUpdateMyMemberInfoResult>> updateMyMemberInfo(
      QChatUpdateMyMemberInfoParam param) async {
    return NIMResult<QChatUpdateMyMemberInfoResult>.fromMap(
        await invokeMethod('updateMyMemberInfo', arguments: param.toJson()),
        convert: (json) => QChatUpdateMyMemberInfoResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatSubscribeServerResult>> subscribeServer(
      QChatSubscribeServerParam param) async {
    return NIMResult<QChatSubscribeServerResult>.fromMap(
        await invokeMethod('subscribeServer', arguments: param.toJson()),
        convert: (json) => QChatSubscribeServerResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatSearchServerByPageResult>> searchServerByPage(
      QChatSearchServerByPageParam param) async {
    return NIMResult<QChatSearchServerByPageResult>.fromMap(
        await invokeMethod('searchServerByPage', arguments: param.toJson()),
        convert: (json) => QChatSearchServerByPageResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGenerateInviteCodeResult>> generateInviteCode(
      QChatGenerateInviteCodeParam param) async {
    return NIMResult<QChatGenerateInviteCodeResult>.fromMap(
        await invokeMethod('generateInviteCode', arguments: param.toJson()),
        convert: (json) => QChatGenerateInviteCodeResult.fromJson(json));
  }

  @override
  Future<NIMResult<void>> joinByInviteCode(
      QChatJoinByInviteCodeParam param) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('joinByInviteCode', arguments: param.toJson()));
  }
}
