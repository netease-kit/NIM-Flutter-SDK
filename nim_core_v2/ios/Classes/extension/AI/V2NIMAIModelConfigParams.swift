// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMAIModelConfigParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMAIModelConfigParams {
    let attach = V2NIMAIModelConfigParams()

    if let prompt = arguments["prompt"] as? String {
      attach.prompt = prompt
    }

    if let maxTokens = arguments["maxTokens"] as? Int {
      attach.maxTokens = maxTokens
    }

    if let topP = arguments["topP"] as? CGFloat {
      attach.topP = topP
    }

    if let temperature = arguments["temperature"] as? CGFloat {
      attach.temperature = temperature
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMAIModelConfigParams.prompt)] = prompt
    keyPaths[#keyPath(V2NIMAIModelConfigParams.maxTokens)] = maxTokens
    keyPaths[#keyPath(V2NIMAIModelConfigParams.topP)] = topP
    keyPaths[#keyPath(V2NIMAIModelConfigParams.temperature)] = temperature
    return keyPaths
  }
}
