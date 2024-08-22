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
    FLTEventSubscribeService().register(nimCore)
    FLTSystemNotificationService().register(nimCore)
    FLTUserService().register(nimCore)
    FLTAudioRecorderService().register(nimCore)
    FLTConversationService().register(nimCore)
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
    FLTNotificationService().register(nimCore)
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
  }
}
