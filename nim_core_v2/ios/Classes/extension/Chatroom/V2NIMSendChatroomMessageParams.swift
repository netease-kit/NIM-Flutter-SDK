// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSendChatroomMessageParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSendChatroomMessageParams {
    let params = V2NIMSendChatroomMessageParams()

    if let messageConfig = arguments["messageConfig"] as? [String: Any] {
      params.messageConfig = V2NIMChatroomMessageConfig.fromDic(messageConfig)
    }

    if let routeConfig = arguments["routeConfig"] as? [String: Any] {
      params.routeConfig = V2NIMMessageRouteConfig.fromDic(routeConfig)
    }

    if let antispamConfig = arguments["antispamConfig"] as? [String: Any] {
      params.antispamConfig = V2NIMMessageAntispamConfig.fromDic(antispamConfig)
    }

    if let clientAntispamEnabled = arguments["clientAntispamEnabled"] as? Bool {
      params.clientAntispamEnabled = clientAntispamEnabled
    }

    if let clientAntispamReplace = arguments["clientAntispamReplace"] as? String {
      params.clientAntispamReplace = clientAntispamReplace
    }

    if let receiverIds = arguments["receiverIds"] as? [String] {
      params.receiverIds = receiverIds
    }

    if let notifyTargetTags = arguments["notifyTargetTags"] as? String {
      params.notifyTargetTags = notifyTargetTags
    }

    if let locationInfo = arguments["locationInfo"] as? [String: Any] {
      params.locationInfo = V2NIMLocationInfo.fromDic(locationInfo)
    }

    return params
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(messageConfig)] = messageConfig?.toDic()
    keyPaths[#keyPath(routeConfig)] = routeConfig?.toDic()
    keyPaths[#keyPath(antispamConfig)] = antispamConfig?.toDic()
    keyPaths[#keyPath(clientAntispamEnabled)] = clientAntispamEnabled
    keyPaths[#keyPath(clientAntispamReplace)] = clientAntispamReplace
    keyPaths[#keyPath(receiverIds)] = receiverIds
    keyPaths[#keyPath(notifyTargetTags)] = notifyTargetTags
    keyPaths[#keyPath(locationInfo)] = locationInfo
    return keyPaths
  }
}
