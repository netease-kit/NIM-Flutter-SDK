// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum SignallingServiceType: String {
  case call
  case callSetup
  case createRoom
  case closeRoom
  case joinRoom
  case leaveRoom
  case invite
  case cancelInvite
  case rejectInvite
  case acceptInvite
  case sendControl
  case getRoomInfoByChannelName
}

class FLTSignallingService: FLTBaseService, FLTService {
  override func onInitialized() {
    NIMSDK.shared().v2SignallingService.add(self)
  }

  deinit {
    NIMSDK.shared().v2SignallingService.remove(self)
  }

  func serviceName() -> String {
    ServiceType.SignallingService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case SignallingServiceType.call.rawValue:
      call(arguments, resultCallback)
    case SignallingServiceType.callSetup.rawValue:
      callSetup(arguments, resultCallback)
    case SignallingServiceType.createRoom.rawValue:
      createRoom(arguments, resultCallback)
    case SignallingServiceType.closeRoom.rawValue:
      closeRoom(arguments, resultCallback)
    case SignallingServiceType.joinRoom.rawValue:
      joinRoom(arguments, resultCallback)
    case SignallingServiceType.leaveRoom.rawValue:
      leaveRoom(arguments, resultCallback)
    case SignallingServiceType.invite.rawValue:
      invite(arguments, resultCallback)
    case SignallingServiceType.cancelInvite.rawValue:
      cancelInvite(arguments, resultCallback)
    case SignallingServiceType.rejectInvite.rawValue:
      rejectInvite(arguments, resultCallback)
    case SignallingServiceType.acceptInvite.rawValue:
      acceptInvite(arguments, resultCallback)
    case SignallingServiceType.sendControl.rawValue:
      sendControl(arguments, resultCallback)
    case SignallingServiceType.getRoomInfoByChannelName.rawValue:
      getRoomInfoByChannelName(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func signallingCallback(_ error: Error?, _ data: Any?, _ resultCallback: ResultCallback) {
    if let ns_error = error as NSError? {
      errorCallBack(resultCallback, ns_error.description, ns_error.code)
    } else {
      successCallBack(resultCallback, data)
    }
  }

  /**
   * 直接呼叫对方加入房间
   * 信令正常流程：
   *  创建房间（createRoom），
   *  自己加入房间（join）
   *  邀请对方加入房间（invite）
   *  上述的房间是信令的房间，不是音视频的房间，因此需要三次向服务器交互才能建立相关流程
   * call接口同时实现了上诉三个接口的功能， 可以加速呼叫流程， 如果你需要精确控制每一步，则需要调用上述每一个接口
   *
   * @param param 呼叫参数
   * @param success 呼叫成功回调
   * @param failure 呼叫失败回调
   */
  func call(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramJson = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let param = V2NIMSignallingCallParams.fromDic(paramJson)
    NIMSDK.shared().v2SignallingService.call(param) { result in
      weakSelf?.signallingCallback(nil, result.toDic(), resultCallback)
    } failure: { error in
      weakSelf?.signallingCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(subscriptionClassName, desc: "call error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 呼叫建立， 包括加入信令频道房间， 同时接受对方呼叫
   *  组合接口（join+accept）
   *  如果需要详细处理每一步骤， 则可以单独调用join接口，之后再调用accept接口
   *
   *  @param param 接受呼叫参数
   *  @param success 接受成功回调
   *  @param failure 接受失败回调
   */
  func callSetup(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramJson = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let param = V2NIMSignallingCallSetupParams.fromDic(paramJson)
    NIMSDK.shared().v2SignallingService.callSetup(param) { result in
      weakSelf?.signallingCallback(nil, result.toDic(), resultCallback)
    } failure: { error in
      weakSelf?.signallingCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(subscriptionClassName, desc: "call error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 取消之前的邀请成员加入信令房间接口
   *  该接口调用后会触发取消邀请通知给对方
   * @param param 取消之前的邀请成员加入信令房间接口参数
   * @param success 成功的回调
   * @param failure 失败的回调
   */
  func createRoom(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let channelType = arguments["channelType"] as? Int,
          let channelType = V2NIMSignallingChannelType(rawValue: channelType) else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self

    let channelName = arguments["channelName"] as? String
    let channelExtension = arguments["channelExtension"] as? String
    NIMSDK.shared().v2SignallingService.createRoom(channelType, channelName: channelName, channelExtension: channelExtension) { info in
      weakSelf?.signallingCallback(nil, info.toDic(), resultCallback)
    } failure: { error in
      weakSelf?.signallingCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(subscriptionClassName, desc: "call error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 关闭信令房间接口
   *  该接口调用后会触发关闭通知给房间内所有人
   *  房间内的所有人均可以调用该接口
   * @param channelId 频道ID。房间的唯一标识
   * @param offlineEnabled 是否需要存离线消息。YES：需要；NO：不需要。如果存离线，则用户离线再上线会收到该通知
   * @param serverExtension 服务端扩展字段， 长度限制4096
   * @param success 成功的回调
   * @param failure 失败的回调
   */
  func closeRoom(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let channelId = arguments["channelId"] as? String,
          let offlineEnabled = arguments["offlineEnabled"] as? Bool else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let serverExtension = arguments["serverExtension"] as? String
    NIMSDK.shared().v2SignallingService.closeRoom(channelId, offlineEnabled: offlineEnabled, serverExtension: serverExtension) {
      weakSelf?.signallingCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.signallingCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(subscriptionClassName, desc: "call error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 加入信令房间接口
   *  该接口调用后会触发加入通知给房间内所有人
   * @param param 加入信令房间相关参数
   * @param success 成功的回调
   * @param failure 失败的回调
   */
  func joinRoom(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramJson = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let param = V2NIMSignallingJoinParams.fromDic(paramJson)
    NIMSDK.shared().v2SignallingService.joinRoom(param) { info in
      weakSelf?.signallingCallback(nil, info.toDic(), resultCallback)
    } failure: { error in
      weakSelf?.signallingCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(subscriptionClassName, desc: "call error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 离开信令房间接口
   *  该接口调用后会触发离开通知给房间内所有人
   * @param channelId 频道ID。房间的唯一标识
   * @param offlineEnabled 是否需要存离线消息。YES：需要；NO：不需要。如果存离线，则用户离线再上线会收到该通知
   * @param serverExtension 服务端扩展字段， 长度限制4096
   * @param success 成功的回调
   * @param failure 失败的回调
   */
  func leaveRoom(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let channelId = arguments["channelId"] as? String,
          let offlineEnabled = arguments["offlineEnabled"] as? Bool else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let serverExtension = arguments["serverExtension"] as? String
    NIMSDK.shared().v2SignallingService.leaveRoom(channelId, offlineEnabled: offlineEnabled, serverExtension: serverExtension) {
      weakSelf?.signallingCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.signallingCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(subscriptionClassName, desc: "call error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 邀请成员加入信令房间接口
   *  该接口调用后会触发邀请通知给对方， 发送方可以配置是否需要发送推送
   *      默认不推送
   *      如果不配置推送相关信息， 则服务器回填默认内容
   *          音频： xx邀请你进行语音通话
   *          视频：xx邀请你进行视频通话
   *          其它： xx邀请你进行音视频通话
   *  房间内的人均可以发送邀请
   * @param param 邀请成员加入信令房间接口参数
   * @param success 成功的回调
   * @param failure 失败的回调
   */
  func invite(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramJson = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let param = V2NIMSignallingInviteParams.fromDic(paramJson)
    NIMSDK.shared().v2SignallingService.invite(param) {
      weakSelf?.signallingCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.signallingCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(subscriptionClassName, desc: "call error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 取消之前的邀请成员加入信令房间接口
   *  该接口调用后会触发取消邀请通知给对方
   * @param param 取消之前的邀请成员加入信令房间接口参数
   * @param success 成功的回调
   * @param failure 失败的回调
   */
  func cancelInvite(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramJson = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let param = V2NIMSignallingCancelInviteParams.fromDic(paramJson)
    NIMSDK.shared().v2SignallingService.cancelInvite(param) {
      weakSelf?.signallingCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.signallingCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(subscriptionClassName, desc: "call error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 拒绝别人的邀请加入信令房间请求
   *  该接口调用后会触发拒绝邀请通知给对方
   * @param param 拒绝邀请加入信令房间接口参数
   * @param success 成功的回调
   * @param failure 失败的回调
   */
  func rejectInvite(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramJson = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let param = V2NIMSignallingRejectInviteParams.fromDic(paramJson)
    NIMSDK.shared().v2SignallingService.rejectInvite(param) {
      weakSelf?.signallingCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.signallingCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(subscriptionClassName, desc: "call error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 接受别人的邀请加入信令房间请求。该接口调用后会触发接受邀请通知给对方
   * @param param 接受邀请加入信令房间接口参数
   * @param success 成功的回调
   * @param failure 失败的回调
   */
  func acceptInvite(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramJson = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let param = V2NIMSignallingAcceptInviteParams.fromDic(paramJson)
    NIMSDK.shared().v2SignallingService.acceptInvite(param) {
      weakSelf?.signallingCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.signallingCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(subscriptionClassName, desc: "call error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 发送自定义控制指令，可以实现自定义相关的业务逻辑
   * 可以发送给指定用户， 如果不指定， 则发送给信令房间内的所有人
   * 该接口不做成员校验， 允许非频道房间内的成员调用， 但是接受者必须在频道房间内或者是创建者
   * 接口调用后会发送一个控制通知
   *  如果指定了接受者： 则通知发送给接受者
   *  如果未指定接受者：则发送给房间内的所有人
   *  通知仅发在线
   * @param channelId 频道ID。房间的唯一标识
   * @param receiverAccountId 接受者ID， 如果该字段为空， 则表示发送给房间内的所有人
   * @param serverExtension 服务端扩展字段， 长度限制4096。自定义控制数据；建议json格式
   * @param success 成功的回调
   * @param failure 失败的回调
   */
  func sendControl(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let channelId = arguments["channelId"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let receiverAccountId = arguments["receiverAccountId"] as? String
    let serverExtension = arguments["serverExtension"] as? String
    NIMSDK.shared().v2SignallingService.sendControl(channelId,
                                                    receiverAccountId: receiverAccountId,
                                                    serverExtension: serverExtension) {
      weakSelf?.signallingCallback(nil, nil, resultCallback)
    } failure: { error in
      weakSelf?.signallingCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(subscriptionClassName, desc: "call error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 根据频道名称查询频道房间信息
   * 相同的频道名，在服务器同时只能存在一个
   * @param channelName 频道名称，为空返回参数错误
   * @param success 成功的回调
   * @param failure 失败的回调
   */
  func getRoomInfoByChannelName(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let channelName = arguments["channelName"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2SignallingService.getRoomInfo(byChannelName: channelName) { info in
      weakSelf?.signallingCallback(nil, info.toDic(), resultCallback)
    } failure: { error in
      weakSelf?.signallingCallback(error.nserror, nil, resultCallback)
      FLTALog.errorLog(subscriptionClassName, desc: "call error \(error.nserror.localizedDescription)")
    }
  }
}

extension FLTSignallingService: V2NIMSignallingListener {
  /**
   * 在线事件回调
   * @param event 在线状态事件回调，包括以下状态：关闭房间、加入房间、离开房间、邀请加入房间、取消邀请加入房间、拒绝加入邀请、接受加入邀请、控制事件
   */
  func onOnlineEvent(_ event: V2NIMSignallingEvent) {
    let arguments = event.toDic()
    notifyEvent(serviceName(), "onOnlineEvent", arguments)
  }

  /**
   * 离线事件回调
   * @param event 离线状态事件回调，包括以下状态：关闭房间、加入房间、离开房间、邀请加入房间、取消邀请加入房间、拒绝加入邀请、接受加入邀请、控制事件
   */
  func onOfflineEvent(_ event: [V2NIMSignallingEvent]) {
    let arguments = event.map { $0.toDic() }
    notifyEvent(serviceName(), "onOfflineEvent", ["offlineEvents": arguments])
  }

  /**
   * 多端事件操作同步回调
   * @param event 多端事件操作回调，包括以下状态：拒绝加入邀请、接受加入邀请
   */
  func onMultiClientEvent(_ event: V2NIMSignallingEvent) {
    let arguments = event.toDic()
    notifyEvent(serviceName(), "onMultiClientEvent", arguments)
  }

  /**
   * 登录后，同步还在的信令频道房间列表
   * @param channelRooms 用户登录SDK后，同步获取当前未退出的信令频道列表
   */
  func onSyncRoomInfoList(_ channelRooms: [V2NIMSignallingRoomInfo]) {
    let arguments = channelRooms.map { $0.toDic() }
    notifyEvent(serviceName(), "onSyncRoomInfoList", ["syncRoomInfoList": arguments])
  }
}
