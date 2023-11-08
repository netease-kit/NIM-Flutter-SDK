// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/method_channel/method_channel_qchat_role_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class QChatRoleServicePlatform extends Service {
  QChatRoleServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static QChatRoleServicePlatform _instance = MethodChannelQChatRoleService();

  static QChatRoleServicePlatform get instance => _instance;

  static set instance(QChatRoleServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<NIMResult<QChatCreateServerRoleResult>> createServerRole(
      QChatCreateServerRoleParam param) async {
    throw UnimplementedError('createServerRole is not implemented');
  }

  Future<NIMResult<void>> deleteServerRole(
      QChatDeleteServerRoleParam param) async {
    throw UnimplementedError('deleteServerRole is not implemented');
  }

  Future<NIMResult<QChatUpdateServerRoleResult>> updateServerRole(
      QChatUpdateServerRoleParam param) async {
    throw UnimplementedError('updateServerRole is not implemented');
  }

  Future<NIMResult<QChatUpdateServerRolePrioritiesResult>>
      updateServerRolePriorities(
          QChatUpdateServerRolePrioritiesParam param) async {
    throw UnimplementedError('updateServerRolePriorities is not implemented');
  }

  Future<NIMResult<QChatGetServerRolesResult>> getServerRoles(
      QChatGetServerRolesParam param) async {
    throw UnimplementedError('getServerRoles is not implemented');
  }

  Future<NIMResult<QChatAddChannelRoleResult>> addChannelRole(
      QChatAddChannelRoleParam param) async {
    throw UnimplementedError('addChannelRole is not implemented');
  }

  Future<NIMResult<void>> removeChannelRole(
      QChatRemoveChannelRoleParam param) async {
    throw UnimplementedError('removeChannelRole is not implemented');
  }

  Future<NIMResult<QChatUpdateChannelRoleResult>> updateChannelRole(
      QChatUpdateChannelRoleParam param) async {
    throw UnimplementedError('updateChannelRole is not implemented');
  }

  Future<NIMResult<QChatGetChannelRolesResult>> getChannelRoles(
      QChatGetChannelRolesParam param) async {
    throw UnimplementedError('getChannelRoles is not implemented');
  }

  Future<NIMResult<QChatAddMembersToServerRoleResult>> addMembersToServerRole(
      QChatAddMembersToServerRoleParam param) async {
    throw UnimplementedError('addMembersToServerRole is not implemented');
  }

  Future<NIMResult<QChatRemoveMembersFromServerRoleResult>>
      removeMembersFromServerRole(
          QChatRemoveMembersFromServerRoleParam param) async {
    throw UnimplementedError('removeMembersFromServerRole is not implemented');
  }

  Future<NIMResult<QChatGetMembersFromServerRoleResult>>
      getMembersFromServerRole(QChatGetMembersFromServerRoleParam param) async {
    throw UnimplementedError('getMembersFromServerRole is not implemented');
  }

  Future<NIMResult<QChatGetServerRolesByAccidResult>> getServerRolesByAccid(
      QChatGetServerRolesByAccidParam param) async {
    throw UnimplementedError('getServerRolesByAccid is not implemented');
  }

  Future<NIMResult<QChatGetExistingServerRolesByAccidsResult>>
      getExistingServerRolesByAccids(
          QChatGetExistingServerRolesByAccidsParam param) async {
    throw UnimplementedError(
        'getExistingServerRolesByAccids is not implemented');
  }

  Future<NIMResult<QChatGetExistingAccidsInServerRoleResult>>
      getExistingAccidsInServerRole(
          QChatGetExistingAccidsInServerRoleParam param) async {
    throw UnimplementedError(
        'getExistingAccidsInServerRole is not implemented');
  }

  Future<NIMResult<QChatGetExistingChannelRolesByServerRoleIdsResult>>
      getExistingChannelRolesByServerRoleIds(
          QChatGetExistingChannelRolesByServerRoleIdsParam param) async {
    throw UnimplementedError(
        'getExistingChannelRolesByServerRoleIds is not implemented');
  }

  Future<NIMResult<QChatGetExistingAccidsOfMemberRolesResult>>
      getExistingAccidsOfMemberRoles(
          QChatGetExistingAccidsOfMemberRolesParam param) async {
    throw UnimplementedError(
        'getExistingAccidsOfMemberRoles is not implemented');
  }

  Future<NIMResult<QChatAddMemberRoleResult>> addMemberRole(
      QChatAddMemberRoleParam param) async {
    throw UnimplementedError('addMemberRole is not implemented');
  }

  Future<NIMResult<void>> removeMemberRole(
      QChatRemoveMemberRoleParam param) async {
    throw UnimplementedError('removeMemberRole is not implemented');
  }

  Future<NIMResult<QChatUpdateMemberRoleResult>> updateMemberRole(
      QChatUpdateMemberRoleParam param) async {
    throw UnimplementedError('updateMemberRole is not implemented');
  }

  Future<NIMResult<QChatGetMemberRolesResult>> getMemberRoles(
      QChatGetMemberRolesParam param) async {
    throw UnimplementedError('getMemberRoles is not implemented');
  }

  Future<NIMResult<QChatCheckPermissionResult>> checkPermission(
      QChatCheckPermissionParam param) async {
    throw UnimplementedError('checkPermission is not implemented');
  }

  Future<NIMResult<QChatCheckPermissionsResult>> checkPermissions(
      QChatCheckPermissionsParam param) async {
    throw UnimplementedError('checkPermissions is not implemented');
  }
}
