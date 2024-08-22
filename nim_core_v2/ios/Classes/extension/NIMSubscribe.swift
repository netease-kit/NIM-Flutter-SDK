// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension NIMSubscribeRequest {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [#keyPath(NIMSubscribeRequest.type): "eventType",
     #keyPath(NIMSubscribeRequest.expiry): "expiry",
     #keyPath(NIMSubscribeRequest.syncEnabled): "syncCurrentValue",
     #keyPath(NIMSubscribeRequest.publishers): "publishers"]
  }
}

extension NIMSubscribeResult {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [#keyPath(NIMSubscribeResult.type): "eventType",
     #keyPath(NIMSubscribeResult.expiry): "expiry",
     #keyPath(NIMSubscribeResult.timestamp): "time",
     #keyPath(NIMSubscribeResult.publisher): "publisherAccount"]
  }

  func toDic() -> [String: Any]? {
    if var dic = yx_modelToJSONObject() as? [String: Any] {
      dic["expiry"] = Int(expiry)
      dic["time"] = Int(timestamp)
      return dic
    }
    return nil
  }
}

extension NIMSubscribeEvent {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [#keyPath(NIMSubscribeEvent.type): "eventType",
     #keyPath(NIMSubscribeEvent.expiry): "expiry",
     #keyPath(NIMSubscribeEvent.syncEnabled): "syncSelfEnable",
     #keyPath(NIMSubscribeEvent.eventId): "eventId",
     #keyPath(NIMSubscribeEvent.from): "publisherAccount",
     #keyPath(NIMSubscribeEvent.timestamp): "publishTime",
     #keyPath(NIMSubscribeEvent.value): "eventValue",
     #keyPath(NIMSubscribeEvent.sendToOnlineUsersOnly): "broadcastOnlineOnly",
     #keyPath(NIMSubscribeEvent.subscribeInfo): "subscribeInfo"]
  }

  static func createSubscribeEvent(_ args: [String: Any]) -> NIMSubscribeEvent? {
    let event = NIMSubscribeEvent.yx_model(with: args)
    if let eventValue = args["eventValue"] as? Int {
      event?.value = eventValue
    }
    if let eventType = args["eventType"] as? Int {
      event?.type = eventType
    }
    if let sendToOnlineUsersOnly = args["broadcastOnlineOnly"] as? Bool {
      event?.sendToOnlineUsersOnly = sendToOnlineUsersOnly
    }
    if let syncEnabled = args["syncSelfEnable"] as? Bool {
      event?.syncEnabled = syncEnabled
    }

    if let config = args["config"] as? String {
      event?.setExt(config)
    }
    if let expiry = args["expiry"] as? Int64 {
      event?.expiry = TimeInterval(expiry)
    }
    return event
  }

  func toDic() -> [String: Any]? {
    if var dic = yx_modelToJSONObject() as? [String: Any] {
      dic["expiry"] = Int(expiry)
      dic["publishTime"] = Int(timestamp * 1000)
      var muiltConfig = [String: String]()
      if let iosConfig = ext(NIMLoginClientType.typeiOS),
         iosConfig.isEmpty == false {
        muiltConfig[String(NIMLoginClientType.typeiOS.rawValue)] = iosConfig
      }
      if let aosConfig = ext(NIMLoginClientType.typeAOS),
         aosConfig.isEmpty == false {
        muiltConfig[String(NIMLoginClientType.typeAOS.rawValue)] = aosConfig
      }
      if let webCofig = ext(NIMLoginClientType.typeWeb),
         webCofig.isEmpty == false {
        muiltConfig[String(NIMLoginClientType.typeWeb.rawValue)] = webCofig
      }
      if let pcCofig = ext(NIMLoginClientType.typePC),
         pcCofig.isEmpty == false {
        muiltConfig[String(NIMLoginClientType.typePC.rawValue)] = pcCofig
      }

      if let publisherClientType = muiltConfig.first?.key as? String,
         let typeValue = Int(publisherClientType) {
        dic["publisherClientType"] = typeValue
      }

      dic["multiClientConfig"] = getJsonStringFromDictionary(muiltConfig)
      return dic
    }
    return nil
  }
}
