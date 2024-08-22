// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../../nim_core_v2_platform_interface.dart';
import '../../method_channel/method_channel_conversation_service.dart';

abstract class ConversationServicePlatform extends Service {
  ConversationServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static ConversationServicePlatform _instance =
      MethodChannelConversationService();

  static ConversationServicePlatform get instance => _instance;

  static set instance(ConversationServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 会话同步开始
  Stream<void> get onSyncStarted;

  /// 会话同步完成
  Stream<void> get onSyncFinished;

  /// 会话同步失败
  Stream<void> get onSyncFailed;

  /// 会话创建
  Stream<NIMConversation> get onConversationCreated;

  /// 会话删除
  Stream<List<String>> get onConversationDeleted;

  /// 会话更新
  Stream<List<NIMConversation>> get onConversationChanged;

  /// 会话未读消息计数更新
  Stream<int> get onTotalUnreadCountChanged;

  /// 未读数改变回调
  Stream<UnreadChangeFilterResult> get onUnreadCountChangedByFilter;

  /// 账号多端登录会话已读时间戳标记通知 账号A登录设备D1, D2, D1会话已读时间戳标记，同步到D2成
  Stream<ReadTimeUpdateResult> get onConversationReadTimeUpdated;

  /// 获取会话列表
  /// offset – 分页偏移，首次传0，后续拉取采用上一次返回的offset limit – 分页拉取数量，不建议超过100;
  Future<NIMResult<NIMConversationResult>> getConversationList(
      int offset, int limit) async {
    throw UnimplementedError('getConversationList() is not implemented');
  }

  /// 根据查询参数获取会话列表
  /// offset – 分页偏移，首次传0，后续拉取采用上一次返回的offset
  /// limit – 分页拉取数量，不建议超过100;
  /// option – 查询选项
  Future<NIMResult<NIMConversationResult>> getConversationListByOption(
      int offset, int limit, NIMConversationOption option) async {
    throw UnimplementedError(
        'getConversationListByOption() is not implemented');
  }

  /// 获取会话列表，通过会话id
  /// conversationId – 会话id
  Future<NIMResult<NIMConversation>> getConversation(
      String conversationId) async {
    throw UnimplementedError('getConversation() is not implemented');
  }

  /// 获取会话列表，通过会话id
  /// conversationIds – 会话id列表
  Future<NIMResult<List<NIMConversation>>> getConversationListByIds(
      List<String> conversationIds) async {
    throw UnimplementedError('getConversationListByIds() is not implemented');
  }

  /// 创建会话
  /// conversationId – 会话id
  Future<NIMResult<NIMConversation>> createConversation(
      String conversationId) async {
    throw UnimplementedError('createConversation() is not implemented');
  }

  /// 删除会话
  /// conversationId – 会话id
  /// clearMessage – 是否清除消息
  Future<NIMResult<void>> deleteConversation(
      String conversationId, bool clearMessage) async {
    throw UnimplementedError('deleteConversation() is not implemented');
  }

  /// 删除会话
  /// conversationId – 会话id
  /// clearMessage – 是否清除消息
  Future<NIMResult<List<NIMConversationOperationResult>>>
      deleteConversationListByIds(
          List<String> conversationIds, bool clearMessage) async {
    throw UnimplementedError(
        'deleteConversationListByIds() is not implemented');
  }

  /// 置顶会话
  /// conversationId – 会话id
  /// stickTop – 是否置顶
  Future<NIMResult<void>> stickTopConversation(
      String conversationId, bool stickTop) async {
    throw UnimplementedError('stickTopConversation() is not implemented');
  }

  /// 更新会话
  /// conversationId – 会话id
  /// updateInfo – 更新信息
  Future<NIMResult<void>> updateConversation(
      String conversationId, NIMConversationUpdate updateInfo) async {
    throw UnimplementedError('updateConversation() is not implemented');
  }

  /// 更新会话本地扩展字段
  /// conversationId – 会话id
  /// localExtension – 本地扩展字段更新信息
  Future<NIMResult<void>> updateConversationLocalExtension(
      String conversationId, String localExtension) async {
    throw UnimplementedError(
        'updateConversationLocalExtension() is not implemented');
  }

  /// 获取会话总未读数
  Future<NIMResult<int>> getTotalUnreadCount() async {
    throw UnimplementedError('getTotalUnreadCount() is not implemented');
  }

  /// 根据会话id获取会话未读数
  /// conversationIds – 会话id列表
  Future<NIMResult<int>> getUnreadCountByIds(
      List<String> conversationIds) async {
    throw UnimplementedError('getUnreadCountByIds() is not implemented');
  }

  /// 根据过滤条件获取相应的未读数
  /// filter – 查询选项
  Future<NIMResult<int>> getUnreadCountByFilter(
      NIMConversationFilter filter) async {
    throw UnimplementedError('getUnreadCountByFilter() is not implemented');
  }

  /// 清空会话未读数
  Future<NIMResult<void>> clearTotalUnreadCount() async {
    throw UnimplementedError('clearTotalUnreadCount() is not implemented');
  }

  /// 根据会话id清空会话未读数
  /// conversationIds – 会话id列表
  Future<NIMResult<List<NIMConversationOperationResult>>> clearUnreadCountByIds(
      List<String> conversationIds) async {
    throw UnimplementedError('clearUnreadCountByIds() is not implemented');
  }

  /// 根据会话id清空会话未读数
  /// groupId – 会话分组Id
  // Future<NIMResult<void>> clearUnreadCountByGroupId(String groupId) async {
  //   throw UnimplementedError('clearUnreadCountByGroupId() is not implemented');
  // }

  /// 根据会话类型清空相应会话的未读数
  /// groupId – 会话分组Id
  Future<NIMResult<void>> clearUnreadCountByTypes(
      List<NIMConversationType> conversationTypes) async {
    throw UnimplementedError('clearUnreadCountByTypes() is not implemented');
  }

  /// 订阅指定过滤条件的会话未读数
  /// filter – 过滤条件
  Future<NIMResult<NIMError>> subscribeUnreadCountByFilter(
      NIMConversationFilter filter) async {
    throw UnimplementedError(
        'subscribeUnreadCountByFilter() is not implemented');
  }

  /// 取消订阅指定过滤条件的会话未读数
  /// filter – 过滤条件
  Future<NIMResult<NIMError>> unsubscribeUnreadCountByFilter(
      NIMConversationFilter filter) async {
    throw UnimplementedError(
        'unsubscribeUnreadCountByFilter() is not implemented');
  }

  /// 获取会话已读时间戳 当前只支持P2P，高级群， 超大群
  /// conversationId – 会话id
  Future<NIMResult<int>> getConversationReadTime(String conversationId) async {
    throw UnimplementedError('getConversationReadTime() is not implemented');
  }

  /// 更新会话已读时间戳
  /// conversationId – 会话id
  Future<NIMResult<int>> markConversationRead(String conversationId) async {
    throw UnimplementedError('markConversationRead() is not implemented');
  }
}
