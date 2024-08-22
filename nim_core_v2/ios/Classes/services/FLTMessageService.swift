// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK
import YXAlog_iOS

enum MessageType: String {
  case sendMessage
  case replyMessage
  case revokeMessage
  case getMessageList
  case getMessageListByIds
  case getMessageListByRefers
  case deleteMessage
  case deleteMessages
  case clearHistoryMessage
  case updateMessageLocalExtension
  case insertMessageToLocal
  case pinMessage
  case unpinMessage
  case updatePinMessage
  case getPinnedMessageList
  case addQuickComment
  case removeQuickComment
  case getQuickCommentList
  case addCollection
  case removeCollections
  case updateCollectionExtension
  case getCollectionListByOption
  case sendP2PMessageReceipt
  case getP2PMessageReceipt
  case isPeerRead
  case sendTeamMessageReceipts
  case getTeamMessageReceipts
  case getTeamMessageReceiptDetail
  case voiceToText
  case cancelMessageAttachmentUpload
  case searchCloudMessages
  case getLocalThreadMessageList
  case getThreadMessageList
}

class FLTMessageService: FLTBaseService, FLTService {
  override func onInitialized() {
    NIMSDK.shared().v2MessageService.add(self)
  }

  deinit {
    NIMSDK.shared().v2MessageService.remove(self)
  }

  // MARK: - Protocol

  func serviceName() -> String {
    ServiceType.MessageService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case MessageType.sendMessage.rawValue:
      sendMessage(arguments, resultCallback)
    case MessageType.replyMessage.rawValue:
      replyMessage(arguments, resultCallback)
    case MessageType.revokeMessage.rawValue:
      revokeMessage(arguments, resultCallback)
    case MessageType.getMessageList.rawValue:
      getMessageList(arguments, resultCallback)
    case MessageType.getMessageListByIds.rawValue:
      getMessageListByIds(arguments, resultCallback)
    case MessageType.getMessageListByRefers.rawValue:
      getMessageListByRefers(arguments, resultCallback)
    case MessageType.deleteMessage.rawValue:
      deleteMessage(arguments, resultCallback)
    case MessageType.deleteMessages.rawValue:
      deleteMessages(arguments, resultCallback)
    case MessageType.clearHistoryMessage.rawValue:
      clearHistoryMessage(arguments, resultCallback)
    case MessageType.updateMessageLocalExtension.rawValue:
      updateMessageLocalExtension(arguments, resultCallback)
    case MessageType.insertMessageToLocal.rawValue:
      insertMessageToLocal(arguments, resultCallback)
    case MessageType.pinMessage.rawValue:
      pinMessage(arguments, resultCallback)
    case MessageType.unpinMessage.rawValue:
      unpinMessage(arguments, resultCallback)
    case MessageType.updatePinMessage.rawValue:
      updatePinMessage(arguments, resultCallback)
    case MessageType.getPinnedMessageList.rawValue:
      getPinnedMessageList(arguments, resultCallback)
    case MessageType.addQuickComment.rawValue:
      addQuickComment(arguments, resultCallback)
    case MessageType.removeQuickComment.rawValue:
      removeQuickComment(arguments, resultCallback)
    case MessageType.getQuickCommentList.rawValue:
      getQuickCommentList(arguments, resultCallback)
    case MessageType.addCollection.rawValue:
      addCollection(arguments, resultCallback)
    case MessageType.removeCollections.rawValue:
      removeCollections(arguments, resultCallback)
    case MessageType.updateCollectionExtension.rawValue:
      updateCollectionExtension(arguments, resultCallback)
    case MessageType.getCollectionListByOption.rawValue:
      getCollectionListByOption(arguments, resultCallback)
    case MessageType.sendP2PMessageReceipt.rawValue:
      sendP2PMessageReceipt(arguments, resultCallback)
    case MessageType.getP2PMessageReceipt.rawValue:
      getP2PMessageReceipt(arguments, resultCallback)
    case MessageType.isPeerRead.rawValue:
      isPeerRead(arguments, resultCallback)
    case MessageType.sendTeamMessageReceipts.rawValue:
      sendTeamMessageReceipts(arguments, resultCallback)
    case MessageType.getTeamMessageReceipts.rawValue:
      getTeamMessageReceipts(arguments, resultCallback)
    case MessageType.getTeamMessageReceiptDetail.rawValue:
      getTeamMessageReceiptDetail(arguments, resultCallback)
    case MessageType.voiceToText.rawValue:
      voiceToText(arguments, resultCallback)
    case MessageType.cancelMessageAttachmentUpload.rawValue:
      cancelMessageAttachmentUpload(arguments, resultCallback)
    case MessageType.searchCloudMessages.rawValue:
      searchCloudMessages(arguments, resultCallback)
    case MessageType.getLocalThreadMessageList.rawValue:
      getLocalThreadMessageList(arguments, resultCallback)
    case MessageType.getThreadMessageList.rawValue:
      getThreadMessageList(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
    self.nimCore = nimCore
  }

  // MARK: - SDK API

  func sendMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any],
          let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)

    var params: V2NIMSendMessageParams?
    if let paramsDic = arguments["params"] as? [String: Any] {
      params = V2NIMSendMessageParams.fromDic(paramsDic)
    }

    NIMSDK.shared().v2MessageService.send(message, conversationId: conversationId, params: params) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    } progress: { progress in
      weakSelf?.notifyEvent("MessageService", "onSendMessageProgress", ["messageClientId": message.messageClientId as Any,
                                                                        "progress": progress as Any])
    }
  }

  func replyMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any],
          let replyMessageDic = arguments["replyMessage"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)
    let replyMessage = V2NIMMessage.fromDict(replyMessageDic)

    var params = V2NIMSendMessageParams()
    if let paramsDic = arguments["params"] as? [String: Any] {
      params = V2NIMSendMessageParams.fromDic(paramsDic)
    }

    NIMSDK.shared().v2MessageService.reply(message, reply: replyMessage, params: params) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    } progress: { progress in
      weakSelf?.notifyEvent("MessageService", "onSendMessageProgress", ["messageClientId": message.messageClientId as Any,
                                                                        "progress": progress as Any])
    }
  }

  func revokeMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)

    var revokeParams = V2NIMMessageRevokeParams()
    if let revokeParamsDic = arguments["revokeParams"] as? [String: Any] {
      revokeParams = V2NIMMessageRevokeParams.fromDic(revokeParamsDic)
    }

    NIMSDK.shared().v2MessageService.revokeMessage(message, revokeParams: revokeParams) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func getMessageList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let optionDic = arguments["option"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let option = V2NIMMessageListOption.fromDic(optionDic)

    NIMSDK.shared().v2MessageService.getMessageList(option) { messages in
      let messageDics = messages.map { $0.toDict() }
      weakSelf?.successCallBack(resultCallback, ["messages": messageDics])
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func getMessageListByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageIds = arguments["messageClientIds"] as? [String] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2MessageService.getMessageList(byIds: messageIds) { messages in
      let messageDics = messages.map { $0.toDict() }
      weakSelf?.successCallBack(resultCallback, ["messages": messageDics])
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func getMessageListByRefers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageRefersDics = arguments["messageRefers"] as? [[String: Any]] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let messageRefers = messageRefersDics.map { V2NIMMessageRefer.fromDic($0) }

    NIMSDK.shared().v2MessageService.getMessageList(by: messageRefers) { messages in
      let messageDics = messages.map { $0.toDict() }
      weakSelf?.successCallBack(resultCallback, ["messages": messageDics])
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func deleteMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let serverExtension = arguments["serverExtension"] as? String ?? ""
    let onlyDeleteLocal = arguments["onlyDeleteLocal"] as? Bool ?? true
    let message = V2NIMMessage.fromDict(messageDic)

    NIMSDK.shared().v2MessageService.delete(message, serverExtension: serverExtension, onlyDeleteLocal: onlyDeleteLocal) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func deleteMessages(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDics = arguments["messages"] as? [[String: Any]] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let serverExtension = arguments["serverExtension"] as? String ?? ""
    let onlyDeleteLocal = arguments["onlyDeleteLocal"] as? Bool ?? true
    let messages = messageDics.map { V2NIMMessage.fromDict($0) }

    NIMSDK.shared().v2MessageService.delete(messages, serverExtension: serverExtension, onlyDeleteLocal: onlyDeleteLocal) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func clearHistoryMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let optionDic = arguments["option"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let option = V2NIMClearHistoryMessageOption.fromDic(optionDic)

    NIMSDK.shared().v2MessageService.clearHistoryMessage(option) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func updateMessageLocalExtension(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any],
          let localExtension = arguments["localExtension"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)

    NIMSDK.shared().v2MessageService.updateMessageLocalExtension(message, localExtension: localExtension) { message in
      weakSelf?.successCallBack(resultCallback, message.toDict())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func insertMessageToLocal(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any],
          let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)
    let senderId = arguments["senderId"] as? String ?? NIMSDK.shared().loginManager.currentAccount()
    let createTime = arguments["createTime"] as? Int ?? 0
    let time = TimeInterval(createTime / 1000)

    NIMSDK.shared().v2MessageService.insertMessage(toLocal: message,
                                                   conversationId: conversationId,
                                                   senderId: senderId,
                                                   createTime: time) { message in
      weakSelf?.successCallBack(resultCallback, message.toDict())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func pinMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let messageRefer = V2NIMMessageRefer.fromDic(messageDic)
    let serverExtension = arguments["serverExtension"] as? String ?? ""

    NIMSDK.shared().v2MessageService.getMessageList(by: [messageRefer]) { messages in
      if let message = messages.first {
        NIMSDK.shared().v2MessageService.pinMessage(message, serverExtension: serverExtension) {
          weakSelf?.successCallBack(resultCallback, nil)
        } failure: { error in
          let err = error.nserror as NSError
          weakSelf?.errorCallBack(resultCallback, err.description, err.code)
        }
      }
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func unpinMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageReferDic = arguments["messageRefer"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let messageRefer = V2NIMMessageRefer.fromDic(messageReferDic)
    let serverExtension = arguments["serverExtension"] as? String ?? ""

    NIMSDK.shared().v2MessageService.unpinMessage(messageRefer, serverExtension: serverExtension) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func updatePinMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)
    let serverExtension = arguments["serverExtension"] as? String ?? ""

    NIMSDK.shared().v2MessageService.updatePinMessage(message, serverExtension: serverExtension) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func getPinnedMessageList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2MessageService.getPinnedMessageList(conversationId) { pinMessages in
      let pinMessageDics = pinMessages.map { $0.toDic() }
      weakSelf?.successCallBack(resultCallback, ["pinMessages": pinMessageDics])
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func addQuickComment(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any],
          let index = arguments["index"] as? Int else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)
    let serverExtension = arguments["serverExtension"] as? String ?? ""

    var pushConfig = V2NIMMessageQuickCommentPushConfig()
    if let pushConfigDic = arguments["pushConfig"] as? [String: Any] {
      pushConfig = V2NIMMessageQuickCommentPushConfig.fromDic(pushConfigDic)
    }

    NIMSDK.shared().v2MessageService.addQuickComment(message,
                                                     index: index,
                                                     serverExtension: serverExtension,
                                                     pushConfig: pushConfig) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func removeQuickComment(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageReferDic = arguments["messageRefer"] as? [String: Any],
          let index = arguments["index"] as? Int else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let messageRefer = V2NIMMessageRefer.fromDic(messageReferDic)
    let serverExtension = arguments["serverExtension"] as? String ?? ""

    NIMSDK.shared().v2MessageService.removeQuickComment(messageRefer,
                                                        index: index,
                                                        serverExtension: serverExtension) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func getQuickCommentList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDics = arguments["messages"] as? [[String: Any]] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let messages = messageDics.map { V2NIMMessage.fromDict($0) }

    NIMSDK.shared().v2MessageService.getQuickCommentList(messages) { quickComments in
      var quickCommentsMap = [String: [[String: Any]]]()
      for (key, value) in quickComments {
        var quickCommentsList = [[String: Any]]()
        for quickComment in value {
          quickCommentsList.append(quickComment.toDic())
        }
        quickCommentsMap[key] = quickCommentsList
      }
      weakSelf?.successCallBack(resultCallback, quickCommentsMap)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func addCollection(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let params = V2NIMAddCollectionParams.fromDic(paramsDic)

    NIMSDK.shared().v2MessageService.addCollection(params) { collection in
      weakSelf?.successCallBack(resultCallback, collection.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func removeCollections(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let collectionDics = arguments["collections"] as? [[String: Any]] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let collections = collectionDics.map { V2NIMCollection.fromDic($0) }

    NIMSDK.shared().v2MessageService.remove(collections) { count in
      weakSelf?.successCallBack(resultCallback, count)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func updateCollectionExtension(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let collectionDic = arguments["collection"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let collection = V2NIMCollection.fromDic(collectionDic)
    let serverExtension = arguments["serverExtension"] as? String ?? ""

    NIMSDK.shared().v2MessageService.updateCollectionExtension(collection, serverExtension: serverExtension) { collection in
      weakSelf?.successCallBack(resultCallback, collection.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func getCollectionListByOption(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let optionDic = arguments["option"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let option = V2NIMCollectionOption.fromDic(optionDic)

    NIMSDK.shared().v2MessageService.getCollectionList(by: option) { collections in
      let collectionDics = collections.map { $0.toDic() }
      weakSelf?.successCallBack(resultCallback, ["collections": collectionDics])
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func sendP2PMessageReceipt(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)

    NIMSDK.shared().v2MessageService.sendP2PMessageReceipt(message) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func getP2PMessageReceipt(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2MessageService.getP2PMessageReceipt(conversationId) { readReceipt in
      weakSelf?.successCallBack(resultCallback, readReceipt.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func isPeerRead(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let message = V2NIMMessage.fromDict(messageDic)
    let isPeerRead = NIMSDK.shared().v2MessageService.isPeerRead(message)
    successCallBack(resultCallback, isPeerRead)
  }

  func sendTeamMessageReceipts(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDics = arguments["messages"] as? [[String: Any]] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let messages = messageDics.map { V2NIMMessage.fromDict($0) }

    NIMSDK.shared().v2MessageService.sendTeamMessageReceipts(messages) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func getTeamMessageReceipts(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDics = arguments["messages"] as? [[String: Any]] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let messages = messageDics.map { V2NIMMessage.fromDict($0) }

    NIMSDK.shared().v2MessageService.getTeamMessageReceipts(messages) { readReceipts in
      let readReceiptDics = readReceipts.map { $0.toDic() }
      weakSelf?.successCallBack(resultCallback, ["readReceipts": readReceiptDics])
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func getTeamMessageReceiptDetail(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)

    var memberAccountIds = Set<String>()
    if let memberAccountIdList = arguments["memberAccountIds"] as? [String] {
      memberAccountIds = Set<String>(memberAccountIdList)
    }

    NIMSDK.shared().v2MessageService.getTeamMessageReceiptDetail(message, memberAccountIds: memberAccountIds) { readReceiptDetail in
      weakSelf?.successCallBack(resultCallback, readReceiptDetail.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func voiceToText(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let params = V2NIMVoiceToTextParams.fromDic(paramsDic)

    NIMSDK.shared().v2MessageService.voice(toText: params) { result in
      weakSelf?.successCallBack(resultCallback, result)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func cancelMessageAttachmentUpload(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)

    NIMSDK.shared().v2MessageService.cancelMessageAttachmentUpload(message) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func searchCloudMessages(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let params = V2NIMMessageSearchParams.fromDic(paramsDic)

    NIMSDK.shared().v2MessageService.searchCloudMessages(params) { messages in
      let messageDics = messages.map { $0.toDict() }
      weakSelf?.successCallBack(resultCallback, ["messages": messageDics])
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func getLocalThreadMessageList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageReferDic = arguments["messageRefer"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let messageRefer = V2NIMMessageRefer.fromDic(messageReferDic)

    NIMSDK.shared().v2MessageService.getLocalThreadMessageList(messageRefer) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }

  func getThreadMessageList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let optionDic = arguments["option"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let option = V2NIMThreadMessageListOption.fromDic(optionDic)

    NIMSDK.shared().v2MessageService.getThreadMessageList(option) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
    }
  }
}

// MARK: - V2NIMMessageListener

extension FLTMessageService: V2NIMMessageListener {
  func onReceiveMessagesModified(_ messages: [V2NIMMessage]) {
    let messagesList = messages.map { $0.toDict() }
    notifyEvent(serviceName(), "onReceiveMessagesModified", ["messages": messagesList])
  }

  private func notifyEvent(_ method: String, _ arguments: inout [String: Any]) {
    arguments["serviceName"] = serviceName()
    nimCore?.getMethodChannel()?.invokeMethod(method, arguments)
  }

  func onSend(_ message: V2NIMMessage) {
    notifyEvent(serviceName(), "onSendMessage", message.toDict())
  }

  func onReceive(_ messages: [V2NIMMessage]) {
    let messagesList = messages.map { $0.toDict() }
    notifyEvent(serviceName(), "onReceiveMessages", ["messages": messagesList])
  }

  func onReceive(_ readReceipts: [V2NIMP2PMessageReadReceipt]) {
    let readReceiptsList = readReceipts.map { $0.toDic() }
    notifyEvent(serviceName(), "onReceiveP2PMessageReadReceipts", ["p2pMessageReadReceipts": readReceiptsList])
  }

  func onReceive(_ readReceipts: [V2NIMTeamMessageReadReceipt]) {
    let readReceiptsList = readReceipts.map { $0.toDic() }
    notifyEvent(serviceName(), "onReceiveTeamMessageReadReceipts", ["teamMessageReadReceipts": readReceiptsList])
  }

  func onMessageRevokeNotifications(_ revokeNotifications: [V2NIMMessageRevokeNotification]) {
    let revokeNotificationsList = revokeNotifications.map { $0.toDic() }
    notifyEvent(serviceName(), "onMessageRevokeNotifications", ["revokeNotifications": revokeNotificationsList])
  }

  func onMessagePinNotification(_ pinNotification: V2NIMMessagePinNotification) {
    notifyEvent(serviceName(), "onMessagePinNotification", pinNotification.toDic())
  }

  func onMessageQuickCommentNotification(_ notification: V2NIMMessageQuickCommentNotification) {
    notifyEvent(serviceName(), "onMessageQuickCommentNotification", notification.toDic())
  }

  func onMessageDeletedNotifications(_ messageDeletedNotification: [V2NIMMessageDeletedNotification]) {
    let messageDeletedNotificationList = messageDeletedNotification.map { $0.toDic() }
    notifyEvent(serviceName(), "onMessageDeletedNotifications", ["deletedNotifications": messageDeletedNotificationList])
  }

  func onClearHistoryNotifications(_ clearHistoryNotification: [V2NIMClearHistoryNotification]) {
    let clearHistoryNotificationList = clearHistoryNotification.map { $0.toDic() }
    notifyEvent(serviceName(), "onClearHistoryNotifications", ["clearHistoryNotifications": clearHistoryNotificationList])
  }
}
