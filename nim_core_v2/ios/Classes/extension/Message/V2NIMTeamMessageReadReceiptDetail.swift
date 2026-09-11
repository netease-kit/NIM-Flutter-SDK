// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMTeamMessageReadReceiptDetail {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTeamMessageReadReceiptDetail {
    let attach = V2NIMTeamMessageReadReceiptDetail()

    if let readReceipt = arguments["readReceipt"] as? [String: Any] {
      attach.setValue(V2NIMTeamMessageReadReceipt.fromDic(readReceipt),
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceiptDetail.readReceipt))
    }

    if let readAccountList = arguments["readAccountList"] as? [String] {
      attach.setValue(readAccountList,
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceiptDetail.readAccountList))
    }

    if let unreadAccountList = arguments["unreadAccountList"] as? [String] {
      attach.setValue(unreadAccountList,
                      forKeyPath: #keyPath(V2NIMTeamMessageReadReceiptDetail.unreadAccountList))
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMTeamMessageReadReceiptDetail.readReceipt)] = readReceipt.toDic()
    keyPaths[#keyPath(V2NIMTeamMessageReadReceiptDetail.readAccountList)] = readAccountList
    keyPaths[#keyPath(V2NIMTeamMessageReadReceiptDetail.unreadAccountList)] = unreadAccountList
    return keyPaths
  }
}
