// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class MethodChannelQChatObserver extends QChatObserverPlatform {
  // ignore: close_sinks
  final _onAttachmentProgress =
      StreamController<AttachmentProgress>.broadcast();

  // ignore: close_sinks
  final _onKickedOut = StreamController<QChatKickedOutEvent>.broadcast();

  // ignore: close_sinks
  final _onMessageDelete =
      StreamController<QChatMessageDeleteEvent>.broadcast();

  // ignore: close_sinks
  final _onMessageRevoke =
      StreamController<QChatMessageRevokeEvent>.broadcast();

  // ignore: close_sinks
  final _onMessageStatusChange = StreamController<QChatMessage>.broadcast();

  // ignore: close_sinks
  final _onMessageUpdate =
      StreamController<QChatMessageUpdateEvent>.broadcast();

  // ignore: close_sinks
  final _onMultiSpotLogin =
      StreamController<QChatMultiSpotLoginEvent>.broadcast();

  // ignore: close_sinks
  final _onReceiveMessage = StreamController<List<QChatMessage>>.broadcast();

  // ignore: close_sinks
  final _onReceiveSystemNotification =
      StreamController<List<QChatSystemNotification>>.broadcast();

  // ignore: close_sinks
  final _onStatusChange = StreamController<QChatStatusChangeEvent>.broadcast();

  // ignore: close_sinks
  final _onSystemNotificationUpdate =
      StreamController<QChatSystemNotificationUpdateEvent>.broadcast();

  // ignore: close_sinks
  final _onUnreadInfoChanged =
      StreamController<QChatUnreadInfoChangedEvent>.broadcast();

  // ignore: close_sinks
  final _serverUnreadInfoChanged =
      StreamController<QChatServerUnreadInfoChangedEvent>.broadcast();

  // ignore: close_sinks
  final _onReceiveTypingEvent = StreamController<QChatTypingEvent>.broadcast();

  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onStatusChange':
        assert(arguments is Map);
        _onStatusChange.add(QChatStatusChangeEvent.fromJson(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onMultiSpotLogin':
        assert(arguments is Map);
        _onMultiSpotLogin.add(QChatMultiSpotLoginEvent.fromJson(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onKickedOut':
        assert(arguments is Map);
        _onKickedOut.add(QChatKickedOutEvent.fromJson(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onReceiveMessage':
        assert(arguments is Map && arguments['eventList'] is List);
        _onReceiveMessage.add((arguments['eventList'] as List)
            .whereType<Map>()
            .map((e) => QChatMessage.fromJson(Map<String, dynamic>.from(e)))
            .toList());
        break;
      case 'onMessageUpdate':
        assert(arguments is Map);
        _onMessageUpdate.add(QChatMessageUpdateEvent.fromJson(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onMessageRevoke':
        assert(arguments is Map);
        _onMessageRevoke.add(QChatMessageRevokeEvent.fromJson(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onMessageDelete':
        assert(arguments is Map);
        _onMessageDelete.add(QChatMessageDeleteEvent.fromJson(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onUnreadInfoChanged':
        assert(arguments is Map);
        _onUnreadInfoChanged.add(QChatUnreadInfoChangedEvent.fromJson(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onMessageStatusChange':
        assert(arguments is Map);
        _onMessageStatusChange.add(
            QChatMessage.fromJson(Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onAttachmentProgress':
        assert(arguments is Map);
        _onAttachmentProgress.add(AttachmentProgress.fromJson(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onReceiveSystemNotification':
        assert(arguments is Map && arguments['eventList'] is List);
        _onReceiveSystemNotification.add((arguments['eventList'] as List)
            .whereType<Map>()
            .map((e) =>
                QChatSystemNotification.fromJson(Map<String, dynamic>.from(e)))
            .toList());
        break;
      case 'onSystemNotificationUpdate':
        assert(arguments is Map);
        _onSystemNotificationUpdate.add(
            QChatSystemNotificationUpdateEvent.fromJson(
                Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'serverUnreadInfoChanged':
        assert(arguments is Map);
        _serverUnreadInfoChanged.add(QChatServerUnreadInfoChangedEvent.fromJson(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onReceiveTypingEvent':
        assert(arguments is Map);
        _onReceiveTypingEvent.add(QChatTypingEvent.fromJson(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      default:
        throw UnimplementedError();
    }
    return Future.value();
  }

  @override
  String get serviceName => 'QChatObserver';

  @override
  Stream<AttachmentProgress> get onAttachmentProgress =>
      _onAttachmentProgress.stream;

  @override
  Stream<QChatKickedOutEvent> get onKickedOut => _onKickedOut.stream;

  @override
  Stream<QChatMessageDeleteEvent> get onMessageDelete =>
      _onMessageDelete.stream;

  @override
  Stream<QChatMessageRevokeEvent> get onMessageRevoke =>
      _onMessageRevoke.stream;

  @override
  Stream<QChatMessage> get onMessageStatusChange =>
      _onMessageStatusChange.stream;

  @override
  Stream<QChatMessageUpdateEvent> get onMessageUpdate =>
      _onMessageUpdate.stream;

  @override
  Stream<QChatMultiSpotLoginEvent> get onMultiSpotLogin =>
      _onMultiSpotLogin.stream;

  @override
  Stream<List<QChatMessage>> get onReceiveMessage => _onReceiveMessage.stream;

  @override
  Stream<List<QChatSystemNotification>> get onReceiveSystemNotification =>
      _onReceiveSystemNotification.stream;

  @override
  Stream<QChatStatusChangeEvent> get onStatusChange => _onStatusChange.stream;

  @override
  Stream<QChatSystemNotificationUpdateEvent> get onSystemNotificationUpdate =>
      _onSystemNotificationUpdate.stream;

  @override
  Stream<QChatUnreadInfoChangedEvent> get onUnreadInfoChanged =>
      _onUnreadInfoChanged.stream;

  @override
  Stream<QChatServerUnreadInfoChangedEvent> get serverUnreadInfoChanged =>
      _serverUnreadInfoChanged.stream;

  @override
  Stream<QChatTypingEvent> get onReceiveTypingEvent =>
      _onReceiveTypingEvent.stream;
}
