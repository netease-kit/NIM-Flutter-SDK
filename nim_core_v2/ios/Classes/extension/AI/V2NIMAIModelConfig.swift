// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMAIModelConfig {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMAIModelConfig.model)] = model
    keyPaths[#keyPath(V2NIMAIModelConfig.prompt)] = prompt
    keyPaths[#keyPath(V2NIMAIModelConfig.promptKeys)] = promptKeys
    keyPaths[#keyPath(V2NIMAIModelConfig.maxTokens)] = maxTokens
    keyPaths[#keyPath(V2NIMAIModelConfig.temperature)] = temperature
    keyPaths[#keyPath(V2NIMAIModelConfig.topP)] = topP
    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMAIModelConfig {
    let config = V2NIMAIModelConfig()
    if let model = arguments[#keyPath(V2NIMAIModelConfig.model)] as? String {
      config.model = model
    }
    if let prompt = arguments[#keyPath(V2NIMAIModelConfig.prompt)] as? String {
      config.prompt = prompt
    }
    if let promptKeys = arguments[#keyPath(V2NIMAIModelConfig.promptKeys)] as? [String] {
      config.promptKeys = promptKeys
    }
    if let maxTokens = arguments[#keyPath(V2NIMAIModelConfig.maxTokens)] as? Int {
      config.maxTokens = maxTokens
    }
    if let temperature = arguments[#keyPath(V2NIMAIModelConfig.temperature)] as? CGFloat {
      config.temperature = temperature
    }
    if let topP = arguments[#keyPath(V2NIMAIModelConfig.topP)] as? CGFloat {
      config.topP = topP
    }
    return config
  }
}
