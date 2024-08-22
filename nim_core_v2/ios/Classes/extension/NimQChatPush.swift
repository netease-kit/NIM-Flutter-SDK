// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension NIMPushNotificationSetting {
  static func fromDic(_ json: [String: Any]) -> NIMPushNotificationSetting? {
    guard let model = NIMPushNotificationSetting.yx_model(with: json) else {
      print("❌NIMPushNotificationSetting.yx_model(with: json) FAILED")
      return nil
    }
    if let showNoDetail = json["isPushShowNoDetail"] as? Bool {
      model.type = showNoDetail ? .noDetail : .detail
    }
    if let isOpen = json["isNoDisturbOpen"] as? Bool {
      model.noDisturbing = isOpen
    }
    if let startTime = json["startNoDisturbTime"] as? String,
       let endTime = json["stopNoDisturbTime"] as? String {
      let startSplits = startTime.components(separatedBy: ":")
      if startSplits.count == 2 {
        if let h = UInt(startSplits[0]) {
          model.noDisturbingStartH = h
        }
        if let m = UInt(startSplits[1]) {
          model.noDisturbingStartM = m
        }
      }

      let endSplits = endTime.components(separatedBy: ":")
      if endSplits.count == 2 {
        if let h = UInt(endSplits[0]) {
          model.noDisturbingEndH = h
        }
        if let m = UInt(endSplits[1]) {
          model.noDisturbingEndM = m
        }
      }
    }
    if let pushMsgType = json["pushMsgType"] as? String,
       let profile = FLTQChatPushNotificationProfile(rawValue: pushMsgType)?
       .convertToPushNotificationProfile() {
      model.profile = profile
    }
    return model
  }

  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["isPushShowNoDetail"] = type == .noDetail
      jsonObject["isNoDisturbOpen"] = noDisturbing
      jsonObject["startNoDisturbTime"] = String(format: "%02d:%02d", noDisturbingStartH,
                                                noDisturbingStartM)
      jsonObject["stopNoDisturbTime"] = String(format: "%02d:%02d", noDisturbingEndH,
                                               noDisturbingEndM)
      if let pushMsgType = FLTQChatPushNotificationProfile.convert(type: profile)?.rawValue {
        jsonObject["pushMsgType"] = pushMsgType
      }
      return jsonObject
    }
    return nil
  }
}
