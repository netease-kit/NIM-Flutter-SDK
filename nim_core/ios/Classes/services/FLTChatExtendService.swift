/*
 * Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import Foundation
import NIMSDK
enum ChatExtendType: String {
    case ReplyMessage = "replyMessage" //回复一条
    case SubMessagesCount = "queryReplyCountInThreadTalkBlock"
    case FetchSubMessages = "queryThreadTalkHistory"
}

class FLTChatExtendService: FLTBaseService, FLTService {
    
    func serviceName() -> String {
        ServiceType.ChatExtendService.rawValue
    }
    
    func onMethodCalled(_ method: String, _ arguments: [String : Any], _ resultCallback: ResultCallback) {
        switch method {
        case ChatExtendType.ReplyMessage.rawValue:
            reply(arguments, resultCallback)
        case ChatExtendType.SubMessagesCount.rawValue:
            subMessageCount(arguments, resultCallback)
        case ChatExtendType.FetchSubMessages.rawValue:
            fetchSubMessages(arguments, resultCallback)
        default:
            break
        }
    }
    
    func register(_ nimCore: NimCore) {
        self.nimCore = nimCore
        nimCore.addService(self)
    }
    
    private func reply(_ arguments: [String: Any], _ resultCallback: ResultCallback){
        if let messageDic = arguments["message"] as? [String: Any],
           let replyMsg = arguments["replyMsg"] as? [String: Any],
           let message = NIMMessage.convertToMessage(messageDic),
           let replyMessage = NIMMessage.convertToMessage(replyMsg){
            weak var weakSelf = self
            NIMSDK.shared().chatExtendManager.reply(message, to: replyMessage) { error in
                if let ns_error = error as NSError? {
                    resultCallback.result(NimResult.error(ns_error.code, ns_error.description).toDic())
                }else {
                    weakSelf?.successCallBack(resultCallback, nil)
                }
            }
        }else {
            errorCallBack(resultCallback, "init message failed")
        }
    }
    
    private func subMessageCount(_ arguments: [String: Any],  _ resultCallback: ResultCallback){
        if let messageDic = arguments["message"] as? [String: Any],
           let message = NIMMessage.convertToMessage(messageDic) {
            let count = NIMSDK.shared().chatExtendManager.subMessagesCount(message)
            resultCallback.result(NimResult.success(count).toDic())
        }else {
            errorCallBack(resultCallback, "init message failed")
        }
    }
    
    private func fetchSubMessages(_ arguments: [String: Any],  _ resultCallback: ResultCallback){
        if let messageDic = arguments["message"] as? [String: Any],
           let message = NIMMessage.convertToMessage(messageDic){
            
            let fromTime = arguments["fromTime"] as? TimeInterval ?? 0
            let toTime = arguments["toTime"] as? TimeInterval ?? 0
            let  limit = arguments["limit"] as? UInt ?? 0
            let  persist = arguments["persist"] as? Bool ?? false
            let option = NIMThreadTalkFetchOption()
            option.start = fromTime
            option.end = toTime
            option.limit = limit
            if let direction = arguments["direction"] as? Int {
                if direction <= 0 {
                    option.reverse = true
                }else {
                    option.reverse = false
                }
            }
            option.sync = persist
            
            weak var weakSelf = self
            NIMSDK.shared().chatExtendManager.fetchSubMessages(from: message, option: option) { error, result in
                if let ns_error = error as NSError? {
                    resultCallback.result(NimResult.error(ns_error.code, ns_error.description).toDic())
                }else {
                    weakSelf?.successCallBack(resultCallback, result)
                }
            }
        }
    }
    
}
