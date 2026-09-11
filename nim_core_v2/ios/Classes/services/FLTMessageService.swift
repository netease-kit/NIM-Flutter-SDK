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
  case insertMessageToLocalEx
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
  case messageSerialization
  case messageDeserialization
  case modifyMessage
  case stopAIStreamMessage
  case regenAIMessage
  case searchLocalMessages
  case searchCloudMessagesEx
  case getMessageListEx
  case getCollectionListExByOption
  case updateLocalMessage
  case setMessageFilter
  case clearRoamingMessage
  case clearLocalMessage
  case translateText
}

class FLTMessageService: FLTBaseService, FLTService {
  private static let className = "FLTMessageService"

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
    case MessageType.insertMessageToLocalEx.rawValue:
      insertMessageToLocalEx(arguments, resultCallback)
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
    case MessageType.messageSerialization.rawValue:
      messageSerialization(arguments, resultCallback)
    case MessageType.messageDeserialization.rawValue:
      messageDeserialization(arguments, resultCallback)
    case MessageType.modifyMessage.rawValue:
      modifyMessage(arguments, resultCallback)
    case MessageType.regenAIMessage.rawValue:
      regenAIMessage(arguments, resultCallback)
    case MessageType.stopAIStreamMessage.rawValue:
      stopAIStreamMessage(arguments, resultCallback)
    case MessageType.searchCloudMessagesEx.rawValue:
      searchCloudMessagesEx(arguments, resultCallback)
    case MessageType.searchLocalMessages.rawValue:
      searchLocalMessages(arguments, resultCallback)
    case MessageType.getMessageListEx.rawValue:
      getMessageListEx(arguments, resultCallback)
    case MessageType.getCollectionListExByOption.rawValue:
      getCollectionListExByOption(arguments, resultCallback)
    case MessageType.updateLocalMessage.rawValue:
      updateLocalMessage(arguments, resultCallback)
    case MessageType.setMessageFilter.rawValue:
      setMessageFilter(arguments, resultCallback)
    case MessageType.clearRoamingMessage.rawValue:
      clearRoamingMessage(arguments, resultCallback)
    case MessageType.clearLocalMessage.rawValue:
      clearLocalMessage(arguments, resultCallback)
    case MessageType.translateText.rawValue:
      translateText(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  // MARK: - SDK API

  func sendMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any],
          let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }

    let message = V2NIMMessage.fromDict(messageDic)
    let params = (arguments["params"] as? [String: Any]).flatMap(V2NIMSendMessageParams.fromDic)

    if message.sendingState == .MESSAGE_SENDING_STATE_FAILED, let clientId = message.messageClientId {
      NIMSDK.shared().v2MessageService.getMessageList(byIds: [clientId]) { [weak self] messages in
        guard let self = self else { return }
        let targetMessage = messages.first ?? message
        self.sendMessage(targetMessage, conversationId: conversationId, params: params, resultCallback: resultCallback)
      }
    } else {
      sendMessage(message, conversationId: conversationId, params: params, resultCallback: resultCallback)
    }
  }

  private func sendMessage(_ message: V2NIMMessage,
                           conversationId: String,
                           params: V2NIMSendMessageParams?,
                           resultCallback: ResultCallback) {
    NIMSDK.shared().v2MessageService.send(message,
                                          conversationId: conversationId,
                                          params: params) { [weak self] result in
      self?.successCallBack(resultCallback, result.toDic())
    } failure: { [weak self] error in
      let err = error.nserror as NSError
      self?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTMessageService.className, desc: "sendMessage error \(error.nserror.localizedDescription)")
    } progress: { [weak self] progress in
      self?.notifyEvent(ServiceType.MessageService.rawValue,
                        "onSendMessageProgress",
                        ["messageClientId": message.messageClientId as Any,
                         "progress": progress])
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
      FLTALog.errorLog(FLTMessageService.className, desc: "replyMessage error \(error.nserror.localizedDescription)")
    } progress: { progress in
      weakSelf?.notifyEvent(ServiceType.MessageService.rawValue,
                            "onSendMessageProgress",
                            ["messageClientId": message.messageClientId as Any,
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
      FLTALog.errorLog(FLTMessageService.className, desc: "revokeMessage error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "getMessageList error \(error.nserror.localizedDescription)")
    }
  }

  func getMessageListEx(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let optionDic = arguments["option"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let option = V2NIMMessageListOption.fromDic(optionDic)

    NIMSDK.shared().v2MessageService.getMessageListEx(option) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTMessageService.className, desc: "getMessageListEx error \(error.nserror.localizedDescription)")
    }
  }

  func getCollectionListExByOption(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let optionDic = arguments["option"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let option = V2NIMCollectionOption.fromDic(optionDic)

    NIMSDK.shared().v2MessageService.getCollectionListEx(by: option, success: { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    }, failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTMessageService.className, desc: "getMessageList error \(error.nserror.localizedDescription)")
    })
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
      FLTALog.errorLog(FLTMessageService.className, desc: "getMessageListByIds error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "getMessageListByRefers error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "deleteMessage error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "deleteMessages error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "clearHistoryMessage error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "updateMessageLocalExtension error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "insertMessageToLocal error \(error.nserror.localizedDescription)")
    }
  }

  func insertMessageToLocalEx(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any],
          let paramsDic = arguments["params"] as? [String: Any],
          let conversationId = paramsDic["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)
    let senderId = paramsDic["senderId"] as? String ?? ""
    let createTime = paramsDic["createTime"] as? Int ?? 0
    let time = TimeInterval(createTime / 1000)
    let lastMessageUpdateEnabled = paramsDic["lastMessageUpdateEnabled"] as? Bool ?? true

    let params = V2NIMMessageInsertParams()
    params.conversationId = conversationId
    params.createTime = time
    params.lastMessageUpdateEnabled = lastMessageUpdateEnabled
    params.senderId = senderId

    NIMSDK.shared().v2MessageService.insertMessage(toLocalEx: message,
                                                   params: params) { message in
      weakSelf?.successCallBack(resultCallback, message.toDict())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTMessageService.className, desc: "insertMessageToLocalEx error \(error.nserror.localizedDescription)")
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
          FLTALog.errorLog(FLTMessageService.className, desc: "pinMessage error \(error.nserror.localizedDescription)")
        }
      }
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTMessageService.className, desc: "getMessageList error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "unpinMessage error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "updatePinMessage error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "getPinnedMessageList error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "addQuickComment error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "removeQuickComment error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "getQuickCommentList error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "addCollection error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "removeCollections error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "updateCollectionExtension error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "getCollectionListByOption error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "sendP2PMessageReceipt error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "getP2PMessageReceipt error \(error.nserror.localizedDescription)")
    }
  }

  func isPeerRead(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)

    // SDK isPeerRead 方法存在序列化问题，先自行实现
    NIMSDK.shared().v2MessageService.getP2PMessageReceipt(message.conversationId ?? "") { readReceipt in
      let isPeerRead = message.createTime <= readReceipt.timestamp
      weakSelf?.successCallBack(resultCallback, isPeerRead)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTMessageService.className, desc: "isPeerRead(getP2PMessageReceipt) error \(error.nserror.localizedDescription)")
    }
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
      FLTALog.errorLog(FLTMessageService.className, desc: "sendTeamMessageReceipts error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "getTeamMessageReceipts error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "getTeamMessageReceiptDetail error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "voiceToText error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "cancelMessageAttachmentUpload error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "searchCloudMessages error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "getLocalThreadMessageList error \(error.nserror.localizedDescription)")
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
      FLTALog.errorLog(FLTMessageService.className, desc: "getThreadMessageList error \(error.nserror.localizedDescription)")
    }
  }

  func messageSerialization(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let message = V2NIMMessage.fromDict(messageDic)

    let msg = V2NIMMessageConverter.messageSerialization(message)

    successCallBack(resultCallback, msg)
  }

  func messageDeserialization(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let msgStr = arguments["msg"] as? String else {
      parameterError(resultCallback)
      return
    }
    let message = V2NIMMessageConverter.messageDeserialization(msgStr)

    successCallBack(resultCallback, message?.toDict())
  }

  func modifyMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any],
          let _ = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)
    let params = V2NIMModifyMessageParams.fromDic(arguments)
    NIMSDK.shared().v2MessageService.modifyMessage(message, params: params) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTMessageService.className, desc: "modifyMessage error \(error.nserror.localizedDescription)")
    }
  }

  func regenAIMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any],
          let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)
    let params = V2NIMMessageAIRegenParams.fromDic(paramsDic)
    NIMSDK.shared().v2MessageService.regenAIMessage(message, params: params) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTMessageService.className, desc: "regenAIMessage error \(error.nserror.localizedDescription)")
    }
  }

  func stopAIStreamMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any],
          let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)
    let params = V2NIMMessageAIStreamStopParams.fromDic(paramsDic)
    NIMSDK.shared().v2MessageService.stopAIStreamMessage(message, params: params) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTMessageService.className, desc: "stopAIStreamMessage error \(error.nserror.localizedDescription)")
    }
  }

  func searchCloudMessagesEx(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let params = V2NIMMessageSearchExParams.fromDic(paramsDic)
    NIMSDK.shared().v2MessageService.searchCloudMessagesEx(params) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTMessageService.className, desc: "searchCloudMessagesEx error \(error.nserror.localizedDescription)")
    }
  }

  func searchLocalMessages(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let params = V2NIMMessageSearchExParams.fromDic(paramsDic)
    NIMSDK.shared().v2MessageService.searchLocalMessages(params) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTMessageService.className, desc: "searchLocalMessages error \(error.nserror.localizedDescription)")
    }
  }

  func setMessageFilter(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let filter = arguments["filter"] as? Bool ?? false
    if filter {
      NIMSDK.shared().v2MessageService.setMessageFilter(self)
    } else {
      NIMSDK.shared().v2MessageService.setMessageFilter(nil)
    }
    successCallBack(resultCallback, nil)
  }

  func updateLocalMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any],
          let _ = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let message = V2NIMMessage.fromDict(messageDic)
    let params = V2NIMUpdateLocalMessageParams.fromDic(arguments)
    NIMSDK.shared().v2MessageService.updateLocalMessage(message, params: params) { result in
      weakSelf?.successCallBack(resultCallback, result.toDict())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTMessageService.className, desc: "updateLocalMessage error \(error.nserror.localizedDescription)")
    }
  }

  func clearRoamingMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationIds = arguments["conversationIds"] as? [String] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2MessageService.clearRoamingMessage(conversationIds) {
      // 成功回调
      weakSelf?.successCallBack(resultCallback, ["success": true])
    } failure: { error in
      // 失败回调
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTMessageService.className, desc: "clearRoamingMessage error \(error.nserror.localizedDescription)")
    }
  }

  /// 清除指定时间点之前的本地消息（10.9.7）
  func clearLocalMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    weak var weakSelf = self
    guard let paramsMap = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let params = V2NIMClearLocalMessageParams()

    if let anchorTime = paramsMap["anchorTime"] as? Int64 {
      params.anchorTime = anchorTime
    }
    if let deleteConversation = paramsMap["deleteConversation"] as? Bool {
      params.deleteConversation = deleteConversation
    }

    NIMSDK.shared().v2MessageService.clearLocalMessage(params) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTMessageService.className, desc: "clearLocalMessage error \(error.nserror.localizedDescription)")
    }
  }

  /// 文本翻译（10.9.75）
  func translateText(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any],
          let text = paramsDic["text"] as? String,
          let targetLanguage = paramsDic["targetLanguage"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let translateParams = V2NIMTextTranslateParams()
    translateParams.text = text
    translateParams.targetLanguage = targetLanguage
    if let sourceLanguage = paramsDic["sourceLanguage"] as? String {
      translateParams.sourceLanguage = sourceLanguage
    }

    NIMSDK.shared().v2MessageService.translateText(translateParams) { result in
      var resultDic = [String: Any?]()
      resultDic["translatedText"] = result.translatedText
      resultDic["sourceLanguage"] = result.sourceLanguage
      resultDic["targetLanguage"] = result.targetLanguage
      weakSelf?.successCallBack(resultCallback, resultDic as [String: Any])
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTMessageService.className, desc: "translateText error \(error.nserror.localizedDescription)")
    }
  }
}

extension FLTMessageService: V2NIMMessageFilter {
  func shouldIgnore(_ message: V2NIMMessage) -> Bool {
    if Thread.isMainThread {
      return false
    }
    let semaphore = DispatchSemaphore(value: 0)
    nimCore?.addSemaphore(semaphore)
    var ignore = false
    notifyEvent(
      serviceName(),
      "shouldIgnore",
      ["message": message.toDict()],
      result: { r in
        ignore = r as? Bool ?? false
        semaphore.signal()
      }
    )
    semaphore.wait()
    return ignore
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
