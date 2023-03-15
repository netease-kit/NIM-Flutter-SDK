// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

class FLTBaseService: NSObject {
  weak var nimCore: NimCore?

  // MARK: - message

  func getMessageAttachment(_ argments: [String: Any]) -> [String: Any]? {
    if let attach = argments["messageAttachment"] as? [String: Any] {
      return attach
    } else if let attach = argments["attachment"] as? [String: Any] {
      return attach
    } else {
      return nil
    }
  }

  func getCustomSetting(_ argments: [String: Any]) -> NIMMessageSetting? {
    if let configJsonObject = argments["config"] as? [String: Any] {
      return NIMMessageSetting.yx_model(with: configJsonObject)
    }
    return nil
  }

  func getScene(_ attachment: [String: Any]?) -> String {
    if let nosScene = attachment?["sen"] as? String,
       let nimNosScene = NIMNosScene(rawValue: nosScene) {
      return nimNosScene.getScene()
    }
    return NIMNosScene.defaultIm.getScene()
  }

  func getAttachmentPath(_ attachment: [String: Any]?) -> String? {
    attachment?["path"] as? String
  }

  func getAttachmentDisplayName(_ attachment: [String: Any]?) -> String? {
    if let path = attachment?["name"] as? String {
      return path
    }
    return attachment?["displayName"] as? String
  }

  func getAttachmentSize(_ attachment: [String: Any]?) -> Int? {
    attachment?["size"] as? Int
  }

  func getDur(_ arguments: [String: Any]?) -> Int {
    if let duration = arguments?["dur"] as? Int {
      return duration
    }
    return 0
  }

  func getTeamId(_ arguments: [String: Any]) -> String? {
    if let teamId = arguments["teamId"] as? String {
      return teamId
    }
    return nil
  }

  func getRoomId(_ arguments: [String: Any]) -> String? {
    if let roomId = arguments["roomId"] as? String {
      return roomId
    }
    return nil
  }

  func getUserId(_ arguments: [String: Any]) -> String? {
    if let teamId = arguments["account"] as? String {
      return teamId
    }
    return nil
  }

  func notifyEvent(_ serviceName: String, _ method: String, _ arguments: [String: Any]?) {
    var args = arguments
    if args == nil {
      args = [String: Any]()
    }
    args!["serviceName"] = serviceName
    nimCore?.getMethodChannel()?.invokeMethod(method, args)
  }

  func notifyEvent(_ serviceName: String, _ method: String, _ arguments: [String: Any]?,
                   result: @escaping FlutterResult) {
    var args = arguments
    if args == nil {
      args = [String: Any]()
    }
    args!["serviceName"] = serviceName
    nimCore?.getMethodChannel()?.invokeMethod(method, args, result: result)
  }

  // MARK: - audio

  func getRecordAudioType(_ arguments: [String: Any]) -> NIMAudioType {
    if let type = arguments["recordType"] as? Int,
       let audioType = NIMAudioType(rawValue: type) {
      return audioType
    }
    return NIMAudioType.AAC
  }

  func getDuration(_ arguments: [String: Any]) -> Double {
    if let duration = arguments["maxLength"] as? Double {
      return duration
    }
    return 100
  }

  // MARK: - call back

  func successCallBack(_ resultCallback: ResultCallback, _ data: Any) {
    resultCallback.result(NimResult.success(data).toDic())
  }

  func successCallBack(_ resultCallback: ResultCallback, _ anyData: Any?) {
    if let data = anyData {
      resultCallback.result(NimResult.success(data).toDic())
    } else {
      resultCallback.result(NimResult.success().toDic())
    }
  }

  func errorCallBack(_ resultCallback: ResultCallback, _ msg: String) {
    resultCallback.result(NimResult.error(msg).toDic())
  }

  func errorCallBack(_ resultCallback: ResultCallback, _ msg: String, _ code: Int) {
    // 状态为“参数错误”时，SDK本应返回414，但是实际返回1，未与AOS对齐，此处进行手动对齐
    let cd = code == 1 ? 414 : code
    resultCallback.result(NimResult.error(cd, msg).toDic())
  }

  func onInitialized() {
    // do nothing
  }

  func DLog(s: String, file: String = #file, line: Int = #line) {
    if let filename = NSString(utf8String: file)?.lastPathComponent {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
      let dateInFormat = dateFormatter.string(from: NSDate() as Date)
      print("\(dateInFormat) \(s) [\(filename):\(line)]")
    }
  }
}
