// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

class NimResult {
  @objc var data: Any?
  @objc var code: NSNumber?
  @objc var errorDetails: String?

  init(_ data: Any?, _ code: NSNumber, _ msg: String?) {
    self.data = data
    self.code = code
    errorDetails = msg
  }

  func toDic() -> [String: Any] {
    var dic = [String: Any]()
    dic["code"] = code
    dic["errorDetails"] = errorDetails
    if let convert = data as? NimDataConvertProtrol {
      dic["data"] = convert.toDic()
    } else if let message = data as? NIMMessage {
      dic["data"] = message.toDic()
    } else if let object = data as? NSObject, let jsonData = object.yx_modelToJSONObject() {
      dic["data"] = jsonData
    } else if let tData = data {
      // 兼容 data 字段为基本类型
      dic["data"] = tData
    }
    return dic
  }

  class func error(_ msg: String) -> NimResult {
    let nimResult = NimResult(nil, NSNumber(integerLiteral: -1), msg)
    return nimResult
  }

  class func error(_ code: Int, _ msg: String) -> NimResult {
    let nimResult = NimResult(nil, NSNumber(integerLiteral: code), msg)
    return nimResult
  }

  class func success(_ msg: String) -> NimResult {
    let nimResult = NimResult(nil, NSNumber(integerLiteral: 0), msg)
    return nimResult
  }

  class func success(_ data: Any?) -> NimResult {
    let nimResult = NimResult(data, NSNumber(integerLiteral: 0), nil)
    return nimResult
  }

  class func successStringData(data: String) -> NimResult {
    let nimResult = NimResult(data, NSNumber(integerLiteral: 0), nil)
    return nimResult
  }

  class func success() -> NimResult {
    let nimResult = NimResult(nil, NSNumber(integerLiteral: 0), nil)
    return nimResult
  }

  class func success(_ data: Any?, _ msg: String) -> NimResult {
    let nimResult = NimResult(data, NSNumber(integerLiteral: 0), nil)
    return nimResult
  }
}
