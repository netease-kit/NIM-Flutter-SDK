// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMChatroomEnterParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMChatroomEnterParams {
    let params = V2NIMChatroomEnterParams()

    if let anonymousMode = arguments["anonymousMode"] as? Bool {
      params.anonymousMode = anonymousMode
    }

    if let accountId = arguments["accountId"] as? String {
      params.accountId = accountId
    }

    if let token = arguments["token"] as? String {
      params.token = token
    }

    if let roomNick = arguments["roomNick"] as? String {
      params.roomNick = roomNick
    }

    if let roomAvatar = arguments["roomAvatar"] as? String {
      params.roomAvatar = roomAvatar
    }

    if let timeout = arguments["timeout"] as? Int {
      params.timeout = timeout
    }

    if let accountId = arguments["accountId"] as? String {
      params.accountId = accountId
    }

    //    if let loginOption = arguments["loginOption"] as? [String: Any] {
    //      params.loginOption = V2NIMChatroomLoginOption.fromDic(loginOption)
    //    }
    params.loginOption = V2NIMChatroomLoginOption.fromDic(arguments)

    if let serverExtension = arguments["serverExtension"] as? String {
      params.serverExtension = serverExtension
    }

    if let notificationExtension = arguments["notificationExtension"] as? String {
      params.notificationExtension = notificationExtension
    }

    if let tagConfig = arguments["tagConfig"] as? [String: Any] {
      params.tagConfig = V2NIMChatroomTagConfig.fromDic(tagConfig)
    }

    if let locationConfig = arguments["locationConfig"] as? [String: Any] {
      params.locationConfig = V2NIMChatroomLocationConfig.fromDic(locationConfig)
    }

    if let antispamConfig = arguments["antispamConfig"] as? [String: Any] {
      params.antispamConfig = V2NIMAntispamConfig.fromDic(antispamConfig)
    }

    return params
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(anonymousMode)] = anonymousMode
    keyPaths[#keyPath(accountId)] = accountId
    keyPaths[#keyPath(token)] = token
    keyPaths[#keyPath(roomNick)] = roomNick
    keyPaths[#keyPath(roomAvatar)] = roomAvatar
    keyPaths[#keyPath(timeout)] = timeout
    keyPaths[#keyPath(loginOption)] = loginOption.toDic()
    keyPaths[#keyPath(serverExtension)] = serverExtension
    keyPaths[#keyPath(notificationExtension)] = notificationExtension
    keyPaths[#keyPath(tagConfig)] = tagConfig?.toDic()
    keyPaths[#keyPath(locationConfig)] = locationConfig?.toDic()
    keyPaths[#keyPath(antispamConfig)] = antispamConfig?.toDic()
    return keyPaths
  }
}
