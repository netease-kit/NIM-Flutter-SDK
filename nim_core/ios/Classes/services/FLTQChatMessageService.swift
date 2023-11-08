// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

enum QChatMessageMethod: String {
  case sendMessage
  case resendMessage
  case updateMessage
  case revokeMessage
  case deleteMessage
  case downloadAttachment
  case getMessageHistory
  case getMessageHistoryByIds
  case markMessageRead
  case markSystemNotificationsRead
  case sendSystemNotification
  case resendSystemNotification
  case updateSystemNotification
  case replyMessage
  case getReferMessages
  case getThreadMessages
  case getMessageThreadInfos
  case addQuickComment
  case removeQuickComment
  case getQuickComments
  case getMessageCache
  case clearMessageCache
  case getLastMessageOfChannels
  case searchMsgByPage
  case areMentionedMeMessages
  case getMentionedMeMessages
  case sendTypingEvent
}

class FLTQChatMessageService: FLTBaseService, FLTService {
  var sendedMsgCallback: ResultCallback?
  private let paramErrorTip = "参数错误"
  private let paramErrorCode = 414

  override func onInitialized() {
    NIMSDK.shared().qchatManager.add(self)
    NIMSDK.shared().qchatMessageManager.add(self)
  }

  deinit {
    NIMSDK.shared().qchatManager.remove(self)
    NIMSDK.shared().qchatMessageManager.remove(self)
  }

  func serviceName() -> String {
    ServiceType.QChatMessageService.rawValue
  }

  func serviceDelegateName() -> String {
    ServiceType.QChatObserver.rawValue
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case QChatMessageMethod.sendMessage.rawValue:
      qChatSendMessage(arguments, resultCallback)
    case QChatMessageMethod.resendMessage.rawValue:
      qChatResendMessage(arguments, resultCallback)
    case QChatMessageMethod.updateMessage.rawValue:
      qChatUpdateMessage(arguments, resultCallback)
    case QChatMessageMethod.revokeMessage.rawValue:
      qChatRevokeMessage(arguments, resultCallback)
    case QChatMessageMethod.deleteMessage.rawValue:
      qChatDeleteMessage(arguments, resultCallback)
    case QChatMessageMethod.downloadAttachment.rawValue:
      qChatDownloadAttachment(arguments, resultCallback)
    case QChatMessageMethod.getMessageHistory.rawValue:
      qChatGetMessageHistory(arguments, resultCallback)
    case QChatMessageMethod.getMessageHistoryByIds.rawValue:
      qChatGetMessageHistoryByIds(arguments, resultCallback)
    case QChatMessageMethod.markMessageRead.rawValue:
      qChatMarkMessageRead(arguments, resultCallback)
    case QChatMessageMethod.markSystemNotificationsRead.rawValue:
      qChatMarkSystemNotificationsRead(arguments, resultCallback)
    case QChatMessageMethod.sendSystemNotification.rawValue:
      qChatSendSystemNotification(arguments, resultCallback)
    case QChatMessageMethod.resendSystemNotification.rawValue:
      qChatResendSystemNotification(arguments, resultCallback)
    case QChatMessageMethod.updateSystemNotification.rawValue:
      qChatUpdateSystemNotification(arguments, resultCallback)
    case QChatMessageMethod.replyMessage.rawValue:
      qChatReplyMessage(arguments, resultCallback)
    case QChatMessageMethod.getReferMessages.rawValue:
      qChatGetReferMessages(arguments, resultCallback)
    case QChatMessageMethod.getThreadMessages.rawValue:
      qChatGetThreadMessages(arguments, resultCallback)
    case QChatMessageMethod.getMessageThreadInfos.rawValue:
      qChatGetMessageThreadInfos(arguments, resultCallback)
    case QChatMessageMethod.addQuickComment.rawValue:
      qChatAddQuickComment(arguments, resultCallback)
    case QChatMessageMethod.removeQuickComment.rawValue:
      qChatRemoveQuickComment(arguments, resultCallback)
    case QChatMessageMethod.getQuickComments.rawValue:
      qChatGetQuickComments(arguments, resultCallback)
    case QChatMessageMethod.getMessageCache.rawValue:
      qChatGetMessageCache(arguments, resultCallback)
    case QChatMessageMethod.clearMessageCache.rawValue:
      qChatClearMessageCache(arguments, resultCallback)
    case QChatMessageMethod.getLastMessageOfChannels.rawValue:
      qChatGetLastMessageOfChannels(arguments, resultCallback)
    case QChatMessageMethod.searchMsgByPage.rawValue:
      qChatSearchMsgByPage(arguments, resultCallback)
    case QChatMessageMethod.sendTypingEvent.rawValue:
      sendTypingEvent(arguments, resultCallback)
    case QChatMessageMethod.areMentionedMeMessages.rawValue:
      areMentionedMeMessages(arguments, resultCallback)
    case QChatMessageMethod.getMentionedMeMessages.rawValue:
      getMentionedMeMessages(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func qChatMessageCallback(_ error: Error?, _ data: Any?, _ resultCallback: ResultCallback) {
    if let ns_error = error as NSError? {
      errorCallBack(resultCallback, ns_error.description, ns_error.code)
    } else {
      successCallBack(resultCallback, data)
    }
  }

  func qChatSendMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let cId = arguments["channelId"] as? Int,
          let sId = arguments["serverId"] as? Int else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    let qchatChannelId = Int64(cId)
    let qchatServerId = Int64(sId)
    let session = NIMSession(forQChat: qchatChannelId, qchatServerId: qchatServerId)
    let qMsg = NIMQChatMessage.convertToMessage(arguments) ?? NIMQChatMessage()
    qMsg.setValue(session, forKeyPath: #keyPath(NIMQChatMessage.session))

    sendedMsgCallback = resultCallback
    NIMSDK.shared().qchatMessageManager.send(qMsg, to: session) { [weak self] error in
      if let ns_error = error as NSError? {
        self?.errorCallBack(resultCallback, ns_error.description, ns_error.code)
      }
    }
  }

  func qChatResendMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let arg = arguments["message"] as? [String: Any] else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    if let qMsg = NIMQChatMessage.convertToMessage(arg) {
      do {
        let qchatChannelId = Int64(arg["qChatChannelId"] as? Int ?? 0)
        let qchatServerId = Int64(arg["qChatServerId"] as? Int ?? 0)
        let session = NIMSession(forQChat: qchatChannelId, qchatServerId: qchatServerId)
        qMsg.setValue(session, forKeyPath: #keyPath(NIMQChatMessage.session))
        sendedMsgCallback = resultCallback
        try NIMSDK.shared().qchatMessageManager.resend(qMsg)
      } catch {
        errorCallBack(resultCallback, error.localizedDescription)
      }
    } else {
      errorCallBack(
        resultCallback,
        "param error",
        414
      )
    }
  }

  func qChatUpdateMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatUpdateMessageParam.fromDic(arguments),
          let sea = NIMQChatGetMessageHistoryParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatMessageManager.getMessageHistory(sea) { [weak self] error, result in
      if let err = error {
        print(
          "@@#❌qChatUpdateMessage -> getMessageHistory FAILED, error: ",
          err
        )
        self?.qChatMessageCallback(error, nil, resultCallback)
      } else {
        if let res = result,
           let msgs = res.messages {
          if msgs.count > 0,
             let msg = msgs.first {
            request.message = msg
            NIMSDK.shared().qchatMessageManager.updateMessage(request) { error, res in
              self?.qChatMessageCallback(error, ["message": res?.toDict()], resultCallback)
            }
          } else {
            self?.errorCallBack(
              resultCallback,
              self?.paramErrorTip ?? "参数错误",
              self?.paramErrorCode ?? 414
            )
          }
        }
      }
    }
  }

  func qChatRevokeMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatRevokeMessageParam.fromDic(arguments),
          let sea = NIMQChatGetMessageHistoryByIdsParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatMessageManager.getMessageHistory(byIds: sea) { [weak self] error, result in
      if let err = error {
        print(
          "@@#❌qChatRevokeMessage -> getMessageHistoryByIds FAILED, error: ",
          err
        )
        self?.qChatMessageCallback(error, nil, resultCallback)
      } else {
        if let res = result,
           let msgs = res.messages {
          if msgs.count > 0,
             let msg = msgs.first {
            request.message = msg
            NIMSDK.shared().qchatMessageManager.revokeMessage(request) { error, result in
              self?.qChatMessageCallback(error, ["message": result?.toDict()], resultCallback)
            }
          } else {
            self?.errorCallBack(
              resultCallback,
              self?.paramErrorTip ?? "参数错误",
              self?.paramErrorCode ?? 414
            )
          }
        }
      }
    }
  }

  func qChatDeleteMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatDeleteMessageParam.fromDic(arguments),
          let sea = NIMQChatGetMessageHistoryByIdsParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    NIMSDK.shared().qchatMessageManager.getMessageHistory(byIds: sea) { [weak self] error, result in
      if let err = error {
        print(
          "@@#❌qChatDeleteMessage -> getMessageHistoryByIds FAILED, error: ",
          err
        )
        self?.qChatMessageCallback(error, nil, resultCallback)
      } else {
        if let res = result,
           let msgs = res.messages {
          if msgs.count > 0,
             let msg = msgs.first {
            request.message = msg
            NIMSDK.shared().qchatMessageManager.deleteMessage(request) { error, result in
              self?.qChatMessageCallback(error, ["message": result?.toDict()], resultCallback)
            }
          } else {
            self?.errorCallBack(
              resultCallback,
              self?.paramErrorTip ?? "参数错误",
              self?.paramErrorCode ?? 414
            )
          }
        }
      }
    }
  }

  func qChatDownloadAttachment(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let arg = arguments["message"] as? [String: Any] else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    let sea = NIMQChatGetMessageHistoryByIdsParam()
    if let channelId = arg["qChatChannelId"] as? UInt64 {
      sea.channelId = channelId
    }
    if let serverId = arg["qChatServerId"] as? UInt64 {
      sea.serverId = serverId
    }
    let id = NIMQChatMessageServerIdInfo.fromDic(arg)
    sea.ids = [id]
    NIMSDK.shared().qchatMessageManager.getMessageHistory(byIds: sea) { [weak self] error, result in
      if let err = error {
        print(
          "@@#❌qChatDownloadAttachment -> getMessageHistoryByIds FAILED, error: ",
          err
        )
        self?.qChatMessageCallback(error, nil, resultCallback)
      } else {
        if let res = result,
           let msgs = res.messages {
          if msgs.count > 0,
             let msg = msgs.first {
            do {
              try NIMSDK.shared().qchatMessageManager.fetchMessageAttachment(msg)
              self?.successCallBack(resultCallback, nil)
            } catch {
              self?.errorCallBack(resultCallback, error.localizedDescription)
            }
          } else {
            self?.errorCallBack(
              resultCallback,
              self?.paramErrorTip ?? "参数错误",
              self?.paramErrorCode ?? 414
            )
          }
        }
      }
    }
  }

  func qChatGetMessageHistory(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetMessageHistoryParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatMessageManager.getMessageHistory(request) { [weak self] error, result in
      self?.qChatMessageCallback(error, ["messages": result?.toDict()], resultCallback)
    }
  }

  func qChatGetMessageHistoryByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetMessageHistoryByIdsParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatMessageManager
      .getMessageHistory(byIds: request) { [weak self] error, result in
        self?.qChatMessageCallback(error, ["messages": result?.toDict()], resultCallback)
      }
  }

  func qChatMarkMessageRead(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatMarkMessageReadParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatMessageManager.markMessageRead(request) { [weak self] error in
      self?.qChatMessageCallback(error, nil, resultCallback)
    }
  }

  func qChatMarkSystemNotificationsRead(_ arguments: [String: Any],
                                        _ resultCallback: ResultCallback) {
    guard let request = NIMQChatMarkSystemNotificationsReadParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatMessageManager.markSystemNotificationsRead(request) { [weak self] error in
      self?.qChatMessageCallback(error, nil, resultCallback)
    }
  }

  func qChatSendSystemNotification(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatSendSystemNotificationParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatMessageManager
      .sendSystemNotification(request) { [weak self] error, result in
        self?.qChatMessageCallback(
          error,
          ["sentCustomNotification": result?.toDict()],
          resultCallback
        )
      }
  }

  func qChatResendSystemNotification(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatResendSystemNotificationParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatMessageManager
      .resendSystemNotification(request) { [weak self] error, result in
        self?.qChatMessageCallback(error, result?.toDict(), resultCallback)
      }
  }

  func qChatUpdateSystemNotification(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatUpdateSystemNotificationParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatMessageManager
      .updateSystemNotification(request) { [weak self] error, result in
        self?.qChatMessageCallback(error, result?.toDict(), resultCallback)
      }
  }

  func qChatReplyMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let msgArg = arguments["message"] as? [String: Any],
          let replyMsgArg = arguments["replyMessage"] as? [String: Any],
          let qchatChannelId = msgArg["channelId"] as? Int64,
          let qchatServerId = msgArg["serverId"] as? Int64 else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    let session = NIMSession(forQChat: qchatChannelId, qchatServerId: qchatServerId)
    let fromMsg = NIMQChatMessage.convertToMessage(msgArg) ?? NIMQChatMessage()
    fromMsg.setValue(session, forKeyPath: #keyPath(NIMQChatMessage.session))

    sendedMsgCallback = resultCallback
    let sea = NIMQChatGetMessageHistoryByIdsParam()
    if let channelId = replyMsgArg["qChatChannelId"] as? UInt64 {
      if channelId != qchatChannelId {
        errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
        return
      }
      sea.channelId = channelId
    }
    if let serverId = replyMsgArg["qChatServerId"] as? UInt64 {
      if serverId != qchatServerId {
        errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
        return
      }
      sea.serverId = serverId
    }
    let id = NIMQChatMessageServerIdInfo.fromDic(replyMsgArg)
    sea.ids = [id]
    NIMSDK.shared().qchatMessageManager
      .getMessageHistory(byIds: sea) { [weak self] error, result in
        if let err = error {
          print(
            "@@#❌qChatReplyMessage -> getMessageHistory FAILED, error: ",
            err
          )
          self?.qChatMessageCallback(error, nil, resultCallback)
        } else {
          if let res = result,
             let msgs = res.messages {
            if msgs.count > 0,
               let toMsg = msgs.first {
              NIMSDK.shared().qchatMessageExtendManager
                .reply(fromMsg, to: toMsg) { error in
                  if let ns_error = error as NSError? {
                    self?.errorCallBack(
                      resultCallback,
                      ns_error.description,
                      ns_error.code
                    )
                  }
                }
            } else {
              self?.errorCallBack(
                resultCallback,
                self?.paramErrorTip ?? "参数错误",
                self?.paramErrorCode ?? 414
              )
            }
          }
        }
      }
  }

  func qChatGetReferMessages(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let msgArg = arguments["message"] as? [String: Any] else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    var type: NIMQChatMessageReferType = .all
    if let typeStr = arguments["referType"] as? String,
       let tp = FLTQChatMessageReferType(rawValue: typeStr)?.convertNIMQChatMessageReferType() {
      type = tp
    }

    let sea = NIMQChatGetMessageHistoryByIdsParam()
    if let channelId = msgArg["qChatChannelId"] as? UInt64 {
      sea.channelId = channelId
    }
    if let serverId = msgArg["qChatServerId"] as? UInt64 {
      sea.serverId = serverId
    }
    let id = NIMQChatMessageServerIdInfo.fromDic(msgArg)
    sea.ids = [id]
    NIMSDK.shared().qchatMessageManager
      .getMessageHistory(byIds: sea) { [weak self] error, result in
        if let err = error {
          print(
            "@@#❌qChatGetReferMessages -> getMessageHistory FAILED, error: ",
            err
          )
          self?.qChatMessageCallback(error, nil, resultCallback)
        } else {
          if let res = result,
             let msgs = res.messages {
            if msgs.count > 0,
               let refMsg = msgs.first {
              NIMSDK.shared().qchatMessageExtendManager
                .getReferMessages(refMsg, type: type) { error, result in
                  self?.qChatMessageCallback(
                    error,
                    ["replyMessage": result?.toDict()?.first ?? "replyMessage is nil",
                     "threadMessage": refMsg
                       .toDict() ?? "threadMessage is nil"],
                    resultCallback
                  )
                }
            } else {
              self?.errorCallBack(
                resultCallback,
                self?.paramErrorTip ?? "参数错误",
                self?.paramErrorCode ?? 414
              )
            }
          }
        }
      }
  }

  func qChatGetThreadMessages(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let msgArg = arguments["message"] as? [String: Any] else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    var request: NIMQChatGetThreadMessagesParam
    if let messageQueryOption = arguments["messageQueryOption"] as? [String: Any] {
      request = NIMQChatGetThreadMessagesParam.fromDic(messageQueryOption)
    } else {
      request = NIMQChatGetThreadMessagesParam()
    }

    let sea = NIMQChatGetMessageHistoryByIdsParam()
    if let channelId = msgArg["qChatChannelId"] as? UInt64 {
      sea.channelId = channelId
    }
    if let serverId = msgArg["qChatServerId"] as? UInt64 {
      sea.serverId = serverId
    }
    let id = NIMQChatMessageServerIdInfo.fromDic(msgArg)
    sea.ids = [id]
    NIMSDK.shared().qchatMessageManager
      .getMessageHistory(byIds: sea) { [weak self] error, result in
        if let err = error {
          print(
            "@@#❌qChatGetThreadMessages -> getMessageHistory FAILED, error: ",
            err
          )
          self?.qChatMessageCallback(error, nil, resultCallback)
        } else {
          if let res = result,
             let msgs = res.messages {
            if msgs.count > 0,
               let qMsg = msgs.first {
              request.message = qMsg
              NIMSDK.shared().qchatMessageExtendManager
                .getThreadMessages(request) { [weak self] error, result in
                  self?.qChatMessageCallback(error, result?.toDict(), resultCallback)
                }
            } else {
              self?.errorCallBack(
                resultCallback,
                self?.paramErrorTip ?? "参数错误",
                self?.paramErrorCode ?? 414
              )
            }
          }
        }
      }
  }

  func qChatGetMessageThreadInfos(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let channelId = arguments["channelId"] as? UInt64,
          let serverId = arguments["serverId"] as? UInt64 else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    let sea = NIMQChatGetMessageHistoryByIdsParam()
    sea.channelId = channelId
    sea.serverId = serverId
    if let msgList = arguments["msgList"] as? [[String: Any]] {
      var msgIds = [NIMQChatMessageServerIdInfo]()
      for item in msgList {
        msgIds.append(NIMQChatMessageServerIdInfo.fromDic(item))
      }
      sea.ids = msgIds
    }
    NIMSDK.shared().qchatMessageManager
      .getMessageHistory(byIds: sea) { [weak self] error, result in
        if let err = error {
          print(
            "@@#❌qChatGetMessageThreadInfos -> getMessageHistory FAILED, error: ",
            err
          )
          self?.qChatMessageCallback(error, nil, resultCallback)
        } else {
          if let res = result,
             let msgs = res.messages {
            if msgs.count > 0 {
              NIMSDK.shared().qchatMessageExtendManager
                .batchGetMessageThreadInfo(msgs) { error, result in
                  var res = [String: Any]()
                  for (key, value) in result ?? [:] {
                    res[key] = value.toDict()
                  }
                  self?.qChatMessageCallback(
                    error,
                    ["messageThreadInfoMap": res],
                    resultCallback
                  )
                }
            } else {
              self?.errorCallBack(
                resultCallback,
                self?.paramErrorTip ?? "参数错误",
                self?.paramErrorCode ?? 414
              )
            }
          }
        }
      }
  }

  func qChatAddQuickComment(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let msgArg = arguments["commentMessage"] as? [String: Any] else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    var type: Int64 = 0
    if let tp = arguments["type"] as? Int64 {
      type = tp
    }

    let sea = NIMQChatGetMessageHistoryByIdsParam()
    if let channelId = msgArg["qChatChannelId"] as? UInt64 {
      sea.channelId = channelId
    }
    if let serverId = msgArg["qChatServerId"] as? UInt64 {
      sea.serverId = serverId
    }
    let id = NIMQChatMessageServerIdInfo.fromDic(msgArg)
    sea.ids = [id]
    NIMSDK.shared().qchatMessageManager
      .getMessageHistory(byIds: sea) { [weak self] error, result in
        if let err = error {
          print(
            "@@#❌qChatAddQuickComment -> getMessageHistory FAILED, error: ",
            err
          )
          self?.qChatMessageCallback(error, nil, resultCallback)
        } else {
          if let res = result,
             let msgs = res.messages {
            if msgs.count > 0,
               let commentMessage = msgs.first {
              NIMSDK.shared().qchatMessageExtendManager
                .addQuickCommentType(type, to: commentMessage) { [weak self] error in
                  self?.qChatMessageCallback(error, nil, resultCallback)
                }
            } else {
              self?.errorCallBack(
                resultCallback,
                self?.paramErrorTip ?? "参数错误",
                self?.paramErrorCode ?? 414
              )
            }
          }
        }
      }
  }

  func qChatRemoveQuickComment(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let msgArg = arguments["commentMessage"] as? [String: Any] else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    var type: Int64 = 0
    if let tp = arguments["type"] as? Int64 {
      type = tp
    }

    let sea = NIMQChatGetMessageHistoryByIdsParam()
    if let channelId = msgArg["qChatChannelId"] as? UInt64 {
      sea.channelId = channelId
    }
    if let serverId = msgArg["qChatServerId"] as? UInt64 {
      sea.serverId = serverId
    }
    let id = NIMQChatMessageServerIdInfo.fromDic(msgArg)
    sea.ids = [id]
    NIMSDK.shared().qchatMessageManager
      .getMessageHistory(byIds: sea) { [weak self] error, result in
        if let err = error {
          print(
            "@@#❌qChatRemoveQuickComment -> getMessageHistory FAILED, error: ",
            err
          )
          self?.qChatMessageCallback(error, nil, resultCallback)
        } else {
          if let res = result,
             let msgs = res.messages {
            if msgs.count > 0,
               let commentMessage = msgs.first {
              NIMSDK.shared().qchatMessageExtendManager
                .deleteQuickCommentType(type, to: commentMessage) { [weak self] error in
                  self?.qChatMessageCallback(error, nil, resultCallback)
                }
            } else {
              self?.errorCallBack(
                resultCallback,
                self?.paramErrorTip ?? "参数错误",
                self?.paramErrorCode ?? 414
              )
            }
          }
        }
      }
  }

  func qChatGetQuickComments(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let channelId = arguments["channelId"] as? UInt64,
          let serverId = arguments["serverId"] as? UInt64 else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    let sea = NIMQChatGetMessageHistoryByIdsParam()
    sea.channelId = channelId
    sea.serverId = serverId
    if let msgList = arguments["msgList"] as? [[String: Any]] {
      var msgIds = [NIMQChatMessageServerIdInfo]()
      for item in msgList {
        msgIds.append(NIMQChatMessageServerIdInfo.fromDic(item))
      }
      sea.ids = msgIds
    }
    NIMSDK.shared().qchatMessageManager
      .getMessageHistory(byIds: sea) { [weak self] error, result in
        if let err = error {
          print(
            "@@#❌qChatGetQuickComments -> getMessageHistory FAILED, error: ",
            err
          )
          self?.qChatMessageCallback(error, nil, resultCallback)
        } else {
          if let res = result,
             let msgs = res.messages {
            if msgs.count > 0 {
              NIMSDK.shared().qchatMessageExtendManager
                .fetchQuickComments(msgs) { error, result in
                  var res = [Int: Any]()
                  for (key, value) in result?.msgIdQuickCommentDic ?? [:] {
                    if let intKey = Int(key) {
                      res[intKey] = value.toDict()
                    }
                  }
                  self?.qChatMessageCallback(
                    error,
                    ["messageQuickCommentDetailMap": res],
                    resultCallback
                  )
                }
            } else {
              self?.errorCallBack(
                resultCallback,
                self?.paramErrorTip ?? "参数错误",
                self?.paramErrorCode ?? 414
              )
            }
          }
        }
      }
  }

  func qChatGetMessageCache(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetMessageCacheParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatMessageManager.getMessageCache(request) { [weak self] error, result in
      self?.qChatMessageCallback(
        error,
        ["messageCacheList": result?.toDict()],
        resultCallback
      )
    }
  }

  func qChatClearMessageCache(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    NIMSDK.shared().qchatMessageManager.clearMessageCache()
    successCallBack(resultCallback, nil)
  }

  func qChatGetLastMessageOfChannels(_ arguments: [String: Any],
                                     _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetLastMessageOfChannelsParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatMessageManager
      .getLastMessage(ofChannels: request) { [weak self] error, result in
        self?.qChatMessageCallback(error, result?.toDict(), resultCallback)
      }
  }

  func qChatSearchMsgByPage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatSearchMsgByPageParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatMessageManager
      .searchMsg(byPage: request) { [weak self] error, result in
        self?.qChatMessageCallback(error, result?.toDict(), resultCallback)
      }
  }

  func sendTypingEvent(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatMessageTypingEvent.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatMessageManager
      .send(request) { [weak self] error, result in
        self?.qChatMessageCallback(error, ["typingEvent": result?.toDict()], resultCallback)
      }
  }

  func getMentionedMeMessages(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetMentionedMeMessagesParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatMessageManager
      .getMentionedMeMessages(request) { [weak self] error, result in
        self?.qChatMessageCallback(error, result?.toDict(), resultCallback)
      }
  }

  func areMentionedMeMessages(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatAreMentionedMeMessagesParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatMessageManager
      .areMentionedMeMessages(request) { [weak self] error, result in
        DispatchQueue.main.async {
          self?.qChatMessageCallback(error, result?.toDict(), resultCallback)
        }
      }
  }
}

extension FLTQChatMessageService: NIMQChatManagerDelegate, NIMQChatMessageManagerDelegate {
  // MARK: NIMQChatManagerDelegate

  /**
   * 圈组在线状态/登录状态回调
   *
   * @param result 结果详情
   */
  func qchatOnlineStatus(_ result: NIMQChatOnlineStatusResult) {
    let argument = result.toDict()
    notifyEvent(serviceDelegateName(), "onStatusChange", argument)
  }

  /**
   * 圈组多端登录发生变化
   * 当有其他端登录或者注销时，会通过此接口通知到UI
   * 登录成功后，如果有其他端登录着，也会发出通知
   *
   * @param type 多端登录变化类型
   */
  func qchatMultiSpot(_ type: NIMMultiLoginType) {
    var jsonObject = [String: Any]()
    jsonObject["notifyType"] = FLTMultiLoginType.convert(type: type)?.rawValue
    if let clientArray = NIMSDK.shared().qchatManager.currentLoginClients(), !clientArray.isEmpty, clientArray.last != nil {
      jsonObject["otherClient"] = clientArray.last?.toDic()
    }
    notifyEvent(serviceDelegateName(), "onMultiSpotLogin", jsonObject)
  }

  /**
   * 被踢出圈组回调
   *
   * @param result 结果详情
   */
  func qchatKickedOut(_ result: NIMLoginKickoutResult) {
    let arguments = result.toDict()
    notifyEvent(serviceDelegateName(), "onKickedOut", arguments)
  }

  // MARK: NIMQChatMessageManagerDelegate

  /**
   *  收到消息回调
   *
   *  @param messages 消息列表,内部为NIMQChatMessage
   */
  func onRecvMessages(_ messages: [NIMQChatMessage]) {
    if messages.count > 0 {
      let arguments = messages.map {
        arg in arg.toDict()
      }
      notifyEvent(serviceDelegateName(), "onReceiveMessage", ["eventList": arguments])
    }
  }

  /**
   * 圈组消息 更新事件（消息状态变化、撤回、删除）回调
   *
   * @param event 事件详情
   */
  func onMessageUpdate(_ event: NIMQChatUpdateMessageEvent) {
    let arguments = event.toDict()
    if event.message.isDeleted { // 删除
      notifyEvent(serviceDelegateName(), "onMessageDelete", arguments)
    } else if event.message.isRevoked { // 撤回
      notifyEvent(serviceDelegateName(), "onMessageRevoke", arguments)
    } else { // 更新
      notifyEvent(serviceDelegateName(), "onMessageUpdate", arguments)
    }
  }

  /**
   * 圈组未读信息变更事件回调
   *
   * @param event 事件详情
   */
  func unreadInfoChanged(_ event: NIMQChatUnreadInfoChangedEvent) {
    let arguments = event.toDict()
    notifyEvent(serviceDelegateName(), "onUnreadInfoChanged", arguments)
  }

  // 圈组消息消息状态变化回调  发送中
  func willSend(_ message: NIMQChatMessage) {
    let arguments = message.toDict()
    notifyEvent(serviceDelegateName(), "onMessageStatusChange", arguments)
  }

  // 圈组消息消息状态变化回调  已发送/发送失败
  func send(_ message: NIMQChatMessage, didCompleteWithError error: Error?) {
    let arguments = message.toDict()
    notifyEvent(serviceDelegateName(), "onMessageStatusChange", arguments)
    if let callback = sendedMsgCallback {
      qChatMessageCallback(error, ["sentMessage": arguments], callback)
    }
  }

  /**
   *  发送消息(消息附件上传)进度回调
   *
   *  @param message  当前发送的消息
   *  @param progress 进度
   */
  func send(_ message: NIMQChatMessage, progress: Float) {
    var jsonObject = [String: Any]()
    jsonObject["id"] = message.messageId
    jsonObject["progress"] = progress
    notifyEvent(serviceDelegateName(), "onAttachmentProgress", jsonObject)
  }

  /**
   *  收取消息附件回调
   *  @param message  当前收取的消息
   *  @param progress 进度
   *  @discussion 附件包括:图片,视频的缩略图,语音文件
   */
  func fetchMessageAttachment(_ message: NIMQChatMessage, progress: Float) {
    var jsonObject = [String: Any]()
    jsonObject["id"] = message.messageId
    jsonObject["progress"] = progress
    notifyEvent(serviceDelegateName(), "onAttachmentProgress", jsonObject)
  }

  /**
   * 圈组系统通知接收事件回调
   *
   * @param result 结果详情
   */
  func onRecvSystemNotification(_ result: NIMQChatReceiveSystemNotificationResult) {
    let arguments = result.toDict()
    notifyEvent(serviceDelegateName(), "onReceiveSystemNotification", arguments)
  }

  /**
   * 圈组系统通知更新事件回调
   *
   * @param result 结果详情
   */
  func onSystemNotificationUpdate(_ result: NIMQChatSystemNotificationUpdateResult) {
    let arguments = result.toDict()
    notifyEvent(serviceDelegateName(), "onSystemNotificationUpdate", arguments)
  }

  /**
   * 圈组服务器未读信息变更事件回调
   *
   * @param serverUnreadInfoDic 事件详情, key为@(serverId)（服务器ID的NSNumber），value 为NIMQChatServerUnreadInfo
   */
  func serverUnreadInfoChanged(_ serverUnreadInfoDic: [NSNumber: NIMQChatServerUnreadInfo]) {
    var arguments = [[String: Any]]()
    for (_, value) in serverUnreadInfoDic {
      if let info = value.toDict() {
        arguments.append(info)
      }
    }
    notifyEvent(
      serviceDelegateName(),
      "serverUnreadInfoChanged",
      ["serverUnreadInfos": arguments]
    )
  }

  func onRecvTypingEvent(_ event: NIMQChatMessageTypingEvent) {
    let arguments = event.toDict()
    notifyEvent(serviceDelegateName(), "onReceiveTypingEvent", arguments)
  }
}
