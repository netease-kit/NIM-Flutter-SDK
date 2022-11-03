// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
import NIMSDK
import Foundation

enum QChatServerMethod: String {
  case acceptServerApply
  case acceptServerInvite
  case applyServerJoin
  case createServer
  case deleteServer
  case getServerMembers
  case getServerMembersByPage
  case getServers
  case getServersByPage
  case inviteServerMembers
  case kickServerMembers
  case leaveServer
  case rejectServerApply
  case rejectServerInvite
  case updateServer
  case updateMyMemberInfo
  case subscribeServer
  case searchServerByPage
  case generateInviteCode
  case joinByInviteCode
}

class FLTQChatServerService: FLTBaseService, FLTService {
  override func onInitialized() {
    NIMSDK.shared().qchatServerManager.add(self)
  }

  deinit {
    NIMSDK.shared().qchatServerManager.remove(self)
  }

  func serviceName() -> String {
    ServiceType.QChatServerService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case QChatServerMethod.acceptServerApply.rawValue:
      acceptServerApply(arguments, resultCallback)
    case QChatServerMethod.acceptServerInvite.rawValue:
      acceptServerInvite(arguments, resultCallback)
    case QChatServerMethod.applyServerJoin.rawValue:
      applyServerJoin(arguments, resultCallback)
    case QChatServerMethod.createServer.rawValue:
      createServer(arguments, resultCallback)
    case QChatServerMethod.deleteServer.rawValue:
      deleteServere(arguments, resultCallback)
    case QChatServerMethod.getServerMembers.rawValue:
      getServerMembers(arguments, resultCallback)
    case QChatServerMethod.getServerMembersByPage.rawValue:
      getServerMembersByPage(arguments, resultCallback)
    case QChatServerMethod.getServers.rawValue:
      getServers(arguments, resultCallback)
    case QChatServerMethod.getServersByPage.rawValue:
      getServersByPage(arguments, resultCallback)
    case QChatServerMethod.inviteServerMembers.rawValue:
      inviteServerMembers(arguments, resultCallback)
    case QChatServerMethod.kickServerMembers.rawValue:
      kickServerMembers(arguments, resultCallback)
    case QChatServerMethod.leaveServer.rawValue:
      leaveServer(arguments, resultCallback)
    case QChatServerMethod.rejectServerApply.rawValue:
      rejectServerApply(arguments, resultCallback)
    case QChatServerMethod.rejectServerInvite.rawValue:
      rejectServerInvite(arguments, resultCallback)
    case QChatServerMethod.updateServer.rawValue:
      updateServer(arguments, resultCallback)
    case QChatServerMethod.updateMyMemberInfo.rawValue:
      updateMyMemberInfo(arguments, resultCallback)
    case QChatServerMethod.subscribeServer.rawValue:
      subscribeServer(arguments, resultCallback)
    case QChatServerMethod.searchServerByPage.rawValue:
      searchServerByPage(arguments, resultCallback)
    case QChatServerMethod.generateInviteCode.rawValue:
      generateInviteCode(arguments, resultCallback)
    case QChatServerMethod.joinByInviteCode.rawValue:
      joinByInviteCode(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func qChatServerCallback(_ error: Error?, _ data: Any?, _ resultCallback: ResultCallback) {
    if let ns_error = error as NSError? {
      // 状态为“参数错误”时，SDK本应返回414，但是实际返回1，未与AOS对齐，此处进行手动对齐
      let code = ns_error.code == 1 ? 414 : ns_error.code
      errorCallBack(resultCallback, ns_error.description, code)
    } else {
      successCallBack(resultCallback, data)
    }
  }

  func acceptServerApply(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatAcceptServerApplyParam.fromDic(arguments) else {
      print("acceptServerApply parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }
    NIMSDK.shared().qchatServerManager.acceptServerApply(param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func acceptServerInvite(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatAcceptServerInviteParam.fromDic(arguments) else {
      print("acceptServerInvite parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.acceptServerInvite(param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func applyServerJoin(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatApplyServerJoinParam.fromDic(arguments) else {
      print("applyServerJoin parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.applyServerJoin(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func createServer(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatCreateServerParam.fromDic(arguments) else {
      print("createServer parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.createServer(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func deleteServere(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatDeleteServerParam.fromDic(arguments) else {
      print("deleteServere parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.deleteServer(param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func getServerMembers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatGetServerMembersParam.fromDic(arguments) else {
      print("getServerMembers parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.getServerMembers(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func getServers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatGetServersParam.fromDic(arguments) else {
      print("getServers parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.getServers(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func getServerMembersByPage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatGetServerMembersByPageParam.fromDic(arguments) else {
      print("getServerMembersByPage parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.getServerMembers(byPage: param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func getServersByPage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatGetServersByPageParam.fromDic(arguments) else {
      print("getServersByPage parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.getServersByPage(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func inviteServerMembers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatInviteServerMembersParam.fromDic(arguments) else {
      print("inviteServerMembers parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.inviteServerMembers(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func kickServerMembers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatKickServerMembersParam.fromDic(arguments) else {
      print("kickServerMembers parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.kickServerMembers(param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func leaveServer(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatLeaveServerParam.fromDic(arguments) else {
      print("leaveServer parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.leaveServer(param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func rejectServerApply(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatRejectServerApplyParam.fromDic(arguments) else {
      print("rejectServerApply parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.rejectServerApply(param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func rejectServerInvite(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatRejectServerInviteParam.fromDic(arguments) else {
      print("rejectServerInvite parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.rejectServerInvite(param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func updateServer(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatUpdateServerParam.fromDic(arguments) else {
      print("updateServer parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.updateServer(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func updateMyMemberInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatUpdateMyMemberInfoParam.fromDic(arguments) else {
      print("updateMyMemberInfo parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.updateMyMemberInfo(param) { error, info in
      self.qChatServerCallback(error, ["member": info?.toDic()], resultCallback)
    }
  }

  func subscribeServer(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatSubscribeServerParam.fromDic(arguments) else {
      print("subscribeServer parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.subscribeServer(param) { error, info in
      self.qChatServerCallback(error, info?.toDic() ?? ["failedList": []], resultCallback)
    }
  }

  func searchServerByPage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatSearchServerByPageParam.fromDic(arguments) else {
      print("searchServerByPage parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.searchServer(byPage: param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func generateInviteCode(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatGenerateInviteCodeParam.fromDic(arguments) else {
      print("generateInviteCode parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.generateInviteCode(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func joinByInviteCode(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatJoinByInviteCodeParam.fromDic(arguments) else {
      print("joinByInviteCode parameter error  is nil")
      errorCallBack(resultCallback, "parameter error is nil")
      return
    }

    NIMSDK.shared().qchatServerManager.join(byInviteCode: param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }
}

extension FLTQChatServerService: NIMQChatServerManagerDelegate {}
