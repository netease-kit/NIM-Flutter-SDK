// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageFileAttachment {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDict(_ arguments: [String: Any]) -> V2NIMMessageFileAttachment {
    let raw = V2NIMMessageAttachment.fromDic(arguments).raw
    let attach = V2NIMMessageFileAttachment()
    attach.raw = raw

    if let path = arguments["path"] as? String {
      attach.path = path
      attach.setValue(path, forKey: "_filePath")
    }

    if let size = arguments["size"] as? UInt {
      attach.size = size
    }

    if let md5 = arguments["md5"] as? String {
      attach.md5 = md5
    }

    if let url = arguments["url"] as? String {
      attach.setValue(url,
                      forKeyPath: #keyPath(V2NIMMessageFileAttachment.url))
    }

    if let ext = arguments["ext"] as? String {
      attach.ext = ext
    }

    if let name = arguments["name"] as? String {
      attach.name = name
      attach.setValue(name, forKey: "_fileName")
    }

    if let sceneName = arguments["sceneName"] as? String {
      attach.sceneName = sceneName
    }

    if let uploadState = arguments["uploadState"] as? Int,
       let state = V2NIMMessageAttachmentUploadState(rawValue: uploadState) {
      attach.uploadState = state
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  override public func toDic() -> [String: Any] {
    var keyPaths = super.toDic()
    keyPaths[nimCoreMessageType] = V2NIMMessageType.MESSAGE_TYPE_FILE.rawValue
    keyPaths[#keyPath(V2NIMMessageFileAttachment.path)] = path
    keyPaths[#keyPath(V2NIMMessageFileAttachment.size)] = size
    keyPaths[#keyPath(V2NIMMessageFileAttachment.md5)] = md5
    keyPaths[#keyPath(V2NIMMessageFileAttachment.url)] = url
    keyPaths[#keyPath(V2NIMMessageFileAttachment.ext)] = ext
    keyPaths[#keyPath(V2NIMMessageFileAttachment.name)] = name
    keyPaths[#keyPath(V2NIMMessageFileAttachment.sceneName)] = sceneName
    keyPaths[#keyPath(V2NIMMessageFileAttachment.uploadState)] = uploadState.rawValue
    return keyPaths
  }
}
