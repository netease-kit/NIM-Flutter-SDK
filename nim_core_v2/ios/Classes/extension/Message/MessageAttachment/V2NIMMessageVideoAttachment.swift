// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageVideoAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDictionary(_ arguments: [String: Any]) -> V2NIMMessageVideoAttachment {
    let superAttach = super.fromDict(arguments)
    let attach = V2NIMMessageVideoAttachment()
    attach.raw = superAttach.raw
    attach.path = superAttach.path
    attach.size = superAttach.size
    attach.md5 = superAttach.md5
    attach.ext = superAttach.ext
    attach.name = superAttach.name
    attach.sceneName = superAttach.sceneName
    attach.uploadState = superAttach.uploadState

    if let path = arguments["path"] as? String {
      attach.setValue(path, forKey: "_filePath")
    }

    if let name = arguments["name"] as? String {
      attach.setValue(name, forKey: "_fileName")
    }

    if let duration = arguments["duration"] as? UInt {
      attach.duration = duration
    }

    if let width = arguments["width"] as? Int {
      attach.width = width
    }

    if let height = arguments["height"] as? Int {
      attach.height = height
    }

    if let url = arguments[#keyPath(V2NIMMessageFileAttachment.url)] as? String {
      attach.setValue(url,
                      forKeyPath: #keyPath(V2NIMMessageFileAttachment.url))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  override public func toDic() -> [String: Any] {
    var keyPaths = super.toDic()
    keyPaths[nimCoreMessageType] = V2NIMMessageType.MESSAGE_TYPE_VIDEO.rawValue
    keyPaths[#keyPath(V2NIMMessageVideoAttachment.duration)] = duration
    keyPaths[#keyPath(V2NIMMessageVideoAttachment.width)] = width
    keyPaths[#keyPath(V2NIMMessageVideoAttachment.height)] = height
    return keyPaths
  }
}
