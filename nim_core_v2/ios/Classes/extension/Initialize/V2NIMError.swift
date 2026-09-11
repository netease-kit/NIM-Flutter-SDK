// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMError {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMError {
    let info = V2NIMError()

    if let source = arguments["source"] as? Int,
       let source = V2NIMErrorSource(rawValue: source) {
      info.setValue(source.rawValue,
                    forKeyPath: #keyPath(V2NIMError.source))
    }

    if let code = arguments["code"] as? Int {
      info.setValue(code,
                    forKeyPath: #keyPath(V2NIMError.code))
    }

    if let desc = arguments["desc"] as? String {
      info.setValue(desc,
                    forKeyPath: #keyPath(V2NIMError.desc))
    }

    if let detail = arguments["detail"] as? [String: Any] {
      info.setValue(detail,
                    forKeyPath: #keyPath(V2NIMError.detail))
    }

    return info
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(source)] = source.rawValue
    keyPaths[#keyPath(code)] = code
    keyPaths[#keyPath(desc)] = desc
    keyPaths[#keyPath(detail)] = detail
    return keyPaths
  }
}
