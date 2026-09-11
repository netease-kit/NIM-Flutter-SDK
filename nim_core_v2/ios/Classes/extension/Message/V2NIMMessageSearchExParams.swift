// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageSearchExParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageSearchExParams {
    let params = V2NIMMessageSearchExParams()

    if let conversationId = arguments["conversationId"] as? String {
      params.conversationId = conversationId
    }

    if let keywordList = arguments["keywordList"] as? [String] {
      params.keywordList = keywordList
    }

    if let keywordMatchTypeInt = arguments["keywordMatchType"] as? Int,
       let keywordMatchType = V2NIMSearchKeywordMathType(rawValue: keywordMatchTypeInt) {
      params.keywordMatchType = keywordMatchType
    }
    if let senderAccountIds = arguments["senderAccountIds"] as? [String] {
      params.senderAccountIds = senderAccountIds
    }

    if let messageTypesInt = arguments["messageTypes"] as? [Int] {
      params.messageTypes = messageTypesInt.map { type in
        NSNumber(value: V2NIMMessageType(rawValue: type)?.rawValue ?? V2NIMMessageType.MESSAGE_TYPE_INVALID.rawValue)
      }
    }

    if let messageSubtypesInt = arguments["messageSubtypes"] as? [Int] {
      params.messageSubtypes = messageSubtypesInt.map { type in
        NSNumber(value: type)
      }
    }

    if let limit = arguments["limit"] as? Int {
      params.limit = limit
    }

    if let searchStartTime = arguments["searchStartTime"] as? Int64 {
      params.searchStartTime = searchStartTime
    }

    if let searchTimePeriod = arguments["searchTimePeriod"] as? Int64 {
      params.searchTimePeriod = searchTimePeriod
    }

    if let pageToken = arguments["pageToken"] as? String {
      params.pageToken = pageToken
    }

    if let directionInt = arguments["direction"] as? Int,
       let direction = V2NIMSearchDirection(rawValue: directionInt) {
      params.direction = direction
    }

    if let strategyInt = arguments["strategy"] as? Int,
       let strategy = V2NIMSearchStrategy(rawValue: strategyInt) {
      params.strategy = strategy
    }

    if let onlyIndex = arguments["onlyIndex"] as? Bool {
      params.onlyIndex = onlyIndex
    }

    return params
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
//  func toDic() -> [String: Any] {
//    var keyPaths = [String: Any]()
//    keyPaths[#keyPath(conversationId)] = conversationId
//    return keyPaths
//  }
}
