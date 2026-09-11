// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

private func nimTopicInt64Value(_ value: Any?) -> Int64? {
  switch value {
  case let value as Int64:
    return value
  case let value as Int:
    return Int64(value)
  case let value as UInt64:
    return value <= UInt64(Int64.max) ? Int64(value) : nil
  case let value as Double:
    return Int64(value)
  case let value as NSNumber:
    return value.int64Value
  default:
    return nil
  }
}

private func nimTopicUInt64Value(_ value: Any?) -> UInt64? {
  switch value {
  case let value as UInt64:
    return value
  case let value as Int where value >= 0:
    return UInt64(value)
  case let value as Int64 where value >= 0:
    return UInt64(value)
  case let value as Double where value >= 0:
    return UInt64(value)
  case let value as NSNumber where value.int64Value >= 0:
    return value.uint64Value
  default:
    return nil
  }
}

extension V2NIMTopicRefer {
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTopicRefer {
    let topicRefer = V2NIMTopicRefer()
    if let conversationId = arguments["conversationId"] as? String {
      topicRefer.setValue(conversationId, forKeyPath: #keyPath(V2NIMTopicRefer.conversationId))
    }
    if let topicId = nimTopicUInt64Value(arguments["topicId"]) {
      topicRefer.setValue(topicId, forKeyPath: #keyPath(V2NIMTopicRefer.topicId))
    }
    if let createTime = nimTopicInt64Value(arguments["createTime"]) {
      topicRefer.setValue(createTime, forKeyPath: #keyPath(V2NIMTopicRefer.createTime))
    }
    return topicRefer
  }

  func toDic() -> [String: Any] {
    if let topic = self as? V2NIMTopic {
      return topic.toDic()
    }
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMTopicRefer.conversationId)] = conversationId
    keyPaths[#keyPath(V2NIMTopicRefer.topicId)] = topicId
    keyPaths[#keyPath(V2NIMTopicRefer.createTime)] = createTime
    return keyPaths
  }
}

extension V2NIMTopic {
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTopic {
    let topic = V2NIMTopic()
    if let conversationId = arguments["conversationId"] as? String {
      topic.setValue(conversationId, forKeyPath: #keyPath(V2NIMTopic.conversationId))

      if let targetId = V2NIMConversationIdUtil.conversationTargetId(conversationId) {
        topic.setValue(targetId,
                       forKeyPath: "targetId")
      }
      let conversationType = V2NIMConversationIdUtil.conversationType(conversationId)
      topic.setValue(conversationType.rawValue,
                     forKeyPath: "conversationType")
    }
    if let topicId = nimTopicUInt64Value(arguments["topicId"]) {
      topic.setValue(topicId, forKeyPath: #keyPath(V2NIMTopic.topicId))
    }
    if let createTime = nimTopicInt64Value(arguments["createTime"]) {
      topic.setValue(createTime, forKeyPath: #keyPath(V2NIMTopic.createTime))
    }
    if let topicName = arguments["topicName"] as? String {
      topic.setValue(topicName, forKeyPath: #keyPath(V2NIMTopic.topicName))
    }
    if let messageClientId = arguments["messageClientId"] as? String {
      topic.setValue(messageClientId, forKeyPath: #keyPath(V2NIMTopic.messageClientId))
    }
    if let messageServerId = arguments["messageServerId"] as? String {
      topic.setValue(messageServerId, forKeyPath: #keyPath(V2NIMTopic.messageServerId))
    }
    if let messageTime = nimTopicInt64Value(arguments["messageTime"]) {
      topic.setValue(messageTime, forKeyPath: #keyPath(V2NIMTopic.messageTime))
    }
    if let serverExtension = arguments["serverExtension"] as? String {
      topic.setValue(serverExtension, forKeyPath: #keyPath(V2NIMTopic.serverExtension))
    }
    if let updateTime = nimTopicInt64Value(arguments["updateTime"]) {
      topic.setValue(updateTime, forKeyPath: #keyPath(V2NIMTopic.updateTime))
    }
    if let data = arguments["data"] as? String {
      topic.setValue(data, forKeyPath: "data")
    }
    return topic
  }

  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMTopic.conversationId)] = conversationId
    keyPaths[#keyPath(V2NIMTopic.topicId)] = topicId
    keyPaths[#keyPath(V2NIMTopic.createTime)] = createTime
    keyPaths[#keyPath(V2NIMTopic.topicName)] = topicName
    keyPaths[#keyPath(V2NIMTopic.messageClientId)] = messageClientId
    keyPaths[#keyPath(V2NIMTopic.messageServerId)] = messageServerId
    keyPaths[#keyPath(V2NIMTopic.messageTime)] = messageTime
    keyPaths[#keyPath(V2NIMTopic.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMTopic.updateTime)] = updateTime
    if let data = value(forKeyPath: "data") {
      keyPaths["data"] = data
    }
    return keyPaths
  }
}

extension V2NIMUpdateTopicParams {
  static func fromDic(_ arguments: [String: Any]) -> V2NIMUpdateTopicParams {
    let params = V2NIMUpdateTopicParams()
    if let topic = arguments["topic"] as? [String: Any] {
      params.topic = V2NIMTopic.fromDic(topic)
    }
    params.topicName = arguments["topicName"] as? String
    params.serverExtension = arguments["serverExtension"] as? String
    return params
  }
}

extension V2NIMRemoveTopicsParams {
  static func fromDic(_ arguments: [String: Any]) -> V2NIMRemoveTopicsParams {
    let params = V2NIMRemoveTopicsParams()
    if let topicList = arguments["topicList"] as? [[String: Any]] {
      params.topicList = topicList.map { V2NIMTopic.fromDic($0) }
    }
    return params
  }
}

extension V2NIMCreateTopicParams {
  static func fromDic(_ arguments: [String: Any]) -> V2NIMCreateTopicParams {
    let params = V2NIMCreateTopicParams()
    params.topicName = arguments["topicName"] as? String
    params.serverExtension = arguments["serverExtension"] as? String
    return params
  }
}

extension V2NIMSendTopicMessageParams {
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSendTopicMessageParams {
    let params = V2NIMSendTopicMessageParams()
    if let sendMessageParams = arguments["sendMessageParams"] as? [String: Any] {
      params.sendMessageParams = V2NIMSendMessageParams.fromDic(sendMessageParams)
    }
    if let createTopicParams = arguments["createTopicParams"] as? [String: Any] {
      params.createTopicParams = V2NIMCreateTopicParams.fromDic(createTopicParams)
    }
    return params
  }
}

extension V2NIMTopicListOption {
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTopicListOption {
    let option = V2NIMTopicListOption()
    option.conversationId = arguments["conversationId"] as? String
    if let beginTime = nimTopicInt64Value(arguments["beginTime"]) {
      option.beginTime = beginTime
    }
    if let endTime = nimTopicInt64Value(arguments["endTime"]) {
      option.endTime = endTime
    }
    option.nextToken = arguments["nextToken"] as? String
    if let limit = arguments["limit"] as? Int {
      option.limit = limit
    }
    if let dir = arguments["direction"] as? Int,
       let direction = V2NIMQueryDirection(rawValue: dir) {
      option.direction = direction
    }
    return option
  }
}

extension V2NIMTopicListResult {
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMTopicListResult.topicList)] = topicList.map { $0.toDic() }
    keyPaths[#keyPath(V2NIMTopicListResult.nextToken)] = nextToken
    keyPaths[#keyPath(V2NIMTopicListResult.hasMore)] = hasMore
    return keyPaths
  }
}

extension V2NIMTopicMessageListOption {
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTopicMessageListOption {
    let option = V2NIMTopicMessageListOption()
    if let topic = arguments["topic"] as? [String: Any] {
      option.topic = V2NIMTopic.fromDic(topic)
    }
    if let beginTime = nimTopicInt64Value(arguments["beginTime"]) {
      option.beginTime = beginTime
    }
    if let endTime = nimTopicInt64Value(arguments["endTime"]) {
      option.endTime = endTime
    }
    if let anchorMessage = arguments["anchorMessage"] as? [String: Any] {
      option.anchorMessage = V2NIMMessage.fromDict(anchorMessage)
    }
    if let limit = arguments["limit"] as? Int {
      option.limit = limit
    }
    if let dir = arguments["direction"] as? Int,
       let direction = V2NIMQueryDirection(rawValue: dir) {
      option.direction = direction
    }
    if let order = arguments["sortOrder"] as? Int,
       let sortOrder = V2NIMSortOrder(rawValue: order) {
      option.sortOrder = sortOrder
    }
    return option
  }
}

extension V2NIMTopicMessageListResult {
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMTopicMessageListResult.replyList)] = replyList.map { $0.toDict() }
    keyPaths[#keyPath(V2NIMTopicMessageListResult.hasMore)] = hasMore
    keyPaths[#keyPath(V2NIMTopicMessageListResult.anchorMessage)] = anchorMessage?.toDict()
    return keyPaths
  }
}
