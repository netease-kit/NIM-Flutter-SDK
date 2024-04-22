// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum SessionType: String {
  case SessionCreate = "createSession"
  case SessionRecentList = "querySessionList"
  case SessionCustomRecentList = "querySessionListFiltered"
  case SessionspecifySession = "querySession" // 获取指定最近会话
  case SessionUpdate = "updateSession"
  case UpdateSessionWithMessage = "updateSessionWithMessage"
  case SessionUnreadCount = "queryTotalUnreadCount"
  case SessionMarkRead = "clearSessionUnreadCount" // 标记已读
  case SessionSyncUnreadCount = "syncUnreadCount" // 未读数多端同步
  case SessionDeleteRecent = "deleteSession"
  case ClearAllSessionUnreadCount = "clearAllSessionUnreadCount"

  static let allValues = [
    SessionCreate,
    SessionRecentList,
    SessionCustomRecentList,
    SessionspecifySession,
    SessionUpdate,
    UpdateSessionWithMessage,
    SessionUnreadCount,
    SessionMarkRead,
    SessionSyncUnreadCount,
    SessionDeleteRecent,
    ClearAllSessionUnreadCount,
  ]
}

class FLTSessionService: FLTBaseService, FLTService {
//    override init() {
//        super.init()
//        NIMSDK.shared().conversationManager.add(self)
//    }

  override func onInitialized() {
    NIMSDK.shared().conversationManager.add(self)
  }

  deinit {
    NIMSDK.shared().conversationManager.remove(self)
  }

  // MARK: - Protocol

  func serviceName() -> String {
    ServiceType.SessionService.rawValue
  }

  func checkMethod(_ method: String) -> Bool {
    for type in SessionType.allValues {
      if method == type.rawValue {
        return true
      }
    }
    return false
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case SessionType.SessionCreate.rawValue: createSession(arguments, resultCallback)
    case SessionType.SessionRecentList.rawValue: getRecentList(arguments, resultCallback)
    case SessionType.SessionCustomRecentList
      .rawValue: getCustomRecentList(arguments, resultCallback)
    case SessionType.SessionspecifySession
      .rawValue: getSpecifySession(arguments, resultCallback)
    case SessionType.SessionUpdate.rawValue: updateSession(arguments, resultCallback)
    case SessionType.UpdateSessionWithMessage
      .rawValue: updateSessionWithMessage(arguments, resultCallback)
    case SessionType.SessionUnreadCount.rawValue: unreadCount(arguments, resultCallback)
    case SessionType.SessionMarkRead.rawValue: markRead(arguments, resultCallback)
    case SessionType.SessionDeleteRecent.rawValue: deleteRecent(arguments, resultCallback)
    case SessionType.ClearAllSessionUnreadCount
      .rawValue: clearAllSessionUnreadCount(arguments, resultCallback)
    default:
      break
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  private func createSessionFaile(_ resultCallback: ResultCallback) {
    resultCallback
      .result(NimResult.error("service name : \(serviceName())  msg : create session failed")
        .toDic())
  }

  // MARK: - SDK API

  private func createSession(_ argument: [String: Any], _ resultCallback: ResultCallback) {
    guard let time = argument["time"] as? Int,
          time > 0 else {
      resultCallback.result(NimResult.success().toDic())
      return
    }
    if let session = convertSession(argument) {
      let option = NIMAddEmptyRecentSessionBySessionOption()
      if let linkToLastMessage = argument["linkToLastMessage"] as? Bool {
        option.withLastMsg = linkToLastMessage
      }
      NIMSDK.shared().conversationManager.addEmptyRecentSession(by: session, option: option)
      let recentSession = NIMSDK.shared().conversationManager.recentSession(by: session)
      resultCallback.result(NimResult.success(recentSession?.toDic()).toDic())
    } else {
      createSessionFaile(resultCallback)
    }
  }

  private func getRecentList(_ argument: [String: Any], _ resultCallback: ResultCallback) {
    let array = NIMSDK.shared().conversationManager.allRecentSessions()
    if let allSessions = array {
      var limit = allSessions.count
      var ret = [[String: Any]]()
      if let lmt = argument["limit"] as? Int {
        limit = min(limit, lmt)
      }

      for index in 0 ..< limit {
        if let item = allSessions[index].toDic() {
          ret.append(item)
        }
      }

      resultCallback.result(NimResult.success(["resultList": ret]).toDic())
    } else {
      resultCallback.result(NimResult.error("get allRecentSessions() error").toDic())
    }
  }

  private func getCustomRecentList(_ argument: [String: Any], _ resultCallback: ResultCallback) {
    if let filterMessageTypeList = argument["filterMessageTypeList"] as? [String] {
      let option = NIMRecentSessionOption()

      var filters = [NSNumber]()
      filterMessageTypeList.forEach { string in
        if let flt_type = FLT_NIMMessageType(rawValue: string),
           let type = flt_type.convertToNIMMessageType()?.rawValue {
          filters.append(NSNumber(value: type))
        }
      }
      option.filterLastMessageTypes = filters
      let array = NIMSDK.shared().conversationManager.allRecentSessions(with: option)
      let ret = array?.map { recentSession in
        recentSession.toDic()
      }
      resultCallback.result(NimResult.success(["resultList": ret]).toDic())

    } else {
      resultCallback.result(NimResult.error("filter parameter miss").toDic())
    }
  }

  private func getSpecifySession(_ argument: [String: Any], _ resultCallback: ResultCallback) {
    if let session = convertSession(argument) {
      let recentSession = NIMSDK.shared().conversationManager.recentSession(by: session)
      resultCallback.result(NimResult.success(recentSession?.toDic()).toDic())
    } else {
      createSessionFaile(resultCallback)
    }
  }

  private func updateSession(_ argument: [String: Any], _ resultCallback: ResultCallback) {
    if let data = argument["session"] as? [String: Any],
       let session = convertSession(data) {
      let extensionDic = data["extension"] as? [String: Any]
      if let recent = NIMSDK.shared().conversationManager.recentSession(by: session) {
        NIMSDK.shared().conversationManager
          .updateRecentLocalExt(extensionDic, recentSession: recent)
        successCallBack(resultCallback, nil)
      } else {
        resultCallback
          .result(NimResult
            .error(
              "sessionId: \(session.sessionId) sessiontype: \(session.sessionType) not find"
            )
            .toDic())
      }
    } else {
      createSessionFaile(resultCallback)
    }
  }

  private func updateSessionWithMessage(_ argument: [String: Any],
                                        _ resultCallback: ResultCallback) {
    if let data = argument["message"] as? [String: Any],
       let message = NIMMessage.convertToMessage(data),
       let session = convertSession(data) {
      let msgs = NIMSDK.shared().conversationManager.messages(in: session, messageIds: [message.messageId])
      NIMSDK.shared().conversationManager.update(msgs?.first ?? message, for: session) { error in
        if let ns_error = error as NSError? {
          resultCallback
            .result(NimResult(nil, NSNumber(value: ns_error.code), ns_error.description)
              .toDic())
        } else {
          let recentSession = NIMSDK.shared().conversationManager.recentSession(by: session)
          if recentSession == nil {
            let option = NIMAddEmptyRecentSessionBySessionOption()
            option.withLastMsg = true
            NIMSDK.shared().conversationManager.addEmptyRecentSession(by: session, option: option)
          }
          resultCallback.result(NimResult.success().toDic())
        }
      }
    } else {
      createSessionFaile(resultCallback)
    }
  }

  private func markRead(_ argument: [String: Any], _ resultCallback: ResultCallback) {
    if let requestList = argument["requestList"] as? [[String: Any]] {
      var sessions = [NIMSession]()
      weak var weakSelf = self
      requestList.forEach { request in
        if let session = weakSelf?.convertSession(request) {
          sessions.append(session)
        }
      }
      NIMSDK.shared().conversationManager
        .batchMarkMessagesRead(in: sessions) { error, retSessions in
          if let ns_error = error as NSError? {
            resultCallback
              .result(NimResult.error(ns_error.code, ns_error.description).toDic())
          } else {
            let ret = retSessions?.map { session in
              [
                "sessionId": session.sessionId,
                "sessionType": FLT_NIMSessionType
                  .convertFLTSessionType(session.sessionType)?.rawValue,
              ]
            }
            resultCallback.result(NimResult.success(["failList": ret]).toDic())
          }
        }
    } else {
      createSessionFaile(resultCallback)
    }
  }

  private func unreadCount(_ argument: [String: Any], _ resultCallback: ResultCallback) {
    if let queryType = argument["queryType"] as? Int {
      // 0-all, 1-notify true
      var count: Int
      if queryType == 0 {
        count = NIMSDK.shared().conversationManager.allUnreadCount()
      } else {
        count = NIMSDK.shared().conversationManager.allUnreadCount(queryType == 1)
      }
      resultCallback.result(NimResult.success(["count": count]).toDic())
    } else {
      resultCallback.result(NimResult.error("argument error").toDic())
    }
  }

  private func deleteRecent(_ argument: [String: Any], _ resultCallback: ResultCallback) {
    if let data = argument["sessionInfo"] as? [String: Any],
       let session = convertSession(data),
       let deleteType = argument["deleteType"] as? String,
       let sendAck = argument["sendAck"] as? Bool {
      let option = NIMDeleteRecentSessionOption()
      option.shouldMarkAllMessagesReadInSessions = sendAck
      weak var weakSelf = self
      switch deleteType {
      case "local":
        if let recent = NIMSDK.shared().conversationManager.recentSession(by: session) {
          NIMSDK.shared().conversationManager.delete(recent, option: option) { error in
            if let ns_error = error as NSError? {
              resultCallback
                .result(NimResult.error(ns_error.code, ns_error.description).toDic())
            } else {
              weakSelf?.successCallBack(resultCallback, nil)
            }
          }
        } else {
          resultCallback.result(NimResult.error("don't find session").toDic())
        }

      case "remote":
        NIMSDK.shared().conversationManager.deleteRemoteSessions([session]) { error in
          if let ns_error = error as NSError? {
            resultCallback
              .result(NimResult.error(ns_error.code, ns_error.description).toDic())
          } else {
            weakSelf?.successCallBack(resultCallback, nil)
          }
        }
      case "localAndRemote":
        if let recent = NIMSDK.shared().conversationManager.recentSession(by: session) {
          option.isDeleteRoamMessage = true
          NIMSDK.shared().conversationManager.delete(recent, option: option) { error in
            if let ns_error = error as NSError? {
              resultCallback
                .result(NimResult.error(ns_error.code, ns_error.description).toDic())
            } else {
              weakSelf?.successCallBack(resultCallback, nil)
            }
          }
        } else {
          resultCallback.result(NimResult.error("don't find session").toDic())
        }
      default:
        resultCallback.result(NimResult.error("deleteType error").toDic())
      }
    } else {
      createSessionFaile(resultCallback)
    }
  }

  private func deleteRemote(_ argument: [String: Any], _ resultCallback: ResultCallback) {
    if let sessionList = argument["sessionList"],
       let sessions = NSArray
       .yx_modelArray(with: NIMSession.self, json: sessionList) as? [NIMSession] {
      weak var weakSelf = self
      NIMSDK.shared().conversationManager.deleteRemoteSessions(sessions) { error in
        if let ns_error = error as NSError? {
          resultCallback
            .result(NimResult.error(ns_error.code, ns_error.description).toDic())
        } else {
          weakSelf?.successCallBack(resultCallback, nil)
        }
      }
    } else {
      errorCallBack(resultCallback, "解析sessionList失败")
    }
  }

  private func clearAllSessionUnreadCount(_ argument: [String: Any],
                                          _ resultCallback: ResultCallback) {
    NIMSDK.shared().conversationManager.markAllMessagesRead()
    successCallBack(resultCallback, nil)
  }

  // MARK: - Other

  private func convertSession(_ arguments: [String: Any]) -> NIMSession? {
    if let sessionId = arguments["sessionId"] as? String,
       let sessionTypeValue = arguments["sessionType"] as? String,
       let sessionType = FLT_NIMSessionType(rawValue: sessionTypeValue)?.convertToNIMSessionType() {
      return NIMSession(sessionId, type: sessionType)
    }
    return nil
  }
}

extension FLTSessionService: NIMConversationManagerDelegate {
  func didUpdate(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
    notifyEvent(
      ServiceType.MessageService.rawValue,
      "onSessionUpdate",
      ["data": [recentSession.toDic() as Any]]
    )
  }

  func didAdd(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
    notifyEvent(
      ServiceType.MessageService.rawValue,
      "onSessionUpdate",
      ["data": [recentSession.toDic() as Any]]
    )
  }

  func didRemove(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
    notifyEvent(ServiceType.MessageService.rawValue, "onSessionDelete", recentSession.toDic())
  }

  func onBatchMarkMessagesRead(in sessions: [NIMSession]) {
    for s in sessions {
      if let recentSession = NIMSDK.shared().conversationManager.recentSession(by: s) {
        notifyEvent(
          ServiceType.MessageService.rawValue,
          "onSessionUpdate",
          ["data": [recentSession.toDic() as Any]]
        )
      }
    }
  }

  func onRecvMessagesDeleted(_ messages: [NIMMessage], exts: [String: String]?) {
    let messageList = messages.map { message in
      message.toDic()
    }
    notifyEvent(
      ServiceType.MessageService.rawValue,
      "onMessagesDelete",
      ["messageList": messageList]
    )
  }

  func allMessagesRead() {
    notifyEvent(ServiceType.MessageService.rawValue, "allMessagesRead", nil)
  }
}
