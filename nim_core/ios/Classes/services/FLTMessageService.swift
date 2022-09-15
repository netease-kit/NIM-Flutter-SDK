// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK
import YXAlog_iOS

enum MessageType: String {
  case SendMessage = "sendMessage"
  case VoiceToText = "voiceToText"
  case CreateMessage = "createMessage"

  case QueryMessageList = "queryMessageList"
  case QueryMessageListEx = "queryMessageListEx" // 不支持asc参数
  case QueryLastMessage = "queryLastMessage"
  case QueryMessageListByUuid = "queryMessageListByUuid"
  case DeleteChattingHistory = "deleteChattingHistory"
  case DeleteChattingHistoryList = "deleteChattingHistoryList"
  case ClearChattingHistory = "clearChattingHistory" // 无ignore
  case ClearMsgDatabase = "clearMsgDatabase"

  case PullMessageHistoryExType = "pullMessageHistoryExType" // 无persistClear
  case PullMessageHistory = "pullMessageHistory" // 无persistClear
  case ClearServerHistory = "clearServerHistory" // 无ext
  case DeleteMsgSelf = "deleteMsgSelf"
  case DeleteMsgListSelf = "deleteMsgListSelf"
  case SearchMessage = "searchMessage"
  case SearchAllMessage = "searchAllMessage"
  case SearchRoamingMsg = "searchRoamingMsg"
  case SearchCloudMessageHistory = "searchCloudMessageHistory"
  case DownloadAttachment = "downloadAttachment"

  case SaveMessage = "saveMessage"
  case UpdateMessage = "updateMessage"
  case CancelUploadAttachment = "cancelUploadAttachment"
  case ForwardMessage = "forwardMessage"
  case MessageInTransport = "messageInTransport" // flutter不实现此接口
  case MessageTransportProgress = "messageTransportProgress" // flutter不实现此接口
  case RevokeMessage = "revokeMessage"
  case SendMessageReceipt = "sendMessageReceipt"
  case SendTeamMessageReceipts = "sendTeamMessageReceipt"
  case RefreshTeamMessageReceipts = "refreshTeamMessageReceipt"
  case FetchTeamMessageReceiptDetail = "fetchTeamMessageReceiptDetail"
  case QueryTeamMessageReceiptDetail = "queryTeamMessageReceiptDetail"

  case CheckLocalAntiSpam = "checkLocalAntiSpam"

  case QueryMySessionList = "queryMySessionList"
  case QueryMySession = "queryMySession"
  case UpdateMySession = "updateMySession"
  case DeleteMySession = "deleteMySession"

  case AddCollect = "addCollect"
  case RemoveCollect = "removeCollect"
  case UpdateCollect = "updateCollect"
  case QueryCollect = "queryCollect"
  case AddMessagePin = "addMessagePin"
  case UpdateMessagePin = "updateMessagePin"
  case RemoveMessagePin = "removeMessagePin"
  case QueryMessagePinForSession = "queryMessagePinForSession"

  case AddQuickComment = "addQuickComment"
  case RemoveQuickComment = "removeQuickComment"
  case QueryQuickComment = "queryQuickComment"
  case AddStickTopSession = "addStickTopSession"
  case RemoveStickTopSession = "removeStickTopSession"
  case UpdateStickTopSession = "updateStickTopSession"
  case QueryStickTopSession = "queryStickTopSession"
  case QueryRoamMsgHasMoreTime = "queryRoamMsgHasMoreTime"
  case UpdateRoamMsgHasMoreTag = "updateRoamMsgHasMoreTag"
  case StickTopInfoForSession = "stickTopInfoForSession"
  case LoadRecentSessions = "loadRecentSessions"
  case SortRecentSessions = "sortRecentSessions"
}

class FLTMessageService: FLTBaseService, FLTService {
  var messageCacheDic = [String: NimMessageCallback]()

//    override init() {
//        super.init()
//        NIMSDK.shared().chatManager.add(self)
//        NIMSDK.shared().broadcastManager.add(self)
//        NIMCustomObject.registerCustomDecoder(NIMCustomAttachmentDecoder())
//    }

  override func onInitialized() {
    NIMSDK.shared().chatManager.add(self)
    NIMSDK.shared().broadcastManager.add(self)
    NIMSDK.shared().chatExtendManager.add(self)
    NIMSDK.shared().conversationManager.add(self)
    NIMCustomObject.registerCustomDecoder(NIMCustomAttachmentDecoder())
  }

  deinit {
    NIMSDK.shared().chatManager.remove(self)
    NIMSDK.shared().broadcastManager.remove(self)
    NIMSDK.shared().chatExtendManager.remove(self)
    NIMSDK.shared().conversationManager.remove(self)
  }

  // MARK: - Protocol

  func serviceName() -> String {
    ServiceType.MessageService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    if let chatExtendService = nimCore?
      .getService(ServiceType.ChatExtendService.rawValue) as? FLTChatExtendService,
      chatExtendService.checkMethod(method) {
      chatExtendService.onMethodCalled(method, arguments, resultCallback)
      return
    }

    if let sessionService = nimCore?
      .getService(ServiceType.SessionService.rawValue) as? FLTSessionService,
      sessionService.checkMethod(method) {
      sessionService.onMethodCalled(method, arguments, resultCallback)
      return
    }

    switch method {
    case MessageType.SendMessage.rawValue:
      sendMessage(arguments, resultCallback)

    case MessageType.VoiceToText.rawValue:
      voiceToText(arguments, resultCallback)
    case MessageType.CreateMessage.rawValue:
      if let messages = createMessage(arguments) {
        let message = messages.message
        let session = messages.session
        message.gArgument = arguments
        message.sessionId = session.sessionId
        message.setValue(session, forKeyPath: #keyPath(NIMMessage.session))

        if let direction = arguments["messageDirection"] as? String,
           let messageDirection = FLT_NIMMessageDirection(rawValue: direction) {
          message.messageDirection = messageDirection
        }

        var targetMsg = message.toDic()
        if let _ = targetMsg?["status"] {
          targetMsg?["status"] = FLT_NIMMessageStatus.sending.rawValue
        }
        let messageJson = NimResult.success(targetMsg).toDic()
        print("create message : ", messageJson)

        resultCallback.result(messageJson)
      } else {
        resultCallback.result(NimResult.error("create message error").toDic())
      }
    case MessageType.QueryMessageList.rawValue:
      queryMessageList(arguments, resultCallback)
    case MessageType.QueryMessageListEx.rawValue:
      queryMessageListEx(arguments, resultCallback)
    case MessageType.QueryLastMessage.rawValue:
      queryLastMessage(arguments, resultCallback)
    case MessageType.QueryMessageListByUuid.rawValue:
      queryMessageListByUuid(arguments, resultCallback)
    case MessageType.DeleteChattingHistory.rawValue:
      deleteChattingHistory(arguments, resultCallback)
    case MessageType.DeleteChattingHistoryList.rawValue:
      deleteChattingHistoryList(arguments, resultCallback)
    case MessageType.ClearChattingHistory.rawValue:
      clearChattingHistory(arguments, resultCallback)
    case MessageType.ClearMsgDatabase.rawValue:
      clearMsgDatabase(arguments, resultCallback)
    case MessageType.PullMessageHistoryExType.rawValue:
      pullMessageHistoryExType(arguments, resultCallback)
    case MessageType.PullMessageHistory.rawValue:
      pullMessageHistory(arguments, resultCallback)
    case MessageType.ClearServerHistory.rawValue:
      clearServerHistory(arguments, resultCallback)
    case MessageType.DeleteMsgSelf.rawValue:
      deleteMsgSelf(arguments, resultCallback)
    case MessageType.DeleteMsgListSelf.rawValue:
      deleteMsgListSelf(arguments, resultCallback)
    case MessageType.SearchMessage.rawValue:
      searchMessage(arguments, resultCallback)
    case MessageType.SearchAllMessage.rawValue:
      searchAllMessage(arguments, resultCallback)
    case MessageType.SearchRoamingMsg.rawValue:
      searchRoamingMsg(arguments, resultCallback)
    case MessageType.SearchCloudMessageHistory.rawValue:
      searchCloudMessageHistory(arguments, resultCallback)
    case MessageType.DownloadAttachment.rawValue:
      if let message = NIMMessage.convertToMessage(arguments),
         let sessionId = message.session?.sessionId,
         let sessionType = message.session?.sessionType {
        if let databaseMessage = NIMSDK.shared().conversationManager.messages(
          in: NIMSession(sessionId, type: sessionType),
          messageIds: [message.messageId]
        )?.first {
          fetchMessageAttachment(databaseMessage, resultCallback)
        } else {
          resultCallback
            .result(NimResult.error("resend message not exist").toDic() as Any)
        }
      }
    case MessageType.SaveMessage.rawValue:
      saveMessage(arguments, resultCallback)
    case MessageType.UpdateMessage.rawValue:
      updateMessage(arguments, resultCallback)
    case MessageType.ForwardMessage.rawValue:
      forwardMessage(arguments, resultCallback)
    case MessageType.CancelUploadAttachment.rawValue:
      cancelUploadAttachment(arguments, resultCallback)
    case MessageType.SendMessageReceipt.rawValue:
      sendMessageReceipt(arguments, resultCallback)
    case MessageType.SendTeamMessageReceipts.rawValue:
      sendTeamMessageReceipts(arguments, resultCallback)
    case MessageType.RefreshTeamMessageReceipts.rawValue:
      refreshTeamMessageReceipts(arguments, resultCallback)
    case MessageType.FetchTeamMessageReceiptDetail.rawValue:
      queryMessageReceiptDetail(arguments, resultCallback)
    case MessageType.QueryTeamMessageReceiptDetail.rawValue:
      localMessageReceiptDetail(arguments, resultCallback)
    case MessageType.CheckLocalAntiSpam.rawValue:
      checkLocalAntiSpam(arguments, resultCallback)
    case MessageType.RevokeMessage.rawValue:
      revokeMessage(arguments, resultCallback)
    case MessageType.QueryMySessionList.rawValue:
      queryMySessionList(arguments, resultCallback)
    case MessageType.QueryMySession.rawValue:
      queryMySession(arguments, resultCallback)
    case MessageType.UpdateMySession.rawValue:
      updateMySession(arguments, resultCallback)
    case MessageType.DeleteMySession.rawValue:
      deleteMySession(arguments, resultCallback)
    case MessageType.AddCollect.rawValue:
      addCollect(arguments, resultCallback)
    case MessageType.RemoveCollect.rawValue:
      removeCollect(arguments, resultCallback)
    case MessageType.UpdateCollect.rawValue:
      updateCollect(arguments, resultCallback)
    case MessageType.QueryCollect.rawValue:
      queryCollect(arguments, resultCallback)
    case MessageType.AddMessagePin.rawValue:
      addMessagePin(arguments, resultCallback)
    case MessageType.RemoveMessagePin.rawValue:
      removeMessagePin(arguments, resultCallback)
    case MessageType.UpdateMessagePin.rawValue:
      updateMessagePin(arguments, resultCallback)
    case MessageType.QueryMessagePinForSession.rawValue:
      queryMessagePinForSession(arguments, resultCallback)
    case MessageType.AddQuickComment.rawValue:
      addQuickComment(arguments, resultCallback)
    case MessageType.RemoveQuickComment.rawValue:
      removeQuickComment(arguments, resultCallback)
    case MessageType.QueryQuickComment.rawValue:
      queryQuickComment(arguments, resultCallback)
    case MessageType.AddStickTopSession.rawValue:
      addStickTopSession(arguments, resultCallback)
    case MessageType.RemoveStickTopSession.rawValue:
      removeStickTopSession(arguments, resultCallback)
    case MessageType.UpdateStickTopSession.rawValue:
      updateStickTopSession(arguments, resultCallback)
    case MessageType.QueryStickTopSession.rawValue:
      queryStickTopSession(arguments, resultCallback)
    case MessageType.QueryRoamMsgHasMoreTime.rawValue:
      queryRoamMsgHasMoreTime(arguments, resultCallback)
    case MessageType.UpdateRoamMsgHasMoreTag.rawValue:
      updateRoamMsgHasMoreTag(arguments, resultCallback)
    case MessageType.StickTopInfoForSession.rawValue:
      stickTopInfoForSession(arguments, resultCallback)
    case MessageType.LoadRecentSessions.rawValue:
      loadRecentSessionsWithOptions(arguments, resultCallback)
    case MessageType.SortRecentSessions.rawValue:
      sortRecentSessions(arguments, resultCallback)
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

  private func voiceToText(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let message = NIMMessage.convertToMessage(arguments),
       let attachment = message.messageObject as? NIMAudioObject {
      let option = NIMAudioToTextOption()
      if let dic = arguments["messageAttachment"] as? [String: Any],
         let path = dic["path"] as? String {
        option.filepath = path
        print("audio message path : ", path)
      }
      if let url = attachment.url {
        option.url = url
        print("audio message url : ", url)
      }
      NIMSDK.shared().mediaManager.transAudio(toText: option) { error, text in
        if error == nil {
          resultCallback.result(NimResult.success(text).toDic())
        } else {
          if let ns_error = error as NSError? {
            resultCallback
              .result(NimResult.error(ns_error.code, ns_error.description).toDic())
          } else {
            resultCallback.result(NimResult.error("trans audio unkonw error").toDic())
          }
        }
      }
    } else {
      resultCallback.result(NimResult.error("parse param failed").toDic())
    }
  }

  private func sendMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let message = NIMMessage.convertToMessage(arguments),
       let sessionId = message.sessionId,
       let sessionType = message.sessionType,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      let resend = arguments["resend"] as? Bool
      if let setting = getCustomSetting(arguments) {
        message.setting = setting
      }
      let messageCallback = NimMessageCallback()
      messageCallback.callback = resultCallback
      messageCallback.message = message
      messageCacheDic[message.messageId] = messageCallback

      if let attachemnt = getMessageAttachment(arguments) {
        let scene = getScene(attachemnt)
        if message.setting == nil {
          message.setting = NIMMessageSetting()
        }
        message.setting?.scene = scene
        // 修复发送消息getCustomSetting失败,未处理问题
        if let messageAck = arguments["messageAck"] as? Bool {
          message.setting?.teamReceiptEnabled = messageAck
        }
      }

      do {
        if resend == false {
          try NIMSDK.shared().chatManager.send(message, to: session)
        } else {
          if let resendMessage = NIMSDK.shared().conversationManager.messages(
            in: NIMSession(sessionId, type: type),
            messageIds: [message.messageId]
          )?.first {
            try NIMSDK.shared().chatManager.resend(resendMessage)
          } else {
            resultCallback
              .result(NimResult.error("resend message not exist").toDic() as Any)
          }
        }
      } catch let error as NSError {
        print("send message  error : ", error)
        messageCacheDic.removeValue(forKey: message.messageId)
        resultCallback.result(NimResult.error(error.code, error.description).toDic())
      }

    } else {
      resultCallback.result(NimResult.error("convert nim message failed").toDic() as Any)
    }
  }

  private func createMessage(_ arguments: [String: Any])
    -> (message: NIMMessage, session: NIMSession)? {
    var sessionId = ""
    var sessionType = NIMSessionType.P2P
    let serviceName = arguments[kFLTNimCoreService] as? String ?? ""
    var text: String?
    if serviceName == ServiceType.ChatroomService.rawValue {
      sessionId = arguments["roomId"] as? String ?? ""
      sessionType = NIMSessionType.chatroom
      // 聊天室带在text中，其他带在content中
      text = arguments["text"] as? String

    } else if serviceName == ServiceType.MessageService.rawValue {
      sessionId = arguments["sessionId"] as? String ?? ""
      let sessionTypeValue = arguments["sessionType"] as? String
      sessionType = (try? NIMSessionType.getType(sessionTypeValue)) ?? NIMSessionType.P2P
      text = arguments["content"] as? String
    }
    if let messageTypeValue = arguments["messageType"] as? String,
       let messageType = try? NIMMessageType.getType(messageTypeValue) {
      let attatchment = getMessageAttachment(arguments)

      switch messageType {
      case NIMMessageType.text:
        return createTextMessage(sessionId, sessionType, text)

      case NIMMessageType.image:

        return createImageMessage(sessionId, sessionType, attatchment)

      case NIMMessageType.audio:

        return createAudioMessage(sessionId, sessionType, attatchment)

      case NIMMessageType.video:

        return createVideoMessage(sessionId, sessionType, attatchment)

      case NIMMessageType.file:

        return createFileMessage(sessionId, sessionType, attatchment)

      case NIMMessageType.location:

        return createLocationMessage(
          sessionId,
          sessionType,
          attatchment?["lng"] as? Double,
          attatchment?["lat"] as? Double,
          attatchment?["title"] as? String
        )

      case NIMMessageType.tip:
        return createTipMessage(sessionId, sessionType, arguments["text"] as? String)

      case NIMMessageType.custom:
        let attatchment = getMessageAttachment(arguments)
        return createCustomMessage(sessionId, sessionType, attatchment)

      case NIMMessageType.robot:
        return createRobotMessage(sessionId, sessionType, arguments)

      default:
        break
      }
    }
    return nil
  }

  private func createTextMessage(_ sessionId: String?, _ sessionType: NIMSessionType,
                                 _ text: String?) -> (message: NIMMessage, session: NIMSession)? {
    if let sid = sessionId, let content = text {
      let message = NIMMessage()
      message.text = content
      let session = NIMSession(sid, type: sessionType)
      return (message: message, session: session)
    }
    return nil
  }

  private func createImageMessage(_ sessionId: String?, _ sessionType: NIMSessionType,
                                  _ attachment: [String: Any]?)
    -> (message: NIMMessage, session: NIMSession)? {
    if let sid = sessionId, let imagePath = getAttachmentPath(attachment) {
      let message = NIMMessage()
      let session = NIMSession(sid, type: sessionType)
      let imageObject = NIMImageObject(filepath: imagePath, scene: getScene(attachment))
      message.messageObject = imageObject
      return (message: message, session: session)
    }
    return nil
  }

  private func createAudioMessage(_ sessionId: String?, _ sessionType: NIMSessionType,
                                  _ attachment: [String: Any]?)
    -> (message: NIMMessage, session: NIMSession)? {
    if let sid = sessionId, let filePath = getAttachmentPath(attachment) {
      let message = NIMMessage()
      let session = NIMSession(sid, type: sessionType)
      let audioObject = NIMAudioObject(sourcePath: filePath, scene: getScene(attachment))
      audioObject.duration = getDur(attachment)
      message.messageObject = audioObject
      return (message: message, session: session)
    }
    return nil
  }

  private func createVideoMessage(_ sessionId: String?, _ sessionType: NIMSessionType,
                                  _ attachment: [String: Any]?)
    -> (message: NIMMessage, session: NIMSession)? {
    if let sid = sessionId, let filePath = getAttachmentPath(attachment) {
      let message = NIMMessage()
      let session = NIMSession(sid, type: sessionType)
      let videoObject = NIMVideoObject(sourcePath: filePath, scene: getScene(attachment))
      videoObject.duration = getDur(attachment)
      message.messageObject = videoObject
      return (message: message, session: session)
    }
    return nil
  }

  private func createFileMessage(_ sessionId: String?, _ sessionType: NIMSessionType,
                                 _ attachment: [String: Any]?)
    -> (message: NIMMessage, session: NIMSession)? {
    if let sid = sessionId, let filePath = getAttachmentPath(attachment) {
      let message = NIMMessage()
      let session = NIMSession(sid, type: sessionType)
      let fileObject = NIMFileObject(sourcePath: filePath, scene: getScene(attachment))
      message.messageObject = fileObject
      return (message: message, session: session)
    }
    return nil
  }

  private func createLocationMessage(_ sessionId: String?,
                                     _ sessionType: NIMSessionType,
                                     _ longitude: Double?,
                                     _ latitude: Double?,
                                     _ address: String?)
    -> (message: NIMMessage, session: NIMSession)? {
    if let sid = sessionId, let lon = longitude, let lat = latitude {
      let message = NIMMessage()
      let session = NIMSession(sid, type: sessionType)
      let locationObject = NIMLocationObject(latitude: lat, longitude: lon, title: address)
      message.messageObject = locationObject
      return (message: message, session: session)
    }
    return nil
  }

  private func createTipMessage(_ sessionId: String?, _ sessionType: NIMSessionType,
                                _ text: String?) -> (message: NIMMessage, session: NIMSession)? {
    if let sid = sessionId {
      let message = NIMMessage()
      message.text = text
      let tipMessage = NIMTipObject()
      message.messageObject = tipMessage
      let session = NIMSession(sid, type: sessionType)
      return (message: message, session: session)
    }
    return nil
  }

  private func createCustomMessage(_ sessionId: String?, _ sessionType: NIMSessionType,
                                   _ data: [String: Any]?)
    -> (message: NIMMessage, session: NIMSession)? {
    if let sid = sessionId {
      let message = NIMMessage()
      let object = NIMCustomObject()
      let nimAttachment = NimAttachment(data)
      object.attachment = nimAttachment
      message.messageObject = object
      let session = NIMSession(sid, type: sessionType)
      return (message: message, session: session)
    }
    return nil
  }

  private func createRobotMessage(_ sessionId: String?, _ sessionType: NIMSessionType,
                                  _ arguments: [String: Any])
    -> (message: NIMMessage, session: NIMSession)? {
    if let roomId = getRoomId(arguments), let sid = sessionId {
      let message = NIMMessage()
      let text = arguments["text"] as? String ?? ""
      let params = arguments["params"] as? String ?? ""
      let content = arguments["content"] as? String ?? ""
      let target = arguments["target"] as? String ?? ""
      let object = NIMRobotObject(robotId: roomId, target: target, param: params)
      message.messageObject = object
      message.text = text
      message.content = content
      let session = NIMSession(sid, type: sessionType)
      return (message: message, session: session)
    }
    return nil
  }

  private func notifyEvent(_ method: String, _ arguments: inout [String: Any]) {
    arguments["serviceName"] = serviceName()
    nimCore?.getMethodChannel()?.invokeMethod(method, arguments)
  }

  private func fetchMessageAttachment(_ message: NIMMessage, _ resultCallback: ResultCallback) {
    do {
      try NIMSDK.shared().chatManager.fetchMessageAttachment(message)
      resultCallback.result(NimResult.success(message).toDic())
    } catch let error as NSError {
      resultCallback.result(NimResult.error(error.code, error.description).toDic())
    }
  }

  private func cancelFetchingMessageAttachment(_ message: NIMMessage,
                                               _ resultCallback: ResultCallback) {
    NIMSDK.shared().chatManager.cancelFetchingMessageAttachment(message)
    resultCallback.result(NimResult.success(true).toDic())
  }

  private func checkLocalAntiSpam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let content = arguments["content"] as? String,
       let replacement = arguments["replacement"] as? String {
      let option = NIMLocalAntiSpamCheckOption()
      option.content = content
      option.replacement = replacement
      do {
        try NIMSDK.shared().antispamManager.checkLocalAntispam(option)
        resultCallback.result(NimResult.success().toDic())
      } catch let error as NSError {
        resultCallback.result(NimResult.error(error.code, error.description).toDic())
      }
    }
  }
}

extension FLTMessageService: NIMChatManagerDelegate {
  // MARK: - SDK Callback

  func willSend(_ message: NIMMessage) {
    if message.session?.sessionType == .chatroom {
      notifyEvent(
        ServiceType.ChatroomService.rawValue,
        "onMessageStatusChanged",
        message.toDic()
      )
    } else {
      notifyEvent(serviceName(), "onMessageStatus", message.toDic())
    }
  }

  func send(_ message: NIMMessage, progress: Float) {
    notifyEvent(
      serviceName(),
      "onAttachmentProgress",
      ["id": message.messageId, "progress": progress]
    )
  }

  func uploadAttachmentSuccess(_ urlString: String, for message: NIMMessage) {}

  func send(_ message: NIMMessage, didCompleteWithError error: Error?) {
    if let messageCallback = messageCacheDic[message.messageId],
       let resultCallBack = messageCallback.callback {
      if let ns_error = error as NSError? {
        print("send message failed :", error as Any)
        resultCallBack.result(NimResult.error(ns_error.code, ns_error.description).toDic())
      } else {
        print("send message success : \(message.serverID)")
        let messageJson = NimResult.success(message.toDic()).toDic()
        resultCallBack.result(messageJson)
      }
      messageCacheDic.removeValue(forKey: message.messageId)
    }
    if message.session?.sessionType == .chatroom {
      notifyEvent(
        ServiceType.ChatroomService.rawValue,
        "onMessageStatusChanged",
        message.toDic()
      )
    } else {
      notifyEvent(serviceName(), "onMessageStatus", message.toDic())
    }
  }

  func onRecvMessageReceipts(_ receipts: [NIMMessageReceipt]) {
    var arguments = [String: Any]()
    var messageReceiptList = [[String: Any?]]()
    var teamMessageReceiptList = [[String: Any?]]()
    for receipt in receipts {
      if receipt.session?.sessionType == NIMSessionType.P2P {
        messageReceiptList.append(receipt.toDic())
      } else if receipt.session?.sessionType == NIMSessionType.team {
        teamMessageReceiptList.append(receipt.toDic())
      }
    }
    if messageReceiptList.count > 0 {
      arguments["messageReceiptList"] = messageReceiptList
      notifyEvent("onMessageReceipt", &arguments)
    }
    if teamMessageReceiptList.count > 0 {
      arguments["teamMessageReceiptList"] = messageReceiptList
      notifyEvent("onTeamMessageReceipt", &arguments)
    }

    for r in receipts {
      if let s = r.session {
        let messages = NIMSDK.shared().conversationManager
          .messages(in: s, messageIds: [r.messageId])
        if messages != nil {
          for m in messages! {
            if m.session?.sessionType == .chatroom {
              notifyEvent(
                ServiceType.ChatroomService.rawValue,
                "onMessageStatusChanged",
                m.toDic()
              )
            } else {
              notifyEvent(serviceName(), "onMessageStatus", m.toDic())
            }
          }
        }
      }
    }
  }

  func onRecvMessages(_ messages: [NIMMessage]) {
    var normal = [NIMMessage]() // 普通消息
    var team = [NIMMessage]() // 群组通知
    var chatroom = [NIMMessage]() // 聊天室通知

    messages.forEach { message in
      if message.messageType == NIMMessageType.notification,
         let noti = message.messageObject as? NIMNotificationObject,
         noti.content.notificationType() == .chatroom {
        chatroom.append(message)
      } else if let session = message.session,
                session.sessionType == .chatroom {
        chatroom.append(message)
      } else {
        normal.append(message)
      }
    }

    if normal.count > 0 {
      let ret = normal.map { message in
        message.toDic()
      }
      print("xxxx to dic message :", ret)
      notifyEvent(ServiceType.MessageService.rawValue, "onMessage", ["messageList": ret])
    }

    if chatroom.count > 0 {
      chatRoomMessage(chatroom)
    }
  }

  func fetchMessageAttachment(_ message: NIMMessage, progress: Float) {
    notifyEvent(
      serviceName(),
      "onAttachmentProgress",
      ["id": message.messageId, "progress": progress]
    )
  }

  func fetchMessageAttachment(_ message: NIMMessage, didCompleteWithError error: Error?) {
    if message.session?.sessionType == .chatroom {
      notifyEvent(
        ServiceType.ChatroomService.rawValue,
        "onMessageStatusChanged",
        message.toDic()
      )
    } else {
      notifyEvent(serviceName(), "onMessageStatus", message.toDic())
    }
  }

  func onRecvRevokeMessageNotification(_ notification: NIMRevokeMessageNotification) {
    notifyEvent(serviceName(), "onMessageRevoked", notification.toDic())
  }
}

// 消息分发
extension FLTMessageService {
  private func chatRoomMessage(_ messages: [NIMMessage]) {
    let ret = messages.map { message in
      message.toDic()
    }
    notifyEvent(ServiceType.ChatroomService.rawValue, "onMessageReceived", ["messageList": ret])
  }
}

// MARK: Conversation

extension FLTMessageService {
  func queryMessageList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let sessionType = try? NIMSessionType.getType(arguments["sessionType"] as? String),
       let account = arguments["account"] as? String {
      let limit = arguments["limit"] as? Int ?? 0
      let session = NIMSession(account, type: sessionType)
      if let ret = NIMSDK.shared().conversationManager
        .messages(in: session, message: nil, limit: limit) {
        let messageList = ret.map { message in
          message.toDic()
        }
        let result = NimResult(["messageList": messageList], 0, nil)
        resultCallback.result(result.toDic())
      } else {
        let result = NimResult(nil, 0, nil)
        resultCallback.result(result.toDic())
      }
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic() as Any)
    }
  }

  func queryMessageListEx(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let messageArgs = arguments["message"] as? [String: Any],
       let message = NIMMessage.convertToMessage(messageArgs),
       let sessionId = message.sessionId,
       let sessionType = message.sessionType,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      if let ret = NIMSDK.shared().conversationManager
        .messages(in: session, message: message, limit: arguments["limit"] as! Int) {
        let messageList = ret.map { message in
          message.toDic()
        }
        let result = NimResult(["messageList": messageList], 0, nil)
        resultCallback.result(result.toDic())
      } else {
        let result = NimResult(nil, 0, nil)
        resultCallback.result(result.toDic())
      }
    } else {
      resultCallback.result(NimResult.error("convert nim message failed").toDic() as Any)
    }
  }

  func queryLastMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let sessionId = arguments["account"] as? String,
       let sessionType = arguments["sessionType"] as? String,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      if let ret = NIMSDK.shared().conversationManager
        .messages(in: session, message: nil, limit: 1) {
        if ret.count > 0 {
          let result = NimResult(ret[0].toDic(), 0, nil)
          resultCallback.result(result.toDic())
          return
        }
      }
      let result = NimResult(nil, 0, nil)
      resultCallback.result(result.toDic())
    } else {
      resultCallback.result(NimResult.error("convert nim message failed").toDic() as Any)
    }
  }

  func queryMessageListByUuid(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let sessionId = arguments["sessionId"] as? String,
       let sessionType = arguments["sessionType"] as? String,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      if let ret = NIMSDK.shared().conversationManager
        .messages(in: session, messageIds: arguments["uuidList"] as! [String]) {
        let messageList = ret.map { message in
          message.toDic()
        }
        let result = NimResult(["messageList": messageList], 0, nil)
        resultCallback.result(result.toDic())
      } else {
        let result = NimResult(nil, 0, nil)
        resultCallback.result(result.toDic())
      }
    } else {
      resultCallback.result(NimResult.error("convert nim message failed").toDic() as Any)
    }
  }

  func deleteChattingHistory(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let messageDic = arguments["message"] as? [String: Any],
       let message = NIMMessage.convertToMessage(messageDic) {
      let option = NIMDeleteMessageOption()
      option.removeFromDB = arguments["ignore"] as? Bool ?? false
      NIMSDK.shared().conversationManager.delete(message, option: option)
      let result = NimResult(nil, 0, nil)
      resultCallback.result(result.toDic())
    } else {
      resultCallback.result(NimResult.error("convert nim message failed").toDic() as Any)
    }
  }

  func deleteChattingHistoryList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let messageList = arguments["messageList"] as! [[String: Any]]
    let option = NIMDeleteMessageOption()
    option.removeFromDB = arguments["ignore"] as? Bool ?? false
    for m in messageList {
      if let message = NIMMessage.convertToMessage(m) {
        NIMSDK.shared().conversationManager.delete(message, option: option)
      } else {
        resultCallback.result(NimResult.error("convert nim message failed").toDic() as Any)
      }
    }
    let result = NimResult(nil, 0, nil)
    resultCallback.result(result.toDic())
  }

  func clearChattingHistory(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let account = arguments["account"] as! String
    _ = arguments["ignore"] as? Bool ?? false
    if let sessionType = try? NIMSessionType.getType(arguments["sessionType"] as? String) {
      let session = NIMSession(account, type: sessionType)
      let option = NIMDeleteMessagesOption()
      NIMSDK.shared().conversationManager.deleteAllmessages(in: session, option: option)
    }
    let result = NimResult(nil, 0, nil)
    resultCallback.result(result.toDic())
  }

  func clearMsgDatabase(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let option = NIMDeleteMessagesOption()
    option.removeSession = arguments["clearRecent"] as? Bool ?? false
    NIMSDK.shared().conversationManager.deleteAllMessages(option)
    let result = NimResult(nil, 0, nil)
    resultCallback.result(result.toDic())
  }

  func pullMessageHistoryExType(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let messageArgs = arguments["message"] as? [String: Any],
       let message = NIMMessage.convertToMessage(messageArgs),
       let sessionId = message.sessionId,
       let sessionType = message.sessionType,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      let option = NIMHistoryMessageSearchOption()
      option.limit = arguments["limit"] as? UInt ?? 0
      option.order = arguments["direction"] as? Int == 1 ? NIMMessageSearchOrder
        .asc : NIMMessageSearchOrder.desc
      if message.timestamp != 0 {
        if option.order == NIMMessageSearchOrder.asc {
          option.startTime = message.timestamp
          option.endTime = arguments["toTime"] as? Double ?? 0.0
        } else {
          option.endTime = message.timestamp
          option.startTime = arguments["toTime"] as? Double ?? 0.0
        }
      }
      option.currentMessage = message
      let messageTypes = arguments["messageTypeList"] as? [String] ?? []
      var types = [NSNumber]()
      for t in messageTypes {
        if let messageType = try? NIMMessageType.getType(t) {
          types.append(NSNumber(value: messageType.rawValue))
        }
      }
      option.messageTypes = types
      option.sync = arguments["persist"] as? Bool ?? false
      if types.count > 0 {
        option.syncMessageTypes = option.sync
      }
      NIMSDK.shared().conversationManager
        .fetchMessageHistory(session, option: option) { error, messages in
          if error != nil {
            let nserror = error! as NSError
            let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
            resultCallback.result(result.toDic())
          } else {
            if messages != nil, messages!.count > 0 {
              let messageList = messages!.map { message in
                message.toDic()
              }
              let result = NimResult(["messageList": messageList], 0, nil)
              resultCallback.result(result.toDic())
            } else {
              let result = NimResult(nil, 0, nil)
              resultCallback.result(result.toDic())
            }
          }
        }
    } else {
      resultCallback.result(NimResult.error("convert nim message failed").toDic() as Any)
    }
  }

  func pullMessageHistory(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let messageArgs = arguments["message"] as? [String: Any],
       let message = NIMMessage.convertToMessage(messageArgs),
       let sessionId = message.sessionId,
       let sessionType = message.sessionType,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      let option = NIMHistoryMessageSearchOption()
      option.limit = arguments["limit"] as? UInt ?? 0
      option.order = NIMMessageSearchOrder.desc
      option.currentMessage = message
      option.sync = arguments["persist"] as? Bool ?? false
      NIMSDK.shared().conversationManager
        .fetchMessageHistory(session, option: option) { error, messages in
          if error != nil {
            let nserror = error! as NSError
            let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
            resultCallback.result(result.toDic())
          } else {
            if messages != nil, messages!.count > 0 {
              let messageList = messages!.map { message in
                message.toDic()
              }
              let result = NimResult(["messageList": messageList], 0, nil)
              resultCallback.result(result.toDic())
            } else {
              let result = NimResult(nil, 0, nil)
              resultCallback.result(result.toDic())
            }
          }
        }
    } else {
      resultCallback.result(NimResult.error("convert nim message failed").toDic() as Any)
    }
  }

  func clearServerHistory(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let sessionId = arguments["sessionId"] as? String ?? ""
    let sessionType = arguments["sessionType"] as? String ?? ""
    let sessionType2 = try? NIMSessionType.getType(sessionType)
    let sync = arguments["sync"] as? Bool ?? false
    let ext = arguments["ext"] as? String ?? ""
    let session = NIMSession(sessionId, type: sessionType2!)

    let option = NIMClearMessagesOption()
    option.removeRoam = sync

    NIMSDK.shared().conversationManager
      .deleteSelfRemoteSession(session, option: option) { error in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          let result = NimResult(nil, 0, nil)
          resultCallback.result(result.toDic())
        }
      }
  }

  func deleteMsgSelf(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let m = arguments["message"] as? [String: Any],
       let message = NIMMessage.convertToMessage(m),
       let sessionId = message.sessionId,
       let sessionType = message.sessionType,
       let sessionType2 = try? NIMSessionType.getType(sessionType) {
      if let messages = NIMSDK.shared().conversationManager.messages(
        in: NIMSession(sessionId, type: sessionType2),
        messageIds: [message.messageId]
      ),
        messages.count > 0 {
        let ext = arguments["ext"] as? String
        NIMSDK.shared().conversationManager
          .deleteMessage(fromServer: messages.first!, ext: ext) { error in
            if error != nil {
              let nserror = error! as NSError
              let result = NimResult(
                nil,
                NSNumber(value: nserror.code),
                nserror.description
              )
              resultCallback.result(result.toDic())
            } else {
              let result = NimResult(nil, 0, nil)
              resultCallback.result(result.toDic())
            }
          }
      } else {
        resultCallback.result(NimResult.success("message already deleted").toDic())
      }
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }

  func deleteMsgListSelf(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let messageList = arguments["messageList"] as! [[String: Any]]
    let ext = arguments["ext"] as? String ?? ""
    for m in messageList {
      if let message = NIMMessage.convertToMessage(m),
         let sessionId = message.sessionId,
         let sessionType = message.sessionType,
         let sessionType2 = try? NIMSessionType.getType(sessionType) {
        if let messages = NIMSDK.shared().conversationManager.messages(
          in: NIMSession(sessionId, type: sessionType2),
          messageIds: [message.messageId]
        ),
          messages.count > 0 {
          NIMSDK.shared().conversationManager
            .deleteMessage(fromServer: messages.first!, ext: ext) { error in
              if error != nil {
                let nserror = error! as NSError
                let result = NimResult(
                  nil,
                  NSNumber(value: nserror.code),
                  nserror.description
                )
                resultCallback.result(result.toDic())
              }
            }
        }
      } else {
        resultCallback.result(NimResult.error("convert nim message failed").toDic() as Any)
      }
    }
    let result = NimResult(nil, 0, nil)
    resultCallback.result(result.toDic())
  }

  func searchMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let sessionId = arguments["sessionId"] as? String ?? ""
    let sessionType = arguments["sessionType"] as? String ?? ""
    let sessionType2 = try? NIMSessionType.getType(sessionType)
    let session = NIMSession(sessionId, type: sessionType2!)
    let option = NIMMessageSearchOption.fromDic(arguments["searchOption"] as! [String: Any])
    NIMSDK.shared().conversationManager
      .searchMessages(session, option: option) { error, messages in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          if messages != nil, messages!.count > 0 {
            let messageList = messages!.map { message in
              message.toDic()
            }
            let result = NimResult(["messageList": messageList], 0, nil)
            resultCallback.result(result.toDic())
          } else {
            let result = NimResult(nil, 0, nil)
            resultCallback.result(result.toDic())
          }
        }
      }
  }

  func searchAllMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let option = NIMMessageSearchOption.fromDic(arguments["searchOption"] as! [String: Any])
    NIMSDK.shared().conversationManager.searchAllMessages(option) { error, msgMap in
      if error != nil {
        let nserror = error! as NSError
        let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
        resultCallback.result(result.toDic())
      } else {
        var messages = [[String: Any]]()
        if msgMap != nil {
          for (session, value) in msgMap! {
            for msg in value {
              if var dic = msg.toDic() {
                dic["sessionId"] = session.sessionId
                dic["sessionType"] = FLT_NIMSessionType
                  .convertFLTSessionType(session.sessionType)?.rawValue
                messages.append(dic)
              }
            }
          }
        }
        let result = NimResult(["messageList": messages], 0, nil)
        resultCallback.result(result.toDic())
      }
    }
  }

  func searchRoamingMsg(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let otherAccid = arguments["otherAccid"] as? String ?? ""
    let fromTime = arguments["fromTime"] as? Double ?? 0.0
    let endTime = arguments["endTime"] as? Double ?? 0.0
    let keyword = arguments["keyword"] as? String ?? ""
    let limit = arguments["limit"] as? UInt ?? 0
    let reverse = arguments["reverse"] as? Bool ?? false

    let session = NIMSession(otherAccid, type: NIMSessionType.P2P)

    let option = NIMMessageServerRetrieveOption()
    option.startTime = fromTime
    option.endTime = endTime
    option.keyword = keyword
    option.limit = limit
    option.order = reverse ? NIMMessageSearchOrder.desc : NIMMessageSearchOrder.asc

    NIMSDK.shared().conversationManager
      .retrieveServerMessages(session, option: option) { error, messages in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          if messages != nil, messages!.count > 0 {
            let messageList = messages!.map { message in
              message.toDic()
            }
            let result = NimResult(["messageList": messageList], 0, nil)
            resultCallback.result(result.toDic())
          } else {
            let result = NimResult(nil, 0, nil)
            resultCallback.result(result.toDic())
          }
        }
      }
  }

  func searchCloudMessageHistory(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let config = arguments["messageKeywordSearchConfig"] as? [AnyHashable: Any],
       let option = NIMMessageFullKeywordSearchOption.yx_model(with: config) {
      var msgTypeArray = [NIMMessageType]()
      if let msgTypeList = config["msgTypeList"] as? [String] {
        for s in msgTypeList {
          if let messageType = try? NIMMessageType.getType(s) {
            msgTypeArray.append(messageType)
          }
        }
      }
      option.msgTypeArray = msgTypeArray
      NIMSDK.shared().conversationManager.retrieveServerMessages(option) { error, messages in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          if messages != nil, messages!.count > 0 {
            let messageList = messages!.map { message in
              message.toDic()
            }
            let result = NimResult(["messageList": messageList], 0, nil)
            resultCallback.result(result.toDic())
          } else {
            let result = NimResult(nil, 0, nil)
            resultCallback.result(result.toDic())
          }
        }
      }
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }

  func saveMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let message = NIMMessage.convertToMessage(arguments),
       let sessionId = message.sessionId,
       let sessionType = message.sessionType,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      message.gArgument = arguments
      message.setValue(session, forKeyPath: #keyPath(NIMMessage.session))

      NIMSDK.shared().conversationManager.save(message, for: session) { error in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          let result = NimResult(message.toDic(), 0, nil)
          resultCallback.result(result.toDic())
        }
      }
    } else {
      resultCallback.result(NimResult.error("create message error").toDic())
    }
  }

  func updateMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let message = NIMMessage.convertToMessage(arguments),
       let sessionId = message.sessionId,
       let sessionType = message.sessionType,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      message.gArgument = arguments
      message.setValue(session, forKeyPath: #keyPath(NIMMessage.session))
      // 需要先查询消息，JSON转换会丢掉私有变量
      if let messages = NIMSDK.shared().conversationManager
        .messages(in: session, messageIds: [message.messageId]),
        messages.count > 0 {
        let m = messages.first!
        // 目前只支持这两个字段update
        if message.localExt != nil {
          m.localExt = message.localExt
        }
        if message.messageObject != nil {
          m.messageObject = message.messageObject
        }
        NIMSDK.shared().conversationManager.update(m, for: session) { error in
          if error != nil {
            let nserror = error! as NSError
            let result = NimResult(
              nil,
              NSNumber(value: nserror.code),
              nserror.description
            )
            resultCallback.result(result.toDic())
          } else {
            let result = NimResult(nil, 0, nil)
            resultCallback.result(result.toDic())
          }
        }
      } else {
        resultCallback.result(NimResult.error("update message message not in db").toDic())
      }
    } else {
      resultCallback.result(NimResult.error("create message error").toDic())
    }
  }

  func cancelUploadAttachment(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let message = NIMMessage.convertToMessage(arguments),
       let sessionId = message.sessionId,
       let sessionType = message.sessionType,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      message.gArgument = arguments
      message.setValue(session, forKeyPath: #keyPath(NIMMessage.session))

      NIMSDK.shared().chatManager.cancelSending(message)
      resultCallback.result(NimResult.success().toDic())
    } else {
      resultCallback.result(NimResult.error("create message error").toDic())
    }
  }

  func forwardMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let message = NIMMessage.convertToMessage(arguments),
       let sessionId = message.sessionId,
       let sessionType = message.sessionType,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      message.gArgument = arguments
      message.setValue(session, forKeyPath: #keyPath(NIMMessage.session))

      let messageCallback = NimMessageCallback()
      messageCallback.callback = resultCallback
      messageCallback.message = message
      messageCacheDic[message.messageId] = messageCallback

      do {
        try NIMSDK.shared().chatManager.forwardMessage(message, to: session)
      } catch let error as NSError {
        print("forwardMessage message  error : \(error)")
        messageCacheDic.removeValue(forKey: message.messageId)
        resultCallback.result(NimResult.error(error.code, error.description).toDic())
      }
      resultCallback.result(NimResult.success().toDic())
    } else {
      resultCallback.result(NimResult.error("create message error").toDic())
    }
  }

  func messageInTransport(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let message = NIMMessage.convertToMessage(arguments),
       let sessionId = message.sessionId,
       let sessionType = message.sessionType,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      message.gArgument = arguments
      message.setValue(session, forKeyPath: #keyPath(NIMMessage.session))

      let inTransport = NIMSDK.shared().chatManager.message(inTransport: message)
      resultCallback.result(NimResult.success(["inTransport": inTransport]).toDic())
    } else {
      resultCallback.result(NimResult.error("create message error").toDic())
    }
  }

  func messageTransportProgress(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let message = NIMMessage.convertToMessage(arguments),
       let sessionId = message.sessionId,
       let sessionType = message.sessionType,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      message.gArgument = arguments
      message.setValue(session, forKeyPath: #keyPath(NIMMessage.session))

      let transportProgress = NIMSDK.shared().chatManager.messageTransportProgress(message)
      resultCallback
        .result(NimResult.success(["transportProgress": transportProgress]).toDic())
    } else {
      resultCallback.result(NimResult.error("create message error").toDic())
    }
  }

  func revokeMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let message = NIMMessage.convertToMessage(arguments),
       let sessionId = message.sessionId,
       let sessionType = message.sessionType,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      message.gArgument = arguments
      message.setValue(session, forKeyPath: #keyPath(NIMMessage.session))

      let option = NIMRevokeMessageOption()
      option.apnsContent = arguments["customApnsText"] as? String
      option.apnsPayload = arguments["pushPayload"] as? [AnyHashable: Any]
      option.shouldBeCounted = arguments["shouldNotifyBeCount"] as? Bool ?? true
      option.postscript = arguments["postscript"] as? String
      option.attach = arguments["attach"] as? String
      // 需要先查询消息，JSON转换会丢掉私有变量
      if let messages = NIMSDK.shared().conversationManager
        .messages(in: session, messageIds: [message.messageId]),
        messages.count > 0 {
        NIMSDK.shared().chatManager
          .revokeMessage(messages.first!, option: option) { error in
            if error != nil {
              let nserror = error! as NSError
              let result = NimResult(
                nil,
                NSNumber(value: nserror.code),
                nserror.description
              )
              resultCallback.result(result.toDic())
            } else {
              resultCallback.result(NimResult.success().toDic())
            }
          }
      } else {
        resultCallback.result(NimResult.error("update message message not in db").toDic())
      }
    } else {
      resultCallback.result(NimResult.error("create message error").toDic())
    }
  }

  func sendMessageReceipt(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let message = NIMMessage.convertToMessage(arguments),
       let sessionId = message.sessionId,
       let sessionType = message.sessionType,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      message.gArgument = arguments
      message.setValue(session, forKeyPath: #keyPath(NIMMessage.session))

      let receipt = NIMMessageReceipt(message: message)
      NIMSDK.shared().chatManager.send(receipt) { error in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          resultCallback.result(NimResult.success().toDic())
        }
      }
    }
  }

  func sendTeamMessageReceipts(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let message = NIMMessage.convertToMessage(arguments),
       let sessionId = message.sessionId,
       let sessionType = message.sessionType,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      message.gArgument = arguments
      message.setValue(session, forKeyPath: #keyPath(NIMMessage.session))

      var receipts = [NIMMessageReceipt]()
      receipts.append(NIMMessageReceipt(message: message))
      NIMSDK.shared().chatManager.sendTeamMessageReceipts(receipts) { error, messageReceipt in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          // TODO: 组messageReceipt
          resultCallback.result(NimResult.success().toDic())
        }
      }
    }
  }

  func refreshTeamMessageReceipts(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let messageList = arguments["messageList"] as? [[String: Any]] {
      var list = [NIMMessage]()
      for a in messageList {
        if let message = NIMMessage.convertToMessage(a),
           let sessionId = message.sessionId,
           let sessionType = message.sessionType,
           let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
          let session = NIMSession(sessionId, type: type)
          message.gArgument = a
          message.setValue(session, forKeyPath: #keyPath(NIMMessage.session))
          list.append(message)
        }
      }
      NIMSDK.shared().chatManager.refreshTeamMessageReceipts(list)
      resultCallback.result(NimResult.success().toDic())
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }

  func queryMessageReceiptDetail(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let message = NIMMessage.convertToMessage(arguments),
       let sessionId = message.sessionId,
       let sessionType = message.sessionType,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      message.gArgument = arguments
      message.setValue(session, forKeyPath: #keyPath(NIMMessage.session))

      var set = Set<AnyHashable>()
      if let accountList = arguments["accountList"] as? [String] {
        for account in accountList {
          set.insert(account)
        }
      }

      if set.isEmpty {
        NIMSDK.shared().chatManager.queryMessageReceiptDetail(message) { error, receiptDetail in
          if error != nil {
            let nserror = error! as NSError
            let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
            resultCallback.result(result.toDic())
          } else {
            resultCallback.result(NimResult.success(receiptDetail?.toDic()).toDic())
          }
        }
      } else {
        NIMSDK.shared().chatManager
          .queryMessageReceiptDetail(message, accountSet: set) { error, receiptDetail in
            if error != nil {
              let nserror = error! as NSError
              let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
              resultCallback.result(result.toDic())
            } else {
              resultCallback.result(NimResult.success(receiptDetail?.toDic()).toDic())
            }
          }
      }

    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }

  func localMessageReceiptDetail(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let message = NIMMessage.convertToMessage(arguments),
       let sessionId = message.sessionId,
       let sessionType = message.sessionType,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      message.gArgument = arguments
      message.setValue(session, forKeyPath: #keyPath(NIMMessage.session))

      var set = Set<AnyHashable>()
      if let accountList = arguments["accountList"] as? [String] {
        for account in accountList {
          set.insert(account)
        }
      }

      NIMSDK.shared().chatManager.localMessageReceiptDetail(message, accountSet: set)
      resultCallback.result(NimResult.success().toDic())
    } else {
      resultCallback.result(NimResult.error("create message error").toDic())
    }
  }

  func queryMySessionList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    // key: minTimestamp maxTimestamp needLastMessage limit
    let option = NIMFetchServerSessionOption.yx_model(with: arguments)
    if option != nil {
      let needLastMsg = arguments["needLastMsg"] as? Int
      option!.needLastMessage = needLastMsg != 0 // 一个字段命名不一样
    }
    NIMSDK.shared().conversationManager
      .fetchServerSessions(option) { error, sessions, hasMore in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          if sessions != nil,
             sessions!.count > 0 {
            let sessionDics = sessions!.map { session in
              session.toDicEx()
            }
            resultCallback
              .result(NimResult
                .success(["mySessionList": ["sessionList": sessionDics, "hasMore": hasMore]])
                .toDic())
          } else {
            resultCallback.result(NimResult.success().toDic())
          }
        }
      }
  }

  func queryMySession(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let sessionId = arguments["sessionId"] as? String,
       let sessionType = arguments["sessionType"] as? String,
       let sessionType2 = try? NIMSessionType.getType(sessionType) {
      let session = NIMSession(sessionId, type: sessionType2)
      NIMSDK.shared().conversationManager
        .fetchServerSession(by: session) { error, recentSession in
          if error != nil {
            let nserror = error! as NSError
            let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
            resultCallback.result(result.toDic())
          } else {
            resultCallback
              .result(NimResult.success(["recentSession": recentSession?.toDicEx()])
                .toDic())
          }
        }
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }

  func updateMySession(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let sessionId = arguments["sessionId"] as? String,
       let sessionType = arguments["sessionType"] as? String,
       let sessionType2 = try? NIMSessionType.getType(sessionType),
       let ext = arguments["ext"] as? String {
      let session = NIMSession(sessionId, type: sessionType2)
      NIMSDK.shared().conversationManager
        .updateServerSessionExt(ext, session: session) { error in
          if error != nil {
            let nserror = error! as NSError
            let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
            resultCallback.result(result.toDic())
          } else {
            resultCallback.result(NimResult.success().toDic())
          }
        }
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }

  func deleteMySession(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let sessionsDic = arguments["sessionList"] as? [[String: Any]] {
      var sessions = [NIMSession]()
      for s in sessionsDic {
        if let sessionId = s["sessionId"] as? String,
           let sessionType = s["sessionType"] as? String,
           let sessionType2 = try? NIMSessionType.getType(sessionType) {
          let session = NIMSession(sessionId, type: sessionType2)
          sessions.append(session)
        }
      }
      NIMSDK.shared().conversationManager.deleteServerSessions(sessions) { error in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          resultCallback.result(NimResult.success().toDic())
        }
      }
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }
}

// 消息扩展
extension FLTMessageService {
  func addCollect(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let params = NIMAddCollectParams.yx_model(with: arguments) {
      NIMSDK.shared().chatExtendManager.addCollect(params) { error, collectInfo in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          if collectInfo == nil {
            resultCallback.result(NimResult.success().toDic())
          } else {
            resultCallback.result(NimResult.success(collectInfo!.toDic()).toDic())
          }
        }
      }
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }

  func removeCollect(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let collects = arguments["collects"] as? [[String: Any]] {
      var infoList = [NIMCollectInfo]()
      for collect in collects {
        if let info = NIMCollectInfo.yx_model(with: collect) {
          infoList.append(info)
        }
      }
      NIMSDK.shared().chatExtendManager.removeCollect(infoList) { error, total_removed in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          resultCallback.result(NimResult.success(total_removed).toDic())
        }
      }
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }

  func updateCollect(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let info = NIMCollectInfo.yx_model(with: arguments) {
      NIMSDK.shared().chatExtendManager.updateCollect(info) { error, info in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          if info != nil {
            resultCallback.result(NimResult.success(info!.toDic()).toDic())
          } else {
            resultCallback.result(NimResult.success().toDic())
          }
        }
      }
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }

  func queryCollect(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let options = NIMCollectQueryOptions.fromDic(arguments)
    NIMSDK.shared().chatExtendManager.queryCollect(options) { error, infos, totalCount in
      if error != nil {
        let nserror = error! as NSError
        let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
        resultCallback.result(result.toDic())
      } else {
        if infos != nil {
          let collects = infos!.map { info in
            info.yx_modelToJSONObject()
          }
          resultCallback
            .result(NimResult.success(["totalCount": totalCount, "collects": collects])
              .toDic())
        } else {
          resultCallback.result(NimResult.success(["totalCount": totalCount]).toDic())
        }
      }
    }
  }

  func addMessagePin(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let pinItem = NIMMessagePinItem.fromDic(arguments) {
      NIMSDK.shared().chatExtendManager.addMessagePin(pinItem) { error, item in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          resultCallback.result(NimResult.success().toDic())
        }
      }
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }

  func updateMessagePin(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let pinItem = NIMMessagePinItem.fromDic(arguments) {
      NIMSDK.shared().chatExtendManager.updateMessagePin(pinItem) { error, item in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          resultCallback.result(NimResult.success().toDic())
        }
      }
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }

  func removeMessagePin(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let pinItem = NIMMessagePinItem.fromDic(arguments) {
      NIMSDK.shared().chatExtendManager.removeMessagePin(pinItem) { error, item in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          resultCallback.result(NimResult.success().toDic())
        }
      }
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }

  func queryMessagePinForSession(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let sessionId = arguments["sessionId"] as? String,
       let sessionTypeValue = arguments["sessionType"] as? String,
       let sessionType = try? NIMSessionType.getType(sessionTypeValue) {
      let session = NIMSession(sessionId, type: sessionType)
      NIMSDK.shared().chatExtendManager.loadMessagePins(for: session) { error, items in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          if items != nil {
            let ret = items!.map { i in
              i.toDic()
            }
            resultCallback.result(NimResult.success(["pinList": ret]).toDic())
          } else {
            resultCallback.result(NimResult.success().toDic())
          }
        }
      }
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }

  func addQuickComment(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let comment = NIMQuickComment.fromDic(arguments)
    NIMSDK.shared().chatExtendManager
      .add(NIMQuickComment.fromDic(arguments), to: comment.message) { error in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          resultCallback.result(NimResult.success().toDic())
        }
      }
  }

  func removeQuickComment(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let comment = NIMQuickComment.fromDic(arguments)
    NIMSDK.shared().chatExtendManager.delete(comment) { error in
      if error != nil {
        let nserror = error! as NSError
        let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
        resultCallback.result(result.toDic())
      } else {
        resultCallback.result(NimResult.success().toDic())
      }
    }
  }

  func queryQuickComment(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let msgs = arguments["msgList"] as? [[String: Any]] {
      let m = msgs.compactMap { dic in
        NIMMessage.convertToMessage(dic)
      }
      NIMSDK.shared().chatExtendManager.fetchQuickComments(m) { error, table, messages in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          // QuickCommentOptionWrapper: key, quickCommentList, modify, time
          // MessageKey: sessionType, fromAccount, toAccount, time, serverId, uuid
          // QuickCommentOption: fromAccount, replyType, time, ext, needBadge, needPush, pushTitle, pushContent, pushPayload
          var result = [[String: Any]]()
          if table != nil {
            for key in table!.keyEnumerator() {
              if let msg = key as? NIMMessage {
                let sessionType = FLT_NIMSessionType
                  .convertFLTSessionType(msg.session!.sessionType)?.rawValue
                let k = [
                  "sessionType": sessionType,
                  "fromAccount": msg.from,
                  "toAccount": msg.sessionId,
                  "time": Int(msg.timestamp),
                  "serverId": Int(msg.serverID),
                  "uuid": msg.messageId,
                ] as [String: Any]
                //                                let modify = msg.
                let time = msg.timestamp
                let value = table!.object(forKey: msg)
                let quickCommentList = value!.compactMap { comment in
                  (comment as! NIMQuickComment).toDic()
                }
                let dic = [
                  "key": k,
                  "time": Int(time),
                  "quickCommentList": quickCommentList,
                ] as [String: Any]
                result.append(dic)
              }
            }
          }
          resultCallback
            .result(NimResult.success(["quickCommentOptionWrapperList": result]).toDic())
        }
      }
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }

  func addStickTopSession(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let sessionId = arguments["sessionId"] as? String,
       let sessionTypeValue = arguments["sessionType"] as? String,
       let sessionType = try? NIMSessionType.getType(sessionTypeValue) {
      let session = NIMSession(sessionId, type: sessionType)
      let params = NIMAddStickTopSessionParams()
      params.session = session
      params.ext = arguments["ext"] as? String ?? ""
      NIMSDK.shared().chatExtendManager.addStickTopSession(params) { error, sessionInfo in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          if sessionInfo != nil {
            resultCallback
              .result(NimResult.success(["stickTopSessionInfo": sessionInfo!.toDic()])
                .toDic())
          } else {
            resultCallback.result(NimResult.success().toDic())
          }
        }
      }
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }

  func removeStickTopSession(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    NIMSDK.shared().chatExtendManager
      .removeStickTopSession(NIMStickTopSessionInfo.fromDic(arguments)) { error, sessionInfo in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          resultCallback.result(NimResult.success().toDic())
        }
      }
  }

  func updateStickTopSession(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    NIMSDK.shared().chatExtendManager
      .udpateStickTopSession(NIMStickTopSessionInfo.fromDic(arguments)) { error, sessionInfo in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          if sessionInfo != nil {
            resultCallback
              .result(NimResult.success(["stickTopSessionInfo": sessionInfo!.toDic()])
                .toDic())
          } else {
            resultCallback.result(NimResult.success().toDic())
          }
        }
      }
  }

  func queryStickTopSession(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    NIMSDK.shared().chatExtendManager.loadStickTopSessionInfos { error, dic in
      if error != nil {
        let nserror = error! as NSError
        let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
        resultCallback.result(result.toDic())
      } else {
        if dic != nil {
          var infos = [[String: Any]]()
          dic?.values.forEach { stickTopSessionInfo in
            infos.append(stickTopSessionInfo.toDic())
          }
          resultCallback.result(NimResult.success(["stickTopSessionInfoList": infos]).toDic())
        } else {
          resultCallback.result(NimResult.success().toDic())
        }
      }
    }
  }

  func queryRoamMsgHasMoreTime(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let sessionId = arguments["sessionId"] as? String,
       let sessionTypeValue = arguments["sessionType"] as? String,
       let sessionType = try? NIMSessionType.getType(sessionTypeValue) {
      let session = NIMSession(sessionId, type: sessionType)
      NIMSDK.shared().conversationManager
        .incompleteSessionInfo(by: session) { error, sessionInfo in
          if error != nil {
            let nserror = error! as NSError
            let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
            resultCallback.result(result.toDic())
          } else {
            if sessionInfo != nil {
              let timeStamp = sessionInfo?.first?.timestamp ?? 0
              resultCallback.result(NimResult.success(timeStamp).toDic())
            } else {
              resultCallback.result(NimResult.success().toDic())
            }
          }
        }
    }
  }

  func updateRoamMsgHasMoreTag(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let message = NIMMessage.convertToMessage(arguments),
       let sessionId = message.sessionId,
       let sessionType = message.sessionType,
       let type = FLT_NIMSessionType(rawValue: sessionType)?.convertToNIMSessionType() {
      let session = NIMSession(sessionId, type: type)
      message.gArgument = arguments
      message.setValue(session, forKeyPath: #keyPath(NIMMessage.session))

      NIMSDK.shared().conversationManager
        .updateIncompleteSessions([message]) { error, recentSessions in
          if error != nil {
            let nserror = error! as NSError
            let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
            resultCallback.result(result.toDic())
          } else {
            resultCallback.result(NimResult.success().toDic())
          }
        }

    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic())
    }
  }

  func loadRecentSessionsWithOptions(_ arguments: [String: Any],
                                     _ resultCallback: ResultCallback) {
    NIMSDK.shared().chatExtendManager
      .loadRecentSessions(with: NIMLoadRecentSessionsOptions
        .yx_model(with: arguments) ?? NIMLoadRecentSessionsOptions()) { error, sessions in
          if error != nil {
            let nserror = error! as NSError
            let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
            resultCallback.result(result.toDic())
          } else {
            if sessions != nil {
              let infos = sessions!.compactMap { s in
                s.toDic()
              }
              resultCallback.result(NimResult.success(["recentSessions": infos]).toDic())
            } else {
              resultCallback.result(NimResult.success().toDic())
            }
          }
      }
  }

  func sortRecentSessions(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
//        NIMSDK.shared().chatExtendManager.sortRecentSessions(<#T##recentSessions: [NIMRecentSession]##[NIMRecentSession]#>, withStickTopInfos: <#T##[NIMSession : NIMStickTopSessionInfo]#>)
  }

  func stickTopInfoForSession(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let sessionId = arguments["sessionId"] as? String,
       let sessionTypeValue = arguments["sessionType"] as? String,
       let sessionType = try? NIMSessionType.getType(sessionTypeValue) {
      let session = NIMSession(sessionId, type: sessionType)
      let info = NIMSDK.shared().chatExtendManager.stickTopInfo(for: session)
      // info要处理toDic
      resultCallback.result(NimResult.success(info.yx_modelToJSONObject()).toDic())
    } else {
      resultCallback.result(NimResult.error("arguments invalid").toDic() as Any)
    }
  }
}

extension FLTMessageService: NIMChatExtendManagerDelegate {
  func onRecvQuickComment(_ comment: NIMQuickComment) {
    if let session = comment.message.session,
       let sessionType = FLT_NIMSessionType.convertFLTSessionType(session.sessionType)?
       .rawValue {
      let key = [
        "sessionType": sessionType,
        "fromAccount": comment.message.from,
        "toAccount": comment.message.sessionId,
        "time": Int(comment.message.timestamp),
        "serverId": Int(comment.message.serverID),
        "uuid": comment.message.messageId,
      ] as [String: Any]
      notifyEvent(
        serviceName(),
        "onQuickCommentAdd",
        ["key": key, "commentOption": comment.toDic()]
      )
    }
  }

  func onRemove(_ comment: NIMQuickComment) {
    if let session = comment.message.session,
       let sessionType = FLT_NIMSessionType.convertFLTSessionType(session.sessionType)?
       .rawValue {
      let key = [
        "sessionType": sessionType,
        "fromAccount": comment.message.from,
        "toAccount": comment.message.sessionId,
        "time": Int(comment.message.timestamp),
        "serverId": Int(comment.message.serverID),
        "uuid": comment.message.messageId,
      ] as [String: Any]
      notifyEvent(
        serviceName(),
        "onQuickCommentRemove",
        ["key": key, "commentOption": comment.toDic()]
      )
    }
  }

  func onNotifyAddMessagePin(_ item: NIMMessagePinItem) {
    notifyEvent(serviceName(), "onMessagePinAdded", item.toDic())
  }

  func onNotifyRemoveMessagePin(_ item: NIMMessagePinItem) {
    notifyEvent(serviceName(), "onMessagePinRemoved", item.toDic())
  }

  func onNotifyUpdateMessagePin(_ item: NIMMessagePinItem) {
    notifyEvent(serviceName(), "onMessagePinUpdated", item.toDic())
  }

  func onNotifySyncStickTopSessions(_ response: NIMSyncStickTopSessionResponse) {
    let sessions = response.allInfos.compactMap { info in
      info.toDic()
    }
    notifyEvent(serviceName(), "onSyncStickTopSession", ["data": sessions])
  }

  func onNotifyAddStickTopSession(_ newInfo: NIMStickTopSessionInfo) {
    notifyEvent(serviceName(), "onStickTopSessionAdd", newInfo.toDic())
  }

  func onNotifyRemoveStickTopSession(_ removedInfo: NIMStickTopSessionInfo) {
    notifyEvent(serviceName(), "onStickTopSessionRemove", removedInfo.toDic())
  }

  func onNotifyUpdateStickTopSession(_ updatedInfo: NIMStickTopSessionInfo) {
    notifyEvent(serviceName(), "onStickTopSessionUpdate", updatedInfo.toDic())
  }
}

// MARK: NIMBroadcastManagerDelegate

extension FLTMessageService: NIMBroadcastManagerDelegate {
  func onReceive(_ broadcastMessage: NIMBroadcastMessage) {
    notifyEvent(serviceName(), "onBroadcastMessage", broadcastMessage.toDic())
  }
}

extension FLTMessageService: NIMConversationManagerDelegate {
  func didServerSessionUpdated(_ recentSession: NIMRecentSession?) {
    notifyEvent(serviceName(), "onMySessionUpdate", recentSession!.toDicEx())
  }

  func allMessagesDeleted() {
    notifyEvent(serviceName(), "onSessionDelete", nil)
  }
}
