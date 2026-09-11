// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK
import YXAlog_iOS

enum ChatRoomServiceAPIType: String {
  case sendMessage
  case cancelMessageAttachmentUpload
  case getMessageList
  case getMessageListByTag
  case getMemberByIds
  case getMemberListByOption
  case updateMemberRole
  case setMemberBlockedStatus
  case setMemberChatBannedStatus
  case setMemberTempChatBanned
  case updateChatroomInfo
  case updateSelfMemberInfo
  case kickMember
  case updateChatroomLocationInfo
  case updateChatroomTags
  case setTempChatBannedByTag
  case getMemberCountByTag
  case getMemberListByTag
  case registerCustomAttachmentParser
  case unregisterCustomAttachmentParser
  case addChatroomListener
  case removeChatroomListener
}

class FLTChatRoomService: FLTBaseService, FLTService {
  private static let className = "FLTChatRoomService"
  private var customAttachmentParsers: [Int: V2NIMMessageCustomAttachmentParser] = [:]
  private var chatroomServiceListeners: [Int: V2NIMChatroomListener] = [:]

  override func onInitialized() {}

  deinit {}

  // MARK: - Protocol

  func serviceName() -> String {
    ServiceType.ChatRoomService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case ChatRoomServiceAPIType.sendMessage.rawValue:
      sendMessage(arguments, resultCallback)
    case ChatRoomServiceAPIType.cancelMessageAttachmentUpload.rawValue:
      cancelMessageAttachmentUpload(arguments, resultCallback)
    case ChatRoomServiceAPIType.getMessageList.rawValue:
      getMessageList(arguments, resultCallback)
    case ChatRoomServiceAPIType.getMessageListByTag.rawValue:
      getMessageListByTag(arguments, resultCallback)
    case ChatRoomServiceAPIType.getMemberByIds.rawValue:
      getMemberByIds(arguments, resultCallback)
    case ChatRoomServiceAPIType.getMemberListByOption.rawValue:
      getMemberListByOption(arguments, resultCallback)
    case ChatRoomServiceAPIType.updateMemberRole.rawValue:
      updateMemberRole(arguments, resultCallback)
    case ChatRoomServiceAPIType.setMemberBlockedStatus.rawValue:
      setMemberBlockedStatus(arguments, resultCallback)
    case ChatRoomServiceAPIType.setMemberChatBannedStatus.rawValue:
      setMemberChatBannedStatus(arguments, resultCallback)
    case ChatRoomServiceAPIType.setMemberTempChatBanned.rawValue:
      setMemberTempChatBanned(arguments, resultCallback)
    case ChatRoomServiceAPIType.updateChatroomInfo.rawValue:
      updateChatroomInfo(arguments, resultCallback)
    case ChatRoomServiceAPIType.updateSelfMemberInfo.rawValue:
      updateSelfMemberInfo(arguments, resultCallback)
    case ChatRoomServiceAPIType.kickMember.rawValue:
      kickMember(arguments, resultCallback)
    case ChatRoomServiceAPIType.updateChatroomLocationInfo.rawValue:
      updateChatroomLocationInfo(arguments, resultCallback)
    case ChatRoomServiceAPIType.updateChatroomTags.rawValue:
      updateChatroomTags(arguments, resultCallback)
    case ChatRoomServiceAPIType.setTempChatBannedByTag.rawValue:
      setTempChatBannedByTag(arguments, resultCallback)
    case ChatRoomServiceAPIType.getMemberCountByTag.rawValue:
      getMemberCountByTag(arguments, resultCallback)
    case ChatRoomServiceAPIType.getMemberListByTag.rawValue:
      getMemberListByTag(arguments, resultCallback)
    case ChatRoomServiceAPIType.registerCustomAttachmentParser.rawValue:
      registerCustomAttachmentParser(arguments, resultCallback)
    case ChatRoomServiceAPIType.unregisterCustomAttachmentParser.rawValue:
      unregisterCustomAttachmentParser(arguments, resultCallback)
    case ChatRoomServiceAPIType.addChatroomListener.rawValue:
      addChatroomListener(arguments, resultCallback)
    case ChatRoomServiceAPIType.removeChatroomListener.rawValue:
      removeChatroomListener(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  // MARK: - SDK API

  /**
   * 发送消息接口
   * 消息对象可以调用V2NIMChatroomMessageCreator.createXXXMessage接口来创建
   * @param message 需要发送的消息体, 由聊天室消息创建工具类(V2NIMChatroomMessageCreator)创建
   * @param param 发送消息相关配置参数
   * @param success 发送消息成功回调
   * @param failure 发送消息失败回调
   * @param progress 发送消息进度回调
   *                  主要运用于文件类消息，回调文件发送进度
   */
  func sendMessage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let messageDic = arguments["message"] as? [String: Any],
          let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    let message = V2NIMChatroomMessage.fromDic(messageDic)
    let params = V2NIMSendChatroomMessageParams.fromDic(paramsDic)
    service.send(message, params: params) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "sendMessage error \(error.nserror.localizedDescription)")
    } progress: { progress in
      weakSelf?.notifyEvent(ServiceType.ChatRoomService.rawValue, "onSendMessageProgress", ["instanceId": instanceId,
                                                                                            "messageClientId": message.messageClientId as Any,
                                                                                            "progress": progress as Any])
    }
  }

  /**
   * 取消文件类附件上传，只有文件类消息可以调用该接口
   * 如果文件已经上传成功，则取消失败
   * 如果取消成功， 则对应消息文件上传状态会变成V2NIMMessageAttachmentUploadState.V2NIM_MESSAGE_ATTACHMENT_UPLOAD_STATE_FAILED，同时消息会发送失败
   *
   * @param message 需要取消附件上传的消息体
   * @param success 取消成功回调
   * @param failure 取消失败回调
   */
  func cancelMessageAttachmentUpload(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let messageDic = arguments["message"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    let message = V2NIMChatroomMessage.fromDic(messageDic)
    service.cancelMessageAttachmentUpload(message) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "cancelMessageAttachmentUpload error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 查询历史消息
   *
   * @param option 获取聊天室消息列表查询参数
   * @param success 获取列表失败的回调
   * @param failure 获取列表失败的回调
   */
  func getMessageList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let optionDic = arguments["option"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    let option = V2NIMChatroomMessageListOption.fromDic(optionDic)
    service.getMessageList(option) { messages in
      let messages = messages.map { $0.toDic() }
      weakSelf?.successCallBack(resultCallback, ["messageList": messages])
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "getMessageList error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 根据标签查询消息列表
   *
   * @param option 查询参数
   * @param success 获取列表成功的回调
   * @param failure 获取列表失败的回调
   */
  func getMessageListByTag(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let optionDic = arguments["messageOption"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    let option = V2NIMChatroomTagMessageOption.fromDic(optionDic)
    service.getMessageList(byTag: option) { messages in
      let messages = messages.map { $0.toDic() }
      weakSelf?.successCallBack(resultCallback, ["messageList": messages])
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "getMessageListByTag error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  根据账号列表查询成员信息
   *
   *  @param accountIds 账号id列表
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  func getMemberByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let accountIds = arguments["accountIds"] as? [String] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    service.getMemberByIds(accountIds) { members in
      let members = members.map { $0.toDic() }
      weakSelf?.successCallBack(resultCallback, ["memberList": members])
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "getMemberByIds error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  分页获取聊天室成员列表
   *
   *  @param queryOption 查询参数
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  func getMemberListByOption(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let optionDic = arguments["queryOption"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    let option = V2NIMChatroomMemberQueryOption.fromDic(optionDic)
    service.getMemberList(by: option) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "getMemberListByOption error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  更新聊天室成员角色
   *
   *  @param accountId 账号id
   *  @param updateParams 更新参数
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  func updateMemberRole(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let accountId = arguments["accountId"] as? String,
          let paramsDic = arguments["updateParams"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    let params = V2NIMChatroomMemberRoleUpdateParams.fromDic(paramsDic)
    service.updateMemberRole(accountId, updateParams: params) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "updateMemberRole error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  设置聊天室成员黑名单状态
   *
   *  @param accountId 账号id
   *  @param blocked 黑名单状态
   *  @param notificationExtension 本次操作生成的通知中的扩展字段
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  func setMemberBlockedStatus(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let accountId = arguments["accountId"] as? String,
          let blocked = arguments["blocked"] as? Bool else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    let notificationExtension = arguments["notificationExtension"] as? String
    service.setMemberBlockedStatus(accountId, blocked: blocked, notificationExtension: notificationExtension) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "setMemberBlockedStatus error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  设置成员禁言状态
   *
   *  @param accountId 账号id
   *  @param chatBanned 禁言状态
   *  @param notificationExtension 本次操作生成的通知中的扩展字段
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  func setMemberChatBannedStatus(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let accountId = arguments["accountId"] as? String,
          let chatBanned = arguments["chatBanned"] as? Bool else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    let notificationExtension = arguments["notificationExtension"] as? String
    service.setMemberChatBannedStatus(accountId, chatBanned: chatBanned, notificationExtension: notificationExtension) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "setMemberChatBannedStatus error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  设置成员临时禁言状态
   *
   *  @param accountId 账号id
   *  @param tempChatBannedDuration 设置临时禁言时长（单位秒）
   *  @param notificationEnabled 是否需要通知
   *  @param notificationExtension 本次操作生成的通知中的扩展字段
   *  @param success 成功回调
   *  @param failure 失败回调
   *
   *  @discussion tempChatBannedDuration 最大可设置为30天，如果取消临时禁言状态，设置为0
   */
  func setMemberTempChatBanned(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let accountId = arguments["accountId"] as? String,
          let tempChatBannedDuration = arguments["tempChatBannedDuration"] as? Int,
          let notificationEnabled = arguments["notificationEnabled"] as? Bool else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    let notificationExtension = arguments["notificationExtension"] as? String
    service.setMemberTempChatBanned(accountId,
                                    tempChatBannedDuration: tempChatBannedDuration,
                                    notificationEnabled: notificationEnabled,
                                    notificationExtension: notificationExtension) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "setMemberTempChatBanned error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  更新聊天室信息
   *
   *  @param updateParams 更新参数
   *  @param antispamConfig 更新参数
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  func updateChatroomInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let updateParamsDic = arguments["updateParams"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    let updateParams = V2NIMChatroomUpdateParams.fromDic(updateParamsDic)
    var antispamConfig: V2NIMAntispamConfig?
    if let antispamConfigDic = arguments["antispamConfig"] as? [String: Any] {
      antispamConfig = V2NIMAntispamConfig.fromDic(antispamConfigDic)
    }
    service.updateChatroomInfo(updateParams, antispamConfig: antispamConfig) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "updateChatroomInfo error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  更新自己在聊天室的成员信息
   *
   *  @param updateParams 更新参数
   *  @param antispamConfig 更新参数
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  func updateSelfMemberInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let updateParamsDic = arguments["updateParams"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    let updateParams = V2NIMChatroomSelfMemberUpdateParams.fromDic(updateParamsDic)
    var antispamConfig: V2NIMAntispamConfig?
    if let antispamConfigDic = arguments["antispamConfig"] as? [String: Any] {
      antispamConfig = V2NIMAntispamConfig.fromDic(antispamConfigDic)
    }
    service.updateSelfMemberInfo(updateParams, antispamConfig: antispamConfig) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "updateSelfMemberInfo error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  踢出聊天室成员
   *
   *  @param accountId 账号id
   *  @param notificationExtension 本次操作生成的通知中的扩展字段
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  func kickMember(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let accountId = arguments["accountId"] as? String,
          let notificationExtension = arguments["notificationExtension"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    service.kickMember(accountId, notificationExtension: notificationExtension) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "kickMember error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  更新坐标信息
   *
   *  @param locationConfig 更新坐标信息参数
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  func updateChatroomLocationInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let locationConfigDic = arguments["locationConfig"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    let locationConfig = V2NIMChatroomLocationConfig.fromDic(locationConfigDic)
    service.updateChatroomLocationInfo(locationConfig) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "updateChatroomLocationInfo error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  更新聊天室tag信息
   *
   *  @param updateParams tags更新的参数
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  func updateChatroomTags(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let updateParamsDic = arguments["updateParams"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    let updateParams = V2NIMChatroomTagsUpdateParams.fromDic(updateParamsDic)
    service.updateChatroomTags(updateParams) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "updateChatroomTags error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  按聊天室标签临时禁言
   *
   *  @param params 设置标签禁言的参数
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  func setTempChatBannedByTag(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    let params = V2NIMChatroomTagTempChatBannedParams.fromDic(paramsDic)
    service.setTempChatBannedByTag(params) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "setTempChatBannedByTag error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  查询某个标签下的成员人数
   *
   *  @param tag 标签
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  func getMemberCountByTag(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let tag = arguments["tag"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    service.getMemberCount(byTag: tag) { memberCount in
      weakSelf?.successCallBack(resultCallback, ["memberCount": memberCount])
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "getMemberCountByTag error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  根据tag查询聊天室成员列表
   *
   *  @param option 根据tag查询成员的参数
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  func getMemberListByTag(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int,
          let optionDic = arguments["option"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    let option = V2NIMChatroomTagMemberOption.fromDic(optionDic)
    service.getMemberList(byTag: option) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      let err = error.nserror as NSError
      weakSelf?.errorCallBack(resultCallback, err.description, err.code)
      FLTALog.errorLog(FLTChatRoomService.className, desc: "getMemberListByTag error \(error.nserror.localizedDescription)")
    }
  }

  /**
   * 注册自定义消息附件解析器，解析自定义消息类型为100的附件
   * 可以注册多个， 后注册的优先级高，优先派发， 一旦被处理，则不继续派发
   * 如果同一个类型多个解析均可以解析，则优先级高的先解析， 解析后直接返回
   * 按需注册，不需要时及时反注册
   */
  func registerCustomAttachmentParser(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int else {
      parameterError(resultCallback)
      return
    }

    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    let parser = FLTChatRoomCustomAttachmentParser(self, instanceId)
    customAttachmentParsers[instanceId] = parser
    service.register(parser)
    successCallBack(resultCallback, nil)
  }

  /**
   * 反注册自定义消息附件解析器，解析自定义消息类型为100的附件
   */
  func unregisterCustomAttachmentParser(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int else {
      parameterError(resultCallback)
      return
    }

    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    if let parser = customAttachmentParsers[instanceId] {
      service.unregisterCustomAttachmentParser(parser)
    }
    successCallBack(resultCallback, nil)
  }

  /**
   *  添加聊天室监听
   *
   *  @param listener 聊天室监听
   */
  func addChatroomListener(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int else {
      parameterError(resultCallback)
      return
    }

    if let _ = chatroomServiceListeners[instanceId] {
      successCallBack(resultCallback, nil)
      return
    }

    let instance = V2NIMChatroomClient.getInstance(instanceId)
    let service = instance.getChatroomService()
    let listener = FLTChatRoomServiceListener(self, instanceId)
    chatroomServiceListeners[instanceId] = listener
    service.add(listener)
    successCallBack(resultCallback, nil)
  }

  /**
   *  移除聊天室监听
   *
   *  @param listener 聊天室监听
   */
  func removeChatroomListener(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let instanceId = arguments["instanceId"] as? Int else {
      parameterError(resultCallback)
      return
    }

    if let listener = chatroomServiceListeners[instanceId] {
      let instance = V2NIMChatroomClient.getInstance(instanceId)
      let service = instance.getChatroomService()
      service.remove(listener)
    }
    successCallBack(resultCallback, nil)
  }
}
