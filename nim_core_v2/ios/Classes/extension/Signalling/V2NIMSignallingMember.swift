// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSignallingMember {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSignallingMember {
    let member = V2NIMSignallingMember()

    if let accountId = arguments["accountId"] as? String {
      member.setValue(accountId, forKeyPath: #keyPath(V2NIMSignallingMember.accountId))
    }

    if let uid = arguments["uid"] as? Int {
      member.setValue(uid, forKeyPath: #keyPath(V2NIMSignallingMember.uid))
    }

    if let joinTime = arguments["joinTime"] as? Int {
      member.setValue(TimeInterval(joinTime / 1000), forKeyPath: #keyPath(V2NIMSignallingMember.joinTime))
    }

    if let expireTime = arguments["expireTime"] as? Int {
      member.setValue(TimeInterval(expireTime / 1000), forKeyPath: #keyPath(V2NIMSignallingMember.expireTime))
    }

    if let deviceId = arguments["deviceId"] as? String {
      member.setValue(deviceId, forKeyPath: #keyPath(V2NIMSignallingMember.deviceId))
    }

    return member
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMSignallingMember.accountId)] = accountId
    keyPaths[#keyPath(V2NIMSignallingMember.uid)] = uid
    keyPaths[#keyPath(V2NIMSignallingMember.joinTime)] = joinTime * 1000
    keyPaths[#keyPath(V2NIMSignallingMember.expireTime)] = expireTime * 1000
    keyPaths[#keyPath(V2NIMSignallingMember.deviceId)] = deviceId
    return keyPaths
  }
}
