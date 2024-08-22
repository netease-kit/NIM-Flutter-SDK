// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension NIMPassThroughHttpData: NimDataConvertProtrol {
  @objc static func modelPropertyBlacklist() -> [String] {
    [#keyPath(NIMPassThroughHttpData.method)]
  }

  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["method"] = method.rawValue
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMPassThroughHttpData.yx_model(with: json) {
      if let method = json["method"] as? Int,
         let m = NIPassThroughHttpMethod(rawValue: method) {
        model.method = m
      }
      return model
    }
    return nil
  }
}
