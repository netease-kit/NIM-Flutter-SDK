// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum V2ConversationGroupAPIType: String {
  case createConversationGroup
  case deleteConversationGroup
  case updateConversationGroup
  case addConversationsToGroup
  case removeConversationsFromGroup
  case getConversationGroup
  case getConversationGroupList
  case getConversationGroupListByIds
}

@objcMembers
class FLTConversationGroupService: FLTBaseService, FLTService {
  private static let className = "FLTConversationGroupService"

  override func onInitialized() {
    NIMSDK.shared().v2ConversationGroupService.add(self)
  }

  deinit {
    NIMSDK.shared().v2ConversationGroupService.remove(self)
  }

  func serviceName() -> String {
    ServiceType.ConversationGroupService.rawValue
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any], _ resultCallback: ResultCallback) {
    switch method {
    case V2ConversationGroupAPIType.createConversationGroup.rawValue:
      createConversationGroup(arguments, resultCallback)
    case V2ConversationGroupAPIType.deleteConversationGroup.rawValue:
      deleteConversationGroup(arguments, resultCallback)
    case V2ConversationGroupAPIType.updateConversationGroup.rawValue:
      updateConversationGroup(arguments, resultCallback)
    case V2ConversationGroupAPIType.addConversationsToGroup.rawValue:
      addConversationsToGroup(arguments, resultCallback)
    case V2ConversationGroupAPIType.removeConversationsFromGroup.rawValue:
      removeConversationsFromGroup(arguments, resultCallback)
    case V2ConversationGroupAPIType.getConversationGroupList.rawValue:
      getConversationGroupList(arguments, resultCallback)
    case V2ConversationGroupAPIType.getConversationGroup.rawValue:
      getConversationGroup(arguments, resultCallback)
    case V2ConversationGroupAPIType.getConversationGroupListByIds.rawValue:
      getConversationGroupListByIds(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  // MARK: - SDK API

  /**
   *  创建会话分组
   *
   *  @param name 分组名
   *  @param serverExtension 服务器扩展字段
   *  @param conversationIds 会话id列表
   */
  func createConversationGroup(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let name = arguments["name"] as? String else {
      parameterError(resultCallback)
      return
    }

    let serverExtension = arguments["serverExtension"] as? String
    let conversationIds = arguments["conversationIds"] as? [String]

    weak var weakSelf = self
    NIMSDK.shared().v2ConversationGroupService.createConversationGroup(name, serverExtension: serverExtension, conversationIds: conversationIds) { result in
      weakSelf?.successCallBack(resultCallback, result.toDic())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTConversationGroupService.className, desc: "createConversationGroup error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  删除会话分组
   *
   *  @param groupId 分组id
   */
  func deleteConversationGroup(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let groupId = arguments["groupId"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2ConversationGroupService.deleteConversationGroup(groupId) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTConversationGroupService.className, desc: "deleteConversationGroup error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  更新会话分组
   *
   *  @param groupId 分组id
   *  @param name 分组名
   *  @param serverExtension 服务器扩展字段
   */
  func updateConversationGroup(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let groupId = arguments["groupId"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    let name = arguments["name"] as? String
    let serverExtension = arguments["serverExtension"] as? String
    NIMSDK.shared().v2ConversationGroupService.updateConversationGroup(groupId, name: name, serverExtension: serverExtension) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTConversationGroupService.className, desc: "updateConversationGroup error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  添加会话到分组
   *
   *  @param groupId 分组id
   *  @param conversationIds 会话id列表
   */
  func addConversationsToGroup(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let groupId = arguments["groupId"] as? String,
          let conversationIds = arguments["conversationIds"] as? [String] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2ConversationGroupService.addConversations(toGroup: groupId, conversationIds: conversationIds) { results in
      let resultsDic = results.map { $0.toDic() }
      weakSelf?.successCallBack(resultCallback, ["conversationOperationResults": resultsDic])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTConversationGroupService.className, desc: "addConversationsToGroup error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  从会话分组移除会话
   *
   *  @param groupId 分组id
   *  @param conversationIds 会话id列表
   */
  func removeConversationsFromGroup(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let groupId = arguments["groupId"] as? String,
          let conversationIds = arguments["conversationIds"] as? [String] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2ConversationGroupService.removeConversations(fromGroup: groupId, conversationIds: conversationIds) { results in
      let resultsDic = results.map { $0.toDic() }
      weakSelf?.successCallBack(resultCallback, ["conversationOperationResults": resultsDic])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTConversationGroupService.className, desc: "removeConversationsFromGroup error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  获取会话分组
   *
   *  @param groupId 分组Id
   */
  func getConversationGroup(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let groupId = arguments["groupId"] as? String else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2ConversationGroupService.getConversationGroup(groupId) { group in
      weakSelf?.successCallBack(resultCallback, group.toDic())
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTConversationGroupService.className, desc: "getConversationGroup error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  获取会话分组列表
   *
   */
  func getConversationGroupList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    weak var weakSelf = self
    NIMSDK.shared().v2ConversationGroupService.getConversationGroupList { groups in
      let groupsDic = groups.map { $0.toDic() }
      weakSelf?.successCallBack(resultCallback, ["conversationGroups": groupsDic])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTConversationGroupService.className, desc: "getConversationGroupList error \(error.nserror.localizedDescription)")
    }
  }

  /**
   *  获取会话分组列表
   *
   *  @param groupIds 分组Id列表
   */
  func getConversationGroupListByIds(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let groupIds = arguments["groupIds"] as? [String] else {
      parameterError(resultCallback)
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().v2ConversationGroupService.getConversationGroupList(byIds: groupIds) { groups in
      let groupsDic = groups.map { $0.toDic() }
      weakSelf?.successCallBack(resultCallback, ["conversationGroups": groupsDic])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(FLTConversationGroupService.className, desc: "getConversationGroupListByIds error \(error.nserror.localizedDescription)")
    }
  }
}

// MARK: - V2NIMConversationGroupListener

extension FLTConversationGroupService: V2NIMConversationGroupListener {
  /**
   *  会话分组创建回调
   *
   *  @param conversationGroup 会话分组
   */
  func onConversationGroupCreated(_ conversationGroup: V2NIMConversationGroup) {
    notifyEvent(serviceName(), "onConversationGroupCreated", conversationGroup.toDic())
  }

  /**
   *  会话分组删除回调
   *
   *  @param groupId 分组id
   */
  func onConversationGroupDeleted(_ groupId: String) {
    notifyEvent(serviceName(), "onConversationGroupDeleted", ["groupId": groupId])
  }

  /**
   *  会话分组变更回调
   *
   *  @param conversationGroup 会话分组
   */
  func onConversationGroupChanged(_ conversationGroup: V2NIMConversationGroup) {
    notifyEvent(serviceName(), "onConversationGroupChanged", conversationGroup.toDic())
  }

  /**
   *  会话分组删除回调
   *
   *  @param groupId 分组id
   *  @param conversations 会话列表
   */
  func onConversationsAdded(toGroup groupId: String, conversations: [V2NIMConversation]) {
    let conversationsDic = conversations.map { $0.toDictionary() }
    notifyEvent(serviceName(), "onConversationsAddedToGroup", ["groupId": groupId,
                                                               "conversations": conversationsDic])
  }

  /**
   *  会话分组删除回调
   *
   *  @param groupId 分组id
   *  @param conversationIds 会话id列表
   */
  func onConversationsRemoved(fromGroup groupId: String, conversationIds: [String]) {
    notifyEvent(serviceName(), "onConversationsRemovedFromGroup", ["groupId": groupId,
                                                                   "conversationIds": conversationIds])
  }
}
