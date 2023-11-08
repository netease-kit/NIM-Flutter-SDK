// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum AvSignalingMethod: String {
  case createChannel
  case closeChannel
  case joinChannel
  case leaveChannel
  case invite
  case cancelInvite
  case rejectInvite
  case acceptInvite
  case sendControl
  case call
  case queryChannelInfo
}

class FLTSignallingService: FLTBaseService, FLTService {
  override func onInitialized() {
    NIMSDK.shared().signalManager.add(self)
  }

  deinit {
    NIMSDK.shared().signalManager.remove(self)
  }

  func serviceName() -> String {
    ServiceType.AvSignallingService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case AvSignalingMethod.createChannel.rawValue:
      signalingCreateChannel(arguments, resultCallback)
    case AvSignalingMethod.closeChannel.rawValue:
      signalingCloseChannel(arguments, resultCallback)
    case AvSignalingMethod.joinChannel.rawValue:
      signalingJoinChannel(arguments, resultCallback)
    case AvSignalingMethod.leaveChannel.rawValue:
      signalingLeaveChannel(arguments, resultCallback)
    case AvSignalingMethod.invite.rawValue:
      signalingInvite(arguments, resultCallback)
    case AvSignalingMethod.cancelInvite.rawValue:
      signalingCancelInvite(arguments, resultCallback)
    case AvSignalingMethod.rejectInvite.rawValue:
      signalingReject(arguments, resultCallback)
    case AvSignalingMethod.acceptInvite.rawValue:
      signalingAccept(arguments, resultCallback)
    case AvSignalingMethod.sendControl.rawValue:
      signalingControl(arguments, resultCallback)
    case AvSignalingMethod.call.rawValue:
      signalingCall(arguments, resultCallback)
    case AvSignalingMethod.queryChannelInfo.rawValue:
      signalingQueryChannelInfo(arguments, resultCallback)

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

  func signalingCreateChannel(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let stringType = arguments["type"] as? String,
          let channelType = FLTSignalingChannelType(rawValue: stringType) else {
      print("signalingCreateChannel parameter is error, type is nil")
      errorCallBack(resultCallback, "parameter is error, type is nil")
      return
    }

    let request = NIMSignalingCreateChannelRequest()
    request.channelType = channelType.convertNIMSignalingChannelType()
    if let channelName = arguments["channelName"] as? String {
      request.channelName = channelName
    }

    if let channelExt = arguments["channelExt"] as? String {
      request.channelExt = channelExt
    }
    NIMSDK.shared().signalManager.signalingCreateChannel(request) { error, info in
      self.signallingCallback(error, info?.toDict(), resultCallback)
    }
  }

  func signalingCloseChannel(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let channelId = arguments["channelId"] as? String else {
      print("signalingCloseChannel parameter is error, channeId is nil")
      errorCallBack(resultCallback, "parameter is error, channeId is nil")
      return
    }

    let request = NIMSignalingCloseChannelRequest()
    request.channelId = channelId
    if let offlineEnabled = arguments["offlineEnabled"] as? Bool {
      request.offlineEnabled = offlineEnabled
    }

    if let customInfo = arguments["customInfo"] as? String {
      request.customInfo = customInfo
    }

    NIMSDK.shared().signalManager.signalingCloseChannel(request) { error in
      self.signallingCallback(error, nil, resultCallback)
    }
  }

  func signalingJoinChannel(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let channelId = arguments["channelId"] as? String else {
      errorCallBack(resultCallback, "paramater is error, channelId is nil")
      return
    }

    let request = NIMSignalingJoinChannelRequest()
    request.channelId = channelId
    if let selfUid = arguments["selfUid"] as? UInt64 {
      request.uid = selfUid
    }

    if let customInfo = arguments["customInfo"] as? String {
      request.customInfo = customInfo
    }

    if let offlineEnable = arguments["offlineEnabled"] as? Bool {
      request.offlineEnabled = offlineEnable
    }

    NIMSDK.shared().signalManager.signalingJoinChannel(request) { error, info in
      self.signallingCallback(error, info?.detailToDict(), resultCallback)
    }
  }

  func signalingLeaveChannel(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let channelId = arguments["channelId"] as? String else {
      errorCallBack(resultCallback, "paramater is error, channelId is nil")
      return
    }

    let request = NIMSignalingLeaveChannelRequest()
    request.channelId = channelId

    if let offlineEnabled = arguments["offlineEnabled"] as? Bool {
      request.offlineEnabled = offlineEnabled
    }

    if let customInfo = arguments["customInfo"] as? String {
      request.customInfo = customInfo
    }

    NIMSDK.shared().signalManager.signalingLeaveChannel(request) { error in
      self.signallingCallback(error, nil, resultCallback)
    }
  }

  func signalingInvite(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMSignalingInviteRequest.fromDic(arguments)

    NIMSDK.shared().signalManager.signalingInvite(request) { error in
      self.signallingCallback(error, nil, resultCallback)
    }
  }

  func signalingCancelInvite(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMSignalingCancelInviteRequest.fromDic(arguments)
    NIMSDK.shared().signalManager.signalingCancelInvite(request) { error in
      self.signallingCallback(error, nil, resultCallback)
    }
  }

  func signalingReject(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMSignalingRejectRequest.fromDic(arguments)
    NIMSDK.shared().signalManager.signalingReject(request) { error in
      self.signallingCallback(error, nil, resultCallback)
    }
  }

  func signalingAccept(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMSignalingAcceptRequest.fromDic(arguments)
    NIMSDK.shared().signalManager.signalingAccept(request) { error, info in
      self.signallingCallback(error, info?.detailToDict(), resultCallback)
    }
  }

  func signalingControl(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let channelId = arguments["channelId"] as? String else {
      errorCallBack(resultCallback, "paramater is error, channelId is nil")
      return
    }

    let request = NIMSignalingControlRequest()
    request.channelId = channelId

    if let accountId = arguments["accountId"] as? String {
      request.accountId = accountId
    }

    if let customInfo = arguments["customInfo"] as? String {
      request.customInfo = customInfo
    }

    NIMSDK.shared().signalManager.signalingControl(request) { error in
      self.signallingCallback(error, nil, resultCallback)
    }
  }

  func signalingCall(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMSignalingCallRequest.fromDic(arguments)
    NIMSDK.shared().signalManager.signalingCall(request) { error, info in
      self.signallingCallback(error, info?.detailToDict(), resultCallback)
    }
  }

  func signalingQueryChannelInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMSignalingQueryChannelRequest()
    if let channelName = arguments["channelName"] as? String {
      request.channelName = channelName
    }
    NIMSDK.shared().signalManager.signalingQueryChannelInfo(request) { error, info in
      self.signallingCallback(error, info?.detailToDict(), resultCallback)
    }
  }
}

extension FLTSignallingService: NIMSignalManagerDelegate {
  /**
   在线通知

   @param eventType 信令操作事件类型
   @param notifyResponse 信令通知回调数据
   @discussion 用于通知信令相关的在线通知  NIMSignalingEventType 1-8有效
   */
  func nimSignalingOnlineNotify(_ eventType: NIMSignalingEventType,
                                response notifyResponse: NIMSignalingNotifyInfo) {
    let arguments = notifyResponse.toDict()
    notifyEvent(serviceName(), "onlineNotification", arguments)
  }

  /**
   在线多端同步通知

   @param eventType 信令操作事件类型：这里只有接受和拒绝
   @param notifyResponse 信令通知回调数据
   @discussion 用于通知信令相关的多端同步通知。比如自己在手机端接受邀请，PC端会同步收到这个通知  NIMSignalingEventType 5-6有效
   */
  func nimSignalingMultiClientSyncNotify(_ eventType: NIMSignalingEventType,
                                         response notifyResponse: NIMSignalingNotifyInfo) {
    let arguments = notifyResponse.toDict()
    notifyEvent(serviceName(), "otherClientInviteAckNotification", arguments)
  }

  /**
   离线通知

   @param notifyResponse 信令通知回调数据
   @discussion 用于通知信令相关的离线通知信息。需要用户在调用相关接口时，打开存离线的开关。如果用户已经接收消息，该通知会在服务器标记已读，之后不会再收到该消息  NIMSignalingEventType 1-7有效
   */
  func nimSignalingOfflineNotify(_ notifyResponse: [NIMSignalingNotifyInfo]) {
    if notifyResponse.count > 0 {
      let eventList = notifyResponse.map {
        event in event.toDict()
      }
      notifyEvent(serviceName(), "offlineNotification", ["eventList": eventList])
    }
  }

  /**
   频道列表同步通知

   @param notifyResponse 信令通知回调数据
   @discussion 在login或者relogin后，会通知该设备账号还未退出的频道列表，用于同步；如果没有在任何频道中，也会返回该同步通知，list为空
   */
  func nimSignalingChannelsSyncNotify(_ notifyResponse: [NIMSignalingChannelDetailedInfo]) {
    if notifyResponse.count > 0 {
      let eventList = notifyResponse.map { event in
        ["channelFullInfo": event.detailToDict()]
      }
      notifyEvent(serviceName(), "syncChannelListNotification", ["eventList": eventList])
    }
  }

  /**
   房间成员同步通知

   @param notifyResponse 信令通知回调数据
   @discussion 用于同步频道内的成员列表变更，当前该接口为定时接口，2分钟同步一次，成员有变化时才上报。
   由于一些特殊情况，导致成员在离开或掉线前没有主动调用离开频道接口，使得该成员的离开没有对应的离开通知事件，由该回调接口【频道成员变更同步通知】告知用户
   */
  func nimSignalingMembersSyncNotify(_ notifyResponse: NIMSignalingChannelDetailedInfo) {
    notifyEvent(
      serviceName(),
      "onMemberUpdateNotification",
      ["channelFullInfo": notifyResponse.detailToDict() ?? []]
    )
  }
}
