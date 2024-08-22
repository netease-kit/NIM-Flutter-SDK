// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum PassThroughType: String {
  case HttpProxy = "httpProxy"
}

class FLTPassThroughService: FLTBaseService, FLTService {
//    override init() {
//        super.init()
//        NIMSDK.shared().passThroughManager.add(self)
//    }

  override func onInitialized() {
    NIMSDK.shared().passThroughManager.add(self)
  }

  deinit {
    NIMSDK.shared().passThroughManager.remove(self)
  }

  // MARK: Service Protocol

  func serviceName() -> String {
    ServiceType.PassThroughService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case PassThroughType.HttpProxy.rawValue: httpProxy(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func httpProxy(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    if let proxyData = arguments["passThroughProxyData"] as? [String: Any],
       let req = NIMPassThroughHttpData.fromDic(proxyData) as? NIMPassThroughHttpData {
      NIMSDK.shared().passThroughManager.passThroughHttpReq(req) { data, error in
        if error != nil {
          let nserror = error! as NSError
          let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
          resultCallback.result(result.toDic())
        } else {
          let result = NimResult(data?.toDic(), 0, nil)
          resultCallback.result(result.toDic())
        }
      }
    } else {
      resultCallback.result(NimResult.error(-1, "arguments invalid").toDic())
    }
  }
}

extension FLTPassThroughService: NIMPassThroughManagerDelegate {
  func didReceivedPassThroughMsg(_ recvData: NIMPassThroughMsgData?) {
    if let data = recvData?.yx_modelToJSONObject() {
      notifyEvent(serviceName(), "onPassthrough", ["passthroughNotifyData": data])
    } else {
      notifyEvent(serviceName(), "onPassthrough", nil)
    }
  }
}
