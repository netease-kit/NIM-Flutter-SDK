// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core;

///圈组身份组服务
///目前仅支持iOS和Android平台
class QChatRoleService {
  factory QChatRoleService() {
    if (_singleton == null) {
      _singleton = QChatRoleService._();
    }
    return _singleton!;
  }

  QChatRoleService._();

  static QChatRoleService? _singleton;

  QChatRoleServicePlatform _platform = QChatRoleServicePlatform.instance;

  ///  新增服务器身份组
  Future<NIMResult<QChatCreateServerRoleResult>> createServerRole(
      QChatCreateServerRoleParam param) {
    return _platform.createServerRole(param);
  }

  /// 移除服务器身份组
  Future<NIMResult<void>> deleteServerRole(QChatDeleteServerRoleParam param) {
    return _platform.deleteServerRole(param);
  }

  /// 修改服务器身份组信息
  Future<NIMResult<QChatUpdateServerRoleResult>> updateServerRole(
      QChatUpdateServerRoleParam param) {
    return _platform.updateServerRole(param);
  }

  /// 批量修改服务器身份组优先级
  Future<NIMResult<QChatUpdateServerRolePrioritiesResult>>
      updateServerRolePriorities(QChatUpdateServerRolePrioritiesParam param) {
    return _platform.updateServerRolePriorities(param);
  }

  /// 查询服务器下身份组列表，第一页返回结果额外包含everyone身份组，自定义身份组数量充足的情况下会返回limit+1个身份组
  Future<NIMResult<QChatGetServerRolesResult>> getServerRoles(
      QChatGetServerRolesParam param) {
    return _platform.getServerRoles(param);
  }

  /// 新增Channel身份组
  Future<NIMResult<QChatAddChannelRoleResult>> addChannelRole(
      QChatAddChannelRoleParam param) {
    return _platform.addChannelRole(param);
  }

  /// 删除频道身份组
  Future<NIMResult<void>> removeChannelRole(QChatRemoveChannelRoleParam param) {
    return _platform.removeChannelRole(param);
  }

  /// 修改频道下某身份组的权限
  Future<NIMResult<QChatUpdateChannelRoleResult>> updateChannelRole(
      QChatUpdateChannelRoleParam param) {
    return _platform.updateChannelRole(param);
  }

  /// 查询某频道下的身份组信息列表
  Future<NIMResult<QChatGetChannelRolesResult>> getChannelRoles(
      QChatGetChannelRolesParam param) {
    return _platform.getChannelRoles(param);
  }

  /// 将某些人加入某服务器身份组
  Future<NIMResult<QChatAddMembersToServerRoleResult>> addMembersToServerRole(
      QChatAddMembersToServerRoleParam param) {
    return _platform.addMembersToServerRole(param);
  }

  /// 将某些人移出某服务器身份组
  Future<NIMResult<QChatRemoveMembersFromServerRoleResult>>
      removeMembersFromServerRole(QChatRemoveMembersFromServerRoleParam param) {
    return _platform.removeMembersFromServerRole(param);
  }

  /// 查询某服务器下某身份组下的成员列表
  Future<NIMResult<QChatGetMembersFromServerRoleResult>>
      getMembersFromServerRole(QChatGetMembersFromServerRoleParam param) {
    return _platform.getMembersFromServerRole(param);
  }

  /// 通过accid查询该accid所属的服务器身份组列表，结果只有自定义身份组，不包含everyone身份组
  Future<NIMResult<QChatGetServerRolesByAccidResult>> getServerRolesByAccid(
      QChatGetServerRolesByAccidParam param) {
    return _platform.getServerRolesByAccid(param);
  }

  /// 通过accid查询该accid所属的服务器身份组列表，结果只有自定义身份组，不包含everyone身份组
  Future<NIMResult<QChatGetExistingServerRolesByAccidsResult>>
      getExistingServerRolesByAccids(
          QChatGetExistingServerRolesByAccidsParam param) {
    return _platform.getExistingServerRolesByAccids(param);
  }

  /// 查询一批accids在某个服务器身份组下存在的列表
  Future<NIMResult<QChatGetExistingAccidsInServerRoleResult>>
      getExistingAccidsInServerRole(
          QChatGetExistingAccidsInServerRoleParam param) {
    return _platform.getExistingAccidsInServerRole(param);
  }

  /// 通过服务器身份组Id列表查询频道身份组列表
  ///
  /// 传入服务器Id，频道Id，和一组该服务器下的身份组Id组成的列表，
  /// 找出该身份组Id列表中被添加到频道Id所在频道的服务器身份组，并返回这些服务器身份组被添加到频道后的频道身份列表
  Future<NIMResult<QChatGetExistingChannelRolesByServerRoleIdsResult>>
      getExistingChannelRolesByServerRoleIds(
          QChatGetExistingChannelRolesByServerRoleIdsParam param) {
    return _platform.getExistingChannelRolesByServerRoleIds(param);
  }

  /// 查询一批accids中定制了服务器身份组的列表
  ///
  /// 输入accid列表和频道Id，查询这些用户在该频道下的成员定制权限，返回这些定制权限的accid列表
  Future<NIMResult<QChatGetExistingAccidsOfMemberRolesResult>>
      getExistingAccidsOfMemberRoles(
          QChatGetExistingAccidsOfMemberRolesParam param) async {
    return _platform.getExistingAccidsOfMemberRoles(param);
  }

  /// 为某个人定制某频道的权限
  Future<NIMResult<QChatAddMemberRoleResult>> addMemberRole(
      QChatAddMemberRoleParam param) async {
    return _platform.addMemberRole(param);
  }

  /// 删除频道下某人的定制权限
  Future<NIMResult<void>> removeMemberRole(
      QChatRemoveMemberRoleParam param) async {
    return _platform.removeMemberRole(param);
  }

  /// 修改某人的定制权限
  Future<NIMResult<QChatUpdateMemberRoleResult>> updateMemberRole(
      QChatUpdateMemberRoleParam param) async {
    return _platform.updateMemberRole(param);
  }

  /// 查询channel下某人的定制权限
  Future<NIMResult<QChatGetMemberRolesResult>> getMemberRoles(
      QChatGetMemberRolesParam param) async {
    return _platform.getMemberRoles(param);
  }

  /// 查询自己是否拥有某个权限
  Future<NIMResult<QChatCheckPermissionResult>> checkPermission(
      QChatCheckPermissionParam param) async {
    return _platform.checkPermission(param);
  }

  /// 查询自己是否拥有某些权限
  Future<NIMResult<QChatCheckPermissionsResult>> checkPermissions(
      QChatCheckPermissionsParam param) async {
    return _platform.checkPermissions(param);
  }
}
