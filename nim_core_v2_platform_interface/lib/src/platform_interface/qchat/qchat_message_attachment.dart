// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:nim_core_v2_platform_interface/src/platform_interface/qchat/qchat_team.dart';

part 'qchat_message_attachment.g.dart';

abstract class QChatNIMMessageAttachment {
  static Map<String, dynamic> _toMap(QChatNIMMessageAttachment? attachment) {
    if (attachment != null) {
      return attachment.toMap();
    } else {
      return {};
    }
  }

  static QChatNIMMessageAttachment? _fromMap(Map<Object?, Object?>? json) {
    if (json == null || json['messageType'] == null) return null;
    var map = Map<String, dynamic>.from(json);
    var messageType = NIMMessageTypeConverter()
        .fromValue(map['messageType'], defaultType: NIMMessageType.invalid);
    switch (messageType) {
      case NIMMessageType.audio:
        return NIMAudioAttachment.fromMap(map);
      case NIMMessageType.video:
        return NIMVideoAttachment.fromMap(map);
      case NIMMessageType.file:
        return NIMFileAttachment.fromMap(map);
      case NIMMessageType.image:
        return NIMImageAttachment.fromMap(map);
      case NIMMessageType.location:
        return NIMLocationAttachment.fromMap(map);
      case NIMMessageType.custom:
        return NIMCustomMessageAttachment(data: map);
      case NIMMessageType.notification:
        final type = map['type'] as int?;
        if (type == null) return null;
        if (type >= NIMChatroomNotificationTypes.chatRoomMemberIn &&
            type <= NIMChatroomNotificationTypes.chatRoomQueueBatchChange) {
          return NIMChatroomNotificationAttachment
              .createChatroomNotificationAttachment(map);
        } else if (type >= NIMTeamNotificationTypes.inviteMember &&
            type <= NIMTeamNotificationTypes.muteTeamMember) {
          return NIMTeamNotificationAttachment.createTeamNotificationAttachment(
              map);
        } else if (type >= NIMSuperTeamNotificationTypes.invite &&
            type <= NIMSuperTeamNotificationTypes.inviteAccept) {
          return NIMTeamNotificationAttachment.createTeamNotificationAttachment(
              map);
        }
        return null;
      default:
        return null;
    }
  }

  static Map<String, dynamic> toJson(QChatNIMMessageAttachment? attachment) {
    return _toMap(attachment);
  }

  static QChatNIMMessageAttachment? fromJson(Map<Object?, Object?>? json) {
    return _fromMap(json);
  }

  Map<String, dynamic> toMap();
}

/// 自定义消息附件
class NIMCustomMessageAttachment extends QChatNIMMessageAttachment {
  /// 数据
  final Map<String, dynamic>? data;

  NIMCustomMessageAttachment({this.data});

  factory NIMCustomMessageAttachment.fromMap(Map<String, dynamic> map) =>
      NIMCustomMessageAttachment(data: map);

  @override
  Map<String, dynamic> toMap() {
    return (data ?? {})
      ..['messageType'] =
          NIMMessageTypeConverter(messageType: NIMMessageType.custom).toValue();
  }
}

/// 文件消息附件
@JsonSerializable()
class NIMFileAttachment extends QChatNIMMessageAttachment {
  /// 文件路径
  @JsonKey(name: 'path', includeIfNull: false)
  final String? path;

  /// 文件下载地址
  @JsonKey(name: 'url', includeIfNull: false)
  final String? url;

  /// web 发送专用
  @JsonKey(name: 'base64', includeIfNull: false)
  final String? base64;

  /// 文件大小
  @JsonKey(name: 'size')
  final int? size;

  ///文件内容的MD5
  @JsonKey(name: 'md5', includeIfNull: false)
  final String? md5;

  /// 文件显示名
  @JsonKey(name: 'name')
  final String? displayName;

  /// 文件后缀名
  @JsonKey(name: 'ext')
  final String? extension;

  /// 过期时间
  @JsonKey(name: 'expire')
  final int? expire;

  /// 上传文件时用的对token对应的场景，默认 [NIMNosScenes.defaultIm]
  @JsonKey(
    name: 'sen',
    defaultValue: NIMNosScenes.defaultIm,
  )
  final NIMNosScene nosScene;

  /// 如果服务器存在相同的附件文件，是否强制重新上传 ， 默认false
  @JsonKey(name: 'force_upload')
  bool forceUpload;

  NIMFileAttachment(
      {this.path,
      required this.size,
      this.md5,
      this.url,
      this.base64,
      this.displayName,
      this.extension,
      this.expire,
      this.nosScene = NIMNosScenes.defaultIm,
      this.forceUpload = false});

  factory NIMFileAttachment.fromMap(Map<String, dynamic> map) =>
      _$NIMFileAttachmentFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$NIMFileAttachmentToJson(this)
    ..['messageType'] =
        NIMMessageTypeConverter(messageType: NIMMessageType.file).toValue();
}

/// 音频消息附件
@JsonSerializable()
class NIMAudioAttachment extends NIMFileAttachment {
  /// 语音时长，毫秒为单位
  @JsonKey(name: 'dur')
  final int? duration;

  /// 是否自动转换为文本消息发送
  final bool? autoTransform;

  /// 文本内容
  final String? text;

  NIMAudioAttachment(
      {this.duration,
      this.autoTransform,
      this.text,
      String? path,
      required int? size,
      String? md5,
      String? url,
      String? base64,
      String? displayName,
      String? extension,
      int? expire,
      NIMNosScene nosScene = NIMNosScenes.defaultIm,
      bool forceUpload = false})
      : super(
            path: path,
            size: size,
            md5: md5,
            url: url,
            base64: base64,
            displayName: displayName,
            extension: extension,
            expire: expire,
            nosScene: nosScene,
            forceUpload: forceUpload); // NIMAudioAttachment(

  factory NIMAudioAttachment.fromMap(Map<String, dynamic> map) =>
      _$NIMAudioAttachmentFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$NIMAudioAttachmentToJson(this)
    ..['messageType'] =
        NIMMessageTypeConverter(messageType: NIMMessageType.audio).toValue();
}

/// 音频消息附件
@JsonSerializable()
class NIMVideoAttachment extends NIMFileAttachment {
  /// 语音时长，毫秒为单位
  @JsonKey(name: 'dur')
  final int? duration;

  /// 视频宽度
  @JsonKey(name: 'w')
  final int? width;

  /// 视频高度
  @JsonKey(name: 'h')
  final int? height;

  /// 缩略本地路径
  final String? thumbPath;

  /// 缩略远程路径
  final String? thumbUrl;

  NIMVideoAttachment(
      {this.duration,
      this.width,
      this.height,
      this.thumbPath,
      this.thumbUrl,
      String? path,
      required int? size,
      String? md5,
      String? url,
      String? base64,
      String? displayName,
      String? extension,
      int? expire,
      NIMNosScene nosScene = NIMNosScenes.defaultIm,
      bool forceUpload = false})
      : super(
            path: path,
            size: size,
            md5: md5,
            url: url,
            base64: base64,
            displayName: displayName,
            extension: extension,
            expire: expire,
            nosScene: nosScene,
            forceUpload: forceUpload);

  factory NIMVideoAttachment.fromMap(Map<String, dynamic> map) =>
      _$NIMVideoAttachmentFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$NIMVideoAttachmentToJson(this)
    ..['messageType'] =
        NIMMessageTypeConverter(messageType: NIMMessageType.video).toValue();
}

/// 图片消息附件
@JsonSerializable()
class NIMImageAttachment extends NIMFileAttachment {
  /// 缩略本地路径
  @JsonKey(includeIfNull: false)
  final String? thumbPath;

  /// 缩略远程路径
  @JsonKey(includeIfNull: false)
  final String? thumbUrl;

  /// 图片宽度
  @JsonKey(name: 'w')
  final int? width;

  /// 图片高度
  @JsonKey(name: 'h')
  final int? height;

  NIMImageAttachment(
      {this.thumbPath,
      this.thumbUrl,
      this.width,
      this.height,
      String? path,
      String? base64,
      required int? size,
      String? md5,
      String? url,
      String? displayName,
      String? extension,
      int? expire,
      NIMNosScene nosScene = NIMNosScenes.defaultIm,
      bool forceUpload = false})
      : super(
            path: path,
            size: size,
            md5: md5,
            url: url,
            base64: base64,
            displayName: displayName,
            extension: extension,
            expire: expire,
            nosScene: nosScene,
            forceUpload: forceUpload);

  factory NIMImageAttachment.fromMap(Map<String, dynamic> map) =>
      _$NIMImageAttachmentFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$NIMImageAttachmentToJson(this)
    ..['messageType'] =
        NIMMessageTypeConverter(messageType: NIMMessageType.image).toValue();
}

/// 图片消息附件
@JsonSerializable()
class NIMLocationAttachment extends QChatNIMMessageAttachment {
  /// 纬度
  @JsonKey(name: 'lat')
  double latitude;

  /// 经度
  @JsonKey(name: 'lng')
  double longitude;

  /// 地理位置描述
  @JsonKey(name: 'title')
  String address;

  NIMLocationAttachment(
      {required this.latitude, required this.longitude, required this.address});

  factory NIMLocationAttachment.fromMap(Map<String, dynamic> map) =>
      _$NIMLocationAttachmentFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$NIMLocationAttachmentToJson(this)
    ..['messageType'] =
        NIMMessageTypeConverter(messageType: NIMMessageType.location).toValue();
}

/// 聊天室通知消息附件
@JsonSerializable()
class NIMChatroomNotificationAttachment extends QChatNIMMessageAttachment {
  /// 通知类型，参考 [NIMChatroomNotificationTypes]
  final int type;

  /// 获取该操作的承受者的账号列表
  final List<String>? targets;

  /// 获取该操作的承受者的昵称列表
  final List<String>? targetNicks;

  /// 获取该操作的发起者的账号
  final String? operator;

  /// 获取该操作的发起者的昵称
  final String? operatorNick;

  /// 获取聊天室通知扩展字段
  /// 该字段对应 [NIMChatroomEnterRequest.notifyExtension]
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

/// 聊天室通知类型
class NIMChatroomNotificationTypes {
  /// 成员进入聊天室
  ///
  /// [NIMChatroomMemberInAttachment]
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
  ///
  /// [NIMChatroomTempMuteAttachment]
  static const int chatRoomMemberTempMuteAdd = 314;

  /// 主动解除临时禁言
  ///
  /// [NIMChatroomTempMuteAttachment]
  static const int chatRoomMemberTempMuteRemove = 315;

  /// 成员主动更新了聊天室内的角色信息(仅指nick/avator/ext)
  static const int chatRoomMyRoomRoleUpdated = 316;

  /// 队列中有变更
  ///
  /// [NIMChatroomQueueChangeAttachment]
  static const int chatRoomQueueChange = 317;

  /// 聊天室被禁言了,只有管理员可以发言,其他人都处于禁言状态
  static const int chatRoomRoomMuted = 318;

  /// 聊天室解除全体禁言状态
  static const int chatRoomRoomDeMuted = 319;

  /// 队列批量变更
  ///
  /// [NIMChatroomQueueChangeAttachment]
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

/// 聊天室成员加入通知消息附件
@JsonSerializable()
class NIMChatroomMemberInAttachment extends NIMChatroomNotificationAttachment {
  /// 是否是禁言状态
  @JsonKey(defaultValue: false)
  final bool muted;

  /// 是否临时禁言状态
  @JsonKey(defaultValue: false)
  final bool tempMuted;

  /// 临时禁言时长，单位为秒
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
  /// 临时禁言时长，单位为秒
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

  /// 当用户掉线或退出聊天室时，返回用户使用 updateQueueEx 接口，并设置 isTransient 参数为true 时，加入或更新的元素
  final Map<String, String>? contentMap;

  /// 队列变更类型
  /// [NIMChatroomQueueChangeType]
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
