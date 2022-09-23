// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum EventSubscribeType: String {
  case RegisterEventSubscribe = "registerEventSubscribe"
  case UnregisterEventSubscribe = "unregisterEventSubscribe"
  case BatchUnSubscribeEvent = "batchUnSubscribeEvent"
  case PublishEvent = "publishEvent"
  case QuerySubscribeEvent = "querySubscribeEvent"
}

class FLTEventSubscribeService: FLTBaseService, FLTService {
//    override init() {
//        super.init()
//        NIMSDK.shared().subscribeManager.add(self)
//    }

  override func onInitialized() {
    NIMSDK.shared().subscribeManager.add(self)
  }

  deinit {
    NIMSDK.shared().subscribeManager.remove(self)
  }

  // MARK: Service Protocol

  func serviceName() -> String {
    ServiceType.EventSubscribeService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case EventSubscribeType.RegisterEventSubscribe.rawValue:
      registerEventSubscribe(arguments, resultCallback)
    case EventSubscribeType.UnregisterEventSubscribe.rawValue:
      unregisterEventSubscribe(arguments, resultCallback)
    case EventSubscribeType.PublishEvent.rawValue:
      publishEvent(arguments, resultCallback)
    case EventSubscribeType.QuerySubscribeEvent.rawValue:
      querySubscribeEvent(arguments, resultCallback)
    case EventSubscribeType.BatchUnSubscribeEvent.rawValue:
      batchUnSubscribeEvent(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  // MARK: Public Method

  func registerEventSubscribe(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMSubscribeRequest.yx_model(with: arguments) else {
      let result = NimResult(nil, -1, "registerEventSubscribe but the args are invalid")
      resultCallback.result(result.toDic())
      return
    }
    if request.type < 0 {
      let result = NimResult(
        nil,
        -1,
        "registerEventSubscribe eventType must be greater than 0"
      )
      resultCallback.result(result.toDic())
      return
    }
    NIMSDK.shared().subscribeManager.subscribeEvent(request) { error, ret in
      guard let nserror = error as NSError? else {
        if ret != nil, ret!.count > 0 {
          let result = NimResult(["resultList": ret], 0, nil)
          resultCallback.result(result.toDic())
        } else {
          let result = NimResult(nil, 0, nil)
          resultCallback.result(result.toDic())
        }
        return
      }
      let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
      resultCallback.result(result.toDic())
    }
  }

  func unregisterEventSubscribe(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMSubscribeRequest.yx_model(with: arguments) else {
      let result = NimResult(nil, -1, "unregisterEventSubscribe but the args are invalid")
      resultCallback.result(result.toDic())
      return
    }
    if request.type < 0 {
      let result = NimResult(
        nil,
        -1,
        "unregisterEventSubscribe eventType must be greater than 0"
      )
      resultCallback.result(result.toDic())
      return
    }
    NIMSDK.shared().subscribeManager.unSubscribeEvent(request) { error, ret in
      guard let nserror = error as NSError? else {
        if ret != nil, ret!.count > 0 {
          let result = NimResult(ret, 0, nil)
          resultCallback.result(result.toDic())
        } else {
          let result = NimResult(nil, 0, nil)
          resultCallback.result(result.toDic())
        }
        return
      }
      let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
      resultCallback.result(result.toDic())
    }
  }

  func publishEvent(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let event = NIMSubscribeEvent.createSubscribeEvent(arguments) else {
      let result = NimResult(nil, -1, "publishEvent but the args are invalid")
      resultCallback.result(result.toDic())
      return
    }
    if event.type < 0 {
      let result = NimResult(nil, -1, "publishEvent eventType must be greater than 0")
      resultCallback.result(result.toDic())
      return
    }

    NIMSDK.shared().subscribeManager.publishEvent(event, completion: { error, ret in
      guard let nserror = error as NSError? else {
        resultCallback.result(NimResult.success().toDic())
        return
      }
      let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
      resultCallback.result(result.toDic())
    })
  }

  func querySubscribeEvent(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMSubscribeRequest.yx_model(with: arguments) else {
      let result = NimResult(nil, -1, "querySubscribeEvent but the args are invalid")
      resultCallback.result(result.toDic())
      return
    }
    if request.type < 0 {
      let result = NimResult(nil, -1, "querySubscribeEvent eventType must be greater than 0")
      resultCallback.result(result.toDic())
      return
    }
    NIMSDK.shared().subscribeManager.querySubscribeEvent(request) { error, ret in
      guard let nserror = error as NSError? else {
        if ret == nil {
          let result = NimResult(nil, 0, nil)
          resultCallback.result(result.toDic())
        } else {
          // 可以用map，后续优化
          var array: [[String: Any?]] = .init()
          for subscribeResult in ret! {
            if let s = subscribeResult as? NIMSubscribeResult,
               let dic = s.toDic() {
              array.append(dic)
            }
          }
          let result = NimResult(["eventSubscribeResultList": array], 0, nil)
          resultCallback.result(result.toDic())
        }
        return
      }
      let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
      resultCallback.result(result.toDic())
    }
  }

  func batchUnSubscribeEvent(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMSubscribeRequest.yx_model(with: arguments) else {
      let result = NimResult(nil, -1, "batchUnSubscribeEvent but the args are invalid")
      resultCallback.result(result.toDic())
      return
    }
    if request.type < 0 {
      let result = NimResult(
        nil,
        -1,
        "batchUnSubscribeEvent eventType must be greater than 0"
      )
      resultCallback.result(result.toDic())
      return
    }
    // publisher不传则为取消所有
    request.publishers = [Any]()
    NIMSDK.shared().subscribeManager.unSubscribeEvent(request) { error, ret in
      guard let nserror = error as NSError? else {
        if ret != nil, ret!.count > 0 {
          let result = NimResult(ret, 0, nil)
          resultCallback.result(result.toDic())
        } else {
          let result = NimResult(nil, 0, nil)
          resultCallback.result(result.toDic())
        }
        return
      }
      let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
      resultCallback.result(result.toDic())
    }
  }
}

extension FLTEventSubscribeService: NIMEventSubscribeManagerDelegate {
  func onRecvSubscribeEvents(_ events: [Any]) {
    // 可以用map，后续优化
    var array = [[String: Any?]]()
    for evnet in events {
      if let e = evnet as? NIMSubscribeEvent,
         let dic = e.toDic() {
        array.append(dic)
      }
    }
    notifyEvent(serviceName(), "observeEventChanged", ["eventList": array])
  }
}
