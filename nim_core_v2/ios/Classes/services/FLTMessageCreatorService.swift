// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

enum MessageCreatorType: String {
  case createTextMessage
  case createImageMessage
  case createAudioMessage
  case createVideoMessage
  case createFileMessage
  case createLocationMessage
  case createCustomMessage
  case createForwardMessage
  case createTipsMessage
  case createCallMessage
}

class FLTMessageCreatorService: FLTBaseService, FLTService {
  func serviceName() -> String {
    ServiceType.MessageCreatorService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any], _ resultCallback: ResultCallback) {
    switch MessageCreatorType(rawValue: method) {
    case .createTextMessage:
      createTextMessage(arguments, resultCallback)
    case .createImageMessage:
      createImageMessage(arguments, resultCallback)
    case .createAudioMessage:
      createAudioMessage(arguments, resultCallback)
    case .createVideoMessage:
      createVideoMessage(arguments, resultCallback)
    case .createFileMessage:
      createFileMessage(arguments, resultCallback)
    case .createLocationMessage:
      createLocationMessage(arguments, resultCallback)
    case .createCustomMessage:
      createCustomMessage(arguments, resultCallback)
    case .createForwardMessage:
      createForwardMessage(arguments, resultCallback)
    case .createTipsMessage:
      createTipsMessage(arguments, resultCallback)
    case .createCallMessage:
      createCallMessage(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  /// 创建文本消息
  func createTextMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let text = arguments["text"] as? String else {
      parameterError(resultCallback)
      return
    }
    let message = V2NIMMessageCreator.createTextMessage(text)
    successCallBack(resultCallback, message.toDict())
  }

  /// 创建音频消息
  func createAudioMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let path = arguments["audioPath"] as? String, let duration = arguments["duration"] as? Int32 else {
      parameterError(resultCallback)
      return
    }

    let name = arguments["name"] as? String
    let sceneName = arguments["sceneName"] as? String

    let message = V2NIMMessageCreator.createAudioMessage(path, name: name, sceneName: sceneName, duration: duration)
    successCallBack(resultCallback, message.toDict())
  }

  /// 创建图片消息
  func createImageMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let imagePath = arguments["imagePath"] as? String, let width = arguments["width"] as? Int32, let height = arguments["height"] as? Int32 else {
      parameterError(resultCallback)
      return
    }
    let name = arguments["name"] as? String
    let sceneName = arguments["sceneName"] as? String
    let message = V2NIMMessageCreator.createImageMessage(imagePath, name: name, sceneName: sceneName, width: width, height: height)
    successCallBack(resultCallback, message.toDict())
  }

  /// 创建视频消息
  func createVideoMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let videoPath = arguments["videoPath"] as? String, let duration = arguments["duration"] as? Int32, let width = arguments["width"] as? Int32, let height = arguments["height"] as? Int32 else {
      parameterError(resultCallback)
      return
    }
    let name = arguments["name"] as? String
    let sceneName = arguments["sceneName"] as? String
    let message = V2NIMMessageCreator.createVideoMessage(videoPath, name: name, sceneName: sceneName, duration: duration, width: width, height: height)
    successCallBack(resultCallback, message.toDict())
  }

  /// 创建文件消息
  func createFileMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let filePath = arguments["filePath"] as? String else {
      parameterError(resultCallback)
      return
    }
    let name = arguments["name"] as? String
    let sceneName = arguments["sceneName"] as? String
    let message = V2NIMMessageCreator.createFileMessage(filePath, name: name, sceneName: sceneName)
    successCallBack(resultCallback, message.toDict())
  }

  /// 创建地理位置消息
  func createLocationMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let latitude = arguments["latitude"] as? Double, let longitude = arguments["longitude"] as? Double, let address = arguments["address"] as? String else {
      parameterError(resultCallback)
      return
    }

    let message = V2NIMMessageCreator.createLocationMessage(latitude, longitude: longitude, address: address)
    successCallBack(resultCallback, message.toDict())
  }

  /// 创建自定义消息
  func createCustomMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let text = arguments["text"] as? String, let rawAttachment = arguments["rawAttachment"] as? String else {
      parameterError(resultCallback)
      return
    }
    let message = V2NIMMessageCreator.createCustomMessage(text, rawAttachment: rawAttachment)
    successCallBack(resultCallback, message.toDict())
  }

  /// 创建tips消息
  func createTipsMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let text = arguments["text"] as? String else {
      parameterError(resultCallback)
      return
    }
    let message = V2NIMMessageCreator.createTipsMessage(text)
    successCallBack(resultCallback, message.toDict())
  }

  /// 创建转发消息
  func createForwardMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    let message = V2NIMMessage.fromDict(messageDic)
    let forwardMessage = V2NIMMessageCreator.createForwardMessage(message)
    successCallBack(resultCallback, forwardMessage.toDict())
  }

  /// 创建话单消息
  func createCallMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let type = arguments["type"] as? Int, let channelId = arguments["channelId"] as? String, let status = arguments["status"] as? Int, let durations = arguments["durations"] as? [[String: Any]], let text = arguments["text"] as? String else {
      parameterError(resultCallback)
      return
    }
    var callDurations = [V2NIMMessageCallDuration]()
    for duration in durations {
      let callDuration = V2NIMMessageCallDuration.fromDict(duration)
      callDurations.append(callDuration)
    }
    let message = V2NIMMessageCreator.createCallMessage(text, type: type, channelId: channelId, status: status, durations: callDurations)
    successCallBack(resultCallback, message.toDict())
  }
}
