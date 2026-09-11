// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageAudioAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDictionary(_ arguments: [String: Any]) -> V2NIMMessageAudioAttachment {
    let superAttach = super.fromDict(arguments)
    let attach = V2NIMMessageAudioAttachment()
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

    if let url = superAttach.url {
      attach.setValue(url,
                      forKeyPath: #keyPath(V2NIMMessageImageAttachment.url))
    }

    if let duration = arguments["duration"] as? UInt {
      attach.duration = duration
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  override public func toDic() -> [String: Any] {
    var keyPaths = super.toDic()
    keyPaths[nimCoreMessageType] = V2NIMMessageType.MESSAGE_TYPE_AUDIO.rawValue
    keyPaths[#keyPath(V2NIMMessageAudioAttachment.duration)] = duration
    return keyPaths
  }
}
