// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension V2NIMFriend {
  func toDict() -> [String: Any?] {
    var dict: [String: Any?] = [
      #keyPath(V2NIMFriend.accountId): accountId,
      #keyPath(V2NIMFriend.alias): alias,
      #keyPath(V2NIMFriend.serverExtension): serverExtension,
      #keyPath(V2NIMFriend.customerExtension): customerExtension,
      #keyPath(V2NIMFriend.createTime): createTime * 1000.0,
      #keyPath(V2NIMFriend.updateTime): updateTime * 1000.0,
    ]
    if let userprofileDic = userProfile?.toDictionary() {
      dict[#keyPath(V2NIMFriend.userProfile)] = userProfile?.toDictionary()
    }
    return dict
  }
}

extension V2NIMFriendAddApplication {
  func toDict() -> [String: Any?] {
    let dict: [String: Any?] = [
      #keyPath(V2NIMFriendAddApplication.applicantAccountId): applicantAccountId,
      #keyPath(V2NIMFriendAddApplication.recipientAccountId): recipientAccountId,
      #keyPath(V2NIMFriendAddApplication.operatorAccountId): operatorAccountId,
      #keyPath(V2NIMFriendAddApplication.postscript): postscript,
      #keyPath(V2NIMFriendAddApplication.status): status.rawValue,
      #keyPath(V2NIMFriendAddApplication.timestamp): timestamp * 1000.0,
      #keyPath(V2NIMFriendAddApplication.read): read,
    ]
    return dict
  }

  static func fromDict(_ json: [String: Any?]) -> V2NIMFriendAddApplication {
    let application = V2NIMFriendAddApplication()
    if let applicantAccountId = json[#keyPath(V2NIMFriendAddApplication.applicantAccountId)] as? String {
      application.setValue(applicantAccountId, forKey: #keyPath(V2NIMFriendAddApplication.applicantAccountId))
    }

    if let recipientAccountId = json[#keyPath(V2NIMFriendAddApplication.recipientAccountId)] as? String {
      application.setValue(recipientAccountId, forKey: #keyPath(V2NIMFriendAddApplication.recipientAccountId))
    }

    if let operatorAccountId = json[#keyPath(V2NIMFriendAddApplication.operatorAccountId)] as? String {
      application.setValue(operatorAccountId, forKey: #keyPath(V2NIMFriendAddApplication.operatorAccountId))
    }

    if let postscript = json[#keyPath(V2NIMFriendAddApplication.postscript)] as? String {
      application.setValue(postscript, forKey: #keyPath(V2NIMFriendAddApplication.postscript))
    }

    if let statusInt = json[#keyPath(V2NIMFriendAddApplication.status)] as? Int,
       let status = V2NIMFriendAddApplicationStatus(rawValue: statusInt) {
      application.status = status
    }

    if let timestamp = json[#keyPath(V2NIMFriendAddApplication.timestamp)] as? Double {
      application.timestamp = TimeInterval(timestamp / 1000)
    }

    if let read = json[#keyPath(V2NIMFriendAddApplication.read)] as? Bool {
      application.read = read
    }
    return application
  }
}

extension V2NIMFriendAddParams {
  static func fromDict(_ json: [String: Any?]) -> V2NIMFriendAddParams {
    let params = V2NIMFriendAddParams()
    if let addModelInt = json[#keyPath(V2NIMFriendAddParams.addMode)] as? Int {
      params.addMode = V2NIMFriendAddMode(rawValue: addModelInt) ?? V2NIMFriendAddMode.FRIEND_MODE_TYPE_APPLAY
    }
    if let postscript = json[#keyPath(V2NIMFriendAddParams.postscript)] as? String {
      params.postscript = postscript
    }
    return params
  }
}

extension V2NIMFriendDeleteParams {
  static func fromDict(_ json: [String: Any?]) -> V2NIMFriendDeleteParams {
    let params = V2NIMFriendDeleteParams()
    if let deleteAlias = json[#keyPath(V2NIMFriendDeleteParams.deleteAlias)] as? Bool {
      params.deleteAlias = deleteAlias
    }
    return params
  }
}

extension V2NIMFriendSetParams {
  static func fromDict(_ json: [String: Any?]) -> V2NIMFriendSetParams {
    let params = V2NIMFriendSetParams()
    if let alias = json[#keyPath(V2NIMFriendSetParams.alias)] as? String {
      params.alias = alias
    }
    if let serverExtension = json[#keyPath(V2NIMFriendSetParams.serverExtension)] as? String {
      params.serverExtension = serverExtension
    }
    return params
  }
}

extension V2NIMFriendSearchOption {
  static func fromDict(_ json: [String: Any?]) -> V2NIMFriendSearchOption {
    let option = V2NIMFriendSearchOption()
    if let keyword = json[#keyPath(V2NIMFriendSearchOption.keyword)] as? String {
      option.keyword = keyword
    }
    if let searchAlias = json[#keyPath(V2NIMFriendSearchOption.searchAlias)] as? Bool {
      option.searchAlias = searchAlias
    }
    if let searchAccountId = json[#keyPath(V2NIMFriendSearchOption.searchAccountId)] as? Bool {
      option.searchAccountId = searchAccountId
    }
    return option
  }
}

extension V2NIMFriendAddApplicationQueryOption {
  static func fromDict(_ json: [String: Any?]) -> V2NIMFriendAddApplicationQueryOption {
    let option = V2NIMFriendAddApplicationQueryOption()
    if let offset = json[#keyPath(V2NIMFriendAddApplicationQueryOption.offset)] as? Int {
      option.offset = UInt(offset)
    }
    if let limit = json[#keyPath(V2NIMFriendAddApplicationQueryOption.limit)] as? Int {
      option.limit = UInt(limit)
    }
    if let status = json[#keyPath(V2NIMFriendAddApplicationQueryOption.status)] as? [Int] {
      option.status = status.map { NSNumber(value: $0) }
    }
    return option
  }
}

// TODO: need check
extension V2NIMFriendAddApplicationResult {
  func toDict() -> [String: Any?] {
    let dict: [String: Any?] = [
      #keyPath(V2NIMFriendAddApplicationResult.infos): infos?.map { application in
        application.toDict()
      },
      #keyPath(V2NIMFriendAddApplicationResult.offset): offset,
      #keyPath(V2NIMFriendAddApplicationResult.finished): finished,
    ]
    return dict
  }
}
