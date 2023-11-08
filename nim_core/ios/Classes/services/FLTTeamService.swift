// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum TeamType: String {
  case CreateTeam = "createTeam"
  case QueryTeamList = "queryTeamList"
  case QueryTeam = "queryTeam"
  case SearchTeam = "searchTeam"
  case DismissTeam = "dismissTeam"
  case ApplyJoinTeam = "applyJoinTeam"
  case PassApply = "passApply"
  case RejectApply = "rejectApply"
  case AddMembersEx = "addMembersEx"
  case AcceptInvite = "acceptInvite"
  case DeclineInvite = "declineInvite"
  case GetMemberInvitor = "getMemberInvitor"
  case RemoveMembers = "removeMembers"
  case QuitTeam = "quitTeam"
  case QueryMemberList = "queryMemberList"
  case QueryTeamMember = "queryTeamMember"
  case UpdateMemberNick = "updateMemberNick"
  case TransferTeam = "transferTeam"
  case AddManagers = "addManagers"
  case RemoveManagers = "removeManagers"
  case MuteTeamMember = "muteTeamMember"
  case MuteAllTeamMember = "muteAllTeamMember"
  case QueryMutedTeamMembers = "queryMutedTeamMembers"
  case UpdateTeamFields = "updateTeamFields"
  case MuteTeam = "muteTeam"
  case SearchTeamIdByName = "searchTeamIdByName"
  case SearchTeamsByKeyword = "searchTeamsByKeyword"
  case UpdateMyMemberExtension = "updateMyMemberExtension"
  case UpdateMyTeamNick = "updateMyTeamNick"
}

class FLTTeamService: FLTBaseService, FLTService {
  override func onInitialized() {
    NIMSDK.shared().teamManager.add(self)
  }

  deinit {
    NIMSDK.shared().teamManager.remove(self)
  }

  func serviceName() -> String {
    ServiceType.TeamService.rawValue
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case TeamType.CreateTeam.rawValue: createTeam(arguments, resultCallback)
    case TeamType.QueryTeamList.rawValue: queryTeamList(arguments, resultCallback)
    case TeamType.QueryTeam.rawValue: queryTeam(arguments, resultCallback)
    case TeamType.SearchTeam.rawValue: searchTeam(arguments, resultCallback)
    case TeamType.DismissTeam.rawValue: dismissTeam(arguments, resultCallback)
    case TeamType.ApplyJoinTeam.rawValue: applyJoinTeam(arguments, resultCallback)
    case TeamType.PassApply.rawValue: passApply(arguments, resultCallback)
    case TeamType.RejectApply.rawValue: rejectApply(arguments, resultCallback)
    case TeamType.AddMembersEx.rawValue: addMembersEx(arguments, resultCallback)
    case TeamType.AcceptInvite.rawValue: acceptInvite(arguments, resultCallback)
    case TeamType.DeclineInvite.rawValue: declineInvite(arguments, resultCallback)
    case TeamType.GetMemberInvitor.rawValue: getMemberInvitor(arguments, resultCallback)
    case TeamType.RemoveMembers.rawValue: removeMembers(arguments, resultCallback)
    case TeamType.QuitTeam.rawValue: quitTeam(arguments, resultCallback)
    case TeamType.QueryMemberList.rawValue: queryMemberList(arguments, resultCallback)
    case TeamType.QueryTeamMember.rawValue: queryTeamMember(arguments, resultCallback)
    case TeamType.UpdateMemberNick.rawValue: updateMemberNick(arguments, resultCallback)
    case TeamType.TransferTeam.rawValue: transferTeam(arguments, resultCallback)
    case TeamType.AddManagers.rawValue: addManagers(arguments, resultCallback)
    case TeamType.RemoveManagers.rawValue: removeManagers(arguments, resultCallback)
    case TeamType.MuteTeamMember.rawValue: muteTeamMember(arguments, resultCallback)
    case TeamType.MuteAllTeamMember.rawValue: muteAllTeamMember(arguments, resultCallback)
    case TeamType.QueryMutedTeamMembers
      .rawValue: queryMutedTeamMembers(arguments, resultCallback)
    case TeamType.UpdateTeamFields.rawValue: updateTeamFields(arguments, resultCallback)
    case TeamType.MuteTeam.rawValue: muteTeam(arguments, resultCallback)
    case TeamType.SearchTeamsByKeyword.rawValue: searchTeamWithOption(arguments, resultCallback)
    case TeamType.SearchTeamIdByName.rawValue: searchTeamWithOption(arguments, resultCallback)
    case TeamType.UpdateMyMemberExtension
      .rawValue: updateMyMemberExtension(arguments, resultCallback)
    case TeamType.UpdateMyTeamNick.rawValue: updateMyTeamNick(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  private func createTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let option = arguments["createTeamOptions"] as? [String: Any],
       let createOption = NIMCreateTeamOption.fromDic(option) as? NIMCreateTeamOption,
       let users = arguments["members"] as? [String] {
      weak var weakSelf = self
      NIMSDK.shared().teamManager
        .createTeam(createOption, users: users) { error, teamid, failedUserIds in
          if error != nil {
            weakSelf?.teamCallback(error, nil, resultCallback)
          } else {
            NIMSDK.shared().teamManager.fetchTeamInfo(teamid!, completion: { error, team in
              weakSelf?.teamCallback(
                error,
                ["team": team?.toDic() ?? [:], "failedInviteAccounts": failedUserIds ?? []],
                resultCallback
              )
            })
          }
        }
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }

  private func queryTeamList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let teams = NIMSDK.shared().teamManager.allMyTeams()
    let ret = teams?.map { team in team.toDic() }
    teamCallback(nil, ["teamList": ret], resultCallback)
  }

  private func queryTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }
    if teamId.isEmpty {
      errorCallBack(resultCallback, "parameter is empty", 1000)
      return
    }
    let team = NIMSDK.shared().teamManager.team(byId: teamId)
    teamCallback(nil, team?.toDic(), resultCallback)
  }

  // 从服务器获取群组
  private func searchTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().teamManager.fetchTeamInfo(teamId, completion: { error, team in
      weakSelf?.teamCallback(error, team?.toDic(), resultCallback)
    })
  }

  // 解散群
  private func dismissTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().teamManager.dismissTeam(teamId) { error in
      weakSelf?.teamCallback(error, nil, resultCallback)
    }
  }

  // 申请加入群组
  private func applyJoinTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }
    let message = arguments["postscript"] as? String ?? ""
    weak var weakSelf = self
    NIMSDK.shared().teamManager.apply(toTeam: teamId, message: message) { error, status in
      if error != nil {
        weakSelf?.teamCallback(error, nil, resultCallback)
      } else {
        NIMSDK.shared().teamManager.fetchTeamInfo(teamId, completion: { error, team in
          weakSelf?.teamCallback(error, team?.toDic(), resultCallback)
        })
      }
    }
  }

  // 通过申请(仅限高级群)
  private func passApply(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments),
          let userId = getUserId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().teamManager.passApply(toTeam: teamId, userId: userId) { error, status in
      weakSelf?.teamCallback(error, nil, resultCallback)
    }
  }

  // 拒绝申请(仅限高级群)
  private func rejectApply(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments),
          let userId = getUserId(arguments),
          let reason = arguments["reason"] as? String else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().teamManager
      .rejectApply(toTeam: teamId, userId: userId, rejectReason: reason) { error in
        weakSelf?.teamCallback(error, nil, resultCallback)
      }
  }

  // 邀请用户入群
  private func addMembersEx(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments),
          let users = arguments["accounts"] as? [String] else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    let postscript = arguments["msg"] as? String
    let attach = arguments["customInfo"] as? String

    NIMSDK.shared().teamManager
      .addUsers(users, toTeam: teamId, postscript: postscript,
                attach: attach) { error, members in
        let memberMaps = members?.compactMap { member in
          member.userId
        }
        weakSelf?.teamCallback(error, ["teamMemberExList": memberMaps], resultCallback)
      }
  }

  // 同意群邀请(仅限高级群)
  private func acceptInvite(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments),
          let invitorId = arguments["inviter"] as? String else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().teamManager.acceptInvite(withTeam: teamId, invitorId: invitorId) { error in
      weakSelf?.teamCallback(error, nil, resultCallback)
    }
  }

  // 拒绝群邀请(仅限高级群)
  private func declineInvite(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments),
          let invitorId = arguments["inviter"] as? String,
          let reason = arguments["reason"] as? String else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().teamManager
      .rejectInvite(withTeam: teamId, invitorId: invitorId, rejectReason: reason) { error in
        weakSelf?.teamCallback(error, nil, resultCallback)
      }
  }

  // 查询群成员入群邀请人
  private func getMemberInvitor(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments),
          let memberIds = arguments["accids"] as? [String] else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().teamManager
      .fetchInviterAccids(teamId, withTargetMembers: memberIds) { error, inviters in
        weakSelf?.teamCallback(error, inviters, resultCallback)
      }
  }

  // 踢人出群
  private func removeMembers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments),
          let userIds = arguments["members"] as? [String] else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().teamManager.kickUsers(userIds, fromTeam: teamId) { error in
      weakSelf?.teamCallback(error, nil, resultCallback)
    }
  }

  // 主动退群
  private func quitTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().teamManager.quitTeam(teamId) { error in
      weakSelf?.teamCallback(error, nil, resultCallback)
    }
  }

  // 获取群组成员列表
  private func queryMemberList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().teamManager.fetchTeamMembers(teamId) { error, members in
      let ret = members?.map { member in
        member.toDic()
      }
      weakSelf?.teamCallback(error, ["teamMemberList": ret], resultCallback)
    }
  }

  // 获取指定群组成员
  private func queryTeamMember(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments),
          let userId = getUserId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }
    if teamId.isEmpty || userId.isEmpty {
      errorCallBack(resultCallback, "parameter teamId is empty", 404)
    }

    let member = NIMSDK.shared().teamManager.teamMember(userId, inTeam: teamId)
    teamCallback(nil, member?.toDic(), resultCallback)
  }

  // 修改群成员昵称
  private func updateMemberNick(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments),
          let userId = getUserId(arguments),
          let newNick = arguments["nick"] as? String else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().teamManager
      .updateUserNick(userId, newNick: newNick, inTeam: teamId) { error in
        weakSelf?.teamCallback(error, nil, resultCallback)
      }
  }

  // 群主转让,quit为false：参数仅包含原拥有者和当前拥有者的(即操作者和account)，权限已被更新。 quit为true: 参数为空。
  private func transferTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments),
          let newOwnerId = getUserId(arguments),
          let isLeave = arguments["quit"] as? Bool else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().teamManager
      .transferManager(withTeam: teamId, newOwnerId: newOwnerId, isLeave: isLeave) { error in
        if error != nil {
          weakSelf?.teamCallback(error, nil, resultCallback)
        } else {
          if isLeave {
            let emptyResult: [String] = Array()
            weakSelf?.teamCallback(error, ["teamMemberList": emptyResult], resultCallback)
          } else {
            NIMSDK.shared().teamManager.fetchTeamMembers(fromServer: teamId) { error, members in
              var ret = members?.filter { teamMember in
                teamMember.userId == newOwnerId || teamMember.userId == NIMSDK.shared().loginManager.currentAccount()
              }.map { member in
                member.toDic()
              }
              if ret == nil {
                ret = Array()
              }
              weakSelf?.teamCallback(error, ["teamMemberList": ret], resultCallback)
            }
          }
        }
      }
  }

  // 添加管理员
  private func addManagers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments),
          let userIds = arguments["accounts"] as? [String] else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().teamManager.addManagers(toTeam: teamId, users: userIds) { error in
      if error != nil {
        weakSelf?.teamCallback(error, nil, resultCallback)
      } else {
        NIMSDK.shared().teamManager.fetchTeamMembers(teamId) { error, members in
          let ret = members?.filter { teamMember in
            for user in userIds {
              if user == teamMember.userId {
                return true
              }
            }
            return false
          }.map { member in
            member.toDic()
          }
          weakSelf?.teamCallback(error, ["teamMemberList": ret], resultCallback)
        }
      }
    }
  }

  // 移除管理员
  private func removeManagers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments),
          let userIds = arguments["managers"] as? [String] else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().teamManager.removeManagers(fromTeam: teamId, users: userIds) { error in
      if error != nil {
        weakSelf?.teamCallback(error, nil, resultCallback)
      } else {
        NIMSDK.shared().teamManager.fetchTeamMembers(fromServer: teamId) { error, members in
          let ret = members?.filter { teamMember in
            for user in userIds {
              if user == teamMember.userId {
                return true
              }
            }
            return false
          }.map { member in
            member.toDic()
          }
          weakSelf?.teamCallback(error, ["teamMemberList": ret], resultCallback)
        }
      }
    }
  }

  // 禁言指定成员
  private func muteTeamMember(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments),
          let userId = getUserId(arguments),
          let mute = arguments["mute"] as? Bool else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().teamManager.updateMuteState(mute, userId: userId, inTeam: teamId) { error in
      weakSelf?.teamCallback(error, nil, resultCallback)
    }
  }

  // 禁言全体普通成员
  private func muteAllTeamMember(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments),
          let mute = arguments["mute"] as? Bool else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().teamManager.updateMuteState(mute, inTeam: teamId) { error in
      weakSelf?.teamCallback(error, nil, resultCallback)
    }
  }

  // 查询禁言用户列表
  private func queryMutedTeamMembers(_ arguments: [String: Any],
                                     _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().teamManager.fetchTeamMutedMembers(teamId) { error, members in
      var ret = members?.map { member in
        member.toDic()
      }
      if ret == nil {
        ret = Array()
      }
      weakSelf?.teamCallback(error, ["teamMemberList": ret], resultCallback)
    }
  }

  private func updateTeamFields(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments),
          let request = arguments["request"] as? [String: Any?],
          let requestList = request["requestList"] as? [String] else {
      errorCallBack(resultCallback, "parameter is error", 414)
      return
    }
    weak var weakSelf = self
    var values = [NSNumber: String]()
    if requestList.contains("announcement") {
      values[NSNumber(value: NIMTeamUpdateTag.anouncement.rawValue)] =
        request["announcement"] as? String ?? ""
    }
    if requestList.contains("beInviteMode"),
       let beInviteMode = request["beInviteMode"] as? Int {
      values[NSNumber(value: NIMTeamUpdateTag.beInviteMode.rawValue)] = String(beInviteMode)
    }
    if requestList.contains("extension") {
      values[NSNumber(value: NIMTeamUpdateTag.clientCustom.rawValue)] =
        request["extension"] as? String ?? ""
    }
    if requestList.contains("icon") {
      values[NSNumber(value: NIMTeamUpdateTag.avatar.rawValue)] = request["icon"] as? String ??
        ""
    }
    if requestList.contains("introduce") {
      values[NSNumber(value: NIMTeamUpdateTag.intro.rawValue)] =
        request["introduce"] as? String ?? ""
    }
    if requestList.contains("inviteMode"),
       let inviteMode = request["inviteMode"] as? Int {
      values[NSNumber(value: NIMTeamUpdateTag.inviteMode.rawValue)] = String(inviteMode)
    }
    if requestList.contains("maxMemberCount") {
      // iOS不支持
      //            values[NSNumber.init(value: NIMTeamUpdateTag.anouncement.rawValue)] = request["maxMemberCount"] as? String ?? ""
    }
    if requestList.contains("name") {
      values[NSNumber(value: NIMTeamUpdateTag.name.rawValue)] = request["name"] as? String ??
        ""
    }
    if requestList.contains("teamExtensionUpdateMode"),
       let teamExtensionUpdateMode = request["teamExtensionUpdateMode"] as? Int {
      values[NSNumber(value: NIMTeamUpdateTag.updateClientCustomMode.rawValue)] =
        String(teamExtensionUpdateMode)
    }
    if requestList.contains("teamUpdateMode"),
       let teamUpdateMode = request["teamUpdateMode"] as? Int {
      values[NSNumber(value: NIMTeamUpdateTag.updateInfoMode.rawValue)] =
        String(teamUpdateMode)
    }
    if requestList.contains("verifyType"),
       let verifyType = request["verifyType"] as? Int {
      values[NSNumber(value: NIMTeamUpdateTag.joinMode.rawValue)] = String(verifyType)
    }

    if teamId.isEmpty || values.isEmpty {
      errorCallBack(resultCallback, "parameter is error", 414)
      return
    }
    NIMSDK.shared().teamManager.updateTeamInfos(values, teamId: teamId) { error in
      weakSelf?.teamCallback(error, nil, resultCallback)
    }
  }

  // 消息免打扰
  private func muteTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments),
          let notifyState = arguments["notifyType"] as? String,
          let state = FLT_NIMTeamNotifyState(rawValue: notifyState) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().teamManager.update(state.convertNIMNotifyState(), inTeam: teamId) { error in
      weakSelf?.teamCallback(error, nil, resultCallback)
    }
  }

  // 群组检索
  private func searchTeamWithOption(_ arguments: [String: Any],
                                    _ resultCallback: ResultCallback) {
    if let name = arguments["name"] as? String {
      let option = NIMTeamSearchOption()
      option.searchContent = name
      option.searchContentOption = .optiontName

      weak var weakSelf = self
      NIMSDK.shared().teamManager.searchTeam(with: option) { error, teams in
        let ret = teams?.map { team in team.teamId }
        weakSelf?.teamCallback(error, ["teamNameList": ret], resultCallback)
      }

      return
    }

    if let keyword = arguments["keyword"] as? String {
      let option = NIMTeamSearchOption()
      option.searchContent = keyword
      option.searchContentOption = .optionTeamAll

      weak var weakSelf = self
      NIMSDK.shared().teamManager.searchTeam(with: option) { error, teams in
        let ret = teams?.map { team in
          team.toDic()
        }
        weakSelf?.teamCallback(error, ["teamList": ret], resultCallback)
      }
      return
    }
    errorCallBack(resultCallback, "parameter is error")
  }

  private func updateMyMemberExtension(_ arguments: [String: Any],
                                       _ resultCallback: ResultCallback) {
    guard let teamId = getTeamId(arguments),
          let ext = arguments["extension"] as? [String: Any?],
          let data = try? JSONSerialization.data(withJSONObject: ext, options: []),
          let str = String(data: data, encoding: String.Encoding.utf8) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().teamManager.updateMyCustomInfo(str, inTeam: teamId) { error in
      weakSelf?.teamCallback(error, nil, resultCallback)
    }
  }

  // 修改自己的群昵称
  private func updateMyTeamNick(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    var params = [String: Any]()
    params["teamId"] = arguments["teamId"]
    params["nick"] = arguments["nick"]
    params["account"] = NIMSDK.shared().loginManager.currentAccount()
    updateMemberNick(params, resultCallback)
  }

  private func teamCallback(_ error: Error?, _ data: Any?, _ resultCallback: ResultCallback) {
    if let ns_error = error as NSError? {
      errorCallBack(resultCallback, ns_error.description, ns_error.code)
    } else {
      successCallBack(resultCallback, data)
    }
  }
}

extension FLTTeamService: NIMTeamManagerDelegate {
  private func teamMembers(_ memberIDs: [String]?, _ teamId: String?) -> [[String: Any?]] {
    var members = [[String: Any?]]()
    memberIDs?.forEach { memberId in
      if let m = NIMSDK.shared().teamManager.teamMember(memberId, inTeam: teamId ?? ""),
         let dic = m.toDic() {
        members.append(dic)
      } else {
        let dicMember = ["id": teamId, "account": memberId, "type": "normal", "isInTeam": false, "isMute": false, "joinTime": 0]
        members.append(dicMember)
      }
    }
    return members
  }

  private func superTeamMembers(_ memberIDs: [String]?, _ teamId: String?) -> [[String: Any?]] {
    var members = [[String: Any?]]()
    memberIDs?.forEach { memberId in
      if let m = NIMSDK.shared().superTeamManager.teamMember(memberId, inTeam: teamId ?? ""),
         let dic = m.toDic() {
        members.append(dic)
      }
    }
    return members
  }

  // 群成员变更，Android 端在成员数量变化时会回调，在成员属性变化时不会回调，
  // 此处ios会比Android 多一种情况的回调
  func onTeamMemberChanged(_ team: NIMTeam) {
    onTeamUpdated(team)
  }

  func onTeamMemberUpdated(_ team: NIMTeam, withMembers memberIDs: [String]?) {
    if team.type == .super {
      notifyEvent(
        ServiceType.SuperTeamService.rawValue,
        "onSuperTeamMemberUpdate",
        ["teamMemberList": superTeamMembers(memberIDs, team.teamId)]
      )
    } else {
      notifyEvent(
        serviceName(),
        "onTeamMemberUpdate",
        ["teamMemberList": teamMembers(memberIDs, team.teamId)]
      )
    }
  }

  func onTeamMemberRemoved(_ team: NIMTeam, withMembers memberIDs: [String]?) {
    if team.type == .super {
      notifyEvent(
        ServiceType.SuperTeamService.rawValue,
        "onSuperTeamMemberRemove",
        ["teamMemberList": superTeamMembers(memberIDs, team.teamId)]
      )
    } else {
      notifyEvent(
        serviceName(),
        "onTeamMemberRemove",
        ["teamMemberList": teamMembers(memberIDs, team.teamId)]
      )
    }
  }

  func onTeamAdded(_ team: NIMTeam) {
    if team.type == .super {
      notifyEvent(
        ServiceType.SuperTeamService.rawValue,
        "onSuperTeamUpdate",
        ["teamList": [team.toDic() as Any]]
      )
    } else {
      notifyEvent(serviceName(), "onTeamListUpdate", ["teamList": [team.toDic() as Any]])
    }
  }

  func onTeamRemoved(_ team: NIMTeam) {
    if team.type == .super {
      notifyEvent(
        ServiceType.SuperTeamService.rawValue,
        "onSuperTeamRemove",
        ["team": team.toDic() as Any]
      )
    } else {
      notifyEvent(serviceName(), "onTeamListRemove", ["team": team.toDic() as Any])
    }
  }

  func onTeamUpdated(_ team: NIMTeam) {
    if team.type == .super {
      notifyEvent(
        ServiceType.SuperTeamService.rawValue,
        "onSuperTeamUpdate",
        ["teamList": [team.toDic() as Any]]
      )
    } else {
      notifyEvent(serviceName(), "onTeamListUpdate", ["teamList": [team.toDic() as Any]])
    }
  }
}
