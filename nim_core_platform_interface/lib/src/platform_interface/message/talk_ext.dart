// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

part 'talk_ext.g.dart';

/// 收藏信息
@JsonSerializable()
class NIMCollectInfo {
  /// 此收藏的ID，由服务端生成，具有唯一性
  final int id;

  /// 收藏的类型
  final int type;

  /// 数据，最大20480
  final String data;

  /// 扩展字段，最大1024
  /// 该字段可以更新
  String? ext;

  /// 去重ID，如果多个收藏具有相同的去重ID，则视为同一条收藏
  final String? uniqueId;

  /// 创建时间，单位为秒
  final double createTime;

  /// 更新时间，单位为 秒
  final double updateTime;

  NIMCollectInfo({
    required this.id,
    required this.type,
    required this.data,
    this.ext,
    this.uniqueId,
    this.createTime = 0.0,
    this.updateTime = 0.0,
  });

  factory NIMCollectInfo.fromMap(Map<String, dynamic> map) =>
      _$NIMCollectInfoFromJson(map);

  Map<String, dynamic> toMap() => _$NIMCollectInfoToJson(this);
}

/// 收藏信息查询结果
class NIMCollectInfoQueryResult {
  final int totalCount;

  final List<NIMCollectInfo>? collectList;

  NIMCollectInfoQueryResult({
    this.totalCount = 0,
    this.collectList,
  });
}

/// 消息PIN
@JsonSerializable()
class NIMMessagePin {
  /// 会话ID
  final String sessionId;

  /// 会话类型
  final NIMSessionType sessionType;

  /// 消息发送方帐号
  final String? messageFromAccount;

  /// 消息接收方账号
  final String? messageToAccount;

  /// 消息发送时间
  final int messageTime;

  /// 消息ID,唯一标识，iOS 可用
  @JsonKey(defaultValue: '-1')
  final String? messageId;

  /// 消息 uuid ，Android & Windows & macOS可用
  final String? messageUuid;

  /// 被pin的消息唯一标识，Windows&macOS可用
  @JsonKey(defaultValue: '-1')
  final String? pinId;

  /// 消息 ServerID
  final int? messageServerId;

  /// 操作者账号，不传表示当前登录者
  final String? pinOperatorAccount;

  /// 扩展字段，string，最大512
  final String? pinExt;

  /// 创建时间，单位为秒
  final int pinCreateTime;

  /// 更新时间，单位为 秒
  final int pinUpdateTime;

  NIMMessagePin({
    required this.sessionId,
    required this.sessionType,
    this.messageFromAccount,
    this.messageToAccount,
    this.messageTime = 0,
    this.messageUuid,
    this.messageId,
    this.pinId,
    this.messageServerId,
    this.pinOperatorAccount,
    this.pinExt,
    this.pinCreateTime = 0,
    this.pinUpdateTime = 0,
  });

  factory NIMMessagePin.fromMap(Map<String, dynamic> map) =>
      _$NIMMessagePinFromJson(map);

  Map<String, dynamic> toMap() => _$NIMMessagePinToJson(this);

  @override
  String toString() {
    return 'NIMMessagePin{sessionId: $sessionId, pinOperatorAccount: $pinOperatorAccount, pinExt: $pinExt}';
  }
}

/// 会话消息查询结果
// class NIMSessionMessagePinResult {
//
//     /// 同步时间戳
//     final int timestamp;
//
//     /// 请求同步PIN时传入了一个时间戳，和时间戳对应的时间的PIN数据相比，同步时间的数据是否有改变
//     final bool changed;
//
//     /// 当前会话全量的 PIN 列表
//     final List<NIMMessagePin>? pinList;
//
//     NIMSessionMessagePinResult({
//     this.timestamp = 0,
//     this.changed = false,
//     this.pinList,
//   });
//
// }

/// 消息PIN事件类
abstract class NIMMessagePinEvent {
  final NIMMessagePin pin;

  NIMMessagePinEvent(this.pin);

  @override
  String toString() {
    return '$runtimeType{pin: $pin}';
  }
}

///  消息PIN 添加事件
class NIMMessagePinAddedEvent extends NIMMessagePinEvent {
  NIMMessagePinAddedEvent(NIMMessagePin pin) : super(pin);
}

///  消息PIN 移除事件
class NIMMessagePinRemovedEvent extends NIMMessagePinEvent {
  NIMMessagePinRemovedEvent(NIMMessagePin pin) : super(pin);
}

///  消息PIN 更新事件
class NIMMessagePinUpdatedEvent extends NIMMessagePinEvent {
  NIMMessagePinUpdatedEvent(NIMMessagePin pin) : super(pin);
}

/// 服务端会话Key，包含 sessionId 与 sessionType
class NIMMySessionKey {
  /// 会话ID
  final String sessionId;

  /// 会话类型
  final NIMSessionType sessionType;

  NIMMySessionKey({
    required this.sessionId,
    required this.sessionType,
  });

  Map<String, dynamic> toMap() => {
        'sessionId': sessionId,
        'sessionType':
            NIMSessionTypeConverter(sessionType: sessionType).toValue(),
      };
}
