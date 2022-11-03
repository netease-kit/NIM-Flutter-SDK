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
}

class FLTQChatMessageService: FLTBaseService, FLTService {
  var sendedMsgCallback: ResultCallback?

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
    default:
      resultCallback.notImplemented()
    }
  }

  func qChatMessageCallback(_ error: Error?, _ data: Any?, _ resultCallback: ResultCallback) {
    if let ns_error = error as NSError? {
      // 状态为“参数错误”时，SDK本应返回414，但是实际返回1，未与AOS对齐，此处进行手动对齐
      let code = ns_error.code == 1 ? 414 : ns_error.code
      errorCallBack(resultCallback, ns_error.description, code)
    } else {
      successCallBack(resultCallback, data)
    }
  }

  func qChatSendMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    var qchatChannelId: Int64 = 0
    var qchatServerId: Int64 = 0
    if let cId = arguments["channelId"] as? Int {
      qchatChannelId = Int64(cId)
    }
    if let cId = arguments["qChatChannelId"] as? Int {
      qchatChannelId = Int64(cId)
    }
    if let sId = arguments["serverId"] as? Int {
      qchatServerId = Int64(sId)
    }
    if let sId = arguments["qChatServerId"] as? Int {
      qchatServerId = Int64(sId)
    }
    let session = NIMSession(forQChat: qchatChannelId, qchatServerId: qchatServerId)
    let qMsg = NIMQChatMessage.convertToMessage(arguments) ?? NIMQChatMessage()
    qMsg.setValue(session, forKeyPath: #keyPath(NIMQChatMessage.session))

    weak var weakSelf = self
    sendedMsgCallback = resultCallback
    NIMSDK.shared().qchatMessageManager.send(qMsg, to: session) { error in
      if let ns_error = error as NSError? {
        // 状态为“参数错误”时，SDK本应返回414，但是实际返回1，未与AOS对齐，此处进行手动对齐
        let code = ns_error.code == 1 ? 414 : ns_error.code
        weakSelf?.errorCallBack(resultCallback, ns_error.description, code)
      }
    }
  }

  func qChatResendMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let arg = arguments["message"] as? [String: Any] else {
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
    NIMSDK.shared().qchatMessageManager.getMessageHistory(byIds: sea) { error, result in
      if let err = error {
        print(
          "@@#❌qChatResendMessage -> getMessageHistory FAILED, error: ",
          err
        )
      } else {
        if let res = result,
           let msgs = res.messages {
          if msgs.count > 0,
             let msg = msgs.first {
            do {
              try NIMSDK.shared().qchatMessageManager.resend(msg)
              self.successCallBack(resultCallback, ["sentMessage": msg.toDict()])
            } catch {
              self.errorCallBack(resultCallback, error.localizedDescription)
            }
          } else {
            self.errorCallBack(resultCallback, "参数错误", 414)
          }
        }
      }
    }
  }

  func qChatUpdateMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatUpdateMessageParam.fromDic(arguments)
    let sea = NIMQChatGetMessageHistoryParam.fromDic(arguments)
    NIMSDK.shared().qchatMessageManager.getMessageHistory(sea) { error, result in
      if let err = error {
        print(
          "@@#❌qChatUpdateMessage -> getMessageHistory FAILED, error: ",
          err
        )
      } else {
        if let res = result,
           let msgs = res.messages {
          if msgs.count > 0,
             let msg = msgs.first {
            request.message = msg
            NIMSDK.shared().qchatMessageManager.updateMessage(request) { error, res in
              self.qChatMessageCallback(error, ["message": res?.toDict()], resultCallback)
            }
          } else {
            self.errorCallBack(resultCallback, "参数错误", 414)
          }
        }
      }
    }
  }

  func qChatRevokeMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatRevokeMessageParam.fromDic(arguments)

    let sea = NIMQChatGetMessageHistoryByIdsParam.fromDic(arguments)
    NIMSDK.shared().qchatMessageManager.getMessageHistory(byIds: sea) { error, result in
      if let err = error {
        print(
          "@@#❌qChatRevokeMessage -> getMessageHistory FAILED, error: ",
          err
        )
        self.qChatMessageCallback(err, nil, resultCallback)
      } else {
        if let res = result,
           let msgs = res.messages {
          if msgs.count > 0,
             let msg = msgs.first {
            request.message = msg
            NIMSDK.shared().qchatMessageManager.revokeMessage(request) { error, result in
              self.qChatMessageCallback(error, ["message": result?.toDict()], resultCallback)
            }
          } else {
            self.errorCallBack(resultCallback, "参数错误", 414)
          }
        }
      }
    }
  }

  func qChatDeleteMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatDeleteMessageParam.fromDic(arguments)
    let sea = NIMQChatGetMessageHistoryByIdsParam.fromDic(arguments)
    NIMSDK.shared().qchatMessageManager.getMessageHistory(byIds: sea) { error, result in
      if let err = error {
        print(
          "@@#❌qChatDeleteMessage -> getMessageHistory FAILED, error: ",
          err
        )
      } else {
        if let res = result,
           let msgs = res.messages {
          if msgs.count > 0,
             let msg = msgs.first {
            request.message = msg
            NIMSDK.shared().qchatMessageManager.deleteMessage(request) { error, result in
              self.qChatMessageCallback(error, result?.toDict(), resultCallback)
            }
          } else {
            self.errorCallBack(resultCallback, "参数错误", 414)
          }
        }
      }
    }
  }

  func qChatDownloadAttachment(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let arg = arguments["message"] as? [String: Any] else {
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
    NIMSDK.shared().qchatMessageManager.getMessageHistory(byIds: sea) { error, result in
      if let err = error {
        print(
          "@@#❌qChatResendMessage -> getMessageHistory FAILED, error: ",
          err
        )
      } else {
        if let res = result,
           let msgs = res.messages {
          if msgs.count > 0,
             let msg = msgs.first {
            do {
              try NIMSDK.shared().qchatMessageManager.fetchMessageAttachment(msg)
              self.successCallBack(resultCallback, nil)
            } catch {
              self.errorCallBack(resultCallback, error.localizedDescription)
            }
          } else {
            self.errorCallBack(resultCallback, "参数错误", 414)
          }
        }
      }
    }
  }

  func qChatGetMessageHistory(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatGetMessageHistoryParam.fromDic(arguments)
    NIMSDK.shared().qchatMessageManager.getMessageHistory(request) { error, result in
      self.qChatMessageCallback(error, ["messages": result?.toDict()], resultCallback)
    }
  }

  func qChatGetMessageHistoryByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatGetMessageHistoryByIdsParam.fromDic(arguments)
    NIMSDK.shared().qchatMessageManager.getMessageHistory(byIds: request) { error, result in
      self.qChatMessageCallback(error, ["messages": result?.toDict()], resultCallback)
    }
  }

  func qChatMarkMessageRead(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatMarkMessageReadParam.fromDic(arguments)
    NIMSDK.shared().qchatMessageManager.markMessageRead(request) { error in
      self.qChatMessageCallback(error, nil, resultCallback)
    }
  }

  func qChatMarkSystemNotificationsRead(_ arguments: [String: Any],
                                        _ resultCallback: ResultCallback) {
    let request = NIMQChatMarkSystemNotificationsReadParam.fromDic(arguments)
    NIMSDK.shared().qchatMessageManager.markSystemNotificationsRead(request) { error in
      self.qChatMessageCallback(error, nil, resultCallback)
    }
  }

  func qChatSendSystemNotification(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatSendSystemNotificationParam.fromDic(arguments)
    NIMSDK.shared().qchatMessageManager.sendSystemNotification(request) { error, result in
      self.qChatMessageCallback(
        error,
        ["sentCustomNotification": result?.toDict()],
        resultCallback
      )
    }
  }

  func qChatResendSystemNotification(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatResendSystemNotificationParam.fromDic(arguments)
    NIMSDK.shared().qchatMessageManager.resendSystemNotification(request) { error, result in
      self.qChatMessageCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChatUpdateSystemNotification(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatUpdateSystemNotificationParam.fromDic(arguments)
    NIMSDK.shared().qchatMessageManager.updateSystemNotification(request) { error, result in
      self.qChatMessageCallback(error, result?.toDict(), resultCallback)
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
    var jsonObject: [String: Any]? = yx_modelToJSONObject() as? [String: Any]
    if jsonObject != nil {
      jsonObject!["notifyType"] = FLTMultiLoginType.convert(type: type)?.rawValue
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
    var jsonObject: [String: Any]? = yx_modelToJSONObject() as? [String: Any]
    if jsonObject != nil {
      jsonObject!["uuid"] = message.messageId
      jsonObject!["transferred"] = message.messageId
      jsonObject!["total"] = message.messageId
    }
    notifyEvent(serviceDelegateName(), "onAttachmentProgress", jsonObject)
  }

  /**
   *  收取消息附件回调
   *  @param message  当前收取的消息
   *  @param progress 进度
   *  @discussion 附件包括:图片,视频的缩略图,语音文件
   */
  func fetchMessageAttachment(_ message: NIMQChatMessage, progress: Float) {
    var jsonObject: [String: Any]? = yx_modelToJSONObject() as? [String: Any]
    if jsonObject != nil {
      jsonObject!["uuid"] = message.messageId
      jsonObject!["transferred"] = message.messageId
      jsonObject!["total"] = message.messageId
    }
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
}
