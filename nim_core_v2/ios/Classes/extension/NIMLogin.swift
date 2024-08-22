// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMLoginOption {
  static func fromDic(_ json: [String: Any?]) ->
    V2NIMLoginOption {
    let option = V2NIMLoginOption()
    if let typeInt = json["authType"] as? Int,
       let type = V2NIMLoginAuthType(rawValue: typeInt) {
      option.authType = type
    }

    if let syncLevelInt = json["syncLevel"] as? Int,
       let syncLevel = V2NIMDataSyncLevel(rawValue: syncLevelInt) {
      option.syncLevel = syncLevel
    }

    if let retryCount = json["retryCount"] as? Int {
      option.retryCount = retryCount
    }

    if let timeout = json["timeout"] as? Int {
      option.timeout = timeout
    }

    if let forceMode = json["forceMode"] as? Bool {
      option.forceMode = forceMode
    }
    return option
  }
}

extension V2NIMLoginClient {
  func toDictionary() -> [String: Any?] {
    var dict: [String: Any?] = [
      "os": os,
      "type": type.rawValue,
      "timestamp": timestamp,
      "customTag": customTag,
      "clientId": clientId,
      "customClientType": customClientType,
    ]
    return dict
  }

  static func fromDic(_ json: [String: Any?]) -> V2NIMLoginClient {
    let client = V2NIMLoginClient()
    if let os = json["os"] as? String {
      client.setValue(os, forKey: #keyPath(V2NIMLoginClient.os))
    }

    if let typeInt = json["type"] as? Int {
      client.setValue(NSNumber(integerLiteral: typeInt), forKey: #keyPath(V2NIMLoginClient.type))
    }

    if let timestamp = json["timestamp"] as? Int64 {
      let time = Double(integerLiteral: timestamp) / 1000
      client.setValue(timestamp, forKey: #keyPath(V2NIMLoginClient.timestamp))
    }

    if let customTag = json["customTag"] as? String {
      client.setValue(customTag, forKey: #keyPath(V2NIMLoginClient.customTag))
    }

    if let clientId = json["clientId"] as? String {
      client.setValue(clientId, forKey: #keyPath(V2NIMLoginClient.clientId))
    }

    if let customClientType = json["customClientType"] as? String {
      client.setValue(customClientType, forKey: #keyPath(V2NIMLoginClient.customClientType))
    }
    return client
  }
}

extension V2NIMKickedOfflineDetail {
  func toDictionary() -> [String: Any?] {
    var dict: [String: Any?] = [
      "reason": reason.rawValue,
      "clientType": clientType.rawValue,
      "customClientType": customClientType,
      "reasonDesc": reasonDesc,
    ]
    return dict
  }

  static func fromDic(_ json: [String: Any?]) -> V2NIMKickedOfflineDetail {
    let detail = V2NIMKickedOfflineDetail()
    if let reasonInt = json["reason"] as? Int,
       let reason = V2NIMKickedOfflineReason(rawValue: reasonInt) {
      detail.setValue(reason, forKey: #keyPath(V2NIMKickedOfflineDetail.reason))
    }
    if let clientTypeInt = json["clientType"] as? Int,
       let clientType = V2NIMLoginClientType(rawValue: clientTypeInt) {
      detail.setValue(clientType, forKey: #keyPath(V2NIMKickedOfflineDetail.clientType))
    }

    if let customClientType = json["customClientType"] as? Int {
      detail.setValue(customClientType, forKey: #keyPath(V2NIMKickedOfflineDetail.customClientType))
    }

    if let reasonDesc = json["reasonDesc"] as? String {
      detail.setValue(reasonDesc, forKey: #keyPath(V2NIMKickedOfflineDetail.reasonDesc))
      return detail
    }
    return detail
  }
}

// TODO: ios no error
extension V2NIMDataSyncDetail {
  func toDictionary() -> [String: Any?] {
    var dict: [String: Any?] = [
      "type": type.rawValue,
      "state": state.rawValue,
    ]
    return dict
  }

  static func fromDic(_ json: [String: Any?]) -> V2NIMDataSyncDetail {
    let detail = V2NIMDataSyncDetail()
    if let typeInt = json["type"] as? Int,
       let type = V2NIMDataSyncType(rawValue: typeInt) {
      detail.setValue(type, forKey: #keyPath(V2NIMDataSyncDetail.type))
    }
    if let stateInt = json["state"] as? Int,
       let state = V2NIMDataSyncState(rawValue: stateInt) {
      detail.setValue(state, forKey: #keyPath(V2NIMDataSyncDetail.state))
    }
    return detail
  }
}
