// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'apns_data.g.dart';

enum NIMPushNotificationDisplayType {
  /// 显示详情
  @JsonValue(1)
  pushNotificationDisplayTypeDetail,

  /// 不显示详情
  @JsonValue(2)
  pushNotificationDisplayTypeNoDetail,
}

enum NIMPushNotificationProfile {
  /// 未指定
  @JsonValue(0)
  pushNotificationProfileNotSet,

  /// 全部消息都收
  @JsonValue(1)
  pushNotificationProfileEnableAll,

  /// 只收高、中等级消息
  @JsonValue(2)
  pushNotificationProfileOnlyHighAndMediumLevel,

  /// 只收高等级消息
  @JsonValue(3)
  pushNotificationProfileOnlyHighLevel,

  /// 全部消息都不收
  @JsonValue(4)
  pushNotificationProfileDisableAll,

  /// 使用平台默认配置
  @JsonValue(5)
  pushNotificationProfilePlatformDefault,
}

/// 消息推送免打扰参数设置
@JsonSerializable()
class NIMPushNotificationSetting {
  /// 推送消息显示类型
  late NIMPushNotificationDisplayType type;

  /// 推送消息是否开启免打扰 YES表示开启免打扰
  late bool noDisturbing;

  /// 免打扰开始时间:小时
  late int noDisturbingStartH;

  /// 免打扰开始时间:分
  late int noDisturbingStartM;

  /// 免打扰结束时间:小时
  late int noDisturbingEndH;

  /// 免打扰结束时间:分
  late int noDisturbingEndM;

  /// 推送消息等级配置（当前仅在圈组中设置有效）
  late NIMPushNotificationProfile profile;

  NIMPushNotificationSetting({
    required this.type,
    required this.noDisturbing,
    required this.noDisturbingStartH,
    required this.noDisturbingStartM,
    required this.noDisturbingEndH,
    required this.noDisturbingEndM,
    required this.profile,
  });

  factory NIMPushNotificationSetting.fromJson(Map<String, dynamic> json) =>
      _$NIMPushNotificationSettingFromJson(json);

  Map<String, dynamic> toJson() => _$NIMPushNotificationSettingToJson(this);
}

/// 自定义消息多端推送策略配置项
@JsonSerializable()
class NIMPushNotificationMultiportConfig {
  ///  桌面端在线时是否需要发送推送给手机端
  ///  @discussion 默认为 YES，即需要推送,桌面端包括 PC，web , macOS 等...
  late bool shouldPushNotificationWhenPCOnline;

  NIMPushNotificationMultiportConfig(
      {required this.shouldPushNotificationWhenPCOnline});

  factory NIMPushNotificationMultiportConfig.fromJson(
          Map<String, dynamic> json) =>
      _$NIMPushNotificationMultiportConfigFromJson(json);

  Map<String, dynamic> toJson() =>
      _$NIMPushNotificationMultiportConfigToJson(this);
}
