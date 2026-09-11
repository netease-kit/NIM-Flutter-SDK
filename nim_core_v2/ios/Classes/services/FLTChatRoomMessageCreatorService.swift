// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

enum ChatRoomMessageCreatorAPIType: String {
  case createTextMessage
  case createImageMessage
  case createAudioMessage
  case createVideoMessage
  case createFileMessage
  case createLocationMessage
  case createCustomMessage
  case createCustomMessageWithAttachmentAndSubType
  case createForwardMessage
  case createTipsMessage
}

class FLTChatRoomMessageCreatorService: FLTBaseService, FLTService {
  func serviceName() -> String {
    ServiceType.ChatRoomMessageCreatorService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any], _ resultCallback: ResultCallback) {
    switch ChatRoomMessageCreatorAPIType(rawValue: method) {
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
    case .createCustomMessageWithAttachmentAndSubType:
      createCustomMessageWithAttachmentAndSubType(arguments, resultCallback)
    case .createForwardMessage:
      createForwardMessage(arguments, resultCallback)
    case .createTipsMessage:
      createTipsMessage(arguments, resultCallback)
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
    let message = V2NIMChatroomMessageCreator.createTextMessage(text)
    successCallBack(resultCallback, message.toDic())
  }

  /// 创建音频消息
  func createAudioMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let path = arguments["audioPath"] as? String,
          let duration = arguments["duration"] as? Int32 else {
      parameterError(resultCallback)
      return
    }

    let name = arguments["name"] as? String
    var sceneName = arguments["sceneName"] as? String
    sceneName = sceneName ?? V2NIMStorageSceneConfig.default_IM().sceneName
    let message = V2NIMChatroomMessageCreator.createAudioMessage(path, name: name, sceneName: sceneName, duration: duration)
    successCallBack(resultCallback, message.toDic())
  }

  /// 创建图片消息
  func createImageMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let imagePath = arguments["imagePath"] as? String,
          let width = arguments["width"] as? Int32,
          let height = arguments["height"] as? Int32 else {
      parameterError(resultCallback)
      return
    }
    let name = arguments["name"] as? String
    var sceneName = arguments["sceneName"] as? String
    sceneName = sceneName ?? V2NIMStorageSceneConfig.default_IM().sceneName
    let message = V2NIMChatroomMessageCreator.createImageMessage(imagePath, name: name, sceneName: sceneName, width: width, height: height)
    successCallBack(resultCallback, message.toDic())
  }

  /// 创建视频消息
  func createVideoMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let videoPath = arguments["videoPath"] as? String,
          let duration = arguments["duration"] as? Int32,
          let width = arguments["width"] as? Int32,
          let height = arguments["height"] as? Int32 else {
      parameterError(resultCallback)
      return
    }
    let name = arguments["name"] as? String
    var sceneName = arguments["sceneName"] as? String
    sceneName = sceneName ?? V2NIMStorageSceneConfig.default_IM().sceneName
    let message = V2NIMChatroomMessageCreator.createVideoMessage(videoPath, name: name, sceneName: sceneName, duration: duration, width: width, height: height)
    successCallBack(resultCallback, message.toDic())
  }

  /// 创建文件消息
  func createFileMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let filePath = arguments["filePath"] as? String else {
      parameterError(resultCallback)
      return
    }
    let name = arguments["name"] as? String
    var sceneName = arguments["sceneName"] as? String
    sceneName = sceneName ?? V2NIMStorageSceneConfig.default_IM().sceneName
    let message = V2NIMChatroomMessageCreator.createFileMessage(filePath, name: name, sceneName: sceneName)
    successCallBack(resultCallback, message.toDic())
  }

  /// 创建地理位置消息
  func createLocationMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let latitude = arguments["latitude"] as? Double,
          let longitude = arguments["longitude"] as? Double,
          let address = arguments["address"] as? String else {
      parameterError(resultCallback)
      return
    }

    let message = V2NIMChatroomMessageCreator.createLocationMessage(latitude, longitude: longitude, address: address)
    successCallBack(resultCallback, message.toDic())
  }

  /// 创建自定义消息
  func createCustomMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let rawAttachment = arguments["rawAttachment"] as? String else {
      parameterError(resultCallback)
      return
    }
    let message = V2NIMChatroomMessageCreator.createCustomMessage(rawAttachment)
    successCallBack(resultCallback, message.toDic())
  }

  /// 创建自定义消息
  func createCustomMessageWithAttachmentAndSubType(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let subType = arguments["subType"] as? Int32,
          let attachment = arguments["attachment"] as? String else {
      parameterError(resultCallback)
      return
    }

    let rawAttachment = V2NIMMessageCustomAttachment()
    rawAttachment.raw = attachment
    let message = V2NIMChatroomMessageCreator.createCustomMessage(with: rawAttachment, subType: subType)
    successCallBack(resultCallback, message.toDic())
  }

  /// 创建tips消息
  func createTipsMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let text = arguments["text"] as? String else {
      parameterError(resultCallback)
      return
    }
    let message = V2NIMChatroomMessageCreator.createTipsMessage(text)
    successCallBack(resultCallback, message.toDic())
  }

  /// 创建转发消息
  func createForwardMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let messageDic = arguments["message"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    let message = V2NIMChatroomMessage.fromDic(messageDic)
    let forwardMessage = V2NIMChatroomMessageCreator.createForwardMessage(message)
    successCallBack(resultCallback, forwardMessage.toDic())
  }
}
