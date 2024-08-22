// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// 会话服务

part of nim_core_v2;

@HawkEntryPoint()
class ConversationService {
// 消息服务
  factory ConversationService() {
    if (_singleton == null) {
      _singleton = ConversationService._();
    }
    return _singleton!;
  }

  ConversationService._();

  static ConversationService? _singleton;

  ConversationServicePlatform get _platform =>
      ConversationServicePlatform.instance;

  /// 会话同步开始
  @HawkApi(ignore: true)
  Stream<void> get onSyncStarted => _platform.onSyncStarted;

  /// 会话同步完成
  @HawkApi(ignore: true)
  Stream<void> get onSyncFinished => _platform.onSyncFinished;

  /// 会话同步失败
  @HawkApi(ignore: true)
  Stream<void> get onSyncFailed => _platform.onSyncFailed;

  /// 会话创建
  @HawkApi(ignore: true)
  Stream<NIMConversation> get onConversationCreated =>
      _platform.onConversationCreated;

  /// 会话删除
  @HawkApi(ignore: true)
  Stream<List<String>> get onConversationDeleted =>
      _platform.onConversationDeleted;

  /// 会话更新
  @HawkApi(ignore: true)
  Stream<List<NIMConversation>> get onConversationChanged =>
      _platform.onConversationChanged;

  /// 会话未读消息计数更新
  @HawkApi(ignore: true)
  Stream<int> get onTotalUnreadCountChanged =>
      _platform.onTotalUnreadCountChanged;

  /// 未读数改变回调
  @HawkApi(ignore: true)
  Stream<UnreadChangeFilterResult> get onUnreadCountChangedByFilter =>
      _platform.onUnreadCountChangedByFilter;

  /// 账号多端登录会话已读时间戳标记通知 账号A登录设备D1, D2, D1会话已读时间戳标记，同步到D2成
  @HawkApi(ignore: true)
  Stream<ReadTimeUpdateResult> get onConversationReadTimeUpdated =>
      _platform.onConversationReadTimeUpdated;

  /// 获取会话列表
  /// offset – 分页偏移，首次传0，后续拉取采用上一次返回的offset limit – 分页拉取数量，不建议超过100;
  Future<NIMResult<NIMConversationResult>> getConversationList(
      int offset, int limit) async {
    return _platform.getConversationList(offset, limit);
  }

  /// 根据查询参数获取会话列表
  /// offset – 分页偏移，首次传0，后续拉取采用上一次返回的offset
  /// limit – 分页拉取数量，不建议超过100;
  /// option – 查询选项
  Future<NIMResult<NIMConversationResult>> getConversationListByOption(
      int offset, int limit, NIMConversationOption option) async {
    return _platform.getConversationListByOption(offset, limit, option);
  }

  /// 获取会话列表，通过会话id
  /// conversationId – 会话id
  Future<NIMResult<NIMConversation>> getConversation(
      String conversationId) async {
    return _platform.getConversation(conversationId);
  }

  /// 获取会话列表，通过会话id
  /// conversationIds – 会话id列表
  Future<NIMResult<List<NIMConversation>>> getConversationListByIds(
      List<String> conversationIds) async {
    return _platform.getConversationListByIds(conversationIds);
  }

  /// 创建会话
  /// conversationId – 会话id
  Future<NIMResult<NIMConversation>> createConversation(
      String conversationId) async {
    return _platform.createConversation(conversationId);
  }

  /// 删除会话
  /// conversationId – 会话id
  /// clearMessage – 是否清除消息
  Future<NIMResult<void>> deleteConversation(
      String conversationId, bool clearMessage) async {
    return _platform.deleteConversation(conversationId, clearMessage);
  }

  /// 删除会话
  /// conversationId – 会话id
  /// clearMessage – 是否清除消息
  Future<NIMResult<List<NIMConversationOperationResult>>>
      deleteConversationListByIds(
          List<String> conversationIds, bool clearMessage) async {
    return _platform.deleteConversationListByIds(conversationIds, clearMessage);
  }

  /// 置顶会话
  /// conversationId – 会话id
  /// stickTop – 是否置顶
  Future<NIMResult<void>> stickTopConversation(
      String conversationId, bool stickTop) async {
    return _platform.stickTopConversation(conversationId, stickTop);
  }

  /// 更新会话
  /// conversationId – 会话id
  /// updateInfo – 更新信息
  Future<NIMResult<void>> updateConversation(
      String conversationId, NIMConversationUpdate updateInfo) async {
    return _platform.updateConversation(conversationId, updateInfo);
  }

  /// 更新会话本地扩展字段
  /// conversationId – 会话id
  /// localExtension – 本地扩展字段更新信息
  Future<NIMResult<void>> updateConversationLocalExtension(
      String conversationId, String localExtension) async {
    return _platform.updateConversationLocalExtension(
        conversationId, localExtension);
  }

  /// 获取会话总未读数
  Future<NIMResult<int>> getTotalUnreadCount() async {
    return _platform.getTotalUnreadCount();
  }

  /// 根据会话id获取会话未读数
  /// conversationIds – 会话id列表
  Future<NIMResult<int>> getUnreadCountByIds(
      List<String> conversationIds) async {
    return _platform.getUnreadCountByIds(conversationIds);
  }

  /// 根据过滤条件获取相应的未读数
  /// filter – 查询选项
  Future<NIMResult<int>> getUnreadCountByFilter(
      NIMConversationFilter filter) async {
    return _platform.getUnreadCountByFilter(filter);
  }

  /// 清空会话未读数
  Future<NIMResult<void>> clearTotalUnreadCount() async {
    return _platform.clearTotalUnreadCount();
  }

  /// 根据会话id清空会话未读数
  /// conversationIds – 会话id列表
  Future<NIMResult<List<NIMConversationOperationResult>>> clearUnreadCountByIds(
      List<String> conversationIds) async {
    return _platform.clearUnreadCountByIds(conversationIds);
  }

  /// 根据会话id清空会话未读数
  /// groupId – 会话分组Id
  // Future<NIMResult<void>> clearUnreadCountByGroupId(String groupId) async {
  //   return _platform.clearUnreadCountByGroupId(groupId);
  // }

  /// 根据会话类型清空相应会话的未读数
  /// groupId – 会话分组Id
  Future<NIMResult<void>> clearUnreadCountByTypes(
      List<NIMConversationType> conversationTypes) async {
    return _platform.clearUnreadCountByTypes(conversationTypes);
  }

  /// 订阅指定过滤条件的会话未读数
  /// filter – 过滤条件
  Future<NIMResult<NIMError>> subscribeUnreadCountByFilter(
      NIMConversationFilter filter) async {
    return _platform.subscribeUnreadCountByFilter(filter);
  }

  /// 取消订阅指定过滤条件的会话未读数
  /// filter – 过滤条件
  Future<NIMResult<NIMError>> unsubscribeUnreadCountByFilter(
      NIMConversationFilter filter) async {
    return _platform.unsubscribeUnreadCountByFilter(filter);
  }

  /// 获取会话已读时间戳 当前只支持P2P，高级群， 超大群
  /// conversationId – 会话id
  Future<NIMResult<int>> getConversationReadTime(String conversationId) async {
    return _platform.getConversationReadTime(conversationId);
  }

  /// 更新会话已读时间戳
  /// conversationId – 会话id
  Future<NIMResult<int>> markConversationRead(String conversationId) async {
    return _platform.markConversationRead(conversationId);
  }
}
