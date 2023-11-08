// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class MethodChannelQChatRoleService extends QChatRoleServicePlatform {
  @override
  String get serviceName => 'QChatRoleService';

  @override
  Future onEvent(String method, arguments) {
    throw UnimplementedError();
  }

  @override
  Future<NIMResult<QChatCreateServerRoleResult>> createServerRole(
      QChatCreateServerRoleParam param) async {
    return NIMResult<QChatCreateServerRoleResult>.fromMap(
        await invokeMethod('createServerRole', arguments: param.toJson()),
        convert: (json) => QChatCreateServerRoleResult.fromJson(json));
  }

  @override
  Future<NIMResult<void>> deleteServerRole(
      QChatDeleteServerRoleParam param) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('deleteServerRole', arguments: param.toJson()));
  }

  @override
  Future<NIMResult<QChatUpdateServerRoleResult>> updateServerRole(
      QChatUpdateServerRoleParam param) async {
    return NIMResult<QChatUpdateServerRoleResult>.fromMap(
        await invokeMethod('updateServerRole', arguments: param.toJson()),
        convert: (json) => QChatUpdateServerRoleResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatUpdateServerRolePrioritiesResult>>
      updateServerRolePriorities(
          QChatUpdateServerRolePrioritiesParam param) async {
    return NIMResult<QChatUpdateServerRolePrioritiesResult>.fromMap(
        await invokeMethod('updateServerRolePriorities',
            arguments: param.toJson()),
        convert: (json) =>
            QChatUpdateServerRolePrioritiesResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetServerRolesResult>> getServerRoles(
      QChatGetServerRolesParam param) async {
    return NIMResult<QChatGetServerRolesResult>.fromMap(
        await invokeMethod('getServerRoles', arguments: param.toJson()),
        convert: (json) => QChatGetServerRolesResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatAddChannelRoleResult>> addChannelRole(
      QChatAddChannelRoleParam param) async {
    return NIMResult<QChatAddChannelRoleResult>.fromMap(
        await invokeMethod('addChannelRole', arguments: param.toJson()),
        convert: (json) => QChatAddChannelRoleResult.fromJson(json));
  }

  @override
  Future<NIMResult<void>> removeChannelRole(
      QChatRemoveChannelRoleParam param) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('removeChannelRole', arguments: param.toJson()));
  }

  @override
  Future<NIMResult<QChatUpdateChannelRoleResult>> updateChannelRole(
      QChatUpdateChannelRoleParam param) async {
    return NIMResult<QChatUpdateChannelRoleResult>.fromMap(
        await invokeMethod('updateChannelRole', arguments: param.toJson()),
        convert: (json) => QChatUpdateChannelRoleResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetChannelRolesResult>> getChannelRoles(
      QChatGetChannelRolesParam param) async {
    return NIMResult<QChatGetChannelRolesResult>.fromMap(
        await invokeMethod('getChannelRoles', arguments: param.toJson()),
        convert: (json) => QChatGetChannelRolesResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatAddMembersToServerRoleResult>> addMembersToServerRole(
      QChatAddMembersToServerRoleParam param) async {
    return NIMResult<QChatAddMembersToServerRoleResult>.fromMap(
        await invokeMethod('addMembersToServerRole', arguments: param.toJson()),
        convert: (json) => QChatAddMembersToServerRoleResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatRemoveMembersFromServerRoleResult>>
      removeMembersFromServerRole(
          QChatRemoveMembersFromServerRoleParam param) async {
    return NIMResult<QChatRemoveMembersFromServerRoleResult>.fromMap(
        await invokeMethod('removeMembersFromServerRole',
            arguments: param.toJson()),
        convert: (json) =>
            QChatRemoveMembersFromServerRoleResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetMembersFromServerRoleResult>>
      getMembersFromServerRole(QChatGetMembersFromServerRoleParam param) async {
    return NIMResult<QChatGetMembersFromServerRoleResult>.fromMap(
        await invokeMethod('getMembersFromServerRole',
            arguments: param.toJson()),
        convert: (json) => QChatGetMembersFromServerRoleResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetServerRolesByAccidResult>> getServerRolesByAccid(
      QChatGetServerRolesByAccidParam param) async {
    return NIMResult<QChatGetServerRolesByAccidResult>.fromMap(
        await invokeMethod('getServerRolesByAccid', arguments: param.toJson()),
        convert: (json) => QChatGetServerRolesByAccidResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetExistingServerRolesByAccidsResult>>
      getExistingServerRolesByAccids(
          QChatGetExistingServerRolesByAccidsParam param) async {
    return NIMResult<QChatGetExistingServerRolesByAccidsResult>.fromMap(
        await invokeMethod('getExistingServerRolesByAccids',
            arguments: param.toJson()),
        convert: (json) =>
            QChatGetExistingServerRolesByAccidsResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetExistingAccidsInServerRoleResult>>
      getExistingAccidsInServerRole(
          QChatGetExistingAccidsInServerRoleParam param) async {
    return NIMResult<QChatGetExistingAccidsInServerRoleResult>.fromMap(
        await invokeMethod('getExistingAccidsInServerRole',
            arguments: param.toJson()),
        convert: (json) =>
            QChatGetExistingAccidsInServerRoleResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetExistingChannelRolesByServerRoleIdsResult>>
      getExistingChannelRolesByServerRoleIds(
          QChatGetExistingChannelRolesByServerRoleIdsParam param) async {
    return NIMResult<QChatGetExistingChannelRolesByServerRoleIdsResult>.fromMap(
        await invokeMethod('getExistingChannelRolesByServerRoleIds',
            arguments: param.toJson()),
        convert: (json) =>
            QChatGetExistingChannelRolesByServerRoleIdsResult.fromJson(json));
  }

  @override
  Future<NIMResult<QChatGetExistingAccidsOfMemberRolesResult>>
      getExistingAccidsOfMemberRoles(
          QChatGetExistingAccidsOfMemberRolesParam param) async {
    return NIMResult<QChatGetExistingAccidsOfMemberRolesResult>.fromMap(
        await invokeMethod('getExistingAccidsOfMemberRoles',
            arguments: param.toJson()),
        convert: (json) =>
            QChatGetExistingAccidsOfMemberRolesResult.fromJson(json));
  }

  Future<NIMResult<QChatAddMemberRoleResult>> addMemberRole(
      QChatAddMemberRoleParam param) async {
    return NIMResult<QChatAddMemberRoleResult>.fromMap(
        await invokeMethod('addMemberRole', arguments: param.toJson()),
        convert: (json) => QChatAddMemberRoleResult.fromJson(json));
  }

  Future<NIMResult<void>> removeMemberRole(
      QChatRemoveMemberRoleParam param) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('removeMemberRole', arguments: param.toJson()));
  }

  Future<NIMResult<QChatUpdateMemberRoleResult>> updateMemberRole(
      QChatUpdateMemberRoleParam param) async {
    return NIMResult<QChatUpdateMemberRoleResult>.fromMap(
        await invokeMethod('updateMemberRole', arguments: param.toJson()),
        convert: (json) => QChatUpdateMemberRoleResult.fromJson(json));
  }

  Future<NIMResult<QChatGetMemberRolesResult>> getMemberRoles(
      QChatGetMemberRolesParam param) async {
    return NIMResult<QChatGetMemberRolesResult>.fromMap(
        await invokeMethod('getMemberRoles', arguments: param.toJson()),
        convert: (json) => QChatGetMemberRolesResult.fromJson(json));
  }

  Future<NIMResult<QChatCheckPermissionResult>> checkPermission(
      QChatCheckPermissionParam param) async {
    return NIMResult<QChatCheckPermissionResult>.fromMap(
        await invokeMethod('checkPermission', arguments: param.toJson()),
        convert: (json) => QChatCheckPermissionResult.fromJson(json));
  }

  Future<NIMResult<QChatCheckPermissionsResult>> checkPermissions(
      QChatCheckPermissionsParam param) async {
    return NIMResult<QChatCheckPermissionsResult>.fromMap(
        await invokeMethod('checkPermissions', arguments: param.toJson()),
        convert: (json) => QChatCheckPermissionsResult.fromJson(json));
  }
}
