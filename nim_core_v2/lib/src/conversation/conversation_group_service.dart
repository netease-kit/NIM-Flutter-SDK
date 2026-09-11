// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

/// 会话分组服务
@HawkEntryPoint()
class V2NIMConversationGroupService {
  factory V2NIMConversationGroupService() {
    if (_singleton == null) {
      _singleton = V2NIMConversationGroupService._();
    }
    return _singleton!;
  }

  V2NIMConversationGroupService._();

  static V2NIMConversationGroupService? _singleton;

  ConversationServiceGroupPlatform get _platform =>
      ConversationServiceGroupPlatform.instance;

  /// 会话分组创建回调
  @HawkApi(ignore: true)
  Stream<V2NIMConversationGroup> get onConversationGroupCreated =>
      _platform.onConversationGroupCreated;

  /// 会话分组删除回调
  @HawkApi(ignore: true)
  Stream<String> get onConversationGroupDeleted =>
      _platform.onConversationGroupDeleted;

  /// 会话分组改变回调
  @HawkApi(ignore: true)
  Stream<V2NIMConversationGroup> get onConversationGroupChanged =>
      _platform.onConversationGroupChanged;

  /// 会话添加到分组回调
  @HawkApi(ignore: true)
  Stream<ConversationsAddedEvent> get onConversationsAddedToGroup =>
      _platform.onConversationsAddedToGroup;

  /// 会话从分组移除回调
  @HawkApi(ignore: true)
  Stream<ConversationsRemovedEvent> get onConversationsRemovedFromGroup =>
      _platform.onConversationsRemovedFromGroup;

  /// 创建会话分组
  ///
  /// [name] 分组名
  /// [conversationIds] 会话id列表
  /// [serverExtension] 服务器扩展字段
  Future<NIMResult<V2NIMConversationGroupResult>> createConversationGroup(
      String name, List<String> conversationIds,
      {String? serverExtension}) {
    return _platform.createConversationGroup(
        name, serverExtension, conversationIds);
  }

  /// 删除会话分组
  ///
  /// [groupId] 分组id
  Future<NIMResult<void>> deleteConversationGroup(String groupId) {
    return _platform.deleteConversationGroup(groupId);
  }

  /// 更新会话分组
  ///
  /// [groupId] 分组id
  /// [name] 分组名，传 null 表示不更新分组名
  /// [serverExtension] 服务器扩展字段
  Future<NIMResult<void>> updateConversationGroup(String groupId, String? name,
      {String? serverExtension}) {
    return _platform.updateConversationGroup(groupId, name, serverExtension);
  }

  /// 添加会话到分组
  ///
  /// [groupId] 分组id
  /// [conversationIds] 会话id列表
  Future<NIMResult<List<V2NIMConversationOperationResult>>>
      addConversationsToGroup(String groupId, List<String> conversationIds) {
    return _platform.addConversationsToGroup(groupId, conversationIds);
  }

  /// 从会话分组移除会话
  ///
  /// [groupId] 分组id
  /// [conversationIds] 会话id列表
  Future<NIMResult<List<V2NIMConversationOperationResult>>>
      removeConversationsFromGroup(
          String groupId, List<String> conversationIds) {
    return _platform.removeConversationsFromGroup(groupId, conversationIds);
  }

  /// 获取会话分组
  ///
  /// [groupId] 分组Id
  Future<NIMResult<V2NIMConversationGroup>> getConversationGroup(
      String groupId) {
    return _platform.getConversationGroup(groupId);
  }

  /// 获取会话分组列表
  Future<NIMResult<List<V2NIMConversationGroup>>> getConversationGroupList() {
    return _platform.getConversationGroupList();
  }

  /// 获取会话分组列表
  ///
  /// [groupIds] 分组Id列表
  Future<NIMResult<List<V2NIMConversationGroup>>> getConversationGroupListByIds(
      List<String> groupIds) {
    return _platform.getConversationGroupListByIds(groupIds);
  }
}
