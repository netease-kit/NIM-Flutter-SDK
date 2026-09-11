// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMLoginClient {
  func toDictionary() -> [String: Any?] {
    var dict: [String: Any?] = [
      "os": os,
      "type": type.rawValue,
      "timestamp": timestamp,
      "customTag": customTag,
      "clientId": clientId,
      "customClientType": customClientType,
      "clientIP": clientIp,
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

    if let clientIp = json["clientIP"] as? String {
      client.setValue(clientIp, forKey: #keyPath(V2NIMLoginClient.clientIp))
    }
    return client
  }
}
