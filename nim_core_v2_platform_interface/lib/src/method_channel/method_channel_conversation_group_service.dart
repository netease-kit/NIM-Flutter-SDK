// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import '../../nim_core_v2_platform_interface.dart';

class MethodChannelConversationGroupService
    extends ConversationServiceGroupPlatform {
  final _conversationGroupChangedController =
      StreamController<V2NIMConversationGroup>.broadcast();

  final _conversationGroupCreatedController =
      StreamController<V2NIMConversationGroup>.broadcast();

  final _conversationGroupDeletedController =
      StreamController<String>.broadcast();

  final _conversationAddedToGroupController =
      StreamController<ConversationsAddedEvent>.broadcast();

  final _conversationRemoveFromGroupController =
      StreamController<ConversationsRemovedEvent>.broadcast();

  @override
  Future onEvent(String method, arguments) {
    assert(arguments is Map);
    switch (method) {
      case 'onConversationGroupCreated':
        assert(arguments is Map);
        _conversationGroupCreatedController.add(V2NIMConversationGroup.fromJson(
            Map<String, dynamic>.from(arguments)));
        break;
      case 'onConversationGroupDeleted':
        assert(arguments is Map);
        _conversationGroupDeletedController.add(arguments['groupId']);
        break;
      case 'onConversationGroupChanged':
        assert(arguments is Map);
        _conversationGroupChangedController.add(V2NIMConversationGroup.fromJson(
            Map<String, dynamic>.from(arguments)));
        break;
      case 'onConversationsAddedToGroup':
        assert(arguments is Map);
        _conversationAddedToGroupController.add(
            ConversationsAddedEvent.fromJson(
                Map<String, dynamic>.from(arguments)));
        break;
      case 'onConversationsRemovedFromGroup':
        assert(arguments is Map);
        _conversationRemoveFromGroupController.add(
            ConversationsRemovedEvent.fromJson(
                Map<String, dynamic>.from(arguments)));
        break;
      default:
        throw UnimplementedError();
    }
    return Future.value();
  }

  @override
  String get serviceName => "V2NIMConversationGroupService";

  @override
  Stream<V2NIMConversationGroup> get onConversationGroupChanged =>
      _conversationGroupChangedController.stream;

  @override
  Stream<V2NIMConversationGroup> get onConversationGroupCreated =>
      _conversationGroupCreatedController.stream;

  @override
  Stream<String> get onConversationGroupDeleted =>
      _conversationGroupDeletedController.stream;

  @override
  Stream<ConversationsAddedEvent> get onConversationsAddedToGroup =>
      _conversationAddedToGroupController.stream;

  @override
  Stream<ConversationsRemovedEvent> get onConversationsRemovedFromGroup =>
      _conversationRemoveFromGroupController.stream;

  /// 创建会话分组
  ///
  /// [name] 分组名
  /// [conversationIds] 会话id列表
  /// [serverExtension] 服务器扩展字段
  Future<NIMResult<V2NIMConversationGroupResult>> createConversationGroup(
      String name,
      String? serverExtension,
      List<String> conversationIds) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'createConversationGroup',
          arguments: {
            'name': name,
            'serverExtension': serverExtension,
            'conversationIds': conversationIds,
          },
        ),
        convert: (json) => V2NIMConversationGroupResult.fromJson(
            Map<String, dynamic>.from(json)));
  }

  /// 删除会话分组
  ///
  /// [groupId] 分组id
  Future<NIMResult<void>> deleteConversationGroup(String groupId) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'deleteConversationGroup',
        arguments: {
          'groupId': groupId,
        },
      ),
    );
  }

  /// 更新会话分组
  ///
  /// [groupId] 分组id
  /// [name] 分组名，传 null 表示不更新分组名
  /// [serverExtension] 服务器扩展字段
  Future<NIMResult<void>> updateConversationGroup(
      String groupId, String? name, String? serverExtension) async {
    return NIMResult.fromMap(
        await invokeMethod('updateConversationGroup', arguments: {
      'groupId': groupId,
      'name': name,
      'serverExtension': serverExtension,
    }));
  }

  /// 添加会话到分组
  ///
  /// [groupId] 分组id
  /// [conversationIds] 会话id列表
  Future<NIMResult<List<V2NIMConversationOperationResult>>>
      addConversationsToGroup(
          String groupId, List<String> conversationIds) async {
    return NIMResult.fromMap(
        await invokeMethod('addConversationsToGroup', arguments: {
          'groupId': groupId,
          'conversationIds': conversationIds,
        }),
        convert: (json) =>
            (json['conversationOperationResults'] as List<dynamic>?)
                ?.map((e) => V2NIMConversationOperationResult.fromJson(
                    Map<String, dynamic>.from(e)))
                .toList());
  }

  /// 从会话分组移除会话
  ///
  /// [groupId] 分组id
  /// [conversationIds] 会话id列表
  Future<NIMResult<List<V2NIMConversationOperationResult>>>
      removeConversationsFromGroup(
          String groupId, List<String> conversationIds) async {
    return NIMResult.fromMap(
        await invokeMethod('removeConversationsFromGroup', arguments: {
          'groupId': groupId,
          'conversationIds': conversationIds,
        }),
        convert: (json) =>
            (json['conversationOperationResults'] as List<dynamic>?)
                ?.map((e) => V2NIMConversationOperationResult.fromJson(
                    Map<String, dynamic>.from(e)))
                .toList());
  }

  /// 获取会话分组
  ///
  /// [groupId] 分组Id
  Future<NIMResult<V2NIMConversationGroup>> getConversationGroup(
      String groupId) async {
    return NIMResult.fromMap(
        await invokeMethod('getConversationGroup', arguments: {
          'groupId': groupId,
        }),
        convert: (json) =>
            V2NIMConversationGroup.fromJson(Map<String, dynamic>.from(json)));
  }

  /// 获取会话分组列表
  Future<NIMResult<List<V2NIMConversationGroup>>>
      getConversationGroupList() async {
    return NIMResult.fromMap(
        await invokeMethod(
          'getConversationGroupList',
        ),
        convert: (json) => (json['conversationGroups'] as List<dynamic>?)
            ?.map((e) =>
                V2NIMConversationGroup.fromJson(Map<String, dynamic>.from(e)))
            .toList());
  }

  /// 获取会话分组列表
  ///
  /// [groupIds] 分组Id列表
  Future<NIMResult<List<V2NIMConversationGroup>>> getConversationGroupListByIds(
      List<String> groupIds) async {
    return NIMResult.fromMap(
        await invokeMethod('getConversationGroupListByIds', arguments: {
          'groupIds': groupIds,
        }),
        convert: (json) => (json['conversationGroups'] as List<dynamic>?)
            ?.map((e) =>
                V2NIMConversationGroup.fromJson(Map<String, dynamic>.from(e)))
            .toList());
  }
}
