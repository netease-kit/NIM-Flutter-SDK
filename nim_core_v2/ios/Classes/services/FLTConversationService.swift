// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum V2ConversationAPIType: String {
  case getConversationList
  case getConversationListByOption
  case getConversationListByIds
  case getConversation
  case createConversation
  case deleteConversation
  case deleteConversationListByIds
  case stickTopConversation
  case muteConversation
  case updateConversation
  case updateConversationLocalExtension
  case getTotalUnreadCount
  case getUnreadCountByIds
  case getUnreadCountByFilter
  case clearTotalUnreadCount
  case clearUnreadCountByIds
  case clearUnreadCountByTypes
  case clearUnreadCountByGroupId
  case subscribeUnreadCountByFilter
  case unsubscribeUnreadCountByFilter
  case getConversationReadTime
  case markConversationRead
}

@objcMembers
class FLTConversationService: FLTBaseService, FLTService, V2NIMConversationListener {
  override func onInitialized() {
    NIMSDK.shared().v2ConversationService.add(self)
  }

  deinit {
    NIMSDK.shared().v2ConversationService.remove(self)
  }

  func serviceName() -> String {
    ServiceType.ConversationService.rawValue
  }

  /// 获取会话列表
  func getConversationList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let offset = arguments["offset"] as? Int64, let limit = arguments["limit"] as? Int else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2ConversationService.getConversationList(offset, limit: limit) { result in
      let resultDic = result.toDictionary()
      print("getConversationList result ", resultDic)
      weakSelf?.successCallBack(resultCallback, result.toDictionary())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 根据查询参数获取会话列表
  func getConversationListByOption(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let optionArgument = arguments["option"] as? [String: Any], let offset = arguments["offset"] as? Int64, let limit = arguments["limit"] as? Int else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    let option = V2NIMConversationOption.fromDictionary(optionArgument)
    NIMSDK.shared().v2ConversationService.getConversationList(byOption: offset, limit: limit, option: option) { result in
      weakSelf?.successCallBack(resultCallback, result.toDictionary())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 获取会话列表，通过会话id列表
  func getConversationListByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationIds = arguments["conversationIdList"] as? [String] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2ConversationService.getConversationList(byIds: conversationIds) { conversations in
      weakSelf?.successCallBack(resultCallback, ["conversationList": conversations.map { $0.toDictionary() }])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 获取会话
  func getConversation(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2ConversationService.getConversation(conversationId) { conversation in
      weakSelf?.successCallBack(resultCallback, conversation.toDictionary())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 创建会话
  func createConversation(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2ConversationService.createConversation(conversationId) { conversation in
      let conversationDic = conversation.toDictionary()
      print("converation dic : \(conversationDic)")
      weakSelf?.successCallBack(resultCallback, conversationDic)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 删除会话
  func deleteConversation(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String, let clearMessage = arguments["clearMessage"] as? Bool else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2ConversationService.deleteConversation(conversationId, clearMessage: clearMessage) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 批量删除会话
  func deleteConversationListByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationIds = arguments["conversationIdList"] as? [String], let clearMessage = arguments["clearMessage"] as? Bool else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2ConversationService.deleteConversationList(byIds: conversationIds, clearMessage: clearMessage) { result in
      var resultList = [[String: Any]]()
      for result in result {
        resultList.append(result.toDictionary())
      }
      weakSelf?.successCallBack(resultCallback, ["conversationOperationResult": resultList])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 置顶会话
  func stickTopConversation(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String, let stickTop = arguments["stickTop"] as? Bool else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2ConversationService.stickTopConversation(conversationId, stickTop: stickTop, success: {
      weakSelf?.successCallBack(resultCallback, nil)
    }) { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 静音会话
  func muteConversation(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String, let isMute = arguments["isMute"] as? Bool else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2ConversationService.muteConversation(conversationId, mute: isMute, success: {
      weakSelf?.successCallBack(resultCallback, nil)
    }) { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 更新会话
  func updateConversation(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String, let updateArgument = arguments["updateInfo"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    let update = V2NIMConversationUpdate.fromDictionary(updateArgument)
    NIMSDK.shared().v2ConversationService.updateConversation(conversationId, updateInfo: update) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 更新会话本地扩展字段
  func updateConversationLocalExtension(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }
    let localExtension = arguments["localExtension"] as? String
    weak var weakSelf = self
    NIMSDK.shared().v2ConversationService.updateConversationLocalExtension(conversationId, localExtension: localExtension) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 获取全部会话的总的未读数
  func getTotalUnreadCount(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let count = NIMSDK.shared().v2ConversationService.getTotalUnreadCount()
    successCallBack(resultCallback, count)
  }

  /// 根据会话id列表获取相应的未读数
  func getUnreadCountByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationIds = arguments["conversationIdList"] as? [String] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2ConversationService.getUnreadCount(byIds: conversationIds) { unreadCount in
      weakSelf?.successCallBack(resultCallback, unreadCount)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 根据过滤条件获取相应的未读数
  func getUnreadCountByFilter(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let filter = V2NIMConversationFilter.fromDictionary(arguments)
    weak var weakSelf = self
    NIMSDK.shared().v2ConversationService.getUnreadCount(by: filter) { unreadCount in
      weakSelf?.successCallBack(resultCallback, unreadCount)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 清空所有会话的总未读数
  func clearTotalUnreadCount(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    weak var weakSelf = self
    NIMSDK.shared().v2ConversationService.clearTotalUnreadCount {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 根据会话id列表清空相应会话的未读数
  func clearUnreadCountByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationIds = arguments["conversationIdList"] as? [String] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2ConversationService.clearUnreadCount(byIds: conversationIds) { resultList in
      var list = [[String: Any]]()
      for result in resultList {
        list.append(result.toDictionary())
      }
      weakSelf?.successCallBack(resultCallback, ["conversationOperationResult": list])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 根据会话类型列表清空相应会话的未读数
  func clearUnreadCountByTypes(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let types = arguments["conversationTypeList"] as? [NSNumber] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2ConversationService.clearUnreadCount(byTypes: types) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 根据会话分组清空相应会话的未读数
  func clearUnreadCountByGroupId(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let groupId = arguments["groupId"] as? String else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2ConversationService.clearUnreadCount(byGroupId: groupId) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 订阅指定过滤条件的会话未读数
  func subscribeUnreadCountByFilter(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let filterArgument = arguments["filter"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    let filter = V2NIMConversationFilter.fromDictionary(filterArgument)
    let error = NIMSDK.shared().v2ConversationService.subscribeUnreadCount(by: filter)
    if error == nil {
      successCallBack(resultCallback, nil)
    } else {
      errorCallBack(resultCallback, error!.nserror.localizedDescription, Int(error!.code))
    }
  }

  /// 取消订阅指定过滤条件的会话未读数
  func unsubscribeUnreadCountByFilter(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let filterArgument = arguments["filter"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    let filter = V2NIMConversationFilter.fromDictionary(filterArgument)
    let error = NIMSDK.shared().v2ConversationService.unsubscribeUnreadCount(by: filter)
    if error == nil {
      successCallBack(resultCallback, nil)
    } else {
      errorCallBack(resultCallback, error!.nserror.localizedDescription, Int(error!.code))
    }
  }

  /// 获取会话已读时间戳
  func getConversationReadTime(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2ConversationService.getConversationReadTime(conversationId) { time in
      weakSelf?.successCallBack(resultCallback, Int64(time * 1000))
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  /// 标记会话已读时间戳
  func markConversationRead(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2ConversationService.markConversationRead(conversationId) { time in
      weakSelf?.successCallBack(resultCallback, Int(time * 1000))
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any], _ resultCallback: ResultCallback) {
    switch method {
    case V2ConversationAPIType.getConversationList.rawValue:
      getConversationList(arguments, resultCallback)
    case V2ConversationAPIType.getConversationListByOption.rawValue:
      getConversationListByOption(arguments, resultCallback)
    case V2ConversationAPIType.getConversationListByIds.rawValue:
      getConversationListByIds(arguments, resultCallback)
    case V2ConversationAPIType.getConversation.rawValue:
      getConversation(arguments, resultCallback)
    case V2ConversationAPIType.createConversation.rawValue:
      createConversation(arguments, resultCallback)
    case V2ConversationAPIType.deleteConversation.rawValue:
      deleteConversation(arguments, resultCallback)
    case V2ConversationAPIType.deleteConversationListByIds.rawValue:
      deleteConversationListByIds(arguments, resultCallback)
    case V2ConversationAPIType.stickTopConversation.rawValue:
      stickTopConversation(arguments, resultCallback)
    case V2ConversationAPIType.muteConversation.rawValue:
      muteConversation(arguments, resultCallback)
    case V2ConversationAPIType.updateConversation.rawValue:
      updateConversation(arguments, resultCallback)
    case V2ConversationAPIType.updateConversationLocalExtension.rawValue:
      updateConversationLocalExtension(arguments, resultCallback)
    case V2ConversationAPIType.getTotalUnreadCount.rawValue:
      getTotalUnreadCount(arguments, resultCallback)
    case V2ConversationAPIType.getUnreadCountByIds.rawValue:
      getUnreadCountByIds(arguments, resultCallback)
    case V2ConversationAPIType.getUnreadCountByFilter.rawValue:
      getUnreadCountByFilter(arguments, resultCallback)
    case V2ConversationAPIType.clearTotalUnreadCount.rawValue:
      clearTotalUnreadCount(arguments, resultCallback)
    case V2ConversationAPIType.clearUnreadCountByIds.rawValue:
      clearUnreadCountByIds(arguments, resultCallback)
    case V2ConversationAPIType.clearUnreadCountByTypes.rawValue:
      clearUnreadCountByTypes(arguments, resultCallback)
    case V2ConversationAPIType.clearUnreadCountByGroupId.rawValue:
      clearUnreadCountByGroupId(arguments, resultCallback)
    case V2ConversationAPIType.subscribeUnreadCountByFilter.rawValue:
      subscribeUnreadCountByFilter(arguments, resultCallback)
    case V2ConversationAPIType.unsubscribeUnreadCountByFilter.rawValue:
      unsubscribeUnreadCountByFilter(arguments, resultCallback)
    case V2ConversationAPIType.getConversationReadTime.rawValue:
      getConversationReadTime(arguments, resultCallback)
    case V2ConversationAPIType.markConversationRead.rawValue:
      markConversationRead(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }
}

extension FLTConversationService {
  /**
   *  同步开始
   */
  func onSyncStarted() {
    notifyEvent(serviceName(), "onSyncStarted", nil)
  }

  /**
   *  同步完成
   */
  func onSyncFinished() {
    notifyEvent(serviceName(), "onSyncFinished", nil)
  }

  /**
   *  同步失败
   *
   *  @param error 错误
   */
  func onSyncFailed(_ error: V2NIMError) {
    notifyEvent(serviceName(), "onSyncFailed", ["error": [#keyPath(V2NIMError.code): error.code, #keyPath(V2NIMError.desc): error.desc]])
  }

  /**
   *  会话创建回调
   *
   *  @param conversation 会话
   */
  func onConversationCreated(_ conversation: V2NIMConversation) {
    notifyEvent(serviceName(), "onConversationCreated", conversation.toDictionary())
  }

  /**
   *  会话删除回调
   *
   *  @param conversationIds 会话id列表
   */
  func onConversationDeleted(_ conversationIds: [String]) {
    notifyEvent(serviceName(), "onConversationDeleted", ["conversationIdList": conversationIds])
  }

  /**
   *  会话变更回调
   *
   *  @param conversations 会话列表
   */

  func onConversationChanged(_ conversations: [V2NIMConversation]) {
    let conversationList = conversations.map { $0.toDictionary() }
    print("conversation list count ", conversationList.count)
    notifyEvent(serviceName(), "onConversationChanged", ["conversationList": conversationList])
  }

  /**
   *  总未读数变更回调
   *
   *  @param unreadCount 未读数
   */
  func onTotalUnreadCountChanged(_ unreadCount: Int) {
    notifyEvent(serviceName(), "onTotalUnreadCountChanged", ["unreadCount": unreadCount])
  }

  /**
   *  过滤器对应的未读数变更回调
   *
   *  @param filter 过滤器
   *  @param unreadCount 未读数
   */
  func onUnreadCountChanged(by filter: V2NIMConversationFilter, unreadCount: Int) {
    notifyEvent(serviceName(), "onUnreadCountChangedByFilter", ["conversationFilter": filter.toDictionary(), "unreadCount": unreadCount])
  }

  /**
   *  账号多端登录会话已读时间戳标记通知回调
   *
   *  @param conversationId 会话id
   *  @param readTime 标记的时间戳
   */
  func onConversationReadTimeUpdated(_ conversationId: String, readTime: TimeInterval) {
    notifyEvent(serviceName(), "onConversationReadTimeUpdated", ["conversationId": conversationId, "readTime": Int(readTime * 1000)])
  }
}
