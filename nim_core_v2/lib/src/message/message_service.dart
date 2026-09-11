// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

/// 消息服务
@HawkEntryPoint()
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

  /// 本端发送消息状态回调
  @HawkApi(ignore: true)
  Stream<NIMMessage> get onSendMessage =>
      MessageServicePlatform.instance.onSendMessage.stream;

  /// 本端发送消息进度回调
  @HawkApi(ignore: true)
  Stream<NIMSendMessageProgress> get onSendMessageProgress =>
      MessageServicePlatform.instance.onSendMessageProgress.stream;

  /// 消息接收
  @HawkApi(ignore: true)
  Stream<List<NIMMessage>> get onReceiveMessages =>
      MessageServicePlatform.instance.onReceiveMessages.stream;

  /// 点对点已读回执
  @HawkApi(ignore: true)
  Stream<List<NIMP2PMessageReadReceipt>> get onReceiveP2PMessageReadReceipts =>
      MessageServicePlatform.instance.onReceiveP2PMessageReadReceipts.stream;

  /// 群消息已读回执
  @HawkApi(ignore: true)
  Stream<List<NIMTeamMessageReadReceipt>>
      get onReceiveTeamMessageReadReceipts => MessageServicePlatform
          .instance.onReceiveTeamMessageReadReceipts.stream;

  /// 消息撤回回调
  @HawkApi(ignore: true)
  Stream<List<NIMMessageRevokeNotification>> get onMessageRevokeNotifications =>
      MessageServicePlatform.instance.onMessageRevokeNotifications.stream;

  /// 消息pin状态回调通知
  @HawkApi(ignore: true)
  Stream<NIMMessagePinNotification> get onMessagePinNotification =>
      MessageServicePlatform.instance.onMessagePinNotification.stream;

  /// 消息评论状态回调
  @HawkApi(ignore: true)
  Stream<NIMMessageQuickCommentNotification>
      get onMessageQuickCommentNotification => MessageServicePlatform
          .instance.onMessageQuickCommentNotification.stream;

  /// 消息被删除通知
  @HawkApi(ignore: true)
  Stream<List<NIMMessageDeletedNotification>>
      get onMessageDeletedNotifications =>
          MessageServicePlatform.instance.onMessageDeletedNotifications.stream;

  /// 消息被清空通知
  @HawkApi(ignore: true)
  Stream<List<NIMClearHistoryNotification>> get onClearHistoryNotifications =>
      MessageServicePlatform.instance.onClearHistoryNotifications.stream;

  /// 消息更新通知
  @HawkApi(ignore: true)
  Stream<List<NIMMessage>> get onReceiveMessagesModified =>
      MessageServicePlatform.instance.onReceiveMessagesModified.stream;

  /// 是否过滤消息
  /// [message] 当前接收到的消息体内容
  /// 返回 true 表示需要过滤掉该消息，返回 false 表示不过滤
  /// 请使用[setMessageFilter] 设置，设置成功后可以使用
  /// 此过滤器不支持Flutter 多引擎
  @HawkApi(ignore: true)
  NIMMessageFilter? get shouldIgnore => _platform.shouldIgnore;

  /// 查询历史消息，分页接口，每次默认50条，可以根据参数组合查询各种类型
  /// - Parameters:
  ///   - option: 查询消息配置选项
  Future<NIMResult<List<NIMMessage>>> getMessageList(
      {required NIMMessageListOption option}) async {
    return _platform.getMessageList(option: option);
  }

  /// 根据ID列表查询消息，只查询本地数据库
  /// - Parameters:
  ///   - messageIds: 需要查询的消息客户端ID列表
  /// web 不支持
  Future<NIMResult<List<NIMMessage>>> getMessageListByIds(
      {required List<String> messageClientIds}) async {
    return _platform.getMessageListByIds(messageClientIds: messageClientIds);
  }

  /// 根据MessageRefer列表查询消息
  /// - Parameters:
  ///   - messageRefers 需要查询的消息Refer列表
  Future<NIMResult<List<NIMMessage>>> getMessageListByRefers(
      {required List<NIMMessageRefer> messageRefers}) async {
    return _platform.getMessageListByRefers(messageRefers: messageRefers);
  }

  /// 搜索云端消息
  /// - Parameters:
  ///   - params: 消息检索参数
  Future<NIMResult<List<NIMMessage>>> searchCloudMessages(
      {required NIMMessageSearchParams params}) async {
    return _platform.searchCloudMessages(params: params);
  }

  /// 本地查询thread聊天消息列表
  /// 如果消息已经删除， 回复数， 回复列表不包括已删除消息
  /// - Parameters:
  ///  - messageRefer: 需要查询的消息引用，如果该消息为根消息，则参数为当前消息；否则需要获取当前消息的跟消息作为输入参数查询；否则查询失败
  /// web 不支持
  Future<NIMResult<NIMThreadMessageListResult>> getLocalThreadMessageList(
      {required NIMMessageRefer messageRefer}) async {
    return _platform.getLocalThreadMessageList(messageRefer: messageRefer);
  }

  /// 查询thread聊天云端消息列表
  /// 建议查询getLocalThreadMessageList， 本地消息已经完全同步，减少网络请求， 以及避免触发请求频控
  /// - Parameters:
  /// - threadMessageListOption: thread消息查询选项
  Future<NIMResult<NIMThreadMessageListResult>> getThreadMessageList(
      {required NIMThreadMessageListOption threadMessageListOption}) async {
    return _platform.getThreadMessageList(
        threadMessageListOption: threadMessageListOption);
  }

  /// 插入一条本地消息， 该消息不会
  /// 该消息不会多端同步，只是本端显示
  /// 插入成功后， SDK会抛出回调
  /// - Parameters:
  ///   - message: 需要插入的消息体
  ///   - conversationId: 会话 ID
  ///   - senderId: 消息发送者账号
  ///   - createTime: 指定插入消息时间
  /// web 不支持
  Future<NIMResult<NIMMessage>> insertMessageToLocal(
      {required NIMMessage message,
      required String conversationId,
      String? senderId,
      int? createTime}) async {
    return _platform.insertMessageToLocal(
        message: message,
        conversationId: conversationId,
        senderId: senderId,
        createTime: createTime);
  }

  /// 插入一条本地消息（扩展版），该消息不会发送，不会多端同步，仅本端显示
  /// - Parameters:
  ///   - message: 需要插入的消息体
  ///   - params: 相关插入参数
  Future<NIMResult<NIMMessage>> insertMessageToLocalEx(
      {required NIMMessage message,
      required V2NIMMessageInsertParams params}) async {
    return _platform.insertMessageToLocalEx(message: message, params: params);
  }

  /// 更新消息本地扩展字段
  /// - Parameters:
  ///   - message: 需要被更新的消息体
  ///   - localExtension: 扩展字段
  /// web 不支持
  Future<NIMResult<NIMMessage>> updateMessageLocalExtension(
      {required NIMMessage message, required String localExtension}) async {
    return _platform.updateMessageLocalExtension(
        message: message, localExtension: localExtension);
  }

  /// 发送消息
  /// 如果需要更新发送状态，请监听 [onSendMessage]。
  /// 如果需要更新发送进度，请监听 [onSendMessageProgress]。
  /// - Parameters:
  ///   - message: 需要发送的消息体
  ///   - conversationId: 会话Id
  ///   - params: 发送消息相关配置参数
  Future<NIMResult<NIMSendMessageResult>> sendMessage(
      {required NIMMessage message,
      required String conversationId,
      NIMSendMessageParams? params}) async {
    return _platform.sendMessage(
        message: message, conversationId: conversationId, params: params);
  }

  /// 回复消息
  /// - Parameters:
  ///   - message: 需要发送的消息体
  ///   - replyMessage: 被回复的消息
  Future<NIMResult<NIMSendMessageResult>> replyMessage(
      {required NIMMessage message,
      required NIMMessage replyMessage,
      NIMSendMessageParams? params}) async {
    return _platform.replyMessage(
        message: message, replyMessage: replyMessage, params: params);
  }

  /// 撤回消息
  /// 只能撤回已经发送成功的消息
  /// - Parameters:
  ///   - message: 要撤回的消息
  ///   - revokeParams: 撤回消息相关参数
  Future<NIMResult<void>> revokeMessage(
      {required NIMMessage message,
      NIMMessageRevokeParams? revokeParams}) async {
    return _platform.revokeMessage(
        message: message, revokeParams: revokeParams);
  }

  /// Pin一条消息
  /// - Parameters:
  ///   - message: 需要被pin的消息体
  ///   - serverExtension: 扩展字段
  Future<NIMResult<void>> pinMessage(
      {required NIMMessage message, String? serverExtension}) async {
    return _platform.pinMessage(
        message: message, serverExtension: serverExtension);
  }

  /// 取消一条Pin消息
  /// - Parameters:
  ///   - messageRefer: 需要被unpin的消息体
  ///   - serverExtension: 扩展字段
  Future<NIMResult<void>> unpinMessage(
      {required NIMMessageRefer messageRefer, String? serverExtension}) async {
    return _platform.unpinMessage(
        messageRefer: messageRefer, serverExtension: serverExtension);
  }

  /// 更新一条Pin消息
  /// - Parameters:
  ///   - message: 需要被更新pin的消息体
  ///   - serverExtension: 扩展字段
  Future<NIMResult<void>> updatePinMessage(
      {required NIMMessage message, String? serverExtension}) async {
    return _platform.updatePinMessage(
        message: message, serverExtension: serverExtension);
  }

  /// 获取 pin 消息列表
  /// - Parameters:
  ///   - conversationId: 会话 ID
  Future<NIMResult<List<NIMMessagePin>>> getPinnedMessageList(
      {required String conversationId}) async {
    return _platform.getPinnedMessageList(conversationId: conversationId);
  }

  /// 添加快捷评论
  /// - Parameters:
  ///   - message: 被快捷评论的消息
  ///   - index: 快捷评论映射标识符
  ///            可以自定义映射关系，例如 表情回复： 可以本地构造映射关系， 1：笑脸  2：大笑， 当前读取到对应的index后，界面展示可以替换对应的表情 还可以应用于其他场景， 文本快捷回复等
  ///   - serverExtension: 扩展字段， 最大8个字符
  ///   - pushConfig: 快捷评论推送配置
  Future<NIMResult<void>> addQuickComment(
      {required NIMMessage message,
      required int index,
      String? serverExtension,
      NIMMessageQuickCommentPushConfig? pushConfig}) async {
    return _platform.addQuickComment(
        message: message,
        index: index,
        serverExtension: serverExtension,
        pushConfig: pushConfig);
  }

  /// 移除快捷评论
  /// - Parameters:
  ///   - messageRefer: 被快捷评论的消息
  ///   - index: 快捷评论索引
  ///   - serverExtension: 扩展字段， 最大8个字符
  Future<NIMResult<void>> removeQuickComment(
      {required NIMMessageRefer messageRefer,
      required int index,
      String? serverExtension}) async {
    return _platform.removeQuickComment(
        messageRefer: messageRefer,
        index: index,
        serverExtension: serverExtension);
  }

  /// 获取快捷评论
  /// - Parameters:
  ///   - messages: 被快捷评论的消息
  Future<NIMResult<Map<String, List<NIMMessageQuickComment>?>>>
      getQuickCommentList({required List<NIMMessage> messages}) async {
    return _platform.getQuickCommentList(messages: messages);
  }

  /// 删除消息
  /// 如果消息未发送成功,则只删除本地消息
  /// - Parameters:
  ///   - message: 需要删除的消息
  ///   - serverExtension: 扩展字段
  ///   - onlyDeleteLocal: 是否只删除本地消息
  ///   true：只删除本地，本地会将该消息标记为删除,getMessage会过滤该消息，界面不展示，卸载重装会再次显示
  ///   fasle：同时删除云端
  Future<NIMResult<void>> deleteMessage(
      {required NIMMessage message,
      String? serverExtension,
      bool? onlyDeleteLocal}) async {
    return _platform.deleteMessage(
        message: message,
        serverExtension: serverExtension,
        onlyDeleteLocal: onlyDeleteLocal);
  }

  /// 批量删除消息
  /// 如果单条消息未发送成功， 则只删除本地消息
  /// 每次50条, 不能跨会话删除,所有消息都属于同一个会话
  /// 删除本地消息不会多端同步，删除云端会多端同步
  /// - Parameters:
  ///   - messages: 需要删除的消息列表
  ///   - serverExtension: 扩展字段
  ///   - onlyDeleteLocal: 是否只删除本地消息
  ///   true：只删除本地，本地会将该消息标记为删除， getHistoryMessage会过滤该消息，界面不展示，卸载重装会再次显示
  ///   fasle：同时删除云端
  Future<NIMResult<void>> deleteMessages(
      {required List<NIMMessage> messages,
      String? serverExtension,
      bool? onlyDeleteLocal}) async {
    return _platform.deleteMessages(
        messages: messages,
        serverExtension: serverExtension,
        onlyDeleteLocal: onlyDeleteLocal);
  }

  /// 清空历史消息
  /// 同步删除本地消息，云端消息
  /// 会话不会被删除
  /// - Parameters:
  ///   - option: 清空消息配置选项
  Future<NIMResult<void>> clearHistoryMessage(
      {required NIMClearHistoryMessageOption option}) async {
    return _platform.clearHistoryMessage(option: option);
  }

  /// 发送消息已读回执
  /// - Parameters:
  ///   - message: 需要发送已读回执的消息
  Future<NIMResult<void>> sendP2PMessageReceipt(
      {required NIMMessage message}) async {
    return _platform.sendP2PMessageReceipt(message: message);
  }

  /// 查询点对点消息已读回执
  /// - Parameters:
  ///   - conversationId: 需要查询已读回执的会话
  Future<NIMResult<NIMP2PMessageReadReceipt>> getP2PMessageReceipt(
      {required String conversationId}) async {
    return _platform.getP2PMessageReceipt(conversationId: conversationId);
  }

  /// 查询点对点消息是否对方已读 内部判断逻辑为： 消息时间小于对方已读回执时间都为true
  /// - Parameter message: 消息体
  Future<NIMResult<bool>> isPeerRead({required NIMMessage message}) async {
    return _platform.isPeerRead(message: message);
  }

  /// 发送群消息已读回执
  /// 所有消息必须属于同一个会话
  /// - Parameters:
  ///   - messages: 需要发送已读回执的消息列表
  Future<NIMResult<void>> sendTeamMessageReceipts(
      {required List<NIMMessage> messages}) async {
    return _platform.sendTeamMessageReceipts(messages: messages);
  }

  /// 获取群消息已读回执状态
  /// - Parameters:
  ///   - messages: 需要查询已读回执状态的消息
  Future<NIMResult<List<NIMTeamMessageReadReceipt>>> getTeamMessageReceipts(
      {required List<NIMMessage> messages}) async {
    return _platform.getTeamMessageReceipts(messages: messages);
  }

  /// 获取群消息已读回执状态详情
  /// - Parameters:
  ///   - message: 需要查询已读回执状态的消息
  ///   - memberAccountIds: 查找指定的账号列表已读未读
  Future<NIMResult<NIMTeamMessageReadReceiptDetail>>
      getTeamMessageReceiptDetail(
          {required NIMMessage message, Set<String>? memberAccountIds}) async {
    return _platform.getTeamMessageReceiptDetail(
        message: message, memberAccountIds: memberAccountIds);
  }

  /// 添加收藏
  /// - Parameter params: 收藏参数
  Future<NIMResult<NIMCollection>> addCollection(
      {required NIMAddCollectionParams params}) async {
    return _platform.addCollection(params: params);
  }

  /// 移除收藏
  /// - Parameter collections: 要移除的收藏列表
  Future<NIMResult<int>> removeCollections(
      {required List<NIMCollection> collections}) async {
    return _platform.removeCollections(collections: collections);
  }

  /// 更新收藏扩展字段
  /// - Parameter collection: 需要更新的收藏信息
  /// - Parameter serverExtension: 扩展字段。为空， 表示移除扩展字段, 否则更新为新扩展字段
  Future<NIMResult<NIMCollection>> updateCollectionExtension(
      {required NIMCollection collection, String? serverExtension}) async {
    return _platform.updateCollectionExtension(
        collection: collection, serverExtension: serverExtension);
  }

  /// 获取收藏列表
  /// - Parameter option: 查询参数
  Future<NIMResult<List<NIMCollection>>> getCollectionListByOption(
      {required NIMCollectionOption option}) async {
    return _platform.getCollectionListByOption(option: option);
  }

  /// 语音转文字
  /// - Parameter params: 语音转文字参数
  Future<NIMResult<String>> voiceToText(
      {required NIMVoiceToTextParams params}) async {
    return _platform.voiceToText(params: params);
  }

  ///取消文件类附件上传，只有文件类消息可以调用该接口
  /// - Parameter message: 需要取消附件上传的消息体
  Future<NIMResult<void>> cancelMessageAttachmentUpload(
      {required NIMMessage message}) async {
    return _platform.cancelMessageAttachmentUpload(message: message);
  }

  /// 消息序列化为字符串
  /// [message] 消对象
  /// 返回序列化后的字符串
  Future<NIMResult<String>> messageSerialization(NIMMessage message) {
    return _platform.messageSerialization(message);
  }

  /// 字符串反序列化为消息对象
  /// [msg]  messageSerialization方法序列化后的字符串
  /// 反序列化后的消息对象
  Future<NIMResult<NIMMessage>> messageDeserialization(String msg) {
    return _platform.messageDeserialization(msg);
  }

  ///更新消息
  /// [message] 需要更新的消息
  /// [params] 更新参数
  Future<NIMResult<NIMModifyMessageResult>> modifyMessage(
      NIMMessage message, NIMModifyMessageParams params) {
    return _platform.modifyMessage(message, params);
  }

  ///重新输出数字人消息
  /// [message] 需要重新输出的消息体
  ///  [params] 重新输出的配置参数，确定重新输出的操作类型
  Future<NIMResult<void>> regenAIMessage(
      NIMMessage message, NIMMessageAIRegenParams params) {
    return _platform.regenAIMessage(message, params);
  }

  ///停止流式消息输出
  /// [message] 需要停止的消息体
  ///  [params] 停止AI流式消息相关参数
  Future<NIMResult<void>> stopAIStreamMessage(
      NIMMessage message, NIMMessageAIStreamStopParams params) {
    return _platform.stopAIStreamMessage(message, params);
  }

  ///安装消息过滤器
  ///云端会话的最后一条消息不受该过滤器控制
  ///[filter] 消息过滤器,传null 则取消消息过滤
  @HawkApi(ignore: true)
  Future<NIMResult<void>> setMessageFilter(NIMMessageFilter? filter) {
    return _platform.setMessageFilter(filter);
  }

  /// 搜索云端消息
  /// [params]  消息检索参数
  Future<NIMResult<NIMMessageSearchResult>> searchCloudMessagesEx(
      NIMMessageSearchExParams params) {
    return _platform.searchCloudMessagesEx(params);
  }

  /// 检索本地消息
  /// [params]  消息检索参数
  Future<NIMResult<NIMMessageSearchResult>> searchLocalMessages(
      NIMMessageSearchExParams params) {
    return _platform.searchLocalMessages(params);
  }

  ///查询历史消息
  /// 分页接口，每次默认50条，可以根据参数组合查询各种类型
  /// [option] 查询消息配置选项
  Future<NIMResult<NIMMessageListResult>> getMessageListEx(
      NIMMessageListOption option) {
    return _platform.getMessageListEx(option);
  }

  ///按条件分页获取收藏信息。回调结果包含总条数
  /// [option] 查询参数
  Future<NIMResult<NIMCollectionListResult>> getCollectionListExByOption(
      NIMCollectionOption option) {
    return _platform.getCollectionListExByOption(option);
  }

  ///更新本地插入的消息
  ///  serverid为0的消息
  /// 云端消息请调用modifyMessage接口
  /// [message] 需要被更新的消息体
  /// [params] 需要更新的数据字段
  Future<NIMResult<NIMMessage>> updateLocalMessage(
      NIMMessage message, NIMUpdateLocalMessageParams params) {
    return _platform.updateLocalMessage(message, params);
  }

  /// 仅清空会话漫游消息， 单次传递最多50个会话ID
  /// [conversationIds] 需要清理的会话ID
  Future<NIMResult<void>> clearRoamingMessage(
      {required List<String> conversationIds}) {
    return _platform.clearRoamingMessage(conversationIds: conversationIds);
  }

  /// 清理本地消息
  ///
  /// [params] 清理参数，包含时间戳锚点和是否同时删除会话；为 null 则清理所有本地消息
  Future<NIMResult<void>> clearLocalMessage(
      NIMClearLocalMessageParams? params) {
    return _platform.clearLocalMessage(params);
  }

  /// 翻译文本 @since v10.9.75
  ///
  /// [params] 翻译参数，包含待翻译文本、源语言和目标语言
  /// [config] 翻译器配置，可选，默认开启严格模式
  Future<NIMResult<NIMTextTranslationResult>> translateText({
    required NIMTextTranslateParams params,
    NIMTranslatorConfig? config,
  }) {
    return _platform.translateText(params: params, config: config);
  }
}
