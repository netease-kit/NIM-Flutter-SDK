//
//  NIMMessageExtend.swift
//  nim_core
//
//  Created by Ginger on 2021/10/26.
//

import Foundation
import NIMSDK

extension NIMAddCollectParams {
    @objc static func modelCustomPropertyMapper() -> [String : Any]? {
        return
            [#keyPath(NIMAddCollectParams.ext):"ext",
             #keyPath(NIMAddCollectParams.type):"type",
             #keyPath(NIMAddCollectParams.data):"data",
             #keyPath(NIMAddCollectParams.uniqueId):"uniqueId",]
    }
}

extension NIMCollectInfo {
    func toDic() -> [String : Any]? {
        if var jsonObject = self.yx_modelToJSONObject() as? [String : Any]  {
            jsonObject["createTime"] = createTime
            jsonObject["updateTime"] = updateTime
            return jsonObject
        }
        return nil
    }
}

extension NIMCollectQueryOptions {
    static func fromDic(_ json: [String : Any]) -> NIMCollectQueryOptions {
        let options: NIMCollectQueryOptions = NIMCollectQueryOptions()
        let anchor = json["anchor"] as? [String : Any]
        let toTime = json["toTime"] as? Int ?? 0
        let type = json["type"] as? Int ?? 0
        let limit = json["limit"] as? Int ?? 0
        options.toTime = Double.init(toTime)
        options.fromTime = 0
        options.excludeId = 0
        options.limit = limit
        if let direction = json["direction"] as? Int {
            if direction <= 0 {
                options.reverse = true
            } else {
                options.reverse = false
            }
        }
        options.type = type
        if anchor == nil {
            options.excludeId = 0
        } else {
            options.excludeId = anchor!["id"] as? Int ?? 0
        }
        return options
    }
}

extension NIMMessagePinItem {
    static func fromDic(_ json: [String : Any]) -> NIMMessagePinItem? {
        if let mssageJson = json["message"] as? [String : Any],
           let message = NIMMessage.convertToMessage(mssageJson) {
            let pin = NIMMessagePinItem.init(message: message)
            pin.ext = json["ext"] as? String
            return pin
        } else {
            return nil
        }
    }
    
    func toDic() -> [String : Any]? {
        if var jsonObject = self.yx_modelToJSONObject() as? [String : Any]  {
            jsonObject["sessionId"] = session.sessionId
            jsonObject["sessionType"] = FLT_NIMSessionType.convertFLTSessionType(session.sessionType)?.rawValue
            jsonObject["pinCreateTime"] = Int.init(createTime)
            jsonObject["pinUpdateTime"] = Int.init(updateTime)
            jsonObject["pinExt"] = ext
            jsonObject["pinOperatorAccount"] = accountID
            jsonObject["messageServerId"] = Int.init(messageServerID)
            jsonObject["messageId"] = messageId
            return jsonObject
        }
        return nil
    }
}

extension NIMQuickComment {
    static func fromDic(_ json: [String : Any]) -> NIMQuickComment {
        let model = NIMQuickComment()
        model.setValue(json["replyType"] as? Int ?? 0, forKeyPath: #keyPath(NIMQuickComment.replyType))
        model.ext = json["ext"] as? String
        let setting = NIMQuickCommentSetting()
        setting.needPush = json["needPush"] as? Bool ?? false
        setting.needBadge = json["needBadge"] as? Bool ?? false
        setting.pushTitle = json["pushTitle"] as? String
        setting.pushContent = json["pushContent"] as? String
        setting.pushPayload = json["pushPayload"] as? [String : Any]
        model.setting = setting
        if let msg = json["msg"] as? [String : Any] {
            model.setValue(NIMMessage.convertToMessage(msg), forKeyPath: #keyPath(NIMQuickComment.message))
        }
        return model
    }
    
    func toDic() -> [String : Any] {
        var jsonObject = [String : Any]()
        jsonObject["fromAccount"] = from
        jsonObject["replyType"] = replyType
        jsonObject["time"] = Int.init(timestamp)
        jsonObject["ext"] = ext
        if setting != nil {
            jsonObject["needPush"] = setting!.needPush
            jsonObject["needBadge"] = setting!.needBadge
            jsonObject["pushTitle"] = setting!.pushTitle
            jsonObject["pushContent"] = setting!.pushContent
            jsonObject["pushPayload"] = setting!.pushPayload
        }
        return jsonObject
    }
}

extension NIMStickTopSessionInfo {
    func toDic() -> [String : Any] {
        var jsonObject = [String : Any]()
        jsonObject["sessionId"] = session.sessionId
        jsonObject["sessionType"] = FLT_NIMSessionType.convertFLTSessionType(session.sessionType)?.rawValue
        jsonObject["updateTime"] = Int.init(updateTime)
        jsonObject["createTime"] = Int.init(createTime)
        jsonObject["ext"] = ext
        return jsonObject
    }
    
    static func fromDic(_ json: [String : Any]) -> NIMStickTopSessionInfo {
        let info = NIMStickTopSessionInfo()
        if let sessionId = json["sessionId"] as? String,
           let sessionTypeValue = json["sessionType"] as? String,
           let sessionType = try? NIMSessionType.getType(sessionTypeValue) {
            let session = NIMSession.init(sessionId, type: sessionType)
            info.session = session
        }
        info.ext = json["ext"] as? String ?? ""
        let createTime = json["createTime"] as? Int ?? 0
        info.createTime = Double.init(createTime)
        let updateTime = json["updateTime"] as? Int ?? 0
        info.updateTime = Double.init(updateTime)
        return info
    }
}
