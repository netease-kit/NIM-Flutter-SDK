// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension NIMSDKOption {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    let keyPaths = getKeyPaths(self)
    return keyPaths
  }
}

extension NIMServerSetting {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    let keyPaths = getKeyPaths(self)
    return keyPaths
  }
}

extension NIMSDKConfig {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = getKeyPaths(self)
    keyPaths[#keyPath(fetchAttachmentAutomaticallyAfterReceiving)] =
      "enablePreloadMessageAttachment"
    keyPaths[#keyPath(exceptionOptimizationEnabled)] = "enableReportLogAutomatically"
    keyPaths[#keyPath(customTag)] = "loginCustomTag"
    keyPaths[#keyPath(fetchAttachmentAutomaticallyAfterReceivingInChatroom)] =
      "enableFetchAttachmentAutomaticallyAfterReceivingInChatroom"
    keyPaths[#keyPath(fileProtectionNone)] = "enableFileProtectionNone"
    keyPaths[#keyPath(shouldCountTeamNotification)] = "shouldTeamNotificationMessageMarkUnread"
    keyPaths[#keyPath(animatedImageThumbnailEnabled)] = "enableAnimatedImageThumbnail"
    keyPaths[#keyPath(reconnectInBackgroundStateDisabled)] = "disableReconnectInBackgroundState"
    keyPaths[#keyPath(teamReceiptEnabled)] = "enableTeamReceipt"
    keyPaths[#keyPath(fileQuickTransferEnabled)] = "enableFileQuickTransfer"
    keyPaths[#keyPath(exceptionOptimizationEnabled)] = "enableReportLogAutomatically"
    keyPaths[#keyPath(asyncLoadRecentSessionEnabled)] = "enableAsyncLoadRecentSession"
    keyPaths.removeValue(forKey: #keyPath(NIMSDKConfig.delegate))
    return keyPaths
  }
}

extension NIMLoginClient: NimDataConvertProtrol {
  @objc static func modelPropertyBlacklist() -> [String] {
    [#keyPath(NIMLoginClient.type), #keyPath(NIMLoginClient.timestamp)]
  }

  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      let logintime = Int(timestamp * 1000)
      jsonObject["loginTime"] = logintime
      if let clientType = FLT_NIMLoginClientType.convertClientType(type)?.rawValue {
        jsonObject["clientType"] = clientType
      }

      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMLoginClient.yx_model(with: json) {
      if let loginTime = json["loginTime"] as? Int {
        model.setValue(Double(loginTime) / 1000, forKey: "_timestamp")
      }
      if let custom = json["customTag"] as? String {
        model.setValue(custom, forKey: "_customTag")
      }
      if let os = json["os"] as? String {
        model.setValue(os, forKey: "_os")
      }
      if let type = json["clientType"] as? String,
         let nimType = FLT_NIMLoginClientType(rawValue: type)?.getNIMLoginClientType() {
        model.setValue(nimType.rawValue, forKey: "_type")
      }
      return model
    }
    return nil
  }
}
