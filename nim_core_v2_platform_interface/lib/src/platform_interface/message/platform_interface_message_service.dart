// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:nim_core_v2_platform_interface/src/method_channel/method_channel_message_service.dart';
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

  /// 本端发送消息状态回调
  final StreamController<NIMMessage> onSendMessage =
      StreamController<NIMMessage>.broadcast();

  /// 本端发送消息进度回调
  final StreamController<NIMSendMessageProgress> onSendMessageProgress =
      StreamController<NIMSendMessageProgress>.broadcast();

  /// 消息接收
  final StreamController<List<NIMMessage>> onReceiveMessages =
      StreamController<List<NIMMessage>>.broadcast();

  /// 点对点已读回执
  final StreamController<List<NIMP2PMessageReadReceipt>>
      onReceiveP2PMessageReadReceipts =
      StreamController<List<NIMP2PMessageReadReceipt>>.broadcast();

  /// 群消息已读回执
  final StreamController<List<NIMTeamMessageReadReceipt>>
      onReceiveTeamMessageReadReceipts =
      StreamController<List<NIMTeamMessageReadReceipt>>.broadcast();

  /// 消息撤回回调
  final StreamController<List<NIMMessageRevokeNotification>>
      onMessageRevokeNotifications =
      StreamController<List<NIMMessageRevokeNotification>>.broadcast();

  /// 消息pin状态回调通知
  final StreamController<NIMMessagePinNotification> onMessagePinNotification =
      StreamController<NIMMessagePinNotification>.broadcast();

  /// 消息评论状态回调
  final StreamController<NIMMessageQuickCommentNotification>
      onMessageQuickCommentNotification =
      StreamController<NIMMessageQuickCommentNotification>.broadcast();

  /// 消息被删除通知
  final StreamController<List<NIMMessageDeletedNotification>>
      onMessageDeletedNotifications =
      StreamController<List<NIMMessageDeletedNotification>>.broadcast();

  /// 消息被清空通知
  final StreamController<List<NIMClearHistoryNotification>>
      onClearHistoryNotifications =
      StreamController<List<NIMClearHistoryNotification>>.broadcast();

  /// 查询历史消息，分页接口，每次默认50条，可以根据参数组合查询各种类型
  /// - Parameters:
  ///   - option: 查询消息配置选项
  Future<NIMResult<List<NIMMessage>>> getMessageList(
      {required NIMMessageListOption option}) async {
    throw UnimplementedError('getMessageList() is not implemented');
  }

  /// 根据ID列表查询消息，只查询本地数据库
  /// - Parameters:
  ///   - messageIds: 需要查询的消息客户端ID列表
  Future<NIMResult<List<NIMMessage>>> getMessageListByIds(
      {required List<String> messageClientIds}) async {
    throw UnimplementedError('getMessageListByIds() is not implemented');
  }

  /// 根据MessageRefer列表查询消息
  /// - Parameters:
  ///   - messageRefers 需要查询的消息Refer列表
  Future<NIMResult<List<NIMMessage>>> getMessageListByRefers(
      {required List<NIMMessageRefer> messageRefers}) async {
    throw UnimplementedError('getMessageListByRefers() is not implemented');
  }

  /// 搜索云端消息
  /// - Parameters:
  ///   - params: 消息检索参数
  Future<NIMResult<List<NIMMessage>>> searchCloudMessages(
      {required NIMMessageSearchParams params}) async {
    throw UnimplementedError('searchCloudMessages() is not implemented');
  }

  /// 本地查询thread聊天消息列表
  /// 如果消息已经删除， 回复数， 回复列表不包括已删除消息
  /// - Parameters:
  ///  - messageRefer: 需要查询的消息引用，如果该消息为根消息，则参数为当前消息；否则需要获取当前消息的跟消息作为输入参数查询；否则查询失败
  Future<NIMResult<NIMThreadMessageListResult>> getLocalThreadMessageList(
      {required NIMMessageRefer messageRefer}) async {
    throw UnimplementedError('getLocalThreadMessageList() is not implemented');
  }

  /// 查询thread聊天云端消息列表
  /// 建议查询getLocalThreadMessageList， 本地消息已经完全同步，减少网络请求， 以及避免触发请求频控
  /// - Parameters:
  /// - threadMessageListOption: thread消息查询选项
  Future<NIMResult<NIMThreadMessageListResult>> getThreadMessageList(
      {required NIMThreadMessageListOption threadMessageListOption}) async {
    throw UnimplementedError('getThreadMessageList() is not implemented');
  }

  /// 插入一条本地消息， 该消息不会
  /// 该消息不会多端同步，只是本端显示
  /// 插入成功后， SDK会抛出回调
  /// - Parameters:
  ///   - message: 需要插入的消息体
  ///   - conversationId: 会话 ID
  ///   - senderId: 消息发送者账号
  ///   - createTime: 指定插入消息时间
  Future<NIMResult<NIMMessage>> insertMessageToLocal(
      {required NIMMessage message,
      required String conversationId,
      String? senderId,
      int? createTime}) async {
    throw UnimplementedError('insertMessageToLocal() is not implemented');
  }

  /// 更新消息本地扩展字段
  /// - Parameters:
  ///   - message: 需要被更新的消息体
  ///   - localExtension: 扩展字段
  Future<NIMResult<NIMMessage>> updateMessageLocalExtension(
      {required NIMMessage message, required String localExtension}) async {
    throw UnimplementedError(
        'updateMessageLocalExtension() is not implemented');
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
    throw UnimplementedError('sendMessage() is not implemented');
  }

  /// 回复消息
  /// - Parameters:
  ///   - message: 需要发送的消息体
  ///   - replyMessage: 被回复的消息
  Future<NIMResult<NIMSendMessageResult>> replyMessage(
      {required NIMMessage message,
      required NIMMessage replyMessage,
      NIMSendMessageParams? params}) async {
    throw UnimplementedError('replyMessage() is not implemented');
  }

  /// 撤回消息
  /// 只能撤回已经发送成功的消息
  /// - Parameters:
  ///   - message: 要撤回的消息
  ///   - revokeParams: 撤回消息相关参数
  Future<NIMResult<void>> revokeMessage(
      {required NIMMessage message,
      NIMMessageRevokeParams? revokeParams}) async {
    throw UnimplementedError('revokeMessage() is not implemented');
  }

  /// Pin一条消息
  /// - Parameters:
  ///   - message: 需要被pin的消息体
  ///   - serverExtension: 扩展字段
  Future<NIMResult<void>> pinMessage(
      {required NIMMessage message, String? serverExtension}) async {
    throw UnimplementedError('pinMessage() is not implemented');
  }

  /// 取消一条Pin消息
  /// - Parameters:
  ///   - messageRefer: 需要被unpin的消息体
  ///   - serverExtension: 扩展字段
  Future<NIMResult<void>> unpinMessage(
      {required NIMMessageRefer messageRefer, String? serverExtension}) async {
    throw UnimplementedError('unpinMessage() is not implemented');
  }

  /// 更新一条Pin消息
  /// - Parameters:
  ///   - message: 需要被更新pin的消息体
  ///   - serverExtension: 扩展字段
  Future<NIMResult<void>> updatePinMessage(
      {required NIMMessage message, String? serverExtension}) async {
    throw UnimplementedError('updatePinMessage() is not implemented');
  }

  /// 获取 pin 消息列表
  /// - Parameters:
  ///   - conversationId: 会话 ID
  Future<NIMResult<List<NIMMessagePin>>> getPinnedMessageList(
      {required String conversationId}) async {
    throw UnimplementedError('getPinnedMessageList() is not implemented');
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
    throw UnimplementedError('addQuickComment() is not implemented');
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
    throw UnimplementedError('removeQuickComment() is not implemented');
  }

  /// 获取快捷评论
  /// - Parameters:
  ///   - messages: 被快捷评论的消息
  Future<NIMResult<Map<String, List<NIMMessageQuickComment>?>>>
      getQuickCommentList({required List<NIMMessage> messages}) async {
    throw UnimplementedError('getQuickCommentList() is not implemented');
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
    throw UnimplementedError('deleteMessage() is not implemented');
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
  ///   false：同时删除云端
  Future<NIMResult<void>> deleteMessages(
      {required List<NIMMessage> messages,
      String? serverExtension,
      bool? onlyDeleteLocal}) async {
    throw UnimplementedError('deleteMessages() is not implemented');
  }

  /// 清空历史消息
  /// 同步删除本地消息，云端消息
  /// 会话不会被删除
  /// - Parameters:
  ///   - option: 清空消息配置选项
  Future<NIMResult<void>> clearHistoryMessage(
      {required NIMClearHistoryMessageOption option}) async {
    throw UnimplementedError('clearHistoryMessage() is not implemented');
  }

  /// 发送消息已读回执
  /// - Parameters:
  ///   - message: 需要发送已读回执的消息
  Future<NIMResult<void>> sendP2PMessageReceipt(
      {required NIMMessage message}) async {
    throw UnimplementedError('sendP2PMessageReceipt() is not implemented');
  }

  /// 查询点对点消息已读回执
  /// - Parameters:
  ///   - conversationId: 需要查询已读回执的会话
  Future<NIMResult<NIMP2PMessageReadReceipt>> getP2PMessageReceipt(
      {required String conversationId}) async {
    throw UnimplementedError('getP2PMessageReceipt() is not implemented');
  }

  /// 查询点对点消息是否对方已读 内部判断逻辑为： 消息时间小于对方已读回执时间都为true
  /// - Parameter message: 消息体
  Future<NIMResult<bool>> isPeerRead({required NIMMessage message}) async {
    throw UnimplementedError('isPeerRead() is not implemented');
  }

  /// 发送群消息已读回执
  /// 所有消息必须属于同一个会话
  /// - Parameters:
  ///   - messages: 需要发送已读回执的消息列表
  Future<NIMResult<void>> sendTeamMessageReceipts(
      {required List<NIMMessage> messages}) async {
    throw UnimplementedError('sendTeamMessageReceipts() is not implemented');
  }

  /// 获取群消息已读回执状态
  /// - Parameters:
  ///   - messages: 需要查询已读回执状态的消息
  Future<NIMResult<List<NIMTeamMessageReadReceipt>>> getTeamMessageReceipts(
      {required List<NIMMessage> messages}) async {
    throw UnimplementedError('getTeamMessageReceipts() is not implemented');
  }

  /// 获取群消息已读回执状态详情
  /// - Parameters:
  ///   - message: 需要查询已读回执状态的消息
  ///   - memberAccountIds: 查找指定的账号列表已读未读
  Future<NIMResult<NIMTeamMessageReadReceiptDetail>>
      getTeamMessageReceiptDetail(
          {required NIMMessage message, Set<String>? memberAccountIds}) async {
    throw UnimplementedError(
        'getTeamMessageReceiptDetail() is not implemented');
  }

  /// 添加收藏
  /// - Parameter params: 收藏参数
  Future<NIMResult<NIMCollection>> addCollection(
      {required NIMAddCollectionParams params}) async {
    throw UnimplementedError('addCollection() is not implemented');
  }

  /// 移除收藏
  /// - Parameter collections: 要移除的收藏列表
  Future<NIMResult<int>> removeCollections(
      {required List<NIMCollection> collections}) async {
    throw UnimplementedError('removeCollections() is not implemented');
  }

  /// 更新收藏扩展字段
  /// - Parameter collection: 需要更新的收藏信息
  /// - Parameter serverExtension: 扩展字段。为空， 表示移除扩展字段, 否则更新为新扩展字段
  Future<NIMResult<NIMCollection>> updateCollectionExtension(
      {required NIMCollection collection, String? serverExtension}) async {
    throw UnimplementedError('updateCollectionExtension() is not implemented');
  }

  /// 获取收藏列表
  /// - Parameter option: 查询参数
  Future<NIMResult<List<NIMCollection>>> getCollectionListByOption(
      {required NIMCollectionOption option}) async {
    throw UnimplementedError('getCollectionListByOption() is not implemented');
  }

  /// 语音转文字
  /// - Parameter params: 语音转文字参数
  Future<NIMResult<String>> voiceToText(
      {required NIMVoiceToTextParams params}) async {
    throw UnimplementedError('voiceToText() is not implemented');
  }

  ///取消文件类附件上传，只有文件类消息可以调用该接口
  /// - Parameter message: 需要取消附件上传的消息体
  Future<NIMResult<void>> cancelMessageAttachmentUpload(
      {required NIMMessage message}) async {
    throw UnimplementedError(
        'cancelMessageAttachmentUpload() is not implemented');
  }
}
