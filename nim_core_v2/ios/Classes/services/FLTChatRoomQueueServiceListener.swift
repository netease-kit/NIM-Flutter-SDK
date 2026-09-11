// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

class FLTChatRoomQueueServiceListener: NSObject {
  private let service: FLTChatRoomQueueService
  private let instanceId: Int

  init(_ service: FLTChatRoomQueueService, _ instanceId: Int) {
    self.service = service
    self.instanceId = instanceId
  }
}

// MARK: - V2NIMChatroomQueueListener

extension FLTChatRoomQueueServiceListener: V2NIMChatroomQueueListener {
  /**
   * 聊天室新增队列元素
   * @param keyValues 新增的队列内容。
   */
  func onChatroomQueueOffered(_ element: V2NIMChatroomQueueElement) {
    service.notifyEvent(service.serviceName(), "onChatroomQueueOffered", ["instanceId": instanceId,
                                                                          "element": element.toDic()])
  }

  /**
   * 聊天室移除队列元素
   * @param keyValues 移除的队列内容。
   */
  func onChatroomQueuePolled(_ element: V2NIMChatroomQueueElement) {
    service.notifyEvent(service.serviceName(), "onChatroomQueuePolled", ["instanceId": instanceId,
                                                                         "element": element.toDic()])
  }

  /**
   * 聊天室清空队列元素
   */
  func onChatroomQueueDropped() {
    service.notifyEvent(service.serviceName(), "onChatroomQueueDropped", ["instanceId": instanceId])
  }

  /**
   * 聊天室清理部分队列元素
   * @param keyValues 清理的队列内容
   */
  func onChatroomQueuePartCleared(_ elements: [V2NIMChatroomQueueElement]) {
    let elementList = elements.map { $0.toDic() }
    service.notifyEvent(service.serviceName(), "onChatroomQueuePartCleared", ["instanceId": instanceId,
                                                                              "elements": elementList])
  }

  /**
   * 聊天室批量更新队列元素
   * @param keyValues 更新的队列内容
   */
  func onChatroomQueueBatchUpdated(_ elements: [V2NIMChatroomQueueElement]) {
    let elementList = elements.map { $0.toDic() }
    service.notifyEvent(service.serviceName(), "onChatroomQueueBatchUpdated", ["instanceId": instanceId,
                                                                               "elements": elementList])
  }

  /**
   * 聊天室批量添加队列元素
   * @param keyValues 批量添加队列元素
   */
  func onChatroomQueueBatchOffered(_ elements: [V2NIMChatroomQueueElement]) {
    let elementList = elements.map { $0.toDic() }
    service.notifyEvent(service.serviceName(), "onChatroomQueueBatchOffered", ["instanceId": instanceId,
                                                                               "elements": elementList])
  }
}
