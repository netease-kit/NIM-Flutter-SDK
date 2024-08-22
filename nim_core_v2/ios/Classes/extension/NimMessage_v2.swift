// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

let nimCoreMessageType = "nimCoreMessageType"

extension V2NIMMessageRefer {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageRefer {
    let attach = V2NIMMessageRefer()

    if let senderId = arguments["senderId"] as? String {
      attach.senderId = senderId
    }

    if let receiverId = arguments["receiverId"] as? String {
      attach.receiverId = receiverId
    }

    if let messageClientId = arguments["messageClientId"] as? String {
      attach.messageClientId = messageClientId
    }

    if let messageServerId = arguments["messageServerId"] as? String {
      attach.messageServerId = messageServerId
    }

    if let type = arguments["conversationType"] as? Int,
       let conversationType = V2NIMConversationType(rawValue: type) {
      attach.conversationType = conversationType
    }

    if let conversationId = arguments["conversationId"] as? String {
      attach.conversationId = conversationId
    }

    let createTime = arguments["createTime"] as? Double
    attach.createTime = TimeInterval((createTime ?? 0) / 1000)

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageRefer.senderId)] = senderId
    keyPaths[#keyPath(V2NIMMessageRefer.receiverId)] = receiverId
    keyPaths[#keyPath(V2NIMMessageRefer.messageClientId)] = messageClientId
    keyPaths[#keyPath(V2NIMMessageRefer.messageServerId)] = messageServerId
    keyPaths[#keyPath(V2NIMMessageRefer.conversationType)] = conversationType.rawValue
    keyPaths[#keyPath(V2NIMMessageRefer.conversationId)] = conversationId
    keyPaths[#keyPath(V2NIMMessageRefer.createTime)] = createTime * 1000
    return keyPaths
  }
}

extension V2NIMMessage {
  // 转换 message json object 为 native message object
  static func fromDict(_ arguments: [String: Any]) -> V2NIMMessage {
    let refer = super.fromDic(arguments)
    let message = V2NIMMessage()
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

  // 结构转换
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
    keyPaths[#keyPath(V2NIMMessage.aiConfig)] = aiConfig?.toDic()
    keyPaths[#keyPath(V2NIMMessage.messageStatus)] = messageStatus.toDic()
    return keyPaths
  }
}

extension V2NIMMessageStatus {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageStatus {
    let attach = V2NIMMessageStatus()

    if let errorCode = arguments["errorCode"] as? Int {
      attach.errorCode = errorCode
    }

    if let readReceiptSent = arguments["readReceiptSent"] as? Bool {
      attach.readReceiptSent = readReceiptSent
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageStatus.errorCode)] = errorCode
    keyPaths[#keyPath(V2NIMMessageStatus.readReceiptSent)] = readReceiptSent
    return keyPaths
  }
}

extension V2NIMMessageAIConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageAIConfig {
    let attach = V2NIMMessageAIConfig()

    if let accountId = arguments["accountId"] as? String {
      attach.accountId = accountId
    }

    if let status = arguments["aiStatus"] as? Int,
       let aiStatus = V2NIMMessageAIStatus(rawValue: status) {
      attach.aiStatus = aiStatus
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageAIConfig.accountId)] = accountId
    keyPaths[#keyPath(V2NIMMessageAIConfig.aiStatus)] = aiStatus.rawValue
    return keyPaths
  }
}

extension V2NIMMessageRobotConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageRobotConfig {
    let attach = V2NIMMessageRobotConfig()

    if let accountId = arguments["accountId"] as? String {
      attach.accountId = accountId
    }

    if let topic = arguments["topic"] as? String {
      attach.topic = topic
    }

    if let function = arguments["function"] as? String {
      attach.function = function
    }

    if let customContent = arguments["customContent"] as? String {
      attach.customContent = customContent
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageRobotConfig.accountId)] = accountId
    keyPaths[#keyPath(V2NIMMessageRobotConfig.topic)] = topic
    keyPaths[#keyPath(V2NIMMessageRobotConfig.function)] = function
    keyPaths[#keyPath(V2NIMMessageRobotConfig.customContent)] = customContent
    return keyPaths
  }
}

extension V2NIMMessageAntispamConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageAntispamConfig {
    let attach = V2NIMMessageAntispamConfig()

    if let antispamEnabled = arguments["antispamEnabled"] as? Bool {
      attach.antispamEnabled = antispamEnabled
    }

    if let antispamBusinessId = arguments["antispamBusinessId"] as? String {
      attach.antispamBusinessId = antispamBusinessId
    }

    if let antispamCustomMessage = arguments["antispamCustomMessage"] as? String {
      attach.antispamCustomMessage = antispamCustomMessage
    }

    if let antispamCheating = arguments["antispamCheating"] as? String {
      attach.antispamCheating = antispamCheating
    }

    if let antispamExtension = arguments["antispamExtension"] as? String {
      attach.antispamExtension = antispamExtension
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageAntispamConfig.antispamEnabled)] = antispamEnabled
    keyPaths[#keyPath(V2NIMMessageAntispamConfig.antispamBusinessId)] = antispamBusinessId
    keyPaths[#keyPath(V2NIMMessageAntispamConfig.antispamCustomMessage)] = antispamCustomMessage
    keyPaths[#keyPath(V2NIMMessageAntispamConfig.antispamCheating)] = antispamCheating
    keyPaths[#keyPath(V2NIMMessageAntispamConfig.antispamExtension)] = antispamExtension
    return keyPaths
  }
}

extension V2NIMMessageRouteConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageRouteConfig {
    let attach = V2NIMMessageRouteConfig()

    if let routeEnabled = arguments["routeEnabled"] as? Bool {
      attach.routeEnabled = routeEnabled
    }

    if let routeEnvironment = arguments["routeEnvironment"] as? String {
      attach.routeEnvironment = routeEnvironment
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageRouteConfig.routeEnabled)] = routeEnabled
    keyPaths[#keyPath(V2NIMMessageRouteConfig.routeEnvironment)] = routeEnvironment
    return keyPaths
  }
}

extension V2NIMMessagePushConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessagePushConfig {
    let attach = V2NIMMessagePushConfig()

    if let pushEnabled = arguments["pushEnabled"] as? Bool {
      attach.pushEnabled = pushEnabled
    }

    if let pushNickEnabled = arguments["pushNickEnabled"] as? Bool {
      attach.pushNickEnabled = pushNickEnabled
    }

    if let pushContent = arguments["pushContent"] as? String {
      attach.pushContent = pushContent
    }

    if let pushPayload = arguments["pushPayload"] as? String {
      attach.pushPayload = pushPayload
    }

    if let forcePush = arguments["forcePush"] as? Bool {
      attach.forcePush = forcePush
    }

    if let forcePushContent = arguments["forcePushContent"] as? String {
      attach.forcePushContent = forcePushContent
    }

    if let forcePushAccountIds = arguments["forcePushAccountIds"] as? [String] {
      attach.forcePushAccountIds = forcePushAccountIds
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessagePushConfig.pushEnabled)] = pushEnabled
    keyPaths[#keyPath(V2NIMMessagePushConfig.pushNickEnabled)] = pushNickEnabled
    keyPaths[#keyPath(V2NIMMessagePushConfig.pushContent)] = pushContent
    keyPaths[#keyPath(V2NIMMessagePushConfig.pushPayload)] = pushPayload
    keyPaths[#keyPath(V2NIMMessagePushConfig.forcePush)] = forcePush
    keyPaths[#keyPath(V2NIMMessagePushConfig.forcePushContent)] = forcePushContent
    keyPaths[#keyPath(V2NIMMessagePushConfig.forcePushAccountIds)] = forcePushAccountIds
    return keyPaths
  }
}

extension V2NIMMessageConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageConfig {
    let attach = V2NIMMessageConfig()

    if let readReceiptEnabled = arguments["readReceiptEnabled"] as? Bool {
      attach.readReceiptEnabled = readReceiptEnabled
    }

    if let lastMessageUpdateEnabled = arguments["lastMessageUpdateEnabled"] as? Bool {
      attach.lastMessageUpdateEnabled = lastMessageUpdateEnabled
    }

    if let historyEnabled = arguments["historyEnabled"] as? Bool {
      attach.historyEnabled = historyEnabled
    }

    if let roamingEnabled = arguments["roamingEnabled"] as? Bool {
      attach.roamingEnabled = roamingEnabled
    }

    if let onlineSyncEnabled = arguments["onlineSyncEnabled"] as? Bool {
      attach.onlineSyncEnabled = onlineSyncEnabled
    }

    if let offlineEnabled = arguments["offlineEnabled"] as? Bool {
      attach.offlineEnabled = offlineEnabled
    }

    if let unreadEnabled = arguments["unreadEnabled"] as? Bool {
      attach.unreadEnabled = unreadEnabled
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageConfig.readReceiptEnabled)] = readReceiptEnabled
    keyPaths[#keyPath(V2NIMMessageConfig.lastMessageUpdateEnabled)] = lastMessageUpdateEnabled
    keyPaths[#keyPath(V2NIMMessageConfig.historyEnabled)] = historyEnabled
    keyPaths[#keyPath(V2NIMMessageConfig.roamingEnabled)] = roamingEnabled
    keyPaths[#keyPath(V2NIMMessageConfig.onlineSyncEnabled)] = onlineSyncEnabled
    keyPaths[#keyPath(V2NIMMessageConfig.offlineEnabled)] = offlineEnabled
    keyPaths[#keyPath(V2NIMMessageConfig.unreadEnabled)] = unreadEnabled
    return keyPaths
  }
}

@objc
extension V2NIMMessageAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageAttachment {
    let attach = V2NIMMessageAttachment()

    if let raw = arguments["raw"] as? String {
      attach.raw = raw
    }

    return attach
  }

  public /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageAttachment.raw)] = raw
    return keyPaths
  }
}

extension V2NIMMessageFileAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDict(_ arguments: [String: Any]) -> V2NIMMessageFileAttachment {
    let raw = V2NIMMessageAttachment.fromDic(arguments).raw
    let attach = V2NIMMessageFileAttachment()
    attach.raw = raw

    if let path = arguments["path"] as? String {
      attach.path = path
      attach.setValue(path, forKey: "_filePath")
    }

    if let size = arguments["size"] as? UInt {
      attach.size = size
    }

    if let md5 = arguments["md5"] as? String {
      attach.md5 = md5
    }

    if let url = arguments["url"] as? String {
      attach.setValue(url,
                      forKeyPath: #keyPath(V2NIMMessageFileAttachment.url))
    }

    if let ext = arguments["ext"] as? String {
      attach.ext = ext
    }

    if let name = arguments["name"] as? String {
      attach.name = name
      attach.setValue(name, forKey: "_fileName")
    }

    if let sceneName = arguments["sceneName"] as? String {
      attach.sceneName = sceneName
    }

    if let uploadState = arguments["uploadState"] as? Int,
       let state = V2NIMMessageAttachmentUploadState(rawValue: uploadState) {
      attach.uploadState = state
    }

    return attach
  }

  override public /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = super.toDic()
    keyPaths[nimCoreMessageType] = V2NIMMessageType.MESSAGE_TYPE_FILE.rawValue
    keyPaths[#keyPath(V2NIMMessageFileAttachment.path)] = path
    keyPaths[#keyPath(V2NIMMessageFileAttachment.size)] = size
    keyPaths[#keyPath(V2NIMMessageFileAttachment.md5)] = md5
    keyPaths[#keyPath(V2NIMMessageFileAttachment.url)] = url
    keyPaths[#keyPath(V2NIMMessageFileAttachment.ext)] = ext
    keyPaths[#keyPath(V2NIMMessageFileAttachment.name)] = name
    keyPaths[#keyPath(V2NIMMessageFileAttachment.sceneName)] = sceneName
    keyPaths[#keyPath(V2NIMMessageFileAttachment.uploadState)] = uploadState.rawValue
    return keyPaths
  }
}

extension V2NIMMessageImageAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDictionary(_ arguments: [String: Any]) -> V2NIMMessageImageAttachment {
    let superAttach = super.fromDict(arguments)
    let attach = V2NIMMessageImageAttachment()
    attach.raw = superAttach.raw
    attach.path = superAttach.path
    attach.size = superAttach.size
    attach.md5 = superAttach.md5
    attach.ext = superAttach.ext
    attach.name = superAttach.name
    attach.sceneName = superAttach.sceneName
    attach.uploadState = superAttach.uploadState

    if let path = arguments["path"] as? String {
      attach.setValue(path, forKey: "_filePath")
    }

    if let name = arguments["name"] as? String {
      attach.setValue(name, forKey: "_fileName")
    }

    if let url = superAttach.url {
      attach.setValue(url,
                      forKeyPath: #keyPath(V2NIMMessageImageAttachment.url))
    }

    if let width = arguments["width"] as? Int {
      attach.setValue(width,
                      forKeyPath: #keyPath(V2NIMMessageImageAttachment.width))
    }

    if let height = arguments["height"] as? Int {
      attach.setValue(height,
                      forKeyPath: #keyPath(V2NIMMessageImageAttachment.height))
    }

    return attach
  }

  override public /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = super.toDic()
    keyPaths[nimCoreMessageType] = V2NIMMessageType.MESSAGE_TYPE_IMAGE.rawValue
    keyPaths[#keyPath(V2NIMMessageImageAttachment.width)] = width
    keyPaths[#keyPath(V2NIMMessageImageAttachment.height)] = height
    return keyPaths
  }
}

extension V2NIMMessageAudioAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDictionary(_ arguments: [String: Any]) -> V2NIMMessageAudioAttachment {
    let superAttach = super.fromDict(arguments)
    let attach = V2NIMMessageAudioAttachment()
    attach.raw = superAttach.raw
    attach.path = superAttach.path
    attach.size = superAttach.size
    attach.md5 = superAttach.md5
    attach.ext = superAttach.ext
    attach.name = superAttach.name
    attach.sceneName = superAttach.sceneName
    attach.uploadState = superAttach.uploadState

    if let path = arguments["path"] as? String {
      attach.setValue(path, forKey: "_filePath")
    }

    if let name = arguments["name"] as? String {
      attach.setValue(name, forKey: "_fileName")
    }

    if let url = superAttach.url {
      attach.setValue(url,
                      forKeyPath: #keyPath(V2NIMMessageImageAttachment.url))
    }

    if let duration = arguments["duration"] as? UInt {
      attach.duration = duration
    }

    return attach
  }

  override public /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = super.toDic()
    keyPaths[nimCoreMessageType] = V2NIMMessageType.MESSAGE_TYPE_AUDIO.rawValue
    keyPaths[#keyPath(V2NIMMessageAudioAttachment.duration)] = duration
    return keyPaths
  }
}

extension V2NIMMessageVideoAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDictionary(_ arguments: [String: Any]) -> V2NIMMessageVideoAttachment {
    let superAttach = super.fromDict(arguments)
    let attach = V2NIMMessageVideoAttachment()
    attach.raw = superAttach.raw
    attach.path = superAttach.path
    attach.size = superAttach.size
    attach.md5 = superAttach.md5
    attach.ext = superAttach.ext
    attach.name = superAttach.name
    attach.sceneName = superAttach.sceneName
    attach.uploadState = superAttach.uploadState

    if let path = arguments["path"] as? String {
      attach.setValue(path, forKey: "_filePath")
    }

    if let name = arguments["name"] as? String {
      attach.setValue(name, forKey: "_fileName")
    }

    if let duration = arguments["duration"] as? UInt {
      attach.duration = duration
    }

    if let width = arguments["width"] as? Int {
      attach.width = width
    }

    if let height = arguments["height"] as? Int {
      attach.height = height
    }

    if let url = arguments[#keyPath(V2NIMMessageFileAttachment.url)] as? String {
      attach.setValue(url,
                      forKeyPath: #keyPath(V2NIMMessageFileAttachment.url))
    }

    return attach
  }

  override public /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = super.toDic()
    keyPaths[nimCoreMessageType] = V2NIMMessageType.MESSAGE_TYPE_VIDEO.rawValue
    keyPaths[#keyPath(V2NIMMessageVideoAttachment.duration)] = duration
    keyPaths[#keyPath(V2NIMMessageVideoAttachment.width)] = width
    keyPaths[#keyPath(V2NIMMessageVideoAttachment.height)] = height
    return keyPaths
  }
}

extension V2NIMMessageLocationAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDict(_ arguments: [String: Any]) -> V2NIMMessageLocationAttachment {
    let superAttach = super.fromDic(arguments)
    let attach = V2NIMMessageLocationAttachment()
    attach.raw = superAttach.raw

    if let longitude = arguments["longitude"] as? Double {
      attach.longitude = longitude
    }

    if let latitude = arguments["latitude"] as? Double {
      attach.latitude = latitude
    }

    if let address = arguments["address"] as? String {
      attach.address = address
    }

    return attach
  }

  override public /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = super.toDic()
    keyPaths[nimCoreMessageType] = V2NIMMessageType.MESSAGE_TYPE_LOCATION.rawValue
    keyPaths[#keyPath(V2NIMMessageLocationAttachment.longitude)] = longitude
    keyPaths[#keyPath(V2NIMMessageLocationAttachment.latitude)] = latitude
    keyPaths[#keyPath(V2NIMMessageLocationAttachment.address)] = address
    return keyPaths
  }
}

extension V2NIMMessageNotificationAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDict(_ arguments: [String: Any]) -> V2NIMMessageNotificationAttachment {
    let superAttach = super.fromDic(arguments)
    let attach = V2NIMMessageNotificationAttachment()
    attach.raw = superAttach.raw

    if let type = arguments["type"] as? Int,
       let notiType = V2NIMMessageNotificationType(rawValue: type) {
      attach.type = notiType
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.serverExtension = serverExtension
    }

    if let targetIds = arguments["targetIds"] as? [String] {
      attach.targetIds = targetIds
    }

    if let chatBanned = arguments["chatBanned"] as? Bool {
      attach.chatBanned = chatBanned
    }

    if let updatedTeamInfo = arguments["updatedTeamInfo"] as? [String: Any] {
      attach.updatedTeamInfo = V2NIMUpdatedTeamInfo.fromDictionary(updatedTeamInfo)
    }

    return attach
  }

  override public /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = super.toDic()
    keyPaths[nimCoreMessageType] = V2NIMMessageType.MESSAGE_TYPE_NOTIFICATION.rawValue
    keyPaths[#keyPath(V2NIMMessageNotificationAttachment.type)] = type.rawValue
    keyPaths[#keyPath(V2NIMMessageNotificationAttachment.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMMessageNotificationAttachment.targetIds)] = targetIds
    keyPaths[#keyPath(V2NIMMessageNotificationAttachment.chatBanned)] = chatBanned
    keyPaths[#keyPath(V2NIMMessageNotificationAttachment.updatedTeamInfo)] = updatedTeamInfo?.toDictionary()
    return keyPaths
  }
}

extension V2NIMMessageCallDuration {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDict(_ arguments: [String: Any]) -> V2NIMMessageCallDuration {
    let callDuration = V2NIMMessageCallDuration()

    if let accountId = arguments["accountId"] as? String {
      callDuration.accountId = accountId
    }

    if let duration = arguments["duration"] as? Int {
      callDuration.duration = duration
    }

    return callDuration
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageCallDuration.accountId)] = accountId
    keyPaths[#keyPath(V2NIMMessageCallDuration.duration)] = duration
    return keyPaths
  }
}

extension V2NIMMessageCallAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDict(_ arguments: [String: Any]) -> V2NIMMessageCallAttachment {
    let superAttach = super.fromDic(arguments)
    let attach = V2NIMMessageCallAttachment()
    attach.raw = superAttach.raw

    if let type = arguments["type"] as? Int {
      attach.type = type
    }

    if let channelId = arguments["channelId"] as? String {
      attach.channelId = channelId
    }

    if let status = arguments["status"] as? Int {
      attach.status = status
    }

    if let durationsMap = arguments["durations"] as? [[String: Any]] {
      var durations = [V2NIMMessageCallDuration]()
      for durationMap in durationsMap {
        let duration = V2NIMMessageCallDuration()
        if let dur = durationMap["duration"] as? Int {
          duration.duration = dur
        }

        if let accountId = durationMap["accountId"] as? String {
          duration.accountId = accountId
        }

        durations.append(duration)
      }
      attach.durations = durations
    }

    return attach
  }

  override public /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = super.toDic()
    keyPaths[nimCoreMessageType] = V2NIMMessageType.MESSAGE_TYPE_CALL.rawValue
    keyPaths[#keyPath(V2NIMMessageCallAttachment.type)] = type
    keyPaths[#keyPath(V2NIMMessageCallAttachment.channelId)] = channelId
    keyPaths[#keyPath(V2NIMMessageCallAttachment.status)] = status

    var durationDic = [[String: Any]]()
    for duration in durations {
      durationDic.append(duration.toDic())
    }

    keyPaths[#keyPath(V2NIMMessageCallAttachment.durations)] = durationDic
    return keyPaths
  }
}

extension V2NIMMessageAIConfigParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageAIConfigParams {
    let attach = V2NIMMessageAIConfigParams()

    if let accountId = arguments["accountId"] as? String {
      attach.accountId = accountId
    }

    if let content = arguments["content"] as? [String: Any] {
      attach.content = V2NIMAIModelCallContent.fromDic(content)
    }

    if let messagesDic = arguments["messages"] as? [[String: Any]] {
      var messages = [V2NIMAIModelCallMessage]()
      for messageDic in messagesDic {
        messages.append(V2NIMAIModelCallMessage.fromDic(messageDic))
      }
      attach.messages = messages
    }

    if let promptVariables = arguments["promptVariables"] as? String {
      attach.promptVariables = promptVariables
    }

    if let modelConfigParams = arguments["modelConfigParams"] as? [String: Any] {
      attach.modelConfigParams = V2NIMAIModelConfigParams.fromDic(modelConfigParams)
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageAIConfigParams.accountId)] = accountId
    keyPaths[#keyPath(V2NIMMessageAIConfigParams.content)] = content?.toDic()

    var messagesDic = [[String: Any]]()
    for message in messages ?? [] {
      messagesDic.append(message.toDic())
    }

    keyPaths[#keyPath(V2NIMMessageAIConfigParams.messages)] = messagesDic
    keyPaths[#keyPath(V2NIMMessageAIConfigParams.promptVariables)] = promptVariables
    keyPaths[#keyPath(V2NIMMessageAIConfigParams.modelConfigParams)] = modelConfigParams?.toDic()
    return keyPaths
  }
}

extension V2NIMAIModelCallContent {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMAIModelCallContent {
    let attach = V2NIMAIModelCallContent()

    if let msg = arguments["msg"] as? String {
      attach.msg = msg
    }

    attach.type = .NIM_AI_MODEL_CONTENT_TYPE_TEXT
    if let type = arguments["type"] as? Int,
       let contentType = V2NIMAIModelCallContentType(rawValue: type) {
      attach.type = contentType
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMAIModelCallContent.msg)] = msg
    keyPaths[#keyPath(V2NIMAIModelCallContent.type)] = type.rawValue
    return keyPaths
  }
}

extension V2NIMAIModelCallMessage {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMAIModelCallMessage {
    let attach = V2NIMAIModelCallMessage()

    if let role = arguments["role"] as? Int,
       let messageRole = V2NIMAIModelRoleType(rawValue: role) {
      attach.role = messageRole
    }

    if let msg = arguments["msg"] as? String {
      attach.msg = msg
    }

    if let type = arguments["type"] as? Int,
       let contentType = V2NIMAIModelCallContentType(rawValue: type) {
      attach.type = contentType
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMAIModelCallMessage.role)] = role.rawValue
    keyPaths[#keyPath(V2NIMAIModelCallMessage.msg)] = msg
    keyPaths[#keyPath(V2NIMAIModelCallMessage.type)] = type.rawValue
    return keyPaths
  }
}

extension V2NIMAIModelConfigParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMAIModelConfigParams {
    let attach = V2NIMAIModelConfigParams()

    if let prompt = arguments["prompt"] as? String {
      attach.prompt = prompt
    }

    if let maxTokens = arguments["maxTokens"] as? Int {
      attach.maxTokens = maxTokens
    }

    if let topP = arguments["topP"] as? CGFloat {
      attach.topP = topP
    }

    if let temperature = arguments["temperature"] as? CGFloat {
      attach.temperature = temperature
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMAIModelConfigParams.prompt)] = prompt
    keyPaths[#keyPath(V2NIMAIModelConfigParams.maxTokens)] = maxTokens
    keyPaths[#keyPath(V2NIMAIModelConfigParams.topP)] = topP
    keyPaths[#keyPath(V2NIMAIModelConfigParams.temperature)] = temperature
    return keyPaths
  }
}

extension V2NIMSendMessageParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSendMessageParams {
    let attach = V2NIMSendMessageParams()

    if let messageConfig = arguments["messageConfig"] as? [String: Any] {
      attach.messageConfig = V2NIMMessageConfig.fromDic(messageConfig)
    }

    if let routeConfig = arguments["routeConfig"] as? [String: Any] {
      attach.routeConfig = V2NIMMessageRouteConfig.fromDic(routeConfig)
    }

    if let pushConfig = arguments["pushConfig"] as? [String: Any] {
      attach.pushConfig = V2NIMMessagePushConfig.fromDic(pushConfig)
    }

    if let antispamConfig = arguments["antispamConfig"] as? [String: Any] {
      attach.antispamConfig = V2NIMMessageAntispamConfig.fromDic(antispamConfig)
    }

    if let robotConfig = arguments["robotConfig"] as? [String: Any] {
      attach.robotConfig = V2NIMMessageRobotConfig.fromDic(robotConfig)
    }

    if let aiConfig = arguments["aiConfig"] as? [String: Any] {
      attach.aiConfig = V2NIMMessageAIConfigParams.fromDic(aiConfig)
    }

    if let clientAntispamEnabled = arguments["clientAntispamEnabled"] as? Bool {
      attach.clientAntispamEnabled = clientAntispamEnabled
    }

    if let clientAntispamReplace = arguments["clientAntispamReplace"] as? String {
      attach.clientAntispamReplace = clientAntispamReplace
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMSendMessageParams.messageConfig)] = messageConfig.toDic()
    keyPaths[#keyPath(V2NIMSendMessageParams.routeConfig)] = routeConfig.toDic()
    keyPaths[#keyPath(V2NIMSendMessageParams.pushConfig)] = pushConfig.toDic()
    keyPaths[#keyPath(V2NIMSendMessageParams.antispamConfig)] = antispamConfig.toDic()
    keyPaths[#keyPath(V2NIMSendMessageParams.robotConfig)] = robotConfig.toDic()
    keyPaths[#keyPath(V2NIMSendMessageParams.aiConfig)] = aiConfig?.toDic()
    keyPaths[#keyPath(V2NIMSendMessageParams.clientAntispamEnabled)] = clientAntispamEnabled
    keyPaths[#keyPath(V2NIMSendMessageParams.clientAntispamReplace)] = clientAntispamReplace
    return keyPaths
  }
}

extension V2NIMSendMessageResult {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSendMessageResult {
    let attach = V2NIMSendMessageResult()

    if let message = arguments["message"] as? [String: Any] {
      attach.setValue(V2NIMMessage.fromDict(message),
                      forKeyPath: #keyPath(V2NIMSendMessageResult.message))
    }

    if let antispamResult = arguments["antispamResult"] as? String {
      attach.setValue(antispamResult,
                      forKeyPath: #keyPath(V2NIMSendMessageResult.antispamResult))
    }

    if let clientAntispamResult = arguments["clientAntispamResult"] as? [String: Any] {
      attach.setValue(V2NIMClientAntispamResult.fromDic(clientAntispamResult),
                      forKeyPath: #keyPath(V2NIMSendMessageResult.clientAntispamResult))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMSendMessageResult.message)] = message?.toDict()
    keyPaths[#keyPath(V2NIMSendMessageResult.antispamResult)] = antispamResult
    keyPaths[#keyPath(V2NIMSendMessageResult.clientAntispamResult)] = clientAntispamResult?.toDic()
    return keyPaths
  }
}

extension V2NIMClientAntispamResult {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMClientAntispamResult {
    let attach = V2NIMClientAntispamResult()

    if let type = arguments["operateType"] as? Int,
       let operateType = V2NIMClientAntispamOperateType(rawValue: type) {
      attach.operateType = operateType
    }

    if let replacedText = arguments["replacedText"] as? String {
      attach.replacedText = replacedText
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMClientAntispamResult.operateType)] = operateType.rawValue
    keyPaths[#keyPath(V2NIMClientAntispamResult.replacedText)] = replacedText
    return keyPaths
  }
}

extension V2NIMMessageListOption {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageListOption {
    let attach = V2NIMMessageListOption()

    if let conversationId = arguments["conversationId"] as? String {
      attach.conversationId = conversationId
    }

    if let messageTypes = arguments["messageTypes"] as? [Int] {
      attach.messageTypes = messageTypes
    }

    let beginTime = arguments["beginTime"] as? Double
    attach.beginTime = TimeInterval((beginTime ?? 0) / 1000)

    let endTime = arguments["endTime"] as? Double
    attach.endTime = TimeInterval((endTime ?? 0) / 1000)

    if let limit = arguments["limit"] as? Int {
      attach.limit = limit
    }

    if let anchorMessage = arguments["anchorMessage"] as? [String: Any] {
      attach.anchorMessage = V2NIMMessage.fromDict(anchorMessage)
    }

    if let dir = arguments["direction"] as? Int,
       let direction = V2NIMQueryDirection(rawValue: dir) {
      attach.direction = direction
    }

    if let strictMode = arguments["strictMode"] as? Bool {
      attach.strictMode = strictMode
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageListOption.conversationId)] = conversationId
    keyPaths[#keyPath(V2NIMMessageListOption.messageTypes)] = messageTypes
    keyPaths[#keyPath(V2NIMMessageListOption.beginTime)] = beginTime * 1000
    keyPaths[#keyPath(V2NIMMessageListOption.endTime)] = endTime * 1000
    keyPaths[#keyPath(V2NIMMessageListOption.limit)] = limit
    keyPaths[#keyPath(V2NIMMessageListOption.anchorMessage)] = anchorMessage?.toDic()
    keyPaths[#keyPath(V2NIMMessageListOption.direction)] = direction.rawValue
    keyPaths[#keyPath(V2NIMMessageListOption.strictMode)] = strictMode
    return keyPaths
  }
}

extension V2NIMClearHistoryMessageOption {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMClearHistoryMessageOption {
    let attach = V2NIMClearHistoryMessageOption()

    if let conversationId = arguments["conversationId"] as? String {
      attach.conversationId = conversationId
    }

    if let deleteRoam = arguments["deleteRoam"] as? Bool {
      attach.deleteRoam = deleteRoam
    }

    if let onlineSync = arguments["onlineSync"] as? Bool {
      attach.onlineSync = onlineSync
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.serverExtension = serverExtension
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMClearHistoryMessageOption.conversationId)] = conversationId
    keyPaths[#keyPath(V2NIMClearHistoryMessageOption.deleteRoam)] = deleteRoam
    keyPaths[#keyPath(V2NIMClearHistoryMessageOption.onlineSync)] = onlineSync
    keyPaths[#keyPath(V2NIMClearHistoryMessageOption.serverExtension)] = serverExtension
    return keyPaths
  }
}

extension V2NIMMessageDeletedNotification {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageDeletedNotification {
    let attach = V2NIMMessageDeletedNotification()

    if let messageRefer = arguments["messageRefer"] as? [String: Any] {
      attach.setValue(V2NIMMessageRefer.fromDic(messageRefer),
                      forKeyPath: #keyPath(V2NIMMessageDeletedNotification.serverExtension))
    }

    if let deleteTime = arguments["deleteTime"] as? Double {
      attach.setValue(TimeInterval(deleteTime / 1000),
                      forKeyPath: #keyPath(V2NIMMessageDeletedNotification.deleteTime))
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.setValue(serverExtension,
                      forKeyPath: #keyPath(V2NIMMessageDeletedNotification.serverExtension))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageDeletedNotification.messageRefer)] = messageRefer.toDic()
    keyPaths[#keyPath(V2NIMMessageDeletedNotification.deleteTime)] = deleteTime * 1000
    keyPaths[#keyPath(V2NIMMessageDeletedNotification.serverExtension)] = serverExtension
    return keyPaths
  }
}

extension V2NIMMessagePin {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessagePin {
    let attach = V2NIMMessagePin()

    if let messageRefer = arguments["messageRefer"] as? [String: Any] {
      attach.messageRefer = V2NIMMessageRefer.fromDic(messageRefer)
    }

    if let operatorId = arguments["operatorId"] as? String {
      attach.operatorId = operatorId
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.serverExtension = serverExtension
    }

    let createTime = arguments["createTime"] as? Double
    attach.createTime = TimeInterval((createTime ?? 0) / 1000)

    let updateTime = arguments["updateTime"] as? Double
    attach.updateTime = TimeInterval((updateTime ?? 0) / 1000)

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessagePin.messageRefer)] = messageRefer?.toDic()
    keyPaths[#keyPath(V2NIMMessagePin.operatorId)] = operatorId
    keyPaths[#keyPath(V2NIMMessagePin.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMMessagePin.createTime)] = createTime * 1000
    keyPaths[#keyPath(V2NIMMessagePin.updateTime)] = updateTime * 1000
    return keyPaths
  }
}

extension V2NIMMessagePinNotification {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessagePinNotification {
    let attach = V2NIMMessagePinNotification()

    if let pin = arguments["pin"] as? [String: Any] {
      attach.setValue(V2NIMMessagePin.fromDic(pin),
                      forKeyPath: #keyPath(V2NIMMessagePinNotification.pin))
    }

    if let state = arguments["pinState"] as? UInt,
       let pinState = V2NIMMessagePinState(rawValue: state) {
      attach.setValue(pinState,
                      forKeyPath: #keyPath(V2NIMMessagePinNotification.pinState))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessagePinNotification.pin)] = pin?.toDic()
    keyPaths[#keyPath(V2NIMMessagePinNotification.pinState)] = pinState.rawValue
    return keyPaths
  }
}

extension V2NIMMessageQuickComment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageQuickComment {
    let attach = V2NIMMessageQuickComment()

    if let messageRefer = arguments["messageRefer"] as? [String: Any] {
      attach.messageRefer = V2NIMMessageRefer.fromDic(messageRefer)
    }

    if let operatorId = arguments["operatorId"] as? String {
      attach.operatorId = operatorId
    }

    if let index = arguments["index"] as? Int {
      attach.index = TimeInterval(index)
    }

    let createTime = arguments["createTime"] as? Double
    attach.createTime = TimeInterval((createTime ?? 0) / 1000)

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.serverExtension = serverExtension
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageQuickComment.messageRefer)] = messageRefer.toDic()
    keyPaths[#keyPath(V2NIMMessageQuickComment.operatorId)] = operatorId
    keyPaths[#keyPath(V2NIMMessageQuickComment.index)] = index
    keyPaths[#keyPath(V2NIMMessageQuickComment.createTime)] = createTime * 1000
    keyPaths[#keyPath(V2NIMMessageQuickComment.serverExtension)] = serverExtension
    return keyPaths
  }
}

extension V2NIMMessageQuickCommentNotification {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageQuickCommentNotification {
    let attach = V2NIMMessageQuickCommentNotification()

    if let type = arguments["operationType"] as? UInt,
       let operationType = V2NIMMessageQuickCommentType(rawValue: type) {
      attach.operationType = operationType
    }

    if let quickComment = arguments["quickComment"] as? [String: Any] {
      attach.quickComment = V2NIMMessageQuickComment.fromDic(quickComment)
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageQuickCommentNotification.operationType)] = operationType.rawValue
    keyPaths[#keyPath(V2NIMMessageQuickCommentNotification.quickComment)] = quickComment.toDic()
    return keyPaths
  }
}

extension V2NIMMessageQuickCommentPushConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageQuickCommentPushConfig {
    let attach = V2NIMMessageQuickCommentPushConfig()

    if let pushEnabled = arguments["pushEnabled"] as? Bool {
      attach.pushEnabled = pushEnabled
    }

    if let needBadge = arguments["needBadge"] as? Bool {
      attach.needBadge = needBadge
    }

    if let title = arguments["pushTitle"] as? String {
      attach.title = title
    }

    if let pushContent = arguments["pushContent"] as? String {
      attach.pushContent = pushContent
    }

    if let pushPayload = arguments["pushPayload"] as? String {
      attach.pushPayload = pushPayload
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageQuickCommentPushConfig.pushEnabled)] = pushEnabled
    keyPaths[#keyPath(V2NIMMessageQuickCommentPushConfig.needBadge)] = needBadge
    keyPaths["pushTitle"] = title
    keyPaths[#keyPath(V2NIMMessageQuickCommentPushConfig.pushContent)] = pushContent
    keyPaths[#keyPath(V2NIMMessageQuickCommentPushConfig.pushPayload)] = pushPayload
    return keyPaths
  }
}

extension V2NIMMessageRevokeNotification {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageRevokeNotification {
    let attach = V2NIMMessageRevokeNotification()

    if let messageRefer = arguments["messageRefer"] as? [String: Any] {
      attach.setValue(V2NIMMessageRefer.fromDic(messageRefer),
                      forKeyPath: #keyPath(V2NIMMessageRevokeNotification.messageRefer))
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.setValue(serverExtension,
                      forKeyPath: #keyPath(V2NIMMessageRevokeNotification.serverExtension))
    }

    if let revokeAccountId = arguments["revokeAccountId"] as? String {
      attach.setValue(revokeAccountId,
                      forKeyPath: #keyPath(V2NIMMessageRevokeNotification.revokeAccountId))
    }

    if let postscript = arguments["postscript"] as? String {
      attach.setValue(postscript,
                      forKeyPath: #keyPath(V2NIMMessageRevokeNotification.postscript))
    }

    if let type = arguments["revokeType"] as? UInt,
       let revokeType = V2NIMMessageRevokeType(rawValue: type) {
      attach.setValue(revokeType,
                      forKeyPath: #keyPath(V2NIMMessageRevokeNotification.revokeType))
    }

    if let callbackExtension = arguments["callbackExtension"] as? String {
      attach.setValue(callbackExtension,
                      forKeyPath: #keyPath(V2NIMMessageRevokeNotification.callbackExtension))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageRevokeNotification.messageRefer)] = messageRefer?.toDic()
    keyPaths[#keyPath(V2NIMMessageRevokeNotification.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMMessageRevokeNotification.revokeAccountId)] = revokeAccountId
    keyPaths[#keyPath(V2NIMMessageRevokeNotification.postscript)] = postscript
    keyPaths[#keyPath(V2NIMMessageRevokeNotification.revokeType)] = revokeType.rawValue
    keyPaths[#keyPath(V2NIMMessageRevokeNotification.callbackExtension)] = callbackExtension
    return keyPaths
  }
}

extension V2NIMMessageRevokeParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageRevokeParams {
    let attach = V2NIMMessageRevokeParams()

    if let postscript = arguments["postscript"] as? String {
      attach.postscript = postscript
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.serverExtension = serverExtension
    }

    if let pushContent = arguments["pushContent"] as? String {
      attach.pushContent = pushContent
    }

    if let pushPayload = arguments["pushPayload"] as? String {
      attach.pushPayload = pushPayload
    }

    if let env = arguments["env"] as? String {
      attach.env = env
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageRevokeParams.postscript)] = postscript
    keyPaths[#keyPath(V2NIMMessageRevokeParams.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMMessageRevokeParams.pushContent)] = pushContent
    keyPaths[#keyPath(V2NIMMessageRevokeParams.pushPayload)] = pushPayload
    keyPaths[#keyPath(V2NIMMessageRevokeParams.env)] = env
    return keyPaths
  }
}

extension V2NIMMessageSearchParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageSearchParams {
    let attach = V2NIMMessageSearchParams()

    if let keyword = arguments["keyword"] as? String {
      attach.keyword = keyword
    }

    let beginTime = arguments["beginTime"] as? Double
    attach.beginTime = TimeInterval((beginTime ?? 0) / 1000)

    let endTime = arguments["endTime"] as? Double
    attach.endTime = TimeInterval((endTime ?? 0) / 1000)

    if let conversationLimit = arguments["conversationLimit"] as? UInt {
      attach.conversationLimit = conversationLimit
    }

    if let messageLimit = arguments["messageLimit"] as? UInt {
      attach.messageLimit = messageLimit
    }

    if let order = arguments["sortOrder"] as? Int,
       let sortOrder = V2NIMSortOrder(rawValue: order) {
      attach.sortOrder = sortOrder
    }

    if let p2pAccountIds = arguments["p2pAccountIds"] as? [String] {
      attach.p2pAccountIds = p2pAccountIds
    }

    if let teamIds = arguments["teamIds"] as? [String] {
      attach.teamIds = teamIds
    }

    if let senderAccountIds = arguments["senderAccountIds"] as? [String] {
      attach.senderAccountIds = senderAccountIds
    }

    if let messageTypes = arguments["messageTypes"] as? [Int] {
      var types = [Int]()
      for type in messageTypes {
        if let _ = V2NIMMessageType(rawValue: type) {
          types.append(type)
        }
      }
      attach.messageTypes = types
    }

    if let messageSubtypes = arguments["messageSubtypes"] as? [Int] {
      attach.messageSubtypes = messageSubtypes
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageSearchParams.keyword)] = keyword
    keyPaths[#keyPath(V2NIMMessageSearchParams.beginTime)] = beginTime * 1000
    keyPaths[#keyPath(V2NIMMessageSearchParams.endTime)] = endTime * 1000
    keyPaths[#keyPath(V2NIMMessageSearchParams.conversationLimit)] = conversationLimit
    keyPaths[#keyPath(V2NIMMessageSearchParams.messageLimit)] = messageLimit
    keyPaths[#keyPath(V2NIMMessageSearchParams.sortOrder)] = sortOrder.rawValue
    keyPaths[#keyPath(V2NIMMessageSearchParams.p2pAccountIds)] = p2pAccountIds
    keyPaths[#keyPath(V2NIMMessageSearchParams.teamIds)] = teamIds
    keyPaths[#keyPath(V2NIMMessageSearchParams.senderAccountIds)] = senderAccountIds
    keyPaths[#keyPath(V2NIMMessageSearchParams.messageTypes)] = messageTypes
    keyPaths[#keyPath(V2NIMMessageSearchParams.messageSubtypes)] = messageSubtypes
    return keyPaths
  }
}

extension V2NIMNotificationAntispamConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMNotificationAntispamConfig {
    let attach = V2NIMNotificationAntispamConfig()

    if let antispamEnabled = arguments["antispamEnabled"] as? Bool {
      attach.antispamEnabled = antispamEnabled
    }

    if let antispamCustomNotification = arguments["antispamCustomNotification"] as? String {
      attach.antispamCustomNotification = antispamCustomNotification
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMNotificationAntispamConfig.antispamEnabled)] = antispamEnabled
    keyPaths[#keyPath(V2NIMNotificationAntispamConfig.antispamCustomNotification)] = antispamCustomNotification
    return keyPaths
  }
}

extension V2NIMNotificationConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMNotificationConfig {
    let attach = V2NIMNotificationConfig()

    if let offlineEnabled = arguments["offlineEnabled"] as? Bool {
      attach.offlineEnabled = offlineEnabled
    }

    if let unreadEnabled = arguments["unreadEnabled"] as? Bool {
      attach.unreadEnabled = unreadEnabled
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMNotificationConfig.offlineEnabled)] = offlineEnabled
    keyPaths[#keyPath(V2NIMNotificationConfig.unreadEnabled)] = unreadEnabled
    return keyPaths
  }
}

extension V2NIMNotificationPushConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMNotificationPushConfig {
    let attach = V2NIMNotificationPushConfig()

    if let pushEnabled = arguments["pushEnabled"] as? Bool {
      attach.pushEnabled = pushEnabled
    }

    if let pushNickEnabled = arguments["pushNickEnabled"] as? Bool {
      attach.pushNickEnabled = pushNickEnabled
    }

    if let pushContent = arguments["pushContent"] as? String {
      attach.pushContent = pushContent
    }

    if let pushContent = arguments["pushContent"] as? String {
      attach.pushContent = pushContent
    }

    if let forcePush = arguments["forcePush"] as? Bool {
      attach.forcePush = forcePush
    }

    if let forcePushContent = arguments["forcePushContent"] as? String {
      attach.forcePushContent = forcePushContent
    }

    if let forcePushAccountIds = arguments["forcePushAccountIds"] as? [String] {
      attach.forcePushAccountIds = forcePushAccountIds
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMNotificationPushConfig.pushEnabled)] = pushEnabled
    keyPaths[#keyPath(V2NIMNotificationPushConfig.pushNickEnabled)] = pushNickEnabled
    keyPaths[#keyPath(V2NIMNotificationPushConfig.pushContent)] = pushContent
    keyPaths[#keyPath(V2NIMNotificationPushConfig.pushPayload)] = pushPayload
    keyPaths[#keyPath(V2NIMNotificationPushConfig.forcePush)] = forcePush
    keyPaths[#keyPath(V2NIMNotificationPushConfig.forcePushContent)] = forcePushContent
    keyPaths[#keyPath(V2NIMNotificationPushConfig.forcePushAccountIds)] = forcePushAccountIds
    return keyPaths
  }
}

extension V2NIMNotificationRouteConfig {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMNotificationRouteConfig {
    let attach = V2NIMNotificationRouteConfig()

    if let routeEnabled = arguments["routeEnabled"] as? Bool {
      attach.routeEnabled = routeEnabled
    }

    if let routeEnvironment = arguments["routeEnvironment"] as? String {
      attach.routeEnvironment = routeEnvironment
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMNotificationRouteConfig.routeEnabled)] = routeEnabled
    keyPaths[#keyPath(V2NIMNotificationRouteConfig.routeEnvironment)] = routeEnvironment
    return keyPaths
  }
}

extension V2NIMP2PMessageReadReceipt {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMP2PMessageReadReceipt {
    let attach = V2NIMP2PMessageReadReceipt()

    if let conversationId = arguments["conversationId"] as? String {
      attach.setValue(conversationId,
                      forKeyPath: #keyPath(V2NIMP2PMessageReadReceipt.conversationId))
    }

    if let timestamp = arguments["timestamp"] as? Double {
      attach.setValue(TimeInterval(timestamp / 1000),
                      forKeyPath: #keyPath(V2NIMP2PMessageReadReceipt.timestamp))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMP2PMessageReadReceipt.conversationId)] = conversationId
    keyPaths[#keyPath(V2NIMP2PMessageReadReceipt.timestamp)] = timestamp * 1000
    return keyPaths
  }
}

extension V2NIMSendCustomNotificationParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSendCustomNotificationParams {
    let attach = V2NIMSendCustomNotificationParams()

    if let notificationConfig = arguments["notificationConfig"] as? [String: Any] {
      attach.notificationConfig = V2NIMNotificationConfig.fromDic(notificationConfig)
    }

    if let pushConfig = arguments["pushConfig"] as? [String: Any] {
      attach.pushConfig = V2NIMNotificationPushConfig.fromDic(pushConfig)
    }

    if let antispamConfig = arguments["antispamConfig"] as? [String: Any] {
      attach.antispamConfig = V2NIMNotificationAntispamConfig.fromDic(antispamConfig)
    }

    if let routeConfig = arguments["routeConfig"] as? [String: Any] {
      attach.routeConfig = V2NIMNotificationRouteConfig.fromDic(routeConfig)
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMSendCustomNotificationParams.notificationConfig)] = notificationConfig.toDic()
    keyPaths[#keyPath(V2NIMSendCustomNotificationParams.pushConfig)] = pushConfig.toDic()
    keyPaths[#keyPath(V2NIMSendCustomNotificationParams.antispamConfig)] = antispamConfig.toDic()
    keyPaths[#keyPath(V2NIMSendCustomNotificationParams.routeConfig)] = routeConfig.toDic()
    return keyPaths
  }
}

extension V2NIMTeamMessageReadReceipt {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTeamMessageReadReceipt {
    let attach = V2NIMTeamMessageReadReceipt()

    if let conversationId = arguments["conversationId"] as? String {
      attach.setValue(conversationId,
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceipt.conversationId))
    }

    if let messageServerId = arguments["messageServerId"] as? String {
      attach.setValue(messageServerId,
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceipt.messageServerId))
    }

    if let messageClientId = arguments["messageClientId"] as? String {
      attach.setValue(messageClientId,
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceipt.messageClientId))
    }

    if let readCount = arguments["readCount"] as? Int {
      attach.setValue(readCount,
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceipt.readCount))
    }

    if let unreadCount = arguments["unreadCount"] as? Int {
      attach.setValue(unreadCount,
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceipt.unreadCount))
    }

    if let latestReadAccount = arguments["latestReadAccount"] as? String {
      attach.setValue(latestReadAccount,
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceipt.latestReadAccount))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMTeamMessageReadReceipt.conversationId)] = conversationId
    keyPaths[#keyPath(V2NIMTeamMessageReadReceipt.messageServerId)] = messageServerId
    keyPaths[#keyPath(V2NIMTeamMessageReadReceipt.messageClientId)] = messageClientId
    keyPaths[#keyPath(V2NIMTeamMessageReadReceipt.readCount)] = readCount
    keyPaths[#keyPath(V2NIMTeamMessageReadReceipt.unreadCount)] = unreadCount
    keyPaths[#keyPath(V2NIMTeamMessageReadReceipt.latestReadAccount)] = latestReadAccount
    return keyPaths
  }
}

extension V2NIMTeamMessageReadReceiptDetail {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTeamMessageReadReceiptDetail {
    let attach = V2NIMTeamMessageReadReceiptDetail()

    if let readReceipt = arguments["readReceipt"] as? [String: Any] {
      attach.setValue(V2NIMTeamMessageReadReceipt.fromDic(readReceipt),
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceiptDetail.readReceipt))
    }

    if let readAccountList = arguments["readAccountList"] as? [String] {
      attach.setValue(readAccountList,
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceiptDetail.readAccountList))
    }

    if let unreadAccountList = arguments["unreadAccountList"] as? [String] {
      attach.setValue(unreadAccountList,
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceiptDetail.unreadAccountList))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMTeamMessageReadReceiptDetail.readReceipt)] = readReceipt.toDic()
    keyPaths[#keyPath(V2NIMTeamMessageReadReceiptDetail.readAccountList)] = readAccountList
    keyPaths[#keyPath(V2NIMTeamMessageReadReceiptDetail.unreadAccountList)] = unreadAccountList
    return keyPaths
  }
}

extension V2NIMThreadMessageListOption {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMThreadMessageListOption {
    let attach = V2NIMThreadMessageListOption()

    if let messageRefer = arguments["messageRefer"] as? [String: Any] {
      attach.messageRefer = V2NIMMessageRefer.fromDic(messageRefer)
    }

    let beginTime = arguments["beginTime"] as? Double
    attach.beginTime = TimeInterval((beginTime ?? 0) / 1000)

    let endTime = arguments["endTime"] as? Double
    attach.endTime = TimeInterval((endTime ?? 0) / 1000)

    if let excludeMessageServerId = arguments["excludeMessageServerId"] as? String {
      attach.excludeMessageServerId = excludeMessageServerId
    }

    if let limit = arguments["limit"] as? Int {
      attach.limit = limit
    }

    if let dir = arguments["direction"] as? Int,
       let direction = V2NIMQueryDirection(rawValue: dir) {
      attach.direction = direction
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMThreadMessageListOption.messageRefer)] = messageRefer.toDic()
    keyPaths[#keyPath(V2NIMThreadMessageListOption.beginTime)] = beginTime * 1000
    keyPaths[#keyPath(V2NIMThreadMessageListOption.endTime)] = endTime * 1000
    keyPaths[#keyPath(V2NIMThreadMessageListOption.excludeMessageServerId)] = excludeMessageServerId
    keyPaths[#keyPath(V2NIMThreadMessageListOption.limit)] = limit
    keyPaths[#keyPath(V2NIMThreadMessageListOption.direction)] = direction.rawValue
    return keyPaths
  }
}

extension V2NIMThreadMessageListResult {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMThreadMessageListResult {
    let attach = V2NIMThreadMessageListResult()

    if let message = arguments["message"] as? [String: Any] {
      attach.setValue(V2NIMMessage.fromDict(message),
                      forKeyPath: #keyPath(V2NIMThreadMessageListResult.message))
    }

    if let timestamp = arguments["timestamp"] as? Double {
      attach.setValue(TimeInterval(timestamp / 1000),
                      forKeyPath: #keyPath(V2NIMThreadMessageListResult.timestamp))
    }

    if let replyCount = arguments["replyCount"] as? Int {
      attach.setValue(replyCount,
                      forKeyPath: #keyPath(V2NIMThreadMessageListResult.replyCount))
    }

    if let replyListDic = arguments["replyList"] as? [[String: Any]] {
      var replyList = [V2NIMMessage]()
      for replyDic in replyListDic {
        replyList.append(V2NIMMessage.fromDict(replyDic))
      }

      attach.setValue(replyList,
                      forKeyPath: #keyPath(V2NIMThreadMessageListResult.replyList))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMThreadMessageListResult.message)] = message.toDict()
    keyPaths[#keyPath(V2NIMThreadMessageListResult.timestamp)] = timestamp * 1000
    keyPaths[#keyPath(V2NIMThreadMessageListResult.replyCount)] = replyCount

    var replyListDic = [[String: Any]]()
    for reply in replyList {
      replyListDic.append(reply.toDict())
    }
    keyPaths[#keyPath(V2NIMThreadMessageListResult.replyList)] = replyListDic
    return keyPaths
  }
}

extension V2NIMVoiceToTextParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMVoiceToTextParams {
    let attach = V2NIMVoiceToTextParams()

    if let voicePath = arguments["voicePath"] as? String {
      attach.voicePath = voicePath
    }

    if let voiceUrl = arguments["voiceUrl"] as? String {
      attach.voiceUrl = voiceUrl
    }

    if let mimeType = arguments["mimeType"] as? String {
      attach.mimeType = mimeType
    }

    if let sampleRate = arguments["sampleRate"] as? String {
      attach.sampleRate = sampleRate
    }

    let duration = arguments["duration"] as? Int
    attach.duration = TimeInterval(duration ?? 0)

    if let sceneName = arguments["sceneName"] as? String {
      attach.sceneName = sceneName
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMVoiceToTextParams.voicePath)] = voicePath
    keyPaths[#keyPath(V2NIMVoiceToTextParams.voiceUrl)] = voiceUrl
    keyPaths[#keyPath(V2NIMVoiceToTextParams.mimeType)] = mimeType
    keyPaths[#keyPath(V2NIMVoiceToTextParams.sampleRate)] = sampleRate
    keyPaths[#keyPath(V2NIMVoiceToTextParams.duration)] = duration
    keyPaths[#keyPath(V2NIMVoiceToTextParams.sceneName)] = sceneName
    return keyPaths
  }
}

extension V2NIMCollection {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMCollection {
    let attach = V2NIMCollection()

    if let collectionId = arguments["collectionId"] as? String {
      attach.collectionId = collectionId
    }

    if let collectionType = arguments["collectionType"] as? Int32 {
      attach.collectionType = collectionType
    }

    if let collectionData = arguments["collectionData"] as? String {
      attach.setValue(collectionData,
                      forKeyPath: #keyPath(V2NIMCollection.collectionData))
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.serverExtension = serverExtension
    }

    let createTime = arguments["createTime"] as? Double
    attach.createTime = TimeInterval((createTime ?? 0) / 1000)

    let updateTime = arguments["updateTime"] as? Double
    attach.updateTime = TimeInterval((updateTime ?? 0) / 1000)

    if let uniqueId = arguments["uniqueId"] as? String {
      attach.uniqueId = uniqueId
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMCollection.collectionId)] = collectionId
    keyPaths[#keyPath(V2NIMCollection.collectionType)] = collectionType
    keyPaths[#keyPath(V2NIMCollection.collectionData)] = collectionData
    keyPaths[#keyPath(V2NIMCollection.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMCollection.createTime)] = createTime * 1000
    keyPaths[#keyPath(V2NIMCollection.updateTime)] = updateTime * 1000
    keyPaths[#keyPath(V2NIMCollection.uniqueId)] = uniqueId
    return keyPaths
  }
}

extension V2NIMAddCollectionParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMAddCollectionParams {
    let attach = V2NIMAddCollectionParams()

    if let collectionType = arguments["collectionType"] as? Int32 {
      attach.collectionType = collectionType
    }

    if let collectionData = arguments["collectionData"] as? String {
      attach.collectionData = collectionData
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.serverExtension = serverExtension
    }

    if let uniqueId = arguments["uniqueId"] as? String {
      attach.uniqueId = uniqueId
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMAddCollectionParams.collectionType)] = collectionType
    keyPaths[#keyPath(V2NIMAddCollectionParams.collectionData)] = collectionData
    keyPaths[#keyPath(V2NIMAddCollectionParams.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMAddCollectionParams.uniqueId)] = uniqueId
    return keyPaths
  }
}

extension V2NIMCollectionOption {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMCollectionOption {
    let attach = V2NIMCollectionOption()

    let beginTime = arguments["beginTime"] as? Double
    attach.beginTime = TimeInterval((beginTime ?? 0) / 1000)

    let endTime = arguments["endTime"] as? Double
    attach.endTime = TimeInterval((endTime ?? 0) / 1000)

    if let dir = arguments["direction"] as? Int,
       let direction = V2NIMQueryDirection(rawValue: dir) {
      attach.direction = direction
    }

    if let anchorCollection = arguments["anchorCollection"] as? [String: Any] {
      attach.anchorCollection = V2NIMCollection.fromDic(anchorCollection)
    }

    if let limit = arguments["limit"] as? Int32 {
      attach.limit = limit
    }

    if let collectionType = arguments["collectionType"] as? Int32 {
      attach.collectionType = collectionType
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMCollectionOption.beginTime)] = beginTime * 1000
    keyPaths[#keyPath(V2NIMCollectionOption.endTime)] = endTime * 1000
    keyPaths[#keyPath(V2NIMCollectionOption.direction)] = direction.rawValue
    keyPaths[#keyPath(V2NIMCollectionOption.anchorCollection)] = anchorCollection.toDic()
    keyPaths[#keyPath(V2NIMCollectionOption.limit)] = limit
    keyPaths[#keyPath(V2NIMCollectionOption.collectionType)] = collectionType
    return keyPaths
  }
}

extension V2NIMClearHistoryNotification {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMClearHistoryNotification {
    let attach = V2NIMClearHistoryNotification()

    if let conversationId = arguments["conversationId"] as? String {
      attach.setValue(conversationId,
                      forKeyPath: #keyPath(V2NIMClearHistoryNotification.conversationId))
    }

    if let deleteTime = arguments["deleteTime"] as? Double {
      attach.setValue(TimeInterval(deleteTime / 1000),
                      forKeyPath: #keyPath(V2NIMClearHistoryNotification.deleteTime))
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.setValue(serverExtension,
                      forKeyPath: #keyPath(V2NIMClearHistoryNotification.serverExtension))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMClearHistoryNotification.conversationId)] = conversationId
    keyPaths[#keyPath(V2NIMClearHistoryNotification.deleteTime)] = deleteTime * 1000
    keyPaths[#keyPath(V2NIMClearHistoryNotification.serverExtension)] = serverExtension
    return keyPaths
  }
}
