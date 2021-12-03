/*
 * Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import Foundation
import NIMSDK

enum SessionType: String {
    case SessionCreate = "createSession"
    case SessionRecentList = "querySessionList"
    case SessionCustomRecentList = "querySessionListFiltered"
    case SessionspecifySession = "querySession" //获取指定最近会话
    case SessionUpdate = "updateSession"
    case UpdateSessionWithMessage = "updateSessionWithMessage"
    case SessionUnreadCount = "queryTotalUnreadCount"
    case SessionMarkRead = "clearSessionUnreadCount" //标记已读
    case SessionSyncUnreadCount = "syncUnreadCount" //未读数多端同步
    case SessionDeleteRecent = "deleteSession"
    case SetChattingAccount = "setChattingAccount"
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
        return ServiceType.SessionService.rawValue
    }
    
    func onMethodCalled(_ method: String, _ arguments: [String : Any], _ resultCallback: ResultCallback) {
        
        switch method {
        case SessionType.SessionCreate.rawValue: createSession(arguments, resultCallback)
        case SessionType.SessionRecentList.rawValue: getRecentList(arguments, resultCallback)
        case SessionType.SessionCustomRecentList.rawValue: getCustomRecentList(arguments, resultCallback)
        case SessionType.SessionspecifySession.rawValue: getSpecifySession(arguments, resultCallback)
        case SessionType.SessionUpdate.rawValue: updateSession(arguments, resultCallback)
        case SessionType.UpdateSessionWithMessage.rawValue: updateSessionWithMessage(arguments, resultCallback)
        case SessionType.SessionUnreadCount.rawValue: unreadCount(arguments, resultCallback)
        case SessionType.SessionMarkRead.rawValue: markRead(arguments, resultCallback)
        case SessionType.SessionDeleteRecent.rawValue: deleteRecent(arguments, resultCallback)
        default:
            break
        }
    }
    
    func register(_ nimCore: NimCore) {
        self.nimCore = nimCore
        nimCore.addService(self)
    }
    
    private func createSessionFaile(_ resultCallback: ResultCallback) {
        resultCallback.result((NimResult.error("service name : \(serviceName())  msg : create session failed").toDic()))
    }
    
    // MARK: - SDK API
    
    private func createSession(_ argument:[String : Any], _ resultCallback: ResultCallback){
        if let session = convertSession(argument){
            let option = NIMAddEmptyRecentSessionBySessionOption()
            if let linkToLastMessage = argument["linkToLastMessage"] as? Bool {
                option.withLastMsg = linkToLastMessage
            }
            NIMSDK.shared().conversationManager.addEmptyRecentSession(by: session, option: option)
            resultCallback.result(NimResult.success().toDic())
        }else {
            createSessionFaile(resultCallback)
        }
    }
    
    private func getRecentList(_ argument:[String : Any], _ resultCallback: ResultCallback) {
        
        let array = NIMSDK.shared().conversationManager.allRecentSessions()
        let ret = array?.map({ recentSession in
            recentSession.toDic()
        })
        
        var data = [[String: Any]]()
        array?.forEach({ session in
            if let dic = session.toDic() {
                data.append(dic)
            }
        })
        
        resultCallback.result(NimResult.success(["resultList": ret]).toDic())
    }
    
    private func getCustomRecentList(_ argument:[String : Any], _ resultCallback: ResultCallback) {
        if let filterMessageTypeList = argument["filterMessageTypeList"] as? [String] {
            let option = NIMRecentSessionOption()
            
            var filters = [NSNumber]()
            filterMessageTypeList.forEach { string in
                if let flt_type = FLT_NIMMessageType(rawValue: string),
                   let type = flt_type.convertToNIMMessageType()?.rawValue{
                    filters.append(NSNumber(value: type))
                }
            }
            option.filterLastMessageTypes = filters
            let array = NIMSDK.shared().conversationManager.allRecentSessions(with: option)
            let ret = array?.map({ recentSession in
                recentSession.toDic()
            })
            resultCallback.result(["resultList": ret])
        }else {
            resultCallback.result(NimResult.error("filter parameter miss").toDic())
        }
    }
    
    private func getSpecifySession(_ argument:[String : Any], _ resultCallback: ResultCallback) {
        if let session = convertSession(argument) {
            let recentSession = NIMSDK.shared().conversationManager.recentSession(by: session)
            resultCallback.result(NimResult.success(recentSession?.toDic()))
        }else {
            createSessionFaile(resultCallback)
        }
    }
    
    private func updateSession(_ argument:[String : Any], _ resultCallback: ResultCallback){
        if let data = argument["session"] as? [String : Any],
           let session = convertSession(data),
           let  extensionDic = argument["extension"] as? [String: Any]{
            if let recent = NIMSDK.shared().conversationManager.recentSession(by: session) {
                NIMSDK.shared().conversationManager.updateRecentLocalExt(extensionDic, recentSession: recent)
                successCallBack(resultCallback, nil)
            }else {
                resultCallback.result(NimResult.error("sessionId: \(session.sessionId) sessiontype: \(session.sessionType) not find").toDic())
            }
        }else {
            createSessionFaile(resultCallback)
        }
    }
    
    private func updateSessionWithMessage(_ argument:[String : Any], _ resultCallback: ResultCallback){
        if let data = argument["message"] as? [String: Any],
           let message = NIMMessage.convertToMessage(data),
           let session = convertSession(data){
            
            NIMSDK.shared().conversationManager.update(message, for: session) { error in
                if let ns_error = error as NSError? {
                    resultCallback.result(NimResult(nil, NSNumber(value: ns_error.code), ns_error.description).toDic())
                }else {
                    resultCallback.result(NimResult.success().toDic())
                }
            }
        }
    }
    
    
    private func markRead(_ argument:[String : Any], _ resultCallback: ResultCallback){
        if let requestList = argument["requestList"] as? [[String : Any]] {
            var  sessions = [NIMSession]()
            weak var weakSelf = self
            requestList.forEach { request in
                if let session = weakSelf?.convertSession(request) {
                    sessions.append(session)
                }
            }
            NIMSDK.shared().conversationManager.batchMarkMessagesRead(in: sessions) { error, retSessions in
                let ret = retSessions?.map({ session in
                    session.yx_modelToJSONObject()
                })
                if let ns_error = error as NSError? {
                    resultCallback.result(NimResult.error(ns_error.code, ns_error.description).toDic())
                }else {
                    resultCallback.result(NimResult.success(["failList": ret]).toDic())
                }
            }
        }else {
            createSessionFaile(resultCallback)
        }
    }
    
    private func unreadCount(_ argument:[String : Any], _ resultCallback: ResultCallback){
        let count =  NIMSDK.shared().conversationManager.allUnreadCount()
        resultCallback.result(NimResult.success(["count": count]).toDic())
    }
    
    private func deleteRecent(_ argument:[String : Any], _ resultCallback: ResultCallback){
        
        if let data = argument["sessionInfo"] as? [String: Any],
           let session = convertSession(data),
           let deleteType = argument["deleteType"], let sendAck = argument["sendAck"] as? Bool{
            let option = NIMDeleteRecentSessionOption()
            option.shouldMarkAllMessagesReadInSessions = sendAck
            weak var weakSelf = self
            switch deleteType {
            case NIMSessionDeleteType.local:
                if let recent = NIMSDK.shared().conversationManager.recentSession(by: session){
                    NIMSDK.shared().conversationManager.delete(recent, option: option) { error in
                        if let ns_error = error as NSError? {
                            resultCallback.result(NimResult.error(ns_error.code, ns_error.description).toDic())
                        }else {
                            weakSelf?.successCallBack(resultCallback, nil)
                        }
                    }
                }else {
                    resultCallback.result(NimResult.error("don't find session").toDic())
                }
                
                break
            case NIMSessionDeleteType.remote:
                NIMSDK.shared().conversationManager.deleteRemoteSessions([session]) { error in
                    if let ns_error = error as NSError? {
                        resultCallback.result(NimResult.error(ns_error.code, ns_error.description).toDic())
                    }else {
                        weakSelf?.successCallBack(resultCallback, nil)
                    }
                }
                break
            case NIMSessionDeleteType.localAndRemote:
                if let recent = NIMSDK.shared().conversationManager.recentSession(by: session){
                    option.isDeleteRoamMessage = true
                    NIMSDK.shared().conversationManager.delete(recent, option: option) { error in
                        if let ns_error = error as NSError? {
                            resultCallback.result(NimResult.error(ns_error.code, ns_error.description).toDic())
                        }else {
                            weakSelf?.successCallBack(resultCallback, nil)
                        }
                    }
                }else {
                    resultCallback.result(NimResult.error("don't find session").toDic())
                }
                break
            default:
                break
            }
        }else {
            createSessionFaile(resultCallback)
        }
    }
    
    private func deleteRemote(_ argument:[String : Any],  _ resultCallback: ResultCallback){
        if let sessionList = argument["sessionList"], let sessions = NSArray.yx_modelArray(with: NIMSession.self, json: sessionList) as? [NIMSession] {
            weak var weakSelf = self
            NIMSDK.shared().conversationManager.deleteRemoteSessions(sessions) { error in
                if let ns_error = error as NSError? {
                    resultCallback.result(NimResult.error(ns_error.code, ns_error.description).toDic())
                }else {
                    weakSelf?.successCallBack(resultCallback, nil)
                }
            }
        }else {
            errorCallBack(resultCallback, "解析sessionList失败")
        }
        
    }
    
    // MARK: - Other
    
    private func convertSession(_ arguments: [String : Any]) -> NIMSession? {
        if let sessionId = arguments["sessionId"] as? String,
           let sessionTypeValue = arguments["sessionType"] as? String,
           let sessionType = try? NIMSessionType.getType(sessionTypeValue) {
            return NIMSession(sessionId, type: sessionType)
        }
        return nil
    }
}

extension FLTSessionService: NIMConversationManagerDelegate {
    
    func didUpdate(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        notifyEvent(ServiceType.MessageService.rawValue, "onSessionUpdate",["data":[recentSession.toDic() as Any]])
    }
    
    func didAdd(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        
    }
    
    func didRemove(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        notifyEvent(ServiceType.MessageService.rawValue, "onSessionDelete", recentSession.toDic())
    }
}
