// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

class FLTInitializeService: FLTService {
  weak var nimCore: NimCore?

  var flutterVersionName: String?

  var isInitLog = false

  func serviceName() -> String {
    ServiceType.LifeCycleService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    if method == "initialize" {
      initSDK(arguments, resultCallback)
    } else {
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  private func initSDK(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if isInitLog == false {
      isInitLog = true
      FLTALog.setUp()
    }
    if let config = NIMSDKConfig.yx_model(with: arguments) {
      let keyPaths = NIMSDKConfig.getKeyPaths(NIMSDKConfig.self)
      for (key, value) in keyPaths {
        if key != "hash", key != "debugDescription", key != "description", key != "superclass" {
          NIMSDKConfig.shared().setValue(config.value(forKey: key), forKeyPath: key)
        }
      }
    }

    if let extras = arguments["extras"] as? [String: Any] {
      flutterVersionName = extras["versionName"] as? String
      if flutterVersionName != nil {
        NIMSDKConfig.shared().flutterSDKVersion = flutterVersionName ?? ""
      }
    }
    if let enableFcs = arguments["enableFcs"] as? Bool {
      NIMSDKConfig.shared().fcsEnable = enableFcs
    }
    // 修复配置未打开问题
    if arguments["enablePreloadMessageAttachment"] as? Bool == nil {
      NIMSDKConfig.shared().fetchAttachmentAutomaticallyAfterReceiving = true
    }

    if let sdkDir = arguments["sdkRootDir"] as? String {
      NIMSDKConfig.shared().setupSDKDir(sdkDir)
    }

    if let enableDatabaseBackup = arguments["enableDatabaseBackup"] as? Bool {
      NIMSDKConfig.shared().sessionDatabaseBackupEnabled = enableDatabaseBackup
    }

    if let serverConfig = arguments["serverConfig"] as? [String: Any] {
      if let serverSetting = NIMServerSetting.fromDic(serverConfig) {
        NIMSDK.shared().serverSetting = serverSetting
      }
    }

    let option = NIMSDKOption.fromDic(arguments)
    let v2Option = V2NIMSDKOption.fromDic(arguments)
    if let enableServerV2FriendAddApplication = arguments["enableServerV2FriendAddApplication"] as? Bool {
      v2Option.enableServerV2FriendAddApplication = enableServerV2FriendAddApplication
    }
    NIMSDK.shared().register(withOptionV2: option, v2Option: v2Option)

    if let nosSceneConfig = arguments["nosSceneConfig"] as? [String: Any] {
      let sceneDict = NSMutableDictionary()
      for (key, value) in nosSceneConfig {
        if let noScene = NIMNosScene(rawValue: key)?.getScene() {
          sceneDict.setValue(value, forKey: noScene)
        }
      }
      NIMSDK.shared().sceneDict = NSMutableDictionary()
    }

    // 开启群回执功能
    if let teamReceiptEnabled = arguments["enableTeamMessageReadReceipt"] as? Bool {
      NIMSDKConfig.shared().teamReceiptEnabled = teamReceiptEnabled
    }

    if let enableServerV2TeamJoinActionInfo = arguments["enableServerV2TeamJoinActionInfo"] as? Bool {
      v2Option.enableServerV2TeamJoinActionInfo = enableServerV2TeamJoinActionInfo
    }

    // 配置 APNs Token 自动更新选项
    if let autoUpdateApnsToken = arguments["autoUpdateApnsToken"] as? Bool {
      if let apnsService = nimCore?.getService(ServiceType.APNSService.rawValue) as? FLTAPNSService {
        apnsService.autoUpdateApnsToken = autoUpdateApnsToken
      }
    }

    resultCallback.result(NimResult.success().toDic())

    nimCore?.notifyOnInitialized()
  }

  func onInitialized() {}
}
