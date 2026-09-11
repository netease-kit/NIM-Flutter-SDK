// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMModifyMessageParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMModifyMessageParams {
    let params = V2NIMModifyMessageParams()

    guard let paramsDic = arguments["params"] as? [String: Any],
          let messageDic = arguments["message"] as? [String: Any] else {
      return params
    }

    if let subType = paramsDic["subType"] as? Int {
      params.subType = subType
    }

    if let text = paramsDic["text"] as? String {
      params.text = text
    }

    if let attachment = paramsDic["attachment"] as? [String: Any] {
      params.attachment = V2NIMMessageAttachment.fromDic(attachment)

      if let type = messageDic["messageType"] as? Int,
         let messageType = V2NIMMessageType(rawValue: type) {
        switch messageType {
        case .MESSAGE_TYPE_AUDIO:
          params.attachment = V2NIMMessageAudioAttachment.fromDictionary(attachment)
        case .MESSAGE_TYPE_FILE:
          params.attachment = V2NIMMessageFileAttachment.fromDict(attachment)
        case .MESSAGE_TYPE_IMAGE:
          params.attachment = V2NIMMessageImageAttachment.fromDictionary(attachment)
        case .MESSAGE_TYPE_VIDEO:
          params.attachment = V2NIMMessageVideoAttachment.fromDictionary(attachment)
        case .MESSAGE_TYPE_LOCATION:
          params.attachment = V2NIMMessageLocationAttachment.fromDict(attachment)
        case .MESSAGE_TYPE_NOTIFICATION:
          params.attachment = V2NIMMessageNotificationAttachment.fromDict(attachment)
        case .MESSAGE_TYPE_CALL:
          params.attachment = V2NIMMessageCallAttachment.fromDict(attachment)
        default:
          params.attachment = V2NIMMessageAttachment.fromDic(attachment)
        }
      }
    }

    if let serverExtension = paramsDic["serverExtension"] as? String {
      params.serverExtension = serverExtension
    }

    if let antispamConfig = paramsDic["antispamConfig"] as? [String: Any] {
      params.antispamConfig = V2NIMMessageAntispamConfig.fromDic(antispamConfig)
    }

    if let routeConfig = paramsDic["routeConfig"] as? [String: Any] {
      params.routeConfig = V2NIMMessageRouteConfig.fromDic(routeConfig)
    }

    if let pushConfig = paramsDic["pushConfig"] as? [String: Any] {
      params.pushConfig = V2NIMMessagePushConfig.fromDic(pushConfig)
    }

    if let clientAntispamEnabled = paramsDic["clientAntispamEnabled"] as? Bool {
      params.clientAntispamEnabled = clientAntispamEnabled
    }

    if let clientAntispamReplace = paramsDic["clientAntispamReplace"] as? String {
      params.clientAntispamReplace = clientAntispamReplace
    }

    return params
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(subType)] = subType
    keyPaths[#keyPath(text)] = text
    keyPaths[#keyPath(attachment)] = attachment?.toDic()
    keyPaths[#keyPath(serverExtension)] = serverExtension
    keyPaths[#keyPath(antispamConfig)] = antispamConfig?.toDic()
    keyPaths[#keyPath(routeConfig)] = routeConfig?.toDic()
    keyPaths[#keyPath(pushConfig)] = pushConfig?.toDic()
    keyPaths[#keyPath(clientAntispamEnabled)] = clientAntispamEnabled
    keyPaths[#keyPath(clientAntispamReplace)] = clientAntispamReplace
    return keyPaths
  }
}
