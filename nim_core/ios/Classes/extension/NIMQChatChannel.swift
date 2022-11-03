// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension NIMQChatChannel {
  static func fromDic(_ json: [String: Any]) -> NIMQChatChannel {
    guard let model = NIMQChatChannel.yx_model(with: json) else {
      print("❌NIMQChatChannel.yx_model(with: json) FAILED")
      return NIMQChatChannel()
    }
    if let type = json["type"] as? String,
       let tp = FLTQChatChannelType(rawValue: type)?.convertNIMQChatChannelType() {
      model.type = tp
    }
    if let valid = json["valid"] as? Bool {
      model.validflag = valid
    }
    if let createTime = json["createTime"] as? Double {
      model.createTime = TimeInterval(createTime / 1000)
    }
    if let updateTime = json["updateTime"] as? Double {
      model.updateTime = TimeInterval(updateTime / 1000)
    }
    if let viewMode = json["viewMode"] as? String {
      model.viewMode = (viewMode == "public") ? .public : .private
    }
    if let syncMode = json["syncMode"] as? String,
       let ope = FLTQChatChannelSyncMode(rawValue: syncMode)?.convertNIMQChatChannelSyncMode() {
      model.syncMode = ope
    }
    model.appId = 0
    return model
  }

  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["valid"] = validflag
      jsonObject["createTime"] = Int(createTime * 1000)
      jsonObject["updateTime"] = Int(createTime * 1000)
      jsonObject["viewMode"] = (viewMode == .public) ? "public" : "private"
      jsonObject["type"] = FLTQChatChannelType.convert(type: type)?.rawValue
      jsonObject["syncMode"] = FLTQChatChannelSyncMode.convert(type: syncMode)?.rawValue
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatUpdateChannelBlackWhiteRoleInfo {
  static func fromDic(_ json: [String: Any]) -> NIMQChatUpdateChannelBlackWhiteRoleInfo {
    guard let model = NIMQChatUpdateChannelBlackWhiteRoleInfo.yx_model(with: json) else {
      print("❌NIMQChatUpdateChannelBlackWhiteRoleInfo.yx_model(with: json) FAILED")
      return NIMQChatUpdateChannelBlackWhiteRoleInfo()
    }
    if let type = json["channelBlackWhiteType"] as? String,
       let tp = FLTQChatChannelMemberRoleType(rawValue: type)?
       .convertNIMQChatChannelMemberRoleType() {
      model.type = tp
    }
    if let syncMode = json["channelBlackWhiteOperateType"] as? String,
       let ope = FLTQChatChannelMemberRoleOpeType(rawValue: syncMode)?
       .convertNIMQChatChannelMemberRoleOpeType() {
      model.opeType = ope
    }
    if let roleId = json["channelBlackWhiteRoleId"] as? UInt64 {
      model.roleId = roleId
    }
    return model
  }

  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["channelBlackWhiteType"] = FLTQChatChannelMemberRoleType.convert(type: type)?
        .rawValue
      jsonObject["creatchannelBlackWhiteOperateTypeeTime"] = FLTQChatChannelMemberRoleOpeType
        .convert(type: opeType)?.rawValue
      jsonObject["channelBlackWhiteRoleId"] = roleId
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatUpdateChannelBlackWhiteMembersInfo {
  static func fromDic(_ json: [String: Any]) -> NIMQChatUpdateChannelBlackWhiteMembersInfo {
    guard let model = NIMQChatUpdateChannelBlackWhiteMembersInfo.yx_model(with: json) else {
      print("❌NIMQChatUpdateChannelBlackWhiteMembersInfo.yx_model(with: json) FAILED")
      return NIMQChatUpdateChannelBlackWhiteMembersInfo()
    }
    if let type = json["channelBlackWhiteType"] as? String,
       let tp = FLTQChatChannelMemberRoleType(rawValue: type)?
       .convertNIMQChatChannelMemberRoleType() {
      model.type = tp
    }
    if let syncMode = json["channelBlackWhiteOperateType"] as? String,
       let ope = FLTQChatChannelMemberRoleOpeType(rawValue: syncMode)?
       .convertNIMQChatChannelMemberRoleOpeType() {
      model.opeType = ope
    }
    if let accids = json["channelBlackWhiteToAccids"] as? [String] {
      model.accids = accids
    }
    return model
  }

  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["channelBlackWhiteType"] = FLTQChatChannelMemberRoleType.convert(type: type)?
        .rawValue
      jsonObject["creatchannelBlackWhiteOperateTypeeTime"] = FLTQChatChannelMemberRoleOpeType
        .convert(type: opeType)?.rawValue
      jsonObject["channelBlackWhiteToAccids"] = accids
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatChannelCategory {
  static func fromDic(_ json: [String: Any]) -> NIMQChatChannelCategory {
    guard let model = NIMQChatChannelCategory.yx_model(with: json) else {
      print("❌NIMQChatChannelCategory.yx_model(with: json) FAILED")
      return NIMQChatChannelCategory()
    }
    model.appId = 0
    if let createTime = json["createTime"] as? Double {
      model.createTime = TimeInterval(createTime / 1000)
    }
    if let updateTime = json["updateTime"] as? Double {
      model.updateTime = TimeInterval(updateTime / 1000)
    }
    if let valid = json["valid"] as? Bool {
      model.validflag = valid
    }
    if let viewMode = json["viewMode"] as? String {
      model.viewMode = (viewMode == "public") ? .public : .private
    }
    return model
  }

  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["viewMode"] = (viewMode == .public) ? "public" : "private"
      jsonObject["valid"] = validflag
      jsonObject["createTime"] = Int(createTime * 1000)
      jsonObject["updateTime"] = Int(updateTime * 1000)
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatUpdateChannelCategoryBlackWhiteRoleInfo {
  static func fromDic(_ json: [String: Any]) -> NIMQChatUpdateChannelCategoryBlackWhiteRoleInfo {
    guard let model = NIMQChatUpdateChannelCategoryBlackWhiteRoleInfo.yx_model(with: json) else {
      print("❌NIMQChatUpdateChannelCategoryBlackWhiteRoleInfo.yx_model(with: json) FAILED")
      return NIMQChatUpdateChannelCategoryBlackWhiteRoleInfo()
    }
    if let type = json["channelBlackWhiteType"] as? String,
       let tp = FLTQChatChannelMemberRoleType(rawValue: type)?
       .convertNIMQChatChannelMemberRoleType() {
      model.type = tp
    }
    if let syncMode = json["channelBlackWhiteOperateType"] as? String,
       let ope = FLTQChatChannelMemberRoleOpeType(rawValue: syncMode)?
       .convertNIMQChatChannelMemberRoleOpeType() {
      model.opeType = ope
    }
    if let roleId = json["roleId"] as? UInt64 {
      model.roleId = roleId
    }
    return model
  }

  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["channelBlackWhiteType"] = FLTQChatChannelMemberRoleType.convert(type: type)?
        .rawValue
      jsonObject["creatchannelBlackWhiteOperateTypeeTime"] = FLTQChatChannelMemberRoleOpeType
        .convert(type: opeType)?.rawValue
      jsonObject["roleId"] = roleId
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatUpdateChannelCategoryBlackWhiteMemberInfo {
  static func fromDic(_ json: [String: Any]) -> NIMQChatUpdateChannelCategoryBlackWhiteMemberInfo {
    guard let model = NIMQChatUpdateChannelCategoryBlackWhiteMemberInfo.yx_model(with: json) else {
      print("❌NIMQChatUpdateChannelCategoryBlackWhiteMemberInfo.yx_model(with: json) FAILED")
      return NIMQChatUpdateChannelCategoryBlackWhiteMemberInfo()
    }
    if let type = json["channelBlackWhiteType"] as? String,
       let tp = FLTQChatChannelMemberRoleType(rawValue: type)?
       .convertNIMQChatChannelMemberRoleType() {
      model.type = tp
    }
    if let syncMode = json["channelBlackWhiteOperateType"] as? String,
       let ope = FLTQChatChannelMemberRoleOpeType(rawValue: syncMode)?
       .convertNIMQChatChannelMemberRoleOpeType() {
      model.opeType = ope
    }
    if let accids = json["toAccids"] as? [String] {
      model.accids = accids
    }
    return model
  }

  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["channelBlackWhiteType"] = FLTQChatChannelMemberRoleType.convert(type: type)?
        .rawValue
      jsonObject["creatchannelBlackWhiteOperateTypeeTime"] = FLTQChatChannelMemberRoleOpeType
        .convert(type: opeType)?.rawValue
      jsonObject["toAccids"] = accids
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatCreateChannelParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatCreateChannelParam {
    guard let model = NIMQChatCreateChannelParam.yx_model(with: json) else {
      print("❌NIMQChatCreateChannelParam.yx_model(with: json) FAILED")
      return NIMQChatCreateChannelParam()
    }
    if let serverId = json["serverId"] as? UInt64 {
      model.serverId = serverId
    }
    if let name = json["name"] as? String {
      model.name = name
    }
    if let topic = json["topic"] as? String {
      model.topic = topic
    }
    if let custom = json["custom"] as? String {
      model.custom = custom
    }
    if let channelType = json["type"] as? String,
       let type = FLTQChatChannelType(rawValue: channelType)?.convertNIMQChatChannelType() {
      model.type = type
    }
    if let viewMode = json["viewMode"] as? String {
      model.viewMode = (viewMode == "public") ? .public : .private
    }
    if let antiSpamConfig = json["antiSpamConfig"] as? [String: Any],
       let antiSpamBusinessId = antiSpamConfig["antiSpamBusinessId"] as? String {
      model.antispamBusinessId = antiSpamBusinessId
    }
    if let categoryId = json["categoryId"] as? UInt64 {
      model.categoryId = categoryId
    } else {
      model.categoryId = 0
    }
    if let syncMode = json["syncMode"] as? String,
       let mode = FLTQChatChannelSyncMode(rawValue: syncMode)?.convertNIMQChatChannelSyncMode() {
      model.syncMode = mode
    } else {
      model.syncMode = .none
    }
    return model
  }
}

extension NIMQChatDeleteChannelParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatDeleteChannelParam {
    guard let model = NIMQChatDeleteChannelParam.yx_model(with: json) else {
      print("❌NIMQChatDeleteChannelParam.yx_model(with: json) FAILED")
      return NIMQChatDeleteChannelParam()
    }
    if let channelId = json["channelId"] as? UInt64 {
      model.channelId = channelId
    }
    return model
  }
}

extension NIMQChatUpdateChannelParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatUpdateChannelParam {
    guard let model = NIMQChatUpdateChannelParam.yx_model(with: json) else {
      print("❌NIMQChatUpdateChannelParam.yx_model(with: json) FAILED")
      return NIMQChatUpdateChannelParam()
    }
    if let channelId = json["channelId"] as? UInt64 {
      model.channelId = channelId
    }
    if let name = json["name"] as? String {
      model.name = name
    }
    if let topic = json["topic"] as? String {
      model.topic = topic
    }
    if let custom = json["custom"] as? String {
      model.custom = custom
    }
    if let viewMode = json["viewMode"] as? String {
      model.viewMode = (viewMode == "public") ? .public : .private
    }
    if let antiSpamConfig = json["antiSpamConfig"] as? [String: Any],
       let antiSpamBusinessId = antiSpamConfig["antiSpamBusinessId"] as? String {
      model.antispamBusinessId = antiSpamBusinessId
    }
    return model
  }
}

extension NIMQChatGetChannelsParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetChannelsParam {
    guard let model = NIMQChatGetChannelsParam.yx_model(with: json) else {
      print("❌NIMQChatGetChannelsParam.yx_model(with: json) FAILED")
      return NIMQChatGetChannelsParam()
    }
    if let channelIdArray = json["channelIds"] as? [Int] {
      model.channelIdArray = channelIdArray
    }
    return model
  }
}

extension NIMQChatGetChannelsByPageParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetChannelsByPageParam {
    guard let model = NIMQChatGetChannelsByPageParam.yx_model(with: json) else {
      print("❌NIMQChatGetChannelsByPageParam.yx_model(with: json) FAILED")
      return NIMQChatGetChannelsByPageParam()
    }
    if let serverId = json["serverId"] as? UInt64 {
      model.serverId = serverId
    }
    if let timeTag = json["timeTag"] as? Double {
      model.timeTag = TimeInterval(timeTag / 1000)
    }
    if let limit = json["limit"] as? Int {
      model.limit = limit
    }
    return model
  }
}

extension NIMQChatGetChannelMembersByPageParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetChannelMembersByPageParam {
    guard let model = NIMQChatGetChannelMembersByPageParam.yx_model(with: json) else {
      print("❌NIMQChatGetChannelMembersByPageParam.yx_model(with: json) FAILED")
      return NIMQChatGetChannelMembersByPageParam()
    }
    if let serverId = json["serverId"] as? UInt64 {
      model.serverId = serverId
    }
    if let channelId = json["channelId"] as? UInt64 {
      model.channelId = channelId
    }
    if let timeTag = json["timeTag"] as? Double {
      model.timeTag = TimeInterval(timeTag / 1000)
    }
    if let limit = json["limit"] as? Int {
      model.limit = limit
    }
    return model
  }
}

extension NIMQChatChannelIdInfo {
  static func fromDic(_ json: [String: Any]) -> NIMQChatChannelIdInfo {
    guard let model = NIMQChatChannelIdInfo.yx_model(with: json) else {
      print("❌NIMQChatChannelIdInfo.yx_model(with: json) FAILED")
      return NIMQChatChannelIdInfo()
    }
    if let channelId = json["channelId"] as? UInt64 {
      model.channelId = channelId
    }
    if let serverId = json["serverId"] as? UInt64 {
      model.serverId = serverId
    }
    return model
  }

  func toDict() -> [String: Any]? {
    if let jsonObject = yx_modelToJSONObject() as? [String: Any] {
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatGetChannelUnreadInfosParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetChannelUnreadInfosParam {
    guard let model = NIMQChatGetChannelUnreadInfosParam.yx_model(with: json) else {
      print("❌NIMQChatGetChannelUnreadInfosParam.yx_model(with: json) FAILED")
      return NIMQChatGetChannelUnreadInfosParam()
    }
    if let channelIdInfos = json["channelIdInfos"] as? [[String: Any]] {
      let res = channelIdInfos.map { item in
        NIMQChatChannelIdInfo.fromDic(item)
      }
      model.targets = res
    }
    return model
  }
}

extension NIMQChatSubscribeChannelParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatSubscribeChannelParam {
    guard let model = NIMQChatSubscribeChannelParam.yx_model(with: json) else {
      print("❌NIMQChatSubscribeChannelParam.yx_model(with: json) FAILED")
      return NIMQChatSubscribeChannelParam()
    }
    if let type = json["type"] as? String,
       let subscribeType = FLTQChatSubscribeType(rawValue: type)?.convertNIMQChatSubscribeType() {
      model.subscribeType = subscribeType
    }
    if let operateType = json["operateType"] as? String,
       let operationType = FLTQChatSubscribeOperationType(rawValue: operateType)?
       .convertNIMQChatSubscribeOperationType() {
      model.operationType = operationType
    }
    if let targets = json["channelIdInfos"] as? [[String: Any]] {
      let res = targets.map { item in
        NIMQChatChannelIdInfo.fromDic(item)
      }
      model.targets = res
    }
    return model
  }
}

extension NIMQChatSearchChannelByPageParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatSearchChannelByPageParam {
    guard let model = NIMQChatSearchChannelByPageParam.yx_model(with: json) else {
      print("❌NIMQChatSearchChannelByPageParam.yx_model(with: json) FAILED")
      return NIMQChatSearchChannelByPageParam()
    }
//      let model = NIMQChatSearchChannelByPageParam()
    if let keyword = json["keyword"] as? String {
      model.keyword = keyword
    }
    if let asc = json["asc"] as? Bool {
      model.asc = asc
    }
    if let startTime = json["startTime"] as? Double {
      model.startTime = NSNumber(floatLiteral: startTime / 1000.0)
    }
    if let endTime = json["endTime"] as? Double {
      model.endTime = NSNumber(floatLiteral: endTime / 1000.0)
    }
    if let limit = json["limit"] as? NSNumber {
      model.limit = limit
    }
    if let serverId = json["serverId"] as? UInt64 {
      model.serverId = serverId
    }
    if let sort = json["sort"] as? String,
       let sortType = FLTQChatSearchChannelSortType(rawValue: sort)?
       .convertNIMQChatSearchChannelSortType() {
      model.sortType = sortType
    }
    if let cursor = json["cursor"] as? String {
      model.cursor = cursor
    }
    return model
  }
}

extension NIMQChatSearchServerChannelMemberParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatSearchServerChannelMemberParam {
    guard let model = NIMQChatSearchServerChannelMemberParam.yx_model(with: json) else {
      print("❌NIMQChatSearchServerChannelMemberParam.yx_model(with: json) FAILED")
      return NIMQChatSearchServerChannelMemberParam()
    }
    return model
  }
}

// MARK: result

extension NIMQChatGetChannelsResult {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["channels"] = channels.map { item in
        item.toDict()
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatGetChannelsByPageResult {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["channels"] = channels.map { item in
        item.toDict()
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatGetChannelMembersByPageResult {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["members"] = memberArray.map { item in
        item.toDic()
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatGetChannelUnreadInfosResult {
  func toDict() -> [[String: Any]?] {
    var jsonObject = [[String: Any]?]()
    if let unreadInfoList = unreadInfo {
      jsonObject = unreadInfoList.map { item in
        item.toDict()
      }
      return jsonObject
    }
    return [nil]
  }
}

extension NIMQChatSubscribeChannelResult {
  func toDict() -> [[String: Any]?] {
    var jsonObject = [[String: Any]?]()
    jsonObject = faildChannels.map { item in
      item.toDict()
    }
    return jsonObject
  }
}

extension NIMQChatSearchChannelByPageResult {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      if let channelsList = channels {
        jsonObject["channels"] = channelsList.map { item in
          item.toDict()
        }
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatChannelMember {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["createTime"] = Int(createTime * 1000)
      jsonObject["updateTime"] = Int(updateTime * 1000)
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatSearchServerChannelMemberResult {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      if let memberList = serverMembers {
        jsonObject["members"] = memberList.map { item in
          item.toDict()
        }
      }
      return jsonObject
    }
    return nil
  }
}
