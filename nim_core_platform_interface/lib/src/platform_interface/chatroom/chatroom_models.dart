// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/src/platform_interface/message/message.dart';
import 'package:nim_core_platform_interface/src/utils/converter.dart';
part 'chatroom_models.g.dart';

/// 加入聊天室请求
@JsonSerializable()
class NIMChatRoomEnterRequest {
  /// 聊天室ID
  final String roomId;

  /// 进入聊天室后展示的昵称
  /// 可选字段,如果不填则直接使用NimUserInfo的数据
  final String? nickname;

  /// 进入聊天室后展示的头像
  final String? avatar;

  /// 进入聊天室后展示的扩展字段，长度限制4K
  @JsonKey(fromJson: castPlatformMapToDartMap)
  final Map<String, dynamic>? extension;

  /// 进入聊天室通知开发者扩展字段，长度限制2K
  @JsonKey(fromJson: castPlatformMapToDartMap)
  final Map<String, dynamic>? notifyExtension;

  /// 登录标签，可以设置多个, 例子：["tag1", "tag2"]
  final List<String>? tags;

  /// 登录登出通知的目标标签，是一个标签表达式，见TagCalculator和TagPattern
  final String? notifyTargetTags;

  /// 重试加入聊天室的次数
  final int? retryCount;

  NIMChatRoomEnterRequest({
    required this.roomId,
    this.nickname,
    this.avatar,
    this.extension,
    this.notifyExtension,
    this.tags,
    this.notifyTargetTags,
    this.retryCount,
  });

  factory NIMChatRoomEnterRequest.fromMap(Map<String, dynamic> map) =>
      _$NIMChatRoomEnterRequestFromJson(map);

  Map<String, dynamic> toJson() => _$NIMChatRoomEnterRequestToJson(this);
}

/// 加入聊天室响应
@JsonSerializable()
class NIMChatroomEnterResult {
  /// 聊天室ID
  final String roomId;

  // final int resCode;

  /// 聊天室信息
  @JsonKey(toJson: _chatroomInfoToJson, fromJson: _chatroomInfoFromJson)
  final NIMChatroomInfo roomInfo;

  /// 当前用户聊天室成员信息
  @JsonKey(toJson: _chatroomMemberToJson, fromJson: _chatroomMemberFromJson)
  final NIMChatroomMember member;

  /// 账号
  // final String account;

  NIMChatroomEnterResult({
    required this.roomId,
    // required this.resCode,
    required this.roomInfo,
    required this.member,
  });

  factory NIMChatroomEnterResult.fromMap(Map<String, dynamic> json) =>
      _$NIMChatroomEnterResultFromJson(json);
}

@JsonSerializable()
class NIMChatroomInfo {
  /// roomId
  final String roomId;

  /// 聊天室名称
  final String? name;

  /// 聊天室公告
  final String? announcement;

  /// 视频直播拉流地址
  final String? broadcastUrl;

  /// 聊天室创建者账号
  final String? creator;

  /// 聊天室有效标记
  @JsonKey(defaultValue: 0)
  final int validFlag;

  /// 当前在线用户数量
  @JsonKey(defaultValue: 0)
  final int onlineUserCount;

  /// 聊天室禁言标记
  @JsonKey(defaultValue: 0)
  final int mute;

  /// 第三方扩展字段, 长度4k
  @JsonKey(fromJson: castPlatformMapToDartMap)
  final Map<String, dynamic>? extension;

  /// 第三方扩展字段，长度限制4K(iOS)
  final String? ext;

  /// 队列管理权限，如是否有权限提交他人key和信息到队列中
  @JsonKey(unknownEnumValue: NIMChatroomQueueModificationLevel.anyone)
  final NIMChatroomQueueModificationLevel queueModificationLevel;

  NIMChatroomInfo({
    required this.roomId,
    this.name,
    this.announcement,
    this.broadcastUrl,
    this.creator,
    this.validFlag = 0,
    this.onlineUserCount = 0,
    this.mute = 0,
    this.extension,
    this.ext,
    this.queueModificationLevel = NIMChatroomQueueModificationLevel.anyone,
  });

  factory NIMChatroomInfo.fromMap(Map<String, dynamic> json) =>
      _$NIMChatroomInfoFromJson(json);

  /// 当前聊天室是否有效
  bool get isValid => validFlag == 1;

  /// 当前聊天室是否禁言
  bool get isMute => mute == 0x01;
}

_chatroomInfoToJson(NIMChatroomInfo info) => _$NIMChatroomInfoToJson(info);
NIMChatroomInfo _chatroomInfoFromJson(Map map) =>
    NIMChatroomInfo.fromMap(map.cast<String, dynamic>());

_chatroomMemberToJson(NIMChatroomMember member) =>
    _$NIMChatroomMemberToJson(member);
NIMChatroomMember _chatroomMemberFromJson(Map map) =>
    NIMChatroomMember.fromMap(map.cast<String, dynamic>());

/// 聊天室队列修改权限
enum NIMChatroomQueueModificationLevel {
  /// 所有人都可以修改聊天室队列
  anyone,

  /// 只有管理员可以修改聊天室队列
  manager,
}

/// 聊天室成员信息
@JsonSerializable()
class NIMChatroomMember {
  /// 聊天室id
  final String roomId;

  /// 成员账号
  final String account;

  /// 成员类型：主要分为游客和非游客，非游客又分成受限用户、普通用户、创建者、管理员;
  @JsonKey(unknownEnumValue: NIMChatroomMemberType.unknown)
  final NIMChatroomMemberType memberType;

  // final int memberLevel;    // 成员级别：大于等于0表示用户开发者可以自定义的级别

  /// 聊天室内的昵称字段，预留字段，可从NimUserInfo中取，也可以由用户进聊天室时提交。
  final String? nickname;

  /// 聊天室内的头像，预留字段，可从NimUserInfo中取avatar，可以由用户进聊天室时提交。
  final String? avatar;

  /// 开发者扩展字段，长度限制4k，可以由用户进聊天室时提交。
  @JsonKey(fromJson: castPlatformMapToDartMap)
  final Map<String, dynamic>? extension;

  /// (iOS)聊天室内预留给开发者的扩展字段，由用户进聊天室时提交。
  final String? roomExt;

  /// 成员是否处于在线状态，仅特殊成员才可能离线，对游客/匿名用户而言只能是在线。
  final bool isOnline;

  /// 是否在黑名单中
  final bool isInBlackList;

  /// 是禁言用户
  final bool isMuted;

  /// 是否临时禁言
  final bool isTempMuted;

  /// 临时禁言的解除时长,单位秒
  final int? tempMuteDuration;

  /// 记录有效标记为
  final bool isValid;

  /// 进入聊天室的时间点,对于离线成员该字段为空
  final int? enterTime;

  /// 固定成员的记录更新时间,用于固定成员列表的排列查询
  // final int? updateTime;

  /// 用户标签
  final List<String>? tags;

  /// 通知目标标签
  final String? notifyTargetTags;

  NIMChatroomMember({
    required this.roomId,
    required this.account,
    required this.memberType,
    required this.nickname,
    this.avatar,
    this.extension,
    this.roomExt,
    this.isOnline = true,
    this.isInBlackList = false,
    this.isMuted = false,
    this.isTempMuted = false,
    this.tempMuteDuration,
    this.isValid = true,
    this.enterTime,
    this.tags,
    this.notifyTargetTags,
  });

  factory NIMChatroomMember.fromMap(Map<String, dynamic> json) =>
      _$NIMChatroomMemberFromJson(json);
}

/// 聊天室成员类型
enum NIMChatroomMemberType {
  /// 未知
  unknown,

  /// 游客
  guest,

  /// 受限用户（非游客）= 被禁言 + 被拉黑的用户
  restricted,

  /// 普通成员（非游客）
  normal,

  /// 创建者（非游客）
  creator,

  /// 管理员（非游客）
  manager,

  /// 匿名游客
  anonymous,
}

/// 聊天室状态
enum NIMChatroomStatus {
  /// 正在进入聊天室
  connecting,

  /// 进入聊天室成功
  connected,

  /// 从聊天室断开
  disconnected,

  /// 连接失败
  failure,
}

/// 聊天室事件
abstract class NIMChatroomEvent {
  /// 聊天室Id
  final String roomId;

  NIMChatroomEvent(this.roomId);
}

class NIMChatroomErrors {
  /// 成功
  static const success = 200;

  /// 参数错误
  static const paramsError = 414;

  /// 聊天室不存在
  static const roomNotExists = 404;

  /// 无权限
  static const forbidden = 403;

  /// 服务器内部错误
  static const serverError = 500;

  /// IM主连接状态异常
  static const connectError = 13001;

  /// 聊天室状态异常
  static const illegalState = 13002;

  /// 黑名单用户禁止进入聊天室
  static const blacklisted = 13003;
}

/// 聊天室状态变更事件
@JsonSerializable()
class NIMChatroomStatusEvent extends NIMChatroomEvent {
  /// 当前状态
  final NIMChatroomStatus status;

  /// 错误码
  ///
  /// [NIMChatroomErrors]
  final int? code;

  NIMChatroomStatusEvent(String roomId, this.status, this.code) : super(roomId);

  factory NIMChatroomStatusEvent.fromMap(Map<String, dynamic> map) =>
      _$NIMChatroomStatusEventFromJson(map);

  Map<String, dynamic> toMap() => _$NIMChatroomStatusEventToJson(this);

  @override
  String toString() {
    return 'NIMChatroomStatusEvent{status: $status, code: $code}';
  }
}

/// 从聊天室断开原因
enum NIMChatroomKickOutReason {
  /// 未知
  unknown,

  /// 聊天室已经被解散
  dismissed,

  /// 被管理员踢出
  byManager,

  /// 被其他端踢出
  byConflictLogin,

  /// 被拉黑
  blacklisted,
}

/// 当用户被踢出聊天室或者聊天室关闭时，会触发被踢事件
@JsonSerializable()
class NIMChatroomKickOutEvent extends NIMChatroomEvent {
  /// 原因
  final NIMChatroomKickOutReason reason;

  /// 扩展字段
  @JsonKey(fromJson: castPlatformMapToDartMap)
  final Map<String, dynamic>? extension;

  NIMChatroomKickOutEvent(String roomId, this.reason, this.extension)
      : super(roomId);

  factory NIMChatroomKickOutEvent.fromMap(Map<String, dynamic> map) =>
      _$NIMChatroomKickOutEventFromJson(map);

  Map<String, dynamic> toMap() => _$NIMChatroomKickOutEventToJson(this);

  @override
  String toString() {
    return 'NIMChatroomKickOutEvent{reason: $reason, extension: $extension}';
  }
}

/// 聊天室通知类型
class NIMChatroomNotificationTypes {
  /// 成员进入聊天室
  static const int chatRoomMemberIn = 301;

  /// 成员离开聊天室
  static const int chatRoomMemberExit = 302;

  /// 成员被加黑
  static const int chatRoomMemberBlackAdd = 303;

  /// 成员被取消黑名单
  static const int chatRoomMemberBlackRemove = 304;

  /// 成员被设置禁言
  static const int chatRoomMemberMuteAdd = 305;

  /// 成员被取消禁言
  static const int chatRoomMemberMuteRemove = 306;

  /// 设置为管理员
  static const int chatRoomManagerAdd = 307;

  /// ChatRoom：取消管理员
  static const int chatRoomManagerRemove = 308;

  /// 成员设定为固定成员
  static const int chatRoomCommonAdd = 309;

  /// 成员取消固定成员
  static const int chatRoomCommonRemove = 310;

  /// 聊天室被关闭了
  static const int chatRoomClose = 311;

  /// 聊天室信息被更新了
  static const int chatRoomInfoUpdated = 312;

  /// 成员被踢了
  static const int chatRoomMemberKicked = 313;

  /// 新增临时禁言
  static const int chatRoomMemberTempMuteAdd = 314;

  /// 主动解除临时禁言
  static const int chatRoomMemberTempMuteRemove = 315;

  /// 成员主动更新了聊天室内的角色信息(仅指nick/avator/ext)
  static const int chatRoomMyRoomRoleUpdated = 316;

  /// 队列中有变更
  static const int chatRoomQueueChange = 317;

  /// 聊天室被禁言了,只有管理员可以发言,其他人都处于禁言状态
  static const int chatRoomRoomMuted = 318;

  /// 聊天室解除全体禁言状态
  static const int chatRoomRoomDeMuted = 319;

  /// 队列批量变更
  static const int chatRoomQueueBatchChange = 320;

  static String typeToString(int type) {
    switch (type) {
      case chatRoomMemberIn:
        return 'chatRoomMemberIn';
      case chatRoomMemberExit:
        return 'chatRoomMemberExit';
      case chatRoomMemberBlackAdd:
        return 'chatRoomMemberBlackAdd';
      case chatRoomMemberBlackRemove:
        return 'chatRoomMemberBlackRemove';
      case chatRoomMemberMuteAdd:
        return 'chatRoomMemberMuteAdd';
      case chatRoomMemberMuteRemove:
        return 'chatRoomMemberMuteRemove';
      case chatRoomManagerAdd:
        return 'chatRoomManagerAdd';
      case chatRoomManagerRemove:
        return 'chatRoomManagerRemove';
      case chatRoomCommonAdd:
        return 'chatRoomCommonAdd';
      case chatRoomCommonRemove:
        return 'chatRoomCommonRemove';
      case chatRoomClose:
        return 'chatRoomClose';
      case chatRoomInfoUpdated:
        return 'chatRoomInfoUpdated';
      case chatRoomMemberKicked:
        return 'chatRoomMemberKicked';
      case chatRoomMemberTempMuteAdd:
        return 'chatRoomMemberTempMuteAdd';
      case chatRoomMemberTempMuteRemove:
        return 'chatRoomMemberTempMuteRemove';
      case chatRoomMyRoomRoleUpdated:
        return 'chatRoomMyRoomRoleUpdated';
      case chatRoomQueueChange:
        return 'chatRoomQueueChange';
      case chatRoomRoomMuted:
        return 'chatRoomRoomMuted';
      case chatRoomRoomDeMuted:
        return 'chatRoomRoomDeMuted';
      case chatRoomQueueBatchChange:
        return 'chatRoomQueueBatchChange';
      default:
        return 'unknown';
    }
  }
}

/// 聊天室通知消息附件
@JsonSerializable()
class NIMChatroomNotificationAttachment extends NIMMessageAttachment {
  /// 通知类型，参考 [NIMChatroomNotificationTypes]
  final int type;

  /// 被操作的成员
  final List<String>? targets;

  /// 被操作的成员昵称列表
  final List<String>? targetNicks;

  /// 操作者
  final String? operator;

  /// 操作者昵称
  final String? operatorNick;

  /// 扩展字段
  @JsonKey(fromJson: castPlatformMapToDartMap)
  final Map<String, dynamic>? extension;

  factory NIMChatroomNotificationAttachment.createChatroomNotificationAttachment(
      Map<String, dynamic> map) {
    final int type = map['type'] as int;
    switch (type) {
      case NIMChatroomNotificationTypes.chatRoomMemberIn:
        return NIMChatroomMemberInAttachment.fromMap(map);
      case NIMChatroomNotificationTypes.chatRoomMemberTempMuteAdd:
      case NIMChatroomNotificationTypes.chatRoomMemberTempMuteRemove:
        return NIMChatroomTempMuteAttachment.fromMap(map);
      case NIMChatroomNotificationTypes.chatRoomQueueBatchChange:
      case NIMChatroomNotificationTypes.chatRoomQueueChange:
        return NIMChatroomQueueChangeAttachment.fromMap(map);
      default:
        return NIMChatroomNotificationAttachment.fromMap(map);
    }
  }

  factory NIMChatroomNotificationAttachment.fromMap(Map<String, dynamic> map) =>
      _$NIMChatroomNotificationAttachmentFromJson(map);

  NIMChatroomNotificationAttachment({
    required this.type,
    this.targets,
    this.targetNicks,
    this.operator,
    this.operatorNick,
    this.extension,
  });

  @override
  Map<String, dynamic> toMap() =>
      _$NIMChatroomNotificationAttachmentToJson(this);
}

/// 聊天室成员加入通知消息附件
@JsonSerializable()
class NIMChatroomMemberInAttachment extends NIMChatroomNotificationAttachment {
  /// 是否是禁言状态
  @JsonKey(defaultValue: false)
  final bool muted;

  /// 是否临时禁言状态
  @JsonKey(defaultValue: false)
  final bool tempMuted;

  /// 临时禁言时长
  @JsonKey(defaultValue: 0)
  final int tempMutedDuration;

  factory NIMChatroomMemberInAttachment.fromMap(Map<String, dynamic> map) =>
      _$NIMChatroomMemberInAttachmentFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$NIMChatroomMemberInAttachmentToJson(this);

  NIMChatroomMemberInAttachment({
    this.muted = false,
    this.tempMuted = false,
    this.tempMutedDuration = 0,
    List<String>? targets,
    List<String>? targetNicks,
    String? operator,
    String? operatorNick,
    Map<String, dynamic>? extension,
  }) : super(
          type: NIMChatroomNotificationTypes.chatRoomMemberIn,
          targets: targets,
          targetNicks: targetNicks,
          operator: operator,
          operatorNick: operatorNick,
          extension: extension,
        );
}

/// 聊天室新增临时禁言通知消息附件
@JsonSerializable()
class NIMChatroomTempMuteAttachment extends NIMChatroomNotificationAttachment {
  /// 临时禁言时长
  final int duration;

  factory NIMChatroomTempMuteAttachment.fromMap(Map<String, dynamic> map) =>
      _$NIMChatroomTempMuteAttachmentFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$NIMChatroomTempMuteAttachmentToJson(this);

  bool get isAdd =>
      type == NIMChatroomNotificationTypes.chatRoomMemberTempMuteAdd;

  bool get isRemove =>
      type == NIMChatroomNotificationTypes.chatRoomMemberTempMuteRemove;

  NIMChatroomTempMuteAttachment({
    required int type,
    this.duration = 0,
    List<String>? targets,
    List<String>? targetNicks,
    String? operator,
    String? operatorNick,
    Map<String, dynamic>? extension,
  }) : super(
          type: type,
          targets: targets,
          targetNicks: targetNicks,
          operator: operator,
          operatorNick: operatorNick,
          extension: extension,
        );
}

@JsonSerializable()
class NIMChatroomQueueChangeAttachment
    extends NIMChatroomNotificationAttachment {
  @JsonKey(fromJson: castMapToTypeOfStringString)
  final Map<String, String>? contentMap;

  final NIMChatroomQueueChangeType queueChangeType;

  final String? key;

  final String? content;

  NIMChatroomQueueChangeAttachment({
    required int type,
    required this.queueChangeType,
    this.content,
    this.key,
    this.contentMap,
    List<String>? targets,
    List<String>? targetNicks,
    String? operator,
    String? operatorNick,
    Map<String, dynamic>? extension,
  }) : super(
          type: type,
          targets: targets,
          targetNicks: targetNicks,
          operator: operator,
          operatorNick: operatorNick,
          extension: extension,
        );

  factory NIMChatroomQueueChangeAttachment.fromMap(Map<String, dynamic> map) =>
      _$NIMChatroomQueueChangeAttachmentFromJson(map);

  @override
  Map<String, dynamic> toMap() =>
      _$NIMChatroomQueueChangeAttachmentToJson(this);
}

enum NIMChatroomQueueChangeType {
  undefined,

  /// 新增队列元素
  offer,

  /// 移除队列元素
  poll,

  /// 清空所有队列元素
  drop,

  /// 部分清理操作(发生在提交元素的用户掉线时，清理这个用户对应的key)
  partialClear,

  /// 批量更新队列元素
  batchUpdate,
}

/// 聊天室信息修改请求
@JsonSerializable()
class NIMChatroomUpdateRequest {
  /// 聊天室名称
  final String? name;

  /// 聊天室公告
  final String? announcement;

  /// 视频直播拉流地址
  final String? broadcastUrl;

  /// 第三方扩展字段, 长度4k
  @JsonKey(fromJson: castPlatformMapToDartMap)
  final Map<String, dynamic>? extension;

  /// 队列管理权限，如是否有权限提交他人key和信息到队列中
  final NIMChatroomQueueModificationLevel? queueModificationLevel;

  NIMChatroomUpdateRequest({
    this.name,
    this.announcement,
    this.broadcastUrl,
    this.extension,
    this.queueModificationLevel,
  });

  Map<String, dynamic> toMap() => _$NIMChatroomUpdateRequestToJson(this);

  factory NIMChatroomUpdateRequest.fromMap(Map<String, dynamic> map) =>
      _$NIMChatroomUpdateRequestFromJson(map);
}

/// 成员查询类型
enum NIMChatroomMemberQueryType {
  /// 固定成员（包括创建者,管理员,普通等级用户,受限用户(禁言+黑名单),即使非在线也可以在列表中看到,有数量限制 ）
  allNormalMember,

  /// 仅在线的固定成员
  onlineNormalMember,

  /// 非固定成员 (又称临时成员,只有在线时才能在列表中看到,数量无上限)
  /// 按照进入聊天室时间倒序排序，进入时间越晚的越靠前
  onlineGuestMemberByEnterTimeDesc,

  /// 非固定成员 (又称临时成员,只有在线时才能在列表中看到,数量无上限)
  /// 按照进入聊天室时间顺序排序，进入时间越早的越靠前
  onlineGuestMemberByEnterTimeAsc,
}

/// 修改自身成员信息请求
@JsonSerializable()
class NIMChatroomUpdateMyMemberInfoRequest {
  /// 聊天室内的昵称字段
  final String? nickname;

  /// 聊天室内的头像
  final String? avatar;

  /// 开发者扩展字段
  @JsonKey(fromJson: castPlatformMapToDartMap)
  final Map<String, dynamic>? extension;

  /// 更新的信息是否需要做持久化，只对固定成员生效
  final bool needSave;

  NIMChatroomUpdateMyMemberInfoRequest({
    this.nickname,
    this.avatar,
    this.extension,
    this.needSave = false,
  });

  factory NIMChatroomUpdateMyMemberInfoRequest.fromMap(
          Map<String, dynamic> map) =>
      _$NIMChatroomUpdateMyMemberInfoRequestFromJson(map);

  Map<String, dynamic> toMap() =>
      _$NIMChatroomUpdateMyMemberInfoRequestToJson(this);
}

///
@JsonSerializable()
class NIMChatroomMemberOptions {
  /// 聊天室id
  final String roomId;

  /// 成员帐号
  final String account;

  /// 操作产生的通知事件中开发者自定义的扩展字段（可选）
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? notifyExtension;

  NIMChatroomMemberOptions({
    required this.roomId,
    required this.account,
    this.notifyExtension,
  });

  factory NIMChatroomMemberOptions.fromMap(Map<String, dynamic> json) =>
      _$NIMChatroomMemberOptionsFromJson(json);

  Map<String, dynamic> toMap() => _$NIMChatroomMemberOptionsToJson(this);
}

/// 聊天室队列元素
class NIMChatroomQueueEntry {
  /// 元素key
  final String key;

  /// 元素value
  final String? value;

  NIMChatroomQueueEntry({
    required this.key,
    required this.value,
  });

  factory NIMChatroomQueueEntry.fromMap(Map<String, dynamic> map) {
    return NIMChatroomQueueEntry(
      key: map['key'] as String,
      value: map['value'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'key': key,
        'value': value,
      };
}
