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
}

class FLTQChatRoleService: FLTBaseService, FLTService {
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
    default:
      resultCallback.notImplemented()
    }
  }

  func qChatRoleCallback(_ error: Error?, _ data: Any?, _ resultCallback: ResultCallback) {
    if let ns_error = error as NSError? {
      // 状态为“参数错误”时，SDK本应返回414，但是实际返回1，未与AOS对齐，此处进行手动对齐
      let code = ns_error.code == 1 ? 414 : ns_error.code
      errorCallBack(resultCallback, ns_error.description, code)
    } else {
      successCallBack(resultCallback, data)
    }
  }

  func qChatcreateServerRole(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatCreateServerRoleParam.fromDic(arguments)
    NIMSDK.shared().qchatRoleManager.createServerRole(request) { error, result in
      self.qChatRoleCallback(error, ["role": result?.toDict()], resultCallback)
    }
  }

  func qChatdeleteServerRole(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatDeleteServerRoleParam.fromDic(arguments)
    NIMSDK.shared().qchatRoleManager.deleteServerRole(request) { error in
      self.qChatRoleCallback(error, nil, resultCallback)
    }
  }

  func qChatupdateServerRole(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatUpdateServerRoleParam.fromDic(arguments)
    NIMSDK.shared().qchatRoleManager.updateServerRole(request) { error, result in
      self.qChatRoleCallback(error, ["role": result?.toDict()], resultCallback)
    }
  }

  func qChatupdateServerRolePriorities(_ arguments: [String: Any],
                                       _ resultCallback: ResultCallback) {
    let request = NIMQChatupdateServerRolePrioritiesParam.fromDic(arguments)
    NIMSDK.shared().qchatRoleManager.updateServerRolePriorities(request) { error, result in
      self.qChatRoleCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChatgetServerRoles(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatGetServerRolesParam.fromDic(arguments)
    NIMSDK.shared().qchatRoleManager.getServerRoles(request) { error, result in
      self.qChatRoleCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChataddChannelRole(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatAddChannelRoleParam.fromDic(arguments)
    NIMSDK.shared().qchatRoleManager.addChannelRole(request) { error, result in
      self.qChatRoleCallback(error, ["role": result?.toDict()], resultCallback)
    }
  }

  func qChatremoveChannelRole(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatRemoveChannelRoleParam.fromDic(arguments)
    NIMSDK.shared().qchatRoleManager.removeChannelRole(request) { error in
      self.qChatRoleCallback(error, nil, resultCallback)
    }
  }

  func qChatupdateChannelRole(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatUpdateChannelRoleParam.fromDic(arguments)
    NIMSDK.shared().qchatRoleManager.updateChannelRole(request) { error, result in
      self.qChatRoleCallback(error, ["role": result?.toDict()], resultCallback)
    }
  }

  func qChatgetChannelRoles(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatGetChannelRolesParam.fromDic(arguments)
    NIMSDK.shared().qchatRoleManager.getChannelRoles(request) { error, result in
      self.qChatRoleCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChataddMembersToServerRole(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatAddServerRoleMembersParam.fromDic(arguments)
    NIMSDK.shared().qchatRoleManager.addServerRoleMembers(request) { error, result in
      self.qChatRoleCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChatremoveMembersFromServerRole(_ arguments: [String: Any],
                                        _ resultCallback: ResultCallback) {
    let request = NIMQChatRemoveServerRoleMemberParam.fromDic(arguments)
    NIMSDK.shared().qchatRoleManager.removeServerRoleMember(request) { error, result in
      self.qChatRoleCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChatgetMembersFromServerRole(_ arguments: [String: Any],
                                     _ resultCallback: ResultCallback) {
    let request = NIMQChatGetServerRoleMembersParam.fromDic(arguments)
    NIMSDK.shared().qchatRoleManager.getServerRoleMembers(request) { error, result in
      self.qChatRoleCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChatgetServerRolesByAccid(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatGetServerRolesByAccidParam.fromDic(arguments)
    NIMSDK.shared().qchatRoleManager
      .getServerRoles(byAccid: request, completion: { error, result in
        self.qChatRoleCallback(error, result?.toDict(), resultCallback)
      })
  }

  func qChatgetExistingServerRolesByAccids(_ arguments: [String: Any],
                                           _ resultCallback: ResultCallback) {
    let request = NIMQChatGetExistingAccidsInServerRoleParam.fromDic(arguments)
    NIMSDK.shared().qchatRoleManager
      .getExistingAccids(inServerRole: request, completion: { error, result in
        self.qChatRoleCallback(error, result?.toDict(), resultCallback)
      })
  }

  func qChatgetExistingAccidsInServerRole(_ arguments: [String: Any],
                                          _ resultCallback: ResultCallback) {
    let request = NIMQChatGetExistingServerRoleMembersByAccidsParam.fromDic(arguments)
    NIMSDK.shared().qchatRoleManager
      .getExistingServerRoleMembers(byAccids: request, completion: { error, result in
        self.qChatRoleCallback(error, result?.toDict(), resultCallback)
      })
  }

  func qChatgetExistingChannelRolesByServerRol(_ arguments: [String: Any],
                                               _ resultCallback: ResultCallback) {
    let request = NIMQChatGetExistingChannelRolesByServerRoleIdsParam.fromDic(arguments)
    NIMSDK.shared().qchatRoleManager
      .getExistingChannelRoles(byServerRoleIds: request, completion: { error, result in
        self.qChatRoleCallback(error, result?.toDict(), resultCallback)
      })
  }

  func qChatgetExistingAccidsOfMemberRoles(_ arguments: [String: Any],
                                           _ resultCallback: ResultCallback) {
    let request = NIMQChatGetExistingAccidsOfMemberRolesParam.fromDic(arguments)
    NIMSDK.shared().qchatRoleManager
      .getExistingAccids(ofMemberRoles: request, completion: { error, result in
        self.qChatRoleCallback(error, result?.toDict(), resultCallback)
      })
  }
}

extension FLTQChatRoleService: NIMQChatRoleManagerDelegate {}
