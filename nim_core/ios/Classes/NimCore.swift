// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

let kFLTNimCoreService = "serviceName"

class NimCore {
  private var services = [String: FLTService]()

  private var safeMethodChannel: SafeMethodChannel?

  private var controller: UIViewController?

  private var initialized = false

  init(_ channel: SafeMethodChannel?, _ controller: UIViewController?) {
    safeMethodChannel = channel
    self.controller = controller
  }

  func notifyOnInitialized() {
    if !initialized {
      print("onInitialized")
      initialized = true
      services.forEach { key, service in
        service.onInitialized()
      }
    }
  }

  func isInitialized() -> Bool {
    if !initialized {
      if let appkey = NIMSDK.shared().appKey() {
        if appkey.count > 0 {
          notifyOnInitialized()
        }
      }
    }
    return initialized
  }

  func addService(_ service: FLTService) {
    services[service.serviceName()] = service
  }

  func getService(_ name: String) -> FLTService? {
    services[name]
  }

  func setController(_ controller: UIViewController?) {
    self.controller = controller
  }

  func setMethodChannel(_ safeMethodChannel: SafeMethodChannel?) {
    self.safeMethodChannel = safeMethodChannel
  }

  func getMethodChannel() -> SafeMethodChannel? {
    safeMethodChannel
  }

  func onMethodCall(_ method: String, _ arguments: [String: Any],
                    resultCallback: ResultCallback) {
    print("========================== \(method) ==========================")
    dump(arguments)
    print("========================== \(method) ==========================")
    if let serviceName = arguments[kFLTNimCoreService] as? String {
      if let service = getService(serviceName) {
        if !isInitialized(), serviceName != ServiceType.LifeCycleService.rawValue {
          resultCallback.result(NimResult.error("sdk is uninitialized").toDic())
          return
        }

        service.onMethodCalled(method, arguments, resultCallback)
      }
    } else {
      resultCallback.notImplemented()
    }
  }
}
