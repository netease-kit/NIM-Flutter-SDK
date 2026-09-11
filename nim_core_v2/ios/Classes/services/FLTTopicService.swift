// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK
import UIKit

enum TopicServiceMethodType: String {
  case removeTopics
  case updateTopic
  case sendTopicMessage
  case replyTopicMessage
  case getTopicByRefer
  case getTopicListByOption
  case getTopicMessageList
}

class FLTTopicService: FLTBaseService, FLTService, V2NIMTopicListener {
  override func onInitialized() {
    NIMSDK.shared().v2TopicService.add(self)
  }

  deinit {
    NIMSDK.shared().v2TopicService.remove(self)
  }

  func serviceName() -> String {
    ServiceType.TopicService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any], _ resultCallback: ResultCallback) {
    switch method {
    case TopicServiceMethodType.removeTopics.rawValue:
      removeTopics(arguments, resultCallback)
    case TopicServiceMethodType.updateTopic.rawValue:
      updateTopic(arguments, resultCallback)
    case TopicServiceMethodType.sendTopicMessage.rawValue:
      sendTopicMessage(arguments, resultCallback)
    case TopicServiceMethodType.replyTopicMessage.rawValue:
      replyTopicMessage(arguments, resultCallback)
    case TopicServiceMethodType.getTopicByRefer.rawValue:
      getTopicByRefer(arguments, resultCallback)
    case TopicServiceMethodType.getTopicListByOption.rawValue:
      getTopicListByOption(arguments, resultCallback)
    case TopicServiceMethodType.getTopicMessageList.rawValue:
      getTopicMessageList(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func removeTopics(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TopicService.removeTopics(V2NIMRemoveTopicsParams.fromDic(paramsDic)) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func updateTopic(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TopicService.updateTopic(V2NIMUpdateTopicParams.fromDic(paramsDic)) { topic in
      weakSelf?.successCallBack(resultCallback, topic.toDic())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func sendTopicMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any],
          let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)
    let topic = (arguments["topic"] as? [String: Any]).flatMap(V2NIMTopic.fromDic)
    var params = (arguments["params"] as? [String: Any]).flatMap(V2NIMSendTopicMessageParams.fromDic)
    if topic == nil {
      let createParams = params ?? V2NIMSendTopicMessageParams()
      if createParams.createTopicParams == nil {
        createParams.createTopicParams = V2NIMCreateTopicParams()
      }
      params = createParams
    }
    NIMSDK.shared().v2TopicService.sendTopicMessage(message,
                                                    conversationId: conversationId,
                                                    topic: topic,
                                                    params: params) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    } progress: { _ in
    }
  }

  func replyTopicMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any],
          let replyMessageDic = arguments["replyMessage"] as? [String: Any],
          let topicDic = arguments["topic"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)
    let replyMessage = V2NIMMessage.fromDict(replyMessageDic)
    let topic = V2NIMTopic.fromDic(topicDic)
    let params = (arguments["params"] as? [String: Any]).flatMap(V2NIMSendMessageParams.fromDic)
    NIMSDK.shared().v2TopicService.replyTopicMessage(message,
                                                     reply: replyMessage,
                                                     topic: topic,
                                                     params: params) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    } progress: { _ in
    }
  }

  func getTopicByRefer(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let topicReferDic = arguments["topicRefer"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TopicService.getTopicBy(V2NIMTopicRefer.fromDic(topicReferDic)) { topic in
      weakSelf?.successCallBack(resultCallback, topic.toDic())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func getTopicListByOption(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let optionDic = arguments["option"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TopicService.getTopicList(by: V2NIMTopicListOption.fromDic(optionDic)) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func getTopicMessageList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let optionDic = arguments["option"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2TopicService.getTopicMessageList(V2NIMTopicMessageListOption.fromDic(optionDic)) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func onTopicAdded(_ topic: V2NIMTopic) {
    notifyEvent(serviceName(), "onTopicAdded", topic.toDic())
  }

  func onTopicsRemoved(_ topics: [V2NIMTopicRefer]) {
    notifyEvent(serviceName(), "onTopicsRemoved", ["topics": topics.map { $0.toDic() }])
  }

  func onTopicUpdated(_ topic: V2NIMTopic) {
    notifyEvent(serviceName(), "onTopicUpdated", topic.toDic())
  }
}
