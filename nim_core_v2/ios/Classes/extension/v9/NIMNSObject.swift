// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation

extension NSObject {
  // endClass 遍历结束对象，通常只取当前对象成员变量列表即可
  class func getKeyPaths(_ endClass: AnyClass) -> [String: Any] {
    var keyPaths = [String: Any]()
    var array = [String]()
    recursiveGetProperty(&array, self, endClass)
    for key in array {
      keyPaths[key] = key
    }
    return keyPaths
  }

  // 递归遍历属性列表，处理多重继承的case
  class func recursiveGetProperty(_ array: inout [String], _ cls: AnyClass,
                                  _ endClass: AnyClass) {
    var outCount: UInt32 = 0
    let propertyList = class_copyPropertyList(cls, &outCount)
    for i in 0 ..< Int(outCount) {
      if let pty = propertyList?[i] {
        let cName = property_getName(pty)
        if let oName = String(utf8String: cName) {
          array.append(oName)
        }
      }
    }
    free(propertyList)
    if String(cString: class_getName(cls)) == String(cString: class_getName(endClass.self)) {
      return
    }
    if let sCls = cls.superclass() {
      recursiveGetProperty(&array, sCls, endClass)
    }
  }

  func getVarPaths(_ cls: AnyClass) -> [String: Any] {
    var keyPaths = [String: Any]()
    var array = [String]()
    recursiveGetVar(&array, cls)
    for key in array {
      keyPaths[key] = key
    }
    return keyPaths
  }

  // 递归遍历属成员变量，处理多重继承的case
  func recursiveGetVar(_ array: inout [String], _ cls: AnyClass) {
    var outCount: UInt32 = 0
    let ivarList = class_copyIvarList(cls, &outCount)
    for i in 0 ..< Int(outCount) {
      if let pty = ivarList?[i], let cName = ivar_getName(pty) {
        if let oName = String(utf8String: cName) {
          array.append(oName)
        }
      }
    }
    free(ivarList)
  }

  func getDictionaryFromJSONString(_ jsonString: String) -> [String: Any]? {
    if let jsonData = jsonString.data(using: .utf8),
       let dic = try? JSONSerialization.jsonObject(
         with: jsonData,
         options: .mutableContainers
       ) as? [String: Any] {
      return dic
    }
    return nil
  }

  // MARK: - other

  func getJsonStringFromDictionary(_ dictionary: [String: Any]) -> String? {
    if !JSONSerialization.isValidJSONObject(dictionary) {
      return nil
    }
    if let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) {
      let jsonString = String(data: data, encoding: .utf8)
      return jsonString
    }
    return nil
  }

  func getArrayFromJSONString(_ jsonString: String) -> [String]? {
    if let jsonData = jsonString.data(using: .utf8),
       let arr = try? JSONSerialization.jsonObject(
         with: jsonData,
         options: .mutableContainers
       ) as? [String] {
      return arr
    }
    return nil
  }

  func getJsonStringFromArray(_ array: [Any]) -> String? {
    if !JSONSerialization.isValidJSONObject(array) {
      return nil
    }
    if let data = try? JSONSerialization.data(withJSONObject: array, options: []) {
      let jsonString = String(data: data, encoding: .utf8)
      return jsonString
    }
    return nil
  }
}

// extension Dictionary where Key == String, Value == Any {
//
//    mutating func setValue(_ value: Any, forkey key: String, filter: [String : String]) {
//        if filter[key] != nil {
//            self[key] = value
//        }
//    }
// }
