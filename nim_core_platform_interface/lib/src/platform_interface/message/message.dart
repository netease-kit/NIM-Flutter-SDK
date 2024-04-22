// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

part 'message.g.dart';

typedef MessageAction = Future Function(NIMMessage message);
typedef ChatroomMessageAction = Future Function(NIMChatroomMessage message);

/// 消息
@JsonSerializable()
class NIMMessage {
  /// 消息ID,唯一标识
  @JsonKey(defaultValue: '-1')
  final String? messageId;

  /// 会话ID,如果当前session为team,则sessionId为teamId,如果是P2P则为对方帐号
  final String? sessionId;

  /// 会话类型,当前仅支持P2P,Team和Chatroom
  @JsonKey(unknownEnumValue: NIMSessionType.p2p)
  final NIMSessionType? sessionType;

  /// 消息类型
  @JsonKey(
      unknownEnumValue: NIMMessageType.undef,
      defaultValue: NIMMessageType.undef)
  final NIMMessageType messageType;

  /// 消息子类型,小于等于0表示没有子类型
  int? messageSubType;

  /// 消息状态
  @JsonKey(unknownEnumValue: NIMMessageStatus.sending)
  NIMMessageStatus? status;

  /// 发送消息或者接收到消息
  @JsonKey(unknownEnumValue: NIMMessageDirection.outgoing)
  NIMMessageDirection messageDirection;

  /// 消息发送方帐号
  String? fromAccount;

  /// 消息文本
  /// 消息中除 [IMMessageType.text] 和 [IMMessageType.tip]  外，其他消息 [text] 字段都为 null
  String? content;

  /// 消息发送时间
  /// 本地存储消息可以通过修改时间戳来调整其在会话列表中的位置，发完服务器的消息时间戳将被服务器自动修正
  final int timestamp;

  /// 消息附件内容
  @JsonKey(
      fromJson: NIMMessageAttachment._fromMap,
      toJson: NIMMessageAttachment._toMap)
  NIMMessageAttachment? messageAttachment;

  /// 消息附件下载状态 仅针对收到的消息
  @JsonKey(unknownEnumValue: NIMMessageAttachmentStatus.transferred)
  NIMMessageAttachmentStatus? attachmentStatus;

  /// 消息UUID
  final String? uuid;

  /// 消息 ServerID
  final int? serverId;

  /// 消息配置
  @JsonKey(
      fromJson: NIMCustomMessageConfig._fromMap,
      toJson: NIMCustomMessageConfig._toMap)
  NIMCustomMessageConfig? config;

  /// 消息拓展字段
  /// 服务器下发的消息拓展字段，并不在本地做持久化，目前只有聊天室中的消息才有该字段
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? remoteExtension;

  /// 本地扩展字段（仅本地有效）
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? localExtension;

  /// 第三方回调回来的自定义扩展字段
  final String? callbackExtension;

  ///消息推送Payload
  /// @discussion iOS 上支持字段参考苹果技术文档,长度限制 2K,撤回消息时该字段无效
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? pushPayload;

  /// 消息推送文案,长度限制200字节
  String? pushContent;

  /// 指定成员推送选项
  @JsonKey(
      fromJson: NIMMemberPushOption._fromMap,
      toJson: NIMMemberPushOption._toMap)
  NIMMemberPushOption? memberPushOption;

  /// 发送者客户端类型
  @JsonKey(unknownEnumValue: NIMClientType.unknown)
  final NIMClientType? senderClientType;

  /// 易盾反垃圾配置项
  @JsonKey(
      fromJson: NIMAntiSpamOption._fromMap, toJson: NIMAntiSpamOption._toMap)
  NIMAntiSpamOption? antiSpamOption;

  /// 是否需要消息已读（主要针对群消息）
  @JsonKey(defaultValue: false)
  bool messageAck;

  /// 是否已经发送过群消息已读回执
  @JsonKey(defaultValue: false)
  final bool hasSendAck;

  /// 群消息已读回执的已读数
  @JsonKey(defaultValue: 0)
  final int ackCount;

  /// 群消息已读回执的未读数
  @JsonKey(defaultValue: 0)
  final int unAckCount;

  /// 命中了客户端反垃圾，服务器处理
  @JsonKey(defaultValue: false)
  bool clientAntiSpam;

  /// 发送消息给对方， 是不是被对方拉黑了（消息本身是发送成功的）
  @JsonKey(defaultValue: false)
  final bool isInBlackList;

  ///消息的选中状态
  @JsonKey(defaultValue: false)
  bool isChecked;

  ///消息是否需要刷新到session服务
  ///只有消息存离线的情况下，才会判断该参数，默认：是
  @JsonKey(defaultValue: true)
  bool sessionUpdate;

  ///消息的thread信息
  @JsonKey(
      fromJson: NIMMessageThreadOption._fromMap,
      toJson: NIMMessageThreadOption._toMap)
  NIMMessageThreadOption? messageThreadOption;

  ///快捷评论的最后更新时间 (SDK内部使用，不建议用户使用)
  final int? quickCommentUpdateTime;

  /// 消息是否标记为已删除
  /// 已删除的消息在获取本地消息列表时会被过滤掉，只有根据 messageId
  /// 获取消息的接口可能会返回已删除消息。聊天室消息里，此字段无效。
  @JsonKey(defaultValue: false)
  final bool isDeleted;

  ///  易盾反垃圾增强反作弊专属字段
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? yidunAntiCheating;

  ///环境变量
  ///用于指向不同的抄送，第三方回调等配置
  ///注意：数据库不会保存此字段
  String? env;

  /// 消息发送方昵称
  final String? fromNickname;

  /// 判断自己发送的消息对方是否已读
  /// 只有当当前消息为 [NIMSessionType.p2p] 消息且 [NIMMessageDirection.outgoing] 为 `true`
  bool? isRemoteRead;

  /// 易盾反垃圾扩展字段，为 json
  String? yidunAntiSpamExt;

  /// 易盾反垃圾返回的结果
  String? yidunAntiSpamRes;

  /// 机器人消息
  @JsonKey(
      fromJson: NIMMessageRobotInfo._fromMap,
      toJson: NIMMessageRobotInfo._toMap)
  NIMMessageRobotInfo? robotInfo;

  @visibleForTesting
  NIMMessage(
      {this.messageId,
      this.sessionId,
      this.sessionType,
      required this.messageType,
      this.messageSubType,
      this.status,
      required this.messageDirection,
      this.fromAccount,
      this.content,
      required this.timestamp,
      this.messageAttachment,
      this.attachmentStatus,
      this.uuid,
      this.serverId,
      this.config,
      this.remoteExtension,
      this.localExtension,
      this.callbackExtension,
      this.pushPayload,
      this.pushContent,
      this.memberPushOption,
      this.senderClientType,
      this.antiSpamOption,
      this.messageAck = false,
      this.hasSendAck = false,
      this.ackCount = 0,
      this.unAckCount = 0,
      this.clientAntiSpam = false,
      this.isInBlackList = false,
      this.isChecked = false,
      this.sessionUpdate = true,
      this.messageThreadOption,
      this.quickCommentUpdateTime,
      this.isDeleted = false,
      this.yidunAntiCheating,
      this.env,
      this.fromNickname,
      this.isRemoteRead,
      this.yidunAntiSpamExt,
      this.yidunAntiSpamRes,
      this.robotInfo});

  factory NIMMessage.fromMap(Map<String, dynamic> map) =>
      _$NIMMessageFromJson(map);

  Map<String, dynamic> toMap() => _$NIMMessageToJson(this);

  factory NIMMessage.textEmptyMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required String text}) {
    return NIMMessage(
      messageDirection: NIMMessageDirection.outgoing,
      messageType: NIMMessageType.text,
      content: text,
      timestamp: new DateTime.now().millisecondsSinceEpoch,
      status: NIMMessageStatus.sending,
      sessionId: sessionId,
      sessionType: sessionType,
      messageAttachment: null,
      attachmentStatus: NIMMessageAttachmentStatus.transferred,
    );
  }

  //空消息占用callbackExtension 传递 empty 标记提供给iOS端使用
  factory NIMMessage.emptyMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required int timestamp}) {
    return NIMMessage(
        timestamp: timestamp,
        sessionId: sessionId,
        sessionType: sessionType,
        callbackExtension: 'empty',
        messageType: NIMMessageType.undef,
        messageDirection: NIMMessageDirection.outgoing);
  }

  factory NIMMessage.imageEmptyMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required String filePath,
      required int fileSize,
      String? displayName,
      String? base64,
      NIMNosScene nosScene = NIMNosScenes.defaultIm}) {
    var extension = filePath.split('.').last;

    var imageAttachment = NIMImageAttachment(
        path: filePath,
        size: fileSize,
        displayName: displayName,
        base64: base64,
        extension: extension,
        nosScene: nosScene);
    return NIMMessage(
        messageDirection: NIMMessageDirection.outgoing,
        messageType: NIMMessageType.image,
        timestamp: new DateTime.now().millisecondsSinceEpoch,
        status: NIMMessageStatus.sending,
        sessionId: sessionId,
        sessionType: sessionType,
        messageAttachment: imageAttachment);
  }

  factory NIMMessage.audioEmptyMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required String filePath,
      required int fileSize,
      required int duration,
      String? displayName,
      String? base64,
      NIMNosScene nosScene = NIMNosScenes.defaultIm}) {
    /// 最低显示1秒
    if (duration < 1000) duration = 1000;

    var extension = filePath.split('.').last;

    var audioAttachment = NIMAudioAttachment(
        path: filePath,
        size: fileSize,
        duration: duration,
        base64: base64,
        extension: extension,
        nosScene: nosScene);
    return NIMMessage(
        messageDirection: NIMMessageDirection.outgoing,
        messageType: NIMMessageType.audio,
        timestamp: new DateTime.now().millisecondsSinceEpoch,
        status: NIMMessageStatus.sending,
        sessionId: sessionId,
        sessionType: sessionType,
        messageAttachment: audioAttachment);
  }

  factory NIMMessage.locationEmptyMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required double latitude,
      required double longitude,
      required String address}) {
    var locationAttachment = NIMLocationAttachment(
        latitude: latitude, longitude: longitude, address: address);

    return NIMMessage(
        messageDirection: NIMMessageDirection.outgoing,
        messageType: NIMMessageType.location,
        timestamp: new DateTime.now().millisecondsSinceEpoch,
        status: NIMMessageStatus.sending,
        sessionId: sessionId,
        sessionType: sessionType,
        messageAttachment: locationAttachment,
        attachmentStatus: NIMMessageAttachmentStatus.transferred);
  }

  factory NIMMessage.videoEmptyMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required String filePath,
      int? fileSize,
      String? base64,
      required int duration,
      required int width,
      required int height,
      required String displayName,
      NIMNosScene nosScene = NIMNosScenes.defaultIm}) {
    var extension = filePath.split('.').last;

    var videoAttachment = NIMVideoAttachment(
        path: filePath,
        size: fileSize,
        duration: duration,
        width: width,
        height: height,
        base64: base64,
        displayName: displayName,
        extension: extension,
        nosScene: nosScene);

    return NIMMessage(
        messageDirection: NIMMessageDirection.outgoing,
        messageType: NIMMessageType.video,
        timestamp: new DateTime.now().millisecondsSinceEpoch,
        status: NIMMessageStatus.sending,
        sessionId: sessionId,
        sessionType: sessionType,
        messageAttachment: videoAttachment);
  }

  factory NIMMessage.fileEmptyMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required String filePath,
      String? base64,
      int? fileSize,
      required String displayName,
      NIMNosScene nosScene = NIMNosScenes.defaultIm}) {
    var extension = filePath.split('.').last;
    var fileAttachment = NIMFileAttachment(
        path: filePath,
        size: fileSize,
        base64: base64,
        displayName: displayName,
        extension: extension,
        nosScene: nosScene);
    return NIMMessage(
        messageDirection: NIMMessageDirection.outgoing,
        messageType: NIMMessageType.file,
        timestamp: new DateTime.now().millisecondsSinceEpoch,
        status: NIMMessageStatus.sending,
        sessionId: sessionId,
        sessionType: sessionType,
        messageAttachment: fileAttachment);
  }

  factory NIMMessage.tipEmptyMessage(
      {required String sessionId, required NIMSessionType sessionType}) {
    return NIMMessage(
        messageDirection: NIMMessageDirection.outgoing,
        messageType: NIMMessageType.tip,
        timestamp: new DateTime.now().millisecondsSinceEpoch,
        status: NIMMessageStatus.sending,
        sessionId: sessionId,
        sessionType: sessionType);
  }

  /// 创建自定义消息
  factory NIMMessage.customEmptyMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      String? content,
      NIMMessageAttachment? attachment,
      NIMCustomMessageConfig? config}) {
    return NIMMessage(
        messageDirection: NIMMessageDirection.outgoing,
        messageType: NIMMessageType.custom,
        timestamp: new DateTime.now().millisecondsSinceEpoch,
        status: NIMMessageStatus.sending,
        sessionId: sessionId,
        sessionType: sessionType,
        content: content,
        messageAttachment: attachment,
        config: config);
  }
}

/// 消息的配置选项，主要用于设定消息的声明周期，是否需要推送，是否需要计入未读数等。
@JsonSerializable()
class NIMCustomMessageConfig {
  /// 该消息是否要保存到服务器
  final bool enableHistory;

  /// 该消息是否需要漫游
  final bool enableRoaming;

  /// 多端同时登录时，发送一条自定义消息后，是否要同步到其他同时登录的客户端
  final bool enableSelfSync;

  /// 该消息是否需要离线推送和消息提醒，如果为true，那么对方收到消息后，系统通知栏会有提醒
  final bool enablePush;

  /// 该消息是否需要推送昵称（针对iOS客户端有效），如果为true，那么对方收到消息后，iOS端将显示推送昵称
  final bool enablePushNick;

  /// 该消息是否要计入未读数，如果为true，那么对方收到消息后，最近联系人列表中未读数加1
  final bool enableUnreadCount;

  /// 该消息是否支持路由，如果为true，默认按照app的路由开关（如果有配置抄送地址则将抄送该消息），该字段web端不支持
  final bool enableRoute;

  /// 该消息是否要存离线
  final bool enablePersist;

  NIMCustomMessageConfig({
    this.enableHistory = true,
    this.enableRoaming = true,
    this.enableSelfSync = true,
    this.enablePush = true,
    this.enablePushNick = true,
    this.enableUnreadCount = true,
    this.enableRoute = true,
    this.enablePersist = true,
  });

  factory NIMCustomMessageConfig.fromMap(Map<String, dynamic> map) =>
      _$NIMCustomMessageConfigFromJson(map);

  Map<String, dynamic> toMap() => _$NIMCustomMessageConfigToJson(this);

  static Map<String, dynamic>? _toMap(NIMCustomMessageConfig? config) =>
      config?.toMap();

  static NIMCustomMessageConfig? _fromMap(Map<Object?, Object?>? map) =>
      map == null
          ? null
          : NIMCustomMessageConfig.fromMap(Map<String, dynamic>.from(map));
}

abstract class NIMMessageAttachment {
  static Map<String, dynamic> _toMap(NIMMessageAttachment? attachment) {
    if (attachment != null) {
      return attachment.toMap();
    } else {
      return {};
    }
  }

  static NIMMessageAttachment? _fromMap(Map<Object?, Object?>? json) {
    if (json == null || json['messageType'] == null) return null;
    var map = Map<String, dynamic>.from(json);
    var messageType = NIMMessageTypeConverter()
        .fromValue(map['messageType'], defaultType: NIMMessageType.undef);
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

  static Map<String, dynamic> toJson(NIMMessageAttachment? attachment) {
    return _toMap(attachment);
  }

  static NIMMessageAttachment? fromJson(Map<Object?, Object?>? json) {
    return _fromMap(json);
  }

  Map<String, dynamic> toMap();
}

/// 自定义消息附件
class NIMCustomMessageAttachment extends NIMMessageAttachment {
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
class NIMFileAttachment extends NIMMessageAttachment {
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
class NIMLocationAttachment extends NIMMessageAttachment {
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

/// 消息已读回执
@JsonSerializable()
class NIMMessageReceipt {
  /// 会话ID（聊天对方账号）
  final String sessionId;

  /// 该会话最后一条已读消息的时间，比该时间早的消息都视为已读
  final int time;

  NIMMessageReceipt({required this.sessionId, required this.time});

  factory NIMMessageReceipt.fromMap(Map<String, dynamic> map) =>
      _$NIMMessageReceiptFromJson(map);

  Map<String, dynamic> toMap() => _$NIMMessageReceiptToJson(this);
}

/// 群消息已读回执
@JsonSerializable()
class NIMTeamMessageReceipt {
  final String messageId;
  final int? ackCount;
  final int? unAckCount;

  /// 新已读用户的账号
  final String? newReaderAccount;

  NIMTeamMessageReceipt(
      {required this.messageId,
      this.ackCount,
      this.unAckCount,
      this.newReaderAccount});

  factory NIMTeamMessageReceipt.fromMap(Map<String, dynamic> map) =>
      _$NIMTeamMessageReceiptFromJson(map);

  Map<String, dynamic> toMap() => _$NIMTeamMessageReceiptToJson(this);
}

/// 附件上传/下载进度
@JsonSerializable()
class NIMAttachmentProgress {
  /// 消息uuid
  final String id;

  /// 进度
  final double? progress;

  NIMAttachmentProgress({required this.id, this.progress});

  factory NIMAttachmentProgress.fromMap(Map<String, dynamic> map) =>
      _$NIMAttachmentProgressFromJson(map);

  Map<String, dynamic> toMap() => _$NIMAttachmentProgressToJson(this);
}

_nimMessageToMap(NIMMessage? message) => message?.toMap();

_nimMessageFromMap(Map? map) =>
    map != null ? NIMMessage.fromMap(map.cast<String, dynamic>()) : null;

/// 消息撤回内容
@JsonSerializable()
class NIMRevokeMessage {
  @JsonKey(toJson: _nimMessageToMap, fromJson: _nimMessageFromMap)
  final NIMMessage? message;
  final String? attach;
  final String? revokeAccount;
  final String? customInfo;
  final int? notificationType;
  @JsonKey(unknownEnumValue: RevokeMessageType.undefined)
  final RevokeMessageType? revokeType;
  final String? callbackExt;

  NIMRevokeMessage(
      {this.message,
      this.attach,
      this.revokeAccount,
      this.customInfo,
      this.notificationType,
      this.revokeType,
      this.callbackExt});

  factory NIMRevokeMessage.fromMap(Map<String, dynamic> map) =>
      _$NIMRevokeMessageFromJson(map);

  Map<String, dynamic> toMap() => _$NIMRevokeMessageToJson(this);
}

/// 广播消息
@JsonSerializable()
class NIMBroadcastMessage {
  /// 广播id
  final int? id;
  final String? fromAccount;
  final int? time;
  final String? content;

  NIMBroadcastMessage(
      {required this.id, this.fromAccount, this.time, this.content});

  factory NIMBroadcastMessage.fromMap(Map<String, dynamic> map) =>
      _$NIMBroadcastMessageFromJson(map);

  Map<String, dynamic> toMap() => _$NIMBroadcastMessageToJson(this);
}

/// 云信反垃圾配置
@JsonSerializable()
class NIMAntiSpamOption {
  /// 是否过易盾反垃圾，对于已开通易盾的用户有效，默认为true
  /// 如果应用已经开了易盾，默认消息都会走易盾，如果对单条消息设置 enable 为false，则此消息不会走易盾反垃圾，而是走通用反垃圾
  @JsonKey(defaultValue: false)
  bool enable = true;

  /// 开发者自定义的反垃圾字段，content 必须是 json 格式，仅适用于自定义消息类型
  String? content;

  /// 易盾反垃圾配置id，指定此消息选择过哪一个反垃圾配置
  String? antiSpamConfigId;

  NIMAntiSpamOption(
      {this.enable = true, required this.content, this.antiSpamConfigId});

  factory NIMAntiSpamOption.fromMap(Map<String, dynamic> map) =>
      _$NIMAntiSpamOptionFromJson(map);

  Map<String, dynamic> toMap() => _$NIMAntiSpamOptionToJson(this);

  static Map<String, dynamic>? _toMap(NIMAntiSpamOption? option) =>
      option?.toMap();

  static NIMAntiSpamOption? _fromMap(Map<Object?, Object?>? map) => map == null
      ? null
      : NIMAntiSpamOption.fromMap(Map<String, dynamic>.from(map));
}

/// 指定成员推送相关可选项
///  * 配置后发送消息，如果遇到414，说明客户端提交参数[forcePushList]格式有误；811说明是强推列表中帐号数量超限，目前上限是100个帐号。
@JsonSerializable()
class NIMMemberPushOption {
  /// 强制推送的账号列表
  List<String>? forcePushList;

  /// 强制推送的文案
  String? forcePushContent;

  /// 是否强制推送
  @JsonKey(defaultValue: true)
  bool isForcePush;

  NIMMemberPushOption(
      {this.forcePushContent, this.forcePushList, this.isForcePush = true});

  factory NIMMemberPushOption.fromMap(Map<String, dynamic> map) =>
      _$NIMMemberPushOptionFromJson(map);

  Map<String, dynamic> toMap() => _$NIMMemberPushOptionToJson(this);

  static Map<String, dynamic>? _toMap(NIMMemberPushOption? option) =>
      option?.toMap();

  static NIMMemberPushOption? _fromMap(Map<Object?, Object?>? map) =>
      map == null
          ? null
          : NIMMemberPushOption.fromMap(Map<String, dynamic>.from(map));
}

@JsonSerializable()
class NIMMessageThreadOption {
  ///被回复消息的消息发送者
  String replyMessageFromAccount;

  ///被回复消息的消息接受者，群的话是tid
  String replyMessageToAccount;

  /// 被回复消息的消息发送时间
  int? replyMessageTime;

  /// 被回复消息的消息ServerID
  int? replyMessageIdServer;

  /// 被回复消息的UUID
  String replyMessageIdClient;

  /// thread消息的消息发送者
  String threadMessageFromAccount;

  /// thread消息的消息接受者，群的话是tid
  String threadMessageToAccount;

  /// thread消息的消息发送时间
  int? threadMessageTime;

  /// thread消息的消息ServerID
  int? threadMessageIdServer;

  /// thread消息的UUID
  String threadMessageIdClient;

  NIMMessageThreadOption({
    this.replyMessageFromAccount = '',
    this.replyMessageIdClient = '',
    this.replyMessageIdServer,
    this.replyMessageTime,
    this.replyMessageToAccount = '',
    this.threadMessageFromAccount = '',
    this.threadMessageIdClient = '',
    this.threadMessageIdServer,
    this.threadMessageTime,
    this.threadMessageToAccount = '',
  });

  factory NIMMessageThreadOption.fromMap(Map<String, dynamic> map) =>
      _$NIMMessageThreadOptionFromJson(map);

  Map<String, dynamic> toMap() => _$NIMMessageThreadOptionToJson(this);

  static Map<String, dynamic>? _toMap(NIMMessageThreadOption? option) =>
      option?.toMap();

  static NIMMessageThreadOption? _fromMap(Map<Object?, Object?>? map) =>
      map == null
          ? null
          : NIMMessageThreadOption.fromMap(Map<String, dynamic>.from(map));
}

@JsonSerializable()
class NIMChatroomMessage extends NIMMessage {
  /// 该消息是否要保存到服务器
  @JsonKey(defaultValue: true)
  bool enableHistory;

  /// 是否是高优先级消息
  @JsonKey(defaultValue: false)
  bool isHighPriorityMessage;

  /// 消息扩展
  @JsonKey(
    fromJson: _chatroomMessageExtensionFromMap,
    toJson: _chatroomMessageExtensionToMap,
  )
  NIMChatroomMessageExtension? extension;

  NIMChatroomMessage({
    this.enableHistory = true,
    this.isHighPriorityMessage = false,
    this.extension,
    String? messageId,
    String? sessionId,
    NIMSessionType? sessionType,
    required NIMMessageType messageType,
    int? messageSubType,
    NIMMessageStatus? status,
    required NIMMessageDirection messageDirection,
    String? fromAccount,
    String? content,
    required int timestamp,
    NIMMessageAttachment? messageAttachment,
    NIMMessageAttachmentStatus? attachmentStatus,
    String? uuid,
    int? serverId,
    Map<String, dynamic>? remoteExtension,
    Map<String, dynamic>? localExtension,
    String? callbackExtension,
    Map<String, dynamic>? pushPayload,
    String? pushContent,
    NIMMemberPushOption? memberPushOption,
    NIMClientType? senderClientType,
    NIMAntiSpamOption? antiSpamOption,
    bool messageAck = false,
    bool hasSendAck = false,
    int ackCount = 0,
    int unAckCount = 0,
    bool clientAntiSpam = false,
    bool isInBlackList = false,
    bool isChecked = false,
    bool sessionUpdate = true,
    NIMMessageThreadOption? messageThreadOption,
    int? quickCommentUpdateTime,
    bool isDeleted = false,
    Map<String, dynamic>? yidunAntiCheating,
    String? env,
    String? fromNickname,
    bool? isRemoteRead,
    String? yidunAntiSpamExt,
    String? yidunAntiSpamRes,
  }) : super(
          messageId: messageId,
          sessionId: sessionId,
          sessionType: sessionType,
          messageType: messageType,
          messageSubType: messageSubType,
          status: status,
          messageDirection: messageDirection,
          fromAccount: fromAccount,
          content: content,
          timestamp: timestamp,
          messageAttachment: messageAttachment,
          attachmentStatus: attachmentStatus,
          uuid: uuid,
          serverId: serverId,
          remoteExtension: remoteExtension,
          localExtension: localExtension,
          callbackExtension: callbackExtension,
          pushPayload: pushPayload,
          pushContent: pushContent,
          memberPushOption: memberPushOption,
          senderClientType: senderClientType,
          antiSpamOption: antiSpamOption,
          messageAck: messageAck,
          hasSendAck: hasSendAck,
          ackCount: ackCount,
          unAckCount: unAckCount,
          clientAntiSpam: clientAntiSpam,
          isInBlackList: isInBlackList,
          isChecked: isChecked,
          sessionUpdate: sessionUpdate,
          messageThreadOption: messageThreadOption,
          quickCommentUpdateTime: quickCommentUpdateTime,
          isDeleted: isDeleted,
          yidunAntiCheating: yidunAntiCheating,
          env: env,
          fromNickname: fromNickname,
          isRemoteRead: isRemoteRead,
        );

  factory NIMChatroomMessage.fromMap(Map<String, dynamic> map) =>
      _$NIMChatroomMessageFromJson(map);

  Map<String, dynamic> toMap() => _$NIMChatroomMessageToJson(this);
}

/// 聊天室消息扩展
@JsonSerializable()
class NIMChatroomMessageExtension {
  final String? nickname;

  final String? avatar;

  @JsonKey(fromJson: castPlatformMapToDartMap)
  final Map<String, dynamic>? senderExtension;

  NIMChatroomMessageExtension({
    this.nickname,
    this.avatar,
    this.senderExtension,
  });

  factory NIMChatroomMessageExtension.fromMap(Map<String, dynamic> map) =>
      _$NIMChatroomMessageExtensionFromJson(map);

  Map<String, dynamic> toMap() => _$NIMChatroomMessageExtensionToJson(this);
}

_chatroomMessageExtensionToMap(NIMChatroomMessageExtension? extension) =>
    extension?.toMap();

NIMChatroomMessageExtension? _chatroomMessageExtensionFromMap(Map? map) =>
    map == null
        ? null
        : NIMChatroomMessageExtension.fromMap(map.cast<String, dynamic>());

/// 最近会话
@JsonSerializable()
class NIMSession {
  /// 最近联系人的ID（好友帐号，群ID等）
  final String sessionId;

  /// 获取与该联系人的最后一条消息的发送方的帐号
  final String? senderAccount;

  /// 获取与该联系人的最后一条消息的发送方的昵称
  final String? senderNickname;

  /// 获取会话类型
  final NIMSessionType sessionType;

  /// 最近一条消息的消息ID [NIMMessage.uuid]
  final String? lastMessageId;

  /// 获取最近一条消息的消息类型
  final NIMMessageType? lastMessageType;

  /// 获取最近一条消息状态
  final NIMMessageStatus? lastMessageStatus;

  /// 获取最近一条消息的缩略内容。<br>
  /// 对于文本消息，返回文本内容。<br>
  /// 对于其他消息，返回一个简单的说明内容
  final String? lastMessageContent;

  /// 获取最近一条消息的时间，单位为ms
  final int? lastMessageTime;

  /// 如果最近一条消息是扩展消息类型，获取消息的附件内容. <br>
  /// 在最近消息列表，第三方app可据此自主定义显示的缩略语
  @JsonKey(
      fromJson: NIMMessageAttachment._fromMap,
      toJson: NIMMessageAttachment._toMap)
  final NIMMessageAttachment? lastMessageAttachment;

  /// 获取该联系人的未读消息条数
  int? unreadCount;

  /// 扩展字段
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? extension;

  /// web 专用session字段
  /// 其中 isTop?: bool 字段，表示该会话是否置顶；
  /// msgReceiptTime ?: int ，表示对方已读的最新一条消息的时间。
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? sessionForWeb;

  /// 设置一个标签，用于做联系人置顶、最近会话列表排序等扩展用途。 SDK不关心tag的意义。 <br>
  /// 第三方app需要事先规划好可能的用途
  /// android 独有，不推荐使用，建议使用extension扩展字段代替
  int? tag;

  NIMSession({
    required this.sessionId,
    this.senderAccount,
    this.senderNickname,
    required this.sessionType,
    this.lastMessageId,
    this.lastMessageType,
    this.lastMessageStatus,
    this.lastMessageContent,
    this.lastMessageTime,
    this.lastMessageAttachment,
    this.unreadCount = 0,
    this.extension,
    this.sessionForWeb,
    this.tag,
  });

  factory NIMSession.fromMap(Map<String, dynamic> map) =>
      _$NIMSessionFromJson(map);

  Map<String, dynamic> toMap() => _$NIMSessionToJson(this);
}

/// 清空消息未读数请求
class NIMSessionInfo {
  /// 会话id ，对方帐号或群组id。
  final String sessionId;

  /// 会话类型
  final NIMSessionType sessionType;

  NIMSessionInfo({
    required this.sessionId,
    required this.sessionType,
  });

  factory NIMSessionInfo.fromMap(Map<String, dynamic> map) {
    return NIMSessionInfo(
      sessionId: map['sessionId'] as String,
      sessionType:
          NIMSessionTypeConverter().fromValue(map['sessionType'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        'sessionId': sessionId,
        'sessionType':
            NIMSessionTypeConverter(sessionType: sessionType).toValue(),
      };
}

///群已读回执信息
@JsonSerializable()
class NIMTeamMessageAckInfo {
  final String? teamId;
  final String? msgId;
  final List<String>? ackAccountList;
  final List<String>? unAckAccountList;

  NIMTeamMessageAckInfo({
    this.teamId,
    this.msgId,
    this.ackAccountList,
    this.unAckAccountList,
  });

  factory NIMTeamMessageAckInfo.fromMap(Map<String, dynamic> map) =>
      _$NIMTeamMessageAckInfoFromJson(map);

  Map<String, dynamic> toMap() => _$NIMTeamMessageAckInfoToJson(this);
}

/// 本地反垃圾检测结果
/// 反垃圾词库由开发者在云信后台管理配置，SDK 内负责下载并管理这个词库。垃圾词汇命中后支持三种替换规则：
///
/// 客户端替换：将命中反垃圾的词语替换成指定的文本，再将替换后的消息发送给服务器 <p>
/// 客户端拦截：命中后，开发者不应发送此消息 <p>
/// 服务器处理：开发者将消息相应属性配置为已命中服务端拦截库，再将消息发送给服务器（发送者能看到该消息发送，但是云信服务器不会投递该消息，接收者不会收到该消息），配置方法请见下文描述。
class NIMLocalAntiSpamResult {
  /// 未命中
  static const int pass = 0;

  /// 客户端替换。
  /// 将命中反垃圾的词语替换成指定的文本，再将替换后的消息发送给服务器
  static const int clientReplace = 1;

  /// 客户端拦截。
  /// 命中后，开发者不应发送此消息
  static const int clientIntercept = 2;

  /// 服务端拦截。
  /// 开发者将消息相应属性配置为已命中服务端拦截库，再将消息发送给服务器（发送者能看到该消息发送，但是云信服务器不会投递该消息，接收者不会收到该消息）
  static const int serverIntercept = 3;

  /// 命中的垃圾词操作类型，0：未命中；1：客户端替换；2：客户端拦截；3：服务器拦截；
  final int operator;

  /// 将垃圾词替换后的文本，只有当类型为客户端替换时才有效
  final String? content;

  NIMLocalAntiSpamResult(this.operator, this.content);

  factory NIMLocalAntiSpamResult.fromMap(Map<String, dynamic> map) {
    return NIMLocalAntiSpamResult(
      map['operator'] as int? ?? 0,
      map['content'] as String?,
    );
  }
}

@JsonSerializable()
class NIMMessageKey {
  final NIMSessionType? sessionType;
  final String? fromAccount;
  final String? toAccount;
  final int? time;
  final int? serverId;
  final String? uuid;

  NIMMessageKey(
      {this.sessionType,
      this.fromAccount,
      this.toAccount,
      this.time,
      this.serverId,
      this.uuid});

  factory NIMMessageKey.fromMap(Map<String, dynamic> param) {
    return NIMMessageKey(
      sessionType:
          NIMSessionTypeConverter().fromValue(param['sessionType'] as String),
      fromAccount: param['fromAccount'] as String?,
      toAccount: param['toAccount'] as String?,
      time: param['time'] as int?,
      serverId: param['serverId'] as int?,
      uuid: param['uuid'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionType':
          NIMSessionTypeConverter(sessionType: sessionType).toValue(),
      'fromAccount': fromAccount,
      'toAccount': toAccount,
      'time': time,
      'serverId': serverId,
      'uuid': uuid,
    };
  }

  @override
  String toString() {
    return 'NIMMessageKey{sessionType: $sessionType, fromAccount: $fromAccount, toAccount: $toAccount, time: $time, serverId: $serverId, uuid: $uuid}';
  }
}

@JsonSerializable()
class NIMMessageRobotInfo {
  final String? function;
  final String? topic;
  final String? customContent;
  final String? account;

  NIMMessageRobotInfo(
      {this.function, this.topic, this.customContent, this.account});

  factory NIMMessageRobotInfo.fromMap(Map<String, dynamic> map) =>
      _$NIMMessageRobotInfoFromJson(map);

  Map<String, dynamic> toMap() => _$NIMMessageRobotInfoToJson(this);

  static Map<String, dynamic>? _toMap(NIMMessageRobotInfo? info) =>
      info?.toMap();

  static NIMMessageRobotInfo? _fromMap(Map<Object?, Object?>? map) =>
      map == null
          ? null
          : NIMMessageRobotInfo.fromMap(Map<String, dynamic>.from(map));
}

/// 动态查询消息返回结果
@JsonSerializable()
class GetMessagesDynamicallyResult {
  ///消息列表
  @JsonKey(fromJson: messageListFromMap)
  final List<NIMMessage>? messages;

  ///是否可信
  final bool? isReliable;

  GetMessagesDynamicallyResult({this.messages, this.isReliable});

  static List<NIMMessage>? messageListFromMap(List<dynamic>? messageListMap) =>
      messageListMap == null
          ? null
          : messageListMap
              .map((e) => NIMMessage.fromMap(Map<String, dynamic>.from(e)))
              .toList();

  factory GetMessagesDynamicallyResult.fromMap(Map<String, dynamic> map) =>
      _$GetMessagesDynamicallyResultFromJson(map);

  Map<String, dynamic> toMap() => _$GetMessagesDynamicallyResultToJson(this);
}

/// 动态查询消息参数
@JsonSerializable()
class GetMessagesDynamicallyParam {
  /// 会话ID
  String sessionId;

  /// 会话类型
  NIMSessionType sessionType;

  /// 开始时间（时间戳小）
  int? fromTime;

  /// 结束时间（时间戳大）
  int? toTime;

  /// 要排除的最后一条消息的服务器ID，用于翻页。
  /// 要从A页翻到B页时，传A页中最接近B页的消息
  ///
  /// 设置此参数，需要同时传[anchorClientId]
  /// 同时需要根据[direction]传入[fromTime] 或者 [toTime]
  /// 当[direction] 为[NIMGetMessageDirection.forward]时，需要传入[toTime]
  /// 当[direction] 为[NIMGetMessageDirection.backward]时，需要传入[fromTime]
  int? anchorServerId;

  /// 要排除的最后一条消息的客户端ID，用于翻页。
  /// 要从A页翻到B页时，传A页中最接近B页的消息
  String? anchorClientId;

  /// 条数限制
  /// 限制0~100，否则414。其中0会被转化为100
  int? limit;

  /// 查询方向
  NIMGetMessageDirection? direction;

  GetMessagesDynamicallyParam(this.sessionId, this.sessionType,
      {this.fromTime,
      this.toTime,
      this.anchorServerId,
      this.anchorClientId,
      this.limit,
      this.direction});

  factory GetMessagesDynamicallyParam.fromMap(Map<String, dynamic> map) =>
      _$GetMessagesDynamicallyParamFromJson(map);

  Map<String, dynamic> toMap() => _$GetMessagesDynamicallyParamToJson(this);
}
