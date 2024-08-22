// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMUserUpdateParams {
  func toDictionary() -> [String: Any] {
    var dict = [String: Any]()
    dict[#keyPath(V2NIMUserUpdateParams.name)] = name
    dict[#keyPath(V2NIMUserUpdateParams.avatar)] = avatar
    dict[#keyPath(V2NIMUserUpdateParams.sign)] = sign
    dict[#keyPath(V2NIMUserUpdateParams.email)] = email
    dict[#keyPath(V2NIMUserUpdateParams.birthday)] = birthday
    dict[#keyPath(V2NIMUserUpdateParams.mobile)] = mobile
    dict[#keyPath(V2NIMUserUpdateParams.gender)] = gender.rawValue
    dict[#keyPath(V2NIMUserUpdateParams.serverExtension)] = serverExtension
    return dict
  }

  static func fromDictionary(_ dict: [String: Any]) -> V2NIMUserUpdateParams {
    let params = V2NIMUserUpdateParams()
    if let name = dict[#keyPath(V2NIMUserUpdateParams.name)] as? String {
      params.name = name
    }
    if let avatar = dict[#keyPath(V2NIMUserUpdateParams.avatar)] as? String {
      params.avatar = avatar
    }
    if let sign = dict[#keyPath(V2NIMUserUpdateParams.sign)] as? String {
      params.sign = sign
    }
    if let email = dict[#keyPath(V2NIMUserUpdateParams.email)] as? String {
      params.email = email
    }
    if let birthday = dict[#keyPath(V2NIMUserUpdateParams.birthday)] as? String {
      params.birthday = birthday
    }
    if let mobile = dict[#keyPath(V2NIMUserUpdateParams.mobile)] as? String {
      params.mobile = mobile
    }
    if let gender = dict[#keyPath(V2NIMUserUpdateParams.gender)] as? Int, let genderEnum = V2NIMGender(rawValue: gender) {
      params.gender = genderEnum
    }
    if let serverExtension = dict[#keyPath(V2NIMUserUpdateParams.serverExtension)] as? String {
      params.serverExtension = serverExtension
    }
    return params
  }
}
