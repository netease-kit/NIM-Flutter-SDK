// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation

class MethodCallHandlerImpl {
  private let tag = "FLTMethodCallHandlerImpl"
  private var safeMethodChannel: SafeMethodChannel?
  private let nimCore = NimCore(nil, nil)

  init() {
    FLTInitializeService().register(nimCore)
    FLTMessageService().register(nimCore)
    FLTClientAntispamUtil().register(nimCore)
    FLTChatRoomClient().register(nimCore)
    FLTChatRoomService().register(nimCore)
    FLTChatRoomQueueService().register(nimCore)
    FLTChatRoomMessageCreatorService().register(nimCore)
    FLTUserService().register(nimCore)
    FLTAudioRecorderService().register(nimCore)
    FLTConversationService().register(nimCore)
    FLTLocalConversationService().register(nimCore)
    FLTConversationGroupService().register(nimCore)
    FLTTeamService().register(nimCore)
    FLTNOSService().register(nimCore)
    FLTPassThroughService().register(nimCore)
    FLTSettingsService().register(nimCore)
    FLTSuperTeamService().register(nimCore)
    FLTChatExtendService().register(nimCore)
    FLTSignallingService().register(nimCore)
    FLTQChatChannelService().register(nimCore)
    FLTQChatPushService().register(nimCore)
    FLTQChatMessageService().register(nimCore)
    FLTQChatRoleService().register(nimCore)
    FLTQChatService().register(nimCore)
    FLTQChatServerService().register(nimCore)
    FLTLoginService().register(nimCore)
    FLTFriendService().register(nimCore)
    FLTMessageCreatorService().register(nimCore)
    FLTStorageService().register(nimCore)
    FLTAPNSService().register(nimCore)
    FLTConversationIdUtil().register(nimCore)
    FLTAIService().register(nimCore)
    FLTTopicService().register(nimCore)
    FLTNotificationService().register(nimCore)
    FLTSubscriptionService().register(nimCore)
    FLTStatisticsService().register(nimCore)
    FLTUtilityService().register(nimCore)
  }

  func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    let arguments = call.arguments as? [String: Any] ?? [String: Any]()
    nimCore.onMethodCall(call.method, arguments, resultCallback: ResultCallback(result))

    //        if let arguments = call.arguments as? [String : Any] {
    //            nimCore.onMethodCall(call.method, arguments,
    //            resultCallback: ResultCallback(result))
    //        }
  }

  @discardableResult
  func startListening(_ registrar: FlutterPluginRegistrar) -> SafeMethodChannel {
    if safeMethodChannel != nil {
      stopListening()
    }
    let channel = SafeMethodChannel("flutter.yunxin.163.com/nim_core", registrar.messenger())
    safeMethodChannel = channel
    nimCore.setMethodChannel(safeMethodChannel)
    return channel
  }

  func stopListening() {
    if safeMethodChannel == nil {
      return
    }
    safeMethodChannel = nil
    nimCore.setMethodChannel(nil)
    nimCore.signalSemaphores()
  }

  /// 获取 APNSService 实例，用于处理 APNs Token
  func getAPNSService() -> FLTAPNSService? {
    nimCore.getService(ServiceType.APNSService.rawValue) as? FLTAPNSService
  }
}
