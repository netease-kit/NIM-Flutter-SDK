// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum SuperTeamType: String {
  case QueryTeamList = "queryTeamList"
  case QueryTeamListById = "queryTeamListById"
  case QueryTeam = "queryTeam"
  case SearchTeam = "searchTeam"
  case ApplyJoinTeam = "applyJoinTeam"
  case PassApply = "passApply"
  case RejectApply = "rejectApply"
  case AddMembers = "addMembers"
  case AcceptInvite = "acceptInvite"
  case DeclineInvite = "declineInvite"
  case RemoveMembers = "removeMembers"
  case QuitTeam = "quitTeam"
  case QueryMemberList = "queryMemberList"
  case QueryTeamMember = "queryTeamMember"
  case QueryMemberListByPage = "queryMemberListByPage"
  case UpdateMemberNick = "updateMemberNick"
  case UpdateMyTeamNick = "updateMyTeamNick"
  case UpdateMyMemberExtension = "updateMyMemberExtension"
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
}

class FLTSuperTeamService: FLTBaseService, FLTService {
  override func onInitialized() {
    NIMSDK.shared().superTeamManager.add(self)
  }

  deinit {
    NIMSDK.shared().superTeamManager.remove(self)
  }

  func serviceName() -> String {
    ServiceType.SuperTeamService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case SuperTeamType.QueryTeamList.rawValue: queryTeamList(arguments, resultCallback)
    case SuperTeamType.QueryTeamListById.rawValue: queryTeamListById(arguments, resultCallback)
    case SuperTeamType.QueryTeam.rawValue: queryTeam(arguments, resultCallback)
    case SuperTeamType.SearchTeam.rawValue: searchTeam(arguments, resultCallback)
    case SuperTeamType.ApplyJoinTeam.rawValue: applyJoinTeam(arguments, resultCallback)
    case SuperTeamType.PassApply.rawValue: passApply(arguments, resultCallback)
    case SuperTeamType.RejectApply.rawValue: rejectApply(arguments, resultCallback)
    case SuperTeamType.AddMembers.rawValue: addMembers(arguments, resultCallback)
    case SuperTeamType.AcceptInvite.rawValue: acceptInvite(arguments, resultCallback)
    case SuperTeamType.DeclineInvite.rawValue: declineInvite(arguments, resultCallback)
    case SuperTeamType.RemoveMembers.rawValue: removeMembers(arguments, resultCallback)
    case SuperTeamType.QuitTeam.rawValue: quitTeam(arguments, resultCallback)
    case SuperTeamType.QueryMemberList.rawValue: queryMemberList(arguments, resultCallback)
    case SuperTeamType.QueryTeamMember.rawValue: queryTeamMember(arguments, resultCallback)
    case SuperTeamType.QueryMemberListByPage
      .rawValue: queryMemberListByPage(arguments, resultCallback)
    case SuperTeamType.UpdateMemberNick.rawValue: updateMemberNick(arguments, resultCallback)
    case SuperTeamType.UpdateMyTeamNick.rawValue: updateMyTeamNick(arguments, resultCallback)
    case SuperTeamType.UpdateMyMemberExtension
      .rawValue: updateMyMemberExtension(arguments, resultCallback)
    case SuperTeamType.TransferTeam.rawValue: transferTeam(arguments, resultCallback)
    case SuperTeamType.AddManagers.rawValue: addManagers(arguments, resultCallback)
    case SuperTeamType.RemoveManagers.rawValue: removeManagers(arguments, resultCallback)
    case SuperTeamType.MuteTeamMember.rawValue: muteTeamMember(arguments, resultCallback)
    case SuperTeamType.MuteAllTeamMember.rawValue: muteAllTeamMember(arguments, resultCallback)
    case SuperTeamType.QueryMutedTeamMembers
      .rawValue: queryMutedTeamMembers(arguments, resultCallback)
    case SuperTeamType.UpdateTeamFields.rawValue: updateTeamFields(arguments, resultCallback)
    case SuperTeamType.MuteTeam.rawValue: muteTeam(arguments, resultCallback)
    case SuperTeamType.SearchTeamIdByName
      .rawValue: searchTeamWithOption(arguments, resultCallback)
    case SuperTeamType.SearchTeamsByKeyword
      .rawValue: searchTeamWithOption(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  // 本地所有群组
  func queryTeamList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let teams = NIMSDK.shared().superTeamManager.allMyTeams()
    let ret = teams?.map { team in team.toDic() }
    superTeamCallback(nil, ["teamList": ret], resultCallback)
  }

  // 本地获取指定群组
  func queryTeamListById(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamIdList = arguments["teamIdList"] as? [String] {
      var ret = [[String: Any?]]()
      teamIdList.forEach { teamId in
        if let team = NIMSDK.shared().superTeamManager.team(byId: teamId),
           let dic = team.toDic() {
          ret.append(dic)
        }
      }
      superTeamCallback(nil, ["teamList": ret], resultCallback)
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 本地获取指定群组
  func queryTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String {
      let team = NIMSDK.shared().superTeamManager.team(byId: teamId)
      superTeamCallback(nil, team?.toDic(), resultCallback)
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 从云端获取指定群组
  func searchTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String {
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager.fetchTeamInfo(teamId) { error, team in
        weakSelf?.superTeamCallback(error, team?.toDic(), resultCallback)
      }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 申请加入群组
  func applyJoinTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String,
       let message = arguments["postscript"] as? String {
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager
        .apply(toTeam: teamId, message: message) { error, status in
          if error != nil {
            weakSelf?.superTeamCallback(error, nil, resultCallback)
          } else {
            // dart需要返回team对象，查一波
            NIMSDK.shared().superTeamManager.fetchTeamInfo(teamId) { error, team in
              weakSelf?.superTeamCallback(nil, team?.toDic(), resultCallback)
            }
          }
        }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 同意群申请
  func passApply(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String,
       let userId = arguments["account"] as? String {
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager
        .passApply(toTeam: teamId, userId: userId) { error, status in
          weakSelf?.superTeamCallback(error, ["status": status], resultCallback)
        }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 拒绝群申请
  func rejectApply(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String,
       let userId = arguments["account"] as? String,
       let rejectReason = arguments["reason"] as? String {
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager
        .rejectApply(toTeam: teamId, userId: userId, rejectReason: rejectReason) { error in
          weakSelf?.superTeamCallback(error, nil, resultCallback)
        }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 邀请加入群组
  func addMembers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let users = arguments["accountList"] as? [String],
       let teamId = arguments["teamId"] as? String {
      let postscript = arguments["msg"] as? String
      let attach = arguments["attach"] as? String
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager
        .addUsers(users, toTeam: teamId, postscript: postscript,
                  attach: attach) { error, members in
          let membersMaps = members?.compactMap { member in
            member.userId
          }
          weakSelf?.superTeamCallback(error, ["teamMemberList": membersMaps], resultCallback)
        }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 接受入群邀请
  func acceptInvite(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String,
       let invitorId = arguments["inviter"] as? String {
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager
        .acceptInvite(withTeam: teamId, invitorId: invitorId) { error in
          weakSelf?.superTeamCallback(error, nil, resultCallback)
        }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 拒绝入群邀请
  func declineInvite(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String,
       let invitorId = arguments["inviter"] as? String,
       let rejectReason = arguments["reason"] as? String {
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager.rejectInvite(
        withTeam: teamId,
        invitorId: invitorId,
        rejectReason: rejectReason
      ) { error in
        weakSelf?.superTeamCallback(error, nil, resultCallback)
      }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 踢人出群
  func removeMembers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let users = arguments["members"] as? [String],
       let teamId = arguments["teamId"] as? String {
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager.kickUsers(users, fromTeam: teamId) { error in
        weakSelf?.superTeamCallback(error, nil, resultCallback)
      }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 用户退群
  func quitTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String {
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager.quitTeam(teamId) { error in
        weakSelf?.superTeamCallback(error, nil, resultCallback)
      }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 获取群组成员列表
  func queryMemberList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String {
      let option = NIMTeamFetchMemberOption()
      option.fromServer = true
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager
        .fetchTeamMembers(teamId, option: option) { error, members in
          let membersMaps = members?.compactMap { member in
            member.toDic()
          }
          weakSelf?.superTeamCallback(error, ["teamMemberList": membersMaps], resultCallback)
        }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  func queryMemberListByPage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String {
      let option = NIMTeamFetchMemberOption()
      option.fromServer = true
      option.offset = arguments["offset"] as? Int ?? 0
      option.count = arguments["limit"] as? Int ?? 0
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager
        .fetchTeamMembers(teamId, option: option) { error, members in
          let membersMaps = members?.compactMap { member in
            member.toDic()
          }
          weakSelf?.superTeamCallback(error, ["teamMemberList": membersMaps], resultCallback)
        }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 获取指定群组成员
  func queryTeamMember(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String,
       let userId = arguments["account"] as? String {
      let member: NIMTeamMember? = NIMSDK.shared().superTeamManager
        .teamMember(userId, inTeam: teamId)
      superTeamCallback(nil, member?.toDic(), resultCallback)
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 修改群成员资料
  func updateMemberNick(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String,
       let userId = arguments["account"] as? String,
       let newNick = arguments["nick"] as? String {
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager
        .updateUserNick(userId, newNick: newNick, inTeam: teamId) { error in
          weakSelf?.superTeamCallback(error, nil, resultCallback)
        }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  func updateMyTeamNick(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String,
       let newNick = arguments["nick"] as? String {
      let userId = NIMSDK.shared().loginManager.currentAccount()
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager
        .updateUserNick(userId, newNick: newNick, inTeam: teamId) { error in
          weakSelf?.superTeamCallback(error, nil, resultCallback)
        }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 更新自己的群成员自定义属性
  func updateMyMemberExtension(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String,
       let newInfo = arguments["extension"] as? [String: Any?],
       let data = try? JSONSerialization.data(withJSONObject: newInfo, options: []),
       let str = String(data: data, encoding: String.Encoding.utf8) {
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager.updateMyCustomInfo(str, inTeam: teamId) { error in
        weakSelf?.superTeamCallback(error, nil, resultCallback)
      }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 判断自己是否在群里
  func isMyTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let teamId = arguments["teamId"] as! String
    let isMyTeam: Bool = NIMSDK.shared().superTeamManager.isMyTeam(teamId)
  }

  // 群主转让
  func transferTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String,
       let newOwnerId = arguments["account"] as? String {
      let isLeave = arguments["quit"] as? Bool ?? false
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager
        .transferManager(withTeam: teamId, newOwnerId: newOwnerId,
                         isLeave: isLeave) { error in
          if error != nil {
            weakSelf?.superTeamCallback(error, nil, resultCallback)
          } else {
            let option = NIMTeamFetchMemberOption()
            option.fromServer = true
            NIMSDK.shared().superTeamManager
              .fetchTeamMembers(teamId, option: option) { error, members in
                let membersMaps = members?.reversed().compactMap { member in
                  member.toDic()
                }
                weakSelf?.superTeamCallback(
                  error,
                  ["teamMemberList": membersMaps],
                  resultCallback
                )
              }
          }
        }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 增加管理员
  func addManagers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let users = arguments["accountList"] as? [String],
       let teamId = arguments["teamId"] as? String {
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager.addManagers(toTeam: teamId, users: users) { error in
        if error != nil {
          weakSelf?.superTeamCallback(error, nil, resultCallback)
        } else {
          let option = NIMTeamFetchMemberOption()
          option.fromServer = true
          NIMSDK.shared().superTeamManager
            .fetchTeamMembers(teamId, option: option) { error, members in
              let membersMaps = members?.reversed().compactMap { member in
                member.toDic()
              }
              weakSelf?.superTeamCallback(
                error,
                ["teamMemberList": membersMaps],
                resultCallback
              )
            }
        }
      }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 移除管理员
  func removeManagers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let users = arguments["accountList"] as? [String],
       let teamId = arguments["teamId"] as? String {
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager
        .removeManagers(fromTeam: teamId, users: users) { error in
          if error != nil {
            weakSelf?.superTeamCallback(error, nil, resultCallback)
          } else {
            let option = NIMTeamFetchMemberOption()
            option.fromServer = true
            NIMSDK.shared().superTeamManager
              .fetchTeamMembers(teamId, option: option) { error, members in
                let membersMaps = members?.reversed().compactMap { member in
                  member.toDic()
                }
                weakSelf?.superTeamCallback(
                  error,
                  ["teamMemberList": membersMaps],
                  resultCallback
                )
              }
          }
        }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 禁言指定成员
  func muteTeamMember(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let users = arguments["accountList"] as? [String],
       let teamId = arguments["teamId"] as? String {
      let mute = arguments["mute"] as? Bool ?? false
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager
        .updateMuteState(mute, userIds: users, inTeam: teamId) { error in
          weakSelf?.superTeamCallback(error, nil, resultCallback)
        }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 禁言群全体成员
  func muteAllTeamMember(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String {
      let mute = arguments["mute"] as? Bool ?? false
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager.updateMuteState(mute, inTeam: teamId) { error in
        weakSelf?.superTeamCallback(error, nil, resultCallback)
      }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 查询被禁言情况
  func queryMutedTeamMembers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let teamId = arguments["teamId"] as? String {
      weak var weakSelf = self
      NIMSDK.shared().superTeamManager.fetchTeamMutedMembers(teamId) { error, members in
        let membersMaps = members?.compactMap { member in
          member.toDic()
        }
        weakSelf?.superTeamCallback(error, ["teamMemberList": membersMaps], resultCallback)
      }
    } else {
      errorCallBack(resultCallback, "invalid arguments")
    }
  }

  // 修改群信息
  func updateTeamFields(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String,
          let request = arguments["request"] as? [String: Any?],
          let requestList = request["requestList"] as? [String] else {
      errorCallBack(resultCallback, "invalid arguments")
      return
    }
    weak var weakSelf = self
    var values = [NSNumber: String]()
    if requestList.contains("announcement") {
      values[NSNumber(value: NIMSuperTeamUpdateTag.anouncement.rawValue)] =
        request["announcement"] as? String ?? ""
    }
    if requestList.contains("beInviteMode"),
       let beInviteMode = request["beInviteMode"] as? Int {
      values[NSNumber(value: NIMSuperTeamUpdateTag.beInviteMode.rawValue)] =
        String(beInviteMode)
    }
    if requestList.contains("extension") {
      values[NSNumber(value: NIMSuperTeamUpdateTag.clientCustom.rawValue)] =
        request["extension"] as? String ?? ""
    }
    if requestList.contains("icon") {
      values[NSNumber(value: NIMSuperTeamUpdateTag.avatar.rawValue)] =
        request["icon"] as? String ?? ""
    }
    if requestList.contains("introduce") {
      values[NSNumber(value: NIMSuperTeamUpdateTag.intro.rawValue)] =
        request["introduce"] as? String ?? ""
    }
    if requestList.contains("name") {
      values[NSNumber(value: NIMSuperTeamUpdateTag.name.rawValue)] =
        request["name"] as? String ?? ""
    }
    if requestList.contains("verifyType"),
       let verifyType = request["verifyType"] as? Int {
      values[NSNumber(value: NIMSuperTeamUpdateTag.joinMode.rawValue)] = String(verifyType)
    }
    // ios 中没有NIMSuperTeamUpdateTag updateInfoMode,
//      使用NIMTeamUpdateTag无效果
//      if requestList.contains("teamUpdateMode"),
//         let teamUpdateMode = request["teamUpdateMode"] as? Int {
//        values[NSNumber(value: NIMTeamUpdateTag.updateInfoMode.rawValue)] =
//          String(teamUpdateMode)
//      }
    NIMSDK.shared().superTeamManager.updateTeamInfos(values, teamId: teamId) { error in
      weakSelf?.superTeamCallback(error, nil, resultCallback)
    }
  }

  // 修改群免打扰状态
  func muteTeam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String,
          let notifyState = arguments["notifyType"] as? String,
          let state = FLT_NIMTeamNotifyState(rawValue: notifyState) else {
      errorCallBack(resultCallback, "invalid arguments")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().superTeamManager
      .update(state.convertNIMNotifyState(), inTeam: teamId) { error in
        weakSelf?.superTeamCallback(error, nil, resultCallback)
      }
  }

  // 群通知状态
  func notifyStateForNewMsg(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let teamId = arguments["teamId"] as! String
    let state: NIMTeamNotifyState = NIMSDK.shared().superTeamManager
      .notifyState(forNewMsg: teamId)
  }

  // 群组检索
  // WARING: 没有专属的superTeam接口,teamManager 查询不到superTeam的信息
  func searchTeamWithOption(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let name = arguments["name"] as? String {
      let option = NIMTeamSearchOption()
      option.searchContent = name
      option.searchContentOption = .optiontName

      weak var weakSelf = self
      NIMSDK.shared().teamManager.searchTeam(with: option) { error, teams in
        let ret = teams?.map { team in team.teamId }
        weakSelf?.superTeamCallback(error, ["teamNameList": ret], resultCallback)
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
        weakSelf?.superTeamCallback(error, ["teamList": ret], resultCallback)
      }
      return
    }
    errorCallBack(resultCallback, "parameter is error")
  }

  private func superTeamCallback(_ error: Error?, _ data: Any?,
                                 _ resultCallback: ResultCallback) {
    if let ns_error = error as NSError? {
      errorCallBack(resultCallback, ns_error.description, ns_error.code)
    } else {
      successCallBack(resultCallback, data)
    }
  }
}

extension FLTSuperTeamService: NIMTeamManagerDelegate {
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
    }
  }

  func onTeamMemberRemoved(_ team: NIMTeam, withMembers memberIDs: [String]?) {
    if team.type == .super {
      notifyEvent(
        ServiceType.SuperTeamService.rawValue,
        "onSuperTeamMemberRemove",
        ["teamMemberList": superTeamMembers(memberIDs, team.teamId)]
      )
    }
  }

  func onTeamAdded(_ team: NIMTeam) {}

  func onTeamRemoved(_ team: NIMTeam) {
    if team.type == .super {
      notifyEvent(
        ServiceType.SuperTeamService.rawValue,
        "onSuperTeamRemove",
        ["team": team.toDic() as Any]
      )
    }
  }

  func onTeamUpdated(_ team: NIMTeam) {
    if team.type == .super {
      notifyEvent(
        ServiceType.SuperTeamService.rawValue,
        "onSuperTeamUpdate",
        ["teamList": [team.toDic() as Any]]
      )
    }
  }
}
