// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'qchat_base_models.g.dart';

@JsonSerializable(explicitToJson: true)
class QChatAntiSpamConfigParam {
  /// 反垃圾配置
  @JsonKey(fromJson: antiSpamConfigFromJson)
  QChatAntiSpamConfig? antiSpamConfig;

  QChatAntiSpamConfigParam();

  factory QChatAntiSpamConfigParam.fromJson(Map<String, dynamic> json) =>
      _$QChatAntiSpamConfigParamFromJson(json);
  Map<String, dynamic> toJson() => _$QChatAntiSpamConfigParamToJson(this);

  @override
  String toString() {
    return 'QChatAntiSpamConfigParam{antiSpamConfig: $antiSpamConfig}';
  }
}

QChatAntiSpamConfig? antiSpamConfigFromJson(Map? map) {
  if (map == null) {
    return null;
  }
  return QChatAntiSpamConfig.fromJson(map.cast<String, dynamic>());
}

@JsonSerializable()
class QChatAntiSpamConfig extends AntiSpamConfig {
  QChatAntiSpamConfig();

  factory QChatAntiSpamConfig.fromJson(Map<String, dynamic> json) =>
      _$QChatAntiSpamConfigFromJson(json);
  Map<String, dynamic> toJson() => _$QChatAntiSpamConfigToJson(this);
}

@JsonSerializable()
class AntiSpamConfig {
  /// 用户配置的对某些资料内容另外的反垃圾的业务ID, Json, {"textbid":"","picbid":""}
  String? antiSpamBusinessId;

  AntiSpamConfig();

  factory AntiSpamConfig.fromJson(Map<String, dynamic> json) =>
      _$AntiSpamConfigFromJson(json);
  Map<String, dynamic> toJson() => _$AntiSpamConfigToJson(this);

  @override
  String toString() {
    return 'AntiSpamConfig{antiSpamBusinessId: $antiSpamBusinessId}';
  }
}

@JsonSerializable()
class QChatGetByPageResult {
  /// 表示是否还有下一页
  final bool hasMore;

  /// 下一次翻页时的起始时间戳
  final int? nextTimeTag;

  QChatGetByPageResult({this.hasMore = false, this.nextTimeTag});

  factory QChatGetByPageResult.fromJson(Map<String, dynamic> json) =>
      _$QChatGetByPageResultFromJson(json);
  Map<String, dynamic> toJson() => _$QChatGetByPageResultToJson(this);

  @override
  String toString() {
    return 'QChatGetByPageResult{hasMore: $hasMore, nextTimeTag: $nextTimeTag}';
  }
}

enum QChatSubscribeType {
  /// 订阅某个channel的【消息】/【通知】
  channelMsg,

  /// 订阅某个channel的【消息未读数】/【通知】
  channelMsgUnreadCount,

  /// 订阅某个channel的【消息未读状态】/【通知】
  channelMsgUnreadStatus,

  /// 订阅某个server的【消息】/【通知】，如server基本信息修改、人员进出、权限变更、创建channel等
  serverMsg,

  /// 订阅某个频道的消息正在输入事件
  channelMsgTyping
}

extension QChatSubscribeTypeExtension on QChatSubscribeType {
  int value() {
    int result = -1;
    switch (this) {
      case QChatSubscribeType.channelMsg:
        result = 1;
        break;
      case QChatSubscribeType.channelMsgUnreadCount:
        result = 2;
        break;
      case QChatSubscribeType.channelMsgUnreadStatus:
        result = 3;
        break;
      case QChatSubscribeType.serverMsg:
        result = 4;
        break;
      case QChatSubscribeType.channelMsgTyping:
        result = 5;
        break;
    }
    return result;
  }

  static QChatSubscribeType? typeOfValue(int value) {
    for (QChatSubscribeType e in QChatSubscribeType.values) {
      if (e.value() == value) {
        return e;
      }
    }
    return null;
  }

  static bool isIllegalChannelSubType(int subType) {
    return (subType >= QChatSubscribeType.channelMsg.value() &&
            subType <= QChatSubscribeType.channelMsgUnreadStatus.value()) ||
        subType == QChatSubscribeType.channelMsgTyping.value();
  }

  static bool isIllegalServerSubType(int subType) {
    return subType >= QChatSubscribeType.serverMsg.value() &&
        subType <= QChatSubscribeType.serverMsg.value();
  }
}

enum QChatSubscribeOperateType {
  /// 订阅
  sub,

  /// 取消订阅
  unSub
}

extension QChatSubscribeOperateTypeExtension on QChatSubscribeOperateType {
  int value() {
    int result = -1;
    switch (this) {
      case QChatSubscribeOperateType.sub:
        result = 1;
        break;
      case QChatSubscribeOperateType.unSub:
        result = 2;
        break;
    }
    return result;
  }

  static QChatSubscribeOperateType? typeOfValue(int value) {
    for (QChatSubscribeOperateType e in QChatSubscribeOperateType.values) {
      if (e.value() == value) {
        return e;
      }
    }
    return null;
  }
}

enum QChatMemberType {
  /// 普通成员
  normal,

  /// 所有者
  owner
}

extension QChatMemberTypeExtension on QChatMemberType {
  int value() {
    int result = -1;
    switch (this) {
      case QChatMemberType.normal:
        result = 0;
        break;
      case QChatMemberType.owner:
        result = 1;
        break;
    }
    return result;
  }

  static QChatMemberType? typeOfValue(int value) {
    for (QChatMemberType e in QChatMemberType.values) {
      if (e.value() == value) {
        return e;
      }
    }
    return null;
  }
}

abstract class QChatGetByPageWithCursorResult extends QChatGetByPageResult {
  /// 可选：查询游标，下次查询的起始位置
  String? cursor;

  QChatGetByPageWithCursorResult(bool? hasMore, int? nextTimeTag, this.cursor)
      : super(hasMore: hasMore ?? false, nextTimeTag: nextTimeTag);

  @override
  String toString() {
    return 'QChatGetByPageWithCursorResult{cursor: $cursor, hasMore: $hasMore, nextTimeTag: $nextTimeTag}';
  }
}

@JsonSerializable(explicitToJson: true)
class QChatUnreadInfo {
  /// 获取serverId

  int serverId;

  /// 获取channelId

  int channelId;

  /// 获取已读时间戳
  int? ackTimeTag;

  /// 获取未读数

  int? unreadCount;

  /// 获取@的未读数

  int? mentionedCount;

  /// 获取最大未读数

  int? maxCount;

  /// 获取最后一条消息的时间戳
  int? lastMsgTime;

  /// 获取服务器当前时间
  int? time;

  QChatUnreadInfo(
      {required this.channelId,
      required this.serverId,
      this.maxCount,
      this.mentionedCount,
      this.unreadCount,
      this.ackTimeTag,
      this.lastMsgTime,
      this.time});

  factory QChatUnreadInfo.fromJson(Map<String, dynamic> json) =>
      _$QChatUnreadInfoFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUnreadInfoToJson(this);
}

abstract class QChatUpdateUserPushConfigParam {
  /// 推送消息类型选项
  final QChatPushMsgType pushMsgType;

  QChatUpdateUserPushConfigParam(this.pushMsgType);
}

/// 推送消息类型选项
/// 低等级消息：普通消息等（没有具体目标、没有@意愿） 中等级消息： @所有人等（没有具体目标、有@意愿） 高等级消息： @某些人等（有具体目标、有@意愿）
enum QChatPushMsgType {
  /// 推送全部类型消息
  all,

  /// 只推送高、中等级消息
  highMidLevel,

  /// 只推送高等级消息
  highLevel,

  /// 全部消息都不推送
  none,

  /// 继承上一级配置
  inherit
}
