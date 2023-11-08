// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension NIMQChatOnlineStatusResult {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["status"] = FLTQChatLoginStep.convert(type: loginStep).rawValue
      return jsonObject
    }
    return nil
  }
}

extension NIMLoginKickoutResult {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["kickReason"] = FLTKickReason.convert(type: reasonCode)?.rawValue
      jsonObject["clientType"] = clientType.rawValue
      jsonObject["extension"] = reasonDesc
      jsonObject["customClientType"] = customClientType
      return jsonObject
    }
    return nil
  }
}

extension NIMSession {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["sessionId"] = sessionId
      jsonObject["sessionType"] = FLT_NIMSessionType.convertFLTSessionType(_: sessionType)?.rawValue
      jsonObject["qchatChannelId"] = qchatChannelId
      jsonObject["qchatServerId"] = qchatServerId
      return jsonObject
    }
    return nil
  }
}

extension NIMMessageSetting {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["historyEnabled"] = historyEnabled
      jsonObject["roamingEnabled"] = roamingEnabled
      jsonObject["syncEnabled"] = syncEnabled
      jsonObject["shouldBeCounted"] = shouldBeCounted
      jsonObject["apnsEnabled"] = apnsEnabled
      jsonObject["apnsWithPrefix"] = apnsWithPrefix
      jsonObject["routeEnabled"] = routeEnabled
      jsonObject["teamReceiptEnabled"] = teamReceiptEnabled
      jsonObject["persistEnable"] = persistEnable
      jsonObject["scene"] = scene
      jsonObject["isSessionUpdate"] = isSessionUpdate
      jsonObject["quickDeliveryEnabled"] = quickDeliveryEnabled
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatMessageServerIdInfo {
  static func fromDic(_ json: [String: Any]) -> NIMQChatMessageServerIdInfo {
    guard let model = NIMQChatMessageServerIdInfo.yx_model(with: json) else {
      print("❌NIMQChatMessageServerIdInfo.yx_model(with: json) FAILED")
      return NIMQChatMessageServerIdInfo()
    }
    if let msgIdServer = json["msgIdServer"] as? Int {
      model.serverID = "\(msgIdServer)"
    }
    if let time = json["time"] as? Double {
      model.timestamp = TimeInterval(time / 1000.0)
    }
    return model
  }

  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["serverID"] = serverID
      jsonObject["timestamp"] = Int(timestamp * 1000)
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatMessageRefer {
  static func fromDic(_ json: [String: Any]) -> NIMQChatMessageRefer {
    guard let model = NIMQChatMessageRefer.yx_model(with: json) else {
      print("❌NIMQChatMessageRefer.yx_model(with: json) FAILED")
      return NIMQChatMessageRefer()
    }
    if let fromAccount = json["fromAccount"] as? String {
      model.setValue(fromAccount, forKeyPath: #keyPath(NIMQChatMessageRefer.from))
    }
    if let uuid = json["uuid"] as? Int {
      model.setValue(uuid, forKeyPath: #keyPath(NIMQChatMessageRefer.messageId))
    }
    model.setValue(
      NIMQChatMessageServerIdInfo.fromDic(json),
      forKeyPath: #keyPath(NIMQChatMessageRefer.serverIdInfo)
    )
    return model
  }

  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["msgIdServer"] = Int(serverIdInfo.serverID)
      jsonObject["time"] = Int(serverIdInfo.timestamp * 1000)
      jsonObject["uuid"] = messageId
      jsonObject["fromAccount"] = from
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatMessageAntispamSetting {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["isCustomAntiSpamEnable"] = enableAntiSpamContent
      jsonObject["customAntiSpamContent"] = antiSpamContent
      jsonObject["antiSpamBusinessId"] = antiSpamBusinessId
      jsonObject["isAntiSpamUsingYidun"] = antiSpamUsingYidun
      jsonObject["yidunCallback"] = yidunCallback
      if let ydAntiCheating = yidunAntiCheating as? [String: Any] {
        jsonObject["yidunAntiCheating"] = getJsonStringFromDictionary(ydAntiCheating)
      }
      jsonObject["yidunAntiSpamExt"] = yidunAntiSpamExt
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatMessageUpdateContent {
  static func fromDic(_ json: [String: Any]) -> NIMQChatMessageUpdateContent {
    guard let model = NIMQChatMessageUpdateContent.yx_model(with: json) else {
      print("❌NIMQChatMessageUpdateContent.yx_model(with: json) FAILED")
      return NIMQChatMessageUpdateContent()
    }
    if let content = json["content"] as? String {
      model.text = content
    }
    if let serverStatus = json["serverStatus"] as? Int {
      model.status = NIMQChatMessageStatus(rawValue: serverStatus) ?? .`init`
    }
    if let getRemoteExtension = json["getRemoteExtension"] as? [String: Any],
       let data = try? JSONSerialization.data(withJSONObject: getRemoteExtension, options: []) {
      let str = String(data: data, encoding: String.Encoding.utf8)
      model.remoteExt = str ?? ""
    }
    return model
  }

  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["serverStatus"] = status.rawValue
      jsonObject["remoteExtension"] = getDictionaryFromJSONString(remoteExt)
      jsonObject["content"] = text
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatMessageUpdateOperatorInfo {
  static func fromDic(_ json: [String: Any]) -> NIMQChatMessageUpdateOperatorInfo {
    guard let model = NIMQChatMessageUpdateOperatorInfo.yx_model(with: json) else {
      print("❌NIMQChatMessageUpdateOperatorInfo.yx_model(with: json) FAILED")
      return NIMQChatMessageUpdateOperatorInfo()
    }
    if let operatorAccount = json["operatorAccount"] as? String {
      model.operatorAccid = operatorAccount
    }
    if let operatorClientType = json["operatorClientType"] as? Int {
      model.operatorClientType = NIMLoginClientType(rawValue: operatorClientType) ?? .typeUnknown
    }
    if let msg = json["msg"] as? String {
      model.postscript = msg
    }
    if let ext = json["ext"] as? String {
      model.extension = ext
    }
    if let pushContent = json["pushContent"] as? String {
      model.pushContent = pushContent
    }
    if let pushPayload = json["pushPayload"] as? String {
      model
        .pushPayload = pushPayload
    }
    return model
  }

  func toDict(_ routeEnable: Bool?, _ env: String?) -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["operatorAccount"] = operatorAccid
      jsonObject["operatorClientType"] = operatorClientType.rawValue
      jsonObject["msg"] = postscript
      jsonObject["ext"] = self.extension
      jsonObject["pushContent"] = pushContent
//      if let psPayload = pushPayload as? [String: Any] {
//        jsonObject["pushPayload"] = getJsonStringFromDictionary(psPayload)
//      }
      jsonObject["routeEnable"] = routeEnable
      jsonObject["env"] = env
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatUpdateParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatUpdateParam {
    guard let model = NIMQChatUpdateParam.yx_model(with: json) else {
      print("❌NIMQChatUpdateParam.yx_model(with: json) FAILED")
      return NIMQChatUpdateParam()
    }

    return model
  }

  func toDict() -> [String: Any] {
    var jsonObject = [String: Any]()
    jsonObject["msg"] = postscript
    jsonObject["ext"] = self.extension
    jsonObject["pushContent"] = pushContent
//      jsonObject["pushPayload"] = pushPayload
    if let ppLoad = pushPayload as? [String: Any] {
      jsonObject["pushPayload"] = NSObject().getJsonStringFromDictionary(ppLoad)
    }
    jsonObject["env"] = env
    jsonObject["routeEnable"] = routeEnable
    jsonObject["operatorAccount"] = operatorAccid
    jsonObject["operatorClientType"] = operatorClientType
    return jsonObject
  }
}

extension NIMQChatUpdateMessageEvent {
  func toDict() -> [String: Any]? {
    var jsonObject = [String: Any]()
    jsonObject["message"] = message.toDict()
    jsonObject["msgUpdateInfo"] = updateParam.toDict()
    return jsonObject
  }
}

extension NIMQChatUnreadInfo {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["channelId"] = channelId
      jsonObject["serverId"] = serverId
      jsonObject["unreadCount"] = unreadCount
      jsonObject["mentionedCount"] = mentionedCount
      jsonObject["maxCount"] = maxCount
      jsonObject["ackTimeTag"] = Int(ackTimestamp * 1000)
      jsonObject["lastMsgTime"] = Int(lastMessageTimestamp * 1000)
      jsonObject["time"] = Int(timestamp * 1000)
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatUnreadInfoChangedEvent {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      if unreadInfo?.count ?? 0 > 0 {
        let ret = unreadInfo!.map { item in
          item.toDict()
        }
        jsonObject["unreadInfos"] = ret
      }
      if lastUnreadInfo?.count ?? 0 > 0 {
        let ret = lastUnreadInfo!.map { item in
          item.toDict()
        }
        jsonObject["lastUnreadInfos"] = ret
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatSystemNotificationSetting {
  static func fromDic(_ json: [String: Any]) -> NIMQChatSystemNotificationSetting {
    guard let model = NIMQChatSystemNotificationSetting.yx_model(with: json) else {
      print("❌NIMQChatSystemNotificationSetting.yx_model(with: json) FAILED")
      return NIMQChatSystemNotificationSetting()
    }
    if let isRouteEnable = json["isRouteEnable"] as? Bool {
      model.routeEnable = isRouteEnable
    }
    return model
  }

  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["persistEnable"] = persistEnable
      jsonObject["pushEnable"] = pushEnable
      jsonObject["needBadge"] = needBadge
      jsonObject["needPushNick"] = needPushNick
      jsonObject["routeEnable"] = routeEnable
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatSystemNotification {
  @objc static func modelPropertyBlacklist() -> [String] {
    [#keyPath(NIMQChatSystemNotification.attach)]
  }

  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["toType"] = FLTQChatSystemNotificationToType.convert(type: toType)?.rawValue
      jsonObject["serverId"] = serverId
      jsonObject["channelId"] = channelId
      jsonObject["toAccids"] = toAccids
      jsonObject["fromAccount"] = fromAccount
      jsonObject["fromClientType"] = fromClientType
      jsonObject["fromDeviceId"] = fromDeviceId
      jsonObject["fromNick"] = fromNick
      jsonObject["time"] = Int(time * 1000)
      jsonObject["updateTime"] = Int(updateTime * 1000)
      jsonObject["type"] = FLTQChatSystemNotificationType.convert(type: type)?.rawValue
      jsonObject["msgIdClient"] = messageClientId
      jsonObject["msgIdServer"] = messageServerID

      jsonObject["body"] = body

      if let attachObject = attach as? NSObject {
        var attachJson = [String: Any]()
        attachJson["requestId"] = attachObject.value(forKeyPath: "requestId")
        if let ser = attachObject.value(forKeyPath: "server") as? NIMQChatServer {
          attachJson["server"] = ser.toDic()
        }
        attachJson["invitedAccids"] = attachObject.value(forKeyPath: "invitedAccids")
        attachJson["applyAccid"] = attachObject.value(forKeyPath: "applyAccid")
        attachJson["inviteAccid"] = attachObject.value(forKeyPath: "inviteAccid")
        attachJson["kickedAccids"] = attachObject.value(forKeyPath: "kickedAccids")
        if let serMem = attachObject.value(forKeyPath: "serverMember") as? NIMQChatServerMember {
          attachJson["serverMember"] = serMem.toDic()
        }
        if let chan = attachObject.value(forKeyPath: "channel") as? NIMQChatChannel {
          attachJson["channel"] = chan.toDict()
        }
        attachJson["serverId"] = attachObject.value(forKeyPath: "serverId")
        attachJson["channelId"] = attachObject.value(forKeyPath: "channelId")
        attachJson["roleId"] = attachObject.value(forKeyPath: "roleId")
        attachJson["parentRoleId"] = attachObject.value(forKeyPath: "parentRoleId")
        if let accid = attachObject.value(forKeyPath: "accId") as? String {
          attachJson["accid"] = accid
        }
        if let info = attachObject
          .value(
            forKeyPath: "updateBlackWhiteRoleInfo"
          ) as? NIMQChatUpdateChannelBlackWhiteRoleInfo {
          attachJson["channelBlackWhiteType"] = FLTQChatChannelMemberRoleType
            .convert(type: info.type)?.rawValue
        }
        if let info = attachObject
          .value(
            forKeyPath: "updateBlackWhiteRoleInfo"
          ) as? NIMQChatUpdateChannelBlackWhiteRoleInfo {
          attachJson["channelBlackWhiteOperateType"] = FLTQChatChannelMemberRoleOpeType
            .convert(type: info.opeType)?.rawValue
        }
        if let info = attachObject
          .value(
            forKeyPath: "updateBlackWhiteRoleInfo"
          ) as? NIMQChatUpdateChannelBlackWhiteRoleInfo {
          attachJson["channelBlackWhiteRoleId"] = info.roleId
        }
        if let info = attachObject
          .value(
            forKeyPath: "updateChannelCategoryBlackWhiteMemberInfo"
          ) as? NIMQChatUpdateChannelCategoryBlackWhiteMemberInfo {
          attachJson["toAccids"] = info.accids
        }
        if let info = attachObject
          .value(
            forKeyPath: "updateBlackWhiteMembersInfo"
          ) as? NIMQChatUpdateChannelBlackWhiteMembersInfo {
          attachJson["channelBlackWhiteToAccids"] = info.accids
        }
        if let info = attachObject
          .value(forKeyPath: "updateQuickCommentInfo") as? NIMQChatUpdateQuickCommentInfo {
          attachJson["quickComment"] = info.toDict()
        }
        if let category = attachObject
          .value(forKeyPath: "channelCategory") as? NIMQChatChannelCategory {
          attachJson["channelCategory"] = category.toDict()
        }
        attachJson["channelCategoryId"] = attachObject.value(forKeyPath: "categoryId")
        attachJson["addAccids"] = attachObject.value(forKeyPath: "addServerRoleAccIds")
        attachJson["deleteAccids"] = attachObject.value(forKeyPath: "removeServerRoleAccIds")
        if let type = attachObject
          .value(forKeyPath: "inoutType") as? Int,
          type > 0 {
          if let inOutType = NIMQChatInoutType(rawValue: type) {
            attachJson["inOutType"] = FLTQChatInoutType.convert(type: inOutType)?.rawValue
          }
        }

        if let info = attachObject.value(forKeyPath: "updatedInfos") as? [NIMQChatUpdatedMyMemberInfo] {
          attachJson["updatedInfos"] = info.map {
            item in item.toDict()
          }
        }

        if let updateAuths = attachObject.value(forKeyPath: "updateAuths") as? [NIMQChatPermissionStatusInfo] {
          var updateAuthsMap = [String: String]()
          updateAuths.forEach { item in
            if let key = FLTQChatPermissionType.convert(type: item.type)?.rawValue,
               let value = FLTQChatPermissionStatus.convert(type: item.status)?.rawValue {
              updateAuthsMap[key] = value
            }
          }
          attachJson["updateAuths"] = updateAuthsMap
        }

        attachJson["inviteCode"] = attachObject.value(forKeyPath: "inviteCode")

        jsonObject["attachment"] = attachJson // MARK: 🫡

        jsonObject["attach"] = getJsonStringFromDictionary(attachJson) // MARK: 🫡
      }

      jsonObject["extension"] = ext
      jsonObject["status"] = status

      jsonObject["pushPayload"] = pushPayload
      jsonObject["pushContent"] = pushContent
      jsonObject["persistEnable"] = setting?.persistEnable ?? false
      jsonObject["pushEnable"] = setting?.pushEnable ?? false
      jsonObject["needBadge"] = setting?.needBadge ?? true
      jsonObject["needPushNick"] = setting?.needPushNick ?? true
      jsonObject["routeEnable"] = setting?.routeEnable ?? true
      jsonObject["env"] = env
      jsonObject["callbackExtension"] = callbackExt
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatUpdatedMyMemberInfo {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["serverId"] = serverId
      jsonObject["nick"] = nick
      jsonObject["avatar"] = avatar
      jsonObject["isNickChanged"] = nickChanged
      jsonObject["isAvatarChanged"] = avatarChanged
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatReceiveSystemNotificationResult {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      if systemNotifications?.count ?? 0 > 0 {
        let ret = systemNotifications!.map { item in
          item.toDict()
        }
        jsonObject["eventList"] = ret
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatSystemNotificationUpdateResult {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["msgUpdateInfo"] = updateParam?.toDict()
      jsonObject["systemNotification"] = systemNotification?.toDict()
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatMessageTypingEvent {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["serverId"] = serverId
      jsonObject["channelId"] = channelId
      jsonObject["fromAccount"] = fromAccount
      jsonObject["fromNick"] = fromNick
      jsonObject["time"] = Int(timestamp * 1000)
      if let extJson = ext {
        jsonObject["extension"] = getDictionaryFromJSONString(extJson)
      }
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> NIMQChatMessageTypingEvent? {
    guard let model = NIMQChatMessageTypingEvent.yx_model(with: json) else {
      print("❌NIMQChatMessageTypingEvent.yx_model(with: json) FAILED")
      return nil
    }
    if let extensionDic = json["extension"] as? [String: Any] {
      model.ext = model.getJsonStringFromDictionary(extensionDic)
    }
    return model
  }
}
