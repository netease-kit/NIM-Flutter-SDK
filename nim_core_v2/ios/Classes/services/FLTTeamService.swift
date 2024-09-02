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
    FLTALog.infoLog(teamClassName, desc: "createTeam argument \(arguments)")
    guard let createTeamParamsArguments = arguments["createTeamParams"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let createTeamParams = V2NIMCreateTeamParams.fromDictionary(createTeamParamsArguments)

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
      weakSelf?.teamCallback(nil, resut.toDictionary(), resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "createTeam error \(error.nserror.localizedDescription)")
    }
  }

  /// 更新群信息
  public func updateTeamInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "updateTeamInfo argument \(arguments)")

    guard let updateTeamInfoParamsArguments = arguments["updateTeamInfoParams"] as? [String: Any], let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType) else {
      parameterError(resultCallback)

      return
    }
    let updateTeamInfoParams = V2NIMUpdateTeamInfoParams.fromDictionary(updateTeamInfoParamsArguments)

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
  public func leaveTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "leaveTeam argument \(arguments)")

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
  public func getTeamInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "getTeamInfo argument \(arguments)")

    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType) else {
      parameterError(resultCallback)

      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.getTeamInfo(teamId, teamType: teamType) { team in
      weakSelf?.teamCallback(nil, team.toDictionary(), resultCallback)
    } failure: { error in

      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "getTeamInfo error \(error.nserror.localizedDescription)")
    }
  }

  /// 批量获取群信息
  public func getTeamInfoByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "getTeamInfoByIds argument \(arguments)")

    guard let teamIds = arguments["teamIds"] as? [String], let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType) else {
      parameterError(resultCallback)

      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.getTeamInfo(byIds: teamIds, teamType: teamType) { teams in
      weakSelf?.teamCallback(nil, ["teamList": teams.map { $0.toDictionary() }], resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "getTeamInfoByIds error \(error.nserror.localizedDescription)")
    }
  }

  /// 解散群
  public func dismissTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "dismissTeam argument \(arguments)")

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
  public func inviteMember(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "inviteMember argument \(arguments)")

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
  public func acceptInvitation(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "acceptInvitation argument \(arguments)")

    guard let invitationInfoParam = arguments["invitationInfo"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let invitationInfo = V2NIMTeamJoinActionInfo.fromDictionary(invitationInfoParam)

    weak var weakSelf = self

    NIMSDK.shared().v2TeamService.acceptInvitation(invitationInfo) { team in
      weakSelf?.teamCallback(nil, team.toDictionary(), resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "acceptInvitation error \(error.nserror.localizedDescription)")
    }
  }

  /// 拒绝邀请
  public func rejectInvitation(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "rejectInvitation argument \(arguments)")

    guard let invitationInfoParam = arguments["invitationInfo"] as? [String: Any] else {
      return
    }

    let invitationInfo = V2NIMTeamJoinActionInfo.fromDictionary(invitationInfoParam)

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
  public func kickMember(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "kickMember argument \(arguments)")

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
  public func applyJoinTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "applyJoinTeam argument \(arguments)")

    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType) else {
      return
    }

    let postscript = arguments["postscript"] as? String
    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.applyJoinTeam(teamId, teamType: teamType, postscript: postscript) { team in
      weakSelf?.teamCallback(nil, team.toDictionary(), resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "applyJoinTeam error \(error.nserror.localizedDescription)")
    }
  }

  /// 同意入群申请
  public func acceptJoinApplication(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "acceptJoinApplication argument \(arguments)")

    guard let acceptJoinApplicationParam = arguments["joinInfo"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let acceptJoinApplicationInfo = V2NIMTeamJoinActionInfo.fromDictionary(acceptJoinApplicationParam)

    weak var weakSelf = self

    NIMSDK.shared().v2TeamService.acceptJoinApplication(acceptJoinApplicationInfo) {
      weakSelf?.teamCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "acceptJoinApplication error \(error.nserror.localizedDescription)")
    }
  }

  /// 拒绝入群申请
  public func rejectJoinApplication(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "rejectJoinApplication argument \(arguments)")

    guard let rejectJoinParamAgruments = arguments["joinInfo"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let rejectJoinActionInfo = V2NIMTeamJoinActionInfo.fromDictionary(rejectJoinParamAgruments)

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
  public func updateTeamMemberRole(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "updateTeamMemberRole argument \(arguments)")

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
  public func transferTeamOwner(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "transferTeamOwner argument \(arguments)")

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
  public func updateSelfTeamMemberInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "updateSelfTeamMemberInfo argument \(arguments)")

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
  public func updateTeamMemberNick(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "updateTeamMemberNick argument \(arguments)")

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
  public func setTeamChatBannedMode(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "setTeamChatBannedMode argument \(arguments)")

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
  public func setTeamMemberChatBannedStatus(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "teamClassName argument \(arguments)")

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
  public func getJoinedTeamList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "getJoinedTeamList argument \(arguments)")

    guard let teamTypes = arguments["teamTypes"] as? [NSNumber] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.getJoinedTeamList(teamTypes) { teams in
      weakSelf?.teamCallback(nil, ["teamList": teams.map { team in
        team.toDictionary()
      }], resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "getJoinedTeamList error \(error.nserror.localizedDescription)")
    }
  }

  /// 获取已加入的群数量
  public func getJoinedTeamCount(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "getJoinedTeamCount argument \(arguments)")

    guard let teamTypes = arguments["teamTypes"] as? [NSNumber] else {
      parameterError(resultCallback)
      return
    }

    let count = NIMSDK.shared().v2TeamService.getJoinedTeamCount(teamTypes)

    teamCallback(nil, NSNumber(integerLiteral: count), resultCallback)
  }

  /// 获取群成员列表
  public func getTeamMemberList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "getTeamMemberList argument \(arguments)")

    guard let queryOption = arguments["queryOption"] as? [String: Any], let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType) else {
      parameterError(resultCallback)
      return
    }

    let option = V2NIMTeamMemberQueryOption.fromDictionary(queryOption)

    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.getTeamMemberList(teamId, teamType: teamType, queryOption: option) { result in

      weakSelf?.teamCallback(nil, result.toDictionary(), resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "getTeamMemberList error \(error.nserror.localizedDescription)")
    }
  }

  /// 批量获取群成员列表
  public func getTeamMemberListByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "getTeamMemberListByIds argument \(arguments)")

    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamType = V2NIMTeamType(rawValue: teamType), let accountIds = arguments["accountIds"] as? [String] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.getTeamMemberList(byIds: teamId, teamType: teamType, accountIds: accountIds) { members in
      weakSelf?.teamCallback(nil, ["memberList": members.map { $0.toDictionary() }], resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "getTeamMemberListByIds error \(error.nserror.localizedDescription)")
    }
  }

  /// 获取群成员邀请者
  public func getTeamMemberInvitor(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "getTeamMemberInvitor argument \(arguments)")

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
  public func getTeamJoinActionInfoList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "getTeamJoinActionInfoList argument \(arguments)")

    guard let queryOptionParam = arguments["queryOption"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let queryOption = V2NIMTeamJoinActionInfoQueryOption.fromDictionary(queryOptionParam)
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
      weakSelf?.teamCallback(nil, result.toDictionary(), resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "getTeamJoinActionInfoList error \(error.nserror.localizedDescription)")
    }
  }

  /// 搜索群
  public func searchTeamByKeyword(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "searchTeamByKeyword argument \(arguments)")

    guard let keyword = arguments["keyword"] as? String else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TeamService.searchTeam(byKeyword: keyword) { teams in
      weakSelf?.teamCallback(nil, ["teamList": teams.map { team in
        team.toDictionary()
      }], resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "searchTeamByKeyword error \(error.nserror.localizedDescription)")
    }
  }

  /// 搜索群成员
  public func searchTeamMembers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(teamClassName, desc: "searchTeamMembers argument \(arguments)")

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
      let resultDic = result.toDictionary()
      print("sdk list ", result.memberList as Any)
      print("resut dic ", resultDic)
      weakSelf?.teamCallback(nil, result.toDictionary(), resultCallback)
    } failure: { error in
      weakSelf?.teamCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(teamClassName, desc: "searchTeamMembers error \(error.nserror.localizedDescription)")
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
    default:
      resultCallback.notImplemented()
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
    notifyEvent(serviceName(), "onReceiveTeamJoinActionInfo", joinActionInfo.toDictionary())
  }

  /**
   *  加入群组回调
   *
   *  @param team 加入的群组
   */
  func onTeamJoined(_ team: V2NIMTeam) {
    notifyEvent(serviceName(), "onTeamJoined", team.toDictionary())
  }

  /**
   *  群组创建回调
   *
   *  @param team 新创建的群组
   */
  func onTeamCreated(_ team: V2NIMTeam) {
    notifyEvent(serviceName(), "onTeamCreated", team.toDictionary())
  }

  func onTeamMemberLeft(_ teamMembers: [V2NIMTeamMember]) {
    notifyEvent(serviceName(), "onTeamMemberLeft", ["memberList": teamMembers.map { $0.toDictionary() }])
  }

  /**
   *  群组成员加入回调
   *
   *  @param teamMembers 加入的群组成员列表
   */
  func onTeamMemberJoined(_ teamMembers: [V2NIMTeamMember]) {
    notifyEvent(serviceName(), "onTeamMemberJoined", ["memberList": teamMembers.map { $0.toDictionary() }])
  }

  /**
   *  群组解散回调
   *
   *  @param team 解散的群组
   *
   *  @discussion 仅teamId和teamType字段有效
   */
  func onTeamDismissed(_ team: V2NIMTeam) {
    notifyEvent(serviceName(), "onTeamDismissed", team.toDictionary())
  }

  /**
   *  群组信息更新回调
   *
   *  @param team 更新信息群组
   */
  func onTeamInfoUpdated(_ team: V2NIMTeam) {
    notifyEvent(serviceName(), "onTeamInfoUpdated", team.toDictionary())
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
    notifyEvent(serviceName(), "onTeamLeft", ["team": team.toDictionary(), "isKicked": isKicked])
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
    notifyEvent(serviceName(), "onTeamMemberInfoUpdated", ["memberList": teamMembers.map { $0.toDictionary() }])
  }

  /**
   *  群组成员被踢回调
   *
   *  @param operatorAccountId 操作账号id
   *  @param teamMembers teamMembers的群组成员列表
   */
  func onTeamMemberKicked(_ operatorAccountId: String, teamMembers: [V2NIMTeamMember]) {
    notifyEvent(serviceName(), "onTeamMemberKicked", ["operatorAccountId": operatorAccountId, "memberList": teamMembers.map { $0.toDictionary() }])
  }
}
