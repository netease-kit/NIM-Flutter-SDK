// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMAIRAGInfo {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMAIRAGInfo {
    let info = V2NIMAIRAGInfo()

    if let name = arguments["name"] as? String {
      info.name = name
    }

    if let icon = arguments["icon"] as? String {
      info.icon = icon
    }

    if let description = arguments["description"] as? String {
      info.desc = description
    }

    if let title = arguments["title"] as? String {
      info.title = title
    }

    if let url = arguments["url"] as? String {
      info.url = url
    }

    if let time = arguments["time"] as? Int {
      info.time = TimeInterval(time / 1000)
    }

    return info
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMAIRAGInfo.name)] = name
    keyPaths[#keyPath(V2NIMAIRAGInfo.icon)] = icon
    keyPaths[#keyPath(V2NIMAIRAGInfo.description)] = description
    keyPaths[#keyPath(V2NIMAIRAGInfo.title)] = title
    keyPaths[#keyPath(V2NIMAIRAGInfo.time)] = time * 1000
    keyPaths[#keyPath(V2NIMAIRAGInfo.url)] = url
    return keyPaths
  }
}
