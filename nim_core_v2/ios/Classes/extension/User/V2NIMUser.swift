// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMUser {
  func toDictionary() -> [String: Any] {
    var dict = [String: Any]()
    dict[#keyPath(V2NIMUser.gender)] = gender
    dict[#keyPath(V2NIMUser.createTime)] = createTime * 1000
    dict[#keyPath(V2NIMUser.updateTime)] = updateTime * 1000

    if let accountIdValue = accountId, accountIdValue.count > 0 {
      dict[#keyPath(V2NIMUser.accountId)] = accountIdValue
    } else {
      dict[#keyPath(V2NIMUser.accountId)] = ""
    }
    if let nameValue = name, nameValue.count > 0 {
      dict[#keyPath(V2NIMUser.name)] = nameValue
    } else {
      dict[#keyPath(V2NIMUser.name)] = ""
    }
    if let avatarValue = avatar, avatarValue.count > 0 {
      dict[#keyPath(V2NIMUser.avatar)] = avatarValue
    } else {
      dict[#keyPath(V2NIMUser.avatar)] = ""
    }
    if let signValue = sign, signValue.count > 0 {
      dict[#keyPath(V2NIMUser.sign)] = signValue
    } else {
      dict[#keyPath(V2NIMUser.sign)] = ""
    }
    if let emailValue = email, emailValue.count > 0 {
      dict[#keyPath(V2NIMUser.email)] = emailValue
    } else {
      dict[#keyPath(V2NIMUser.email)] = ""
    }
    if let birthdayValue = birthday, birthdayValue.count > 0 {
      dict[#keyPath(V2NIMUser.birthday)] = birthdayValue
    } else {
      dict[#keyPath(V2NIMUser.birthday)] = ""
    }
    if let mobileValue = mobile, mobileValue.count > 0 {
      dict[#keyPath(V2NIMUser.mobile)] = mobileValue
    } else {
      dict[#keyPath(V2NIMUser.mobile)] = ""
    }
    if let serverExtensionValue = serverExtension, serverExtensionValue.count > 0 {
      dict[#keyPath(V2NIMUser.serverExtension)] = serverExtensionValue
    } else {
      dict[#keyPath(V2NIMUser.serverExtension)] = ""
    }
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMUser {
    let user = V2NIMUser()
    if let accountId = dict[#keyPath(V2NIMUser.accountId)] as? String {
      user.accountId = accountId
    }
    if let name = dict[#keyPath(V2NIMUser.name)] as? String {
      user.name = name
    }
    if let avatar = dict[#keyPath(V2NIMUser.avatar)] as? String {
      user.avatar = avatar
    }
    if let sign = dict[#keyPath(V2NIMUser.sign)] as? String {
      user.sign = sign
    }
    if let email = dict[#keyPath(V2NIMUser.email)] as? String {
      user.email = email
    }
    if let birthday = dict[#keyPath(V2NIMUser.birthday)] as? String {
      user.birthday = birthday
    }
    if let mobile = dict[#keyPath(V2NIMUser.mobile)] as? String {
      user.mobile = mobile
    }
    if let gender = dict[#keyPath(V2NIMUser.gender)] as? Int {
      user.gender = gender
    }
    if let serverExtension = dict[#keyPath(V2NIMUser.serverExtension)] as? String {
      user.serverExtension = serverExtension
    }
    if let createTime = dict[#keyPath(V2NIMUser.createTime)] as? Double {
      user.createTime = createTime / 1000
    }
    if let updateTime = dict[#keyPath(V2NIMUser.updateTime)] as? Double {
      user.updateTime = updateTime / 1000
    }
    return user
  }
}
