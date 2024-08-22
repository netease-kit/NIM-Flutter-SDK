// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

enum QChatPushMethod: String {
  case setPushConfig
  case getPushConfig
}

class FLTQChatPushService: FLTBaseService, FLTService {
  private let paramErrorTip = "参数错误"
  private let paramErrorCode = 414

  override func onInitialized() {
    NIMSDK.shared().qchatApnsManager.add(self)
  }

  deinit {
    NIMSDK.shared().qchatApnsManager.remove(self)
  }

  func serviceName() -> String {
    ServiceType.QChatPushService.rawValue
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case QChatPushMethod.setPushConfig.rawValue:
      qChatSetPushConfig(arguments, resultCallback)
    case QChatPushMethod.getPushConfig.rawValue:
      qChatGetPushConfig(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func qChatPushCallback(_ error: Error?, _ data: Any?, _ resultCallback: ResultCallback) {
    if let ns_error = error as NSError? {
      errorCallBack(resultCallback, ns_error.description, ns_error.code)
    } else {
      successCallBack(resultCallback, data)
    }
  }

  func qChatSetPushConfig(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMPushNotificationSetting.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatApnsManager.updateApnsSetting(request) { [weak self] error in
      self?.qChatPushCallback(error, nil, resultCallback)
    }
  }

  func qChatGetPushConfig(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let result = NIMSDK.shared().qchatApnsManager.currentSetting()
    if let res = result {
      successCallBack(resultCallback, res.toDict())
    } else {
      errorCallBack(resultCallback, "❌return value is nil")
    }
  }
}

extension FLTQChatPushService: NIMQChatApnsManagerDelegate {}
