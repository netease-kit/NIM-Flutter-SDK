// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK
import Foundation

extension NIMQChatCreateServerRoleParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatCreateServerRoleParam {
    guard let model = NIMQChatCreateServerRoleParam.yx_model(with: json) else {
      print("❌NIMQChatCreateServerRoleParam.yx_model(with: json) FAILED")
      return NIMQChatCreateServerRoleParam()
    }
    if let type = json["type"] as? String,
       let tp = FLTQChatRoleType(rawValue: type)?.convertNIMQChatRoleType() {
      model.type = tp
    }
    if let ext = json["extension"] as? String {
      model.ext = ext
    }
    if let antiSpamConfig = json["antiSpamConfig"] as? [String: Any],
       let antiSpamBusinessId = antiSpamConfig["antiSpamBusinessId"] as? String {
      model.antispamBusinessId = antiSpamBusinessId
    }
    return model
  }
}

extension NIMQChatDeleteServerRoleParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatDeleteServerRoleParam {
    guard let model = NIMQChatDeleteServerRoleParam.yx_model(with: json) else {
      print("❌NIMQChatDeleteServerRoleParam.yx_model(with: json) FAILED")
      return NIMQChatDeleteServerRoleParam()
    }
    return model
  }
}

extension NIMQChatUpdateServerRoleParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatUpdateServerRoleParam {
    guard let model = NIMQChatUpdateServerRoleParam.yx_model(with: json) else {
      print("❌NIMQChatUpdateServerRoleParam.yx_model(with: json) FAILED")
      return NIMQChatUpdateServerRoleParam()
    }
    if let resourceAuths = json["resourceAuths"] as? [String: String] {
      var commands = [NIMQChatPermissionStatusInfo]()
      for (key, value) in resourceAuths {
        if let tp = FLTQChatPermissionType(rawValue: key)?.convertNIMQChatPermissionType(),
           let stt = FLTQChatPermissionStatus(rawValue: value)?
           .convertNIMQChatPermissionStatus() {
          let cmd = NIMQChatPermissionStatusInfo()
          cmd.type = tp
          cmd.customType = tp.rawValue
          cmd.status = stt
          commands.append(cmd)
        }
      }
      model.commands = commands
    }
    if let antiSpamConfig = json["antiSpamConfig"] as? [String: Any],
       let antiSpamBusinessId = antiSpamConfig["antiSpamBusinessId"] as? String {
      model.antispamBusinessId = antiSpamBusinessId
    }
    return model
  }
}

extension NIMQChatupdateServerRolePrioritiesParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatupdateServerRolePrioritiesParam {
    guard let model = NIMQChatupdateServerRolePrioritiesParam.yx_model(with: json) else {
      print("❌NIMQChatupdateServerRolePrioritiesParam.yx_model(with: json) FAILED")
      return NIMQChatupdateServerRolePrioritiesParam()
    }
    if let roleIdPriorityMap = json["roleIdPriorityMap"] as? [String: Int] {
      var updateItems = [NIMQChatUpdateServerRolePriorityItem]()
      for (key, value) in roleIdPriorityMap {
        if let ser = json["serverId"] as? UInt64 {
          let updateItem = NIMQChatUpdateServerRolePriorityItem()
          updateItem.serverId = ser
          updateItem.roleId = UInt64(key) ?? 0
          updateItem.priority = NSNumber(value: value)
          updateItems.append(updateItem)
        }
      }
      model.updateItems = updateItems
    }
    return model
  }
}

extension NIMQChatGetServerRolesParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetServerRolesParam {
    guard let model = NIMQChatGetServerRolesParam.yx_model(with: json) else {
      print("❌NIMQChatGetServerRolesParam.yx_model(with: json) FAILED")
      return NIMQChatGetServerRolesParam()
    }
    return model
  }
}

extension NIMQChatAddChannelRoleParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatAddChannelRoleParam {
    guard let model = NIMQChatAddChannelRoleParam.yx_model(with: json) else {
      print("❌NIMQChatAddChannelRoleParam.yx_model(with: json) FAILED")
      return NIMQChatAddChannelRoleParam()
    }
    if let serverRoleId = json["serverRoleId"] as? UInt64 {
      model.parentRoleId = serverRoleId
    }
    return model
  }
}

extension NIMQChatRemoveChannelRoleParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatRemoveChannelRoleParam {
    guard let model = NIMQChatRemoveChannelRoleParam.yx_model(with: json) else {
      print("❌NIMQChatRemoveChannelRoleParam.yx_model(with: json) FAILED")
      return NIMQChatRemoveChannelRoleParam()
    }
    return model
  }
}

extension NIMQChatUpdateChannelRoleParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatUpdateChannelRoleParam {
    guard let model = NIMQChatUpdateChannelRoleParam.yx_model(with: json) else {
      print("❌NIMQChatUpdateChannelRoleParam.yx_model(with: json) FAILED")
      return NIMQChatUpdateChannelRoleParam()
    }
    if let resourceAuths = json["resourceAuths"] as? [String: String] {
      var commands = [NIMQChatPermissionStatusInfo]()
      for (key, value) in resourceAuths {
        if let tp = FLTQChatPermissionType(rawValue: key)?.convertNIMQChatPermissionType(),
           let stt = FLTQChatPermissionStatus(rawValue: value)?
           .convertNIMQChatPermissionStatus() {
          let cmd = NIMQChatPermissionStatusInfo()
          cmd.type = tp
          cmd.customType = tp.rawValue
          cmd.status = stt
          commands.append(cmd)
        }
      }
      model.commands = commands
    }
    return model
  }
}

extension NIMQChatGetChannelRolesParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetChannelRolesParam {
    guard let model = NIMQChatGetChannelRolesParam.yx_model(with: json) else {
      print("❌NIMQChatGetChannelRolesParam.yx_model(with: json) FAILED")
      return NIMQChatGetChannelRolesParam()
    }
    if let time = json["timeTag"] as? Double {
      model.timeTag = TimeInterval(time / 1000)
    }
    return model
  }
}

extension NIMQChatAddServerRoleMembersParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatAddServerRoleMembersParam {
    guard let model = NIMQChatAddServerRoleMembersParam.yx_model(with: json) else {
      print("❌NIMQChatAddServerRoleMembersParam.yx_model(with: json) FAILED")
      return NIMQChatAddServerRoleMembersParam()
    }
    if let accids = json["accids"] as? [String] {
      model.accountArray = accids
    }
    return model
  }
}

extension NIMQChatRemoveServerRoleMemberParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatRemoveServerRoleMemberParam {
    guard let model = NIMQChatRemoveServerRoleMemberParam.yx_model(with: json) else {
      print("❌NIMQChatRemoveServerRoleMemberParam.yx_model(with: json) FAILED")
      return NIMQChatRemoveServerRoleMemberParam()
    }
    if let accids = json["accids"] as? [String] {
      model.accountArray = accids
    }
    return model
  }
}

extension NIMQChatGetServerRoleMembersParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetServerRoleMembersParam {
    guard let model = NIMQChatGetServerRoleMembersParam.yx_model(with: json) else {
      print("❌NIMQChatGetServerRoleMembersParam.yx_model(with: json) FAILED")
      return NIMQChatGetServerRoleMembersParam()
    }
    if let time = json["timeTag"] as? Double {
      model.timeTag = TimeInterval(time / 1000)
    }
    return model
  }
}

extension NIMQChatGetServerRolesByAccidParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetServerRolesByAccidParam {
    guard let model = NIMQChatGetServerRolesByAccidParam.yx_model(with: json) else {
      print("❌NIMQChatGetServerRolesByAccidParam.yx_model(with: json) FAILED")
      return NIMQChatGetServerRolesByAccidParam()
    }
    if let time = json["timeTag"] as? Double {
      model.timeTag = TimeInterval(time / 1000)
    }
    return model
  }
}

extension NIMQChatGetExistingAccidsInServerRoleParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetExistingAccidsInServerRoleParam {
    guard let model = NIMQChatGetExistingAccidsInServerRoleParam.yx_model(with: json) else {
      print("❌NIMQChatGetExistingAccidsInServerRoleParam.yx_model(with: json) FAILED")
      return NIMQChatGetExistingAccidsInServerRoleParam()
    }
    return model
  }
}

extension NIMQChatGetExistingServerRoleMembersByAccidsParam {
  static func fromDic(_ json: [String: Any])
    -> NIMQChatGetExistingServerRoleMembersByAccidsParam {
    guard let model = NIMQChatGetExistingServerRoleMembersByAccidsParam.yx_model(with: json)
    else {
      print("❌NIMQChatGetExistingServerRoleMembersByAccidsParam.yx_model(with: json) FAILED")
      return NIMQChatGetExistingServerRoleMembersByAccidsParam()
    }
    return model
  }
}

extension NIMQChatGetExistingChannelRolesByServerRoleIdsParam {
  static func fromDic(_ json: [String: Any])
    -> NIMQChatGetExistingChannelRolesByServerRoleIdsParam {
    guard let model = NIMQChatGetExistingChannelRolesByServerRoleIdsParam.yx_model(with: json)
    else {
      print(
        "❌NIMQChatGetExistingChannelRolesByServerRoleIdsParam.yx_model(with: json) FAILED"
      )
      return NIMQChatGetExistingChannelRolesByServerRoleIdsParam()
    }
    return model
  }
}

extension NIMQChatGetExistingAccidsOfMemberRolesParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetExistingAccidsOfMemberRolesParam {
    guard let model = NIMQChatGetExistingAccidsOfMemberRolesParam.yx_model(with: json) else {
      print("❌NIMQChatGetExistingAccidsOfMemberRolesParam.yx_model(with: json) FAILED")
      return NIMQChatGetExistingAccidsOfMemberRolesParam()
    }
    return model
  }
}

// MARK: result

extension NIMQChatServerRole {
  static func fromDic(_ json: [String: Any]) -> NIMQChatServerRole {
    guard let model = NIMQChatServerRole.yx_model(with: json) else {
      print("❌NIMQChatServerRole.yx_model(with: json) FAILED")
      return NIMQChatServerRole()
    }
    if let ext = json["extension"] as? String {
      model.ext = ext
    }
    if let resourceAuths = json["resourceAuths"] as? [String: String] {
      var commands = [NIMQChatPermissionStatusInfo]()
      for (key, value) in resourceAuths {
        if let tp = FLTQChatPermissionType(rawValue: key)?.convertNIMQChatPermissionType(),
           let stt = FLTQChatPermissionStatus(rawValue: value)?
           .convertNIMQChatPermissionStatus() {
          let cmd = NIMQChatPermissionStatusInfo()
          cmd.type = tp
          cmd.customType = tp.rawValue
          cmd.status = stt
          commands.append(cmd)
        }
      }
      model.auths = commands
    }
    if let type = json["type"] as? String,
       let tp = FLTQChatRoleType(rawValue: type)?.convertNIMQChatRoleType() {
      model.type = tp
    }
    if let createTime = json["createTime"] as? Double {
      model.createTime = TimeInterval(createTime / 1000)
    }
    if let updateTime = json["updateTime"] as? Double {
      model.updateTime = TimeInterval(updateTime / 1000)
    }
    return model
  }

  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["extension"] = ext
      jsonObject["createTime"] = Int(createTime * 1000)
      jsonObject["updateTime"] = Int(createTime * 1000)
      var resourceAuths = [String: String]()
      for item in auths {
        if let key = FLTQChatPermissionType.convert(type: item.type)?.rawValue,
           let value = FLTQChatPermissionStatus.convert(type: item.status)?.rawValue {
          resourceAuths[key] = value
        }
      }
      jsonObject["resourceAuths"] = resourceAuths
      jsonObject["type"] = FLTQChatRoleType.convert(type: type)?.rawValue
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatupdateServerRolePrioritiesResult {
  func toDict() -> [String: Any]? {
    var jsonObject = [String: Any]()
    var roleIdPriorityMap = [UInt64: Int]()
    for item in serverRoleArray ?? [] {
      roleIdPriorityMap[UInt64(item.roleId)] = item.priority.intValue
    }
    jsonObject["roleIdPriorityMap"] = roleIdPriorityMap
    return jsonObject
  }
}

extension NIMQChatGetServerRolesResult {
  func toDict() -> [String: Any]? {
    var jsonObject = [String: Any]()
    jsonObject["roleList"] = serverRoleArray.map { item in
      item.toDict()
    }
    jsonObject["isMemberSet"] = isMemberSet
    return jsonObject
  }
}

extension NIMQChatChannelRole {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      var resourceAuths = [String: String]()
      for item in auths {
        if let key = FLTQChatPermissionType.convert(type: item.type)?.rawValue,
           let value = FLTQChatPermissionStatus.convert(type: item.status)?.rawValue {
          resourceAuths[key] = value
        }
      }
      jsonObject["resourceAuths"] = resourceAuths
      jsonObject["type"] = FLTQChatRoleType.convert(type: type)?.rawValue
      jsonObject["createTime"] = Int(createTime * 1000)
      jsonObject["updateTime"] = Int(updateTime * 1000)
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatGetChannelRolesResult {
  func toDict() -> [String: Any]? {
    var jsonObject = [String: Any]()
    let roleList = channelRoleArray.map { item in
      item.toDict()
    }
    jsonObject["roleList"] = roleList
    return jsonObject
  }
}

extension NIMQChatAddServerRoleMembersResult {
  func toDict() -> [String: Any]? {
    var jsonObject = [String: Any]()
    jsonObject["successAccids"] = successfulAccidArray
    jsonObject["failedAccids"] = failedAccidArray
    return jsonObject
  }
}

extension NIMQChatRemoveServerRoleMembersResult {
  func toDict() -> [String: Any]? {
    var jsonObject = [String: Any]()
    jsonObject["successAccids"] = successfulAccidArray
    jsonObject["failedAccids"] = failedAccidArray
    return jsonObject
  }
}

extension NIMQChatServerRoleMember {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["createTime"] = Int(createTime * 1000)
      jsonObject["updateTime"] = Int(updateTime * 1000)
      jsonObject["type"] = FLTQChatServerMemberType.convert(type: type)?.rawValue
      jsonObject["jointime"] = Int(jointime * 1000)
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatGetServerRoleMembersResult {
  func toDict() -> [String: Any]? {
    var jsonObject = [String: Any]()
    let roleMemberList = memberArray.map { item in
      item.toDict()
    }
    jsonObject["roleMemberList"] = roleMemberList
    return jsonObject
  }
}

extension NIMQChatGetServerRolesByAccidResult {
  func toDict() -> [String: Any]? {
    var jsonObject = [String: Any]()
    let roleList = serverRoles.map { item in
      item.toDict()
    }
    jsonObject["roleList"] = roleList
    return jsonObject
  }
}

extension NIMQChatGetExistingAccidsInServerRoleResult {
  func toDict() -> [String: Any]? {
    var jsonObject = [String: Any]()
    var resourceAuths = [String: [[String: Any]]]()
    if let dic = accidServerRolesDic {
      for (key, value) in dic {
        var valueToDict = [[String: Any]]()
        for item in value {
          if let itemToDict = item.toDict() {
            valueToDict.append(itemToDict)
          }
        }
        resourceAuths[key] = valueToDict
      }
    }
    jsonObject["accidServerRolesMap"] = resourceAuths
    return jsonObject
  }
}

extension NIMQChatGetExistingServerRoleMembersByAccidsResult {
  func toDict() -> [String: Any]? {
    var jsonObject = [String: Any]()
    jsonObject["accidList"] = accidArray
    return jsonObject
  }
}

extension NIMQChatGetExistingChannelRolesByServerRoleIdsResult {
  func toDict() -> [String: Any]? {
    var jsonObject = [String: Any]()
    if let list = channelRoleArray {
      let roleList = list.map { item in
        item.toDict()
      }
      jsonObject["roleList"] = roleList
    }
    return jsonObject
  }
}

extension NIMQChatGetExistingAccidsOfMemberRolesResult {
  func toDict() -> [String: Any]? {
    var jsonObject = [String: Any]()
    jsonObject["accidList"] = accidArray
    return jsonObject
  }
}
