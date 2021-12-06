/*
 * Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import Foundation
import NIMSDK

extension NIMSubscribeRequest {
    @objc static func modelCustomPropertyMapper() -> [String : Any]? {
        return
            [#keyPath(NIMSubscribeRequest.type):"eventType",
             #keyPath(NIMSubscribeRequest.expiry):"expiry",
             #keyPath(NIMSubscribeRequest.syncEnabled):"syncCurrentValue",
             #keyPath(NIMSubscribeRequest.publishers):"publishers",]
    }
}

extension NIMSubscribeResult {
    @objc static func modelCustomPropertyMapper() -> [String : Any]? {
        return
            [#keyPath(NIMSubscribeResult.type):"eventType",
             #keyPath(NIMSubscribeResult.expiry):"expiry",
             #keyPath(NIMSubscribeResult.timestamp):"time",
             #keyPath(NIMSubscribeResult.publisher):"publisherAccount",]
    }
    
    func toDic() -> [String : Any]? {
        if var dic = self.yx_modelToJSONObject() as? [String : Any] {
            dic["expiry"] = Int.init(self.expiry)
            dic["time"] = Int.init(self.timestamp)
            return dic
        }
        return nil
    }
}

extension NIMSubscribeEvent {
    @objc static func modelCustomPropertyMapper() -> [String : Any]? {
        return
            [#keyPath(NIMSubscribeEvent.type):"eventType",
             #keyPath(NIMSubscribeEvent.expiry):"expiry",
             #keyPath(NIMSubscribeEvent.syncEnabled):"syncSelfEnable",
             #keyPath(NIMSubscribeEvent.eventId):"eventId",
             #keyPath(NIMSubscribeEvent.from):"publisherAccount",
             #keyPath(NIMSubscribeEvent.timestamp):"publishTime",
             #keyPath(NIMSubscribeEvent.value):"eventValue",
             #keyPath(NIMSubscribeEvent.sendToOnlineUsersOnly):"broadcastOnlineOnly",
             #keyPath(NIMSubscribeEvent.subscribeInfo):"subscribeInfo"]
    }
    
    static func createSubscribeEvent(_ args: [String : Any]) -> NIMSubscribeEvent? {
        let event = NIMSubscribeEvent.yx_model(with: args)
        // 处理readonly字段
        if let eventId = args["eventId"] {
            event?.setValue(eventId, forKeyPath: #keyPath(NIMSubscribeEvent.eventId))
        }
        if let from = args["publisherAccount"] {
            event?.setValue(from, forKeyPath: #keyPath(NIMSubscribeEvent.from))
        }
        if let timestamp = args["publishTime"] as? Int {
            event?.setValue(timestamp, forKeyPath: #keyPath(NIMSubscribeEvent.timestamp))
        }
        if let subscribeInfo = args["subscribeInfo"] {
            event?.setValue(subscribeInfo, forKeyPath: #keyPath(NIMSubscribeEvent.subscribeInfo))
        }
        return event
    }
    
    func toDic() -> [String : Any]? {
        if var dic = self.yx_modelToJSONObject() as? [String : Any] {
            dic["expiry"] = Int.init(self.expiry)
            dic["time"] = Int.init(self.timestamp)
            return dic
        }
        return nil
    }
}
