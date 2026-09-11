// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

enum StatisticsServiceMethodType: String {
  case getDatabaseInfos
}

class FLTStatisticsService: FLTBaseService, FLTService {
  func serviceName() -> String {
    ServiceType.StatisticsService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case StatisticsServiceMethodType.getDatabaseInfos.rawValue:
      getDatabaseInfos(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  // MARK: - SDK API

  func getDatabaseInfos(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    weak var weakSelf = self
    NIMSDK.shared().v2StatisticsService.getDatabaseInfos { databaseInfoList in
      var result = [[String: Any]]()
      databaseInfoList.forEach { info in
        var item = [String: Any]()
        item["path"] = info.path
        item["name"] = info.name
        item["size"] = info.size
        result.append(item)
      }
      weakSelf?.successCallBack(resultCallback, ["databaseInfoList": result])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }
}
