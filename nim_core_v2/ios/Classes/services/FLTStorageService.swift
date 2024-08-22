// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK
import UIKit

enum StorageServiceType: String {
  case addCustomStorageScene
  case cancelUploadFile
  case createUploadFileTask
  case downloadAttachment
  case downloadFile
  case getImageThumbUrl
  case getStorageSceneList
  case getVideoCoverUrl
  case shortUrlToLong
  case uploadFile
  case imageThumbUrl
  case videoCoverUrl
}

class FLTStorageService: FLTBaseService, FLTService {
  override func onInitialized() {}

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func serviceName() -> String {
    ServiceType.StorageService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any], _ resultCallback: ResultCallback) {
    switch method {
    case StorageServiceType.addCustomStorageScene.rawValue:
      addCustomStorageScene(arguments, resultCallback)
    case StorageServiceType.cancelUploadFile.rawValue:
      cancelUploadFile(arguments, resultCallback)
    case StorageServiceType.createUploadFileTask.rawValue:
      createUploadFileTask(arguments, resultCallback)
    case StorageServiceType.downloadAttachment.rawValue:
      downloadAttachment(arguments, resultCallback)
    case StorageServiceType.downloadFile.rawValue:
      downloadFile(arguments, resultCallback)
    case StorageServiceType.getImageThumbUrl.rawValue:
      getImageThumbUrl(arguments, resultCallback)
    case StorageServiceType.getVideoCoverUrl.rawValue:
      getVideoCoverUrl(arguments, resultCallback)
    case StorageServiceType.shortUrlToLong.rawValue:
      shortUrlToLong(arguments, resultCallback)
    case StorageServiceType.uploadFile.rawValue:
      uploadFile(arguments, resultCallback)
    case StorageServiceType.imageThumbUrl.rawValue:
      imageThumbUrl(arguments, resultCallback)
    case StorageServiceType.videoCoverUrl.rawValue:
      videoCoverUrl(arguments, resultCallback)
    case StorageServiceType.getStorageSceneList.rawValue:
      getStorageSceneList(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  /// 添加自定义存储场景
  func addCustomStorageScene(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let sceneName = arguments["sceneName"] as? String, let expireTime = arguments["expireTime"] as? UInt else {
      parameterError(resultCallback)
      return
    }
    NIMSDK.shared().v2StorageService.addCustomStorageScene(sceneName, expireTime: expireTime)
    successCallBack(resultCallback, nil)
  }

  /// 取消上传文件
  func cancelUploadFile(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let fileTaskArguments = arguments["fileTask"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let fileTask = V2NIMUploadFileTask()
    if let taskId = fileTaskArguments[#keyPath(V2NIMUploadFileTask.taskId)] as? String {
      fileTask.taskId = taskId
    }

    if let uploadParamsArguments = fileTaskArguments["uploadParams"] as? [String: Any] {
      let uploadParams = V2NIMUploadFileParams()
      if let filePath = uploadParamsArguments["filePath"] as? String {
        uploadParams.filePath = filePath
      }
      if let sceneName = uploadParamsArguments["sceneName"] as? String {
        uploadParams.sceneName = sceneName
      }
      fileTask.uploadParams = uploadParams
    }

    weak var weakSelf = self
    NIMSDK.shared().v2StorageService.cancelUploadFile(fileTask) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 创建上传文件任务
  func createUploadFileTask(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let fileParamsArguments = arguments["fileParams"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let uploadParams = V2NIMUploadFileParams()
    if let filePath = fileParamsArguments["filePath"] as? String {
      uploadParams.filePath = filePath
    }
    if let sceneName = fileParamsArguments["sceneName"] as? String {
      uploadParams.sceneName = sceneName
    }

    let task = NIMSDK.shared().v2StorageService.createUploadFileTask(uploadParams)
    successCallBack(resultCallback, task.toDictionary())
  }

  /// downloadAttachment
  func downloadAttachment(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let downloadAttachmentArgument = arguments["downloadParam"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    guard let params = V2NIMDownloadMessageAttachmentParams.fromDictionary(downloadAttachmentArgument) else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self

    NIMSDK.shared().v2StorageService.downloadAttachment(params) { url in
      weakSelf?.successCallBack(resultCallback, url)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    } progress: { progress in
      let progressModel = NIMDownloadMessageAttachmentProgress()
      progressModel.progress = Int(progress)
      progressModel.downloadParam = params
      weakSelf?.notifyEvent(weakSelf?.serviceName() ?? "", "onMessageAttachmentDownloadProgress", progressModel.toDictionary())
    }
  }

  /// 获取缩略图地址
  func getImageThumbUrl(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let thumbSize = arguments["thumbSize"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    guard let size = V2NIMSize.fromDictionary(thumbSize) else {
      parameterError(resultCallback)
      return
    }
    guard let attachmentArguments = arguments["attachment"] as? [String: Any], let attachment = FLTStorageService.getRealAttachment(attachmentArguments) else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2StorageService.getImageThumbUrl(attachment, thumbSize: size) { result in
      weakSelf?.successCallBack(resultCallback, result.toDictionary())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func getStorageSceneList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let list = NIMSDK.shared().v2StorageService.getStorageSceneList()
    var sceneList = [[String: Any]]()
    for scene in list {
      sceneList.append(scene.toDictionary())
    }
    successCallBack(resultCallback, ["sceneList": sceneList])
  }

  func getVideoCoverUrl(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let thumbSize = arguments["thumbSize"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    guard let size = V2NIMSize.fromDictionary(thumbSize) else {
      parameterError(resultCallback)
      return
    }
    guard let attachmentArguments = arguments["attachment"] as? [String: Any], let attachment = FLTStorageService.getRealAttachment(attachmentArguments) else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2StorageService.getVideoCoverUrl(attachment, thumbSize: size) { result in
      weakSelf?.successCallBack(resultCallback, result.toDictionary())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func shortUrlToLong(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let url = arguments["url"] as? String else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2StorageService.shortUrl(toLong: url) { retUrl in
      weakSelf?.successCallBack(resultCallback, retUrl)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func uploadFile(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let fileTaskArguments = arguments["fileTask"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    let fileTask = V2NIMUploadFileTask.fromDictionary(fileTaskArguments)

    weak var weakSelf = self
    NIMSDK.shared().v2StorageService.uploadFile(fileTask) { url in
      weakSelf?.successCallBack(resultCallback, url)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    } progress: { progress in
      let progressModel = NIMUploadFileProgress()
      progressModel.taskId = fileTask.taskId
      progressModel.progress = Int(progress * 100)
      print("uploadFile progress: \(progress)")
      weakSelf?.notifyEvent(weakSelf?.serviceName() ?? "", "onFileUploadProgress", progressModel.toDictionary())
    }
  }

  func downloadFile(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let url = arguments["url"] as? String, let filePath = arguments["filePath"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2StorageService.downloadFile(url, filePath: filePath) { path in
      weakSelf?.successCallBack(resultCallback, path)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    } progress: { progress in
      let progressModel = NIMDownloadFileProgress()
      progressModel.url = url
      progressModel.progress = Int(progress)
      weakSelf?.notifyEvent(weakSelf?.serviceName() ?? "", "onFileDownloadProgress", progressModel.toDictionary())
      print("downloadFile progress: \(progress)")
    }
  }

  func videoCoverUrl(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let url = arguments["url"] as? String, let offset = arguments["offset"] as? Int else {
      parameterError(resultCallback)
      return
    }
    let videoCoverUrl = V2NIMStorageUtil.videoCoverUrl(url, offset: offset)
    successCallBack(resultCallback, videoCoverUrl)
  }

  func imageThumbUrl(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let url = arguments["url"] as? String, let thumbSize = arguments["thumbSize"] as? Int else {
      parameterError(resultCallback)
      return
    }
    let imageThumbUrl = V2NIMStorageUtil.imageThumbUrl(url, thumbSize: thumbSize)
    successCallBack(resultCallback, imageThumbUrl)
  }

  static func getRealAttachment(_ attachmentDic: [String: Any]) -> V2NIMMessageAttachment? {
    var attachment: V2NIMMessageAttachment?
    if let type = attachmentDic["nimCoreMessageType"] as? Int,
       let messageType = V2NIMMessageType(rawValue: type) {
      switch messageType {
      case .MESSAGE_TYPE_AUDIO:
        attachment = V2NIMMessageAudioAttachment.fromDictionary(attachmentDic)
      case .MESSAGE_TYPE_FILE:
        attachment = V2NIMMessageFileAttachment.fromDict(attachmentDic)
      case .MESSAGE_TYPE_IMAGE:
        attachment = V2NIMMessageImageAttachment.fromDictionary(attachmentDic)
      case .MESSAGE_TYPE_VIDEO:
        attachment = V2NIMMessageVideoAttachment.fromDictionary(attachmentDic)
      case .MESSAGE_TYPE_LOCATION:
        attachment = V2NIMMessageLocationAttachment.fromDict(attachmentDic)
      case .MESSAGE_TYPE_NOTIFICATION:
        attachment = V2NIMMessageNotificationAttachment.fromDict(attachmentDic)
      case .MESSAGE_TYPE_CALL:
        attachment = V2NIMMessageCallAttachment.fromDict(attachmentDic)
      default:
        attachment = V2NIMMessageAttachment.fromDic(attachmentDic)
      }
    }
    return attachment
  }
}

extension V2NIMUploadFileParams {
  func toDictionary() -> [String: Any] {
    var dic = [String: Any]()
    dic[#keyPath(filePath)] = filePath
    dic[#keyPath(sceneName)] = sceneName
    return dic
  }

  static func fromDictionary(_ dic: [String: Any]) -> V2NIMUploadFileParams {
    let params = V2NIMUploadFileParams()
    if let filePath = dic[#keyPath(filePath)] as? String {
      params.filePath = filePath
    }
    if let sceneName = dic[#keyPath(sceneName)] as? String {
      params.sceneName = sceneName
    }
    return params
  }
}

extension V2NIMUploadFileTask {
  func toDictionary() -> [String: Any] {
    var dic = [String: Any]()
    dic[#keyPath(taskId)] = taskId
    dic[#keyPath(uploadParams)] = uploadParams.toDictionary()
    return dic
  }

  static func fromDictionary(_ dic: [String: Any]) -> V2NIMUploadFileTask {
    let task = V2NIMUploadFileTask()
    if let taskId = dic[#keyPath(taskId)] as? String {
      task.taskId = taskId
    }
    if let uploadParamsDic = dic[#keyPath(uploadParams)] as? [String: Any] {
      task.uploadParams = V2NIMUploadFileParams.fromDictionary(uploadParamsDic)
    }
    return task
  }
}

extension V2NIMSize {
  func toDictionary() -> [String: Any] {
    var dic = [String: Any]()
    dic[#keyPath(width)] = width
    dic[#keyPath(height)] = height
    return dic
  }

  static func fromDictionary(_ dic: [String: Any]) -> V2NIMSize? {
    if let width = dic[#keyPath(width)] as? Int, let height = dic[#keyPath(height)] as? Int {
      return V2NIMSize(width: width, height: height)
    }
    return nil
  }
}

extension V2NIMDownloadMessageAttachmentParams {
  func toDictionary() -> [String: Any] {
    var dic = [String: Any]()
    dic[#keyPath(saveAs)] = saveAs
    dic[#keyPath(messageClientId)] = messageClientId
    if let sizeDic = thumbSize?.toDictionary() {
      dic[#keyPath(thumbSize)] = sizeDic
    }
    dic[#keyPath(type)] = type.rawValue
    if let videoAttachemnt = attachment as? V2NIMMessageVideoAttachment {
      dic[#keyPath(attachment)] = videoAttachemnt.toDic()
    } else if let audioAttachment = attachment as? V2NIMMessageAudioAttachment {
      dic[#keyPath(attachment)] = audioAttachment.toDic()
    } else if let fileAttachment = attachment as? V2NIMMessageFileAttachment {
      dic[#keyPath(attachment)] = fileAttachment.toDic()
    } else if let imageAttachment = attachment as? V2NIMMessageImageAttachment {
      dic[#keyPath(attachment)] = imageAttachment.toDic()
    } else if let callAttachment = attachment as? V2NIMMessageCallAttachment {
      dic[#keyPath(attachment)] = callAttachment.toDic()
    } else if let locationAttachment = attachment as? V2NIMMessageLocationAttachment {
      dic[#keyPath(attachment)] = locationAttachment.toDic()
    } else if let notiAttachment = attachment as? V2NIMMessageNotificationAttachment {
      dic[#keyPath(attachment)] = notiAttachment.toDic()
    } else {
      dic[#keyPath(attachment)] = attachment.toDic()
    }
    return dic
  }

  static func fromDictionary(_ dic: [String: Any]) -> V2NIMDownloadMessageAttachmentParams? {
    if let attachmentDic = dic[#keyPath(attachment)] as? [String: Any] {
      if let attachment = FLTStorageService.getRealAttachment(attachmentDic) {
        let params = V2NIMDownloadMessageAttachmentParams(attachment: attachment)
        if let saveAs = dic[#keyPath(saveAs)] as? String {
          params.saveAs = saveAs
        }
        if let messageClientId = dic[#keyPath(messageClientId)] as? String {
          params.messageClientId = messageClientId
        }
        if let thumbSizeDic = dic[#keyPath(thumbSize)] as? [String: Any] {
          params.thumbSize = V2NIMSize.fromDictionary(thumbSizeDic)
        }
        if let type = dic[#keyPath(V2NIMDownloadMessageAttachmentParams.type)] as? Int, let type = V2NIMDownloadAttachmentType(rawValue: type) {
          params.type = type
        }
        return params
      }
    }
    return nil
  }
}

extension V2NIMGetMediaResourceInfoResult {
  func toDictionary() -> [String: Any] {
    var dic = [String: Any]()
    dic[#keyPath(url)] = url
    dic[#keyPath(authHeaders)] = authHeaders
    return dic
  }

  static func fromDictionary(_ dic: [String: Any]) -> V2NIMGetMediaResourceInfoResult {
    let result = V2NIMGetMediaResourceInfoResult()
    if let url = dic[#keyPath(url)] as? String {
      result.setValue(url, forKey: #keyPath(V2NIMGetMediaResourceInfoResult.url))
    }
    if let authHeaders = dic[#keyPath(authHeaders)] as? [String: String] {
      result.setValue(authHeaders, forKey: #keyPath(V2NIMGetMediaResourceInfoResult.authHeaders))
    }
    return result
  }
}

extension V2NIMStorageScene {
  func toDictionary() -> [String: Any] {
    var dic = [String: Any]()
    dic[#keyPath(sceneName)] = sceneName
    dic[#keyPath(expireTime)] = expireTime
    return dic
  }

  static func fromDictionary(_ dic: [String: Any]) -> V2NIMStorageScene {
    let scene = V2NIMStorageScene()
    if let sceneName = dic[#keyPath(sceneName)] as? String {
      scene.sceneName = sceneName
    }
    if let expireTime = dic[#keyPath(expireTime)] as? UInt {
      scene.expireTime = expireTime
    }
    return scene
  }
}

@objcMembers
class NIMDownloadMessageAttachmentProgress {
  var progress: Int = 0
  var downloadParam: V2NIMDownloadMessageAttachmentParams?

  func toDictionary() -> [String: Any] {
    var dic = [String: Any]()
    dic[#keyPath(progress)] = progress
    dic[#keyPath(downloadParam)] = downloadParam?.toDictionary()
    return dic
  }
}

@objcMembers
class NIMUploadFileProgress {
  var taskId: String?
  var progress: Int = 0
  func toDictionary() -> [String: Any] {
    var dic = [String: Any]()
    dic[#keyPath(taskId)] = taskId
    dic[#keyPath(progress)] = progress
    return dic
  }
}

@objcMembers
class NIMDownloadFileProgress {
  var url: String?
  var progress: Int = 0
  func toDictionary() -> [String: Any] {
    var dic = [String: Any]()
    dic[#keyPath(url)] = url
    dic[#keyPath(progress)] = progress
    return dic
  }
}
