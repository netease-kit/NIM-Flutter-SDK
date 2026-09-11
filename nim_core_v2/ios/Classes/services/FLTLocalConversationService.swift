// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum V2LocalConversationAPIType: String {
  case getConversationList
  case getConversationListByOption
  case getConversationListByIds
  case getConversation
  case createConversation
  case deleteConversation
  case deleteConversationListByIds
  case stickTopConversation
  case updateConversationLocalExtension
  case getTotalUnreadCount
  case getUnreadCountByIds
  case getUnreadCountByFilter
  case clearTotalUnreadCount
  case clearUnreadCountByIds
  case clearUnreadCountByTypes
  case subscribeUnreadCountByFilter
  case unsubscribeUnreadCountByFilter
  case getConversationReadTime
  case markConversationRead
  case getStickTopConversationList
  case setCurrentConversation
}

@objcMembers
class FLTLocalConversationService: FLTBaseService, FLTService, V2NIMLocalConversationListener {
  private static let className = "FLTLocalConversationService"

  override func onInitialized() {
    NIMSDK.shared().v2LocalConversationService.add(self)
  }

  deinit {
    NIMSDK.shared().v2LocalConversationService.remove(self)
  }

  func serviceName() -> String {
    ServiceType.LocalConversationService.rawValue
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any], _ resultCallback: ResultCallback) {
    switch method {
    case V2LocalConversationAPIType.getConversationList.rawValue:
      getConversationList(arguments, resultCallback)
    case V2LocalConversationAPIType.getConversationListByOption.rawValue:
      getConversationListByOption(arguments, resultCallback)
    case V2LocalConversationAPIType.getConversationListByIds.rawValue:
      getConversationListByIds(arguments, resultCallback)
    case V2LocalConversationAPIType.getConversation.rawValue:
      getConversation(arguments, resultCallback)
    case V2LocalConversationAPIType.createConversation.rawValue:
      createConversation(arguments, resultCallback)
    case V2LocalConversationAPIType.deleteConversation.rawValue:
      deleteConversation(arguments, resultCallback)
    case V2LocalConversationAPIType.deleteConversationListByIds.rawValue:
      deleteConversationListByIds(arguments, resultCallback)
    case V2LocalConversationAPIType.stickTopConversation.rawValue:
      stickTopConversation(arguments, resultCallback)
    case V2LocalConversationAPIType.updateConversationLocalExtension.rawValue:
      updateConversationLocalExtension(arguments, resultCallback)
    case V2LocalConversationAPIType.getTotalUnreadCount.rawValue:
      getTotalUnreadCount(arguments, resultCallback)
    case V2LocalConversationAPIType.getUnreadCountByIds.rawValue:
      getUnreadCountByIds(arguments, resultCallback)
    case V2LocalConversationAPIType.getUnreadCountByFilter.rawValue:
      getUnreadCountByFilter(arguments, resultCallback)
    case V2LocalConversationAPIType.clearTotalUnreadCount.rawValue:
      clearTotalUnreadCount(arguments, resultCallback)
    case V2LocalConversationAPIType.clearUnreadCountByIds.rawValue:
      clearUnreadCountByIds(arguments, resultCallback)
    case V2LocalConversationAPIType.clearUnreadCountByTypes.rawValue:
      clearUnreadCountByTypes(arguments, resultCallback)
    case V2LocalConversationAPIType.subscribeUnreadCountByFilter.rawValue:
      subscribeUnreadCountByFilter(arguments, resultCallback)
    case V2LocalConversationAPIType.unsubscribeUnreadCountByFilter.rawValue:
      unsubscribeUnreadCountByFilter(arguments, resultCallback)
    case V2LocalConversationAPIType.getConversationReadTime.rawValue:
      getConversationReadTime(arguments, resultCallback)
    case V2LocalConversationAPIType.markConversationRead.rawValue:
      markConversationRead(arguments, resultCallback)
    case V2LocalConversationAPIType.getStickTopConversationList.rawValue:
      getStickTopConversationList(arguments, resultCallback)
    case V2LocalConversationAPIType.setCurrentConversation.rawValue:
      setCurrentConversation(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  /// 获取会话列表
  func getConversationList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let offset = arguments["offset"] as? Int,
          let limit = arguments["limit"] as? Int else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2LocalConversationService.getConversationList(offset, limit: limit) { result in
      let resultDic = result.toDic()
      print("getConversationList result ", resultDic)
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "getConversationList error \(error.nserror.localizedDescription)")
    }
  }

  /// 获取置顶会话列表
  func getStickTopConversationList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    weak var weakSelf = self
    NIMSDK.shared().v2LocalConversationService.getStickTopConversationList { conversations in
      weakSelf?.successCallBack(resultCallback, ["conversationList": conversations.map { $0.toDic() }])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "getStickTopConversationList error \(error.nserror.localizedDescription)")
    }
  }

  /// 根据查询参数获取会话列表
  func getConversationListByOption(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let optionArgument = arguments["option"] as? [String: Any],
          let offset = arguments["offset"] as? Int,
          let limit = arguments["limit"] as? Int else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    let option = V2NIMLocalConversationOption.fromDic(optionArgument)
    NIMSDK.shared().v2LocalConversationService.getConversationList(byOption: offset, limit: limit, option: option) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "getConversationListByOption error \(error.nserror.localizedDescription)")
    }
  }

  /// 获取会话列表，通过会话id列表
  func getConversationListByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationIds = arguments["conversationIdList"] as? [String] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2LocalConversationService.getConversationList(byIds: conversationIds) { conversations in
      weakSelf?.successCallBack(resultCallback, ["conversationList": conversations.map { $0.toDic() }])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "getConversationListByIds error \(error.nserror.localizedDescription)")
    }
  }

  /// 获取会话
  func getConversation(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2LocalConversationService.getConversation(conversationId) { conversation in
      weakSelf?.successCallBack(resultCallback, conversation.toDic())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "getConversation error \(error.nserror.localizedDescription)")
    }
  }

  func setCurrentConversation(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    var error: V2NIMError?
    NIMSDK.shared().v2LocalConversationService.setCurrentConversation(conversationId, error: &error)

    if let error = error {
      // 处理错误情况
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "setCurrentConversation error \(error.nserror.localizedDescription)")
    } else {
      // 成功回调，返回空或成功标识
      weakSelf?.successCallBack(resultCallback, ["success": true])
    }
  }

  /// 创建会话
  func createConversation(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2LocalConversationService.createConversation(conversationId) { conversation in
      let conversationDic = conversation.toDic()
      print("converation dic : \(conversationDic)")
      weakSelf?.successCallBack(resultCallback, conversationDic)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "createConversation error \(error.nserror.localizedDescription)")
    }
  }

  /// 删除会话
  func deleteConversation(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String, let clearMessage = arguments["clearMessage"] as? Bool else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2LocalConversationService.deleteConversation(conversationId, clearMessage: clearMessage) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "deleteConversation error \(error.nserror.localizedDescription)")
    }
  }

  /// 批量删除会话
  func deleteConversationListByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationIds = arguments["conversationIdList"] as? [String], let clearMessage = arguments["clearMessage"] as? Bool else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2LocalConversationService.deleteConversationList(byIds: conversationIds, clearMessage: clearMessage) { result in
      var resultList = [[String: Any]]()
      for result in result {
        resultList.append(result.toDic())
      }
      weakSelf?.successCallBack(resultCallback, ["conversationOperationResult": resultList])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "deleteConversationListByIds error \(error.nserror.localizedDescription)")
    }
  }

  /// 置顶会话
  func stickTopConversation(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String, let stickTop = arguments["stickTop"] as? Bool else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2LocalConversationService.stickTopConversation(conversationId, stickTop: stickTop, success: {
      weakSelf?.successCallBack(resultCallback, nil)
    }) { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "stickTopConversation error \(error.nserror.localizedDescription)")
    }
  }

  /// 更新会话本地扩展字段
  func updateConversationLocalExtension(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String,
          let localExtension = arguments["localExtension"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2LocalConversationService.updateConversationLocalExtension(conversationId, localExtension: localExtension) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "updateConversationLocalExtension error \(error.nserror.localizedDescription)")
    }
  }

  /// 获取全部会话的总的未读数
  func getTotalUnreadCount(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let count = NIMSDK.shared().v2LocalConversationService.getTotalUnreadCount()
    successCallBack(resultCallback, count)
  }

  /// 根据会话id列表获取相应的未读数
  func getUnreadCountByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationIds = arguments["conversationIdList"] as? [String] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2LocalConversationService.getUnreadCount(byIds: conversationIds) { unreadCount in
      weakSelf?.successCallBack(resultCallback, unreadCount)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "getUnreadCountByIds error \(error.nserror.localizedDescription)")
    }
  }

  /// 根据过滤条件获取相应的未读数
  func getUnreadCountByFilter(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let filter = V2NIMLocalConversationFilter.fromDic(arguments)
    weak var weakSelf = self
    NIMSDK.shared().v2LocalConversationService.getUnreadCount(by: filter) { unreadCount in
      weakSelf?.successCallBack(resultCallback, unreadCount)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "getUnreadCountByFilter error \(error.nserror.localizedDescription)")
    }
  }

  /// 清空所有会话的总未读数
  func clearTotalUnreadCount(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    weak var weakSelf = self
    NIMSDK.shared().v2LocalConversationService.clearTotalUnreadCount {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "clearTotalUnreadCount error \(error.nserror.localizedDescription)")
    }
  }

  /// 根据会话id列表清空相应会话的未读数
  func clearUnreadCountByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationIds = arguments["conversationIdList"] as? [String] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2LocalConversationService.clearUnreadCount(byIds: conversationIds) { resultList in
      var list = [[String: Any]]()
      for result in resultList {
        list.append(result.toDic())
      }
      weakSelf?.successCallBack(resultCallback, ["conversationOperationResult": list])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "clearUnreadCountByIds error \(error.nserror.localizedDescription)")
    }
  }

  /// 根据会话类型列表清空相应会话的未读数
  func clearUnreadCountByTypes(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let types = arguments["conversationTypeList"] as? [NSNumber] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2LocalConversationService.clearUnreadCount(byTypes: types) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "clearUnreadCountByTypes error \(error.nserror.localizedDescription)")
    }
  }

  /// 订阅指定过滤条件的会话未读数
  func subscribeUnreadCountByFilter(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let filterArgument = arguments["filter"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    let filter = V2NIMLocalConversationFilter.fromDic(filterArgument)
    let error = NIMSDK.shared().v2LocalConversationService.subscribeUnreadCount(by: filter)
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
    let filter = V2NIMLocalConversationFilter.fromDic(filterArgument)
    NIMSDK.shared().v2LocalConversationService.unsubscribeUnreadCount(by: filter)
    successCallBack(resultCallback, nil)
  }

  /// 获取会话已读时间戳
  func getConversationReadTime(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2LocalConversationService.getConversationReadTime(conversationId) { time in
      weakSelf?.successCallBack(resultCallback, Int64(time * 1000))
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "getConversationReadTime error \(error.nserror.localizedDescription)")
    }
  }

  /// 标记会话已读时间戳
  func markConversationRead(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2LocalConversationService.markConversationRead(conversationId) { time in
      weakSelf?.successCallBack(resultCallback, Int(time * 1000))
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTLocalConversationService.className, desc: "markConversationRead error \(error.nserror.localizedDescription)")
    }
  }
}

extension FLTLocalConversationService {
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
    notifyEvent(serviceName(), "onSyncFailed", ["error": error.toDic()])
  }

  /**
   * 会话创建回调
   * 主要为主动创建会话回调
   * 多端内容同步变更
   *
   * @param conversation 新创建的本地会话
   */
  func onConversationCreated(_ conversation: V2NIMLocalConversation) {
    notifyEvent(serviceName(), "onConversationCreated", conversation.toDic())
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
   * 会话变更回调
   * 会话置顶
   * 会话静音
   * 新消息导致内容变更
   * 多端内容同步变更
   *
   * @param conversationList 相应变更的会话列表
   */
  func onConversationChanged(_ conversationList: [V2NIMLocalConversation]) {
    let conversationList = conversationList.map { $0.toDic() }
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
  func onUnreadCountChanged(by filter: V2NIMLocalConversationFilter, unreadCount: Int) {
    notifyEvent(serviceName(), "onUnreadCountChangedByFilter", ["conversationFilter": filter.toDic(),
                                                                "unreadCount": unreadCount])
  }

  /**
   *  账号多端登录会话已读时间戳标记通知回调
   *
   *  @param conversationId 会话id
   *  @param readTime 标记的时间戳
   */
  func onConversationReadTimeUpdated(_ conversationId: String, readTime: TimeInterval) {
    notifyEvent(serviceName(), "onConversationReadTimeUpdated", ["conversationId": conversationId,
                                                                 "readTime": Int(readTime * 1000)])
  }
}
