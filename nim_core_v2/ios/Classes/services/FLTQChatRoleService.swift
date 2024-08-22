// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

enum QChatRoleMethod: String {
  case createServerRole
  case deleteServerRole
  case updateServerRole
  case updateServerRolePriorities
  case getServerRoles
  case addChannelRole
  case removeChannelRole
  case updateChannelRole
  case getChannelRoles
  case addMembersToServerRole
  case removeMembersFromServerRole
  case getMembersFromServerRole
  case getServerRolesByAccid
  case getExistingServerRolesByAccids
  case getExistingAccidsInServerRole
  case getExistingChannelRolesByServerRoleIds
  case getExistingAccidsOfMemberRoles
  case addMemberRole
  case removeMemberRole
  case updateMemberRole
  case getMemberRoles
  case checkPermission
  case checkPermissions
}

class FLTQChatRoleService: FLTBaseService, FLTService {
  private let paramErrorTip = "参数错误"
  private let paramErrorCode = 414

  override func onInitialized() {
    NIMSDK.shared().qchatRoleManager.add(self)
  }

  deinit {
    NIMSDK.shared().qchatRoleManager.remove(self)
  }

  func serviceName() -> String {
    ServiceType.QChatRoleService.rawValue
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case QChatRoleMethod.createServerRole.rawValue:
      qChatcreateServerRole(arguments, resultCallback)
    case QChatRoleMethod.deleteServerRole.rawValue:
      qChatdeleteServerRole(arguments, resultCallback)
    case QChatRoleMethod.updateServerRole.rawValue:
      qChatupdateServerRole(arguments, resultCallback)
    case QChatRoleMethod.updateServerRolePriorities.rawValue:
      qChatupdateServerRolePriorities(arguments, resultCallback)
    case QChatRoleMethod.getServerRoles.rawValue:
      qChatgetServerRoles(arguments, resultCallback)
    case QChatRoleMethod.addChannelRole.rawValue:
      qChataddChannelRole(arguments, resultCallback)
    case QChatRoleMethod.removeChannelRole.rawValue:
      qChatremoveChannelRole(arguments, resultCallback)
    case QChatRoleMethod.updateChannelRole.rawValue:
      qChatupdateChannelRole(arguments, resultCallback)
    case QChatRoleMethod.getChannelRoles.rawValue:
      qChatgetChannelRoles(arguments, resultCallback)
    case QChatRoleMethod.addMembersToServerRole.rawValue:
      qChataddMembersToServerRole(arguments, resultCallback)
    case QChatRoleMethod.removeMembersFromServerRole.rawValue:
      qChatremoveMembersFromServerRole(arguments, resultCallback)
    case QChatRoleMethod.getMembersFromServerRole.rawValue:
      qChatgetMembersFromServerRole(arguments, resultCallback)
    case QChatRoleMethod.getServerRolesByAccid.rawValue:
      qChatgetServerRolesByAccid(arguments, resultCallback)
    case QChatRoleMethod.getExistingServerRolesByAccids.rawValue:
      qChatgetExistingServerRolesByAccids(arguments, resultCallback)
    case QChatRoleMethod.getExistingAccidsInServerRole.rawValue:
      qChatgetExistingAccidsInServerRole(arguments, resultCallback)
    case QChatRoleMethod.getExistingChannelRolesByServerRoleIds.rawValue:
      qChatgetExistingChannelRolesByServerRol(arguments, resultCallback)
    case QChatRoleMethod.getExistingAccidsOfMemberRoles.rawValue:
      qChatgetExistingAccidsOfMemberRoles(arguments, resultCallback)
    case QChatRoleMethod.addMemberRole.rawValue:
      addMemberRole(arguments, resultCallback)
    case QChatRoleMethod.removeMemberRole.rawValue:
      removeMemberRole(arguments, resultCallback)
    case QChatRoleMethod.updateMemberRole.rawValue:
      updateMemberRole(arguments, resultCallback)
    case QChatRoleMethod.getMemberRoles.rawValue:
      getMemberRoles(arguments, resultCallback)
    case QChatRoleMethod.checkPermission.rawValue:
      checkPermission(arguments, resultCallback)
    case QChatRoleMethod.checkPermissions.rawValue:
      checkPermissions(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func qChatRoleCallback(_ error: Error?, _ data: Any?, _ resultCallback: ResultCallback) {
    if let ns_error = error as NSError? {
      errorCallBack(resultCallback, ns_error.description, ns_error.code)
    } else {
      successCallBack(resultCallback, data)
    }
  }

  func qChatcreateServerRole(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatCreateServerRoleParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatRoleManager.createServerRole(request) { error, result in
      self.qChatRoleCallback(error, ["role": result?.toDict()], resultCallback)
    }
  }

  func qChatdeleteServerRole(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatDeleteServerRoleParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatRoleManager.deleteServerRole(request) { error in
      self.qChatRoleCallback(error, nil, resultCallback)
    }
  }

  func qChatupdateServerRole(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatUpdateServerRoleParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatRoleManager.updateServerRole(request) { error, result in
      self.qChatRoleCallback(error, ["role": result?.toDict()], resultCallback)
    }
  }

  func qChatupdateServerRolePriorities(_ arguments: [String: Any],
                                       _ resultCallback: ResultCallback) {
    guard let request = NIMQChatupdateServerRolePrioritiesParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatRoleManager.updateServerRolePriorities(request) { error, result in
      self.qChatRoleCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChatgetServerRoles(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetServerRolesParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatRoleManager.getServerRoles(request) { error, result in
      self.qChatRoleCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChataddChannelRole(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatAddChannelRoleParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatRoleManager.addChannelRole(request) { error, result in
      self.qChatRoleCallback(error, ["role": result?.toDict()], resultCallback)
    }
  }

  func qChatremoveChannelRole(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatRemoveChannelRoleParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatRoleManager.removeChannelRole(request) { error in
      self.qChatRoleCallback(error, nil, resultCallback)
    }
  }

  func qChatupdateChannelRole(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatUpdateChannelRoleParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatRoleManager.updateChannelRole(request) { error, result in
      self.qChatRoleCallback(error, ["role": result?.toDict()], resultCallback)
    }
  }

  func qChatgetChannelRoles(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetChannelRolesParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatRoleManager.getChannelRoles(request) { error, result in
      self.qChatRoleCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChataddMembersToServerRole(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatAddServerRoleMembersParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatRoleManager.addServerRoleMembers(request) { error, result in
      self.qChatRoleCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChatremoveMembersFromServerRole(_ arguments: [String: Any],
                                        _ resultCallback: ResultCallback) {
    guard let request = NIMQChatRemoveServerRoleMemberParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatRoleManager.removeServerRoleMember(request) { error, result in
      self.qChatRoleCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChatgetMembersFromServerRole(_ arguments: [String: Any],
                                     _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetServerRoleMembersParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatRoleManager.getServerRoleMembers(request) { error, result in
      self.qChatRoleCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChatgetServerRolesByAccid(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetServerRolesByAccidParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatRoleManager
      .getServerRoles(byAccid: request, completion: { error, result in
        self.qChatRoleCallback(error, result?.toDict(), resultCallback)
      })
  }

  func qChatgetExistingServerRolesByAccids(_ arguments: [String: Any],
                                           _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetExistingAccidsInServerRoleParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatRoleManager
      .getExistingAccids(inServerRole: request, completion: { error, result in
        self.qChatRoleCallback(error, result?.toDict(), resultCallback)
      })
  }

  func qChatgetExistingAccidsInServerRole(_ arguments: [String: Any],
                                          _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetExistingServerRoleMembersByAccidsParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatRoleManager
      .getExistingServerRoleMembers(byAccids: request, completion: { error, result in
        self.qChatRoleCallback(error, result?.toDict(), resultCallback)
      })
  }

  func qChatgetExistingChannelRolesByServerRol(_ arguments: [String: Any],
                                               _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetExistingChannelRolesByServerRoleIdsParam.fromDic(arguments)
    else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatRoleManager
      .getExistingChannelRoles(byServerRoleIds: request, completion: { error, result in
        self.qChatRoleCallback(error, result?.toDict(), resultCallback)
      })
  }

  func qChatgetExistingAccidsOfMemberRoles(_ arguments: [String: Any],
                                           _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetExistingAccidsOfMemberRolesParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatRoleManager
      .getExistingAccids(ofMemberRoles: request, completion: { error, result in
        self.qChatRoleCallback(error, result?.toDict(), resultCallback)
      })
  }

  func addMemberRole(_ arguments: [String: Any],
                     _ resultCallback: ResultCallback) {
    guard let param = NIMQChatAddMemberRoleParam.fromDic(arguments) else {
      print("addMemberRole parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatRoleManager.addMemberRole(param) { error, info in
      self.qChatRoleCallback(error, ["role": info?.toDic()], resultCallback)
    }
  }

  func removeMemberRole(_ arguments: [String: Any],
                        _ resultCallback: ResultCallback) {
    guard let param = NIMQChatRemoveMemberRoleParam.fromDic(arguments) else {
      print("removeMemberRole parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatRoleManager.removeMemberRole(param) { error in
      self.qChatRoleCallback(error, nil, resultCallback)
    }
  }

  func updateMemberRole(_ arguments: [String: Any],
                        _ resultCallback: ResultCallback) {
    guard let param = NIMQChatUpdateMemberRoleParam.fromDic(arguments) else {
      print("updateMemberRole parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatRoleManager.updateMemberRole(param) { error, info in
      self.qChatRoleCallback(error, ["role": info?.toDic()], resultCallback)
    }
  }

  func getMemberRoles(_ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    guard let param = NIMQChatGetMemberRolesParam.fromDic(arguments) else {
      print("getMemberRoles parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatRoleManager.getMemberRoles(param) { error, info in
      self.qChatRoleCallback(error, info?.toDic(), resultCallback)
    }
  }

  func checkPermission(_ arguments: [String: Any],
                       _ resultCallback: ResultCallback) {
    guard let param = NIMQChatCheckPermissionParam.fromDic(arguments) else {
      print("checkPermission parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatRoleManager.checkPermission(param) { error, info in
      self.qChatRoleCallback(error, ["hasPermission": info], resultCallback)
    }
  }

  func checkPermissions(_ arguments: [String: Any],
                        _ resultCallback: ResultCallback) {
    guard let param = NIMQChatCheckPermissionsParam.fromDic(arguments) else {
      print("checkPermissions parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatRoleManager.checkPermissions(param) { error, info in
      self.qChatRoleCallback(error, info?.toDic(), resultCallback)
    }
  }
}

extension FLTQChatRoleService: NIMQChatRoleManagerDelegate {}
