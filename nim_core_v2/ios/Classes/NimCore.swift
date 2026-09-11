// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

let kFLTNimCoreService = "serviceName"

class NimCore {
  private var services = [String: FLTService]()

  private var semaphores = [DispatchSemaphore]()

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
      for (key, service) in services {
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

  func addSemaphore(_ semaphore: DispatchSemaphore) {
    semaphores.append(semaphore)
  }

  func signalSemaphores() {
    semaphores.forEach { $0.signal() }
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
