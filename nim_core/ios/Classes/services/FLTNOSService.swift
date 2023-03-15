// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum NOSType: String {
  case Upload = "upload"
  case Download = "download"
}

class FLTNOSService: FLTBaseService, FLTService {
  // MARK: Service Protocol

  func serviceName() -> String {
    ServiceType.NOSService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case NOSType.Upload.rawValue:
      upload(arguments, resultCallback)
    case NOSType.Download.rawValue:
      download(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func upload(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let filePath = arguments["filePath"] as? String else {
      resultCallback.result(NimResult.error(414, "upload but the filePath is empty!").toDic())
      return
    }
    _ = arguments["mimeType"] as? String ?? "image/jpeg"
    let sceneKey = arguments["sceneKey"] as? String
    let md5 = arguments["md5"] as? String

    let info = NIMResourceExtraInfo()
    info.md5 = md5
    info.scene = sceneKey

    var map: [String: Any] = ["transferType": "upload"]
    if !filePath.isEmpty {
      map["path"] = filePath
    }
    if md5 != nil, !md5!.isEmpty {
      map["md5"] = md5
    }
    map["status"] = "transferring"
    notifyEvent(serviceName(), "onNOSTransferStatus", map)

    NIMSDK.shared().resourceManager.upload(filePath, extraInfo: info) { progress in
      self.notifyEvent(self.serviceName(), "onNOSTransferProgress", ["progress": progress])
    } completion: { url, error in
      if error != nil {
        let nserror = error! as NSError
        let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
        resultCallback.result(result.toDic())
      } else {
        let result = NimResult(url, 0, nil)
        resultCallback.result(result.toDic())
      }
      if url == nil || url!.isEmpty {
        self.notifyEvent(self.serviceName(), "onNOSTransferStatus", nil)
      } else {
        var map: [String: Any] = ["transferType": "upload"]
        if !filePath.isEmpty {
          map["path"] = filePath
        }
        if md5 != nil, !md5!.isEmpty {
          map["md5"] = md5
        }
        if url != nil, !url!.isEmpty {
          map["url"] = url
        }
        map["status"] = error == nil ? "transferred" : "fail"
        self.notifyEvent(self.serviceName(), "onNOSTransferStatus", map)
      }
    }
  }

  func download(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let url = arguments["url"] as? String,
          let path = arguments["path"] as? String else {
      resultCallback.result(NimResult.error(414, "download but the url or path is empty!").toDic())
      return
    }
    var map: [String: Any] = ["transferType": "download"]
    map["url"] = url
    map["status"] = "transferring"
    notifyEvent(serviceName(), "onNOSTransferStatus", map)

    NIMSDK.shared().resourceManager.download(url, filepath: path) { progress in
      self.notifyEvent(self.serviceName(), "onNOSTransferProgress", ["progress": progress])
    } completion: { error in
      if error != nil {
        let nserror = error! as NSError
        let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
        resultCallback.result(result.toDic())
      } else {
        let result = NimResult(nil, 0, nil)
        resultCallback.result(result.toDic())
      }
      var map: [String: Any] = ["transferType": "download"]
      map["url"] = url
      map["status"] = error == nil ? "transferred" : "fail"
      self.notifyEvent(self.serviceName(), "onNOSTransferStatus", map)
    }
  }
}
