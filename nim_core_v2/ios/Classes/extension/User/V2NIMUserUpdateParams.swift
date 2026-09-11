// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMUserUpdateParams {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMUserUpdateParams.name)] = name
    keyPaths[#keyPath(V2NIMUserUpdateParams.avatar)] = avatar
    keyPaths[#keyPath(V2NIMUserUpdateParams.sign)] = sign
    keyPaths[#keyPath(V2NIMUserUpdateParams.email)] = email
    keyPaths[#keyPath(V2NIMUserUpdateParams.birthday)] = birthday
    keyPaths[#keyPath(V2NIMUserUpdateParams.mobile)] = mobile
    keyPaths[#keyPath(V2NIMUserUpdateParams.gender)] = gender.rawValue
    keyPaths[#keyPath(V2NIMUserUpdateParams.serverExtension)] = serverExtension
    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMUserUpdateParams {
    let params = V2NIMUserUpdateParams()

    if let name = arguments[#keyPath(V2NIMUserUpdateParams.name)] as? String {
      params.name = name
    }

    if let avatar = arguments[#keyPath(V2NIMUserUpdateParams.avatar)] as? String {
      params.avatar = avatar
    }

    if let sign = arguments[#keyPath(V2NIMUserUpdateParams.sign)] as? String {
      params.sign = sign
    }

    if let email = arguments[#keyPath(V2NIMUserUpdateParams.email)] as? String {
      params.email = email
    }

    if let birthday = arguments[#keyPath(V2NIMUserUpdateParams.birthday)] as? String {
      params.birthday = birthday
    }

    if let mobile = arguments[#keyPath(V2NIMUserUpdateParams.mobile)] as? String {
      params.mobile = mobile
    }

    if let gender = arguments[#keyPath(V2NIMUserUpdateParams.gender)] as? Int, let genderEnum = V2NIMGender(rawValue: gender) {
      params.gender = genderEnum
    }

    if let serverExtension = arguments[#keyPath(V2NIMUserUpdateParams.serverExtension)] as? String {
      params.serverExtension = serverExtension
    }
    return params
  }
}
