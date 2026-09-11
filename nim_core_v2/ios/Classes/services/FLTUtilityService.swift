// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK
import YXAlog_iOS

enum UtilityServiceType: String {
  case exportMessagesToPath
  case importMessagesFromPath
  case cancelMigrateMessages
}

class FLTUtilityService: FLTBaseService, FLTService {
  private static let className = "FLTUtilityService"

  func serviceName() -> String {
    ServiceType.UtilityService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case UtilityServiceType.exportMessagesToPath.rawValue:
      exportMessagesToPath(arguments, resultCallback)
    case UtilityServiceType.importMessagesFromPath.rawValue:
      importMessagesFromPath(arguments, resultCallback)
    case UtilityServiceType.cancelMigrateMessages.rawValue:
      cancelMigrateMessages(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  // MARK: - 导出消息到指定路径

  func exportMessagesToPath(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let optionDic = arguments["option"] as? [String: Any],
          let filePath = optionDic["path"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let option = V2NIMExportMessageOption()
    option.path = filePath

    NIMSDK.shared().v2UtilityService.exportMessages(toPath: option) { exportedPath in
      weakSelf?.successCallBack(resultCallback, exportedPath)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTUtilityService.className, desc: "exportMessagesToPath error \(error.nserror.localizedDescription)")
    } progress: { progress in

      weakSelf?.notifyEvent(ServiceType.UtilityService.rawValue,
                            "onMessagesProgress",
                            ["progress": progress])
    }
  }

  // MARK: - 从指定路径导入消息

  func importMessagesFromPath(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let optionDic = arguments["option"] as? [String: Any],
          let filePath = optionDic["path"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let option = V2NIMImportMessageOption()
    option.path = filePath

    NIMSDK.shared().v2UtilityService.importMessages(fromPath: option) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTUtilityService.className, desc: "importMessagesFromPath error \(error.nserror.localizedDescription)")
    } progress: { progress in
      weakSelf?.notifyEvent(ServiceType.UtilityService.rawValue,
                            "onMessagesProgress",
                            ["progress": progress])
    }
  }

  // MARK: - 取消当前导入/导出消息

  func cancelMigrateMessages(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    NIMSDK.shared().v2UtilityService.cancelMigrateMessages()
    successCallBack(resultCallback, nil)
  }
}
