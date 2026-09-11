// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK
import YXAlog_iOS

enum ChatRoomClientAPIType: String {
  case newInstance
  case destroyInstance
  case getInstanceList
  case destroyAll
  case enter
  case exit
  case getChatroomInfo
  case addChatroomClientListener
  case removeChatroomClientListener
}

class FLTChatRoomClient: FLTBaseService, FLTService {
  private static let className = "FLTChatRoomClient"
  private var chatroomClientListeners: [Int: V2NIMChatroomClientListener] = [:]

  override func onInitialized() {}

  deinit {}

  // MARK: - Protocol

  func serviceName() -> String {
    ServiceType.ChatRoomClient.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case ChatRoomClientAPIType.newInstance.rawValue:
      newInstance(arguments, resultCallback)
    case ChatRoomClientAPIType.destroyInstance.rawValue:
      destroyInstance(arguments, resultCallback)
    case ChatRoomClientAPIType.getInstanceList.rawValue:
      getInstanceList(arguments, resultCallback)
    case ChatRoomClientAPIType.destroyAll.rawValue:
      destroyAll(arguments, resultCallback)
    case ChatRoomClientAPIType.enter.rawValue:
      enter(arguments, resultCallback)
    case ChatRoomClientAPIType.exit.rawValue:
      exit(arguments, resultCallback)
    case ChatRoomClientAPIType.getChatroomInfo.rawValue:
      getChatroomInfo(arguments, resultCallback)
    case ChatRoomClientAPIType.addChatroomClientListener.rawValue:
      addChatroomClientListener(arguments, resultCallback)
    case ChatRoomClientAPIType.removeChatroomClientListener.rawValue:
      removeChatroomClientListener(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  // MARK: - SDK API

  func getInstanceId(_ arguments: [String: Any], _ resultCallback: ResultCallback) {}

  func getChatroomService(_ arguments: [String: Any], _ resultCallback: ResultCallback) {}

  func getChatroomQueueService(_ arguments: [String: Any], _ resultCallback: ResultCallback) {}

  func getStorageService(_ arguments: [String: Any], _ resultCallback: ResultCallback) {}

  /**
   *  构造一个新的聊天室实例
   *
   *  @return 聊天室实例
   */
  func newInstance(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let instance = V2NIMChatroomClient.newInstance()
    let instanceId = instance.getInstanceId()
    successCallBack(resultCallback, ["instanceId": instanceId])
  }

  /**
   *  获取聊天室实例
   *
   *  @param instanceId 聊天室实例ID
   *
   *  @return 聊天室实例
   */
  func getInstance(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int else {
      parameterError(resultCallback)
      return
    }

    let instance = V2NIMChatroomClient.getInstance(instanceId)
    successCallBack(resultCallback, ["instanceId": instance.getInstanceId()])
  }

  /**
   *  销毁指定聊天室实例
   *
   *  @param instanceId 聊天室实例ID
   */
  func destroyInstance(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int else {
      parameterError(resultCallback)
      return
    }

    V2NIMChatroomClient.destroyInstance(instanceId)
    successCallBack(resultCallback, nil)
  }

  /**
   *  获取当前已经存在的聊天室实例列表
   *
   *  @return 聊天室实例列表
   */
  func getInstanceList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let instanceList = V2NIMChatroomClient.getInstanceList()
    let instanceIdList = instanceList.map { $0.getInstanceId() }
    successCallBack(resultCallback, ["instanceList": instanceIdList])
  }

  /**
   *  销毁当前的所有聊天室实例
   */
  func destroyAll(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    V2NIMChatroomClient.destroyAll()
    successCallBack(resultCallback, nil)
  }

  /**
   *  进入聊天室
   *
   *  @param roomId 聊天室ID
   *  @param enterParams 进入聊天室相关参数
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  func enter(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let roomId = arguments["roomId"] as? String,
          let paramsDic = arguments["enterParams"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let params = V2NIMChatroomEnterParams.fromDic(paramsDic)
    let provider = FLTChatRoomClientListener(self, instanceId)
    params.linkProvider = provider
    params.loginOption.tokenProvider = provider
    params.loginOption.loginExtensionProvider = provider
    instance.enter(roomId, enterParams: params) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomClient.className, desc: "enter error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  退出聊天室
   */
  func exit(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int else {
      parameterError(resultCallback)
      return
    }

    let instance = V2NIMChatroomClient.getInstance(instanceId)
    instance.exit()
    successCallBack(resultCallback, nil)
  }

  /**
   *  获取聊天室信息
   *
   *  @return 聊天室信息
   */
  func getChatroomInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int else {
      parameterError(resultCallback)
      return
    }

    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let chatroomInfo = instance.getChatroomInfo()
    successCallBack(resultCallback, chatroomInfo.toDic())
  }

  /**
   *  添加聊天室实例监听
   *
   *  @param listener 聊天室监听
   */
  func addChatroomClientListener(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int else {
      parameterError(resultCallback)
      return
    }

    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let listener = FLTChatRoomClientListener(self, instanceId)
    instance.add(listener)
    chatroomClientListeners[instanceId] = listener
    successCallBack(resultCallback, nil)
  }

  /**
   *  移除聊天室实例监听
   *
   *  @param listener 聊天室监听
   */
  func removeChatroomClientListener(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int else {
      parameterError(resultCallback)
      return
    }

    let instance = V2NIMChatroomClient.getInstance(instanceId)
    if let listener = chatroomClientListeners[instanceId] {
      instance.remove(listener)
    }
    successCallBack(resultCallback, nil)
  }
}
