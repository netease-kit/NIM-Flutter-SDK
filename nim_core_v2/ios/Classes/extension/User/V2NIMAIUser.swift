// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMAIUser {
  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  override public func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMAIUser.gender)] = gender
    keyPaths[#keyPath(V2NIMAIUser.createTime)] = createTime * 1000
    keyPaths[#keyPath(V2NIMAIUser.updateTime)] = updateTime * 1000
    keyPaths[#keyPath(V2NIMAIUser.accountId)] = accountId
    keyPaths[#keyPath(V2NIMAIUser.name)] = name
    keyPaths[#keyPath(V2NIMAIUser.avatar)] = avatar
    keyPaths[#keyPath(V2NIMAIUser.sign)] = sign
    keyPaths[#keyPath(V2NIMAIUser.email)] = email
    keyPaths[#keyPath(V2NIMAIUser.birthday)] = birthday
    keyPaths[#keyPath(V2NIMAIUser.mobile)] = mobile
    keyPaths[#keyPath(V2NIMAIUser.serverExtension)] = serverExtension
    keyPaths[#keyPath(V2NIMAIUser.modelType)] = modelType.rawValue
    keyPaths[#keyPath(V2NIMAIUser.modelConfig)] = modelConfig?.toDic()
    keyPaths[#keyPath(V2NIMAIUser.aiModelType)] = aiModelType

    return keyPaths
  }

  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDict(_ arguments: [String: Any]) -> V2NIMAIUser {
    let user = V2NIMAIUser()

    if let modelTypeInt = arguments[#keyPath(V2NIMAIUser.modelType)] as? Int, let modelType = V2NIMAIModelType(rawValue: modelTypeInt) {
      user.modelType = modelType
    }
    if let modelConfigDic = arguments[#keyPath(V2NIMAIUser.modelConfig)] as? [String: Any] {
      user.modelConfig = V2NIMAIModelConfig.fromDic(modelConfigDic)
    }
    if let accountId = arguments[#keyPath(V2NIMAIUser.accountId)] as? String {
      user.accountId = accountId
    }
    if let name = arguments[#keyPath(V2NIMAIUser.name)] as? String {
      user.name = name
    }
    if let avatar = arguments[#keyPath(V2NIMAIUser.avatar)] as? String {
      user.avatar = avatar
    }
    if let sign = arguments[#keyPath(V2NIMAIUser.sign)] as? String {
      user.sign = sign
    }
    if let email = arguments[#keyPath(V2NIMAIUser.email)] as? String {
      user.email = email
    }
    if let birthday = arguments[#keyPath(V2NIMAIUser.birthday)] as? String {
      user.birthday = birthday
    }
    if let mobile = arguments[#keyPath(V2NIMAIUser.mobile)] as? String {
      user.mobile = mobile
    }
    if let gender = arguments[#keyPath(V2NIMAIUser.gender)] as? Int {
      user.gender = gender
    }
    if let serverExtension = arguments[#keyPath(V2NIMAIUser.serverExtension)] as? String {
      user.serverExtension = serverExtension
    }
    if let createTime = arguments[#keyPath(V2NIMAIUser.createTime)] as? Double {
      user.createTime = TimeInterval(createTime / 1000)
    }
    if let updateTime = arguments[#keyPath(V2NIMAIUser.updateTime)] as? Double {
      user.updateTime = TimeInterval(updateTime / 1000)
    }
    if let aiModelType = arguments[#keyPath(V2NIMAIUser.aiModelType)] as? Int {
      user.aiModelType = aiModelType
    }
    return user
  }
}
