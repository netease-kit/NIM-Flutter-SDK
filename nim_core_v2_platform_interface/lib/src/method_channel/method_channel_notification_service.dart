// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import '../../nim_core_v2_platform_interface.dart';

class MethodChannelNotificationService extends NotificationServicePlatform {
  // ignore: close_sinks
  final _customNotifyController =
      StreamController<List<NIMCustomNotification>>.broadcast();

  // ignore: close_sinks
  final _broadcastNotifyController =
      StreamController<List<NIMBroadcastNotification>>.broadcast();

  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onReceiveBroadcastNotifications':
        assert(arguments is Map);
        _broadcastNotifyController.add(
            (arguments['broadcastNotifications'] as List)
                .map((e) => NIMBroadcastNotification.fromJson(
                    Map<String, dynamic>.from(e as Map)))
                .toList());
        break;
      case 'onReceiveCustomNotifications':
        assert(arguments is Map);
        _customNotifyController.add((arguments['customNotifications'] as List)
            .map((e) => NIMCustomNotification.fromJson(
                Map<String, dynamic>.from(e as Map)))
            .toList());
        break;
      default:
        throw UnimplementedError();
    }
    return Future.value();
  }

  @override
  String get serviceName => 'NotificationService';

  @override
  Stream<List<NIMBroadcastNotification>> get onReceiveBroadcastNotifications =>
      _broadcastNotifyController.stream;

  @override
  Stream<List<NIMCustomNotification>> get onReceiveCustomNotifications =>
      _customNotifyController.stream;

  @override
  Future<NIMResult<void>> sendCustomNotification(String conversationId,
      String content, NIMSendCustomNotificationParams params) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'sendCustomNotification',
        arguments: {
          'conversationId': conversationId,
          'content': content,
          'params': params.toJson(),
        },
      ),
    );
  }
}
