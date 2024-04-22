// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class CustomNotification {
  final String? sessionId;

  final NIMSessionType? sessionType;

  final String? fromAccount;

  final int? time;

  final String? content;

  final bool? sendToOnlineUserOnly;

  final String? apnsText;

  final Map<String, dynamic>? pushPayload;

  final CustomNotificationConfig? config;

  final NIMAntiSpamOption? antiSpamOption;

  final String? env;

  CustomNotification(
      {this.sessionId,
      this.sessionType,
      this.fromAccount,
      this.time,
      this.content,
      this.apnsText,
      this.pushPayload,
      this.config,
      this.antiSpamOption,
      this.env,
      this.sendToOnlineUserOnly = true});

  factory CustomNotification.fromMap(Map<String, dynamic> param) {
    return CustomNotification(
      sessionId: param["sessionId"] as String?,
      sessionType:
          NIMSessionTypeConverter().fromValue(param["sessionType"] as String),
      fromAccount: param["fromAccount"] as String?,
      time: param["time"] as int?,
      content: param["content"] as String?,
      apnsText: param["apnsText"] as String?,
      pushPayload: castPlatformMapToDartMap(param["pushPayload"] as Map?),
      config: CustomNotificationConfig.fromMap(
          (param["config"] as Map?)?.cast<String, dynamic>()),
      // antiSpamOption: NIMAntiSpamOption.fromMap(param["antiSpamOption"] as Map<String,dynamic>?) ,
      env: param["env"] as String?,
      sendToOnlineUserOnly: param["sendToOnlineUserOnly"] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        "sessionId": sessionId,
        "sessionType":
            NIMSessionTypeConverter(sessionType: sessionType).toValue(),
        "fromAccount": fromAccount,
        "time": time,
        "content": content,
        "sendToOnlineUserOnly": sendToOnlineUserOnly,
        "apnsText": apnsText,
        "pushPayload": pushPayload,
        "config": config?.toMap(),
        "antiSpamOption": antiSpamOption?.toMap(),
        "env": env,
      };
}

class CustomNotificationConfig {
  bool? enablePush = true;
  bool? enablePushNick = false;
  bool? enableUnreadCount = true;

  CustomNotificationConfig(
      {this.enablePush, this.enablePushNick, this.enableUnreadCount});

  factory CustomNotificationConfig.fromMap(Map<String, dynamic>? param) {
    return CustomNotificationConfig(
      enablePush: param?["enablePush"] as bool?,
      enablePushNick: param?["enablePushNick"] as bool?,
      enableUnreadCount: param?["enableUnreadCount"] as bool?,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        "enablePush": enablePush,
        "enablePushNick": enablePushNick,
        "enableUnreadCount": enableUnreadCount,
      };
}
