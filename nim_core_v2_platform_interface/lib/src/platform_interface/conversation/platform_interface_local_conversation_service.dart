// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../../nim_core_v2_platform_interface.dart';
import '../../method_channel/method_channel_local_conversation_service.dart';

abstract class LocalConversationServicePlatform extends Service {
  LocalConversationServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static LocalConversationServicePlatform _instance =
      MethodChannelLocalConversationService();

  static LocalConversationServicePlatform get instance => _instance;

  static set instance(LocalConversationServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<List<NIMConversation>> get onConversationChanged;

  Stream<NIMConversation> get onConversationCreated;

  Stream<List<String>> get onConversationDeleted;

  Stream<ReadTimeUpdateResult> get onConversationReadTimeUpdated;

  Stream<void> get onSyncFailed;

  Stream<void> get onSyncFinished;

  Stream<void> get onSyncStarted;

  Stream<int> get onTotalUnreadCountChanged;

  Stream<UnreadChangeFilterResult> get onUnreadCountChangedByFilter;

  /// 获取本地会话列表
  ///
  /// @param offset  分页偏移，首次传0，后续拉取采用上一次返回的offset
  /// @param limit   分页拉取数量，不建议超过100;
  Future<NIMResult<NIMConversationResult>> getConversationList(
      int offset, int limit) {
    throw UnimplementedError('getConversationList() is not implemented');
  }

  /// 根据查询参数获取本地会话列表
  ///
  /// @param offset  分页偏移，首次传0，后续拉取采用上一次返回的offset
  /// @param limit   分页拉取数量，不建议超过100;
  /// @param option  查询选项
  Future<NIMResult<NIMConversationResult>> getConversationListByOption(
      int offset, int limit, NIMConversationOption? option) {
    throw UnimplementedError(
        'getConversationListByOption() is not implemented');
  }

  /// 获取本地会话列表，通过会话id
  ///
  /// @param conversationId 会话id
  Future<NIMResult<NIMConversation>> getConversation(String conversationId) {
    throw UnimplementedError('getConversation() is not implemented');
  }

  /// 根据会话id获取本地会话列表
  ///
  /// @param conversationIds 会话id列表
  Future<NIMResult<List<NIMConversation>>> getConversationListByIds(
      List<String> conversationIds) {
    throw UnimplementedError('getConversationListByIds() is not implemented');
  }

  /// 创建本地会话
  ///
  /// @param conversationId 会话id
  Future<NIMResult<NIMConversation>> createConversation(String conversationId) {
    throw UnimplementedError('createConversation() is not implemented');
  }

  /// 删除本地会话
  ///
  /// @param conversationId 会话id
  /// @param clearMessage   是否删除会话消息
  Future<NIMResult<void>> deleteConversation(
      String conversationId, bool clearMessage) {
    throw UnimplementedError('deleteConversation() is not implemented');
  }

  /// 删除本地会话列表
  ///
  /// @param conversationIds 会话id列表
  /// @param clearMessage    是否删除会话消息
  Future<NIMResult<List<NIMConversationOperationResult>>>
      deleteConversationListByIds(
          List<String> conversationIds, bool clearMessage) {
    throw UnimplementedError(
        'deleteConversationListByIds() is not implemented');
  }

  /// 置顶会话
  ///
  /// @param conversationId 会话id
  /// @param stickTop       是否置顶,true：置顶, false：取消置顶
  Future<NIMResult<void>> stickTopConversation(
      String conversationId, bool stickTop) {
    throw UnimplementedError('stickTopConversation() is not implemented');
  }

  /// 更新本地会话本地扩展字段
  ///
  /// @param conversationId 会话id
  /// @param localExtension 本地扩展字段更新信息
  Future<NIMResult<void>> updateConversationLocalExtension(
      String conversationId, String localExtension) {
    throw UnimplementedError(
        'updateConversationLocalExtension() is not implemented');
  }

  /// 获取本地会话总未读数
  ///
  /// @return 会话总未读数
  Future<NIMResult<int>> getTotalUnreadCount() {
    throw UnimplementedError('getTotalUnreadCount() is not implemented');
  }

  /// 根据会话id获取本地会话未读数
  ///
  /// @param conversationIds 会话id列表
  Future<NIMResult<int>> getUnreadCountByIds(List<String> conversationIds) {
    throw UnimplementedError('getUnreadCountByIds() is not implemented');
  }

  /// 根据过滤条件获取相应本地会话的未读数
  ///
  /// @param filter  查询选项
  Future<NIMResult<int>> getUnreadCountByFilter(NIMConversationFilter filter) {
    throw UnimplementedError('getUnreadCountByFilter() is not implemented');
  }

  /// 清空本地会话未读数
  Future<NIMResult<void>> clearTotalUnreadCount() {
    throw UnimplementedError('clearTotalUnreadCount() is not implemented');
  }

  /// 根据会话id清空本地会话未读数
  ///
  /// @param conversationIds 会话id列表
  Future<NIMResult<List<NIMConversationOperationResult>>> clearUnreadCountByIds(
      List<String> conversationIds) {
    throw UnimplementedError('clearUnreadCountByIds() is not implemented');
  }

  /// 根据会话类型清空相应本地会话的未读数
  ///
  /// @param conversationTypes
  Future<NIMResult<void>> clearUnreadCountByTypes(
      List<NIMConversationType> conversationTypes) {
    throw UnimplementedError('clearUnreadCountByTypes() is not implemented');
  }

  /// 订阅指定过滤条件的本地会话未读数
  ///
  /// @param filter 过滤条件
  /// @return 是否订阅成功，成功返回null，失败返回V2NIMError
  Future<NIMResult<NIMError?>> subscribeUnreadCountByFilter(
      NIMConversationFilter filter) {
    throw UnimplementedError(
        'subscribeUnreadCountByFilter() is not implemented');
  }

  /// 取消订阅指定过滤条件的本地会话未读数
  /// filter 过滤条件
  /// @return 是否取消订阅成功，成功返回null，失败返回V2NIMError
  Future<NIMResult<NIMError?>> unsubscribeUnreadCountByFilter(
      NIMConversationFilter filter) {
    throw UnimplementedError(
        'unsubscribeUnreadCountByFilter() is not implemented');
  }

  /// 获取本地会话已读时间戳
  /// 当前只支持P2P，高级群， 超大群
  ///
  /// @param conversationId 会话ID
  Future<NIMResult<int>> getConversationReadTime(String conversationId) {
    throw UnimplementedError('getConversationReadTime() is not implemented');
  }

  /// 标记会话已读时间戳
  /// 当前只支持P2P，高级群， 超大群
  ///
  /// @param conversationId 会话ID
  Future<NIMResult<int>> markConversationRead(String conversationId) {
    throw UnimplementedError('markConversationRead() is not implemented');
  }

  /// 查询当前全量置顶的会话列表
  /// 排序方式：倒序
  Future<NIMResult<List<NIMConversation>>> getStickTopConversationList() async {
    throw UnimplementedError(
        'getStickTopConversationList() is not implemented');
  }

  /// 设置当前聊天账号
  ///
  /// @param conversationId 会话id
  Future<NIMResult<void>> setCurrentConversation(String conversationId) {
    throw UnimplementedError('setCurrentConversation() is not implemented');
  }
}
