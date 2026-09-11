// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMCreateUserAIBotParams {
  static func fromDic(_ arguments: [String: Any]) -> V2NIMCreateUserAIBotParams {
    let params = V2NIMCreateUserAIBotParams()
    params.accid = arguments["accid"] as? String ?? ""
    params.name = arguments["name"] as? String ?? ""
    params.icon = arguments["icon"] as? String
    params.sign = arguments["sign"] as? String
    params.ex = arguments["ex"] as? String
    return params
  }
}

extension V2NIMUpdateUserAIBotParams {
  static func fromDic(_ arguments: [String: Any]) -> V2NIMUpdateUserAIBotParams {
    let params = V2NIMUpdateUserAIBotParams()
    params.accid = arguments["accid"] as? String ?? ""
    params.name = arguments["name"] as? String
    params.icon = arguments["icon"] as? String
    params.sign = arguments["sign"] as? String
    params.ex = arguments["ex"] as? String
    return params
  }
}

extension V2NIMDeleteUserAIBotParams {
  static func fromDic(_ arguments: [String: Any]) -> V2NIMDeleteUserAIBotParams {
    let params = V2NIMDeleteUserAIBotParams()
    params.accid = arguments["accid"] as? String ?? ""
    return params
  }
}

extension V2NIMGetUserAIBotParams {
  static func fromDic(_ arguments: [String: Any]) -> V2NIMGetUserAIBotParams {
    let params = V2NIMGetUserAIBotParams()
    params.accid = arguments["accid"] as? String ?? ""
    return params
  }
}

extension V2NIMGetUserAIBotListParams {
  static func fromDic(_ arguments: [String: Any]) -> V2NIMGetUserAIBotListParams {
    let params = V2NIMGetUserAIBotListParams()
    params.pageToken = arguments["pageToken"] as? String
    if let limit = arguments["limit"] as? Int {
      params.limit = limit
    }
    return params
  }
}

extension V2NIMBindUserAIBotToQrCodeParams {
  static func fromDic(_ arguments: [String: Any]) -> V2NIMBindUserAIBotToQrCodeParams {
    let params = V2NIMBindUserAIBotToQrCodeParams()
    params.accid = arguments["accid"] as? String ?? ""
    params.token = arguments["token"] as? String ?? ""
    params.qrCode = arguments["qrCode"] as? String ?? ""
    return params
  }
}

extension V2NIMRefreshUserAIBotTokenParams {
  static func fromDic(_ arguments: [String: Any]) -> V2NIMRefreshUserAIBotTokenParams {
    let params = V2NIMRefreshUserAIBotTokenParams()
    params.accid = arguments["accid"] as? String ?? ""
    return params
  }
}

extension V2NIMUserAIBot {
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths["accid"] = accid
    keyPaths["appid"] = appid
    keyPaths["name"] = name
    keyPaths["icon"] = icon
    keyPaths["sign"] = sign
    keyPaths["gender"] = gender
    keyPaths["email"] = email
    keyPaths["birth"] = birth
    keyPaths["mobile"] = mobile
    keyPaths["ex"] = ex
    keyPaths["type"] = type
    keyPaths["modelConfig"] = modelConfigStr
    keyPaths["yunxinConfig"] = yunxinConfig
    keyPaths["validFlag"] = validFlag
    keyPaths["createTime"] = Int64(createTime)
    keyPaths["updateTime"] = Int64(updateTime)
    keyPaths["business"] = business
    keyPaths["level"] = level
    keyPaths["ownerid"] = ownerid
    keyPaths["token"] = token
    return keyPaths
  }
}

extension V2NIMCreateUserAIBotResult {
  func toDic() -> [String: Any] {
    ["token": token]
  }
}

extension V2NIMGetUserAIBotListResult {
  func toDic() -> [String: Any] {
    [
      "bots": bots.map { $0.toDic() },
      "hasMore": hasMore,
      "nextToken": nextToken as Any,
    ]
  }
}

extension V2NIMRefreshUserAIBotTokenResult {
  func toDic() -> [String: Any] {
    ["token": token]
  }
}
