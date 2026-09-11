// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

enum ClientAntispamUtilType: String {
  case checkTextAntispam
}

class FLTClientAntispamUtil: FLTBaseService, FLTService {
  func serviceName() -> String {
    ServiceType.ClientAntispamUtil.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case ClientAntispamUtilType.checkTextAntispam.rawValue:
      checkTextAntispam(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func checkTextAntispam(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let text = arguments["text"] as? String else {
      parameterError(resultCallback)
      return
    }
    let replace = arguments["replace"] as? String
    let result = V2NIMClientAntispamUtil.checkTextAntispam(text, replace: replace)
    successCallBack(resultCallback, result.toDic())
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }
}
