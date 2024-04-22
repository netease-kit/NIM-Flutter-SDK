// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension NIMAddCollectParams {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [#keyPath(NIMAddCollectParams.ext): "ext",
     #keyPath(NIMAddCollectParams.type): "type",
     #keyPath(NIMAddCollectParams.data): "data",
     #keyPath(NIMAddCollectParams.uniqueId): "uniqueId"]
  }
}

extension NIMCollectInfo {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["createTime"] = Int(createTime * 1000)
      jsonObject["updateTime"] = Int(updateTime * 1000)
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> NIMCollectInfo? {
    let info = NIMCollectInfo.yx_model(with: json)
    if let createTime = json["createTime"] as? Int {
      info?.createTime = TimeInterval(Double(createTime) / 1000)
    }
    if let updateTime = json["updateTime"] as? Int {
      info?.updateTime = TimeInterval(Double(updateTime) / 1000)
    }
    if let data = json["data"] as? String {
      info?.data = data
    }
    if let type = json["type"] as? Int {
      info?.type = type
    }
    if let uniqueId = json["uniqueId"] as? String {
      info?.uniqueId = uniqueId
    }
    if let ext = json["ext"] as? String {
      info?.ext = ext
    }
    if let id = json["id"] as? UInt {
      info?.id = id
    }
    return info
  }
}

extension NIMCollectQueryOptions {
  static func fromDic(_ json: [String: Any]) -> NIMCollectQueryOptions {
    let options = NIMCollectQueryOptions()
    let anchor = json["anchor"] as? [String: Any]
    let toTime = json["toTime"] as? Double ?? 0
    let type = json["type"] as? Int ?? 0
    let limit = json["limit"] as? Int ?? 0
    options.toTime = TimeInterval(toTime / 1000)
    options.fromTime = 0
    options.excludeId = 0
    options.limit = limit
    if let direction = json["direction"] as? Int {
      if direction <= 0 {
        options.reverse = false
      } else {
        options.reverse = true
      }
    } else {
      options.reverse = false
    }
    if let type = json["type"] as? Int {
      options.type = type
    }
    if anchor == nil {
      options.excludeId = 0
    } else {
      options.excludeId = anchor!["id"] as? Int ?? 0
    }
    return options
  }
}

extension NIMMessagePinItem {
  static func fromDic(_ json: [String: Any]) -> NIMMessagePinItem? {
    if let mssageJson = json["message"] as? [String: Any],
       let message = NIMMessage.convertToMessage(mssageJson) {
      let pin = NIMMessagePinItem(message: message)
      pin.ext = json["ext"] as? String
      return pin
    } else {
      return nil
    }
  }

  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["sessionId"] = session.sessionId
      jsonObject["sessionType"] = FLT_NIMSessionType
        .convertFLTSessionType(session.sessionType)?.rawValue
      jsonObject["pinCreateTime"] = Int(createTime * 1000)
      jsonObject["pinUpdateTime"] = Int(updateTime * 1000)
      jsonObject["pinExt"] = ext
      jsonObject["pinOperatorAccount"] = accountID
      jsonObject["messageServerId"] = Int(messageServerID)
      jsonObject["messageUuid"] = messageId
      jsonObject["messageId"] = messageId
      jsonObject["messageTime"] = Int(messageTime * 1000)
      return jsonObject
    }
    return nil
  }
}

extension NIMQuickComment {
  static func fromDic(_ json: [String: Any]) -> NIMQuickComment {
    let model = NIMQuickComment()
    model.setValue(
      json["replyType"] as? Int ?? 0,
      forKeyPath: #keyPath(NIMQuickComment.replyType)
    )
    model.ext = json["ext"] as? String
    let setting = NIMQuickCommentSetting()
    setting.needPush = json["needPush"] as? Bool ?? false
    setting.needBadge = json["needBadge"] as? Bool ?? false
    setting.pushTitle = json["pushTitle"] as? String
    setting.pushContent = json["pushContent"] as? String
    setting.pushPayload = json["pushPayload"] as? [String: Any]
    model.setting = setting
    if let msg = json["msg"] as? [String: Any] {
      model.setValue(
        NIMMessage.convertToMessage(msg),
        forKeyPath: #keyPath(NIMQuickComment.message)
      )
    }
    return model
  }

  func toDic() -> [String: Any] {
    var jsonObject = [String: Any]()
    jsonObject["fromAccount"] = from
    jsonObject["replyType"] = replyType
    jsonObject["time"] = Int(timestamp)
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
  func toDic() -> [String: Any] {
    var jsonObject = [String: Any]()
    jsonObject["sessionId"] = session.sessionId
    jsonObject["sessionType"] = FLT_NIMSessionType.convertFLTSessionType(session.sessionType)?
      .rawValue
    jsonObject["updateTime"] = Int(updateTime * 1000)
    jsonObject["createTime"] = Int(createTime * 1000)
    jsonObject["ext"] = ext
    return jsonObject
  }

  static func fromDic(_ json: [String: Any]) -> NIMStickTopSessionInfo {
    let info = NIMStickTopSessionInfo()
    if let sessionId = json["sessionId"] as? String,
       let sessionTypeValue = json["sessionType"] as? String,
       let sessionType = try? NIMSessionType.getType(sessionTypeValue) {
      let session = NIMSession(sessionId, type: sessionType)
      info.session = session
    }
    if let ext = json["ext"] as? String {
      info.ext = ext
    }

    if let createTime = json["createTime"] as? Int {
      info.createTime = TimeInterval(createTime / 1000)
    }

    if let updateTime = json["updateTime"] as? Int {
      info.updateTime = TimeInterval(updateTime / 1000)
    }

    return info
  }
}

extension NIMThreadTalkFetchOption {
  static func fromDic(_ json: [String: Any]) -> NIMThreadTalkFetchOption {
    guard let model = NIMThreadTalkFetchOption.yx_model(with: json) else {
      print("❌NIMThreadTalkFetchOption.yx_model(with: json) FAILED")
      return NIMThreadTalkFetchOption()
    }
    if let fromTime = json["fromTime"] as? Double {
      model.start = TimeInterval(fromTime / 1000)
    }
    if let toTime = json["toTime"] as? Double {
      model.end = TimeInterval(toTime / 1000)
    }
    if let persist = json["persist"] as? Bool {
      model.sync = persist
    }
    if let direction = json["direction"] as? Int {
      model.reverse = direction <= 0
    }
    return model
  }
}

extension NIMThreadTalkFetchResult {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["thread"] = message.toDic()
      jsonObject["time"] = Int(timestamp * 1000)
      var replyList: [[String: Any]] = []
      for subMsg in subMessages {
        if let msg = subMsg as? NIMMessage,
           let msgDic = msg.toDic() {
          replyList.append(msgDic)
        }
      }
      jsonObject["replyList"] = replyList
      return jsonObject
    }
    return nil
  }
}
