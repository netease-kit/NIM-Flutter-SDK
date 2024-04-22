// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core;

class MessageService {
  factory MessageService() {
    if (_singleton == null) {
      _singleton = MessageService._();
    }
    return _singleton!;
  }

  MessageService._();

  static MessageService? _singleton;

  MessageServicePlatform get _platform => MessageServicePlatform.instance;

  /// 消息接收
  Stream<List<NIMMessage>> get onMessage =>
      MessageServicePlatform.instance.onMessage.stream;

  /// 消息状态变化
  Stream<NIMMessage> get onMessageStatus =>
      MessageServicePlatform.instance.onMessageStatus.stream;

  /// 消息已读回执
  Stream<List<NIMMessageReceipt>> get onMessageReceipt =>
      MessageServicePlatform.instance.onMessageReceipt.stream;

  /// 群消息已读回执
  Stream<List<NIMTeamMessageReceipt>> get onTeamMessageReceipt =>
      MessageServicePlatform.instance.onTeamMessageReceipt.stream;

  /// 消息附件上传进度
  Stream<NIMAttachmentProgress> get onAttachmentProgress =>
      MessageServicePlatform.instance.onAttachmentProgress.stream;

  /// 消息撤回内容
  Stream<NIMRevokeMessage> get onMessageRevoked =>
      MessageServicePlatform.instance.onMessageRevoked.stream;

  /// 广播消息接收
  Stream<NIMBroadcastMessage> get onBroadcastMessage =>
      MessageServicePlatform.instance.onBroadcastMessage.stream;

  /// 最近会话更新
  Stream<List<NIMSession>> get onSessionUpdate =>
      MessageServicePlatform.instance.onSessionUpdate.stream;

  /// 最近会话删除
  Stream<NIMSession?> get onSessionDelete =>
      MessageServicePlatform.instance.onSessionDelete.stream;

  /// 消息PIN事件通知
  Stream<NIMMessagePinEvent> get onMessagePinNotify =>
      MessageServicePlatform.instance.onMessagePinNotify.stream;

  /// 会话服务-更新会话
  Stream<RecentSession> get onMySessionUpdate =>
      MessageServicePlatform.instance.onMySessionUpdate.stream;

  /// 增加一条快捷评论的同步回包
  Stream<NIMHandleQuickCommentOption> get onQuickCommentAdd =>
      MessageServicePlatform.instance.onQuickCommentAdd.stream;

  /// 删除一条快捷评论的同步回包
  Stream<NIMHandleQuickCommentOption> get onQuickCommentRemove =>
      MessageServicePlatform.instance.onQuickCommentRemove.stream;

  /// 同步置顶会话的多端同步回包
  Stream<List<NIMStickTopSessionInfo>> get onSyncStickTopSession =>
      MessageServicePlatform.instance.onSyncStickTopSession.stream;

  /// 增加一条置顶会话的多端同步回包
  Stream<NIMStickTopSessionInfo> get onStickTopSessionAdd =>
      MessageServicePlatform.instance.onStickTopSessionAdd.stream;

  /// 移除一条置顶会话的多端同步回包
  Stream<NIMStickTopSessionInfo> get onStickTopSessionRemove =>
      MessageServicePlatform.instance.onStickTopSessionRemove.stream;

  /// 更新一条置顶会话的扩展字段的多端同步回包
  Stream<NIMStickTopSessionInfo> get onStickTopSessionUpdate =>
      MessageServicePlatform.instance.onStickTopSessionUpdate.stream;

  ///消息删除的同步接口回调
  Stream<List<NIMMessage>> get onMessagesDelete =>
      MessageServicePlatform.instance.onMessagesDelete.stream;

  ///所有消息都已读的回调，在调用[MessageService.clearAllSessionUnreadCount]后触发
  ///仅iOS端有效
  Stream<void> get allMessagesReadForIOS =>
      MessageServicePlatform.instance.allMessagesRead.stream;

  /// 创建消息
  Future<NIMResult<NIMMessage>> _createMessage(
      {required NIMMessage message}) async {
    return _platform.createMessage(message: message);
  }

  /// 创建并发送消息
  Future<NIMResult<NIMMessage>> _createMessageAndSend(
    NIMMessage message,
    MessageAction? action,
  ) {
    return _createMessage(message: message).then((messageResult) async {
      if (messageResult.isSuccess) {
        final message = messageResult.data as NIMMessage;
        await action?.call(message);
        return sendMessage(message: message, resend: false);
      } else {
        return messageResult;
      }
    });
  }

  Future<NIMResult<String>> _convertMessageToJson(NIMMessage message) async {
    return _platform.convertMessageToJson(message);
  }

  /// 消息转换
  Future<NIMResult<NIMMessage>> _convertJsonToMessage(String json) async {
    return _platform.convertJsonToMessage(json);
  }

  /// 发送消息
  /// 如果需要更新发送进度，请监听 [onMessageStatus]。
  /// 如果需要监听附件进度，请监听 [onAttachmentProgress]。
  /// 如果消息发送失败后需要重发，请使用[resend] 参数。
  Future<NIMResult<NIMMessage>> sendMessage(
      {required NIMMessage message, bool resend = false}) async {
    return _platform.sendMessage(message: message, resend: resend);
  }

  /// 发送文本消息
  Future<NIMResult<NIMMessage>> sendTextMessage({
    required String sessionId,
    required NIMSessionType sessionType,
    required String text,
    MessageAction? action,
  }) async {
    final message = NIMMessage.textEmptyMessage(
        sessionId: sessionId, sessionType: sessionType, text: text);
    return _createMessageAndSend(message, action);
  }

  /// 发送图片消息
  /// [base64] 字段为web端专用，web端[filePath] 可传空字符串
  Future<NIMResult<NIMMessage>> sendImageMessage({
    required String sessionId,
    required NIMSessionType sessionType,
    required String filePath,
    required int fileSize,
    String? displayName,
    String? base64,
    NIMNosScene nosScene = NIMNosScenes.defaultIm,
    MessageAction? action,
  }) async {
    final message = NIMMessage.imageEmptyMessage(
      sessionId: sessionId,
      sessionType: sessionType,
      filePath: filePath,
      fileSize: fileSize,
      base64: base64,
      displayName: displayName,
      nosScene: nosScene,
    );
    return _createMessageAndSend(message, action);
  }

  /// 发送音频消息
  /// [displayName] 字段无效，不建议使用
  /// [base64] 字段为web端专用，web端[filePath] 可传空字符串
  Future<NIMResult<NIMMessage>> sendAudioMessage({
    required String sessionId,
    required NIMSessionType sessionType,
    required String filePath,
    required int fileSize,
    required int duration,
    String? displayName,
    String? base64,
    NIMNosScene nosScene = NIMNosScenes.defaultIm,
    MessageAction? action,
  }) async {
    final message = NIMMessage.audioEmptyMessage(
        sessionId: sessionId,
        sessionType: sessionType,
        filePath: filePath,
        fileSize: fileSize,
        base64: base64,
        duration: duration,
        displayName: displayName,
        nosScene: nosScene);
    return _createMessageAndSend(message, action);
  }

  /// 发送地理位置消息
  Future<NIMResult<NIMMessage>> sendLocationMessage({
    required String sessionId,
    required NIMSessionType sessionType,
    required double latitude,
    required double longitude,
    required String address,
    MessageAction? action,
  }) async {
    var message = NIMMessage.locationEmptyMessage(
        sessionId: sessionId,
        sessionType: sessionType,
        latitude: latitude,
        longitude: longitude,
        address: address);
    return _createMessageAndSend(message, action);
  }

  /// 发送视频消息
  /// [base64] 字段为web端专用，web端[filePath] 可传空字符串
  Future<NIMResult<NIMMessage>> sendVideoMessage({
    required String sessionId,
    required NIMSessionType sessionType,
    required String filePath,
    int? fileSize,
    required int duration,
    required int width,
    required int height,
    required String displayName,
    String? base64,
    NIMNosScene nosScene = NIMNosScenes.defaultIm,
    MessageAction? action,
  }) async {
    var message = NIMMessage.videoEmptyMessage(
        sessionId: sessionId,
        sessionType: sessionType,
        filePath: filePath,
        fileSize: fileSize,
        duration: duration,
        base64: base64,
        width: width,
        height: height,
        displayName: displayName,
        nosScene: nosScene);
    return _createMessageAndSend(message, action);
  }

  /// 发送文件消息
  /// [base64] 字段为web端专用，web端[filePath] 可传空字符串
  Future<NIMResult<NIMMessage>> sendFileMessage({
    required String sessionId,
    required NIMSessionType sessionType,
    required String filePath,
    String? base64,
    int? fileSize,
    required String displayName,
    NIMNosScene nosScene = NIMNosScenes.defaultIm,
    MessageAction? action,
  }) async {
    var message = NIMMessage.fileEmptyMessage(
        sessionId: sessionId,
        sessionType: sessionType,
        filePath: filePath,
        base64: base64,
        fileSize: fileSize,
        displayName: displayName,
        nosScene: nosScene);
    return _createMessageAndSend(message, action);
  }

  /// 发送Tip消息
  /// [content] web端tip内容传这个字段
  Future<NIMResult<NIMMessage>> sendTipMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      MessageAction? action,
      String? content}) async {
    var message = NIMMessage.tipEmptyMessage(
        sessionId: sessionId, sessionType: sessionType);
    message.content = content;
    return _createMessageAndSend(message, action);
  }

  /// 发送自定义消息
  Future<NIMResult<NIMMessage>> sendCustomMessage({
    required String sessionId,
    required NIMSessionType sessionType,
    String? content,
    NIMMessageAttachment? attachment,
    NIMCustomMessageConfig? config,
    MessageAction? action,
  }) async {
    var message = NIMMessage.customEmptyMessage(
        sessionId: sessionId,
        sessionType: sessionType,
        content: content,
        attachment: attachment,
        config: config);
    return _createMessageAndSend(message, action);
  }

  /// 发送单聊已读回执
  /// 如果需要监听消息已读回执，请监听 [onMessageReceipt]。
  Future<NIMResult<void>> sendMessageReceipt(
      {required String sessionId, required NIMMessage message}) async {
    return _platform.sendMessageReceipt(sessionId: sessionId, message: message);
  }

  /// 发送群消息已读回执
  /// 如果需要监听群消息已读回执，请监听 [onTeamMessageReceipt]。
  Future<NIMResult<void>> sendTeamMessageReceipt(NIMMessage message) async {
    return _platform.sendTeamMessageReceipt(message);
  }

  /// 保存消息
  Future<NIMResult<NIMMessage>> saveMessage(
      {required NIMMessage message, required String fromAccount}) async {
    return _platform.saveMessage(message: message, fromAccount: fromAccount);
  }

  /// 保存消息到本地
  Future<NIMResult<NIMMessage>> saveMessageToLocalEx(
      {required NIMMessage message, required int time}) async {
    return _platform.saveMessageToLocalEx(message: message, time: time);
  }

  /// 语音转文字
  /// [mimeType] PC 端使用，指定语音类型 aac, wav, mp3, amr，默认 aac
  /// [sampleRate] PC 端使用，指定语音采样率 8000kHz, 16000kHz，默认 16000
  Future<NIMResult<String>> voiceToText(
      {required NIMMessage message,
      @Deprecated("useless") String? scene,
      String? mimeType = 'aac',
      String? sampleRate = '16000'}) async {
    return _platform.voiceToText(
        message: message,
        scene: scene,
        mimeType: mimeType,
        sampleRate: sampleRate);
  }

  /// 查询消息
  @Deprecated('queryMessageListEx')
  Future<NIMResult<List<NIMMessage>>> queryMessageList(
      String account, NIMSessionType sessionType, int limit) async {
    return _platform.queryMessageList(account, sessionType, limit);
  }

  /// 查询消息
  Future<NIMResult<List<NIMMessage>>> queryMessageListEx(
      NIMMessage anchor, QueryDirection direction, int limit) async {
    return _platform.queryMessageListEx(anchor, direction, limit);
  }

  ///查询最近一条消息
  Future<NIMResult<NIMMessage>> queryLastMessage(
      String account, NIMSessionType sessionType) async {
    return _platform.queryLastMessage(account, sessionType);
  }

  ///按消息uuid查询
  Future<NIMResult<List<NIMMessage>>> queryMessageListByUuid(
      List<String> uuids, String sessionId, NIMSessionType sessionType) async {
    return _platform.queryMessageListByUuid(uuids, sessionId, sessionType);
  }

  /// 删除一条消息记录
  Future<void> deleteChattingHistory(NIMMessage anchor, bool ignore) async {
    return _platform.deleteChattingHistory(anchor, ignore);
  }

  ///指定多条消息进行本地删除
  Future<void> deleteChattingHistoryList(
      List<NIMMessage> msgList, bool ignore) async {
    return _platform.deleteChattingHistoryList(msgList, ignore);
  }

  ///清除与指定用户的所有本地消息记录
  ///[account]用户账号
  ///[sessionType]会话类型
  ///[ignore] true: 本地不记录清除操作; false: 本地记录清除操作，默认false, web端无效
  ///如果为true则[pullMessageHistory]接口参数persist为true时会重新保存到数据库
  ///不推荐设置成true
  Future<void> clearChattingHistory(
      String account, NIMSessionType sessionType, bool? ignore) async {
    return _platform.clearChattingHistory(account, sessionType, ignore);
  }

  /// 清空消息数据库的所有消息记录。 可选择是否要同时清空最近联系人列表数据库。
  /// 若最近联系人列表也被清空，会触发[onSessionDelete]通知
  Future<void> clearMsgDatabase(bool clearRecent) async {
    return _platform.clearMsgDatabase(clearRecent);
  }

  ///从服务器拉取消息历史记录，结果不存本地消息数据库。
  Future<NIMResult<List<NIMMessage>>> pullMessageHistory(
      NIMMessage anchor, int limit, bool persist) async {
    return _platform.pullMessageHistory(anchor, limit, persist);
  }

  ///从服务器拉取消息历史记录，可以指定查询的消息类型，结果不存本地消息数据库。
  /// [anchor] 起始时间点的消息
  /// [toTime] – 结束时间点单位毫秒
  /// [limit] – 本次查询的消息条数上限(最多100条)
  /// [direction] – 查询方向，QUERY_OLD按结束时间点逆序查询，逆序排列；QUERY_NEW按起始时间点正序起查，正序排列
  /// [messageTypeList] – 消息类型，数组。
  /// [persist] – 通过该接口获取的漫游消息记录，要不要保存到本地消息数据库。
  Future<NIMResult<List<NIMMessage>>> pullMessageHistoryExType(
      NIMMessage anchor,
      int toTime,
      int limit,
      QueryDirection direction,
      List<NIMMessageType> messageTypeList,
      bool persist) async {
    return _platform.pullMessageHistoryExType(
        anchor, toTime, limit, direction, messageTypeList, persist);
  }

  ///删除单会话云端历史消息
  Future<void> clearServerHistory(
      String sessionId, NIMSessionType sessionType, bool sync) async {
    return _platform.clearServerHistory(sessionId, sessionType, sync);
  }

  ///单向删除单条云端历史消息
  Future<NIMResult<int>> deleteMsgSelf(NIMMessage msg, String ext) async {
    return _platform.deleteMsgSelf(msg, ext);
  }

  ///单向删除多条云端历史消息
  Future<NIMResult<int>> deleteMsgListSelf(
      List<NIMMessage> msgList, String ext) async {
    return _platform.deleteMsgListSelf(msgList, ext);
  }

  ///单会话检索(新)
  Future<NIMResult<List<NIMMessage>>> searchMessage(NIMSessionType sessionType,
      String sessionId, MessageSearchOption searchOption) async {
    return _platform.searchMessage(sessionType, sessionId, searchOption);
  }

  ///全局检索(新)
  Future<NIMResult<List<NIMMessage>>> searchAllMessage(
      MessageSearchOption searchOption) async {
    return _platform.searchAllMessage(searchOption);
  }

  /// 单聊云端消息检索
  Future<NIMResult<List<NIMMessage>>> searchRoamingMsg(
      String otherAccid,
      int fromTime,
      int endTime,
      String keyword,
      int limit,
      bool reverse) async {
    return _platform.searchRoamingMsg(
        otherAccid, fromTime, endTime, keyword, limit, reverse);
  }

  ///全文云端消息检索
  Future<NIMResult<List<NIMMessage>>> searchCloudMessageHistory(
      MessageKeywordSearchConfig config) async {
    return _platform.searchCloudMessageHistory(config);
  }

  /// 正常情况收到消息后附件会自动下载。如果下载失败，可调用该接口重新下载
  /// [message] 附件所在的消息, [thumb] 下载缩略图还是原文件， 为`true`时仅下载缩略图。 缩略图参数仅对图片和视频类消息有效
  Future<NIMResult<void>> downloadAttachment(
      {required NIMMessage message, required bool thumb}) async {
    return _platform.downloadAttachment(message: message, thumb: thumb);
  }

  /// 取消上传消息附件
  Future<NIMResult<void>> cancelUploadAttachment(NIMMessage message) async {
    return _platform.cancelUploadAttachment(message);
  }

  /// 撤回消息
  /// [message] - 要撤回的消息
  /// [customApnsText] – 第三方透传消息推送文本，不填则不推送
  /// [pushPayload] – 第三方自定义的推送属性，限制json类型，长度2048
  /// [shouldNotifyBeCount] – 撤回通知是否更新未读数
  /// [postscript] – 附言
  /// [attach] – 扩展字段
  Future<NIMResult<void>> revokeMessage(
      {required NIMMessage message,
      String? customApnsText,
      Map<String, Object>? pushPayload,
      bool? shouldNotifyBeCount,
      String? postscript,
      String? attach}) async {
    return _platform.revokeMessage(
        message: message,
        customApnsText: customApnsText,
        pushPayload: pushPayload,
        shouldNotifyBeCount: shouldNotifyBeCount,
        postscript: postscript,
        attach: attach);
  }

  /// 消息更新
  /// 支持更新客户端数据库内的消息的客户端扩展字段。
  Future<NIMResult<void>> updateMessage(NIMMessage message) async {
    return _platform.updateMessage(message);
  }

  /// (群消息发送方)批量刷新群组消息已读、未读的数量信息，没有异步回调
  /// 如果已读、未读数有变更，请监听 [onTeamMessageReceipt] 来批量通知，没有变更则不会通知
  Future<NIMResult<void>> refreshTeamMessageReceipt(
      List<NIMMessage> messageList) async {
    return _platform.refreshTeamMessageReceipt(messageList);
  }

  /// (群消息发送方)远程查询单条群组消息在指定用户中的已读、未读账号列表
  Future<NIMResult<NIMTeamMessageAckInfo>> fetchTeamMessageReceiptDetail(
      {required NIMMessage message, List<String>? accountList}) async {
    return _platform.fetchTeamMessageReceiptDetail(
        message: message, accountList: accountList);
  }

  /// 从本地数据库查询单条群组消息已读、未读账号列表（同步接口）
  /// /// 注意！！！：这里获取的数据通常比离线前的列表信息更陈旧
  Future<NIMResult<NIMTeamMessageAckInfo>> queryTeamMessageReceiptDetail(
      {required NIMMessage message, List<String>? accountList}) async {
    return _platform.queryTeamMessageReceiptDetail(
        message: message, accountList: accountList);
  }

  /// 消息转发
  /// 支持更新客户端数据库内的消息的客户端扩展字段。
  Future<NIMResult<void>> forwardMessage(
      NIMMessage message, String sessionId, NIMSessionType sessionType) async {
    return _platform.forwardMessage(message, sessionId, sessionType);
  }

  ///回复消息。<br>
  ///  [msg]    待发送的消息体，由{@link MessageBuilder}构造
  ///  [replyMsg] 被回复的消息
  ///  [resend] 如果是发送失败后重发，标记为true，否则填false
  ///
  Future<NIMResult<void>> replyMessage(
      {required NIMMessage msg,
      required NIMMessage replyMsg,
      required bool resend}) async {
    return _platform.replyMessage(msg: msg, replyMsg: replyMsg, resend: resend);
  }

  /// 添加一条收藏
  ///
  /// [type] 收藏类型，要求 > 0
  /// [date] 收藏内容，最大20k
  /// [ext] 扩展字段，最大1k
  /// [uniqueId] 去重唯一ID
  Future<NIMResult<NIMCollectInfo>> addCollect({
    required int type,
    required String data,
    String? ext,
    String? uniqueId,
  }) {
    return _platform.addCollect(
      type: type,
      data: data,
      ext: ext,
      uniqueId: uniqueId,
    );
  }

  /// 批量移除收藏
  ///
  /// [collects] 要移除的收藏的请求
  ///
  /// [NIMCollectInfo] 中 [id] 和 [createTime] 为必填字段
  Future<NIMResult<int>> removeCollect(List<NIMCollectInfo> collects) {
    return _platform.removeCollect(collects);
  }

  ///
  /// 更新一个收藏的扩展字段
  ///
  /// 如果 [info.ext] 为空，表示删除ext字段
  ///
  Future<NIMResult<NIMCollectInfo>> updateCollect(NIMCollectInfo info) {
    return _platform.updateCollect(info);
  }

  ///
  /// 从服务端分页查询收藏列表
  ///
  /// [anchor] 结束查询的最后一条收藏(不包含在查询结果中) <br>
  /// [type] 查询类型，如果为空则返回所有类型 <br>
  /// [toTime] 结束时间点单位毫秒 <br>
  /// [limit] 本次查询的消息条数上限(最多100条) <br>
  /// [direction] 查询方向 <br>
  ///
  Future<NIMResult<NIMCollectInfoQueryResult>> queryCollect({
    NIMCollectInfo? anchor,
    int toTime = 0,
    int? type,
    int limit = 100,
    QueryDirection direction = QueryDirection.QUERY_OLD,
  }) {
    return _platform.queryCollect(
      anchor: anchor,
      toTime: toTime,
      direction: direction,
      type: type,
      limit: limit,
    );
  }

  ///
  /// PIN一条消息
  ///
  /// [message] 被PIN的消息 <br>
  /// [ext] 扩展字段 <br>
  ///
  Future<NIMResult<void>> addMessagePin(NIMMessage message, String? ext) {
    return _platform.addMessagePin(message, ext);
  }

  ///
  /// 更新一条消息的PIN
  ///
  /// [message] 被PIN的消息 <br>
  /// [ext] 扩展字段；如果 ext 为空表示删除该字段 <br>
  ///
  Future<NIMResult<void>> updateMessagePin(NIMMessage message, String? ext) {
    return _platform.updateMessagePin(message, ext);
  }

  ///
  /// 删除一条消息的PIN
  ///
  /// [message] 被PIN的消息
  /// [ext] 扩展字段
  ///
  Future<NIMResult<void>> removeMessagePin(NIMMessage message, String? ext) {
    return _platform.removeMessagePin(message, ext);
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
    return _platform.queryMessagePinForSession(sessionId, sessionType);
  }

  ///  查询thread聊天云端历史（支持p2p、群、超大群）
  ///
  ///  anchor 查找锚点，查找对象为此消息所在的thread中的消息
  ///  fromTime 起始时间
  ///  toTime 终止时间
  ///  limit 条数限制
  ///  direction 方向
  ///  persist 是否持久化
  Future<NIMResult<NIMThreadTalkHistory>> queryThreadTalkHistory(
      {required NIMMessage anchor,
      required int fromTime,
      required int toTime,
      required int limit,
      required QueryDirection direction,
      required bool persist}) {
    return _platform.queryThreadTalkHistory(
        anchor: anchor,
        fromTime: fromTime,
        toTime: toTime,
        limit: limit,
        direction: direction,
        persist: persist);
  }

  /// 本地获取某thread消息的回复消息的条数，thread消息不被计入总数
  ///
  ///  msg thread中的某一条消息
  ///  回复消息数
  Future<NIMResult<int>> queryReplyCountInThreadTalkBlock(NIMMessage msg) {
    return _platform.queryReplyCountInThreadTalkBlock(msg);
  }

  /// 获取最近会话列表
  ///
  /// 最近会话列表，即最近联系人列表。当收到新联系人的消息时，SDK会自动生成这个消息对应的本地最近会话。
  /// 它记录了包括联系人帐号、联系人类型、最近一条消息的时间、消息状态、消息内容、未读条数等信息。
  ///
  /// [limit] 获取本地会话的数量，最大为100；如果不设置该值，会返回全量会话列表
  Future<NIMResult<List<NIMSession>>> querySessionList([int? limit]) async {
    return _platform.querySessionList(limit);
  }

  /// 当希望返回的会话的最近一条消息不是某一类消息时，可以使用以下过滤接口。
  ///
  /// 如希望最近一条消息为非文本消息时，使用该接口的返回的会话，将取最近的一条非文本的消息作为最近一条消息。
  ///
  /// [filterMessageType] 过滤消息类型
  Future<NIMResult<List<NIMSession>>> querySessionListFiltered(
      List<NIMMessageType> filterMessageTypeList) async {
    return _platform.querySessionListFiltered(filterMessageTypeList);
  }

  ///
  /// 查询最近联系人会话列表数据(同步接口)，可以设置limit， 防止本地会话过多时，导致第一次加载慢
  /// [sessionInfo] - 会话信息
  ///
  Future<NIMResult<NIMSession>> querySession(NIMSessionInfo sessionInfo) {
    return _platform.querySession(sessionInfo);
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
    return _platform.createSession(
      sessionId: sessionId,
      sessionType: sessionType,
      time: time,
      tag: tag,
      linkToLastMessage: linkToLastMessage,
    );
  }

  /// 更新会话对象
  ///
  /// [needNotify] 是否需要发送通知
  /// 仅支持修改 tag 以及 extension
  Future<NIMResult<void>> updateSession({
    required NIMSession session,
    bool needNotify = false,
  }) {
    return _platform.updateSession(session: session, needNotify: needNotify);
  }

  /// 使用消息更新会话对象
  ///
  /// <br>[message] 消息对象
  /// <br>[needNotify] 是否需要发送通知
  Future<NIMResult<void>> updateSessionWithMessage({
    required NIMMessage message,
    bool needNotify = false,
  }) {
    return _platform.updateSessionWithMessage(
        message: message, needNotify: needNotify);
  }

  /// 获取未读数总数
  ///
  /// [queryType] 查询类型
  Future<NIMResult<int>> queryTotalUnreadCount({
    NIMUnreadCountQueryType queryType = NIMUnreadCountQueryType.all,
  }) {
    return _platform.queryTotalUnreadCount(queryType: queryType);
  }

  /// 设置当前会话，Android iOS 平台可用
  /// 调用以下接口重置当前会话，SDK会自动管理消息的未读数。
  /// 该接口会自动调用clearUnreadCount(String, SessionTypeEnum)将正在聊天对象的未读数清零。
  /// 如果有新消息到达，且消息来源是正在聊天的对象，其未读数也不会递增。
  ///
  /// <br>[sessionId] - 聊天对象帐号，或者以下两个值：'all' 与 'none'。
  /// <br>[sessionType] - 会话类型。如果account不是具体的对象，该参数将被忽略
  Future<NIMResult<void>> setChattingAccount({
    required String sessionId,
    required NIMSessionType sessionType,
  }) {
    return _platform.setChattingAccount(
        sessionId: sessionId, sessionType: sessionType);
  }

  /// 清除未读数
  ///
  /// [sessionInfoList] 请求列表
  ///
  /// 返回不能成功处理的请求列表
  Future<NIMResult<List<NIMSessionInfo>>> clearSessionUnreadCount(
    List<NIMSessionInfo> sessionInfoList,
  ) {
    return _platform.clearSessionUnreadCount(sessionInfoList);
  }

  /// 清空所有会话的未读计数
  ///
  Future<NIMResult<void>> clearAllSessionUnreadCount() {
    return _platform.clearAllSessionUnreadCount();
  }

  /// 删除最近联系人记录。
  /// 调用该接口后，会触发[MessageService.onSessionDelete]通知
  ///
  /// [deleteType] 删除类型，决定是否删除本地记录和漫游记录
  ///
  /// [sendAck] 如果参数合法，是否向其他端标记此会话为已读
  Future<NIMResult<void>> deleteSession({
    required NIMSessionInfo sessionInfo,
    required NIMSessionDeleteType deleteType,
    required bool sendAck,
  }) {
    return _platform.deleteSession(
      sessionInfo: sessionInfo,
      deleteType: deleteType,
      sendAck: sendAck,
    );
  }

  /// 检验本地反垃圾词库，支持单聊、群聊和聊天室的文本消息反垃圾
  /// <p>[content] 需要检查的文本
  /// <p>[replacement] 指定 content 中被反垃圾词库命中后的替换文本
  /// <p>[LocalAntiSpamResult] 检验结果
  ///
  Future<NIMResult<NIMLocalAntiSpamResult>> checkLocalAntiSpam(
      String content, String replacement) {
    return _platform.checkLocalAntiSpam(content, replacement);
  }

  ///【会话服务】增量获取会话列表，增量+翻页
  /// <p>[minTimestamp] 最小时间戳，作为请求参数时表示增量获取Session列表，传0表示全量获取
  /// <p>[maxTimestamp] 最大时间戳，翻页时使用
  /// <p>[needLastMsg]  是否需要lastMsg，0或者1，默认1
  /// <p>[limit] 结果集limit，最大100，默认100
  /// <p>[hasMore] 结果集是否完整，0或者1
  Future<NIMResult<RecentSessionList>> queryMySessionList(int minTimestamp,
      int maxTimestamp, int needLastMsg, int limit, int hasMore) {
    return _platform.queryMySessionList(
        minTimestamp, maxTimestamp, needLastMsg, limit, hasMore);
  }

  ///【会话服务】获取某一个会话
  /// <p>[sessionId] 分为p2p/team/superTeam，格式分别是：p2p|accid、team|tid、super_team|tid
  Future<NIMResult<RecentSession>> queryMySession(
      String sessionId, NIMSessionType sessionType) {
    return _platform.queryMySession(sessionId, sessionType);
  }

  ///【会话服务】更新某一个会话，主要是设置会话的ext字段，如果会话不存在，则会创建出来，此时会话没有lastMsg
  ///  <p>[sessionId] 分为p2p/team/superTeam，格式分别是：p2p|accid、team|tid、super_team|tid
  ///  <p>[ext]       会话的扩展字段，仅自己可见
  Future<NIMResult<void>> updateMySession(
      String sessionId, NIMSessionType sessionType, String ext) {
    return _platform.updateMySession(sessionId, sessionType, ext);
  }

  ///【会话服务】删除会话
  /// <p>[sessionList] 目标会话
  Future<NIMResult<void>> deleteMySession(List<NIMMySessionKey> sessionList) {
    return _platform.deleteMySession(sessionList);
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
    return _platform.addQuickComment(msg, replyType, ext, needPush, needBadge,
        pushTitle, pushContent, pushPayload);
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
    return _platform.removeQuickComment(msg, replyType, ext, needPush,
        needBadge, pushTitle, pushContent, pushPayload);
  }

  ///获取快捷评论列表
  Future<NIMResult<List<NIMQuickCommentOptionWrapper>>> queryQuickComment(
      List<NIMMessage> msgList) {
    return _platform.queryQuickComment(msgList);
  }

  ///添加一个置顶会话
  Future<NIMResult<NIMStickTopSessionInfo>> addStickTopSession(
      String sessionId, NIMSessionType sessionType, String ext) {
    return _platform.addStickTopSession(sessionId, sessionType, ext);
  }

  ///删除一个置顶会话
  Future<NIMResult<void>> removeStickTopSession(
      String sessionId, NIMSessionType sessionType, String ext) {
    return _platform.removeStickTopSession(sessionId, sessionType, ext);
  }

  ///更新一个会话在置顶上的扩展字段
  Future<NIMResult<void>> updateStickTopSession(
      String sessionId, NIMSessionType sessionType, String ext) {
    return _platform.updateStickTopSession(sessionId, sessionType, ext);
  }

  ///获取置顶会话信息的列表
  Future<NIMResult<List<NIMStickTopSessionInfo>>> queryStickTopSession() {
    return _platform.queryStickTopSession();
  }

  ///获取是否有更多漫游消息标记的时间戳，如果没有，回调0
  Future<NIMResult<int>> queryRoamMsgHasMoreTime(
      String sessionId, NIMSessionType sessionType) {
    return _platform.queryRoamMsgHasMoreTime(sessionId, sessionType);
  }

  ///更新是否有更多漫游消息的标记
  Future<NIMResult<void>> updateRoamMsgHasMoreTag(NIMMessage newTag) {
    return _platform.updateRoamMsgHasMoreTag(newTag);
  }

  ///动态途径获取消息，默认从本地获取，动态能力需要开通功能，并在同步完成后生效
  Future<NIMResult<GetMessagesDynamicallyResult>> getMessagesDynamically(
      GetMessagesDynamicallyParam param) {
    return _platform.getMessagesDynamically(param);
  }

  ///根据消息关键信息批量查询服务端历史消息。
  ///[msgKeyList] 消息关键信息列表
  ///[persist] 查询的漫游消息是否同步到本地数据库。
  Future<NIMResult<List<NIMMessage>>> pullHistoryById(
      List<NIMMessageKey> msgKeyList, bool persist) {
    return _platform.pullHistoryById(msgKeyList, persist);
  }
}
