// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK
import YXAlog_iOS

class FLTChatRoomClientListener: NSObject {
  private let service: FLTChatRoomClient
  private let instanceId: Int

  init(_ service: FLTChatRoomClient, _ instanceId: Int) {
    self.service = service
    self.instanceId = instanceId
  }
}

// MARK: - V2NIMChatroomClientListener

extension FLTChatRoomClientListener: V2NIMChatroomClientListener {
  /**
   *  聊天室状态
   *
   *  @param status 状态
   *  @param error 错误信息
   */
  func onChatroomStatus(_ status: V2NIMChatroomStatus, error: V2NIMError?) {
    service.notifyEvent(service.serviceName(), "onChatroomStatus", ["instanceId": instanceId,
                                                                    "status": status.rawValue,
                                                                    "error": error?.toDic() as Any])
  }

  /**
   *  进入聊天室
   */
  func onChatroomEntered() {
    service.notifyEvent(service.serviceName(), "onChatroomEntered", ["instanceId": instanceId])
  }

  /**
   *  退出聊天室
   *
   *  @param error 错误信息
   */
  func onChatroomExited(_ error: V2NIMError?) {
    service.notifyEvent(service.serviceName(), "onChatroomExited", ["instanceId": instanceId,
                                                                    "error": error?.toDic() as Any])
  }

  /**
   *  自己被踢出聊天室
   *
   *  @param kickedInfo 被踢出的详细信息
   */
  func onChatroomKicked(_ kickedInfo: V2NIMChatroomKickedInfo) {
    service.notifyEvent(service.serviceName(), "onChatroomKicked", ["instanceId": instanceId,
                                                                    "kickedInfo": kickedInfo.toDic()])
  }
}

// MARK: - V2NIMChatroomLinkProvider

extension FLTChatRoomClientListener: V2NIMChatroomLinkProvider {
  func getLinkAddress(_ roomId: String, accountId: String) -> [String]? {
    guard !roomId.isEmpty, !accountId.isEmpty else {
      return nil
    }

    let semaphore = DispatchSemaphore(value: 0)
    service.nimCore?.addSemaphore(semaphore)
    var linkAddress: [String]?
    service.notifyEvent(service.serviceName(),
                        "getLinkAddress",
                        ["instanceId": instanceId,
                         "roomId": roomId,
                         "accountId": accountId]) { res in
      semaphore.signal()

      linkAddress = res as? [String]
    }
    semaphore.wait()
    return linkAddress
  }
}

// MARK: - V2NIMChatroomTokenProvider

extension FLTChatRoomClientListener: V2NIMChatroomTokenProvider {
  func getToken(_ roomId: String, accountId: String) -> String? {
    guard !roomId.isEmpty, !accountId.isEmpty else {
      return nil
    }

    let semaphore = DispatchSemaphore(value: 0)
    service.nimCore?.addSemaphore(semaphore)
    var token: String?
    service.notifyEvent(service.serviceName(),
                        "getToken",
                        ["instanceId": instanceId,
                         "roomId": roomId,
                         "accountId": accountId]) { res in
      semaphore.signal()
      token = res as? String
    }
    semaphore.wait()
    return token
  }
}

// MARK: - V2NIMChatroomLoginExtensionProvider

extension FLTChatRoomClientListener: V2NIMChatroomLoginExtensionProvider {
  func getLoginExtension(_ roomId: String, accountId: String) -> String? {
    guard !roomId.isEmpty, !accountId.isEmpty else {
      return nil
    }

    let semaphore = DispatchSemaphore(value: 0)
    service.nimCore?.addSemaphore(semaphore)
    var token: String?
    service.notifyEvent(service.serviceName(),
                        "getLoginExtension",
                        ["instanceId": instanceId,
                         "roomId": roomId,
                         "accountId": accountId]) { res in
      semaphore.signal()
      token = res as? String
    }
    semaphore.wait()
    return token
  }
}
