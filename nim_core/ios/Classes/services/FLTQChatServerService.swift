import Foundation
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
import NIMSDK

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
  case updateServerMemberInfo
  case banServerMember
  case unbanServerMember
  case getBannedServerMembersByPage
  case updateUserServerPushConfig
  case getUserServerPushConfigs
  case searchServerMemberByPage
  case getInviteApplyRecordOfServer
  case getInviteApplyRecordOfSelf
  case markRead
  case subscribeAllChannel
  case subscribeAsVisitor
  case enterAsVisitor
  case leaveAsVisitor
}

class FLTQChatServerService: FLTBaseService, FLTService {
  private let paramErrorTip = "参数错误"
  private let paramErrorCode = 414

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
    case QChatServerMethod.updateServerMemberInfo.rawValue:
      updateServerMemberInfo(arguments, resultCallback)
    case QChatServerMethod.banServerMember.rawValue:
      banServerMember(arguments, resultCallback)
    case QChatServerMethod.unbanServerMember.rawValue:
      unbanServerMember(arguments, resultCallback)
    case QChatServerMethod.getBannedServerMembersByPage.rawValue:
      getBannedServerMembersByPage(arguments, resultCallback)
    case QChatServerMethod.updateUserServerPushConfig.rawValue:
      updateUserServerPushConfig(arguments, resultCallback)
    case QChatServerMethod.getUserServerPushConfigs.rawValue:
      getUserServerPushConfigs(arguments, resultCallback)
    case QChatServerMethod.searchServerMemberByPage.rawValue:
      searchServerMemberByPage(arguments, resultCallback)
    case QChatServerMethod.getInviteApplyRecordOfServer.rawValue:
      getInviteApplyRecordOfServer(arguments, resultCallback)
    case QChatServerMethod.getInviteApplyRecordOfSelf.rawValue:
      getInviteApplyRecordOfSelf(arguments, resultCallback)
    case QChatServerMethod.markRead.rawValue:
      markRead(arguments, resultCallback)
    case QChatServerMethod.subscribeAllChannel.rawValue:
      subscribeAllChannel(arguments, resultCallback)
    case QChatServerMethod.subscribeAsVisitor.rawValue:
      subscribeAsVisitor(arguments, resultCallback)
    case QChatServerMethod.enterAsVisitor.rawValue:
      enterAsVisitor(arguments, resultCallback)
    case QChatServerMethod.leaveAsVisitor.rawValue:
      leaveAsVisitor(arguments, resultCallback)
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
      errorCallBack(resultCallback, ns_error.description, ns_error.code)
    } else {
      successCallBack(resultCallback, data)
    }
  }

  func acceptServerApply(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatAcceptServerApplyParam.fromDic(arguments) else {
      print("acceptServerApply parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatServerManager.acceptServerApply(param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func acceptServerInvite(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatAcceptServerInviteParam.fromDic(arguments) else {
      print("acceptServerInvite parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.acceptServerInvite(param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func applyServerJoin(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatApplyServerJoinParam.fromDic(arguments) else {
      print("applyServerJoin parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.applyServerJoin(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func createServer(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatCreateServerParam.fromDic(arguments) else {
      print("createServer parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.createServer(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func deleteServere(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatDeleteServerParam.fromDic(arguments) else {
      print("deleteServere parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.deleteServer(param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func getServerMembers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatGetServerMembersParam.fromDic(arguments) else {
      print("getServerMembers parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.getServerMembers(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func getServers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatGetServersParam.fromDic(arguments) else {
      print("getServers parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.getServers(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func getServerMembersByPage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatGetServerMembersByPageParam.fromDic(arguments) else {
      print("getServerMembersByPage parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.getServerMembers(byPage: param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func getServersByPage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatGetServersByPageParam.fromDic(arguments) else {
      print("getServersByPage parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.getServersByPage(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func inviteServerMembers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatInviteServerMembersParam.fromDic(arguments) else {
      print("inviteServerMembers parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.inviteServerMembers(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func kickServerMembers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatKickServerMembersParam.fromDic(arguments) else {
      print("kickServerMembers parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.kickServerMembers(param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func leaveServer(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatLeaveServerParam.fromDic(arguments) else {
      print("leaveServer parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.leaveServer(param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func rejectServerApply(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatRejectServerApplyParam.fromDic(arguments) else {
      print("rejectServerApply parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.rejectServerApply(param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func rejectServerInvite(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatRejectServerInviteParam.fromDic(arguments) else {
      print("rejectServerInvite parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.rejectServerInvite(param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func updateServer(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatUpdateServerParam.fromDic(arguments) else {
      print("updateServer parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.updateServer(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func updateMyMemberInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatUpdateMyMemberInfoParam.fromDic(arguments) else {
      print("updateMyMemberInfo parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.updateMyMemberInfo(param) { error, info in
      self.qChatServerCallback(error, ["member": info?.toDic()], resultCallback)
    }
  }

  func subscribeServer(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatSubscribeServerParam.fromDic(arguments) else {
      print("subscribeServer parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.subscribeServer(param) { error, info in
      self.qChatServerCallback(error, info?.toDic() ?? ["failedList": []], resultCallback)
    }
  }

  func searchServerByPage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatSearchServerByPageParam.fromDic(arguments) else {
      print("searchServerByPage parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.searchServer(byPage: param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func generateInviteCode(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatGenerateInviteCodeParam.fromDic(arguments) else {
      print("generateInviteCode parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.generateInviteCode(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func joinByInviteCode(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatJoinByInviteCodeParam.fromDic(arguments) else {
      print("joinByInviteCode parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.join(byInviteCode: param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func updateServerMemberInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatUpdateServerMemberInfoParam.fromDic(arguments) else {
      print("updateServerMemberInfo parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.updateServerMemberInfo(param) { error, info in
      self.qChatServerCallback(error, ["member": info?.toDic()], resultCallback)
    }
  }

  func banServerMember(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatUpdateServerMemberBanParam.fromDic(arguments) else {
      print("banServerMember parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.banServerMember(param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func unbanServerMember(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatUpdateServerMemberBanParam.fromDic(arguments) else {
      print("unbanServerMember parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.unbanServerMember(param) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func getBannedServerMembersByPage(_ arguments: [String: Any],
                                    _ resultCallback: ResultCallback) {
    guard let param = NIMQChatGetServerBanedMembersByPageParam.fromDic(arguments) else {
      print("getBannedServerMembersByPage parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.getServerBanedMembers(byPage: param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func updateUserServerPushConfig(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let serverId = arguments["serverId"] as? UInt64,
          let pushMsgType = arguments["pushMsgType"] as? String,
          let notificationProfile = FLTQChatPushNotificationProfile(rawValue: pushMsgType)?
          .convertToPushNotificationProfile() else {
      print("updateUserServerPushConfig parameter error, serverId is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatApnsManager.update(notificationProfile, server: serverId) { error in
      self.qChatServerCallback(error, nil, resultCallback)
    }
  }

  func getUserServerPushConfigs(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let serverIdList = (arguments["serverIdList"] as? [UInt64])?.map({ item in
      NSNumber(value: item)
    }) else {
      print("getUserServerPushConfigs parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatApnsManager
      .getUserPushNotificationConfig(byServer: serverIdList) { error, info in
        self.qChatServerCallback(error, ["userPushConfigs": info?.map { item in
          item.toDic()
        }], resultCallback)
      }
  }

  func searchServerMemberByPage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatSearchServerMemberByPageParam.fromDic(arguments) else {
      print("searchServerMemberByPage parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.searchServerMember(byPage: param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func getInviteApplyRecordOfServer(_ arguments: [String: Any],
                                    _ resultCallback: ResultCallback) {
    guard let param = NIMQChatGetInviteApplyRecordOfServerParam.fromDic(arguments) else {
      print("getInviteApplyRecordOfServer parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.getInviteApplyRecord(ofServer: param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func getInviteApplyRecordOfSelf(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatGetInviteApplyRecordOfSelfParam.fromDic(arguments) else {
      print("getInviteApplyRecordOfSelf parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.getInviteApplyRecord(ofSelf: param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func markRead(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatMarkServerReadParam.fromDic(arguments) else {
      print("searchServerMemberByPage parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.markServerRead(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func subscribeAllChannel(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatSubscribeAllChannelParam.fromDic(arguments) else {
      print("subscribeAllChannel parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.subscribeAllChannel(param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func subscribeAsVisitor(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatSubscribeServerAsVisitorParam.fromDic(arguments) else {
      print("subscribeAsVisitor parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.subscribe(asVisitor: param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func enterAsVisitor(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatEnterServerAsVisitorParam.fromDic(arguments) else {
      print("enterAsVisitor parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.enter(asVisitor: param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }

  func leaveAsVisitor(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let param = NIMQChatLeaveServerAsVisitorParam.fromDic(arguments) else {
      print("leaveAsVisitor parameter error is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatServerManager.leave(asVisitor: param) { error, info in
      self.qChatServerCallback(error, info?.toDic(), resultCallback)
    }
  }
}

extension FLTQChatServerService: NIMQChatServerManagerDelegate {}
