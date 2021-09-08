// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/src/method_channel/method_channel_message_service.dart';
import 'package:nim_core_platform_interface/src/platform_interface/message/message.dart';
import 'package:nim_core_platform_interface/src/platform_interface/message/message_keyword_search_config.dart';
import 'package:nim_core_platform_interface/src/platform_interface/message/message_search_option.dart';
import 'package:nim_core_platform_interface/src/platform_interface/message/query_direction_enum.dart';
import 'package:nim_core_platform_interface/src/platform_interface/message/thread_talk_history.dart';
import 'package:nim_core_platform_interface/src/platform_interface/nim_base.dart';
import 'package:nim_core_platform_interface/src/platform_interface/service.dart';
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
  final StreamController<NIMTeamMessageReceipt> onTeamMessageReceipt =
      StreamController<NIMTeamMessageReceipt>.broadcast();

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
  final StreamController<NIMSession> onSessionDelete =
      StreamController<NIMSession>.broadcast();

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
    throw UnimplementedError('sendMessage() is not implemented');
  }

  Future<NIMResult<NIMMessage>> createMessage(
      {required NIMMessage message}) async {
    throw UnimplementedError('createMessage() is not implemented');
  }

  Future<NIMResult<String>> voiceToText(
      {required NIMMessage message, String? scene}) async {
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
      String account, NIMSessionType sessionType) async {
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

  /// 设置当前会话
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
}
