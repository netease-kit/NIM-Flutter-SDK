// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMUpdateLocalMessageParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMUpdateLocalMessageParams {
    let params = V2NIMUpdateLocalMessageParams()

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

    if let localExtension = paramsDic["localExtension"] as? String {
      params.localExtension = localExtension
    }

    if let sendingStateInt = paramsDic["sendingState"] as? Int,
       let sendingState = V2NIMMessageSendingState(rawValue: sendingStateInt) {
      params.sendingState = sendingState
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
    keyPaths[#keyPath(localExtension)] = localExtension
    keyPaths[#keyPath(sendingState)] = sendingState.rawValue
    return keyPaths
  }
}
