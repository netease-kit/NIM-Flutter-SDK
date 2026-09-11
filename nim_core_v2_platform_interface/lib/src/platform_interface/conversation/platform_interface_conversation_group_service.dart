// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../../nim_core_v2_platform_interface.dart';
import '../../method_channel/method_channel_conversation_group_service.dart';

abstract class ConversationServiceGroupPlatform extends Service {
  ConversationServiceGroupPlatform() : super(token: _token);

  static final Object _token = Object();

  static ConversationServiceGroupPlatform _instance =
      MethodChannelConversationGroupService();

  static ConversationServiceGroupPlatform get instance => _instance;

  static set instance(ConversationServiceGroupPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 会话分组创建回调
  Stream<V2NIMConversationGroup> get onConversationGroupCreated;

  /// 会话分组删除回调
  Stream<String> get onConversationGroupDeleted;

  /// 会话分组改变回调
  Stream<V2NIMConversationGroup> get onConversationGroupChanged;

  /// 会话添加到分组回调
  Stream<ConversationsAddedEvent> get onConversationsAddedToGroup;

  /// 会话从分组移除回调
  Stream<ConversationsRemovedEvent> get onConversationsRemovedFromGroup;

  /// 创建会话分组
  ///
  /// [name] 分组名
  /// [conversationIds] 会话id列表
  /// [serverExtension] 服务器扩展字段
  Future<NIMResult<V2NIMConversationGroupResult>> createConversationGroup(
      String name, String? serverExtension, List<String> conversationIds) {
    throw UnimplementedError('createConversationGroup() is not implemented');
  }

  /// 删除会话分组
  ///
  /// [groupId] 分组id
  Future<NIMResult<void>> deleteConversationGroup(String groupId) {
    throw UnimplementedError('deleteConversationGroup() is not implemented');
  }

  /// 更新会话分组
  ///
  /// [groupId] 分组id
  /// [name] 分组名，传 null 表示不更新分组名
  /// [serverExtension] 服务器扩展字段
  Future<NIMResult<void>> updateConversationGroup(
      String groupId, String? name, String? serverExtension) {
    throw UnimplementedError('updateConversationGroup() is not implemented');
  }

  /// 添加会话到分组
  ///
  /// [groupId] 分组id
  /// [conversationIds] 会话id列表
  Future<NIMResult<List<V2NIMConversationOperationResult>>>
      addConversationsToGroup(String groupId, List<String> conversationIds) {
    throw UnimplementedError('addConversationsToGroup() is not implemented');
  }

  /// 从会话分组移除会话
  ///
  /// [groupId] 分组id
  /// [conversationIds] 会话id列表
  Future<NIMResult<List<V2NIMConversationOperationResult>>>
      removeConversationsFromGroup(
          String groupId, List<String> conversationIds) {
    throw UnimplementedError(
        'removeConversationsFromGroup() is not implemented');
  }

  /// 获取会话分组
  ///
  /// [groupId] 分组Id
  Future<NIMResult<V2NIMConversationGroup>> getConversationGroup(
      String groupId) {
    throw UnimplementedError('getConversationGroup() is not implemented');
  }

  /// 获取会话分组列表
  Future<NIMResult<List<V2NIMConversationGroup>>> getConversationGroupList() {
    throw UnimplementedError('getConversationGroupList() is not implemented');
  }

  /// 获取会话分组列表
  ///
  /// [groupIds] 分组Id列表
  Future<NIMResult<List<V2NIMConversationGroup>>> getConversationGroupListByIds(
      List<String> groupIds) {
    throw UnimplementedError(
        'getConversationGroupListByIds() is not implemented');
  }
}
