// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMAIModelStreamCallChunk {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMAIModelStreamCallChunk.content)] = content
    keyPaths[#keyPath(V2NIMAIModelStreamCallChunk.type)] = type
    keyPaths[#keyPath(V2NIMAIModelStreamCallChunk.chunkTime)] = chunkTime * 1000
    keyPaths[#keyPath(V2NIMAIModelStreamCallChunk.index)] = index
    return keyPaths
  }
}
