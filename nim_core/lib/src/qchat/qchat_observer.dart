// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core;

///圈组回调
///目前仅支持iOS和Android平台
@HawkEntryPoint()
class QChatObserver {
  factory QChatObserver() {
    if (_singleton == null) {
      _singleton = QChatObserver._();
    }
    return _singleton!;
  }

  QChatObserver._();

  static QChatObserver? _singleton;

  QChatObserverPlatform _platform = QChatObserverPlatform.instance;

  ///圈组在线状态/登录状态观察者

  Stream<QChatStatusChangeEvent> get onStatusChange => _platform.onStatusChange;

  ///多端登录状态观察,当有其他端登录或者注销时，会通过此接口通知到UI。
  ///登录成功后，如果有其他端登录着，也会发出通知。

  Stream<QChatMultiSpotLoginEvent> get onMultiSpotLogin =>
      _platform.onMultiSpotLogin;

  ///被踢出的事件

  Stream<QChatKickedOutEvent> get onKickedOut => _platform.onKickedOut;

  ///收到的消息集合

  Stream<List<QChatMessage>> get onReceiveMessage => _platform.onReceiveMessage;

  ///消息更新事件

  Stream<QChatMessageUpdateEvent> get onMessageUpdate =>
      _platform.onMessageUpdate;

  ///消息撤回事件

  Stream<QChatMessageRevokeEvent> get onMessageRevoke =>
      _platform.onMessageRevoke;

  ///删除的消息事件

  Stream<QChatMessageDeleteEvent> get onMessageDelete =>
      _platform.onMessageDelete;

  ///新的未读通知事件
  ///订阅、标记消息已读、收到新消息或新消息通知会触发该通知
  ///通知事件内的新未读状态可能没有实际变更，比如重复调用订阅接口触发的变更事件

  Stream<QChatUnreadInfoChangedEvent> get onUnreadInfoChanged =>
      _platform.onUnreadInfoChanged;

  ///消息状态变化事件
  ///更改的状态可能包含status和attachStatus

  Stream<QChatMessage> get onMessageStatusChange =>
      _platform.onMessageStatusChange;

  ///消息附件上传/下载进度观察者，以message id作为key

  Stream<AttachmentProgress> get onAttachmentProgress =>
      _platform.onAttachmentProgress;

  ///系统通知接收事件

  Stream<List<QChatSystemNotification>> get onReceiveSystemNotification =>
      _platform.onReceiveSystemNotification;

  ///系统通知更新观事件

  Stream<QChatSystemNotificationUpdateEvent> get onSystemNotificationUpdate =>
      _platform.onSystemNotificationUpdate;

  /// 未读通知接收
  /// 订阅、标记消息已读、收到新消息或新消息通知会触发该通知
  /// 如果服务器前后未读数没有发生变化将不会触发
  Stream<QChatServerUnreadInfoChangedEvent> get serverUnreadInfoChanged =>
      _platform.serverUnreadInfoChanged;

  /// 接收到的消息正在输入事件
  Stream<QChatTypingEvent> get onReceiveTypingEvent =>
      _platform.onReceiveTypingEvent;
}
