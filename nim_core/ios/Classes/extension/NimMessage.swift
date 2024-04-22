// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

class NIMMessageThreadOption: NSObject {
  // 与 NIMSDK => NIMMessage 字段重复，剥离出来只为做结构转换，抹平 iOS 与 Flutter 层结构差异

  /// 该消息回复的目标消息的消息ID
  @objc dynamic var repliedMessageId: String?

  /// 被回复消息的消息接受者，群的话是tid   (Flutter => NSNumber 类型)
  @objc dynamic var repliedMessageServerId: String?

  ///  该消息回复的目标消息的发送者
  @objc dynamic var repliedMessageFrom: String?

  /// 该消息回复的目标消息的接收者
  @objc dynamic var repliedMessageTo: String?

  /// 该消息回复的目标消息的发送时间
  @objc dynamic var repliedMessageTime: NSNumber?

  /// 该消息的父消息的消息ID
  @objc dynamic var threadMessageId: String?

  /// 该消息的父消息的服务端ID  (Flutter => NSNumber 类型)
  @objc dynamic var threadMessageServerId: String?

  ///  该消息回复的父消息的发送者
  @objc dynamic var threadMessageFrom: String?

  /// 该消息回复的目标消息的接收者
  @objc dynamic var threadMessageTo: String?

  /// 该消息回复的父消息的发送时间
  @objc dynamic var threadMessageTime: NSNumber?

  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = getKeyPaths(self)
    keyPaths[#keyPath(NIMMessage.repliedMessageId)] = "replyMessageIdClient"
    keyPaths[#keyPath(NIMMessage.repliedMessageServerId)] = "threadMessageIdServer"
    keyPaths[#keyPath(NIMMessage.repliedMessageFrom)] = "replyMessageFromAccount"
    keyPaths[#keyPath(NIMMessage.repliedMessageTo)] = "replyMessageToAccount"
    keyPaths[#keyPath(NIMMessage.repliedMessageTime)] = "replyMessageTime"
    keyPaths[#keyPath(NIMMessage.threadMessageId)] = "threadMessageIdClient"
    keyPaths[#keyPath(NIMMessage.threadMessageServerId)] = "threadMessageIdServer"
    keyPaths[#keyPath(NIMMessage.threadMessageTo)] = "threadMessageToAccount"
    keyPaths[#keyPath(NIMMessage.threadMessageFrom)] = "threadMessageFromAccount"
    keyPaths[#keyPath(NIMMessage.threadMessageTime)] = "threadMessageTime"
    return keyPaths
  }

  func toDic() -> [String: Any]? {
    if var dic = yx_modelToJSONObject() as? [String: Any] {
      if let serverId = dic["replyMessageIdServer"] as? String {
        dic["replyMessageIdServer"] = (serverId as NSString).longLongValue
      }
      if let threadServerId = dic["threadMessageIdServer"] as? String {
        dic["threadMessageIdServer"] = (threadServerId as NSString).longLongValue
      }
      dic["replyMessageTime"] = Int((repliedMessageTime?.doubleValue ?? 0) * 1000)
      dic["threadMessageTime"] = Int((threadMessageTime?.doubleValue ?? 0) * 1000)
      return dic
    }
    return nil
  }
}

// iOS <=> Flutter 结构位置不同字段，需要手动处理
extension NIMMessage {
  /// 会话ID,如果当前session为team,则sessionId为teamId,如果是P2P则为对方帐号
  // self => session => sessionId
  @objc dynamic var sessionId: String? {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "sessionId".hashValue)!
      ) as? String {
        return T
      } else {
        return nil
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "sessionId".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }

  /// 会话类型,当前仅支持P2P,Team和Chatroom
  // self => session => sessionType
  @objc dynamic var sessionType: String? {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "sessionType".hashValue)!
      ) as? String {
        return T
      } else {
        return nil
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "sessionType".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }

  /// 消息是否需要刷新到session服务
  /// 只有消息存离线的情况下，才会判断该参数，默认：是
  // setting => isSessionUpdate
  dynamic var sessionUpdate: Bool {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "sessionUpdate".hashValue)!
      ) as? Bool {
        return T
      } else {
        return true
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "sessionUpdate".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN
      )
    }
  }

  // 群消息已读回执的已读数 => teamReceiptInfo => readCount
  dynamic var ackCount: Int? {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "ackCount".hashValue)!
      ) as? Int {
        return T
      } else {
        return nil
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "ackCount".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN
      )
    }
  }

  // 群消息已读回执的未读数  => teamReceiptInfo => unreadCount
  dynamic var unAckCount: Int? {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "unAckCount".hashValue)!
      ) as? Int {
        return T
      } else {
        return nil
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "unAckCount".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN
      )
    }
  }

  // 命中了客户端反垃圾，服务器处理 => antiSpamOption => hitClientAntispam
  dynamic var clientAntiSpam: Bool? {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "clientAntiSpam".hashValue)!
      ) as? Bool {
        return T
      } else {
        return nil
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "clientAntiSpam".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN
      )
    }
  }
}

// iOS 暂时没有找到相关字段
extension NIMMessage {
  /*
   iOS 无此字段
   Android =>
   消息文本
   消息中除 [IMMessageType.text] 和 [IMMessageType.tip]  外，其他消息 [text] 字段都为 null
   */
  dynamic var content: String? {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "content".hashValue)!
      ) as? String {
        return T
      } else {
        return nil
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "content".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }

  //
  dynamic var uuid: String? {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "uuid".hashValue)!
      ) as? String {
        return T
      } else {
        return nil
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "uuid".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }

  /// 消息的选中状态
  dynamic var isChecked: Bool {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "isChecked".hashValue)!
      ) as? Bool {
        return T
      } else {
        return false
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "isChecked".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN
      )
    }
  }
}

// 转义(类型不同，无法自动映射)
extension NIMMessage {
  dynamic var gArgument: [String: Any]? {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "gArgument".hashValue)!
      ) as? [String: Any]? {
        return T
      } else {
        return nil
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "gArgument".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }

  dynamic var flt_serverId: Int? {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "flt_serverId".hashValue)!
      ) as? Int {
        return T
      } else {
        return nil
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "flt_serverId".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN
      )
    }
  }

  dynamic var flt_status: FLT_NIMMessageStatus? {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "status".hashValue)!
      ) as? FLT_NIMMessageStatus {
        return T
      } else {
        return nil
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "status".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }

  dynamic var flt_messageType: FLT_NIMMessageType? {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "flt_messageType".hashValue)!
      ) as? FLT_NIMMessageType {
        return T
      } else {
        return nil
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "flt_messageType".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }

  dynamic var flt_attachmentDownloadState: FLT_NIMMessageAttachmentDownloadState? {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "flt_attachmentDownloadState".hashValue)!
      ) as? FLT_NIMMessageAttachmentDownloadState {
        return T
      } else {
        return nil
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "flt_attachmentDownloadState".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }

  dynamic var messageDirection: FLT_NIMMessageDirection? {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "messageDirection".hashValue)!
      ) as? FLT_NIMMessageDirection {
        return T
      } else {
        return FLT_NIMMessageDirection.outgoing
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "messageDirection".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }
}

extension NIMMessage {
  dynamic var flt_senderClientType: FLT_NIMLoginClientType? {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "senderClientType".hashValue)!
      ) as? FLT_NIMLoginClientType {
        return T
      } else {
        return nil
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "senderClientType".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }
}

extension NIMMessage {
  // 转换 message json object 为 native message object
  class func convertToMessage(_ arguments: [String: Any]) -> NIMMessage? {
    var target: [String: Any]
    let serviceName = arguments[kFLTNimCoreService] as? String ?? ""
    if serviceName == ServiceType.ChatroomService.rawValue {
      target = arguments["message"] as? [String: Any] ?? [String: Any]()
    } else {
      target = arguments
    }

    if let message = NIMMessage.yx_model(with: target) {
      // 开始转换不对称结构
      message.gArgument = target
      if let type = target["messageType"] as? String,
         let mType = FLT_NIMMessageType(rawValue: type)?.convertToNIMMessageType(),
         let attachment = target["messageAttachment"] as? [String: Any] {
        message.setValue(mType.rawValue, forKeyPath: #keyPath(NIMMessage.messageType))

        switch mType {
        case NIMMessageType.image:
          if let object = NIMImageObject.fromDic(attachment) as? NIMImageObject {
            if let scene = object.value(forKeyPath: "_scene") as? String,
               let nosScene = NIMNosScene(rawValue: scene) {
              let _scene = nosScene.getScene()
              object.setValue(_scene, forKeyPath: "_scene")
            }
            message.messageObject = object
          }

        case NIMMessageType.audio:
          if let object = NIMAudioObject.fromDic(attachment) as? NIMAudioObject {
            if let scene = object.value(forKeyPath: "_scene") as? String,
               let nosScene = NIMNosScene(rawValue: scene) {
              let _scene = nosScene.getScene()
              object.setValue(_scene, forKeyPath: "_scene")
            }
            message.messageObject = object
          }

        case NIMMessageType.video:
          if let object = NIMVideoObject.fromDic(attachment) as? NIMVideoObject {
            if let scene = object.value(forKeyPath: "_scene") as? String,
               let nosScene = NIMNosScene(rawValue: scene) {
              let _scene = nosScene.getScene()
              object.setValue(_scene, forKeyPath: "_scene")
            }
            message.messageObject = object
          }

        case NIMMessageType.file:
          if let object = NIMFileObject.fromDic(attachment) as? NIMFileObject {
            if let scene = object.value(forKeyPath: "_scene") as? String,
               let nosScene = NIMNosScene(rawValue: scene) {
              let _scene = nosScene.getScene()
              object.setValue(_scene, forKeyPath: "_scene")
            }
            message.messageObject = object
          }

        case NIMMessageType.location:
          let location = NIMLocationObject.yx_model(with: attachment)
          if let t = attachment["title"] as? String,
             let lat = attachment["lat"] as? Double,
             let lng = attachment["lng"] as? Double {
            location?.setValue(t, forKeyPath: "title")
            location?.setValue(lat, forKeyPath: #keyPath(NIMLocationObject.latitude))
            location?.setValue(lng, forKeyPath: #keyPath(NIMLocationObject.longitude))
          }
          message.messageObject = location

        case NIMMessageType.custom:
          let customAttachment = NimAttachment(attachment)
          let object = NIMCustomObject()
          object.attachment = customAttachment
          message.messageObject = object

        case NIMMessageType.robot:
          if let object = NIMRobotObject.fromDic(attachment) as? NIMRobotObject {
            message.messageObject = object
          }
        default:
          break
        }
      }
      if let sId = message.flt_serverId {
        message.setValue("\(sId)", forKeyPath: #keyPath(NIMMessage.serverID))
      }
      if let s = message.flt_status?.convertToNIMMessageStatus() {
        message.setValue(s, forKeyPath: #keyPath(NIMMessage.status))
      }
      if let attachemntState = target["attachmentStatus"] as? String,
         let flt_attachmentState =
         FLT_NIMMessageAttachmentDownloadState(rawValue: attachemntState) {
        // iOS IM SDK 源码中是根据多个变量组合返回此变量的值，无法单一赋值
      }

      message.teamReceiptInfo?.setValue(
        message.ackCount,
        forKey: #keyPath(NIMTeamMessageReceipt.readCount)
      )

      message.teamReceiptInfo?.setValue(
        message.unAckCount,
        forKeyPath: #keyPath(NIMTeamMessageReceipt.unreadCount)
      )

      message.antiSpamOption?.setValue(
        message.clientAntiSpam,
        forKeyPath: #keyPath(NIMAntiSpamOption.hitClientAntispam)
      )

      if let sClientType = message.flt_senderClientType?.getNIMLoginClientType() {
        message.setValue(sClientType, forKeyPath: #keyPath(NIMMessage.senderClientType))
      }

      // 把 Flutter 层的 messageThreadOption 子结构 转化到 NIMMessage 的一级结构
      if let threadOptionDic = target["messageThreadOption"] as? [String: Any],
         let messageThreadOption = NIMMessageThreadOption.yx_model(with: threadOptionDic) {
        let keyPaths = NIMMessageThreadOption.getKeyPaths(NIMMessageThreadOption.self)
        keyPaths.forEach { key, value in
          message.setValue(messageThreadOption.value(forKey: key), forKeyPath: key)
        }
      }

      message.setting?.isSessionUpdate = message.sessionUpdate
      if let messageAck = arguments["messageAck"] as? Bool {
        message.setting?.teamReceiptEnabled = messageAck
      }

      if let sessionId = target["sessionId"] as? String,
         let sessionTypeValue = target["sessionType"] as? String,
         let sessionType = try? NIMSessionType.getType(sessionTypeValue) {
        let session = NIMSession(sessionId, type: sessionType)
        message.setValue(session, forKeyPath: #keyPath(NIMMessage.session))
      }

      if let serverId = target["serverId"] as? Int,
         serverId > 0 {
        message.setValue(String(serverId), forKeyPath: #keyPath(NIMMessage.serverID))
      }

      if let fromAccount = target["fromAccount"] as? String {
        message.from = fromAccount
      }

      if let messageSubType = target["messageSubType"] as? Int,
         messageSubType > 0 {
        message.messageSubType = messageSubType
      }

      message.remoteExt = target["remoteExtension"] as? [String: Any]
      message.localExt = target["localExtension"] as? [String: Any]
      if let time = target["timestamp"] as? Int {
        message.timestamp = TimeInterval(Double(time) / 1000)
      }

      if let replyTime = message.value(forKey: "_repliedMessageTime") as? Double {
        message.setValue(replyTime / 1000, forKey: "_repliedMessageTime")
      }
      if let threadMessageTime = message.value(forKey: "_threadMessageTime") as? Double {
        message.setValue(threadMessageTime / 1000, forKey: "_threadMessageTime")
      }

      if let yidunAntiCheating = target["yidunAntiCheating"] as? [String: Any] {
        message.yidunAntiCheating = yidunAntiCheating
      }
      if let yidunAntiSpamRes = target["yidunAntiSpamRes"] as? String {
        message.yidunAntiSpamRes = yidunAntiSpamRes
      }

      if let yidunAntiSpamExt = target["yidunAntiSpamExt"] as? String {
        message.yidunAntiSpamExt = yidunAntiSpamExt
      }

      if let robotInfoMap = target["robotInfo"] as? [String: Any] {
        let robotInfo = NIMMessageRobotInfo()
        robotInfo.function = robotInfoMap["function"] as? String
        robotInfo.account = robotInfoMap["account"] as? String
        robotInfo.customContent = robotInfoMap["customContent"] as? String
        robotInfo.topic = robotInfoMap["topic"] as? String
        message.robotInfo = robotInfo
      }

      return message
    }
    return nil
  }

  /// 根据消息类型转换最后一条消息显示
  /// - Returns: 转换结果
  func convertLastMessage() -> String {
    var text = ""

    switch messageType {
    case .text, .tip:
      if let messageText = self.text {
        text = messageText
      }
    case .image:
      text = "[图片]"
    case .audio:
      text = "[语音]"
    case .video:
      text = "[视频]"
    case .location:
      text = "[位置]"
    case .notification:
      text = "[通知消息]"
    case .file:
      text = "[文件]"
    case .robot:
      text = "[机器人消息]"
    case .rtcCallRecord:
      let record = messageObject as? NIMRtcCallRecordObject
      text = (record?.callType == .audio) ? "音频电话" : "视频电话"
    default:
      text = "[自定义消息]"
    }
    return text
  }

  // 结构转换
  func toDic(_ showYidunAnti: Bool = true) -> [String: Any]? {
    if var arguments = yx_modelToJSONObject() as? [String: Any] {
      if let sid = Int(serverID) {
        arguments["serverId"] = sid
      } else {
        arguments["serverId"] = 0
      }
      arguments["senderClientType"] = FLT_NIMLoginClientType
        .convertClientType(senderClientType)?.rawValue
      arguments["status"] = FLT_NIMMessageStatus.convertFLTStatus(self).rawValue
      arguments["messageType"] = FLT_NIMMessageType.convert(messageType)?.rawValue
      switch messageType {
      case .text, .tip, .custom:
        //  对齐dart: 文本、提醒消息、自定义消息无附件，attachmentStatus 字段对应flutter应该为 initial
        arguments["attachmentStatus"] = FLT_NIMMessageAttachmentDownloadState.initial.rawValue
      default:
        arguments["attachmentStatus"] = FLT_NIMMessageAttachmentDownloadState
          .convertFLTState(attachmentDownloadState)?.rawValue
      }
//      if let subType = NIMMessageType(rawValue: messageSubType) {
//        arguments["messageSubType"] = FLT_NIMMessageType.convert(subType)?.rawValue
//      } else {
//        arguments.removeValue(forKey: "messageSubType")
//      }
      arguments["messageSubType"] = messageSubType

      if let attachment = messageObject as? NSObject {
        if let convert = attachment as? NimDataConvertProtrol {
          var att = convert.toDic()
//          if let attachement = gArgument?["messageAttachment"] as? [String: Any],
//             let size = attachement["size"] as? Int {
//            att?["size"] = size
//          }
          att?["force_upload"] = false
          if let mt = arguments["messageType"] as? String {
            att?["messageType"] = mt
          } else if let messagetype = FLT_NIMMessageType.convert(messageType) {
            att?["messageType"] = messagetype.rawValue
          }
//          if att?["messageType"] as? String == FLT_NIMMessageType.image.rawValue,
//             let image = messageObject as? NIMImageObject {
//            att?["size"] = Int(image.size.width * image.size.height)
//          }
          // messageAttachment返回为空问题修改
          if let location = messageObject as? NIMLocationObject {
            att?["lat"] = location.latitude
            att?["lng"] = location.longitude
            att?["title"] = location.title
          }

          if let robot = messageObject as? NIMRobotObject {
            att?["robotAccid"] = robot.robotId
            att?["target"] = robot.value(forKeyPath: "target")
            att?["param"] = robot.value(forKeyPath: "param")
          }
          if let expire = att?["expire"] as? Int {
            att?["expire"] = expire
          } else {
            att?["expire"] = 0
          }
          if let noscene = att?["sen"] as? String {
            att?["sen"] = NIMNosScene.toDic(scene: noscene)
          }
          if let name = att?["displayName"] as? String {
            att?["name"] = name
          }
          arguments["messageAttachment"] = att
        } else if let object = attachment as? NIMCustomObject,
                  let customObject = object.attachment as? NimAttachment,
                  var data = customObject.data {
          data["messageType"] = "custom"
          arguments["messageAttachment"] = data
        } else if let attachement = gArgument?["messageAttachment"] as? [String: Any],
                  var messageAttachment = attachment
                  .yx_modelToJSONObject() as? [String: Any] {
          if let size = attachement["size"] as? Int {
            messageAttachment["size"] = size
            messageAttachment["messageType"] = arguments["messageType"]
            messageAttachment["force_upload"] = true
          } else {
            messageAttachment["size"] = 0
            messageAttachment["messageType"] = arguments["messageType"]
            messageAttachment["force_upload"] = true
          }
          if let location = messageObject as? NIMLocationObject {
            messageAttachment["lat"] = location.latitude
            messageAttachment["lng"] = location.longitude
            messageAttachment["title"] = location.title
          }
          arguments["messageAttachment"] = messageAttachment
        }
      }
      arguments["yidunAntiSpamRes"] = yidunAntiSpamRes
      arguments["yidunAntiSpamExt"] = yidunAntiSpamExt
      if showYidunAnti,
         let yidunAntiCheatingForMap = yidunAntiCheating as? [String: Any] {
        arguments["yidunAntiCheating"] = yidunAntiCheatingForMap
      } else {
        arguments["yidunAntiCheating"] = nil
      }

      arguments["sessionUpdate"] = setting?.isSessionUpdate ?? true
      arguments["messageAck"] = setting?.teamReceiptEnabled ?? false
      arguments["isChecked"] = isChecked
      arguments["ackCount"] = teamReceiptInfo?.readCount ?? 0
      arguments["unAckCount"] = teamReceiptInfo?.unreadCount ?? 0
      arguments["clientAntiSpam"] = antiSpamOption?.hitClientAntispam ?? false
      arguments["messageThreadOption"] = convertThreadOption(message: self)
      arguments["config"] = convertConfig(setting: setting ?? NIMMessageSetting())

      if let sType = session?.sessionType {
        arguments["sessionType"] = FLT_NIMSessionType.convertFLTSessionType(sType)?.rawValue
      } else if let sType = sessionType {
        arguments["sessionType"] = sType
      }

      if let sessionId = session?.sessionId {
        arguments["sessionId"] = sessionId
      }

      if isReceivedMsg == true {
        arguments["messageDirection"] = FLT_NIMMessageDirection.received.rawValue
      }

      if isOutgoingMsg {
        arguments["messageDirection"] = FLT_NIMMessageDirection.outgoing.rawValue
      }

      if arguments["messageDirection"] == nil, messageDirection != nil {
        arguments["messageDirection"] = messageDirection?.rawValue
      }

      if let timestamp = arguments["timestamp"] as? NSNumber {
        arguments["timestamp"] = Int(timestamp.doubleValue * 1000)
      }

      arguments["fromAccount"] = from

//        // 把 NIMMessage 的一级结构中的 thread 相关转化到 messageThreadOption 子结构
//        let threadKeyPaths = NIMMessageThreadOption.getKeyPaths(NIMMessageThreadOption.self)
//        let threadOption = NIMMessageThreadOption()
//        threadKeyPaths.forEach { key, value in
//          threadOption.setValue(self.value(forKeyPath: key), forKey: key)
//        }
//        arguments["messageThreadOption"] = threadOption.toDic()

      arguments.removeValue(forKey: "flt_messageType")
      arguments.removeValue(forKey: "flt_status")
      arguments.removeValue(forKey: "flt_serverId")
      arguments.removeValue(forKey: "flt_senderClientType")

      // attachmentObject是通知类型的
      if let attachmentObject = messageObject as? NIMNotificationObject {
        arguments["messageAttachment"] = dealNotificationObject(attachmentObject)
      }
      // 聊天室单独处理extension
      if session?.sessionType == .chatroom,
         let ext = messageExt as? NIMMessageChatroomExtension {
        var senderExtension: [String: Any]?
        if let roomExt = ext.roomExt {
          senderExtension = getDictionaryFromJSONString(roomExt)
        }
        arguments["extension"] = [
          "nickname": ext.roomNickname,
          "avatar": ext.roomAvatar,
          "senderExtension": senderExtension,
        ]
      }
      arguments["remoteExtension"] = remoteExt
      arguments["localExtension"] = localExt
      arguments["uuid"] = messageId
      // 兼容SDK层功能，当fromNickname为空时,赋值为消息来源
      if arguments["fromNickname"] == nil {
        arguments["fromNickname"] = from
      }

      // 赋予默认值, 对齐AOS
      if !arguments.keys.contains("quickCommentUpdateTime") {
        arguments["quickCommentUpdateTime"] = 0
      }
      arguments["messageAttachment"] = (arguments["messageAttachment"] != nil) ? arguments["messageAttachment"] : [:]
      arguments["yidunAntiCheating"] = (arguments["yidunAntiCheating"] != nil) ? arguments["yidunAntiCheating"] : [:]
      arguments["yidunAntiSpamRes"] = (arguments["yidunAntiSpamRes"] != nil) ? arguments["yidunAntiSpamRes"] : ""
      arguments["extension"] = (arguments["extension"] != nil) ? arguments["extension"] : [:]
      arguments["pushContent"] = (arguments["pushContent"] != nil) ? arguments["pushContent"] : ""

      // chat room
      if session?.sessionType == .chatroom {
        if let historyEnabled = setting?.historyEnabled {
          arguments["enableHistory"] = historyEnabled
        }
      }
      if let info = robotInfo {
        arguments["robotInfo"] = convertRobotInfo(robotInfo: info)
      }
      return arguments
    }
    return nil
  }

  func convertRobotInfo(robotInfo: NIMMessageRobotInfo) -> [String: Any] {
    var robotInfoMap = [String: Any]()
    robotInfoMap["topic"] = robotInfo.topic
    robotInfoMap["account"] = robotInfo.account
    robotInfoMap["function"] = robotInfo.function
    robotInfoMap["customContent"] = robotInfo.customContent
    return robotInfoMap
  }

  func convertThreadOption(message: NIMMessage) -> [String: Any] {
    var threadOption = [String: Any]()
    threadOption["replyMessageFromAccount"] = repliedMessageFrom ?? ""
    threadOption["replyMessageToAccount"] = repliedMessageTo ?? ""
    threadOption["replyMessageTime"] = Int(repliedMessageTime * 1000)
    threadOption["replyMessageIdServer"] = Int(repliedMessageServerId ?? "0") ?? 0
    threadOption["replyMessageIdClient"] = repliedMessageId ?? ""
    threadOption["threadMessageFromAccount"] = threadMessageFrom ?? ""
    threadOption["threadMessageToAccount"] = threadMessageTo ?? ""
    threadOption["threadMessageTime"] = Int(threadMessageTime * 1000)
    threadOption["threadMessageIdServer"] = Int(threadMessageServerId ?? "0") ?? 0
    threadOption["threadMessageIdClient"] = threadMessageId ?? ""
    return threadOption
  }

  func convertConfig(setting: NIMMessageSetting) -> [String: Any] {
    var config = [String: Any]()
    config["enableUnreadCount"] = setting.shouldBeCounted
    config["enableRoaming"] = setting.roamingEnabled
    config["enableSelfSync"] = setting.syncEnabled
    config["enablePushNick"] = setting.apnsWithPrefix
    config["enableHistory"] = setting.historyEnabled
    config["enablePersist"] = setting.persistEnable
    config["enableRoute"] = setting.routeEnabled
    config["enablePush"] = setting.apnsEnabled
    return config
  }

  func dealNotificationObject(_ object: NIMNotificationObject) -> [String: Any] {
    var target = [String: Any]()
    switch object.notificationType {
    case .chatroom:
      if let chatroomNotify = object.content as? NIMChatroomNotificationContent {
        target["type"] = chatroomNotify.eventType.rawValue
        if let targets = chatroomNotify.targets {
          target["targets"] = targets.compactMap { member in
            member.userId
          }
          target["targetNicks"] = targets.compactMap { member in
            member.nick
          }
        }
        target["operator"] = chatroomNotify.source?.userId
        target["operatorNick"] = chatroomNotify.source?.nick
        if let roomExt = chatroomNotify.notifyExt {
          target["extension"] = getDictionaryFromJSONString(roomExt)
        }
        target["messageType"] = "notification"
        if chatroomNotify.eventType == .enter {
          if let obj = chatroomNotify.ext as? [String: Any] {
            target["muted"] = obj[NIMChatroomEventInfoMutedKey]
            target["tempMuted"] = obj[NIMChatroomEventInfoTempMutedKey]
            target["tempMutedDuration"] =
              Int(obj[NIMChatroomEventInfoTempMutedDurationKey] as? Double ?? 0)
          }
        } else if chatroomNotify.eventType == .addMuteTemporarily ||
          chatroomNotify.eventType == .removeMuteTemporarily {
          if let obj = chatroomNotify.ext as? Int {
            target["duration"] = obj
          }
        } else if chatroomNotify.eventType == .queueChange {
          if let obj = chatroomNotify.ext as? [String: Any] {
            target["key"] = obj[NIMChatroomEventInfoQueueChangeItemKey]
            target["content"] = obj[NIMChatroomEventInfoQueueChangeItemValueKey]
            target["contentMap"] = obj[NIMChatroomEventInfoQueueChangeItemsKey]
            if let queueChangeType = obj[
              NIMChatroomEventInfoQueueChangeTypeKey
            ] as? Int,
              let roomChangeQueueType =
              NIMChatroomQueueChangeType(rawValue: queueChangeType) {
              let flt_Type = FLT_NIMChatroomQueueChangeType
                .convert(roomChangeQueueType)
              target["queueChangeType"] = flt_Type.rawValue
            } else {
              target["queueChangeType"] = FLT_NIMChatroomQueueChangeType.undefined
                .rawValue
            }
          }
        } else if chatroomNotify.eventType == .queueBatchChange {
          if let obj = chatroomNotify.ext as? [String: Any] {
            target["contentMap"] = obj[NIMChatroomEventInfoQueueChangeItemsKey]
            if let queueChangeType = obj[
              NIMChatroomEventInfoQueueChangeTypeKey
            ] as? Int,
              let roomChangeQueueType =
              NIMChatroomQueueChangeType(rawValue: queueChangeType) {
              let flt_Type = FLT_NIMChatroomQueueChangeType
                .convert(roomChangeQueueType)
              target["queueChangeType"] = flt_Type.rawValue
            } else {
              target["queueChangeType"] = FLT_NIMChatroomQueueChangeType.undefined
                .rawValue
            }
          }
        }
      }
    case .superTeam:
      if let superTeamNotify = object.content as? NIMSuperTeamNotificationContent {
        target["type"] = superTeamNotify.operationType.rawValue
        target["messageType"] = "notification"
        target["extension"] = superTeamNotify.notifyExt
        if superTeamNotify.operationType == .dismiss ||
          superTeamNotify.operationType == .leave {
          // 无特殊字段
        } else if superTeamNotify.operationType == .mute {
          if let muteMember = superTeamNotify.attachment as? NIMMuteTeamMemberAttachment {
            target["mute"] = muteMember.flag
            target["targets"] = superTeamNotify.targetIDs
          }
        } else if superTeamNotify.operationType == .update {
          if let updateTeamInfo = superTeamNotify
            .attachment as? NIMUpdateTeamInfoAttachment {
            target["updatedFields"] = dealUpdateTeamInfoAttachment(updateTeamInfo, true)
          }
        } else if superTeamNotify.operationType == .invite ||
          superTeamNotify.operationType == .kick ||
          superTeamNotify.operationType == .applyPass ||
          superTeamNotify.operationType == .leave ||
          superTeamNotify.operationType == .transferOwner ||
          superTeamNotify.operationType == .addManager ||
          superTeamNotify.operationType == .removeManager ||
          superTeamNotify.operationType == .acceptInvitation {
          target["targets"] = superTeamNotify.targetIDs
        }
      }
    case .team:
      if let teamNotify = object.content as? NIMTeamNotificationContent {
        target["type"] = teamNotify.operationType.rawValue
        target["messageType"] = "notification"
        target["extension"] = teamNotify.notifyExt
        if teamNotify.operationType == .dismiss ||
          teamNotify.operationType == .leave {
          // 无特殊字段
        } else if teamNotify.operationType == .mute {
          if let muteMember = teamNotify.attachment as? NIMMuteTeamMemberAttachment {
            target["mute"] = muteMember.flag
            target["targets"] = teamNotify.targetIDs
          }
        } else if teamNotify.operationType == .update {
          if let updateTeamInfo = teamNotify.attachment as? NIMUpdateTeamInfoAttachment {
            target["updatedFields"] = dealUpdateTeamInfoAttachment(updateTeamInfo,
                                                                   false)
          }
        } else if teamNotify.operationType == .invite ||
          teamNotify.operationType == .kick ||
          teamNotify.operationType == .applyPass ||
          teamNotify.operationType == .leave ||
          teamNotify.operationType == .transferOwner ||
          teamNotify.operationType == .addManager ||
          teamNotify.operationType == .removeManager ||
          teamNotify.operationType == .acceptInvitation {
          target["targets"] = teamNotify.targetIDs
        }
      }
    case .netCall:
      if let callNotify = object.content as? NIMNetCallNotificationContent {}
    case .unsupport:
      if let unsupportNotify = object.content as? NIMUnsupportedNotificationContent {}
    default:
      break
    }
    return target
  }

  func dealUpdateTeamInfoAttachment(_ updateTeamInfo: NIMUpdateTeamInfoAttachment,
                                    _ isSuperTeam: Bool) -> [String: String] {
    if updateTeamInfo.values != nil {
      var newDic = [String: String]()
      updateTeamInfo.values!.forEach { (key: NSNumber, value: String) in
        if !isSuperTeam,
           let type = NIMTeamUpdateTag(rawValue: key.intValue),
           let fltKey = FLT_NIMTeamUpdateTag.convert(type)?.rawValue {
          if type == NIMTeamUpdateTag.beInviteMode,
             let intValue = Int(value) {
            newDic[fltKey] = FLT_NIMTeamBeInviteMode
              .convert(NIMTeamBeInviteMode(rawValue: intValue) ?? .noAuth)?.rawValue
          } else if type == NIMTeamUpdateTag.inviteMode,
                    let intValue = Int(value) {
            newDic[fltKey] = FLT_NIMTeamInviteMode
              .convert(NIMTeamInviteMode(rawValue: intValue) ?? .manager)?.rawValue
          } else if type == NIMTeamUpdateTag.joinMode,
                    let intValue = Int(value) {
            newDic[fltKey] = FLT_NIMTeamJoinMode
              .convert(NIMTeamJoinMode(rawValue: intValue) ?? .noAuth)?.rawValue
          } else if type == NIMTeamUpdateTag.muteMode,
                    let intValue = Int(value) {
            newDic["updatedAllMuteMode"] = intValue == 0 ? "cancel" : "muteAll"
          } else if type == NIMTeamUpdateTag.updateInfoMode,
                    let intValue = Int(value) {
            newDic[fltKey] = FLT_NIMTeamUpdateInfoMode
              .convert(NIMTeamUpdateInfoMode(rawValue: intValue) ?? .manager)?.rawValue
          } else if type == NIMTeamUpdateTag.updateClientCustomMode,
                    let intValue = Int(value) {
            newDic[fltKey] = FLT_NIMTeamUpdateClientCustomMode
              .convert(NIMTeamUpdateClientCustomMode(rawValue: intValue) ?? .manager)?
              .rawValue
          } else {
            newDic[fltKey] = value
          }
        } else if isSuperTeam,
                  let type = NIMSuperTeamUpdateTag(rawValue: key.intValue),
                  let fltKey = FLT_NIMSuperTeamUpdateTag.convert(type)?.rawValue {
          if type == NIMSuperTeamUpdateTag.beInviteMode,
             let intValue = Int(value) {
            newDic[fltKey] = FLT_NIMTeamBeInviteMode
              .convert(NIMTeamBeInviteMode(rawValue: intValue) ?? .noAuth)?.rawValue
          } else if type == NIMSuperTeamUpdateTag.joinMode,
                    let intValue = Int(value) {
            newDic[fltKey] = FLT_NIMTeamJoinMode
              .convert(NIMTeamJoinMode(rawValue: intValue) ?? .noAuth)?.rawValue
          } else if type == NIMSuperTeamUpdateTag.muteMode,
                    let intValue = Int(value) {
            newDic["updatedAllMuteMode"] = intValue == 0 ? "cancel" : "muteAll"
          } else {
            newDic[fltKey] = value
          }
        }
      }
      return newDic
    }
    return [String: String]()
  }

  func getSetting() -> NIMMessageSetting {
    if let s = setting {
      return s
    }
    let set = NIMMessageSetting()
    setValue(set, forKeyPath: #keyPath(setting))
    return set
  }

  @objc static func modelPropertyBlacklist() -> [String] {
    [#keyPath(NIMMessage.messageObject),
     #keyPath(NIMMessage.messageExt),
     #keyPath(NIMMessage.localExt)]
  }

  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = getKeyPaths(self)
    // flutter => remoteExtension  iOS => NIMMessageChatroomExtension
    keyPaths
      .removeValue(forKey: #keyPath(NIMMessage.messageExt))
    // flutter => localExtension ios => NSDictinary
    keyPaths
      .removeValue(forKey: #keyPath(NIMMessage.localExt))
    keyPaths[#keyPath(NIMMessage.from)] = "fromAccount"
    keyPaths[#keyPath(NIMMessage.senderName)] = "fromNickname"
    keyPaths[#keyPath(NIMMessage.setting)] = "config"
    keyPaths[#keyPath(NIMMessage.callbackExt)] = "callbackExtension"
    keyPaths[#keyPath(NIMMessage.apnsContent)] = "pushContent"
    keyPaths[#keyPath(NIMMessage.apnsMemberOption)] = "memberPushOption"
    keyPaths[#keyPath(NIMMessage.apnsPayload)] = "pushPayload"
    keyPaths[#keyPath(NIMMessage.isTeamReceiptSended)] = "hasSendAck"
    keyPaths[#keyPath(NIMMessage.isBlackListed)] = "isInBlackList"
    keyPaths[#keyPath(NIMMessage.text)] = "content"

    // runtime无法抓取key值后续优化
    keyPaths["messageDirection"] = "messageDirection"
    keyPaths["sessionId"] = "sessionId"
    keyPaths["sessionType"] = "sessionType"

    keyPaths["flt_senderClientType"] = #keyPath(NIMMessage.senderClientType)
    keyPaths["flt_serverId"] = #keyPath(NIMMessage.serverID)
    keyPaths["flt_status"] = #keyPath(NIMMessage.status)
    keyPaths["flt_messageType"] = #keyPath(NIMMessage.messageType)
    return keyPaths
  }
}

extension NIMMessageChatroomExtension {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    let keyPaths = getKeyPaths(self)
    return keyPaths
  }
}

extension NIMMessageSetting {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [#keyPath(NIMMessageSetting.apnsEnabled): "enablePush",
     #keyPath(NIMMessageSetting.apnsWithPrefix): "enablePushNick",
     #keyPath(NIMMessageSetting.historyEnabled): "enableHistory",
     #keyPath(NIMMessageSetting.roamingEnabled): "enableRoaming",
     #keyPath(NIMMessageSetting.syncEnabled): "enableSelfSync",
     #keyPath(NIMMessageSetting.shouldBeCounted): "enableUnreadCount",
     #keyPath(NIMMessageSetting.routeEnabled): "enableRoute",
     #keyPath(NIMMessageSetting.teamReceiptEnabled): "enableTeamReceipt",
     #keyPath(NIMMessageSetting.persistEnable): "enablePersist",
     #keyPath(NIMMessageSetting.scene): "scene",
     #keyPath(NIMMessageSetting.isSessionUpdate): "enableSessionUpdate"]
  }
}

extension NIMMessageApnsMemberOption {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = getKeyPaths(self)
    keyPaths[#keyPath(NIMMessageApnsMemberOption.userIds)] = "forcePushList"
    keyPaths[#keyPath(NIMMessageApnsMemberOption.forcePush)] = "isForcePush"
    keyPaths[#keyPath(NIMMessageApnsMemberOption.apnsContent)] = "forcePushContent"
    return keyPaths
  }
}

extension NIMGetMessagesDynamicallyParam {
  class func convertToParam(_ arguments: [String: Any]) -> NIMGetMessagesDynamicallyParam? {
    if let sessionId = arguments["sessionId"] as? String,
       let sessionTypeValue = arguments["sessionType"] as? String,
       let sessionType = try? NIMSessionType.getType(sessionTypeValue) {
      let session = NIMSession(sessionId, type: sessionType)
      let param = NIMGetMessagesDynamicallyParam()
      param.session = session
      if let fromTime = arguments["fromTime"] as? Int {
        param.startTime = TimeInterval(Double(fromTime) / 1000)
      }
      if let toTime = arguments["toTime"] as? Int {
        param.endTime = TimeInterval(Double(toTime) / 1000)
      }
      if let anchorServerId = arguments["anchorServerId"] as? Int {
        param.anchorServerId = String(anchorServerId)
      }
      if let anchorClientId = arguments["anchorClientId"] as? String {
        param.anchorClientId = anchorClientId
      }
      if let limit = arguments["limit"] as? UInt {
        param.limit = limit
      }
      if let directionStr = arguments["direction"] as? String {
        if directionStr == "forward" {
          param.order = NIMMessageSearchOrder.desc
        } else {
          param.order = NIMMessageSearchOrder.asc
        }
      }
      return param
    }
    return nil
  }
}

extension NIMAntiSpamOption {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = getKeyPaths(self)
    keyPaths[#keyPath(NIMAntiSpamOption.yidunEnabled)] = "enable"
    keyPaths[#keyPath(NIMAntiSpamOption.businessId)] = "antiSpamConfigId"
    return keyPaths
  }
}

extension NIMImageObject: NimDataConvertProtrol {
  func convertVar() -> [String: String] {
    ["_scene": "sen", "_fileLength": "size", "_sourceFilepath": "path"]
  }

  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      extensionIvaToJson(&jsonObject, NIMImageObject.self)
//      jsonObject["size"] = Int(size.height * size.width)
      jsonObject["w"] = Int(size.width)
      jsonObject["h"] = Int(size.height)
      jsonObject["hash"] = md5
      if let p = path {
        jsonObject["path"] = p
      }
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMImageObject.yx_model(with: json) {
      model.extensionModelIva(json, NIMImageObject.self)
      return model
    }
    return nil
  }

  @objc static func modelPropertyBlacklist() -> [String] {
    [#keyPath(NIMImageObject.message), #keyPath(NIMImageObject.size)]
  }

  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = getKeyPaths(self)
    keyPaths[#keyPath(NIMImageObject.thumbUrl)] = "thumbUrl"
    keyPaths[#keyPath(NIMImageObject.thumbPath)] = "thumbPath"
    keyPaths[#keyPath(NIMImageObject.displayName)] = "name"
    return keyPaths
  }
}

extension NIMAudioObject: NimDataConvertProtrol {
  func convertVar() -> [String: String] {
    ["_scene": "sen", "_fileLength": "size", "_sourcePath": "path"]
  }

  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      extensionIvaToJson(&jsonObject, NIMAudioObject.self)
      if let p = path {
        jsonObject["path"] = p
      }
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMAudioObject.yx_model(with: json) {
      model.extensionModelIva(json, NIMAudioObject.self)
      if let path = json["path"] as? String {
        model.setValue(path, forKey: "_sourcePath")
      }
      return model
    }
    return nil
  }

  @objc static func modelPropertyBlacklist() -> [String] {
    [#keyPath(NIMAudioObject.message)]
  }

  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = getKeyPaths(self)
    keyPaths[#keyPath(NIMAudioObject.duration)] = "dur"
    keyPaths[#keyPath(NIMAudioObject.displayName)] = "name"
    return keyPaths
  }
}

extension NIMRobotObject: NimDataConvertProtrol {
  @objc static func modelPropertyBlacklist() -> [String] {
    [#keyPath(NIMRobotObject.message)]
  }

  func toDic() -> [String: Any]? {
    if let jsonObject = yx_modelToJSONObject() as? [String: Any] {
      //            extensionIvaToJson(&jsonObject, NIMFileObject.self)
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let robotID = json["robotAccid"] as? String,
       let target = json["target"] as? String,
       let param = json["param"] as? String {
      return NIMRobotObject(robotId: robotID, target: target, param: param)
    }
    return nil
  }
}

extension NIMFileObject: NimDataConvertProtrol {
  func convertVar() -> [String: String] {
    ["_scene": "sen", "_fileLength": "size", "_sourceFilepath": "path"]
  }

  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      extensionIvaToJson(&jsonObject, NIMFileObject.self)
      if !jsonObject.keys.contains("path") {
        jsonObject["path"] = path
      }

      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMFileObject.yx_model(with: json) {
      model.extensionModelIva(json, NIMFileObject.self)
      return model
    }
    return nil
  }

  @objc static func modelPropertyBlacklist() -> [String] {
    [#keyPath(NIMFileObject.message)]
  }

  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = getKeyPaths(self)
    keyPaths[#keyPath(NIMFileObject.fileLength)] = "size"
    keyPaths[#keyPath(NIMFileObject.displayName)] = "name"
    return keyPaths
  }
}

extension NIMVideoObject: NimDataConvertProtrol {
  func convertVar() -> [String: String] {
    ["_scene": "sen", "_fileLength": "size", "_sourcePath": "path"]
  }

  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      extensionIvaToJson(&jsonObject, NIMVideoObject.self)
      jsonObject["w"] = Int(coverSize.width)
      jsonObject["h"] = Int(coverSize.height)
      if jsonObject["thumbPath"] == nil {
        jsonObject["thumbPath"] = ""
      }
      if let p = path {
        jsonObject["path"] = p
      }
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMVideoObject.yx_model(with: json) {
      model.extensionModelIva(json, NIMVideoObject.self)
      if let w = json["w"] as? Double,
         let h = json["h"] as? Double {
        model.setValue(CGSize(width: w, height: h), forKeyPath: #keyPath(NIMVideoObject.coverSize))
      }
      return model
    }
    return nil
  }

  @objc static func modelPropertyBlacklist() -> [String] {
    [#keyPath(NIMVideoObject.message)]
  }

  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = getKeyPaths(self)
    keyPaths[#keyPath(NIMVideoObject.duration)] = "dur"
    keyPaths[#keyPath(NIMVideoObject.fileLength)] = "size"
    keyPaths[#keyPath(NIMVideoObject.coverUrl)] = "thumbUrl"
    keyPaths[#keyPath(NIMVideoObject.coverPath)] = "thumbPath"
    keyPaths[#keyPath(NIMVideoObject.displayName)] = "name"
    return keyPaths
  }
}

extension NIMNotificationObject: NimDataConvertProtrol {
  func toDic() -> [String: Any]? {
    var jsonObject = [String: Any]()
    extensionIvaToJson(&jsonObject, NIMNotificationObject.self)
    jsonObject["type"] = notificationType.rawValue
    return jsonObject
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMNotificationObject.yx_model(with: json) {
      model.extensionModelIva(json, NIMNotificationObject.self)
      return model
    }
    return nil
  }
}

extension NIMRtcCallRecordObject: NimDataConvertProtrol {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      extensionIvaToJson(&jsonObject, NIMRtcCallRecordObject.self)
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMNotificationObject.yx_model(with: json) {
      model.extensionModelIva(json, NIMRtcCallRecordObject.self)
      return model
    }
    return nil
  }
}

extension NIMLocationObject: NimDataConvertProtrol {
  func toDic() -> [String: Any]? {
    if let jsonObject = yx_modelToJSONObject() as? [String: Any] {
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMLocationObject.yx_model(with: json) {
      return model
    }
    return nil
  }

  @objc static func modelPropertyBlacklist() -> [String] {
    [#keyPath(NIMLocationObject.message)]
  }

  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = getKeyPaths(self)
    keyPaths[#keyPath(NIMLocationObject.latitude)] = "lat"
    keyPaths[#keyPath(NIMLocationObject.longitude)] = "lng"
    keyPaths[#keyPath(NIMLocationObject.title)] = "title"
    return keyPaths
  }
}

extension NIMRevokeMessageNotification {
  func toDic() -> [String: Any] {
    var dic = [String: Any]()
    dic["message"] = message?.toDic()
    dic["attach"] = attach
    dic["revokeAccount"] = messageFromUserId
    dic["customInfo"] = postscript
    if offline {
      dic["notificationType"] = 1
    } else {
      dic["notificationType"] = roaming ? 2 : 0
    }
    dic["callbackExt"] = callbackExt
    switch notificationType {
    case .P2P:
      dic["revokeType"] = "p2pDeleteMsg"
    case .team:
      dic["revokeType"] = "teamDeleteMsg"
    case .superTeam:
      dic["revokeType"] = "superTeamDeleteMsg"
    case .p2POneWay:
      dic["revokeType"] = "p2pOneWayDeleteMsg"
    case .teamOneWay:
      dic["revokeType"] = "teamOneWayDeleteMsg"
    default:
      dic["revokeType"] = "undefined"
    }
    return dic
  }
}

class NimAttachment: NSObject, NIMCustomAttachment {
  @objc static func modelPropertyBlacklist() -> [String] {
    ["message"]
  }

  var data: [String: Any]?

  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    let keyPaths = getKeyPaths(self)
    return keyPaths
  }

  init(_ jsonDic: [String: Any]?) {
    super.init()
    data = jsonDic
  }

  func encode() -> String {
    if let jsonObject = data {
      if let jsonData = try? JSONSerialization.data(
        withJSONObject: jsonObject,
        options: .prettyPrinted
      ), let json = String(data: jsonData, encoding: .utf8) {
        return json
      }
    }
    return ""
  }
}

extension NIMTeamMessageReceiptDetail {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = getKeyPaths(self)
    keyPaths[#keyPath(NIMTeamMessageReceiptDetail.messageId)] = "msgId"
    keyPaths[#keyPath(NIMTeamMessageReceiptDetail.sessionId)] = "teamId"
    keyPaths[#keyPath(NIMTeamMessageReceiptDetail.readUserIds)] = "ackAccountList"
    keyPaths[#keyPath(NIMTeamMessageReceiptDetail.unreadUserIds)] = "unAckAccountList"
    return keyPaths
  }

  func toDic() -> [String: Any]? {
    if var dic = yx_modelToJSONObject() as? [String: Any] {
      dic["ackCount"] = readUserIds.count
      dic["unAckCount"] = unreadUserIds.count
      return dic
    }
    return nil
  }
}

extension NIMBroadcastMessage {
  func toDic() -> [String: Any] {
    var dic = [String: Any]()
    dic["id"] = broadcastId
    dic["fromAccount"] = sender
    dic["time"] = Int(timestamp * 1000)
    dic["content"] = content
    return dic
  }
}

class NIMCustomAttachmentDecoder: NSObject, NIMCustomAttachmentCoding {
  func decodeAttachment(_ content: String?) -> NIMCustomAttachment? {
    var attachment: NIMCustomAttachment?
    if let data = content, let dict = getDictionaryFromJSONString(data) {
      attachment = NimAttachment(dict)
    }
    return attachment
  }
}

extension NIMMessageReceipt {
  func toDic() -> [String: Any] {
    var dic = [String: Any]()
    if session?.sessionType == NIMSessionType.P2P {
      dic["sessionId"] = session?.sessionId
      dic["time"] = Int(timestamp * 1000)
    } else if session?.sessionType == NIMSessionType.team {
      dic["messageId"] = messageId
      dic["ackCount"] = teamReceiptInfo.readCount
      dic["unAckCount"] = teamReceiptInfo.unreadCount
      dic["newReaderAccount"] = teamReceiptInfo.readerAccount
    }
    return dic
  }
}

extension NIMMessageSearchOption {
  static func fromDic(_ json: [String: Any]) -> NIMMessageSearchOption {
    if let model = NIMMessageSearchOption.yx_model(with: json) {
      if let msgTypeList = json["msgTypeList"] as? [String] {
        model.messageTypes = msgTypeList.compactMap { type in
          NSNumber(value: (try! NIMMessageType.getType(type) ?? NIMMessageType.text)
            .rawValue)
        }
      }
      model.order = json["order"] as? Int == 1 ? NIMMessageSearchOrder
        .asc : NIMMessageSearchOrder.desc

      if let startTime = json["startTime"] as? Int {
        model.startTime = TimeInterval(Double(startTime) / 1000)
      }
      if let endTime = json["endTime"] as? Int {
        model.endTime = TimeInterval(Double(endTime) / 1000)
      }

      return model
    }
    return NIMMessageSearchOption()
  }
}

extension NIMChatExtendBasicInfo {
  static func fromDic(_ json: [String: Any]) -> NIMChatExtendBasicInfo? {
    if let model = NIMChatExtendBasicInfo.yx_model(with: json) {
      if let sessionTypeValue = json["sessionType"] as? String,
         let sessionType = try? NIMSessionType.getType(sessionTypeValue) {
        model.type = sessionType
      }
      if let fromAccount = json["fromAccount"] as? String {
        model.fromAccount = fromAccount
      }
      if let toAccount = json["toAccount"] as? String {
        model.toAccount = toAccount
      }
      if let time = json["time"] as? Int64 {
        model.timestamp = TimeInterval(Double(time) / 1000)
      }
      if let serverId = json["serverId"] as? Int64 {
        model.serverID = String(serverId)
      }
      if let uuid = json["uuid"] as? String {
        model.messageID = uuid
      }
      return model
    }
    return nil
  }
}

extension NIMMessageFullKeywordSearchOption {
  static func fromDic(_ json: [String: Any]) -> NIMMessageFullKeywordSearchOption? {
    if let model = NIMMessageFullKeywordSearchOption.yx_model(with: json) {
      if let fromTime = json["fromTime"] as? Int {
        model.startTime = TimeInterval(Double(fromTime) / 1000)
      }
      if let toTime = json["toTime"] as? Int {
        model.endTime = TimeInterval(Double(toTime) / 1000)
      }
      if let p2pList = json["p2pList"] as? [String] {
        model.p2pArray = p2pList
      }
      if let teamList = json["teamList"] as? [String] {
        model.teamArray = teamList
      }
      if let senderList = json["senderList"] as? [String] {
        model.senderArray = senderList
      }
      if let msgTypeList = json["msgTypeList"] as? [String] {
        var msgTypeArray = [Int]()
        for s in msgTypeList {
          if let messageType = try? NIMMessageType.getType(s) {
            msgTypeArray.append(messageType.rawValue)
          }
        }
        model.msgTypeArray = msgTypeArray
      }
      if let msgSubtypeList = json["msgSubtypeList"] as? [Int] {
        model.msgSubtypeArray = msgSubtypeList
      }
      return model
    }
    return nil
  }
}

extension NIMLocalAntiSpamCheckResult {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["content"] = content
      jsonObject["operator"] = (type.rawValue > 3) ? 0 : type.rawValue
      return jsonObject
    }
    return nil
  }
}
