// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation

@objc protocol NimDataConvertProtrol {
  func toDic() -> [String: Any]?

  static func fromDic(_ json: [String: Any]) -> Any?

  // 需要转换的属性
  @objc optional func convertProperty() -> [String: String]

  // 需要转换私有成员变量
  @objc optional func convertVar() -> [String: String]
}

extension NSObject {
  func extensionIvaToJson(_ jsonObject: inout [String: Any], _ cls: AnyClass) {
    if let convert = self as? NimDataConvertProtrol, let convertDic = convert.convertVar?() {
      let filter = getVarPaths(cls)
      convertDic.forEach { (key: String, value: String) in
        if filter[key] != nil {
          jsonObject[value] = self.value(forKey: key)
          jsonObject.removeValue(forKey: key)
        }
      }
    }
  }

  func extensionModelIva(_ jsonObject: [String: Any], _ cls: AnyClass) {
    if let convert = self as? NimDataConvertProtrol, let convertDic = convert.convertVar?() {
      let filter = getVarPaths(cls)
      convertDic.forEach { (key: String, value: String) in
        if filter[key] != nil {
          if let v = jsonObject[value] {
            self.setValue(v, forKeyPath: key)
          }
        }
      }
    }
  }
}
