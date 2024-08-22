// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension NIMQChatCreateServerRoleParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatCreateServerRoleParam? {
    guard let model = NIMQChatCreateServerRoleParam.yx_model(with: json) else {
      print("❌NIMQChatCreateServerRoleParam.yx_model(with: json) FAILED")
      return nil
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
  static func fromDic(_ json: [String: Any]) -> NIMQChatDeleteServerRoleParam? {
    guard let model = NIMQChatDeleteServerRoleParam.yx_model(with: json) else {
      print("❌NIMQChatDeleteServerRoleParam.yx_model(with: json) FAILED")
      return nil
    }
    return model
  }
}

extension NIMQChatUpdateServerRoleParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatUpdateServerRoleParam? {
    guard let model = NIMQChatUpdateServerRoleParam.yx_model(with: json) else {
      print("❌NIMQChatUpdateServerRoleParam.yx_model(with: json) FAILED")
      return nil
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
  static func fromDic(_ json: [String: Any]) -> NIMQChatupdateServerRolePrioritiesParam? {
    guard let model = NIMQChatupdateServerRolePrioritiesParam.yx_model(with: json) else {
      print("❌NIMQChatupdateServerRolePrioritiesParam.yx_model(with: json) FAILED")
      return nil
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
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetServerRolesParam? {
    guard let model = NIMQChatGetServerRolesParam.yx_model(with: json) else {
      print("❌NIMQChatGetServerRolesParam.yx_model(with: json) FAILED")
      return nil
    }
    return model
  }
}

extension NIMQChatAddChannelRoleParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatAddChannelRoleParam? {
    guard let model = NIMQChatAddChannelRoleParam.yx_model(with: json),
          let serverRoleId = json["serverRoleId"] as? UInt64 else {
      print("❌NIMQChatAddChannelRoleParam.yx_model(with: json) FAILED")
      return nil
    }
    model.parentRoleId = serverRoleId
    return model
  }
}

extension NIMQChatRemoveChannelRoleParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatRemoveChannelRoleParam? {
    guard let model = NIMQChatRemoveChannelRoleParam.yx_model(with: json) else {
      print("❌NIMQChatRemoveChannelRoleParam.yx_model(with: json) FAILED")
      return nil
    }
    return model
  }
}

extension NIMQChatUpdateChannelRoleParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatUpdateChannelRoleParam? {
    guard let model = NIMQChatUpdateChannelRoleParam.yx_model(with: json) else {
      print("❌NIMQChatUpdateChannelRoleParam.yx_model(with: json) FAILED")
      return nil
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
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetChannelRolesParam? {
    guard let model = NIMQChatGetChannelRolesParam.yx_model(with: json) else {
      print("❌NIMQChatGetChannelRolesParam.yx_model(with: json) FAILED")
      return nil
    }
    if let time = json["timeTag"] as? Double {
      model.timeTag = TimeInterval(time / 1000)
    }
    return model
  }
}

extension NIMQChatAddServerRoleMembersParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatAddServerRoleMembersParam? {
    guard let model = NIMQChatAddServerRoleMembersParam.yx_model(with: json) else {
      print("❌NIMQChatAddServerRoleMembersParam.yx_model(with: json) FAILED")
      return nil
    }
    if let accids = json["accids"] as? [String] {
      model.accountArray = accids
    }
    return model
  }
}

extension NIMQChatRemoveServerRoleMemberParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatRemoveServerRoleMemberParam? {
    guard let model = NIMQChatRemoveServerRoleMemberParam.yx_model(with: json) else {
      print("❌NIMQChatRemoveServerRoleMemberParam.yx_model(with: json) FAILED")
      return nil
    }
    if let accids = json["accids"] as? [String] {
      model.accountArray = accids
    }
    return model
  }
}

extension NIMQChatGetServerRoleMembersParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetServerRoleMembersParam? {
    guard let model = NIMQChatGetServerRoleMembersParam.yx_model(with: json) else {
      print("❌NIMQChatGetServerRoleMembersParam.yx_model(with: json) FAILED")
      return nil
    }
    if let time = json["timeTag"] as? Double {
      model.timeTag = TimeInterval(time / 1000)
    }
    return model
  }
}

extension NIMQChatGetServerRolesByAccidParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetServerRolesByAccidParam? {
    guard let model = NIMQChatGetServerRolesByAccidParam.yx_model(with: json) else {
      print("❌NIMQChatGetServerRolesByAccidParam.yx_model(with: json) FAILED")
      return nil
    }
    if let time = json["timeTag"] as? Double {
      model.timeTag = TimeInterval(time / 1000)
    }
    return model
  }
}

extension NIMQChatGetExistingAccidsInServerRoleParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetExistingAccidsInServerRoleParam? {
    guard let model = NIMQChatGetExistingAccidsInServerRoleParam.yx_model(with: json) else {
      print("❌NIMQChatGetExistingAccidsInServerRoleParam.yx_model(with: json) FAILED")
      return nil
    }
    return model
  }
}

extension NIMQChatGetExistingServerRoleMembersByAccidsParam {
  static func fromDic(_ json: [String: Any])
    -> NIMQChatGetExistingServerRoleMembersByAccidsParam? {
    guard let model = NIMQChatGetExistingServerRoleMembersByAccidsParam.yx_model(with: json)
    else {
      print("❌NIMQChatGetExistingServerRoleMembersByAccidsParam.yx_model(with: json) FAILED")
      return nil
    }
    return model
  }
}

extension NIMQChatGetExistingChannelRolesByServerRoleIdsParam {
  static func fromDic(_ json: [String: Any])
    -> NIMQChatGetExistingChannelRolesByServerRoleIdsParam? {
    guard let model = NIMQChatGetExistingChannelRolesByServerRoleIdsParam.yx_model(with: json)
    else {
      print(
        "❌NIMQChatGetExistingChannelRolesByServerRoleIdsParam.yx_model(with: json) FAILED"
      )
      return nil
    }
    return model
  }
}

extension NIMQChatGetExistingAccidsOfMemberRolesParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetExistingAccidsOfMemberRolesParam? {
    guard let model = NIMQChatGetExistingAccidsOfMemberRolesParam.yx_model(with: json) else {
      print("❌NIMQChatGetExistingAccidsOfMemberRolesParam.yx_model(with: json) FAILED")
      return nil
    }
    return model
  }
}

// MARK: result

extension NIMQChatServerRole {
  static func fromDic(_ json: [String: Any]) -> NIMQChatServerRole? {
    guard let model = NIMQChatServerRole.yx_model(with: json) else {
      print("❌NIMQChatServerRole.yx_model(with: json) FAILED")
      return nil
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

extension NIMQChatAddMemberRoleParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatAddMemberRoleParam? {
    guard let serverId = arguments["serverId"] as? UInt64,
          let channelId = arguments["channelId"] as? UInt64,
          let accid = arguments["accid"] as? String else {
      print("addMemberRole parameter is error, serverId, channelId or accid is nil")
      return nil
    }
    let param = NIMQChatAddMemberRoleParam()
    param.serverId = serverId
    param.channelId = channelId
    param.accid = accid
    return param
  }
}

extension NIMQChatMemberRole {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["serverId"] = serverId
      jsonObject["id"] = roleId
      jsonObject["accid"] = accid
      jsonObject["channelId"] = channelId
      var resourceAuths = [String: String]()
      for item in auths {
        if let key = FLTQChatPermissionType.convert(type: item.type)?.rawValue,
           let value = FLTQChatPermissionStatus.convert(type: item.status)?.rawValue {
          resourceAuths[key] = value
        }
      }
      jsonObject["resourceAuths"] = resourceAuths
      jsonObject["createTime"] = Int(createTime * 1000)
      jsonObject["updateTime"] = Int(updateTime * 1000)
      jsonObject["nick"] = nick
      jsonObject["avatar"] = avatar
      jsonObject["custom"] = custom
      jsonObject["type"] = FLTQChatServerMemberType.convert(type: type)?.rawValue
      jsonObject["joinTime"] = Int(joinTime * 1000)
      jsonObject["inviter"] = inviter

      return jsonObject
    }
    return nil
  }
}

extension NIMQChatRemoveMemberRoleParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatRemoveMemberRoleParam? {
    guard let serverId = arguments["serverId"] as? UInt64,
          let channelId = arguments["channelId"] as? UInt64,
          let accid = arguments["accid"] as? String else {
      print("removeMemberRole parameter is error, serverId, channelId or accid is nil")
      return nil
    }
    let param = NIMQChatRemoveMemberRoleParam()
    param.serverId = serverId
    param.channelId = channelId
    param.accid = accid
    return param
  }
}

extension NIMQChatUpdateMemberRoleParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatUpdateMemberRoleParam? {
    guard let serverId = arguments["serverId"] as? UInt64,
          let channelId = arguments["channelId"] as? UInt64,
          let accid = arguments["accid"] as? String,
          let auths = arguments["resourceAuths"] as? [String: String] else {
      print(
        "updateMemberRole parameter is error, serverId, channelId, accid or resourceAuths is nil"
      )
      return nil
    }
    let param = NIMQChatUpdateMemberRoleParam()
    param.serverId = serverId
    param.channelId = channelId
    param.accid = accid

    var commands = [NIMQChatPermissionStatusInfo]()
    for (key, value) in auths {
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
    param.commands = commands
    return param
  }
}

extension NIMQChatGetMemberRolesParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatGetMemberRolesParam? {
    guard let serverId = arguments["serverId"] as? UInt64,
          let limit = arguments["limit"] as? Int,
          let timeTag = arguments["timeTag"] as? Int,
          let channelId = arguments["channelId"] as? UInt64 else {
      print("getMemberRoles parameter is error, serverId, channelId, timeTag or limit is nil")
      return nil
    }
    let param = NIMQChatGetMemberRolesParam()
    param.serverId = serverId
    param.channelId = channelId
    param.limit = limit
    param.timeTag = TimeInterval(Double(timeTag) / 1000)
    return param
  }
}

extension NIMQChatGetMemberRolesResult {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["roleList"] = memberRoleArray.map { item in
        item.toDic()
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatCheckPermissionParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatCheckPermissionParam? {
    guard let serverId = arguments["serverId"] as? UInt64,
          let permission = arguments["permission"] as? String,
          let permissionType = FLTQChatPermissionType(rawValue: permission)?
          .convertNIMQChatPermissionType() else {
      print(
        "checkPermission parameter is error, serverId is nil"
      )
      return nil
    }
    let param = NIMQChatCheckPermissionParam()
    param.serverId = serverId
    param.permissionType = permissionType

    if let channelId = arguments["channelId"] as? UInt64 {
      param.channelId = channelId
    }
    return param
  }
}

extension NIMQChatCheckPermissionsParam {
  static func fromDic(_ arguments: [String: Any]) -> NIMQChatCheckPermissionsParam? {
    guard let serverId = arguments["serverId"] as? UInt64 else {
      print("checkPermissions parameter is error, serverId is nil")
      return nil
    }
    let param = NIMQChatCheckPermissionsParam()
    param.serverId = serverId
    if let permissionArray = arguments["permissions"] as? [String] {
      var permissionTypeArray = [NSNumber]()
      for item in permissionArray {
        if let permission = FLTQChatPermissionType(rawValue: item)?
          .convertNIMQChatPermissionType().rawValue {
          permissionTypeArray.append(NSNumber(value: permission))
        }
      }
      param.permissions = permissionTypeArray
    }
    if let channelId = arguments["channelId"] as? UInt64 {
      param.channelId = channelId
    }
    return param
  }
}

extension NIMQChatCheckPermissionsResult {
  func toDic() -> [String: Any]? {
    var jsonObject = [String: Any]()
    var permissionDic = [String: String]()
    for (key, value) in permissions {
      if let type = NIMQChatPermissionType(rawValue: key.intValue),
         let status = NIMQChatPermissionStatus(rawValue: value.intValue),
         let permissionKey = FLTQChatPermissionType.convert(type: type)?.rawValue,
         let permissionValue = FLTQChatPermissionStatus.convert(type: status)?.rawValue {
        permissionDic[permissionKey] = permissionValue
      }
      jsonObject["permissions"] = permissionDic
    }
    return jsonObject
  }
}
