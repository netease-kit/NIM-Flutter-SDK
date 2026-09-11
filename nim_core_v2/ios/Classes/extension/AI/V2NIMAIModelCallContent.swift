// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMAIModelCallContent {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMAIModelCallContent {
    let attach = V2NIMAIModelCallContent()

    if let msg = arguments["msg"] as? String {
      attach.msg = msg
    }

    attach.type = .NIM_AI_MODEL_CONTENT_TYPE_TEXT
    if let type = arguments["type"] as? Int,
       let contentType = V2NIMAIModelCallContentType(rawValue: type) {
      attach.type = contentType
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMAIModelCallContent.msg)] = msg
    keyPaths[#keyPath(V2NIMAIModelCallContent.type)] = type.rawValue
    return keyPaths
  }
}
