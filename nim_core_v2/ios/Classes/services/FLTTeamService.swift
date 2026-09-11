// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum V2TeamNameType: String {
  case createTeam
  case updateTeamInfo
  case leaveTeam
  case getTeamInfo
  case getTeamInfoByIds
  case dismissTeam
  case inviteMember
  case acceptInvitation
  case rejectInvitation
  case kickMember
  case applyJoinTeam
  case acceptJoinApplication
  case rejectJoinApplication
  case updateTeamMemberRole
  case transferTeamOwner
  case updateSelfTeamMemberInfo
  case updateTeamMemberNick
  case setTeamChatBannedMode
  case setTeamMemberChatBannedStatus
  case getJoinedTeamList
  case getJoinedTeamCount
  case getTeamMemberList
  case getTeamMemberListByIds
  case getTeamMemberInvitor
  case getTeamJoinActionInfoList
  case searchTeamByKeyword
  case searchTeamMembers
  case addTeamMembersFollow
  case removeTeamMembersFollow
  case clearAllTeamJoinActionInfo
  case clearAllTeamJoinActionInfoEx
  case deleteTeamJoinActionInfo
  case inviteMemberEx
  case getOwnerTeamList
  case getManagerTeamList
  case getTeamInfoFromCloud
  case searchTeams
  case searchTeamMembersEx
}

let teamClassName = "FLTTeamService"

class FLTTeamService: FLTBaseService, FLTService, V2NIMTeamListener {
  override func onInitialized() {
    NIMSDK.shared().v2TeamService.add(self)
  }

  deinit {
    NIMSDK.shared().v2TeamService.remove(self)
  }

  func serviceName() -> String {
    ServiceType.TeamService.rawValue
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  private func teamCallback(_ error: Error?, _ data: Any?, _ resultCallback: ResultCallback) {
    if let ns_error = error as NSError? {
      errorCallBack(resultCallback, ns_error.description, ns_error.code)
    } else {
      successCallBack(resultCallback, data)
    }
  }

  /// 创建群
  public func createTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let createTeamParamsArguments = arguments["createTeamParams"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let createTeamParams = V2NIMCreateTeamParams.fromDic(createTeamParamsArguments)

    var inviteeAccountIds: [String]?
    if let inviteeAccountIdsArguments = arguments["inviteeAccountIds"] as? [String] {
      inviteeAccountIds = inviteeAccountIdsArguments
    }

    var postscript: String?
    if let postscriptArguments = arguments["postscript"] as? String {
      postscript = postscriptArguments
    }

    var antispamConfig: V2NIMAntispamConfig?
    if let antispamConfigArguments = arguments["antispamConfig"] as? [String: Any] {
      if let antispamBusinessId = antispamConfigArguments["antispamBusinessId"] as? String {
        antispamConfig = V2NIMAntispamConfig()
        antispamConfig?.antispamBusinessId = antispamBusinessId
      }
    }

    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.createTeam(createTeamParams, inviteeAccountIds: inviteeAccountIds, postscript: postscript, antispamConfig: antispamConfig) { resut in
      weakSelf?.teamCallback(nil, resut.toDic(), resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "createTeam error \(error.nserror.localizedDescription)")
    }
  }

  /// 更新群信息
  func updateTeamInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let updateTeamInfoParamsArguments = arguments["updateTeamInfoParams"] as? [String: Any], let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType) else {
      parameterError(resultCallback)

      return
    }
    let updateTeamInfoParams = V2NIMUpdateTeamInfoParams.fromDic(updateTeamInfoParamsArguments)

    var antispamConfig: V2NIMAntispamConfig?
    if let antispamConfigArguments = arguments["antispamConfig"] as? [String: Any] {
      if let antispamBusinessId = antispamConfigArguments["antispamBusinessId"] as? String {
        antispamConfig = V2NIMAntispamConfig()
        antispamConfig?.antispamBusinessId = antispamBusinessId
      }
    }

    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.updateTeamInfo(teamId, teamType: teamType, updateTeamInfoParams: updateTeamInfoParams, antispamConfig: antispamConfig) {
      weakSelf?.teamCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "updateTeamInfo error \(error.nserror.localizedDescription)")
    }
  }

  /// 退出群
  func leaveTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType) {
      weak var weakSelf = self
      NIMSDK.shared().v2TeamService.leaveTeam(teamId, teamType: teamType) {
        weakSelf?.teamCallback(nil, nil, resultCallback)
      } failure: { error in
        weakSelf?.teamCallback(error.nserror, nil, resultCallback)
        FLTALog.errorLog(teamClassName, desc: "leaveTeam error \(error.nserror.localizedDescription)")
      }
    } else {
      parameterError(resultCallback)
    }
  }

  /// 获取群信息
  func getTeamInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType) else {
      parameterError(resultCallback)

      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.getTeamInfo(teamId, teamType: teamType) { team in
      weakSelf?.teamCallback(nil, team.toDic(), resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "getTeamInfo error \(error.nserror.localizedDescription)")
    }
  }

  /// 批量获取群信息
  func getTeamInfoByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamIds = arguments["teamIds"] as? [String], let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType) else {
      parameterError(resultCallback)

      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.getTeamInfo(byIds: teamIds, teamType: teamType) { teams in
      weakSelf?.teamCallback(nil, ["teamList": teams.map { $0.toDic() }], resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "getTeamInfoByIds error \(error.nserror.localizedDescription)")
    }
  }

  /// 解散群
  func dismissTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType) {
      weak var weakSelf = self
      NIMSDK.shared().v2TeamService.dismissTeam(teamId, teamType: teamType) {
        weakSelf?.teamCallback(nil, nil, resultCallback)
      } failure: { error in
        weakSelf?.teamCallback(error.nserror, nil, resultCallback)
        FLTALog.errorLog(teamClassName, desc: "dismissTeam error \(error.nserror.localizedDescription)")
      }
    } else {
      parameterError(resultCallback)
    }
  }

  /// 邀请成员
  func inviteMember(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String, let inviteeAccountIds = arguments["inviteeAccountIds"] as? [String], let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType) else {
      return
    }
    var postscript: String?
    if let postscriptArguments = arguments["postscript"] as? String {
      postscript = postscriptArguments
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.inviteMember(teamId, teamType: teamType, inviteeAccountIds: inviteeAccountIds, postscript: postscript) { failedList in
      weakSelf?.teamCallback(nil, ["failedList": failedList], resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "inviteMember error \(error.nserror.localizedDescription)")
    }
  }

  /// 接受邀请
  func acceptInvitation(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let invitationInfoParam = arguments["invitationInfo"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let invitationInfo = V2NIMTeamJoinActionInfo.fromDic(invitationInfoParam)

    weak var weakSelf = self

    NIMSDK.shared().v2TeamService.acceptInvitation(invitationInfo) { team in
      weakSelf?.teamCallback(nil, team.toDic(), resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "acceptInvitation error \(error.nserror.localizedDescription)")
    }
  }

  /// 拒绝邀请
  func rejectInvitation(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let invitationInfoParam = arguments["invitationInfo"] as? [String: Any] else {
      return
    }

    let invitationInfo = V2NIMTeamJoinActionInfo.fromDic(invitationInfoParam)

    var postscript: String?

    if let postscriptString = arguments["postscript"] as? String {
      postscript = postscriptString
    }

    weak var weakSelf = self

    NIMSDK.shared().v2TeamService.rejectInvitation(invitationInfo, postscript: postscript) {
      weakSelf?.teamCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "rejectInvitation error \(error.nserror.localizedDescription)")
    }
  }

  /// 踢人
  func kickMember(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType), let accountIds = arguments["memberAccountIds"] as? [String] else {
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.kickMember(teamId, teamType: teamType, memberAccountIds: accountIds) {
      weakSelf?.teamCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "kickMember error \(error.nserror.localizedDescription)")
    }
  }

  /// 申请加入群
  func applyJoinTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType) else {
      return
    }

    let postscript = arguments["postscript"] as? String
    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.applyJoinTeam(teamId, teamType: teamType, postscript: postscript) { team in
      weakSelf?.teamCallback(nil, team.toDic(), resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "applyJoinTeam error \(error.nserror.localizedDescription)")
    }
  }

  /// 同意入群申请
  func acceptJoinApplication(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let acceptJoinApplicationParam = arguments["joinInfo"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let acceptJoinApplicationInfo = V2NIMTeamJoinActionInfo.fromDic(acceptJoinApplicationParam)

    weak var weakSelf = self

    NIMSDK.shared().v2TeamService.acceptJoinApplication(acceptJoinApplicationInfo) {
      weakSelf?.teamCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "acceptJoinApplication error \(error.nserror.localizedDescription)")
    }
  }

  /// 拒绝入群申请
  func rejectJoinApplication(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let rejectJoinParamAgruments = arguments["joinInfo"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let rejectJoinActionInfo = V2NIMTeamJoinActionInfo.fromDic(rejectJoinParamAgruments)

    weak var weakSelf = self

    let postscript = arguments["postscript"] as? String

    NIMSDK.shared().v2TeamService.rejectJoinApplication(rejectJoinActionInfo, postscript: postscript) {
      weakSelf?.teamCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "rejectJoinApplication error \(error.nserror.localizedDescription)")
    }
  }

  /// 更新群成员角色
  func updateTeamMemberRole(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType), let memberAccountIds = arguments["memberAccountIds"] as? [String], let memberRole = arguments["memberRole"] as? Int, let memberRole = V2NIMTeamMemberRole(rawValue: memberRole) else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self

    NIMSDK.shared().v2TeamService.updateTeamMemberRole(teamId, teamType: teamType, memberAccountIds: memberAccountIds, memberRole: memberRole) {
      weakSelf?.teamCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "updateTeamMemberRole error \(error.nserror.localizedDescription)")
    }
  }

  /// 转让群主
  func transferTeamOwner(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType), let accountId = arguments["accountId"] as? String, let leave = arguments["leave"] as? Bool else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.transferTeamOwner(teamId, teamType: teamType, accountId: accountId, leave: leave) {
      weakSelf?.teamCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "transferTeamOwner error \(error.nserror.localizedDescription)")
    }
  }

  /// 更新自己的群成员信息
  func updateSelfTeamMemberInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let memberInfoParamsArguments = arguments["memberInfoParams"] as? [String: Any], let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType) else {
      return
    }
    let memberInfoParams = V2NIMUpdateSelfMemberInfoParams()
    if let nick = memberInfoParamsArguments["teamNick"] as? String {
      memberInfoParams.teamNick = nick
    }
    if let serverExtension = memberInfoParamsArguments["serverExtension"] as? String {
      memberInfoParams.serverExtension = serverExtension
    }

    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.updateSelfTeamMemberInfo(teamId, teamType: teamType, memberInfoParams: memberInfoParams) {
      weakSelf?.teamCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "updateSelfTeamMemberInfo error \(error.nserror.localizedDescription)")
    }
  }

  /// 更新群成员昵称
  func updateTeamMemberNick(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType), let accountId = arguments["accountId"] as? String, let teamNick = arguments["teamNick"] as? String else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.updateTeamMemberNick(teamId, teamType: teamType, accountId: accountId, teamNick: teamNick, success: {
      weakSelf?.teamCallback(nil, nil, resultCallback)
    }, failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "updateTeamMemberNick error \(error.nserror.localizedDescription)")

    })
  }

  /// 设置群聊禁言模式
  func setTeamChatBannedMode(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType), let chatBannedMode = arguments["chatBannedMode"] as? Int, let chatBannedMode = V2NIMTeamChatBannedMode(rawValue: chatBannedMode) else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.setTeamChatBannedMode(teamId, teamType: teamType, chatBannedMode: chatBannedMode) {
      weakSelf?.teamCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "setTeamChatBannedMode error \(error.nserror.localizedDescription)")
    }
  }

  /// 设置群成员禁言状态
  func setTeamMemberChatBannedStatus(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType), let accountId = arguments["accountId"] as? String, let chatBannedStatus = arguments["chatBanned"] as? Bool else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.setTeamMemberChatBannedStatus(teamId, teamType: teamType, accountId: accountId, chatBanned: chatBannedStatus) {
      weakSelf?.teamCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "setTeamMemberChatBannedStatus error \(error.nserror.localizedDescription)")
    }
  }

  /// 获取已加入的群列表
  func getJoinedTeamList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamTypes = arguments["teamTypes"] as? [NSNumber] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.getJoinedTeamList(teamTypes) { teams in
      weakSelf?.teamCallback(nil, ["teamList": teams.map { team in
        team.toDic()
      }], resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "getJoinedTeamList error \(error.nserror.localizedDescription)")
    }
  }

  /// 获取已加入的群数量
  func getJoinedTeamCount(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamTypes = arguments["teamTypes"] as? [NSNumber] else {
      parameterError(resultCallback)
      return
    }

    let count = NIMSDK.shared().v2TeamService.getJoinedTeamCount(teamTypes)

    teamCallback(nil, NSNumber(integerLiteral: count), resultCallback)
  }

  /// 获取群成员列表
  func getTeamMemberList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let queryOption = arguments["queryOption"] as? [String: Any], let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType) else {
      parameterError(resultCallback)
      return
    }

    let option = V2NIMTeamMemberQueryOption.fromDic(queryOption)

    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.getTeamMemberList(teamId, teamType: teamType, queryOption: option) { result in
      weakSelf?.teamCallback(nil, result.toDic(), resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "getTeamMemberList error \(error.nserror.localizedDescription)")
    }
  }

  /// 批量获取群成员列表
  func getTeamMemberListByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType), let accountIds = arguments["accountIds"] as? [String] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.getTeamMemberList(byIds: teamId, teamType: teamType, accountIds: accountIds) { members in
      weakSelf?.teamCallback(nil, ["memberList": members.map { $0.toDic() }], resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "getTeamMemberListByIds error \(error.nserror.localizedDescription)")
    }
  }

  /// 添加群组成员关注
  public func addTeamMembersFollow(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType), let accountIds = arguments["accountIds"] as? [String] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.addTeamMembersFollow(teamId, teamType: teamType, accountIds: accountIds) {
      weakSelf?.teamCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "addTeamMembersFollow error \(error.nserror.localizedDescription)")
    }
  }

  /// 移除群组成员关注
  public func removeTeamMembersFollow(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType), let accountIds = arguments["accountIds"] as? [String] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.removeTeamMembersFollow(teamId, teamType: teamType, accountIds: accountIds) {
      weakSelf?.teamCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "removeTeamMembersFollow error \(error.nserror.localizedDescription)")
    }
  }

  // 清空所有群申请
  public func clearAllTeamJoinActionInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    weak var weakSelf = self

    NIMSDK.shared().v2TeamService.clearAllTeamJoinActionInfo {
      weakSelf?.teamCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "clearAllTeamJoinActionInfo error \(error.nserror.localizedDescription)")
    }
  }

  /// 带过滤条件清空群申请记录（10.9.7）
  public func clearAllTeamJoinActionInfoEx(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    weak var weakSelf = self
    var option: V2NIMTeamClearJoinActionInfoOption?
    if let optionDic = arguments["option"] as? [String: Any] {
      let opt = V2NIMTeamClearJoinActionInfoOption()
      if let teamTypeInt = optionDic["type"] as? Int,
         let teamType = V2NIMTeamJoinActionTeamType(rawValue: teamTypeInt) {
        opt.type = teamType
      }
      if let time = optionDic["timestamp"] as? Int {
        opt.timestamp = TimeInterval(time / 1000)
      }
      option = opt
    }

    if let unwrappedOption = option {
      NIMSDK.shared().v2TeamService.clearAllTeamJoinActionInfoEx(unwrappedOption) {
        weakSelf?.teamCallback(nil, nil, resultCallback)
      } failure: { error in
        weakSelf?.teamCallback(error.nserror, nil, resultCallback)
        FLTALog.errorLog(teamClassName, desc: "clearAllTeamJoinActionInfoEx error \(error.nserror.localizedDescription)")
      }
    } else {
      NIMSDK.shared().v2TeamService.clearAllTeamJoinActionInfo {
        weakSelf?.teamCallback(nil, nil, resultCallback)
      } failure: { error in
        weakSelf?.teamCallback(error.nserror, nil, resultCallback)
        FLTALog.errorLog(teamClassName, desc: "clearAllTeamJoinActionInfoEx error \(error.nserror.localizedDescription)")
      }
    }
  }

  /// 删除入群申请
  public func deleteTeamJoinActionInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let applicationParamAgruments = arguments["application"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let application = V2NIMTeamJoinActionInfo.fromDic(applicationParamAgruments)

    weak var weakSelf = self

    NIMSDK.shared().v2TeamService.delete(application) {
      weakSelf?.teamCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "deleteTeamJoinActionInfo error \(error.nserror.localizedDescription)")
    }
  }

  /// 邀请成员加入群组
  public func inviteMemberEx(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType), let inviteeParamsDic = arguments["inviteeParams"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let inviteeParams = V2NIMTeamInviteParams.fromDic(inviteeParamsDic)

    weak var weakSelf = self

    NIMSDK.shared().v2TeamService.inviteMemberEx(teamId, teamType: teamType, inviteeParams: inviteeParams) { result in
      weakSelf?.teamCallback(nil, ["failedList": result], resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "inviteMemberEx error \(error.nserror.localizedDescription)")
    }
  }

  /// 获取群成员邀请者
  func getTeamMemberInvitor(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType), let accountIds = arguments["accountIds"] as? [String] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.getTeamMemberInvitor(teamId, teamType: teamType, accountIds: accountIds) { result in
      weakSelf?.teamCallback(nil, result, resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "getTeamMemberInvitor error \(error.nserror.localizedDescription)")
    }
  }

  /// 获取群入群申请列表
  func getTeamJoinActionInfoList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let queryOptionParam = arguments["queryOption"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let queryOption = V2NIMTeamJoinActionInfoQueryOption.fromDic(queryOptionParam)
    if let types = queryOptionParam[#keyPath(V2NIMTeamJoinActionInfoQueryOption.types)] as? [NSNumber] {
      queryOption.types = types
    }
    if let offset = queryOptionParam[#keyPath(V2NIMTeamJoinActionInfoQueryOption.offset)] as? Int {
      queryOption.offset = offset
    }
    if let limit = queryOptionParam[#keyPath(V2NIMTeamJoinActionInfoQueryOption.limit)] as? Int {
      queryOption.limit = limit
    }
    if let status = queryOptionParam[#keyPath(V2NIMTeamJoinActionInfoQueryOption.status)] as? [NSNumber] {
      queryOption.status = status
    }
    weak var weakSelf = self

    NIMSDK.shared().v2TeamService.getTeamJoinActionInfoList(queryOption) { result in
      weakSelf?.teamCallback(nil, result.toDic(), resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "getTeamJoinActionInfoList error \(error.nserror.localizedDescription)")
    }
  }

  /// 搜索群
  func searchTeamByKeyword(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let keyword = arguments["keyword"] as? String else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.searchTeam(byKeyword: keyword) { teams in
      weakSelf?.teamCallback(nil, ["teamList": teams.map { team in
        team.toDic()
      }], resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "searchTeamByKeyword error \(error.nserror.localizedDescription)")
    }
  }

  /// 搜索群成员
  func searchTeamMembers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let searchOptionArguments = arguments["searchOption"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    let searchOption = V2NIMTeamMemberSearchOption()

    if let keyword = searchOptionArguments[#keyPath(V2NIMTeamMemberSearchOption.keyword)] as? String {
      searchOption.keyword = keyword
    }
    if let teamTypeInt = searchOptionArguments[#keyPath(V2NIMTeamMemberSearchOption.teamType)] as? Int, let teamType = V2NIMTeamType(rawValue: teamTypeInt) {
      searchOption.teamType = teamType
    }
    if let teamId = searchOptionArguments[#keyPath(V2NIMTeamMemberSearchOption.teamId)] as? String {
      searchOption.teamId = teamId
    }
    if let nextToken = searchOptionArguments[#keyPath(V2NIMTeamMemberSearchOption.nextToken)] as? String {
      searchOption.nextToken = nextToken
    }
    if let orderInt = searchOptionArguments[#keyPath(V2NIMTeamMemberSearchOption.order)] as? Int, let order = V2NIMSortOrder(rawValue: orderInt) {
      searchOption.order = order
    }
    if let limit = searchOptionArguments[#keyPath(V2NIMTeamMemberSearchOption.limit)] as? Int {
      searchOption.limit = limit
    }
    if let initNextToken = searchOptionArguments["initNextToken"] as? String {
      V2NIMTeamMemberSearchOption.initNextToken = initNextToken
    }
    weak var weakSelf = self

    NIMSDK.shared().v2TeamService.searchTeamMembers(searchOption) { result in
      let resultDic = result.toDic()
      print("sdk list ", result.memberList as Any)
      print("resut dic ", resultDic)
      weakSelf?.teamCallback(nil, result.toDic(), resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "searchTeamMembers error \(error.nserror.localizedDescription)")
    }
  }

  /// 搜索群
  public func getOwnerTeamList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let teamTypesInt = arguments["teamTypes"] as? [Int]
    let teamTypes = teamTypesInt?.map { code in
      NSNumber(value: code)
    }

    // 声明错误变量
    var error: V2NIMError?
    let teams = NIMSDK.shared().v2TeamService.getOwnerTeamList(teamTypes ?? [], error: &error)

    // 处理错误和结果
    if let error = error {
      teamCallback(error.nserror, nil, resultCallback)
    } else {
      // 处理群组列表，teams 非空（但可能为空数组）
      teamCallback(nil, ["teamList": teams.map { team in
        team.toDic()
      }], resultCallback)
    }
  }

  /// 获取管理员群列表（本地，异步接口）
  public func getManagerTeamList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let teamTypesInt = arguments["teamTypes"] as? [Int]
    let teamTypes = teamTypesInt?.map { code in
      NSNumber(value: code)
    }

    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.getManagerTeamList(teamTypes ?? []) { teams in
      weakSelf?.teamCallback(nil, ["teamList": teams.map { $0.toDic() }], resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "getManagerTeamList error \(error.nserror.localizedDescription)")
    }
  }

  /// 从云端获取群信息
  public func getTeamInfoFromCloud(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String,
          let teamTypeInt = arguments["teamType"] as? Int,
          let teamType = V2NIMTeamType(rawValue: teamTypeInt) else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.getTeamInfo(fromCloud: teamId, teamType: teamType) { team in
      weakSelf?.teamCallback(nil, team.toDic(), resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "getTeamInfoFromCloud error \(error.nserror.localizedDescription)")
    }
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any], _ resultCallback: ResultCallback) {
    switch method {
    case V2TeamNameType.createTeam.rawValue:
      createTeam(arguments, resultCallback)
    case V2TeamNameType.updateTeamInfo.rawValue:
      updateTeamInfo(arguments, resultCallback)
    case V2TeamNameType.leaveTeam.rawValue:
      leaveTeam(arguments, resultCallback)
    case V2TeamNameType.getTeamInfo.rawValue:
      getTeamInfo(arguments, resultCallback)
    case V2TeamNameType.getTeamInfoByIds.rawValue:
      getTeamInfoByIds(arguments, resultCallback)
    case V2TeamNameType.dismissTeam.rawValue:
      dismissTeam(arguments, resultCallback)
    case V2TeamNameType.inviteMember.rawValue:
      inviteMember(arguments, resultCallback)
    case V2TeamNameType.acceptInvitation.rawValue:
      acceptInvitation(arguments, resultCallback)
    case V2TeamNameType.rejectInvitation.rawValue:
      rejectInvitation(arguments, resultCallback)
    case V2TeamNameType.kickMember.rawValue:
      kickMember(arguments, resultCallback)
    case V2TeamNameType.applyJoinTeam.rawValue:
      applyJoinTeam(arguments, resultCallback)
    case V2TeamNameType.acceptJoinApplication.rawValue:
      acceptJoinApplication(arguments, resultCallback)
    case V2TeamNameType.rejectJoinApplication.rawValue:
      rejectJoinApplication(arguments, resultCallback)
    case V2TeamNameType.updateTeamMemberRole.rawValue:
      updateTeamMemberRole(arguments, resultCallback)
    case V2TeamNameType.transferTeamOwner.rawValue:
      transferTeamOwner(arguments, resultCallback)
    case V2TeamNameType.updateSelfTeamMemberInfo.rawValue:
      updateSelfTeamMemberInfo(arguments, resultCallback)
    case V2TeamNameType.updateTeamMemberNick.rawValue:
      updateTeamMemberNick(arguments, resultCallback)
    case V2TeamNameType.setTeamChatBannedMode.rawValue:
      setTeamChatBannedMode(arguments, resultCallback)
    case V2TeamNameType.setTeamMemberChatBannedStatus.rawValue:
      setTeamMemberChatBannedStatus(arguments, resultCallback)
    case V2TeamNameType.getJoinedTeamList.rawValue:
      getJoinedTeamList(arguments, resultCallback)
    case V2TeamNameType.getJoinedTeamCount.rawValue:
      getJoinedTeamCount(arguments, resultCallback)
    case V2TeamNameType.getTeamMemberList.rawValue:
      getTeamMemberList(arguments, resultCallback)
    case V2TeamNameType.getTeamMemberInvitor.rawValue:
      getTeamMemberInvitor(arguments, resultCallback)
    case V2TeamNameType.searchTeamByKeyword.rawValue:
      searchTeamByKeyword(arguments, resultCallback)
    case V2TeamNameType.searchTeamMembers.rawValue:
      searchTeamMembers(arguments, resultCallback)
    case V2TeamNameType.getTeamMemberListByIds.rawValue:
      getTeamMemberListByIds(arguments, resultCallback)
    case V2TeamNameType.getTeamJoinActionInfoList.rawValue:
      getTeamJoinActionInfoList(arguments, resultCallback)
    case V2TeamNameType.addTeamMembersFollow.rawValue:
      addTeamMembersFollow(arguments, resultCallback)
    case V2TeamNameType.removeTeamMembersFollow.rawValue:
      removeTeamMembersFollow(arguments, resultCallback)
    case V2TeamNameType.clearAllTeamJoinActionInfo.rawValue:
      clearAllTeamJoinActionInfo(arguments, resultCallback)
    case V2TeamNameType.clearAllTeamJoinActionInfoEx.rawValue:
      clearAllTeamJoinActionInfoEx(arguments, resultCallback)
    case V2TeamNameType.deleteTeamJoinActionInfo.rawValue:
      deleteTeamJoinActionInfo(arguments, resultCallback)
    case V2TeamNameType.inviteMemberEx.rawValue:
      inviteMemberEx(arguments, resultCallback)
    case V2TeamNameType.getOwnerTeamList.rawValue:
      getOwnerTeamList(arguments, resultCallback)
    case V2TeamNameType.searchTeams.rawValue:
      searchTeams(arguments, resultCallback)
    case V2TeamNameType.searchTeamMembersEx.rawValue:
      searchTeamMembersEx(arguments, resultCallback)
    case V2TeamNameType.getManagerTeamList.rawValue:
      getManagerTeamList(arguments, resultCallback)
    case V2TeamNameType.getTeamInfoFromCloud.rawValue:
      getTeamInfoFromCloud(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  // MARK: - New Team Search APIs (10.9.5)

  /// 本地全文检索群信息
  func searchTeams(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsArguments = arguments["searchParams"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    let params = V2NIMTeamSearchParams()
    if let keywordList = paramsArguments["keywordList"] as? [String] {
      params.keywordList = keywordList
    }
    if let keywordMatchTypeInt = paramsArguments["keywordMatchType"] as? Int,
       let keywordMatchType = V2NIMSearchKeywordMathType(rawValue: keywordMatchTypeInt) {
      params.keywordMatchType = keywordMatchType
    }
    if let teamTypesRaw = paramsArguments["teamTypes"] as? [Int] {
      params.teamTypes = teamTypesRaw.map { NSNumber(value: $0) }
    }
    if let limit = paramsArguments["limit"] as? Int {
      params.limit = limit
    }
    if let nextToken = paramsArguments["nextToken"] as? String {
      params.nextToken = nextToken
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.searchTeams(params) { teams in
      weakSelf?.teamCallback(nil, ["teamList": teams.map { $0.toDic() }], resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "searchTeams error \(error.nserror.localizedDescription)")
    }
  }

  /// 本地全文检索群成员信息
  func searchTeamMembersEx(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsArguments = arguments["searchParams"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    let params = V2NIMSearchTeamMemberParams()
    if let keywordList = paramsArguments["keywordList"] as? [String] {
      params.keywordList = keywordList
    }
    if let keywordMatchTypeInt = paramsArguments["keywordMatchType"] as? Int,
       let keywordMatchType = V2NIMSearchKeywordMathType(rawValue: keywordMatchTypeInt) {
      params.keywordMatchType = keywordMatchType
    }
    if let teamRefersRaw = paramsArguments["teamRefers"] as? [[String: Any]] {
      params.teamRefers = teamRefersRaw.compactMap { dic -> V2NIMTeamRefer? in
        guard let teamId = dic["teamId"] as? String,
              let teamTypeInt = dic["teamType"] as? Int,
              let teamType = V2NIMTeamType(rawValue: teamTypeInt) else { return nil }
        let refer = V2NIMTeamRefer()
        refer.teamId = teamId
        refer.teamType = teamType
        return refer
      }
    }
    if let searchAccountId = paramsArguments["searchAccountId"] as? Bool {
      params.searchAccountId = searchAccountId
    }
    if let searchTeamNick = paramsArguments["searchTeamNick"] as? Bool {
      params.searchTeamNick = searchTeamNick
    }
    if let limit = paramsArguments["limit"] as? Int {
      params.limit = limit
    }
    if let nextToken = paramsArguments["nextToken"] as? String {
      params.nextToken = nextToken
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.searchTeamMembersEx(params) { resultDict in
      var items: [[String: Any]] = []
      resultDict.forEach { refer, members in
        var item: [String: Any] = [:]
        item["teamRefer"] = ["teamId": refer.teamId, "teamType": refer.teamType.rawValue]
        item["members"] = members.map { $0.toDic() }
        items.append(item)
      }
      weakSelf?.teamCallback(nil, ["resultList": items], resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "searchTeamMembersEx error \(error.nserror.localizedDescription)")
    }
  }
}

extension FLTTeamService {
  /**
   *  同步完成
   */
  func onSyncFinished() {
    notifyEvent(serviceName(), "onSyncFinished", nil)
  }

  /**
   *  同步失败
   *
   *  @param error 错误
   */
  func onSyncFailed(_ error: V2NIMError) {
    notifyEvent(serviceName(), "onSyncFailed", NimResult.error(Int(error.code), error.nserror.localizedDescription).toDic())
  }

  /**
   *  入群操作回调
   *
   *  @param joinActionInfo 入群操作信息
   */
  func onReceive(_ joinActionInfo: V2NIMTeamJoinActionInfo) {
    notifyEvent(serviceName(), "onReceiveTeamJoinActionInfo", joinActionInfo.toDic())
  }

  /**
   *  加入群组回调
   *
   *  @param team 加入的群组
   */
  func onTeamJoined(_ team: V2NIMTeam) {
    notifyEvent(serviceName(), "onTeamJoined", team.toDic())
  }

  /**
   *  群组创建回调
   *
   *  @param team 新创建的群组
   */
  func onTeamCreated(_ team: V2NIMTeam) {
    notifyEvent(serviceName(), "onTeamCreated", team.toDic())
  }

  func onTeamMemberLeft(_ teamMembers: [V2NIMTeamMember]) {
    notifyEvent(serviceName(), "onTeamMemberLeft", ["memberList": teamMembers.map { $0.toDic() }])
  }

  /**
   *  群组成员加入回调
   *
   *  @param teamMembers 加入的群组成员列表
   */
  func onTeamMemberJoined(_ teamMembers: [V2NIMTeamMember]) {
    notifyEvent(serviceName(), "onTeamMemberJoined", ["memberList": teamMembers.map { $0.toDic() }])
  }

  /**
   *  群组解散回调
   *
   *  @param team 解散的群组
   *
   *  @discussion 仅teamId和teamType字段有效
   */
  func onTeamDismissed(_ team: V2NIMTeam) {
    notifyEvent(serviceName(), "onTeamDismissed", team.toDic())
  }

  /**
   *  群组信息更新回调
   *
   *  @param team 更新信息群组
   */
  func onTeamInfoUpdated(_ team: V2NIMTeam) {
    notifyEvent(serviceName(), "onTeamInfoUpdated", team.toDic())
  }

  /**
   *  离开群组回调
   *
   *  @param team 离开的群组
   *  @param isKicked 是否被踢出群组
   *
   *  @discussion 主动离开群组或被管理员踢出群组
   */
  func onTeamLeft(_ team: V2NIMTeam, isKicked: Bool) {
    print("on Team Left swift")
    notifyEvent(serviceName(), "onTeamLeft", ["team": team.toDic(), "isKicked": isKicked])
  }

  /**
   *  同步开始
   */
  func onSyncStarted() {
    notifyEvent(serviceName(), "onSyncStarted", nil)
  }

  /**
   *  群组成员信息变更回调
   *
   *  @param teamMembers 信息变更的群组成员列表
   */
  func onTeamMemberInfoUpdated(_ teamMembers: [V2NIMTeamMember]) {
    notifyEvent(serviceName(), "onTeamMemberInfoUpdated", ["memberList": teamMembers.map { $0.toDic() }])
  }

  /**
   *  群组成员被踢回调
   *
   *  @param operatorAccountId 操作账号id
   *  @param teamMembers teamMembers的群组成员列表
   */
  func onTeamMemberKicked(_ operatorAccountId: String, teamMembers: [V2NIMTeamMember]) {
    notifyEvent(serviceName(), "onTeamMemberKicked", ["operatorAccountId": operatorAccountId, "memberList": teamMembers.map { $0.toDic() }])
  }
}
