// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

@objc
extension V2NIMUser {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  public func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMUser.gender)] = gender
    keyPaths[#keyPath(V2NIMUser.createTime)] = createTime * 1000
    keyPaths[#keyPath(V2NIMUser.updateTime)] = updateTime * 1000
    keyPaths[#keyPath(V2NIMUser.accountId)] = accountId
    keyPaths[#keyPath(V2NIMUser.name)] = name
    keyPaths[#keyPath(V2NIMUser.avatar)] = avatar
    keyPaths[#keyPath(V2NIMUser.sign)] = sign
    keyPaths[#keyPath(V2NIMUser.email)] = email
    keyPaths[#keyPath(V2NIMUser.birthday)] = birthday
    keyPaths[#keyPath(V2NIMUser.mobile)] = mobile
    keyPaths[#keyPath(V2NIMUser.serverExtension)] = serverExtension
    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMUser {
    let user = V2NIMUser()

    if let accountId = arguments[#keyPath(V2NIMUser.accountId)] as? String {
      user.accountId = accountId
    }

    if let name = arguments[#keyPath(V2NIMUser.name)] as? String {
      user.name = name
    }

    if let avatar = arguments[#keyPath(V2NIMUser.avatar)] as? String {
      user.avatar = avatar
    }

    if let sign = arguments[#keyPath(V2NIMUser.sign)] as? String {
      user.sign = sign
    }

    if let email = arguments[#keyPath(V2NIMUser.email)] as? String {
      user.email = email
    }

    if let birthday = arguments[#keyPath(V2NIMUser.birthday)] as? String {
      user.birthday = birthday
    }

    if let mobile = arguments[#keyPath(V2NIMUser.mobile)] as? String {
      user.mobile = mobile
    }

    if let gender = arguments[#keyPath(V2NIMUser.gender)] as? Int {
      user.gender = gender
    }

    if let serverExtension = arguments[#keyPath(V2NIMUser.serverExtension)] as? String {
      user.serverExtension = serverExtension
    }

    if let createTime = arguments[#keyPath(V2NIMUser.createTime)] as? Double {
      user.createTime = TimeInterval(createTime / 1000)
    }

    if let updateTime = arguments[#keyPath(V2NIMUser.updateTime)] as? Double {
      user.updateTime = TimeInterval(updateTime / 1000)
    }
    return user
  }
}
