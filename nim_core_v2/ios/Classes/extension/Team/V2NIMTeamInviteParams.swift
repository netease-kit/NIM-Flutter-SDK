// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation

import NIMSDK

extension V2NIMTeamInviteParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMTeamInviteParams {
    let inviteParams = V2NIMTeamInviteParams()
    if let postscript = arguments[#keyPath(postscript)] as? String {
      inviteParams.setValue(postscript, forKey: #keyPath(V2NIMTeamInviteParams.postscript))
    }
    if let serverExtension = arguments[#keyPath(serverExtension)] as? String {
      inviteParams.setValue(serverExtension, forKey: #keyPath(V2NIMTeamInviteParams.serverExtension))
    }
    if let inviteeAccountIds = arguments[#keyPath(inviteeAccountIds)] as? [String] {
      inviteParams.setValue(inviteeAccountIds, forKey: #keyPath(V2NIMTeamInviteParams.inviteeAccountIds))
    }
    return inviteParams
  }
}
