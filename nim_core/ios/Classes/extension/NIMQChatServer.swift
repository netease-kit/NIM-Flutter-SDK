// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension NIMQChatAcceptServerApplyParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatAcceptServerApplyParam? {
    guard let serverId = arguments["serverId"] as? UInt64,
          let requestId = arguments["requestId"] as? UInt64,
          let accid = arguments["accid"] as? String else {
      print("acceptServerApply parameter is error, serverId, accid or requestId is nil")
      return nil
    }
    let param = NIMQChatAcceptServerApplyParam()
    param.serverId = serverId
    param.accid = accid
    param.requestId = requestId
    return param
  }
}

extension NIMQChatAcceptServerInviteParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatAcceptServerInviteParam? {
    guard let serverId = arguments["serverId"] as? UInt64,
          let accid = arguments["accid"] as? String,
          let requestId = arguments["requestId"] as? UInt64 else {
      print("acceptServerInvite parameter is error, serverId, accid or requestId is nil")
      return nil
    }

    let param = NIMQChatAcceptServerInviteParam()
    param.serverId = serverId
    param.requestId = requestId
    param.accid = accid
    return param
  }
}

extension NIMQChatApplyServerJoinParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatApplyServerJoinParam? {
    guard let serverId = arguments["serverId"] as? UInt64 else {
      print("applyServerJoin parameter is error, serverId is nil")
      return nil
    }
    let param = NIMQChatApplyServerJoinParam()
    param.serverId = serverId
    param.postscript = arguments["postscript"] as? String ?? ""
    if let ttl = arguments["ttl"] as? Int {
      param.ttl = NSNumber(value: ttl)
    }
    return param
  }
}

extension NIMQChatApplyServerJoinResult {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["applyServerMemberInfo"] = ["requestId": requestId,
                                             "expireTime": Int(ttl * 1000)]
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatCreateServerParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatCreateServerParam? {
    guard let name = arguments["name"] as? String else {
      print("createServer parameter is error, name is nil")
      return nil
    }
    let param = NIMQChatCreateServerParam()
    param.name = name
    param.icon = arguments["icon"] as? String
    param.custom = arguments["custom"] as? String
    if let inviteMode = arguments["inviteMode"] as? String {
      if let mode = FLTQChatServerInviteMode(rawValue: inviteMode)?
        .convertToQChatServerInviteMode() {
        param.inviteMode = mode
      } else {
        param.inviteMode = NIMQChatServerInviteMode.autoEnter
      }
    }
    if let applyMode = arguments["applyJoinMode"] as? String {
      if let mode = FLTQChatServerApplyMode(rawValue: applyMode)?
        .convertToQChatServerApplyMode() {
        param.applyMode = mode
      } else {
        param.applyMode = NIMQChatServerApplyMode.autoEnter
      }
    }
    if let searchType = arguments["searchType"] as? Int {
      param.searchType = NSNumber(value: searchType)
    }
    param.searchEnable = arguments["searchEnable"] as? Bool ?? true

    if let antiSpamConfig = arguments["antiSpamConfig"] as? [String: Any],
       let antiSpamBusinessId = antiSpamConfig["antiSpamBusinessId"] as? String {
      param.antispamBusinessId = antiSpamBusinessId
    }
    return param
  }
}

extension NIMQChatCreateServerResult {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["server"] = server?.toDic()
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatServer {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["serverId"] = serverId
      jsonObject["name"] = name
      jsonObject["icon"] = icon
      jsonObject["custom"] = custom
      jsonObject["owner"] = owner
      jsonObject["memberNumber"] = memberNumber
      jsonObject["inviteMode"] = FLTQChatServerInviteMode.convert(type: inviteMode)?.rawValue
      jsonObject["applyMode"] = FLTQChatServerApplyMode.convert(type: applyMode)?.rawValue
      jsonObject["valid"] = validFlag
      jsonObject["createTime"] = Int(createTime * 1000)
      jsonObject["updateTime"] = Int(updateTime * 1000)
      jsonObject["channelNum"] = channelNumber
      jsonObject["channelCategoryNum"] = catogeryNumber
      jsonObject["searchType"] = searchType?.intValue
      jsonObject["searchEnable"] = searchEnable
      jsonObject["reorderWeight"] = reorderWeight
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatDeleteServerParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatDeleteServerParam? {
    guard let serverId = arguments["serverId"] as? UInt64 else {
      print("deleteServere parameter is error, serverId is nil")
      return nil
    }
    let param = NIMQChatDeleteServerParam()
    param.serverId = serverId
    return param
  }
}

extension NIMQChatGetServerMembersParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatGetServerMembersParam? {
    guard let dataList = arguments["serverIdAccidPairList"] as? [[String: Any]] else {
      print("getServerMembers parameter is error, serverIdAccidPairList is nil")
      return nil
    }
    var resultList = [NIMQChatGetServerMemberItem]()
    for item in dataList {
      let resultItem = NIMQChatGetServerMemberItem.fromDic(item)
      if resultItem == nil {
        continue
      }
      resultList.append(resultItem!)
    }
    let param = NIMQChatGetServerMembersParam()
    param.serverAccids = resultList
    return param
  }
}

extension NIMQChatGetServerMemberItem {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatGetServerMemberItem? {
    guard let serverId = arguments["first"] as? UInt64,
          let accid = arguments["second"] as? String else {
      print("getServerMembers parameter is error, serverId or accid is nil")
      return nil
    }
    let param = NIMQChatGetServerMemberItem()
    param.serverId = serverId
    param.accid = accid
    return param
  }
}

extension NIMQChatGetServerMembersResult {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["serverMembers"] = memberArray?.map { item in
        item.toDic()
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatServerMember {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["serverId"] = serverId
      jsonObject["accid"] = accid
      jsonObject["nick"] = nick
      jsonObject["avatar"] = avatar
      jsonObject["custom"] = custom
      jsonObject["type"] = FLTQChatServerMemberType.convert(type: type)?.rawValue
      jsonObject["joinTime"] = Int(joinTime * 1000)
      jsonObject["createTime"] = Int(createTime * 1000)
      jsonObject["updateTime"] = Int(updateTime * 1000)
      jsonObject["valid"] = validFlag
      jsonObject["inviter"] = inviter
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatGetServersParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatGetServersParam? {
    guard let serverIds = arguments["serverIds"] as? [UInt64] else {
      print("getServers parameter is error, serverIds is nil")
      return nil
    }

    let param = NIMQChatGetServersParam()
    param.serverIds = serverIds
    return param
  }
}

extension NIMQChatGetServersResult {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["servers"] = servers?.map { server in
        server.toDic()
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatGetServerMembersByPageParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatGetServerMembersByPageParam? {
    guard let serverId = arguments["serverId"] as? UInt64,
          let limit = arguments["limit"] as? Int,
          let timeTag = arguments["timeTag"] as? Int else {
      print("getServerMembersByPage parameter is error, serverId, limit or timeTag is nil")
      return nil
    }
    let param = NIMQChatGetServerMembersByPageParam()
    param.serverId = serverId
    param.limit = limit
    param.timeTag = TimeInterval(Double(timeTag) / 1000)
    return param
  }
}

extension NIMQChatGetServerMemberListByPageResult {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["hasMore"] = hasMore
      jsonObject["nextTimeTag"] = Int(nextTimetag * 1000)
      jsonObject["serverMembers"] = memberArray?.map { member in
        member.toDic()
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatGetServersByPageParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatGetServersByPageParam? {
    guard let limit = arguments["limit"] as? Int,
          let timeTag = arguments["timeTag"] as? Int else {
      print("getServersByPage parameter is error, limit or timeTag is nil")
      return nil
    }
    let param = NIMQChatGetServersByPageParam()
    param.timeTag = TimeInterval(Double(timeTag) / 1000)
    param.limit = limit
    return param
  }
}

extension NIMQChatGetServersByPageResult {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["hasMore"] = hasMore
      jsonObject["nextTimeTag"] = Int(nextTimetag * 1000)
      jsonObject["servers"] = servers?.map { server in
        server.toDic()
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatInviteServerMembersParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatInviteServerMembersParam? {
    guard let accids = arguments["accids"] as? [String],
          let serverId = arguments["serverId"] as? UInt64 else {
      print("inviteServerMembers parameter is error, serverId or accids is nil")
      return nil
    }
    let param = NIMQChatInviteServerMembersParam()
    param.serverId = serverId
    param.accids = accids
    param.postscript = arguments["postscript"] as? String ?? ""
    if let ttl = arguments["ttl"] as? Int {
      param.ttl = NSNumber(value: ttl)
    }
    return param
  }
}

extension NIMQChatInviteServerMembersResult {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["failedAccids"] = ultralimitFailedArray
      jsonObject["bannedAccids"] = banedFailedArray
      if let objRequestId = Int(requestId) {
        jsonObject["inviteServerMemberInfo"] = ["requestId": objRequestId,
                                                "expireTime": Int(expireTime * 1000)]
      }

      return jsonObject
    }
    return nil
  }
}

extension NIMQChatKickServerMembersParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatKickServerMembersParam? {
    guard let accids = arguments["accids"] as? [String],
          let serverId = arguments["serverId"] as? UInt64 else {
      print("kickServerMembers parameter is error, serverId or accids is nil")
      return nil
    }
    let param = NIMQChatKickServerMembersParam()
    param.serverId = serverId
    param.accids = accids
    return param
  }
}

extension NIMQChatLeaveServerParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatLeaveServerParam? {
    guard let serverId = arguments["serverId"] as? UInt64 else {
      print("leaveServer parameter is error, serverId is nil")
      return nil
    }
    let param = NIMQChatLeaveServerParam()
    param.serverId = serverId
    return param
  }
}

extension NIMQChatRejectServerApplyParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatRejectServerApplyParam? {
    guard let serverId = arguments["serverId"] as? UInt64,
          let requestId = arguments["requestId"] as? UInt64,
          let accid = arguments["accid"] as? String else {
      print("rejectServerApply parameter is error, serverId, accid or requestId is nil")
      return nil
    }
    let param = NIMQChatRejectServerApplyParam()
    param.serverId = serverId
    param.accid = accid
    param.requestId = requestId
    param.postscript = arguments["postscript"] as? String ?? ""
    return param
  }
}

extension NIMQChatRejectServerInviteParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatRejectServerInviteParam? {
    guard let serverId = arguments["serverId"] as? UInt64,
          let requestId = arguments["requestId"] as? UInt64,
          let accid = arguments["accid"] as? String else {
      print("rejectServerInvite parameter is error, serverId, accid or requestId is nil")
      return nil
    }
    let param = NIMQChatRejectServerInviteParam()
    param.serverId = serverId
    param.accid = accid
    param.requestId = requestId
    param.postscript = arguments["postscript"] as? String ?? ""
    return param
  }
}

extension NIMQChatUpdateServerParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatUpdateServerParam? {
    guard let serverId = arguments["serverId"] as? UInt64 else {
      print("updateServer parameter is error, serverId is nil")
      return nil
    }
    let param = NIMQChatUpdateServerParam()
    param.serverId = serverId
    if let name = arguments["name"] as? String {
      param.name = name
    }
    if let icon = arguments["icon"] as? String {
      param.icon = icon
    }
    if let custom = arguments["custom"] as? String {
      param.custom = custom
    }
    if let inviteMode = arguments["inviteMode"] as? String {
      if let mode = FLTQChatServerInviteMode(rawValue: inviteMode)?
        .convertToQChatServerInviteMode() {
        param.inviteMode = NSNumber(value: mode.rawValue)
      }
    }
    if let applyMode = arguments["applyMode"] as? String {
      if let mode = FLTQChatServerApplyMode(rawValue: applyMode)?
        .convertToQChatServerApplyMode() {
        param.applyMode = NSNumber(value: mode.rawValue)
      }
    }
    if let searchType = arguments["searchType"] as? Int {
      param.searchType = NSNumber(value: searchType)
    }
    if let searchEnable = arguments["searchEnable"] as? Bool {
      param.searchEnable = NSNumber(value: searchEnable)
    }
    if let antiSpamConfig = arguments["antiSpamConfig"] as? [String: Any],
       let antiSpamBusinessId = antiSpamConfig["antiSpamBusinessId"] as? String {
      param.antispamBusinessId = antiSpamBusinessId
    }
    return param
  }
}

extension NIMQChatUpdateServerResult {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["server"] = server?.toDic()
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatUpdateMyMemberInfoParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatUpdateMyMemberInfoParam? {
    guard let serverId = arguments["serverId"] as? UInt64 else {
      print("updateMyMemberInfo parameter is error, serverId is nil")
      return nil
    }
    let param = NIMQChatUpdateMyMemberInfoParam()
    param.serverId = serverId
    if let nick = arguments["nick"] as? String {
      param.nick = nick
    }
    if let avatar = arguments["avatar"] as? String {
      param.avatar = avatar
    }
    if let custom = arguments["custom"] as? String {
      param.custom = custom
    }
    if let antiSpamConfig = arguments["antiSpamConfig"] as? [String: Any],
       let antiSpamBusinessId = antiSpamConfig["antiSpamBusinessId"] as? String {
      param.antispamBusinessId = antiSpamBusinessId
    }
    return param
  }
}

extension NIMQChatSubscribeServerParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatSubscribeServerParam? {
    guard let serverIds = arguments["serverIds"] as? [UInt64] else {
      print("subscribeServer parameter is error, serverIds is nil")
      return nil
    }
    let param = NIMQChatSubscribeServerParam()
    param.targets = serverIds.map { item
      in
      NSNumber(value: item)
    }
    if let subType = arguments["type"] as? String {
      if let type = FLTQChatSubscribeType(rawValue: subType)?.convertNIMQChatSubscribeType() {
        param.subscribeType = type
      }
    }
    if let operateType = arguments["operateType"] as? String {
      if let type = FLTQChatSubscribeOperationType(rawValue: operateType)?
        .convertNIMQChatSubscribeOperationType() {
        param.operationType = type
      }
    }
    return param
  }
}

extension NIMQChatSubsribeServerResult {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["failedList"] = failedServerIds.map { item in
        item.intValue
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatSearchServerByPageParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatSearchServerByPageParam? {
    guard let keyword = arguments["keyword"] as? String else {
      print("searchServerByPage parameter is error, serverIds is nil")
      return nil
    }
    guard let searchTypeStr = arguments["searchType"] as? String,
          let searchType = FLTQChatSearchServerType(rawValue: searchTypeStr)?
          .convertToQChatSearchServerType() else {
      print("searchServerByPage parameter is error, searchType is error")
      return nil
    }
    let param = NIMQChatSearchServerByPageParam()
    param.keyword = keyword
    param.searchType = searchType

    param.asc = arguments["asc"] as? Bool ?? false

    if let startTime = arguments["startTime"] as? Int {
      param.startTime = NSNumber(value: startTime / 1000)
    }
    if let endTime = arguments["endTime"] as? Int {
      param.endTime = NSNumber(value: endTime / 1000)
    }
    if let limit = arguments["limit"] as? Int {
      param.limit = NSNumber(value: limit)
    }
    if let serverTypes = arguments["serverTypes"] as? [Int?] {
      var serverTypeArray = [NSNumber]()
      for serverType in serverTypes {
        if serverType == nil {
          continue
        }
        serverTypeArray.append(NSNumber(value: serverType!))
      }
      param.serverTypes = serverTypeArray
    }
    if let sortTypeStr = arguments["sort"] as? String,
       let sortType = FLTQChatSearchServerSortType(rawValue: sortTypeStr)?
       .convertToQChatSearchServerSortType() {
      param.sortType = sortType
    }
    if let cursor = arguments["cursor"] as? String {
      param.cursor = cursor
    }
    return param
  }
}

extension NIMQChatSearchServerByPageResult {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["hasMore"] = hasMore
      jsonObject["nextTimeTag"] = Int(nextTimetag * 1000)
      jsonObject["cursor"] = cursor
      jsonObject["servers"] = servers?.map { server in
        server.toDic()
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatGenerateInviteCodeParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatGenerateInviteCodeParam? {
    guard let serverId = arguments["serverId"] as? UInt64 else {
      print("generateInviteCode parameter is error, serverId is nil")
      return nil
    }
    let param = NIMQChatGenerateInviteCodeParam()
    param.serverId = serverId
    if let ttl = arguments["ttl"] as? Int {
      param.ttl = NSNumber(value: ttl / 1000)
    }
    return param
  }
}

extension NIMQChatGenerateInviteCodeResult {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["serverId"] = serverId
      jsonObject["requestId"] = requestId
      jsonObject["inviteCode"] = inviteCode
      jsonObject["expireTime"] = Int(expireTime * 1000)
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatJoinByInviteCodeParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatJoinByInviteCodeParam? {
    let param = NIMQChatJoinByInviteCodeParam()
    if let serverId = arguments["serverId"] as? UInt64 {
      param.serverId = serverId
    } else {
      param.serverId = 0
    }

    if let inviteCode = arguments["inviteCode"] as? String {
      param.inviteCode = inviteCode
    }
    if let postscript = arguments["postscript"] as? String {
      param.postscript = postscript
    }
    return param
  }
}
