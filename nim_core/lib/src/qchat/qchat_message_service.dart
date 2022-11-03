// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
part of nim_core;

///圈组消息服务
///仅支持Android 和 iOS
class QChatMessageService {
  factory QChatMessageService() {
    if (_singleton == null) {
      _singleton = QChatMessageService._();
    }
    return _singleton!;
  }

  QChatMessageService._();

  static QChatMessageService? _singleton;

  QChatMessageServicePlatform _platform = QChatMessageServicePlatform.instance;

  /// 发送消息
  Future<NIMResult<QChatSendMessageResult>> sendMessage(
      QChatSendMessageParam param) {
    return _platform.sendMessage(param);
  }

  /// 重发消息
  Future<NIMResult<QChatSendMessageResult>> resendMessage(
      QChatResendMessageParam param) {
    return _platform.resendMessage(param);
  }

  /// 默认情况下（SDKOPtions#preloadAttach为true），SDK收到多媒体消息后，图片和视频会自动下载缩略图，音频会自动下载文件。
  /// 如果下载原图或者原视频等，可调用该接口下载附件
  Future<NIMResult<void>> downloadAttachment(
      QChatDownloadAttachmentParam param) {
    return _platform.downloadAttachment(param);
  }

  /// 查询历史消息
  Future<NIMResult<QChatGetMessageHistoryResult>> getMessageHistory(
      QChatGetMessageHistoryParam param) {
    return _platform.getMessageHistory(param);
  }

  /// 更新消息
  Future<NIMResult<QChatUpdateMessageResult>> updateMessage(
      QChatUpdateMessageParam param) {
    return _platform.updateMessage(param);
  }

  /// 撤回消息
  Future<NIMResult<QChatRevokeMessageResult>> revokeMessage(
      QChatRevokeMessageParam param) {
    return _platform.revokeMessage(param);
  }

  /// 删除消息
  Future<NIMResult<QChatDeleteMessageResult>> deleteMessage(
      QChatDeleteMessageParam param) {
    return _platform.deleteMessage(param);
  }

  /// 标记消息已读，该接口存在频控，300ms内只能调用1次
  Future<NIMResult<void>> markMessageRead(QChatMarkMessageReadParam param) {
    return _platform.markMessageRead(param);
  }

  /// 发送系统通知
  Future<NIMResult<QChatSendSystemNotificationResult>> sendSystemNotification(
      QChatSendSystemNotificationParam param) {
    return _platform.sendSystemNotification(param);
  }

  /// 重发系统通知
  Future<NIMResult<QChatSendSystemNotificationResult>> resendSystemNotification(
      QChatResendSystemNotificationParam param) {
    return _platform.resendSystemNotification(param);
  }

  /// 更新系统通知,除了更新自定义系统通知外，还允许更新邀请服务器成员、
  /// 拒绝邀请、申请加入服务器、拒绝申请这几种内置系统通知
  Future<NIMResult<QChatUpdateSystemNotificationResult>>
      updateSystemNotification(QChatUpdateSystemNotificationParam param) {
    return _platform.updateSystemNotification(param);
  }

  /// 标记系统通知已读
  Future<NIMResult<void>> markSystemNotificationsRead(
      QChatMarkSystemNotificationsReadParam param) {
    return _platform.markSystemNotificationsRead(param);
  }

  /// 根据消息id查询历史消息
  Future<NIMResult<QChatGetMessageHistoryResult>> getMessageHistoryByIds(
      QChatGetMessageHistoryByIdsParam param) {
    return _platform.getMessageHistoryByIds(param);
  }
}
