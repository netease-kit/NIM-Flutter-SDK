// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/method_channel/method_channel_qchat_message_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class QChatMessageServicePlatform extends Service {
  QChatMessageServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static QChatMessageServicePlatform _instance =
      MethodChannelQChatMessageService();

  static QChatMessageServicePlatform get instance => _instance;

  static set instance(QChatMessageServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 发送消息

  Future<NIMResult<QChatSendMessageResult>> sendMessage(
      QChatSendMessageParam param);

  /// 重发消息

  Future<NIMResult<QChatSendMessageResult>> resendMessage(
      QChatResendMessageParam param);

  /// 默认情况下（SDKOPtions#preloadAttach为true），SDK收到多媒体消息后，图片和视频会自动下载缩略图，音频会自动下载文件。
  /// 如果下载原图或者原视频等，可调用该接口下载附件
  Future<NIMResult<void>> downloadAttachment(
      QChatDownloadAttachmentParam param);

  /// 查询历史消息

  Future<NIMResult<QChatGetMessageHistoryResult>> getMessageHistory(
      QChatGetMessageHistoryParam param);

  /// 更新消息

  Future<NIMResult<QChatUpdateMessageResult>> updateMessage(
      QChatUpdateMessageParam param);

  /// 撤回消息

  Future<NIMResult<QChatRevokeMessageResult>> revokeMessage(
      QChatRevokeMessageParam param);

  /// 删除消息

  Future<NIMResult<QChatDeleteMessageResult>> deleteMessage(
      QChatDeleteMessageParam param);

  /// 标记消息已读，该接口存在频控，300ms内只能调用1次

  Future<NIMResult<void>> markMessageRead(QChatMarkMessageReadParam param);

  /// 发送系统通知

  Future<NIMResult<QChatSendSystemNotificationResult>> sendSystemNotification(
      QChatSendSystemNotificationParam param);

  /// 重发系统通知

  Future<NIMResult<QChatSendSystemNotificationResult>> resendSystemNotification(
      QChatResendSystemNotificationParam param);

  /// 更新系统通知,除了更新自定义系统通知外，还允许更新邀请服务器成员、
  /// 拒绝邀请、申请加入服务器、拒绝申请这几种内置系统通知
  Future<NIMResult<QChatUpdateSystemNotificationResult>>
      updateSystemNotification(QChatUpdateSystemNotificationParam param);

  /// 标记系统通知已读

  Future<NIMResult<void>> markSystemNotificationsRead(
      QChatMarkSystemNotificationsReadParam param);

  /// 根据消息id查询历史消息

  Future<NIMResult<QChatGetMessageHistoryResult>> getMessageHistoryByIds(
      QChatGetMessageHistoryByIdsParam param);

  ///回复消息
  Future<NIMResult<QChatSendMessageResult>> replyMessage(
      QChatReplyMessageParam param);

  /// 清除消息通知栏

  Future<NIMResult<void>> clearMsgNotifyAndroid();

  /// 根据消息查询被引用的消息详情
  Future<NIMResult<QChatGetReferMessagesResult>> getReferMessages(
      QChatGetReferMessagesParam param);

  /// 查询thread聊天的历史

  Future<NIMResult<QChatGetThreadMessagesResult>> getThreadMessages(
      QChatGetThreadMessagesParam param);

  /// 批量查询thread聊天信息

  Future<NIMResult<QChatGetMessageThreadInfosResult>> getMessageThreadInfos(
      QChatGetMessageThreadInfosParam param);

  /// 添加一条快捷评论

  Future<NIMResult<void>> addQuickComment(QChatAddQuickCommentParam param);

  /// 删除一条快捷评论

  Future<NIMResult<void>> removeQuickComment(
      QChatRemoveQuickCommentParam param);

  /// 批量查询快捷评论

  Future<NIMResult<QChatGetQuickCommentsResult>> getQuickComments(
      QChatGetQuickCommentsParam param);

  /// 指定通道查询消息缓存
  /// [qchatServerId] 服务器id
  /// [qchatChannelId] 频道id

  Future<NIMResult<List<QChatMessageCache>?>> getMessageCache(
      int qchatServerId, int qchatChannelId);

  /// 清空消息缓存

  Future<NIMResult<void>> clearMessageCache();

  /// 查询频道的最后一条消息

  Future<NIMResult<QChatGetLastMessageOfChannelsResult>>
      getLastMessageOfChannels(QChatGetLastMessageOfChannelsParam param);

  /// 检索消息

  Future<NIMResult<QChatSearchMsgByPageResult>> searchMsgByPage(
      QChatSearchMsgByPageParam param);

  /// 发送消息正在输入事件
  /// 接收方需要调用订阅指定频道事件订阅正在输入事件后后才能就可以收到指定频道的正在输入事件
  Future<NIMResult<QChatSendTypingEventResult>> sendTypingEvent(
      QChatSendTypingEventParam param);

  ///分页查询指定频道@我的消息
  Future<NIMResult<QChatGetMentionedMeMessagesResult>> getMentionedMeMessages(
      QChatGetMentionedMeMessagesParam param);

  ///批量查询消息是否@当前用户
  Future<NIMResult<QChatAreMentionedMeMessagesResult>> areMentionedMeMessages(
      QChatAreMentionedMeMessagesParam param);
}
