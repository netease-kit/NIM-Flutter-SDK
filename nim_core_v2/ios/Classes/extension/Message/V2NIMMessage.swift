// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK
import ObjectiveC.runtime

private let nimMessageIOSSerialKey = "iosSerial"
private let nimMessageIOSSerialLegacyCacheKey = "_iosMessageCacheKey"
private let nimMessageIOSSerialTopicReferKey = "_topicRefer"

private func nimSetObjectValue(_ value: AnyObject?,
                               forIvarNames ivarNames: [String],
                               object: AnyObject) -> Bool {
  var cls: AnyClass? = type(of: object)
  while let currentClass = cls, currentClass != NSObject.self {
    for ivarName in ivarNames {
      if let ivar = class_getInstanceVariable(currentClass, ivarName) {
        object_setIvar(object, ivar, value)
        return true
      }
    }
    cls = class_getSuperclass(currentClass)
  }
  return false
}

private func nimApplyIOSSerial(_ value: Any?, to message: V2NIMMessage) {
  guard let iosSerial = value as? [String: Any] else {
    return
  }

  var serialValues = iosSerial
  serialValues.removeValue(forKey: nimMessageIOSSerialLegacyCacheKey)
  serialValues.removeValue(forKey: nimMessageIOSSerialTopicReferKey)
  if !serialValues.isEmpty {
    _ = message.yx_modelSet(with: serialValues)
  }

  if let topicReferDic = iosSerial[nimMessageIOSSerialTopicReferKey] as? [String: Any] {
    let topicRefer = V2NIMTopicRefer.fromDic(topicReferDic)
    _ = nimSetObjectValue(topicRefer,
                          forIvarNames: ["_topicRefer", "topicRefer"],
                          object: message)
  }
}

private func nimMessageIOSSerial(from message: V2NIMMessage,
                                 exposedKeys: Set<String>) -> [String: Any]? {
  var iosSerial = (message.yx_modelToJSONObject() as? [String: Any]) ?? [:]
  for key in exposedKeys {
    iosSerial.removeValue(forKey: key)
  }

  if let topicRefer = message.topicRefer?.toDic() {
    iosSerial[nimMessageIOSSerialTopicReferKey] = topicRefer
  }

  return iosSerial.isEmpty ? nil : iosSerial
}

extension V2NIMMessage {
  /// 转换 message json object 为 native message object
  static func fromDict(_ arguments: [String: Any]) -> V2NIMMessage {
    let refer = super.fromDic(arguments)
    let message = V2NIMMessage()
    nimApplyIOSSerial(arguments[nimMessageIOSSerialKey], to: message)

    message.senderId = refer.senderId
    message.receiverId = refer.receiverId
    message.messageClientId = refer.messageClientId
    message.messageServerId = refer.messageServerId
    message.conversationType = refer.conversationType
    message.conversationId = refer.conversationId
    message.createTime = refer.createTime

    if let isSelf = arguments["isSelf"] as? Bool {
      message.setValue(isSelf,
                       forKeyPath: #keyPath(V2NIMMessage.isSelf))
    }

    if let serialId = arguments["serialId"] as? Int {
      message.setValue(serialId,
                       forKeyPath: "serialId")
    }

    if let subStatus = arguments["subStatus"] as? Int {
      message.setValue(subStatus,
                       forKeyPath: "subStatus")
    }

    if let attachmentUploadState = arguments["attachmentUploadState"] as? Int {
      message.setValue(attachmentUploadState,
                       forKeyPath: #keyPath(V2NIMMessage.attachmentUploadState))
    }

    if let sendingState = arguments["sendingState"] as? Int {
      message.setValue(sendingState,
                       forKeyPath: #keyPath(V2NIMMessage.sendingState))
    }

    if let type = arguments["messageType"] as? Int,
       let messageType = V2NIMMessageType(rawValue: type) {
      message.messageType = messageType
    }

    if let subType = arguments["subType"] as? Int {
      message.subType = subType
    }

    if let text = arguments["text"] as? String {
      message.text = text
    }

    if let attachment = arguments["attachment"] as? [String: Any],
       let type = arguments["messageType"] as? Int,
       let messageType = V2NIMMessageType(rawValue: type) {
      switch messageType {
      case .MESSAGE_TYPE_AUDIO:
        message.attachment = V2NIMMessageAudioAttachment.fromDictionary(attachment)
      case .MESSAGE_TYPE_FILE:
        message.attachment = V2NIMMessageFileAttachment.fromDict(attachment)
      case .MESSAGE_TYPE_IMAGE:
        message.attachment = V2NIMMessageImageAttachment.fromDictionary(attachment)
      case .MESSAGE_TYPE_VIDEO:
        message.attachment = V2NIMMessageVideoAttachment.fromDictionary(attachment)
      case .MESSAGE_TYPE_LOCATION:
        message.attachment = V2NIMMessageLocationAttachment.fromDict(attachment)
      case .MESSAGE_TYPE_NOTIFICATION:
        message.attachment = V2NIMMessageNotificationAttachment.fromDict(attachment)
      case .MESSAGE_TYPE_CALL:
        message.attachment = V2NIMMessageCallAttachment.fromDict(attachment)
      default:
        message.attachment = V2NIMMessageAttachment.fromDic(attachment)
      }
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      message.serverExtension = serverExtension
    }

    if let localExtension = arguments["localExtension"] as? String {
      message.localExtension = localExtension
    }

    if let callbackExtension = arguments["callbackExtension"] as? String {
      message.setValue(callbackExtension,
                       forKeyPath: #keyPath(V2NIMMessage.callbackExtension))
    }

    if let messageConfig = arguments["messageConfig"] as? [String: Any] {
      message.setValue(V2NIMMessageConfig.fromDic(messageConfig),
                       forKeyPath: #keyPath(V2NIMMessage.messageConfig))
    }

    if let pushConfig = arguments["pushConfig"] as? [String: Any] {
      message.setValue(V2NIMMessagePushConfig.fromDic(pushConfig),
                       forKeyPath: #keyPath(V2NIMMessage.pushConfig))
    }

    if let routeConfig = arguments["routeConfig"] as? [String: Any] {
      message.setValue(V2NIMMessageRouteConfig.fromDic(routeConfig),
                       forKeyPath: #keyPath(V2NIMMessage.routeConfig))
    }

    if let antispamConfig = arguments["antispamConfig"] as? [String: Any] {
      message.setValue(V2NIMMessageAntispamConfig.fromDic(antispamConfig),
                       forKeyPath: #keyPath(V2NIMMessage.antispamConfig))
    }

    if let robotConfig = arguments["robotConfig"] as? [String: Any] {
      message.setValue(V2NIMMessageRobotConfig.fromDic(robotConfig),
                       forKeyPath: #keyPath(V2NIMMessage.robotConfig))
    }

    if let threadRoot = arguments["threadRoot"] as? [String: Any] {
      message.threadRoot = V2NIMMessageRefer.fromDic(threadRoot)
    }

    if let threadReply = arguments["threadReply"] as? [String: Any] {
      message.setValue(V2NIMMessageRefer.fromDic(threadReply),
                       forKeyPath: #keyPath(V2NIMMessage.threadReply))
    }

    if let aiConfig = arguments["aiConfig"] as? [String: Any] {
      message.aiConfig = V2NIMMessageAIConfig.fromDic(aiConfig)
    }

    if let messageStatus = arguments["messageStatus"] as? [String: Any] {
      message.setValue(V2NIMMessageStatus.fromDic(messageStatus),
                       forKeyPath: #keyPath(V2NIMMessage.messageStatus))
    }

    if let modifyAccountId = arguments["modifyAccountId"] as? String {
      message.setValue(modifyAccountId,
                       forKeyPath: #keyPath(V2NIMMessage.modifyAccountId))
    }

    if let modifyTime = arguments["modifyTime"] as? Int {
      message.setValue(modifyTime / 1000,
                       forKeyPath: #keyPath(V2NIMMessage.modifyTime))
    }

    if let streamConfig = arguments["streamConfig"] as? [String: Any] {
      message.setValue(V2NIMMessageStreamConfig.fromDic(streamConfig),
                       forKeyPath: #keyPath(V2NIMMessage.streamConfig))
    }

    return message
  }

  /// 根据消息类型转换最后一条消息显示
  /// - Returns: 转换结果
  func convertLastMessage() -> String {
    var text = ""

    switch messageType {
    case .MESSAGE_TYPE_TEXT, .MESSAGE_TYPE_TIP:
      if let messageText = self.text {
        text = messageText
      }
    case .MESSAGE_TYPE_IMAGE:
      text = "[图片消息]"
    case .MESSAGE_TYPE_AUDIO:
      text = "[语音消息]"
    case .MESSAGE_TYPE_VIDEO:
      text = "[视频消息]"
    case .MESSAGE_TYPE_LOCATION:
      text = "[地理位置]"
    case .MESSAGE_TYPE_NOTIFICATION:
      text = "[通知消息]"
    case .MESSAGE_TYPE_FILE:
      text = "[文件消息]"
    case .MESSAGE_TYPE_ROBOT:
      text = "[机器人消息]"
    case .MESSAGE_TYPE_CALL:
      let record = attachment as? V2NIMMessageCallAttachment
      text = (record?.type == 1) ? "音频通话" : "视频通话"
    case .MESSAGE_TYPE_CUSTOM:
      text = NECustomUtils.contentOfCustomMessage(attachment)
    default:
      text = "[未知消息体]"
    }
    return text
  }

  /// 结构转换
  func toDict() -> [String: Any] {
    var keyPaths = super.toDic()
    keyPaths[#keyPath(V2NIMMessageRefer.senderId)] = senderId
    keyPaths[#keyPath(V2NIMMessageRefer.receiverId)] = receiverId
    keyPaths[#keyPath(V2NIMMessageRefer.messageClientId)] = messageClientId
    keyPaths[#keyPath(V2NIMMessageRefer.messageServerId)] = messageServerId
    keyPaths[#keyPath(V2NIMMessageRefer.conversationType)] = conversationType.rawValue
    keyPaths[#keyPath(V2NIMMessageRefer.conversationId)] = conversationId
    keyPaths[#keyPath(V2NIMMessageRefer.createTime)] = createTime * 1000
    keyPaths[#keyPath(V2NIMMessage.isSelf)] = isSelf
    keyPaths[#keyPath(V2NIMMessage.attachmentUploadState)] = attachmentUploadState.rawValue
    keyPaths[#keyPath(V2NIMMessage.sendingState)] = sendingState.rawValue
    keyPaths[#keyPath(V2NIMMessage.messageType)] = messageType.rawValue
    keyPaths[#keyPath(V2NIMMessage.subType)] = subType
    keyPaths[#keyPath(V2NIMMessage.text)] = text
    keyPaths[#keyPath(V2NIMMessage.attachment)] = attachment?.toDic()
    keyPaths[#keyPath(V2NIMMessage.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMMessage.localExtension)] = localExtension
    keyPaths[#keyPath(V2NIMMessage.callbackExtension)] = callbackExtension
    keyPaths[#keyPath(V2NIMMessage.messageConfig)] = messageConfig?.toDic()
    keyPaths[#keyPath(V2NIMMessage.pushConfig)] = pushConfig?.toDic()
    keyPaths[#keyPath(V2NIMMessage.routeConfig)] = routeConfig?.toDic()
    keyPaths[#keyPath(V2NIMMessage.antispamConfig)] = antispamConfig?.toDic()
    keyPaths[#keyPath(V2NIMMessage.robotConfig)] = robotConfig?.toDic()
    keyPaths[#keyPath(V2NIMMessage.threadRoot)] = threadRoot?.toDic()
    keyPaths[#keyPath(V2NIMMessage.threadReply)] = threadReply?.toDic()
    keyPaths[#keyPath(V2NIMMessage.topicRefer)] = topicRefer?.toDic()
    keyPaths[#keyPath(V2NIMMessage.aiConfig)] = aiConfig?.toDic()
    keyPaths[#keyPath(V2NIMMessage.messageStatus)] = messageStatus.toDic()
    if let serialId = value(forKeyPath: "serialId") {
      keyPaths["serialId"] = serialId
    }
    if let subStatus = value(forKeyPath: "subStatus") {
      keyPaths["subStatus"] = subStatus
    }
    keyPaths[#keyPath(V2NIMMessage.modifyTime)] = modifyTime * 1000
    keyPaths[#keyPath(V2NIMMessage.modifyAccountId)] = modifyAccountId
    keyPaths[#keyPath(V2NIMMessage.streamConfig)] = streamConfig?.toDic()
    keyPaths["messageSource"] = messageSource.rawValue
    if let iosSerial = nimMessageIOSSerial(from: self, exposedKeys: Set(keyPaths.keys)) {
      keyPaths[nimMessageIOSSerialKey] = iosSerial
    }
    return keyPaths
  }
}
