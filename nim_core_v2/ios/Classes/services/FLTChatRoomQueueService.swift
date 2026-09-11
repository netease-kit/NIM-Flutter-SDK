// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK
import YXAlog_iOS

enum ChatRoomQueueServiceAPIType: String {
  case queueOffer
  case queuePoll
  case queueList
  case queuePeek
  case queueDrop
  case queueInit
  case queueBatchUpdate
  case addQueueListener
  case removeQueueListener
}

class FLTChatRoomQueueService: FLTBaseService, FLTService {
  private static let className = "FLTChatRoomQueueService"
  private var chatroomQueueServiceListeners: [Int: V2NIMChatroomQueueListener] = [:]

  override func onInitialized() {}

  deinit {}

  // MARK: - Protocol

  func serviceName() -> String {
    ServiceType.ChatRoomQueueService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case ChatRoomQueueServiceAPIType.queueOffer.rawValue:
      queueOffer(arguments, resultCallback)
    case ChatRoomQueueServiceAPIType.queuePoll.rawValue:
      queuePoll(arguments, resultCallback)
    case ChatRoomQueueServiceAPIType.queueList.rawValue:
      queueList(arguments, resultCallback)
    case ChatRoomQueueServiceAPIType.queuePeek.rawValue:
      queuePeek(arguments, resultCallback)
    case ChatRoomQueueServiceAPIType.queueDrop.rawValue:
      queueDrop(arguments, resultCallback)
    case ChatRoomQueueServiceAPIType.queueInit.rawValue:
      queueInit(arguments, resultCallback)
    case ChatRoomQueueServiceAPIType.queueBatchUpdate.rawValue:
      queueBatchUpdate(arguments, resultCallback)
    case ChatRoomQueueServiceAPIType.addQueueListener.rawValue:
      addQueueListener(arguments, resultCallback)
    case ChatRoomQueueServiceAPIType.removeQueueListener.rawValue:
      removeQueueListener(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  // MARK: - SDK API

  /**
   * 聊天室队列新增或更新元素
   * @param offerParams 新增或更新元素参数
   * @param success 操作成功的回调
   * @param failure 操作失败的回调
   */
  func queueOffer(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let paramsDic = arguments["offerParams"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let queueService = instance.getChatroomQueueService()
    let offerParams = V2NIMChatroomQueueOfferParams.fromDic(paramsDic)

    queueService.queueOffer(offerParams) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomQueueService.className, desc: "queueOffer error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 取出头元素或者指定的元素
   * 仅管理员和创建者可以操作
   * @param elementKey
   *           如果为空表示取出头元素
   *           如果不为空， 取出指定的元素
   * @param success 操作成功的回调
   * @param failure 操作失败的回调
   */
  func queuePoll(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let queueService = instance.getChatroomQueueService()
    let elementKey = arguments["elementKey"] as? String

    queueService.queuePoll(elementKey) { element in
      weakSelf?.successCallBack(resultCallback, element.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomQueueService.className, desc: "queuePoll error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 排序列出所有元素
   * @param success 操作成功的回调
   * @param failure 操作失败的回调
   */
  func queueList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let queueService = instance.getChatroomQueueService()

    queueService.queueList { elements in
      let elementList = elements.map { $0.toDic() }
      weakSelf?.successCallBack(resultCallback, ["elements": elementList])
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomQueueService.className, desc: "queueList error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 查看队头元素， 不删除
   * @param success 操作成功的回调
   * @param failure 操作失败的回调
   */
  func queuePeek(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let queueService = instance.getChatroomQueueService()

    queueService.queuePeek { element in
      weakSelf?.successCallBack(resultCallback, element.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomQueueService.className, desc: "queuePeek error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 清空队列
   * 仅管理员/创建者可以操作
   * @param success 操作成功的回调
   * @param failure 操作失败的回调
   */
  func queueDrop(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let queueService = instance.getChatroomQueueService()

    queueService.queueDrop {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomQueueService.className, desc: "queueDrop error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 初始化队列
   * @param size 初始化队列的长度
   *             长度限制： 0~1000， 超过返回参数错误
   *             可以对现有队列做此操作，修改现有队列的长度上限；
   *             当前队列如果已经超过了新的限制，元素不会减少，但是新元素无法增加
   * @param success 操作成功的回调
   * @param failure 操作失败的回调
   */
  func queueInit(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let size = arguments["size"] as? Int else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let queueService = instance.getChatroomQueueService()

    queueService.queueInit(size) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomQueueService.className, desc: "queueInit error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 批量更新队列元素
   * @param keyValues 批量更新元素
   *                   size为空， size==0， size>100， 返回参数错误
   *                   key:长度限制：128字节
   *                   value：长度限制：4096字节
   * @param notificationEnabled 是否发送广播通知,317,默认为true
   * @param notificationExtension 本次操作生成的通知中的扩展字段，长度限制：2048字节
   * @param success 操作成功的回调，返回不存在的元素key列表
   * @param failure 操作失败的回调
   */
  func queueBatchUpdate(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let notificationEnabled = arguments["notificationEnabled"] as? Bool,
          let elementsDic = arguments["elements"] as? [[String: Any]] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let queueService = instance.getChatroomQueueService()
    let elements = elementsDic.map { V2NIMChatroomQueueElement.fromDic($0) }
    let notificationExtension = arguments["notificationExtension"] as? String

    queueService.queueBatchUpdate(elements,
                                  notificationEnabled: notificationEnabled,
                                  notificationExtension: notificationExtension) { notExistKeys in
      weakSelf?.successCallBack(resultCallback, ["notExistKeys": notExistKeys])
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomQueueService.className, desc: "queueBatchUpdate error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 添加聊天室队列监听器
   */
  func addQueueListener(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int else {
      parameterError(resultCallback)
      return
    }

    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let queueService = instance.getChatroomQueueService()
    let listener = FLTChatRoomQueueServiceListener(self, instanceId)
    chatroomQueueServiceListeners[instanceId] = listener
    queueService.add(listener)
    successCallBack(resultCallback, nil)
  }

  /**
   * 移除聊天室队列监听器
   */
  func removeQueueListener(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int else {
      parameterError(resultCallback)
      return
    }

    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let queueService = instance.getChatroomQueueService()
    if let listener = chatroomQueueServiceListeners[instanceId] {
      queueService.remove(listener)
    }
    successCallBack(resultCallback, nil)
  }
}
