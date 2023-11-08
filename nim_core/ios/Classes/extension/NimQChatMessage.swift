// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension NIMQChatMessageAntispamSetting {
  static func fromDic(_ json: [String: Any]) -> NIMQChatMessageAntispamSetting? {
    guard let model = NIMQChatMessageAntispamSetting.yx_model(with: json) else {
      print("❌NIMQChatMessageAntispamSetting.yx_model(with: json) FAILED")
      return nil
    }
    if let isCustomAntiSpamEnable = json["isCustomAntiSpamEnable"] as? Bool {
      model.enableAntiSpamContent = isCustomAntiSpamEnable
    }
    if let customAntiSpamContent = json["customAntiSpamContent"] as? String {
      model.antiSpamContent = customAntiSpamContent
    }
    if let antiSpamBusinessId = json["antiSpamBusinessId"] as? String {
      model.antiSpamBusinessId = antiSpamBusinessId
    }
    if let isAntiSpamUsingYidun = json["isAntiSpamUsingYidun"] as? Bool {
      model.antiSpamUsingYidun = isAntiSpamUsingYidun
    }
    if let yidunCallback = json["yidunCallback"] as? String {
      model.yidunCallback = yidunCallback
    }
    if let yidunAntiCheating = json["yidunAntiCheating"] as? String {
      model
        .yidunAntiCheating = NSObject().getDictionaryFromJSONString(yidunAntiCheating)
    }
    if let yidunAntiSpamExt = json["yidunAntiSpamExt"] as? String {
      model.yidunAntiSpamExt = yidunAntiSpamExt
    }
    return model
  }
}

extension NIMQChatMessage {
  @objc static func modelPropertyBlacklist() -> [String] {
    [#keyPath(NIMMessage.messageObject),
     #keyPath(NIMMessage.messageExt),
     #keyPath(NIMMessage.localExt)]
  }

  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["msgType"] = FLT_NIMMessageType.convert(_: messageType)?.rawValue
//      jsonObject["session"] = session?.toDict()
      jsonObject["qChatChannelId"] = qchatChannelId
      jsonObject["qChatServerId"] = qchatServerId
      jsonObject["fromAccount"] = from
      jsonObject["fromClientType"] = senderClientType.rawValue
      jsonObject["fromNick"] = senderName ?? ""
      jsonObject["time"] = Int(timestamp * 1000)
      jsonObject["updateTime"] = Int(updateTimestamp * 1000)
      jsonObject["content"] = text
      jsonObject["remoteExtension"] = remoteExt ?? [String: Any]()
      jsonObject["uuid"] = messageId
      jsonObject["msgIdServer"] = Int(serverID)
      jsonObject["resend"] = false
      jsonObject["serverStatus"] = status.rawValue
      jsonObject["pushPayload"] = apnsPayload
      jsonObject["pushContent"] = apnsContent
      jsonObject["mentionedAccidList"] = mentionedAccids
      jsonObject["mentionedAll"] = mentionedAll
      jsonObject["historyEnable"] = setting?.historyEnabled
      jsonObject["sendMsgStatus"] = FLT_NIMMessageStatus.convertFLTStatus(qchatMessage: self)
        .rawValue
      jsonObject["attachStatus"] = FLT_NIMMessageAttachmentDownloadState
        .convertFLTState(_: attachmentDownloadState)?.rawValue
      jsonObject["pushEnable"] = setting?.apnsEnabled
      jsonObject["needBadge"] = setting?.shouldBeCounted
      jsonObject["needPushNick"] = setting?.apnsWithPrefix
      jsonObject["routeEnable"] = setting?.routeEnabled
      jsonObject["env"] = env ?? ""
      jsonObject["callbackExtension"] = callbackExt
      jsonObject["replyRefer"] = replyRefer?.toDict()
      jsonObject["threadRefer"] = threadRefer?.toDict()
      jsonObject["rootThread"] = (threadRefer == nil)
      jsonObject["antiSpamOption"] = yidunAntiSpamSetting?.toDict()
      jsonObject["antiSpamResult"] = yidunAntiSpamResult?.toDict()
      jsonObject["updateContent"] = updateContent?.toDict()
      jsonObject["updateOperatorInfo"] = updateOperatorInfo?.toDict(setting?.routeEnabled, env)
      jsonObject["mentionedRoleIdList"] = mentionedRoleidList
      jsonObject["subType"] = subType
      jsonObject["direct"] = isOutgoingMsg == true ? FLT_NIMMessageDirection.outgoing
        .rawValue : FLT_NIMMessageDirection.received.rawValue
      jsonObject["localExtension"] = localExt
      jsonObject["status"] = FLT_NIMMessageStatus.convertFLTStatus(qchatMessage: self)
        .rawValue

      if let attachment = messageObject as? NSObject {
        if let convert = attachment as? NimDataConvertProtrol {
          var att = convert.toDic()
          //                if let attachement = gArgument?["messageAttachment"] as? [String:
          // Any],
          //                   let size = attachement["size"] as? Int {
          //                  att?["size"] = size
          //                }
          att?["force_upload"] = true
          if let mt = jsonObject["messageType"] as? String {
            att?["messageType"] = mt
          } else if let messagetype = FLT_NIMMessageType.convert(messageType) {
            att?["messageType"] = messagetype.rawValue
          }
          if att?["messageType"] as? String == FLT_NIMMessageType.image.rawValue,
             let image = messageObject as? NIMImageObject {
            att?["size"] = Int(image.size.width * image.size.height)
          }
          // messageAttachment返回为空问题修改
          if let location = messageObject as? NIMLocationObject {
            att?["lat"] = location.latitude
            att?["lng"] = location.longitude
            att?["title"] = location.title
          }

          jsonObject["attachment"] = att
        } else if let object = attachment as? NIMCustomObject,
                  let customObject = object.attachment as? NimAttachment,
                  var data = customObject.data {
          data["messageType"] = "custom"
          jsonObject["attachment"] = data
        } else {
          print("NIMQchatMessage toDict(): messageObject type is unknown")
        }
        if let attchStr = jsonObject["attachment"] as? [String: Any] {
          jsonObject["attachStr"] = getJsonStringFromDictionary(attchStr)
        }
      }
      return jsonObject
    }
    return nil
  }

  class func convertToMessage(_ arguments: [String: Any]) -> NIMQChatMessage? {
    if let qChatMessage = NIMQChatMessage.yx_model(with: arguments) {
      // 开始转换不对称结构
      var type: NIMMessageType?
      var attachment: [String: Any]?
      if let type1 = arguments["type"] as? String {
        type = FLT_NIMMessageType(rawValue: type1)?.convertToNIMMessageType()
      }
      if let type2: String = arguments["msgType"] as? String {
        type = FLT_NIMMessageType(rawValue: type2)?.convertToNIMMessageType()
      }

      if let attachment1 = arguments["attach"] as? String {
        attachment = NSObject().getDictionaryFromJSONString(attachment1)
      }
      if let attachment2 = arguments["attachment"] as? [String: Any] {
        attachment = attachment2
      }

      if let msgType = type {
        qChatMessage.setValue(
          msgType.rawValue,
          forKeyPath: #keyPath(NIMQChatMessage.messageType)
        )
      }
      if let attachment = attachment, let mType = type {
        switch mType {
        case NIMMessageType.image:
          if let object = NIMImageObject.fromDic(attachment) as? NIMImageObject {
            if let scene = object.value(forKeyPath: "_scene") as? String,
               let nosScene = NIMNosScene(rawValue: scene) {
              let _scene = nosScene.getScene()
              object.setValue(_scene, forKeyPath: "_scene")
            }
            qChatMessage.messageObject = object
          }

        case NIMMessageType.audio:
          if let object = NIMAudioObject.fromDic(attachment) as? NIMAudioObject {
            if let scene = object.value(forKeyPath: "_scene") as? String,
               let nosScene = NIMNosScene(rawValue: scene) {
              let _scene = nosScene.getScene()
              object.setValue(_scene, forKeyPath: "_scene")
            }
            qChatMessage.messageObject = object
          }

        case NIMMessageType.video:
          if let object = NIMVideoObject.fromDic(attachment) as? NIMVideoObject {
            if let scene = object.value(forKeyPath: "_scene") as? String,
               let nosScene = NIMNosScene(rawValue: scene) {
              let _scene = nosScene.getScene()
              object.setValue(_scene, forKeyPath: "_scene")
            }
            qChatMessage.messageObject = object
          }

        case NIMMessageType.file:
          if let object = NIMFileObject.fromDic(attachment) as? NIMFileObject {
            if let scene = object.value(forKeyPath: "_scene") as? String,
               let nosScene = NIMNosScene(rawValue: scene) {
              let _scene = nosScene.getScene()
              object.setValue(_scene, forKeyPath: "_scene")
            }
            qChatMessage.messageObject = object
          }

        case NIMMessageType.location:
          let location = NIMLocationObject.yx_model(with: attachment)
          if let t = attachment["title"] as? String,
             let lat = attachment["lat"] as? Double,
             let lng = attachment["lng"] as? Double {
            location?.setValue(t, forKeyPath: #keyPath(NIMLocationObject.title))
            location?.setValue(lat, forKeyPath: #keyPath(NIMLocationObject.latitude))
            location?.setValue(lng, forKeyPath: #keyPath(NIMLocationObject.longitude))
          }
          qChatMessage.messageObject = location

        case NIMMessageType.notification:
          if let object = NIMNotificationObject.fromDic(attachment) as? NIMNotificationObject {
            qChatMessage.messageObject = object
          }

        case NIMMessageType.rtcCallRecord:
          if let object = NIMRtcCallRecordObject.fromDic(attachment) as? NIMRtcCallRecordObject {
            qChatMessage.messageObject = object
          }

        case NIMMessageType.custom:
          let customAttachment = NimAttachment(attachment)
          let object = NIMCustomObject()
          object.attachment = customAttachment
          qChatMessage.messageObject = object

        case NIMMessageType.robot:
          if let object = NIMRobotObject.fromDic(attachment) as? NIMRobotObject {
            qChatMessage.messageObject = object
          }
        default:
          break
        }
      }

      if let uuid = arguments["uuid"] as? String {
        qChatMessage.setValue(uuid, forKeyPath: #keyPath(NIMQChatMessage.messageId))
      }
      if let msgIdServer = arguments["msgIdServer"] as? Int {
        qChatMessage.setValue("\(msgIdServer)", forKeyPath: #keyPath(NIMQChatMessage.serverID))
      }
      var qChatServiceId = 0
      var qChatChannelId = 0
      if let sId = arguments["serverId"] as? Int {
        qChatServiceId = sId
      }
      if let sId = arguments["qChatServerId"] as? Int {
        qChatServiceId = sId
      }
      if let cId = arguments["channelId"] as? Int {
        qChatChannelId = cId
      }
      if let cId = arguments["qChatChannelId"] as? Int {
        qChatChannelId = cId
      }
      if qChatServiceId > 0, qChatChannelId > 0 {
        let session = NIMSession(forQChat: Int64(qChatChannelId), qchatServerId: Int64(qChatServiceId))
        qChatMessage.setValue(session, forKeyPath: #keyPath(NIMQChatMessage.session))
      }
      if let body = arguments["body"] as? String {
        qChatMessage.text = body
      }
      if let content = arguments["content"] as? String {
        qChatMessage.text = content
      }
      if let fromAccount = arguments["fromAccount"] as? String {
        qChatMessage.from = fromAccount
      }
      if let fromClientType = arguments["fromClientType"] as? Int {
        qChatMessage.setValue(
          fromClientType,
          forKeyPath: "_clientType"
        )
      }
      if let fromNick = arguments["fromNick"] as? String {
        qChatMessage.setValue(fromNick, forKeyPath: #keyPath(NIMQChatMessage.senderName))
      }
      if let time = arguments["time"] as? Double {
        qChatMessage.timestamp = TimeInterval(time / 1000)
      }
      if let updateTime = arguments["updateTime"] as? Double {
        qChatMessage.updateTimestamp = TimeInterval(updateTime / 1000)
      }

      // 发送消息的时候通过extension 设置
      if let ext = arguments["extension"] as? [String: Any] {
        qChatMessage.remoteExt = ext
      }

      if let remoteExt = arguments["remoteExtension"] as? [String: Any] {
        qChatMessage.remoteExt = remoteExt
      }

      if let localExt = arguments["localExtension"] as? [String: Any] {
        qChatMessage.localExt = localExt
      }
//      qChatMessage.remoteExt = arguments["extension"] as? [String: Any]
//      qChatMessage.remoteExt = arguments["remoteExtension"] as? [String: Any]
//      qChatMessage.localExt = arguments["extension"] as? [String: Any]
//      qChatMessage.localExt = arguments["localExtension"] as? [String: Any]

      qChatMessage.apnsPayload = arguments["pushPayload"] as? [String: Any]
      if let pushContent = arguments["pushContent"] as? String {
        qChatMessage.apnsContent = pushContent
      }
      if let mentionedAccidList = arguments["mentionedAccidList"] as? [String] {
        qChatMessage.mentionedAccids = mentionedAccidList
      }
      if let mentionedRoleIdList = arguments["mentionedRoleIdList"] as? [NSNumber] {
        qChatMessage.mentionedRoleidList = mentionedRoleIdList
      }
      if let mentionedAll = arguments["mentionedAll"] as? Bool {
        qChatMessage.mentionedAll = mentionedAll
      }

      let sett = NIMMessageSetting()

      if let historyEnable = arguments["historyEnable"] as? Bool {
        sett.historyEnabled = historyEnable
      }
      if let pushEnable = arguments["pushEnable"] as? Bool {
        sett.apnsEnabled = pushEnable
      }
      if let needBadge = arguments["needBadge"] as? Bool {
        sett.shouldBeCounted = needBadge
      }
      if let needPushNick = arguments["needPushNick"] as? Bool {
        sett.apnsWithPrefix = needPushNick
      }
      if let isRouteEnable = arguments["isRouteEnable"] as? Bool {
        sett.routeEnabled = isRouteEnable
      }
      if let routeEnable = arguments["routeEnable"] as? Bool {
        sett.routeEnabled = routeEnable
      }
      qChatMessage.setting = sett
      if let serverStatus = arguments["serverStatus"] as? Int {
        qChatMessage.status = NIMQChatMessageStatus(rawValue: serverStatus) ?? .`init`
      }
      if let replyRefer = arguments["replyRefer"] as? [String: Any] {
        qChatMessage.setValue(
          NIMQChatMessageRefer.fromDic(replyRefer),
          forKeyPath: #keyPath(NIMQChatMessage.replyRefer)
        )
      }
      if let threadRefer = arguments["threadRefer"] as? [String: Any] {
        qChatMessage.setValue(
          NIMQChatMessageRefer.fromDic(threadRefer),
          forKeyPath: #keyPath(NIMQChatMessage.threadRefer)
        )
      }
      if let env = arguments["env"] as? String {
        qChatMessage.env = env
      }
      if let callbackExtension = arguments["callbackExtension"] as? String {
        qChatMessage.setValue(
          callbackExtension,
          forKeyPath: #keyPath(NIMQChatMessage.callbackExt)
        )
      }
      if let antiSpamOption = arguments["antiSpamOption"] as? [String: Any] {
        qChatMessage.yidunAntiSpamSetting = NIMQChatMessageAntispamSetting
          .fromDic(antiSpamOption)
      }
//        // MARK: antiSpamResult 参数反序列化无效
//        if let antiSpamResult = arguments["antiSpamResult"] as? [String: Any] {
//            qChatMessage.yidunAntiSpamResult =
//            NIMQChatMessageAntispamResult.fromDic(antiSpamResult)
//        }
      if let updateContent = arguments["updateContent"] as? [String: Any] {
        qChatMessage.updateContent = NIMQChatMessageUpdateContent.fromDic(updateContent)
      }
      if let updateOperatorInfo = arguments["updateOperatorInfo"] as? [String: Any] {
        qChatMessage.updateOperatorInfo = NIMQChatMessageUpdateOperatorInfo
          .fromDic(updateOperatorInfo)
      }
      if let subType = arguments["subType"] as? NSNumber {
        qChatMessage.subType = subType
      }
      return qChatMessage
    }
    return nil
  }
}

extension NIMQChatMessageAntispamResult {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["isAntiSpam"] = isAntispam
      jsonObject["yidunAntiSpamRes"] = yidunAntiSpamRes
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatUpdateMessageInfo {
  static func fromDic(_ json: [String: Any]) -> NIMQChatUpdateMessageInfo? {
    guard let model = NIMQChatUpdateMessageInfo.yx_model(with: json) else {
      print("❌NIMQChatUpdateMessageInfo.yx_model(with: json) FAILED")
      return nil
    }
    if let serverStatus = json["serverStatus"] as? Int {
      model.status = serverStatus
    }
    if let body = json["body"] as? String {
      model.text = body
    }
    if let ext = json["extension"] as? [String: Any] {
      model.remoteExt = ext
    }
    if let antiSpamOption = json["antiSpamOption"] as? [String: Any] {
      model.antispamSetting = NIMQChatMessageAntispamSetting.fromDic(antiSpamOption)
    }
    if let subType = json["subType"] as? NSNumber {
      model.subType = subType
    }
    return model
  }
}

extension NIMQChatUpdateMessageParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatUpdateMessageParam? {
    guard let model = NIMQChatUpdateMessageParam.yx_model(with: json) else {
      print("❌NIMQChatUpdateMessageParam.yx_model(with: json) FAILED")
      return nil
    }
    if let updateParam = json["updateParam"] as? [String: Any] {
      model.updateParam = NIMQChatUpdateParam.fromDic(updateParam)
    }

    if let updateInfo = NIMQChatUpdateMessageInfo.fromDic(json) {
      model.updateInfo = updateInfo
    }

    return model
  }
}

extension NIMQChatRevokeMessageParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatRevokeMessageParam? {
    guard let model = NIMQChatRevokeMessageParam.yx_model(with: json) else {
      print("❌NIMQChatRevokeMessageParam.yx_model(with: json) FAILED")
      return nil
    }
    if let updateParam = json["updateParam"] as? [String: Any] {
      model.updateParam = NIMQChatUpdateParam.fromDic(updateParam)
    }

    return model
  }
}

extension NIMQChatDeleteMessageParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatDeleteMessageParam? {
    guard let model = NIMQChatDeleteMessageParam.yx_model(with: json) else {
      print("❌NIMQChatDeleteMessageParam.yx_model(with: json) FAILED")
      return nil
    }
    if let updateParam = json["updateParam"] as? [String: Any] {
      model.updateParam = NIMQChatUpdateParam.fromDic(updateParam)
    }

    return model
  }
}

extension NIMQChatGetMessageHistoryParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetMessageHistoryParam? {
    guard let model = NIMQChatGetMessageHistoryParam.yx_model(with: json) else {
      print("❌NIMQChatGetMessageHistoryParam.yx_model(with: json) FAILED")
      return nil
    }
    if let excludeMessageId = json["excludeMessageId"] as? NSNumber {
      model.excludeMsgId = excludeMessageId
    }
    if let fromTime = json["fromTime"] as? Int64 {
      model.fromTime = Double(fromTime) / 1000.0
    }
    if let toTime = json["toTime"] as? Int64 {
      model.toTime = NSNumber(value: Double(toTime) / 1000.0)
    }
    return model
  }
}

extension NIMQChatGetMessageHistoryByIdsParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetMessageHistoryByIdsParam? {
    guard let model = NIMQChatGetMessageHistoryByIdsParam.yx_model(with: json),
          let serverId = json["serverId"] as? UInt64,
          let channelId = json["channelId"] as? UInt64 else {
      print("❌NIMQChatGetMessageHistoryByIdsParam.yx_model(with: json) FAILED")
      return nil
    }
    model.serverId = serverId
    model.channelId = channelId
    if let messageReferList = json["messageReferList"] as? [[String: Any]] {
      let ids = messageReferList.map { item in
        NIMQChatMessageServerIdInfo.fromDic(item)
      }
      model.ids = ids
    } else {
      model.ids = [NIMQChatMessageServerIdInfo.fromDic(json)]
    }
    return model
  }
}

extension NIMQChatMarkMessageReadParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatMarkMessageReadParam? {
    guard let model = NIMQChatMarkMessageReadParam.yx_model(with: json),
          let serverId = json["serverId"] as? UInt64,
          let channelId = json["channelId"] as? UInt64 else {
      print("❌NIMQChatMarkMessageReadParam.yx_model(with: json) FAILED")
      return nil
    }
    model.serverId = serverId
    model.channelId = channelId
    if let ackTimestamp = json["ackTimestamp"] as? Double {
      model.ackTimestamp = TimeInterval(ackTimestamp / 1000)
    }
    return model
  }
}

extension NIMQChatMarkSystemNotificationsReadItem {
  static func fromDic(_ json: [String: Any]) -> NIMQChatMarkSystemNotificationsReadItem {
    guard let model = NIMQChatMarkSystemNotificationsReadItem.yx_model(with: json) else {
      print("❌NIMQChatMarkSystemNotificationsReadItem.yx_model(with: json) FAILED")
      return NIMQChatMarkSystemNotificationsReadItem()
    }
    if let msgId = json["msgId"] as? UInt64 {
      model.messageServerId = msgId
    }
    if let type = json["type"] as? String,
       let nimType = FLTQChatSystemNotificationType(rawValue: type)?
       .convertNIMQChatSystemNotificationType() {
      model.type = nimType
    }
    return model
  }
}

extension NIMQChatMarkSystemNotificationsReadParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatMarkSystemNotificationsReadParam? {
    guard let model = NIMQChatMarkSystemNotificationsReadParam.yx_model(with: json) else {
      print("❌NIMQChatMarkSystemNotificationsReadParam.yx_model(with: json) FAILED")
      return nil
    }
    if let pairs = json["pairs"] as? [[String: Any]] {
      let items = pairs.map { item in
        NIMQChatMarkSystemNotificationsReadItem.fromDic(item)
      }
      model.items = items
    }
    return model
  }
}

extension NIMQChatSendSystemNotificationParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatSendSystemNotificationParam? {
    guard let serverId = json["serverId"] as? UInt64 else {
      return nil
    }
    var model = NIMQChatSendSystemNotificationParam(serverId: serverId)
    if let channelId = json["channelId"] as? UInt64 {
      if let toAccids = json["toAccids"] as? [String] {
        model = NIMQChatSendSystemNotificationParam(
          serverId: serverId,
          channelId: channelId,
          toAccids: toAccids
        )
      } else {
        model = NIMQChatSendSystemNotificationParam(serverId: serverId, channelId: channelId)
      }
    }

    if let attach = json["attach"] as? String,
       let att = NSObject().getDictionaryFromJSONString(attach) {
      model.attach = att
    }
    if let ext = json["extension"] as? [String: Any],
       let data = try? JSONSerialization.data(withJSONObject: ext, options: []),
       let str = String(data: data, encoding: String.Encoding.utf8) {
      model.ext = str
    }
    if let body = json["body"] as? String {
      model.body = body
    }

    if let payload = json["pushPayload"] as? [String: Any],
       let jsondata = try? JSONSerialization.data(withJSONObject: payload, options: []),
       let jsonStr = String(data: jsondata, encoding: String.Encoding.utf8) {
      model.pushPayload = jsonStr
    }

    if let pushContent = json["pushContent"] as? String {
      model.pushContent = pushContent
    }

    model.setting = NIMQChatSystemNotificationSetting.fromDic(json)
    return model
  }
}

extension NIMQChatSystemNotification {
  static func fromDic(_ json: [String: Any]) -> NIMQChatSystemNotification? {
    guard let model = NIMQChatSystemNotification.yx_model(with: json) else {
      print("❌NIMQChatSystemNotification.yx_model(with: json) FAILED")
      return nil
    }
    if let toType = json["toType"] as? String,
       let nimToType = FLTQChatSystemNotificationToType(rawValue: toType)?
       .convertNIMQChatSystemNotificationToType() {
      model.setValue(nimToType, forKeyPath: #keyPath(NIMQChatSystemNotification.toType))
    }
    if let type = json["type"] as? String,
       let nimType = FLTQChatSystemNotificationType(rawValue: type)?
       .convertNIMQChatSystemNotificationType() {
      model.type = nimType
    }
    if let msgIdClient = json["msgIdClient"] as? String {
      model.messageClientId = msgIdClient
    }
    if let msgIdServer = json["msgIdServer"] as? UInt64 {
      model.messageServerID = msgIdServer
    }
    if let ext = json["extension"] as? String {
      model.ext = ext
    }
    model.setting = NIMQChatSystemNotificationSetting.fromDic(json)
    if let callbackExtension = json["callbackExtension"] as? String {
      model.callbackExt = callbackExtension
    }

    // MARK: 🫡NIMQChatSystemNotification attachment

    var namespace = ""
    if let name = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String {
      namespace = name + "."
    }
    if let attachJson = json["attachment"] as? [String: Any],
       let myClass =
       NSClassFromString(namespace + "NIMQChatSystemNotificationAttachment") as? NSObject.Type {
      let object = myClass.init()
      let attachDict = attachJson
      object.setValue(attachDict, forKeyPath: "attachDict")
      object.setValue(model.type, forKeyPath: "type")
      if let requestId = attachJson["requestId"] as? Int32 {
        object.setValue(requestId, forKeyPath: "requestId")
      }
      if let server = attachJson["server"] as? [String: Any] {
        let serverObjc = NIMQChatServer.fromDic(server)
        object.setValue(serverObjc, forKeyPath: "server")
      }
      if let invitedAccids = attachJson["invitedAccids"] as? [String] {
        object.setValue(invitedAccids, forKeyPath: "invitedAccids")
      }
      if let applyAccid = attachJson["applyAccid"] as? String {
        object.setValue(applyAccid, forKeyPath: "applyAccid")
      }
      if let inviteAccid = attachJson["inviteAccid"] as? String {
        object.setValue(inviteAccid, forKeyPath: "inviteAccid")
      }
      if let kickedAccids = attachJson["kickedAccids"] as? [String] {
        object.setValue(kickedAccids, forKeyPath: "kickedAccids")
      }
      if let serverMember = attachJson["serverMember"] as? [String: Any] {
        let serverMemberObjc = NIMQChatServerMember.fromDic(serverMember)
        object.setValue(serverMemberObjc, forKeyPath: "serverMember")
      }
      if let channel = attachJson["channel"] as? [String: Any] {
        let channelObjc = NIMQChatChannel.fromDic(channel)
        object.setValue(channelObjc, forKeyPath: "channel")
      }
      if let serverId = attachJson["serverId"] as? UInt64,
         let channelId = attachJson["channelId"] as? UInt64 {
        object.setValue(serverId, forKeyPath: "serverId")
        object.setValue(channelId, forKeyPath: "channelId")
        object.setValue(
          NIMQChatChannelIdInfo(channelId: channelId, serverId: serverId),
          forKeyPath: "channelIdInfo"
        )
      }
      if let roleId = attachJson["roleId"] as? UInt64 {
        object.setValue(roleId, forKeyPath: "roleId")
      }
      let updateBlackWhiteRoleInfo = NIMQChatUpdateChannelBlackWhiteRoleInfo
        .fromDic(attachJson)
      object.setValue(updateBlackWhiteRoleInfo, forKeyPath: "updateBlackWhiteRoleInfo")
//        }
      let updateBlackWhiteMembersInfo = NIMQChatUpdateChannelBlackWhiteMembersInfo
        .fromDic(attachJson)
      object.setValue(updateBlackWhiteMembersInfo, forKeyPath: "updateBlackWhiteMembersInfo")
      if let quickComment = attachJson["quickComment"] as? [String: Any] {
        let updateQuickCommentInfo = NIMQChatUpdateQuickCommentInfo.fromDic(quickComment)
        object.setValue(updateQuickCommentInfo, forKeyPath: "updateQuickCommentInfo")
      }
      if let channelCategory = attachJson["channelCategory"] as? [String: Any] {
        let channelCategory = NIMQChatChannelCategory.fromDic(channelCategory)
        object.setValue(channelCategory, forKeyPath: "channelCategory")
      }
      if let channelCategoryId = attachJson["channelCategoryId"] as? UInt64 {
        object.setValue(channelCategoryId, forKeyPath: "categoryId")
      }
      let updateChannelCategoryBlackWhiteRoleInfo =
        NIMQChatUpdateChannelCategoryBlackWhiteRoleInfo.fromDic(attachJson)
      object.setValue(
        updateChannelCategoryBlackWhiteRoleInfo,
        forKeyPath: "updateChannelCategoryBlackWhiteRoleInfo"
      )
      let updateChannelCategoryBlackWhiteMemberInfo =
        NIMQChatUpdateChannelCategoryBlackWhiteMemberInfo.fromDic(attachJson)
      object.setValue(
        updateChannelCategoryBlackWhiteMemberInfo,
        forKeyPath: "updateChannelCategoryBlackWhiteMemberInfo"
      )
      if let addServerRoleAccIds = attachJson["addAccids"] as? [String] {
        object.setValue(addServerRoleAccIds, forKeyPath: "addServerRoleAccIds")
      }
      if let removeServerRoleAccIds = attachJson["deleteAccids"] as? [String] {
        object.setValue(removeServerRoleAccIds, forKeyPath: "removeServerRoleAccIds")
      }
      if let inOutType = attachJson["inOutType"] as? String,
         let inoutType = FLTQChatInoutType(rawValue: inOutType)?.convertNIMQChatInoutType() {
        object.setValue(inoutType, forKeyPath: "inoutType")
      }
      if let inviteCode = attachJson["inviteCode"] as? String {
        object.setValue(inviteCode, forKeyPath: "inviteCode")
      }
      if let updateAuths = attachJson["updateAuths"] as? [String: String] {
        var updateAuthList = [NIMQChatPermissionStatusInfo]()
        for (key, value) in updateAuths {
          if let type = FLTQChatPermissionType(rawValue: key)?.convertNIMQChatPermissionType(),
             let status = FLTQChatPermissionStatus(rawValue: value)?
             .convertNIMQChatPermissionStatus() {
            let updateAuth = NIMQChatPermissionStatusInfo()
            updateAuth.type = type
            updateAuth.customType = type.rawValue
            updateAuth.status = status
            updateAuthList.append(updateAuth)
          }
        }
        object.setValue(updateAuthList, forKeyPath: "updateAuths")
      }
      if let parentRoleId = attachJson["parentRoleId"] as? UInt64 {
        object.setValue(parentRoleId, forKeyPath: "parentRoleId")
      }
      if let accid = attachJson["accid"] as? String {
        object.setValue(accid, forKeyPath: "accId")
      }
    }
    return model
  }
}

extension NIMQChatResendSystemNotificationParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatResendSystemNotificationParam? {
    guard let model = NIMQChatResendSystemNotificationParam.yx_model(with: json) else {
      print("❌NIMQChatResendSystemNotificationParam.yx_model(with: json) FAILED")
      return nil
    }
    if let systemNotificationJson = json["systemNotification"] as? [String: Any],
       let systemNotification = NIMQChatSystemNotification.fromDic(systemNotificationJson) {
      model.systemNotification = systemNotification
    }

    return model
  }
}

extension NIMQChatUpdateSystemNotificationParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatUpdateSystemNotificationParam? {
    guard let model = NIMQChatUpdateSystemNotificationParam.yx_model(with: json) else {
      print("❌NIMQChatUpdateSystemNotificationParam.yx_model(with: json) FAILED")
      return nil
    }
    if let updateParam = json["updateParam"] as? [String: Any] {
      model.updateParam = NIMQChatUpdateParam.fromDic(updateParam)
    }
    if let msgIdServer = json["msgIdServer"] as? UInt64 {
      model.msgServerId = msgIdServer
    }
    if let type = json["type"] as? String,
       let nimType = FLTQChatSystemNotificationType(rawValue: type)?
       .convertNIMQChatSystemNotificationType() {
      model.notificationType = nimType
    }
    return model
  }
}

extension NIMQChatServer {
  static func fromDic(_ json: [String: Any]) -> NIMQChatServer {
    guard let model = NIMQChatServer.yx_model(with: json) else {
      print("❌NIMQChatServer.yx_model(with: json) FAILED")
      return NIMQChatServer()
    }

    model.appId = 0
    if let inviteMode = json["inviteMode"] as? String,
       let invi = FLTQChatServerInviteMode(rawValue: inviteMode)?
       .convertToQChatServerInviteMode() {
      model.inviteMode = invi
    }
    if let applyMode = json["applyMode"] as? String,
       let appMd = FLTQChatServerApplyMode(rawValue: applyMode)?
       .convertToQChatServerApplyMode() {
      model.applyMode = appMd
    }
    if let valid = json["valid"] as? Bool {
      model.validFlag = valid
    }
    if let createTime = json["createTime"] as? Double {
      model.createTime = TimeInterval(createTime / 1000)
    }
    if let updateTime = json["updateTime"] as? Double {
      model.updateTime = TimeInterval(updateTime / 1000)
    }
    if let channelNum = json["channelNum"] as? Int {
      model.channelNumber = channelNum
    }
    if let channelCategoryNum = json["channelCategoryNum"] as? Int {
      model.catogeryNumber = channelCategoryNum
    }
    return model
  }
}

extension NIMQChatServerMember {
  static func fromDic(_ json: [String: Any]) -> NIMQChatServerMember {
    guard let model = NIMQChatServerMember.yx_model(with: json) else {
      print("❌NIMQChatServerMember.yx_model(with: json) FAILED")
      return NIMQChatServerMember()
    }

    model.appId = 0
    if let type = json["type"] as? String,
       let nimType = FLTQChatServerMemberType(rawValue: type)?.convertToQChatServerMemberType() {
      model.type = nimType
    }
    if let joinTime = json["joinTime"] as? Double {
      model.joinTime = TimeInterval(joinTime / 1000)
    }
    if let valid = json["valid"] as? Bool {
      model.validFlag = valid
    }
    if let createTime = json["createTime"] as? Double {
      model.createTime = TimeInterval(createTime / 1000)
    }
    if let updateTime = json["updateTime"] as? Double {
      model.updateTime = TimeInterval(updateTime / 1000)
    }
    return model
  }
}

extension NIMQChatUpdateQuickCommentInfo {
  static func fromDic(_ json: [String: Any]) -> NIMQChatUpdateQuickCommentInfo {
    guard let model = NIMQChatUpdateQuickCommentInfo.yx_model(with: json) else {
      print("❌NIMQChatUpdateQuickCommentInfo.yx_model(with: json) FAILED")
      return NIMQChatUpdateQuickCommentInfo()
    }
    if let msgSenderAccid = json["msgSenderAccid"] as? String {
      model.fromAccId = msgSenderAccid
    }
    if let msgIdServer = json["msgIdServer"] as? String {
      model.msgServerId = msgIdServer
    }
    if let msgTime = json["msgTime"] as? Double {
      model.timestamp = TimeInterval(msgTime / 1000)
    }
    if let type = json["type"] as? Int64 {
      model.replyType = type
    }
    if let operateType = json["operateType"] as? String,
       let ope = FLTQChatUpdateQuickCommentType(rawValue: operateType)?
       .convertNIMQChatUpdateQuickCommentType() {
      model.opeType = ope
    }
    return model
  }

  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["msgSenderAccid"] = fromAccId
      jsonObject["msgIdServer"] = Int(msgServerId)
      jsonObject["msgTime"] = Int(timestamp * 1000)
      jsonObject["type"] = replyType
      if let operateType = FLTQChatUpdateQuickCommentType.convert(type: opeType)?
        .rawValue {
        jsonObject["operateType"] = operateType
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatGetThreadMessagesParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetThreadMessagesParam {
    guard let model = NIMQChatGetThreadMessagesParam.yx_model(with: json) else {
      print("❌NIMQChatGetThreadMessagesParam.yx_model(with: json) FAILED")
      return NIMQChatGetThreadMessagesParam()
    }
    if let fromTime = json["fromTime"] as? Double {
      model.fromTime = TimeInterval(fromTime / 1000)
    }
    if let toTime = json["toTime"] as? Double {
      model.toTime = NSNumber(floatLiteral: toTime / 1000)
    }
    if let excludeMessageId = json["excludeMessageId"] as? Int {
      model.excludeMsgId = "\(excludeMessageId)"
    }
    if let limit = json["limit"] as? Int {
      model.limit = NSNumber(value: limit)
    }
    if let reverse = json["reverse"] as? Bool {
      model.reverse = NSNumber(booleanLiteral: reverse)
    }
    return model
  }
}

extension NIMQChatGetMessageCacheParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetMessageCacheParam? {
    guard let model = NIMQChatGetMessageCacheParam.yx_model(with: json),
          let qchatServerId = json["qchatServerId"] as? UInt64,
          let qchatChannelId = json["qchatChannelId"] as? UInt64 else {
      print("❌NIMQChatGetMessageCacheParam.yx_model(with: json) FAILED")
      return nil
    }
    model.serverId = qchatServerId
    model.channelId = qchatChannelId
    model.withRefer = true
    model.withQuickComment = true
    return model
  }
}

extension NIMQChatGetLastMessageOfChannelsParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetLastMessageOfChannelsParam? {
    guard let model = NIMQChatGetLastMessageOfChannelsParam.yx_model(with: json),
          let serverId = json["serverId"] as? UInt64,
          let channelIds = json["channelIds"] as? [Int] else {
      print("❌NIMQChatGetLastMessageOfChannelsParam.yx_model(with: json) FAILED")
      return nil
    }
    model.serverId = serverId
    model.channelIds = channelIds.map { chan in
      NSNumber(value: chan)
    }
    return model
  }
}

extension NIMQChatSearchMsgByPageParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatSearchMsgByPageParam? {
    guard let model = NIMQChatSearchMsgByPageParam.yx_model(with: json) else {
      print("❌NIMQChatSearchMsgByPageParam.yx_model(with: json) FAILED")
      return nil
    }
    if let fromTime = json["fromTime"] as? Double {
      model.fromTime = TimeInterval(fromTime / 1000)
    }
    if let toTime = json["toTime"] as? Double {
      model.toTime = TimeInterval(toTime / 1000)
    }
    if let msgTypes = json["msgTypes"] as? [String] {
      model.msgTypes = msgTypes.map { item in
        NSNumber(value: FLT_NIMMessageType(rawValue: item)?.convertToNIMMessageType()?
          .rawValue ?? 0)
      }
    }
    if let isIncludeSelf = json["isIncludeSelf"] as? Bool {
      model.includeSelf = isIncludeSelf
    }
    if let sort = json["sort"] as? String,
       let sortType = FLTQChatSearchMessageSortType(rawValue: sort)?
       .convertNIMQChatSearchMessageSortType() {
      model.sortType = sortType
    }
    return model
  }
}

// MARK: reault

extension NIMQChatUpdateMessageResult {
  func toDict() -> [String: Any]? {
    message?.toDict()
  }
}

extension NIMQChatGetMessageHistoryResult {
  func toDict() -> [Any]? {
    var jsonObject: [Any] = []
    if let msgs = messages,
       msgs.count > 0 {
      for item in msgs {
        if let msg = item.toDict() {
          jsonObject.append(msg)
        }
      }
    }
    return jsonObject
  }
}

extension NIMQChatSendSystemNotificationResult {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any],
       let jsonOb = systemNotification?.toDict() {
      jsonObject = jsonOb
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatUpdateSystemNotificationResult {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["sentCustomNotification"] = systemNotification?.toDict()
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatMessageThreadInfo {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["total"] = messageCount
      jsonObject["lastMsgTime"] = Int(lastMessageTimestamp * 1000)
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatGetThreadMessagesResult {
  func toDict() -> [String: Any]? {
    var jsonObject = [String: Any]()
    jsonObject["threadInfo"] = threadInfo?.toDict()
    jsonObject["threadMessage"] = threadMessage?.toDict()
    if let msgs = messages {
      let msgsList = msgs.map { msg in
        msg.toDict()
      }
      jsonObject["messages"] = msgsList
    }
    return jsonObject
  }
}

extension NIMQChatMessageQuickCommentsDetail {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["type"] = replyType
      jsonObject["hasSelf"] = selfReplyed
      jsonObject["severalAccids"] = replyAccIds
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatMessageQuickCommentInfo {
  func toDict() -> [String: Any]? {
    var jsonObject = [String: Any]()
    jsonObject["msgIdServer"] = Int64(msgServerId)
    jsonObject["totalCount"] = count
    jsonObject["lastUpdateTime"] = Int(updateTime * 1000)
    let details = commentArray.map { msg in
      msg.toDict()
    }
    jsonObject["details"] = details
    return jsonObject
  }
}

extension NIMQChatGetMessageCacheResult {
  func toDict() -> [[String: Any]]? {
    var jsonObject = [[String: Any]]()
    for index in 0 ..< (messages?.count ?? 0) {
      var jsonItem = [String: Any]()
      jsonItem["message"] = messages![index].toDict()
      if let msgsRef = messagesRefered,
         let refKey = messages![index].replyRefer?.messageId {
        jsonItem["replyMessage"] = msgsRef[refKey]?.toDict()
      }
      if let msgsRef = messagesRefered,
         let refKey = messages![index].threadRefer?.messageId {
        jsonItem["threadMessage"] = msgsRef[refKey]?.toDict()
      }
      if let cmts = comments,
         let comment = cmts[messages![index].serverID]?.toDict() {
        jsonItem["messageQuickCommentDetail"] = comment
      }
      jsonObject.append(jsonItem)
    }
    return jsonObject
  }
}

extension NIMQChatGetLastMessageOfChannelsResult {
  func toDict() -> [String: Any]? {
    var jsonObject = [String: Any]()
    var channelMsgMap = [Int: [String: Any]]()
    for (key, value) in lastMessageOfChannelDic {
      channelMsgMap[key.intValue] = value.toDict()
    }
    jsonObject["channelMsgMap"] = channelMsgMap
    return jsonObject
  }
}

extension NIMQChatSearchMsgByPageResult {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["nextTimetag"] = Int(nextTimetag * 1000)
      if let msgs = messages {
        jsonObject["messages"] = msgs.map { msg in
          msg.toDict()
        }
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatServerUnreadInfo {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatGetMentionedMeMessagesParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatGetMentionedMeMessagesParam? {
    guard let model = NIMQChatGetMentionedMeMessagesParam.yx_model(with: json) else {
      print("❌NIMQChatGetMentionedMeMessagesParam.yx_model(with: json) FAILED")
      return nil
    }
    if let timetag = json["timetag"] as? Double {
      model.timetag = TimeInterval(timetag / 1000)
    }

    if let limit = json["limit"] as? Int {
      model.limit = limit
    }
    return model
  }
}

extension NIMQChatAreMentionedMeMessagesParam {
  static func fromDic(_ json: [String: Any]) -> NIMQChatAreMentionedMeMessagesParam? {
    guard let model = NIMQChatAreMentionedMeMessagesParam.yx_model(with: json) else {
      print("❌NIMQChatAreMentionedMeMessagesParam.yx_model(with: json) FAILED")
      return nil
    }

    if let messages = json["messages"] as? [[String: Any]] {
      var msgs = [NIMQChatMessage]()
      messages.forEach {
        item in
        if let msg = NIMQChatMessage.convertToMessage(item) {
          msgs.append(msg)
        }
      }
      model.messages = msgs
    }
    return model
  }
}

extension NIMQChatGetMentionedMeMessagesResult {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["nextTimetag"] = Int(nextTimetag * 1000)
      if let msgs = messages {
        jsonObject["messages"] = msgs.map { msg in
          msg.toDict()
        }
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMQChatAreMentionedMeMessagesResult {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      if let res = result {
        jsonObject["result"] = res.mapValues { it in
          it.boolValue
        }
      }
      return jsonObject
    }
    return nil
  }
}
