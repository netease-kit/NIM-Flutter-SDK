// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageRevokeParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageRevokeParams {
    let attach = V2NIMMessageRevokeParams()

    if let postscript = arguments["postscript"] as? String {
      attach.postscript = postscript
    }

    if let serverExtension = arguments["serverExtension"] as? String {
      attach.serverExtension = serverExtension
    }

    if let pushContent = arguments["pushContent"] as? String {
      attach.pushContent = pushContent
    }

    if let pushPayload = arguments["pushPayload"] as? String {
      attach.pushPayload = pushPayload
    }

    if let env = arguments["env"] as? String {
      attach.env = env
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMMessageRevokeParams.postscript)] = postscript
    keyPaths[#keyPath(V2NIMMessageRevokeParams.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMMessageRevokeParams.pushContent)] = pushContent
    keyPaths[#keyPath(V2NIMMessageRevokeParams.pushPayload)] = pushPayload
    keyPaths[#keyPath(V2NIMMessageRevokeParams.env)] = env
    return keyPaths
  }
}
