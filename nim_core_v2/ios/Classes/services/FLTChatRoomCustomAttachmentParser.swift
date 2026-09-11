// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK
import YXAlog_iOS

class FLTChatRoomCustomAttachmentParser: NSObject {
  private let service: FLTChatRoomService
  private let instanceId: Int

  init(_ service: FLTChatRoomService, _ instanceId: Int) {
    self.service = service
    self.instanceId = instanceId
  }
}

// MARK: - V2NIMMessageCustomAttachmentParser

extension FLTChatRoomCustomAttachmentParser: V2NIMMessageCustomAttachmentParser {
  func parse(_ subType: Int32, attach: String) -> Any? {
    guard subType > 0, !attach.isEmpty else {
      return nil
    }

    let semaphore = DispatchSemaphore(value: 0)
    service.nimCore?.addSemaphore(semaphore)
    var result: Any?
    service.notifyEvent(service.serviceName(),
                        "parse",
                        ["instanceId": instanceId,
                         "subType": subType,
                         "attach": attach]) { res in
      semaphore.signal()
      result = res
    }
    semaphore.wait()
    return result
  }
}
