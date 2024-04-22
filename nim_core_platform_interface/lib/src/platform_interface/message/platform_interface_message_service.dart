// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/method_channel/method_channel_message_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class MessageServicePlatform extends Service {
  MessageServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static MessageServicePlatform _instance = MethodChannelMessageService();

  static MessageServicePlatform get instance => _instance;

  static set instance(MessageServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // ignore: close_sinks, never closed
  final StreamController<List<NIMMessage>> onMessage =
      StreamController<List<NIMMessage>>.broadcast();

// ignore: close_sinks, never closed
  final StreamController<NIMMessage> onMessageStatus =
      StreamController<NIMMessage>.broadcast();

  // ignore: close_sinks, never closed
  final StreamController<List<NIMMessageReceipt>> onMessageReceipt =
      StreamController<List<NIMMessageReceipt>>.broadcast();

  // ignore: close_sinks, never closed
  final StreamController<List<NIMTeamMessageReceipt>> onTeamMessageReceipt =
      StreamController<List<NIMTeamMessageReceipt>>.broadcast();

  // ignore: close_sinks, never closed
  final StreamController<NIMAttachmentProgress> onAttachmentProgress =
      StreamController<NIMAttachmentProgress>.broadcast();

  // ignore: close_sinks, never closed
  final StreamController<NIMRevokeMessage> onMessageRevoked =
      StreamController<NIMRevokeMessage>.broadcast();

  // ignore: close_sinks, never closed
  final StreamController<NIMBroadcastMessage> onBroadcastMessage =
      StreamController<NIMBroadcastMessage>.broadcast();

  // ignore: close_sinks, never closed
  final StreamController<List<NIMSession>> onSessionUpdate =
      StreamController<List<NIMSession>>.broadcast();

  // ignore: close_sinks, never closed
  final StreamController<NIMSession?> onSessionDelete =
      StreamController<NIMSession?>.broadcast();

  // ignore: close_sinks, never closed
  final StreamController<NIMMessagePinEvent> onMessagePinNotify =
      StreamController<NIMMessagePinEvent>.broadcast();

  // ignore: close_sinks, never closed
  final StreamController<RecentSession> onMySessionUpdate =
      StreamController<RecentSession>.broadcast();

  // ignore: close_sinks, never closed
  final StreamController<NIMHandleQuickCommentOption> onQuickCommentAdd =
      StreamController<NIMHandleQuickCommentOption>.broadcast();

  // ignore: close_sinks, never closed
  final StreamController<NIMHandleQuickCommentOption> onQuickCommentRemove =
      StreamController<NIMHandleQuickCommentOption>.broadcast();

  // ignore: close_sinks, never closed
  final StreamController<List<NIMStickTopSessionInfo>> onSyncStickTopSession =
      StreamController<List<NIMStickTopSessionInfo>>.broadcast();

  // ignore: close_sinks, never closed
  final StreamController<NIMStickTopSessionInfo> onStickTopSessionAdd =
      StreamController<NIMStickTopSessionInfo>.broadcast();

  // ignore: close_sinks, never closed
  final StreamController<NIMStickTopSessionInfo> onStickTopSessionRemove =
      StreamController<NIMStickTopSessionInfo>.broadcast();

  // ignore: close_sinks, never closed
  final StreamController<NIMStickTopSessionInfo> onStickTopSessionUpdate =
      StreamController<NIMStickTopSessionInfo>.broadcast();

  // ignore: close_sinks, never closed
  final StreamController<List<NIMMessage>> onMessagesDelete =
      StreamController<List<NIMMessage>>.broadcast();

  final StreamController<void> allMessagesRead =
      StreamController<void>.broadcast();

  Future<NIMResult<NIMMessage>> sendMessage(
      {required NIMMessage message, bool resend = false}) async {
    throw UnimplementedError('sendMessage() is not implemented');
  }

  /// 发送单聊已读回执
  Future<NIMResult<void>> sendMessageReceipt(
      {required String sessionId, required NIMMessage message}) async {
    throw UnimplementedError('sendMessageReceipt() is not implemented');
  }

  /// 发送群消息已读回执
  Future<NIMResult<void>> sendTeamMessageReceipt(NIMMessage message) async {
    throw UnimplementedError('sendTeamMessageReceipt() is not implemented');
  }

  Future<NIMResult<NIMMessage>> saveMessage(
      {required NIMMessage message, required String fromAccount}) async {
    throw UnimplementedError('saveMessage() is not implemented');
  }

  Future<NIMResult<NIMMessage>> saveMessageToLocalEx(
      {required NIMMessage message, required int time}) async {
    throw UnimplementedError('saveMessageToLocalEx() is not implemented');
  }

  Future<NIMResult<NIMMessage>> createMessage(
      {required NIMMessage message}) async {
    throw UnimplementedError('createMessage() is not implemented');
  }

  Future<NIMResult<String>> voiceToText(
      {required NIMMessage message,
      String? scene,
      String? mimeType,
      String? sampleRate}) async {
    throw UnimplementedError('voiceToText() is not implemented');
  }

  Future<NIMResult<List<NIMMessage>>> queryMessageList(
      String account, NIMSessionType sessionType, int limit) async {
    throw UnimplementedError('queryMessageList() is not implemented');
  }

  Future<NIMResult<List<NIMMessage>>> queryMessageListEx(
      NIMMessage anchor, QueryDirection direction, int limit) async {
    throw UnimplementedError('queryMessageListEx() is not implemented');
  }

  Future<NIMResult<NIMMessage>> queryLastMessage(
      String account, NIMSessionType sessionType) async {
    throw UnimplementedError('queryLastMessage() is not implemented');
  }

  Future<NIMResult<List<NIMMessage>>> queryMessageListByUuid(
      List<String> uuids, String sessionId, NIMSessionType sessionType) async {
    throw UnimplementedError('queryMessageListByUuid() is not implemented');
  }

  Future<void> deleteChattingHistory(NIMMessage anchor, bool ignore) async {
    throw UnimplementedError('deleteChattingHistory() is not implemented');
  }

  Future<void> deleteChattingHistoryList(
      List<NIMMessage> msgList, bool ignore) async {
    throw UnimplementedError('deleteChattingHistoryList() is not implemented');
  }

  Future<void> clearChattingHistory(
      String account, NIMSessionType sessionType, bool? ignore) async {
    throw UnimplementedError('clearChattingHistory() is not implemented');
  }

  Future<void> clearMsgDatabase(bool clearRecent) async {
    throw UnimplementedError('clearMsgDatabase() is not implemented');
  }

  Future<NIMResult<List<NIMMessage>>> pullMessageHistory(
      NIMMessage anchor, int limit, bool persist) async {
    throw UnimplementedError('pullMessageHistory() is not implemented');
  }

  Future<NIMResult<List<NIMMessage>>> pullMessageHistoryExType(
      NIMMessage anchor,
      int toTime,
      int limit,
      QueryDirection direction,
      List<NIMMessageType> messageTypeList,
      bool persist) async {
    throw UnimplementedError('pullMessageHistoryExType() is not implemented');
  }

  Future<void> clearServerHistory(
      String sessionId, NIMSessionType sessionType, bool sync) async {
    throw UnimplementedError('clearServerHistory() is not implemented');
  }

  Future<NIMResult<int>> deleteMsgSelf(NIMMessage msg, String ext) async {
    throw UnimplementedError('deleteMsgSelf() is not implemented');
  }

  Future<NIMResult<int>> deleteMsgListSelf(
      List<NIMMessage> msgList, String ext) async {
    throw UnimplementedError('deleteMsgListSelf() is not implemented');
  }

  Future<NIMResult<List<NIMMessage>>> searchMessage(NIMSessionType sessionType,
      String sessionId, MessageSearchOption searchOption) async {
    throw UnimplementedError('searchMessage() is not implemented');
  }

  Future<NIMResult<List<NIMMessage>>> searchAllMessage(
      MessageSearchOption searchOption) async {
    throw UnimplementedError('searchAllMessage() is not implemented');
  }

  Future<NIMResult<List<NIMMessage>>> searchRoamingMsg(
      String otherAccid,
      int fromTime,
      int endTime,
      String keyword,
      int limit,
      bool reverse) async {
    throw UnimplementedError('searchRoamingMsg() is not implemented');
  }

  Future<NIMResult<List<NIMMessage>>> searchCloudMessageHistory(
      MessageKeywordSearchConfig config) async {
    throw UnimplementedError('searchCloudMessageHistory() is not implemented');
  }

  Future<NIMResult<void>> downloadAttachment(
      {required NIMMessage message, required bool thumb}) async {
    throw UnimplementedError('downloadAttachment() is not implemented');
  }

  Future<NIMResult<void>> cancelUploadAttachment(NIMMessage message) async {
    throw UnimplementedError('cancelUploadAttachment() is not implemented');
  }

  Future<NIMResult<void>> revokeMessage(
      {required NIMMessage message,
      String? customApnsText,
      Map<String, Object>? pushPayload,
      bool? shouldNotifyBeCount,
      String? postscript,
      String? attach}) async {
    throw UnimplementedError('revokeMessage() is not implemented');
  }

  Future<NIMResult<void>> updateMessage(NIMMessage message) async {
    throw UnimplementedError('updateMessage() is not implemented');
  }

  Future<NIMResult<void>> refreshTeamMessageReceipt(
      List<NIMMessage> messageList) async {
    throw UnimplementedError('refreshTeamMessageReceipt() is not implemented');
  }

  Future<NIMResult<NIMTeamMessageAckInfo>> fetchTeamMessageReceiptDetail(
      {required NIMMessage message, List<String>? accountList}) async {
    throw UnimplementedError(
        'fetchTeamMessageReceiptDetail() is not implemented');
  }

  Future<NIMResult<NIMTeamMessageAckInfo>> queryTeamMessageReceiptDetail(
      {required NIMMessage message, List<String>? accountList}) async {
    throw UnimplementedError(
        'queryTeamMessageReceiptDetail() is not implemented');
  }

  Future<NIMResult<void>> forwardMessage(
      NIMMessage message, String sessionId, NIMSessionType sessionType) async {
    throw UnimplementedError('forwardMessage() is not implemented');
  }

  /// 获取最近会话列表
  ///
  /// 最近会话列表，即最近联系人列表。当收到新联系人的消息时，SDK会自动生成这个消息对应的本地最近会话。
  /// 它记录了包括联系人帐号、联系人类型、最近一条消息的时间、消息状态、消息内容、未读条数等信息。
  ///
  /// [limit] 获取本地会话的数量，最大为100；如果不设置该值，会返回全量会话列表
  Future<NIMResult<List<NIMSession>>> querySessionList([int? limit]) async {
    throw UnimplementedError('querySessionList() is not implemented');
  }

  /// 当希望返回的会话的最近一条消息不是某一类消息时，可以使用以下过滤接口。
  ///
  /// 如希望最近一条消息为非文本消息时，使用该接口的返回的会话，将取最近的一条非文本的消息作为最近一条消息。
  ///
  /// [filterMessageType] 过滤消息类型
  Future<NIMResult<List<NIMSession>>> querySessionListFiltered(
      List<NIMMessageType> filterMessageTypeList) async {
    throw UnimplementedError('querySessionListFiltered() is not implemented');
  }

  // /// 查询最近联系人会话列表数据，可按时间逆序或者正序查询指定数量的最新会话列表数据
  // /// <br>[anchor]: 查询最近联系人会话列表的锚点
  // ///  如果首次查询传null即可;
  // ///  如果首次查询，当查询方向direction为QUERY_NEW时，则时间按0开始查询；
  // ///  如果首次查询，当查询方向direction为QUERY_OLD时，则时间按当前系统时间开始查询；
  // ///  如果想查询下一页数据，传入上一页数据的最后一个NIMSession即可
  // /// <br>[direction]: 查询方向
  // ///    QUERY_OLD查询在时间在anchor之前的数据，逆序排列；
  // ///    QUERY_NEW查询时间在anchor之后的数据，正序排列
  // /// <br>[limit]: 获取本地会话的数量, 最大100
  //  Future<NIMResult<List<NIMSession>>> queryLatestSessionListByPage({
  //    NIMSession? anchor,
  //    QueryDirection direction = QueryDirection.QUERY_NEW,
  //    int limit = 100,
  //  }) async {
  //    throw UnimplementedError(
  //        'queryLatestSessionListByPage() is not implemented');
  //  }

  ///
  /// 查询最近联系人会话列表数据(同步接口)，可以设置limit， 防止本地会话过多时，导致第一次加载慢
  /// [sessionInfo] - 会话信息
  ///
  Future<NIMResult<NIMSession>> querySession(NIMSessionInfo sessionInfo) {
    throw UnimplementedError('querySessionById() is not implemented');
  }

  /// 创建一条空的联系人会话，并保存到数据库中

  /// <br> [sessionId] - 会话id ，对方帐号或群组id。
  /// <br> [sessionType] - 会话类型
  /// <br> [tag] - 会话tag ， eg:置顶标签（UIKit中的实现： RECENT_TAG_STICKY） ，用户参照自己的tag 实现即可， 如不需要，传 0 即可
  /// <br> [time] - 会话时间 ，单位为ms。
  /// <br> [linkToLastMessage] - 是否放入最后一条消息的相关信息
  Future<NIMResult<NIMSession>> createSession({
    required String sessionId,
    required NIMSessionType sessionType,
    int tag = 0,
    required int time,
    bool linkToLastMessage = false,
  }) {
    throw UnimplementedError('createSession() is not implemented');
  }

  // /// 通过消息对象创建会话对象
  // Future<NIMResult<NIMSession>> createSessionByMessage({
  //   required NIMMessage message,
  //   bool needNotify = true,
  // }) {
  //   throw UnimplementedError('createSessionByMessage() is not implemented');
  // }

  /// 更新会话对象
  ///
  /// [needNotify] 是否需要发送通知
  /// 仅支持修改 tag 以及 extension
  Future<NIMResult<void>> updateSession({
    required NIMSession session,
    bool needNotify = false,
  }) {
    throw UnimplementedError('updateSession() is not implemented');
  }

  /// 使用消息更新会话对象
  ///
  /// <br>[message] 消息对象
  /// <br>[needNotify] 是否需要发送通知
  Future<NIMResult<void>> updateSessionWithMessage({
    required NIMMessage message,
    bool needNotify = false,
  }) {
    throw UnimplementedError('updateSession() is not implemented');
  }

  /// 获取未读数总数
  ///
  /// [queryType] 查询类型
  Future<NIMResult<int>> queryTotalUnreadCount({
    NIMUnreadCountQueryType queryType = NIMUnreadCountQueryType.all,
  }) {
    throw UnimplementedError('queryTotalUnreadCount() is not implemented');
  }

  /// 设置当前会话，Android平台可用
  /// 调用以下接口重置当前会话，SDK会自动管理消息的未读数。
  /// 该接口会自动调用clearUnreadCount(String, SessionTypeEnum)将正在聊天对象的未读数清零。
  /// 如果有新消息到达，且消息来源是正在聊天的对象，其未读数也不会递增。
  ///
  /// <br>[account] - 聊天对象帐号，或者以下两个值：'all' 与 'none'。
  /// <br>[sessionType] - 会话类型。如果account不是具体的对象，该参数将被忽略
  Future<NIMResult<void>> setChattingAccount({
    required String sessionId,
    required NIMSessionType sessionType,
  }) {
    throw UnimplementedError('setChattingAccount() is not implemented');
  }

  /// 清除未读数
  ///
  /// [sessionInfoList] 请求列表
  ///
  /// 返回不能成功处理的请求列表
  Future<NIMResult<List<NIMSessionInfo>>> clearSessionUnreadCount(
    List<NIMSessionInfo> sessionInfoList,
  ) {
    throw UnimplementedError('clearSessionUnreadCount() is not implemented');
  }

  /// 清空所有会话的未读计数
  ///
  Future<NIMResult<void>> clearAllSessionUnreadCount() {
    throw UnimplementedError('clearAllSessionUnreadCount() is not implemented');
  }

  // /// 删除指定最近联系人的漫游消息。
  // /// 不删除本地消息，但如果在其他端登录，当前时间点该会话已经产生的消息不漫游。
  // ///
  // /// [sessionInfo] 会话信息
  // Future<NIMResult<void>> deleteRoamingSession(NIMSessionInfo sessionInfo) {
  //   throw UnimplementedError('setChattingAccount() is not implemented');
  // }

  /// 删除最近联系人记录。<br>
  /// 调用该接口后，会触发{@link MsgServiceObserve#observeRecentContactDeleted(Observer, boolean)}通知
  /// 会话ID
  /// 会话类型，只能选{@link SessionTypeEnum#P2P}和{@link SessionTypeEnum#Team}会删漫游消息
  /// 删除类型，决定是否删除本地记录和漫游记录，
  /// 如果为null，视为{@link DeleteTypeEnum#REMAIN}
  /// 如果参数合法，是否向其他端标记此会话为已读
  ///
  Future<NIMResult<void>> deleteSession({
    required NIMSessionInfo sessionInfo,
    required NIMSessionDeleteType deleteType,
    required bool sendAck,
  }) {
    throw UnimplementedError('deleteSession() is not implemented');
  }

  Future<NIMResult<void>> replyMessage(
      {required NIMMessage msg,
      required NIMMessage replyMsg,
      required bool resend}) {
    throw UnimplementedError('replyMessage() is not implemented');
  }

  /// 添加一条收藏
  ///
  /// [type] 收藏类型
  /// [date] 收藏内容，最大20k
  /// [ext] 扩展字段，最大1k
  /// [uniqueId] 去重唯一ID
  Future<NIMResult<NIMCollectInfo>> addCollect({
    required int type,
    required String data,
    String? ext,
    String? uniqueId,
  }) {
    throw UnimplementedError('addCollect() is not implemented');
  }

  /// 批量移除收藏
  ///
  /// [collects] 要移除的收藏的请求
  ///
  /// [NIMCollectInfo] 中 [id] 和 [createTime] 为必填字段
  Future<NIMResult<int>> removeCollect(List<NIMCollectInfo> collects) {
    throw UnimplementedError('removeCollect() is not implemented');
  }

  ///
  /// 更新一个收藏的扩展字段
  ///
  /// 如果 [info.ext] 为空，表示删除ext字段
  ///
  Future<NIMResult<NIMCollectInfo>> updateCollect(NIMCollectInfo info) {
    throw UnimplementedError('updateCollect() is not implemented');
  }

  ///
  /// 从服务端分页查询收藏列表
  ///
  /// [anchor] 结束查询的最后一条收藏(不包含在查询结果中)
  /// [type] 查询类型，如果为空则返回所有类型
  /// [toTime] 结束时间点单位毫秒
  /// [limit] 本次查询的消息条数上限(最多100条)
  /// [direction] 查询方向
  ///
  Future<NIMResult<NIMCollectInfoQueryResult>> queryCollect({
    NIMCollectInfo? anchor,
    int toTime = 0,
    int? type,
    int limit = 100,
    QueryDirection direction = QueryDirection.QUERY_OLD,
  }) {
    throw UnimplementedError('queryCollect() is not implemented');
  }

  ///
  /// PIN一条消息
  ///
  /// [message] 被PIN的消息
  /// [ext] 扩展字段
  ///
  Future<NIMResult<void>> addMessagePin(NIMMessage message, String? ext) {
    throw UnimplementedError('addMessagePin() is not implemented');
  }

  ///
  /// 更新一条消息的PIN
  ///
  /// [message] 被PIN的消息
  /// [ext] 扩展字段
  ///
  Future<NIMResult<void>> updateMessagePin(NIMMessage message, String? ext) {
    throw UnimplementedError('updateMessagePin() is not implemented');
  }

  ///
  /// 删除一条消息的PIN
  ///
  /// [message] 被PIN的消息
  /// [ext] 扩展字段
  ///
  Future<NIMResult<void>> removeMessagePin(NIMMessage message, String? ext) {
    throw UnimplementedError('removeMessagePin() is not implemented');
  }

  /// 查询会话所有的 PIN
  ///
  /// [sessionId] 会话ID
  ///
  /// [sessionType] 会话类型
  Future<NIMResult<List<NIMMessagePin>>> queryMessagePinForSession(
    String sessionId,
    NIMSessionType sessionType,
  ) {
    throw UnimplementedError('queryMessagePinForSession() is not implemented');
  }

  Future<NIMResult<NIMThreadTalkHistory>> queryThreadTalkHistory(
      {required NIMMessage anchor,
      required int fromTime,
      required int toTime,
      required int limit,
      required QueryDirection direction,
      required bool persist}) {
    throw UnimplementedError('queryThreadTalkHistory() is not implemented');
  }

  /// 检验本地反垃圾词库，支持单聊、群聊和聊天室的文本消息反垃圾
  /// <p>[content] 需要检查的文本
  /// <p>[replacement] 指定 content 中被反垃圾词库命中后的替换文本
  /// <p>[LocalAntiSpamResult] 检验结果
  ///
  Future<NIMResult<NIMLocalAntiSpamResult>> checkLocalAntiSpam(
      String content, String replacement);

  Future<NIMResult<int>> queryReplyCountInThreadTalkBlock(NIMMessage msg) {
    throw UnimplementedError(
        'queryReplyCountInThreadTalkBlock() is not implemented');
  }

  ///【会话服务】增量获取会话列表，增量+翻页
  /// <p>[minTimestamp] 最小时间戳，作为请求参数时表示增量获取Session列表，传0表示全量获取
  /// <p>[maxTimestamp] 最大时间戳，翻页时使用
  /// <p>[needLastMsg]  是否需要lastMsg，0或者1，默认1
  /// <p>[limit] 结果集limit，最大100，默认100
  /// <p>[hasMore] 结果集是否完整，0或者1
  Future<NIMResult<RecentSessionList>> queryMySessionList(int minTimestamp,
      int maxTimestamp, int needLastMsg, int limit, int hasMore) {
    throw UnimplementedError('queryMySessionList() is not implemented');
  }

  ///【会话服务】获取某一个会话
  /// <p>[sessionId] 分为p2p/team/superTeam，格式分别是：p2p|accid、team|tid、super_team|tid
  /// <p>[sessionType] 会话类型
  Future<NIMResult<RecentSession>> queryMySession(
      String sessionId, NIMSessionType sessionType) {
    throw UnimplementedError('queryMySession() is not implemented');
  }

  ///【会话服务】更新某一个会话，主要是设置会话的ext字段，如果会话不存在，则会创建出来，此时会话没有lastMsg
  ///  <p>[sessionId] 分为p2p/team/superTeam，格式分别是：p2p|accid、team|tid、super_team|tid
  ///  <p>[sessionType] 会话类型
  ///  <p>[ext] 会话的扩展字段，仅自己可见
  Future<NIMResult<void>> updateMySession(
      String sessionId, NIMSessionType sessionType, String ext) {
    throw UnimplementedError('updateMySession() is not implemented');
  }

  ///【会话服务】删除会话
  /// <p>[sessionList] NIMSession列表
  Future<NIMResult<void>> deleteMySession(List<NIMMySessionKey> sessionList) {
    throw UnimplementedError('deleteMySession() is not implemented');
  }

  ///增加一条快捷评论
  Future<NIMResult<int>> addQuickComment(
      NIMMessage msg,
      int replyType,
      String ext,
      bool needPush,
      bool needBadge,
      String pushTitle,
      String pushContent,
      Map<String, Object> pushPayload) {
    throw UnimplementedError('addQuickComment() is not implemented');
  }

  ///删除一条快捷评论
  Future<NIMResult<void>> removeQuickComment(
      NIMMessage msg,
      int replyType,
      String ext,
      bool needPush,
      bool needBadge,
      String pushTitle,
      String pushContent,
      Map<String, Object> pushPayload) {
    throw UnimplementedError('removeQuickComment() is not implemented');
  }

  ///获取快捷评论列表
  Future<NIMResult<List<NIMQuickCommentOptionWrapper>>> queryQuickComment(
      List<NIMMessage> msgList) {
    throw UnimplementedError('queryQuickComment() is not implemented');
  }

  ///添加一个置顶会话
  Future<NIMResult<NIMStickTopSessionInfo>> addStickTopSession(
      String sessionId, NIMSessionType sessionType, String ext) {
    throw UnimplementedError('addStickTopSession() is not implemented');
  }

  ///删除一个置顶会话
  Future<NIMResult<void>> removeStickTopSession(
      String sessionId, NIMSessionType sessionType, String ext) {
    throw UnimplementedError('removeStickTopSession() is not implemented');
  }

  ///更新一个会话在置顶上的扩展字段
  Future<NIMResult<void>> updateStickTopSession(
      String sessionId, NIMSessionType sessionType, String ext) {
    throw UnimplementedError('updateStickTopSession() is not implemented');
  }

  ///获取置顶会话信息的列表
  Future<NIMResult<List<NIMStickTopSessionInfo>>> queryStickTopSession() {
    throw UnimplementedError('queryStickTopSession() is not implemented');
  }

  ///获取是否有更多漫游消息标记的时间戳，如果没有，回调0
  Future<NIMResult<int>> queryRoamMsgHasMoreTime(
      String sessionId, NIMSessionType sessionType) {
    throw UnimplementedError('queryRoamMsgHasMoreTime() is not implemented');
  }

  ///更新是否有更多漫游消息的标记
  Future<NIMResult<void>> updateRoamMsgHasMoreTag(NIMMessage newTag) {
    throw UnimplementedError('updateRoamMsgHasMoreTag() is not implemented');
  }

  Future<NIMResult<GetMessagesDynamicallyResult>> getMessagesDynamically(
      GetMessagesDynamicallyParam param) {
    throw UnimplementedError('getMessagesDynamically() is not implemented');
  }

  Future<NIMResult<String>> convertMessageToJson(NIMMessage message) async {
    throw UnimplementedError('getMessagesDynamically() is not implemented');
  }

  Future<NIMResult<NIMMessage>> convertJsonToMessage(String json) async {
    throw UnimplementedError('getMessagesDynamically() is not implemented');
  }

  ///根据消息关键信息批量查询服务端历史消息。
  ///[msgKeyList] 消息关键信息列表
  ///[persist] 查询的漫游消息是否同步到本地数据库。
  Future<NIMResult<List<NIMMessage>>> pullHistoryById(
      List<NIMMessageKey> msgKeyList, bool persist) async {
    throw UnimplementedError('pullHistoryById() is not implemented');
  }
}
