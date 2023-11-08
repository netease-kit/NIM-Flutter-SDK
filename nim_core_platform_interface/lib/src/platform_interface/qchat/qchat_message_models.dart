// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

part 'qchat_message_models.g.dart';

@JsonSerializable(explicitToJson: true)
class QChatSendMessageParam {
  /// 消息所属的serverId，必填

  final int serverId;

  /// 消息所属的channelId，必填

  final int channelId;

  /// 消息类型, 同TalkMsgTag，必填

  final NIMMessageType type;

  /// 消息body

  String? body;

  /// 消息附件，通过NIMMessageAttachment#toMap()获得

  String? attach;

  /// 推荐使用此接口设置附件
  void setAttachment(NIMMessageAttachment attachment) {
    attach = jsonEncode(attachment.toMap());
  }

  /// 消息自定义扩展，SDK会转成json字符串使用
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? extension;

  /// 第三方自定义的推送属性，SDK会转成json字符串使用
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? pushPayload;

  /// 自定义推送文案

  String? pushContent;

  /// 被艾特的人的accid列表

  List<String>? mentionedAccidList;

  /// 被艾特的身份组的roleid列表

  List<int>? mentionedRoleIdList;

  /// 是否艾特所有人

  bool mentionedAll = false;

  /// 该消息是否存储云端历史 默认true

  bool historyEnable = true;

  /// 是否需要推送，默认true

  bool pushEnable = true;

  /// 是否需要消息计数，默认true

  bool needBadge = true;

  /// 是否需要推送昵称，默认true

  bool needPushNick = true;

  /// 是否需要抄送，默认true

  bool isRouteEnable = true;

  /// 环境变量,用户可以根据不同的env配置不同的抄送和回调地址

  String? env;

  /// 消息反垃圾配置选项

  @JsonKey(fromJson: _qChatMessageAntiSpamOptionFromJson)
  QChatMessageAntiSpamOption? antiSpamOption;

  /// 消息子类型

  int? subType;

  QChatSendMessageParam(
      {required this.channelId,
      required this.serverId,
      required this.type,
      this.extension,
      this.antiSpamOption,
      this.attach,
      this.body,
      this.env,
      this.historyEnable = true,
      this.isRouteEnable = true,
      this.mentionedAccidList,
      this.mentionedAll = false,
      this.mentionedRoleIdList,
      this.needBadge = true,
      this.needPushNick = true,
      this.pushContent,
      this.pushEnable = true,
      this.pushPayload,
      this.subType});

  factory QChatSendMessageParam.fromJson(Map<String, dynamic> json) =>
      _$QChatSendMessageParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSendMessageParamToJson(this);
}

QChatMessageAntiSpamOption? _qChatMessageAntiSpamOptionFromJson(Map? map) {
  if (map != null) {
    return QChatMessageAntiSpamOption.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class QChatMessageAntiSpamOption {
  /// 是否使用自定义反垃圾字段(customAntiSpamContent)

  bool? isCustomAntiSpamEnable;

  /// 开发者自定义的反垃圾字段

  String? customAntiSpamContent;

  /// 用户配置的对某些单条消息另外的反垃圾的业务ID

  String? antiSpamBusinessId;

  /// 单条消息是否使用易盾反垃圾

  bool? isAntiSpamUsingYidun;

  /// 易盾check的回调URL, 目前仅支持Audio类型的消息, 最长256个字符, 如果不合法则忽略该参数

  String? yidunCallback;

  /// 易盾反垃圾增强反作弊专属字段, 限制json, 长度限制1024

  String? yidunAntiCheating;

  /// 易盾反垃圾扩展字段, 限制json, 长度限制1024

  String? yidunAntiSpamExt;

  QChatMessageAntiSpamOption(
      {this.antiSpamBusinessId,
      this.customAntiSpamContent,
      this.isAntiSpamUsingYidun,
      this.isCustomAntiSpamEnable,
      this.yidunAntiCheating,
      this.yidunAntiSpamExt,
      this.yidunCallback});

  factory QChatMessageAntiSpamOption.fromJson(Map<String, dynamic> json) =>
      _$QChatMessageAntiSpamOptionFromJson(json);

  Map<String, dynamic> toJson() => _$QChatMessageAntiSpamOptionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatSendMessageResult {
  ///已发送的消息
  @JsonKey(fromJson: qChatMessageFromJson)
  final QChatMessage? sentMessage;

  QChatSendMessageResult(this.sentMessage);

  factory QChatSendMessageResult.fromJson(Map<String, dynamic> json) =>
      _$QChatSendMessageResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSendMessageResultToJson(this);
}

QChatMessage? qChatMessageFromJson(Map? map) {
  if (map != null) {
    return QChatMessage.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class QChatMessage {
  /// 消息所属的serverId

  int qChatServerId;

  /// 消息所属的channelId

  int qChatChannelId;

  /// 消息发送者的accid

  String? fromAccount;

  /// 消息发送者的客户端类型

  int? fromClientType;

  /// 消息发送者昵称

  String? fromNick;

  /// 消息发送时间

  int? time;

  /// 消息更新时间

  int? updateTime;

  /// 消息类型

  NIMMessageType? msgType;

  /// 消息body

  String? content;

  /// 消息自定义ext
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? remoteExtension;

  /// 消息的uuid, 该域在生成消息时即会填上

  String? uuid;

  /// 消息服务端ID

  int? msgIdServer;

  /// 是否重发

  bool? resend;

  /// 服务器消息状态

  int? serverStatus;

  /// 第三方自定义的推送属性
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? pushPayload;

  /// 自定义推送文案

  String? pushContent;

  /// 被@的人的accid列表

  List<String>? mentionedAccidList;

  /// 是否@所有人

  bool? mentionedAll;

  /// 该消息是否存储云端历史,默认true

  bool? historyEnable;

  /// 消息附件对象。仅当MsgType为非text时有效

  @JsonKey(
      fromJson: NIMMessageAttachment.fromJson,
      toJson: NIMMessageAttachment.toJson)
  NIMMessageAttachment? attachment;

  /// 消息附件接收/发送状态

  NIMMessageAttachmentStatus? attachStatus;

  /// 是否需要推送,默认true

  bool? pushEnable;

  /// 是否需要消息计数,默认true

  bool? needBadge;

  /// 是否需要推送昵称,默认true

  bool? needPushNick;

  /// 是否需要抄送,默认true

  bool? routeEnable;

  /// 环境变量
  /// 用于指向不同的抄送，第三方回调等配置

  String? env;

  /// 第三方回调回来的自定义扩展字段

  String? callbackExtension;

  /// 被回复消息引用
  @JsonKey(fromJson: _qChatMessageReferFromJson)
  QChatMessageRefer? replyRefer;

  /// 根消息引用
  @JsonKey(fromJson: _qChatMessageReferFromJson)
  QChatMessageRefer? threadRefer;

  /// 是否是根消息

  bool? rootThread;

  /// 消息反垃圾配置选项
  @JsonKey(fromJson: _qChatMessageAntiSpamOptionFromJson)
  QChatMessageAntiSpamOption? antiSpamOption;

  /// 反垃圾结果，此结果仅对文本和图片有效

  @JsonKey(fromJson: _qChatMessageAntiSpamResultFromJson)
  QChatMessageAntiSpamResult? antiSpamResult;

  /// 消息更新内容，消息被修改/撤回/删除 才有值，否则为null

  @JsonKey(fromJson: _qChatMsgUpdateContentFromJson)
  QChatMsgUpdateContent? updateContent;

  /// 消息更新操作者的信息，消息被修改/撤回/删除 才有值，否则为null

  @JsonKey(fromJson: qChatMsgUpdateInfoFromJson)
  QChatMsgUpdateInfo? updateOperatorInfo;

  /// 被@的身份组的roleid列表

  List<int>? mentionedRoleIdList;

  /// 消息子类型

  int? subType;

  /// 消息方向：发出去的消息还是接收到的消息

  NIMMessageDirection? direct;

  /// 本地扩展字段（仅本地有效）

  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? localExtension;

  /// 消息接收/发送状态。

  NIMMessageStatus? status;

  QChatMessage(
      {required this.qChatChannelId,
      required this.qChatServerId,
      this.subType,
      this.serverStatus,
      this.pushEnable,
      this.pushContent,
      this.needPushNick,
      this.needBadge,
      this.mentionedRoleIdList,
      this.mentionedAll,
      this.mentionedAccidList,
      this.historyEnable,
      this.env,
      this.antiSpamOption,
      this.uuid,
      this.updateTime,
      this.time,
      this.content,
      this.attachment,
      this.resend,
      this.antiSpamResult,
      this.attachStatus,
      this.callbackExtension,
      this.direct,
      this.fromAccount,
      this.fromClientType,
      this.fromNick,
      this.localExtension,
      this.msgIdServer,
      this.msgType,
      this.pushPayload,
      this.remoteExtension,
      this.replyRefer,
      this.rootThread,
      this.routeEnable,
      this.status,
      this.threadRefer,
      this.updateContent,
      this.updateOperatorInfo});

  factory QChatMessage.fromJson(Map<String, dynamic> json) =>
      _$QChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$QChatMessageToJson(this);
}

QChatMessageAntiSpamResult? _qChatMessageAntiSpamResultFromJson(Map? map) {
  if (map != null) {
    return QChatMessageAntiSpamResult.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///消息反垃圾结果
@JsonSerializable(explicitToJson: true)
class QChatMessageAntiSpamResult {
  /// 消息是否被反垃圾了

  final bool? isAntiSpam;

  /// 易盾反垃圾结果

  final String? yidunAntiSpamRes;

  QChatMessageAntiSpamResult({this.isAntiSpam, this.yidunAntiSpamRes});

  factory QChatMessageAntiSpamResult.fromJson(Map<String, dynamic> json) =>
      _$QChatMessageAntiSpamResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatMessageAntiSpamResultToJson(this);
}

QChatMsgUpdateContent? _qChatMsgUpdateContentFromJson(Map? map) {
  if (map != null) {
    return QChatMsgUpdateContent.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///消息更新内容
@JsonSerializable(explicitToJson: true)
class QChatMsgUpdateContent {
  /// 修改的服务器消息状态，没修改返回null

  int? serverStatus;

  /// 修改的消息内容，没有修改返回null

  String? content;

  /// 修改的消息自定义ext，没有修改返回null
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? remoteExtension;

  QChatMsgUpdateContent(
      {this.content, this.serverStatus, this.remoteExtension});

  factory QChatMsgUpdateContent.fromJson(Map<String, dynamic> json) =>
      _$QChatMsgUpdateContentFromJson(json);

  Map<String, dynamic> toJson() => _$QChatMsgUpdateContentToJson(this);
}

QChatMsgUpdateInfo? qChatMsgUpdateInfoFromJson(Map? map) {
  if (map != null) {
    return QChatMsgUpdateInfo.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///消息更新信息
@JsonSerializable(explicitToJson: true)
class QChatMsgUpdateInfo {
  /// 操作账号

  String? operatorAccount;

  /// 操作客户端类型

  int? operatorClientType;

  /// 操作附言

  String? msg;

  /// 操作扩展字段

  String? ext;

  /// 推送文案

  String? pushContent;

  /// 推送payload

  String? pushPayload;

  /// 是否需要抄送

  bool? routeEnable;

  /// 环境变量,用户可以根据不同的env配置不同的抄送和回调地址

  String? env;

  QChatMsgUpdateInfo(
      {this.routeEnable,
      this.pushPayload,
      this.env,
      this.pushContent,
      this.ext,
      this.msg,
      this.operatorAccount,
      this.operatorClientType});

  factory QChatMsgUpdateInfo.fromJson(Map<String, dynamic> json) =>
      _$QChatMsgUpdateInfoFromJson(json);

  Map<String, dynamic> toJson() => _$QChatMsgUpdateInfoToJson(this);
}

///下发通知原因
enum QChatNotifyReason {
  /// 通知channel里的所有人
  notifyAll,

  /// 通知给订阅的人
  notifySubscribe,
}

QChatMessageRefer? _qChatMessageReferFromJson(Map? map) {
  if (map != null) {
    return QChatMessageRefer.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///消息引用结构
@JsonSerializable(explicitToJson: true)
class QChatMessageRefer {
  /// 消息发送者

  String? fromAccount;

  /// 消息发送时间

  int time;

  /// 服务端消息id

  int msgIdServer;

  /// 消息的uuid

  String? uuid;

  QChatMessageRefer(
      {required this.time,
      required this.msgIdServer,
      this.fromAccount,
      this.uuid});

  factory QChatMessageRefer.fromJson(Map<String, dynamic> json) =>
      _$QChatMessageReferFromJson(json);

  Map<String, dynamic> toJson() => _$QChatMessageReferToJson(this);
}

///"重发消息"接口入参
@JsonSerializable(explicitToJson: true)
class QChatResendMessageParam {
  final QChatMessage message;

  QChatResendMessageParam(this.message);

  factory QChatResendMessageParam.fromJson(Map<String, dynamic> json) =>
      _$QChatResendMessageParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatResendMessageParamToJson(this);
}

///"下载附件"接口入参
@JsonSerializable(explicitToJson: true)
class QChatDownloadAttachmentParam {
  /// 消息体
  final QChatMessage message;

  /// 下载缩略图还是原文件。为true时，仅下载缩略图
  final bool thumb;

  QChatDownloadAttachmentParam({required this.message, required this.thumb});

  factory QChatDownloadAttachmentParam.fromJson(Map<String, dynamic> json) =>
      _$QChatDownloadAttachmentParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatDownloadAttachmentParamToJson(this);
}

///"查询历史消息"接口入参
@JsonSerializable(explicitToJson: true)
class QChatGetMessageHistoryParam {
  /// 服务器Id

  final int serverId;

  /// 频道Id

  final int channelId;

  /// 起始时间

  int? fromTime;

  /// 结束时间

  int? toTime;

  /// excludeMsgId，排除消息id

  int? excludeMessageId;

  /// limit，条数限制，默认100

  int? limit;

  /// reverse，是否反向

  bool reverse = false;

  QChatGetMessageHistoryParam(
      {required this.serverId,
      required this.channelId,
      this.limit,
      this.excludeMessageId,
      this.fromTime,
      this.reverse = false,
      this.toTime});

  factory QChatGetMessageHistoryParam.fromJson(Map<String, dynamic> json) =>
      _$QChatGetMessageHistoryParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetMessageHistoryParamToJson(this);
}

List<QChatMessage>? _qChatMessageListFromJson(List<dynamic>? messageList) {
  return messageList
      ?.map((e) => QChatMessage.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

List<QChatMessage> _qChatMessageListNotEmptyFromJson(
    List<dynamic> messageList) {
  return messageList
      .map((e) => QChatMessage.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

Map<int, QChatMessage>? _qChatMessageMapIntFromJson(Map? map) {
  return map?.cast<dynamic, dynamic>().map(
        (k, e) => MapEntry(int.parse(k.toString()),
            QChatMessage.fromJson((e as Map).cast<String, dynamic>())),
      );
}

@JsonSerializable(explicitToJson: true)
class QChatGetMessageHistoryResult {
  ///查询到的历史消息
  @JsonKey(fromJson: _qChatMessageListFromJson)
  final List<QChatMessage>? messages;

  QChatGetMessageHistoryResult(this.messages);

  factory QChatGetMessageHistoryResult.fromJson(Map<String, dynamic> json) =>
      _$QChatGetMessageHistoryResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetMessageHistoryResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateMessageParam {
  /// 更新操作通用参数，必填

  final QChatUpdateParam updateParam;

  /// 消息所属的serverId，必填

  final int serverId;

  /// 消息所属的channelId，必填

  final int channelId;

  /// 消息发送时间，从QChatMessage中获取，不可随便设置，必填

  final int time;

  /// 服务端生成的消息id，全局唯一，必填

  final int msgIdServer;

  /// 消息body

  String? body;

  /// 消息自定义扩展
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? extension;

  /// 状态，可以自定义(status>= 10000)

  int? serverStatus;

  /// 消息反垃圾配置选项

  QChatMessageAntiSpamOption? antiSpamOption;

  /// 消息子类型

  int? subType;

  QChatUpdateMessageParam(
      {required this.channelId,
      required this.updateParam,
      required this.serverId,
      required this.time,
      required this.msgIdServer,
      this.extension,
      this.serverStatus,
      this.antiSpamOption,
      this.subType,
      this.body});

  factory QChatUpdateMessageParam.fromJson(Map<String, dynamic> json) =>
      _$QChatUpdateMessageParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUpdateMessageParamToJson(this);
}

///消息/系统通知相关接口更新操作通用参数，设置该操作相关的附加字段，设置该操作引发的推送内容
@JsonSerializable(explicitToJson: true)
class QChatUpdateParam {
  /// 操作附言

  String postscript;

  /// 操作扩展字段

  String? extension;

  /// 推送文案

  String? pushContent;

  /// 推送payload，SDK会转成json字符串使用

  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? pushPayload;

  ///  是否需要抄送，默认true

  bool routeEnable = true;

  /// 环境变量,用户可以根据不同的env配置不同的抄送和回调地址

  String? env;

  QChatUpdateParam(
      {required this.postscript,
      this.pushContent,
      this.env,
      this.pushPayload,
      this.routeEnable = true,
      this.extension});

  factory QChatUpdateParam.fromJson(Map<String, dynamic> json) =>
      _$QChatUpdateParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUpdateParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateMessageResult {
  @JsonKey(fromJson: qChatMessageFromJson)
  final QChatMessage? message;

  QChatUpdateMessageResult(this.message);

  factory QChatUpdateMessageResult.fromJson(Map<String, dynamic> json) =>
      _$QChatUpdateMessageResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUpdateMessageResultToJson(this);
}

///"撤回消息"接口入参
@JsonSerializable(explicitToJson: true)
class QChatRevokeMessageParam {
  /// 更新操作通用参数，设置该操作相关的附加字段，设置该操作引发的推送内容，必填

  final QChatUpdateParam updateParam;

  /// 消息所属的serverId，必填

  final int serverId;

  /// 消息所属的channelId，必填

  final int channelId;

  /// 消息发送时间，从QChatMessage中获取，不可随便设置，必填

  final int time;

  /// 服务端生成的消息id，全局唯一，必填

  final int msgIdServer;

  QChatRevokeMessageParam(
      {required this.channelId,
      required this.serverId,
      required this.msgIdServer,
      required this.time,
      required this.updateParam});

  factory QChatRevokeMessageParam.fromJson(Map<String, dynamic> json) =>
      _$QChatRevokeMessageParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatRevokeMessageParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatRevokeMessageResult {
  ///更新成功的消息
  @JsonKey(fromJson: qChatMessageFromJson)
  final QChatMessage? message;

  QChatRevokeMessageResult(this.message);

  factory QChatRevokeMessageResult.fromJson(Map<String, dynamic> json) =>
      _$QChatRevokeMessageResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatRevokeMessageResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatDeleteMessageResult {
  ///更新成功的消息
  @JsonKey(fromJson: qChatMessageFromJson)
  final QChatMessage? message;

  QChatDeleteMessageResult(this.message);

  factory QChatDeleteMessageResult.fromJson(Map<String, dynamic> json) =>
      _$QChatDeleteMessageResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatDeleteMessageResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatDeleteMessageParam {
  /// 更新操作通用参数，设置该操作相关的附加字段，设置该操作引发的推送内容，必填

  final QChatUpdateParam updateParam;

  /// 消息所属的serverId，必填

  final int serverId;

  /// 消息所属的channelId，必填

  final int channelId;

  /// 消息发送时间，从QChatMessage中获取，不可随便设置，必填

  final int time;

  /// 服务端生成的消息id，全局唯一，必填

  final int msgIdServer;

  QChatDeleteMessageParam(
      {required this.channelId,
      required this.serverId,
      required this.msgIdServer,
      required this.time,
      required this.updateParam});

  factory QChatDeleteMessageParam.fromJson(Map<String, dynamic> json) =>
      _$QChatDeleteMessageParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatDeleteMessageParamToJson(this);
}

///"标记已读"接口入参
@JsonSerializable(explicitToJson: true)
class QChatMarkMessageReadParam {
  /// 服务器Id

  final int serverId;

  /// 频道Id

  final int channelId;

  /// 标记已读时间戳

  final int ackTimestamp;

  QChatMarkMessageReadParam(
      {required this.serverId,
      required this.channelId,
      required this.ackTimestamp});

  factory QChatMarkMessageReadParam.fromJson(Map<String, dynamic> json) =>
      _$QChatMarkMessageReadParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatMarkMessageReadParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatSendSystemNotificationParam {
  /// 通知所属的serverId

  final int serverId;

  /// 通知所属的channelId

  final int? channelId;

  /// 通知接收者账号列表

  final List<String>? toAccids;

  /// 通知内容

  String? body;

  /// 通知附件

  String? attach;

  /// 扩展字段，SDK会转成json字符串使用
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? extension;

  /// 状态，可以自定义(status>= 10000)

  int? status;

  /// 第三方自定义的推送属性，SDK会转成json字符串使用
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? pushPayload;

  /// 自定义推送文案

  String? pushContent;

  /// 是否存离线，只有toAccids不为空，才能设置为存离线，默认false
  /// 设置为离线的消息，发送时如果接收方不在线，上线后可以通过同步接口获得

  bool persistEnable = false;

  /// 是否需要推送，默认false

  bool pushEnable = false;

  /// 是否需要消息计数，默认true

  bool needBadge = true;

  /// 是否需要推送昵称，默认true

  bool needPushNick = true;

  /// 是否需要抄送，默认true

  bool isRouteEnable = true;

  /// 环境变量,用户可以根据不同的env配置不同的抄送和回调地址

  String? env;

  /// 通知发送对象类型，对应下面四种情况，不需要主动设置
  /// <p>
  /// QChatSystemMsgToType.server：如果只填了serverId，则发送给serverId下的所有人
  /// QChatSystemMsgToType.channel: 如果填了serverId+channelId，则发送给serverId+channelId下的所有人
  /// QChatSystemMsgToType.server_ACCIDS: 如果填了serverId+toAccids，则发送给server下的指定账号列表
  /// QChatSystemMsgToType.channel_ACCIDS: 如果填了serverId+channelId+toAccids，则发送给server下某个channel里的指定账号列表

  final QChatSystemMessageToType? toType;

  QChatSendSystemNotificationParam(
      {required this.serverId,
      this.channelId,
      this.body,
      this.extension,
      this.pushPayload,
      this.env,
      this.pushContent,
      this.toAccids,
      this.toType,
      this.status,
      this.needBadge = true,
      this.needPushNick = true,
      this.pushEnable = false,
      this.isRouteEnable = true,
      this.attach,
      this.persistEnable = false});

  factory QChatSendSystemNotificationParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatSendSystemNotificationParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatSendSystemNotificationParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatSendSystemNotificationResult {
  ///发送成功的自定义系统通知
  @JsonKey(fromJson: qChatSystemNotificationFromJson)
  final QChatSystemNotification? sentCustomNotification;

  QChatSendSystemNotificationResult(this.sentCustomNotification);

  factory QChatSendSystemNotificationResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatSendSystemNotificationResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatSendSystemNotificationResultToJson(this);
}

QChatSystemNotification? qChatSystemNotificationFromJson(Map? map) {
  if (map != null) {
    return QChatSystemNotification.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class QChatSystemNotification {
  /// 通知所属的serverId

  int? serverId;

  /// 通知所属的channelId

  int? channelId;

  /// 通知接收者账号列表

  List<String>? toAccids;

  /// 通知发送者的accid

  String? fromAccount;

  /// 通知发送者这的客户端类型

  int? fromClientType;

  /// 发送方设备id

  String? fromDeviceId;

  /// 发送方昵称

  String? fromNick;

  /// 消息发送时间

  int? time;

  /// 通知更新时间

  int? updateTime;

  /// 通知类型, 参考QChatSystemMsgType

  @JsonKey(
      fromJson: _systemNotificationTypeFromJson,
      toJson: __systemNotificationTypeToJson)
  QChatSystemNotificationType? type;

  /// 客户端生成的消息id, 会用于去重

  String? msgIdClient;

  /// 服务器生成的通知id，全局唯一

  int? msgIdServer;

  /// 通知内容

  String? body;

  /// 通知附件

  String? attach;

  /// 通知附件字符串解析后的结构
  @JsonKey(
      fromJson: QChatSystemNotificationAttachment._fromJson,
      toJson: QChatSystemNotificationAttachment._toJson)
  QChatSystemNotificationAttachment? attachment;

  /// 扩展字段

  String? extension;

  /// 状态，参考QChatSystemMsgStatus，可以自定义

  int? status;

  /// 第三方自定义的推送属性，限制使用json格式

  String? pushPayload;

  /// 自定义推送文案

  String? pushContent;

  /// 是否存离线，只有toAccids不为空，才能设置为存离线

  bool? persistEnable;

  /// 是否需要推送，默认false

  bool? pushEnable;

  /// 是否需要消息计数

  bool? needBadge;

  /// 是否需要推送昵称

  bool? needPushNick;

  /// 是否需要抄送,默认true

  bool? routeEnable;

  /// 获取环境变量
  /// 用于指向不同的抄送，第三方回调等配置

  String? env;

  /// 获取第三方回调回来的自定义扩展字段
  ///第三方回调回来的自定义扩展字段

  String? callbackExtension;

  QChatSystemNotification(
      {this.type,
      this.msgIdServer,
      this.extension,
      this.status,
      this.persistEnable,
      this.attach,
      this.pushEnable,
      this.needPushNick,
      this.needBadge,
      this.pushContent,
      this.env,
      this.pushPayload,
      this.body,
      this.channelId,
      this.serverId,
      this.time,
      this.routeEnable,
      this.fromAccount,
      this.fromNick,
      this.fromDeviceId,
      this.fromClientType,
      this.callbackExtension,
      this.attachment,
      this.updateTime,
      this.msgIdClient,
      this.toAccids});

  factory QChatSystemNotification.fromJson(Map<String, dynamic> json) =>
      _$QChatSystemNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSystemNotificationToJson(this);
}

enum QChatSystemMessageToType {
  /// 服务器，serverId必填
  server,

  /// 频道，serverId/channelId必填
  channel,

  /// 服务器成员，serverId/toAccids必填
  server_accids,

  /// 频道成员，serverId/channelId/toAccids必填
  channel_accids,

  /// 复用IM成员信息，toAccids必填
  accids,
}

QChatSystemNotificationType _systemNotificationTypeFromJson(String? param) {
  return QChatSystemNotificationTypeConverter()
      .fromValue(param ?? '', defaultType: QChatSystemNotificationType.custom);
}

String __systemNotificationTypeToJson(QChatSystemNotificationType? type) {
  return QChatSystemNotificationTypeConverter(type: type).toValue();
}

enum QChatSystemNotificationType {
  /// 邀请服务器成员
  server_member_invite,

  /// 拒绝邀请
  server_member_invite_reject,

  /// 申请加入服务器
  server_member_apply,

  /// 拒绝申请
  server_member_apply_reject,

  /// 创建服务器
  server_create,

  /// 删除服务器
  server_remove,

  /// 修改服务器信息
  server_update,

  /// 已邀请服务器成员
  server_member_invite_done,

  /// 接受邀请
  server_member_invite_accept,

  /// 已申请加入服务器
  server_member_apply_done,

  /// 接受申请
  server_member_apply_accept,

  /// 踢除服务器成员
  server_member_kick,

  /// 主动离开服务器
  server_member_leave,

  /// 修改服务器成员信息
  server_member_update,

  /// 创建频道
  channel_create,

  /// 删除频道
  channel_remove,

  /// 修改频道信息
  channel_update,

  /// 频道修改黑白名单身份组
  channel_update_white_black_role,

  /// 频道修改黑白名单成员
  channel_update_white_black_member,

  /// 更新快捷评论表情
  update_quick_comment,

  /// 创建频道类别
  channel_category_create,

  /// 删除频道类别
  channel_category_remove,

  /// 修改频道类别信息
  channel_category_update,

  /// 频道类别修改黑白名单身份组
  channel_category_update_white_black_role,

  /// 频道类别修改黑白名单成员
  channel_category_update_white_black_member,

  /// 加入服务器身份组成员
  server_role_member_add,

  /// 移出服务器身份组成员
  server_role_member_delete,

  /// 更新服务器身份组权限
  server_role_auth_update,

  /// 更新频道身份组权限
  channel_role_auth_update,

  /// 更新频道个人定制权限
  member_role_auth_update,

  /// 频道对当前用户可见性变更
  channel_visibility_update,

  /// 当前用户进入/离开服务器
  server_enter_leave,

  /// 用户通过邀请码加入服务器
  server_member_join_by_invite_code,

  ///修改IM用户信息所触发的对服务器成员信息的联动修改
  ///attach：JSON格式，字段：type，serverIds（服务器成员信息复用IM用户信息的服务器ID列表），userInfo（name、icon）
  my_member_info_update,

  /// 自定义
  custom,
}

@JsonSerializable(explicitToJson: true)
class QChatResendSystemNotificationParam {
  ///重发的系统通知
  final QChatSystemNotification systemNotification;

  QChatResendSystemNotificationParam(this.systemNotification);

  factory QChatResendSystemNotificationParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatResendSystemNotificationParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatResendSystemNotificationParamToJson(this);
}

///"更新系统通知"接口入参
@JsonSerializable(explicitToJson: true)
class QChatUpdateSystemNotificationParam {
  /// 更新操作通用参数，设置该操作相关的附加字段，设置该操作引发的推送内容，必填

  final QChatUpdateParam updateParam;

  /// 服务端生成的消息id，全局唯一，必填

  final int msgIdServer;

  ///  通知类型
  @JsonKey(
      fromJson: _systemNotificationTypeFromJson,
      toJson: __systemNotificationTypeToJson)
  final QChatSystemNotificationType type;

  /// 通知内容

  String? body;

  /// 通知扩展，SDK会转成json字符串使用
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? extension;

  /// 状态,只能设置自定义(status>= 10000)

  int? status;

  QChatUpdateSystemNotificationParam(
      {required this.updateParam,
      required this.msgIdServer,
      required this.type,
      this.status,
      this.extension,
      this.body});

  factory QChatUpdateSystemNotificationParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateSystemNotificationParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatUpdateSystemNotificationParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateSystemNotificationResult {
  ///修改成功的系统通知
  @JsonKey(fromJson: qChatSystemNotificationFromJson)
  final QChatSystemNotification? sentCustomNotification;

  QChatUpdateSystemNotificationResult(this.sentCustomNotification);

  factory QChatUpdateSystemNotificationResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateSystemNotificationResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatUpdateSystemNotificationResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatMarkSystemNotificationsReadParam {
  /// 系统通知msgIdServer和系统通知类型键值对列表

  final List<ReadPair> pairs;

  QChatMarkSystemNotificationsReadParam(this.pairs);

  factory QChatMarkSystemNotificationsReadParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatMarkSystemNotificationsReadParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatMarkSystemNotificationsReadParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ReadPair {
  ///消息id
  int msgId;

  ///类型
  @JsonKey(
      fromJson: _systemNotificationTypeFromJson,
      toJson: __systemNotificationTypeToJson)
  QChatSystemNotificationType type;

  ReadPair({required this.msgId, required this.type});

  factory ReadPair.fromJson(Map<String, dynamic> json) =>
      _$ReadPairFromJson(json);

  Map<String, dynamic> toJson() => _$ReadPairToJson(this);
}

///"根据消息id查询历史消息"接口入参
@JsonSerializable(explicitToJson: true)
class QChatGetMessageHistoryByIdsParam {
  /// 服务器Id

  final int serverId;

  /// 频道Id

  final int channelId;

  /// 消息引用列表

  final List<QChatMessageRefer> messageReferList;

  QChatGetMessageHistoryByIdsParam(
      {required this.serverId,
      required this.channelId,
      required this.messageReferList});

  factory QChatGetMessageHistoryByIdsParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetMessageHistoryByIdsParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetMessageHistoryByIdsParamToJson(this);
}

abstract class QChatSystemNotificationAttachment {
  static Map<String, dynamic> _toJson(
      QChatSystemNotificationAttachment? attachment) {
    if (attachment != null) {
      return attachment.toJson();
    } else {
      return {};
    }
  }

  static QChatSystemNotificationAttachment? _fromJson(
      Map<Object?, Object?>? json,
      {String? type}) {
    if (json == null || type?.isNotEmpty != true) return null;
    var map = Map<String, dynamic>.from(json);
    var messageType = QChatSystemNotificationTypeConverter()
        .fromValue(type!, defaultType: QChatSystemNotificationType.custom);
    switch (messageType) {
      case QChatSystemNotificationType.server_member_invite:
        return QChatInviteServerMemberAttachment.fromJson(map);
      case QChatSystemNotificationType.server_member_invite_reject:
        return QChatRejectInviteServerMemberAttachment.fromJson(map);
      case QChatSystemNotificationType.server_member_apply:
        return QChatApplyJoinServerMemberAttachment.fromJson(map);
      case QChatSystemNotificationType.server_member_apply_reject:
        return QChatRejectApplyServerMemberAttachment.fromJson(map);
      case QChatSystemNotificationType.server_create:
        return QChatCreateServerAttachment.fromJson(map);
      case QChatSystemNotificationType.server_remove:
        return QChatSystemNotificationAttachmentCommon.fromJson(map);
      case QChatSystemNotificationType.server_update:
        return QChatUpdateServerAttachment.fromJson(map);
      case QChatSystemNotificationType.server_member_invite_done:
        return QChatInviteServerMembersDoneAttachment.fromJson(map);
      case QChatSystemNotificationType.server_member_invite_accept:
        return QChatInviteServerMemberAcceptAttachment.fromJson(map);
      case QChatSystemNotificationType.server_member_apply_done:
        return QChatApplyJoinServerMemberDoneAttachment.fromJson(map);
      case QChatSystemNotificationType.server_member_apply_accept:
        return QChatApplyJoinServerMemberAcceptAttachment.fromJson(map);
      case QChatSystemNotificationType.server_member_kick:
        return QChatKickServerMembersDoneAttachment.fromJson(map);
      case QChatSystemNotificationType.server_member_leave:
        return QChatLeaveServerAttachment.fromJson(map);
      case QChatSystemNotificationType.server_member_update:
        return QChatUpdateServerMemberAttachment.fromJson(map);
      case QChatSystemNotificationType.channel_create:
        return QChatCreateChannelNotificationAttachment.fromJson(map);
      case QChatSystemNotificationType.channel_remove:
        return QChatSystemNotificationAttachmentCommon.fromJson(map);
      case QChatSystemNotificationType.channel_update:
        return QChatUpdateChannelNotificationAttachment.fromJson(map);
      case QChatSystemNotificationType.channel_update_white_black_member:
        return QChatUpdateChannelBlackWhiteMemberAttachment.fromJson(map);
      case QChatSystemNotificationType.update_quick_comment:
        return QChatQuickCommentAttachment.fromJson(map);
      case QChatSystemNotificationType.channel_category_create:
        return QChatCreateChannelCategoryAttachment.fromJson(map);
      case QChatSystemNotificationType.channel_category_remove:
        return QChatDeleteChannelCategoryAttachment.fromJson(map);
      case QChatSystemNotificationType.channel_category_update:
        return QChatUpdateChannelCategoryAttachment.fromJson(map);
      case QChatSystemNotificationType
            .channel_category_update_white_black_member:
        return QChatUpdateChannelCategoryBlackWhiteMemberAttachment.fromJson(
            map);
      case QChatSystemNotificationType.server_role_member_add:
        return QChatAddServerRoleMembersAttachment.fromJson(map);
      case QChatSystemNotificationType.server_role_member_delete:
        return QChatDeleteServerRoleMembersAttachment.fromJson(map);
      case QChatSystemNotificationType.channel_visibility_update:
        return QChatUpdateChannelVisibilityAttachment.fromJson(map);
      case QChatSystemNotificationType.server_enter_leave:
        return QChatLeaveServerAttachment.fromJson(map);
      case QChatSystemNotificationType.server_member_join_by_invite_code:
        return QChatJoinServerByInviteCodeAttachment.fromJson(map);
      case QChatSystemNotificationType.channel_update_white_black_role:
        return QChatUpdateChannelBlackWhiteRoleAttachment.fromJson(map);
      case QChatSystemNotificationType.channel_category_update_white_black_role:
        return QChatUpdateChannelCategoryBlackWhiteRoleAttachment.fromJson(map);
      case QChatSystemNotificationType.server_role_auth_update:
        return QChatUpdateServerRoleAuthsAttachment.fromJson(map);
      case QChatSystemNotificationType.channel_role_auth_update:
        return QChatUpdateChannelRoleAuthsAttachment.fromJson(map);
      case QChatSystemNotificationType.member_role_auth_update:
        return QChatUpdateMemberRoleAuthsAttachment.fromJson(map);
      case QChatSystemNotificationType.my_member_info_update:
        return QChatMyMemberInfoUpdatedAttachment.fromJson(map);
      default:
        return QChatSystemNotificationAttachmentCommon.fromJson(map);
    }
  }

  Map<String, dynamic> toJson();
}

@JsonSerializable(explicitToJson: true)
class QChatAddServerRoleMembersAttachment
    extends QChatSystemNotificationAttachment {
  /// 服务器身份组id

  int? roleId;

  /// 服务器Id

  int? serverId;

  /// 被加入成员accid列表

  List<String>? addAccids;

  QChatAddServerRoleMembersAttachment(
      {this.addAccids, this.roleId, this.serverId});

  factory QChatAddServerRoleMembersAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatAddServerRoleMembersAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatAddServerRoleMembersAttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatApplyJoinServerMemberAcceptAttachment
    extends QChatSystemNotificationAttachment {
  /// 获取服务器信息
  @JsonKey(fromJson: serverFromJsonNullable)
  QChatServer? server;

  /// 获取申请者accid

  String? applyAccid;

  /// 申请/邀请唯一标识

  int? requestId;

  QChatApplyJoinServerMemberAcceptAttachment(
      {this.applyAccid, this.requestId, this.server});

  factory QChatApplyJoinServerMemberAcceptAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatApplyJoinServerMemberAcceptAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatApplyJoinServerMemberAcceptAttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatApplyJoinServerMemberAttachment
    extends QChatSystemNotificationAttachment {
  /// 申请/邀请唯一标识

  int? requestId;

  QChatApplyJoinServerMemberAttachment({this.requestId});

  factory QChatApplyJoinServerMemberAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatApplyJoinServerMemberAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatApplyJoinServerMemberAttachmentToJson(this);
}

///已申请加入服务器通知附件
@JsonSerializable(explicitToJson: true)
class QChatApplyJoinServerMemberDoneAttachment
    extends QChatSystemNotificationAttachment {
  /// 获取服务器信息
  @JsonKey(fromJson: serverFromJsonNullable)
  QChatServer? server;

  /// 申请/邀请唯一标识

  int? requestId;

  QChatApplyJoinServerMemberDoneAttachment({this.requestId, this.server});

  factory QChatApplyJoinServerMemberDoneAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatApplyJoinServerMemberDoneAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatApplyJoinServerMemberDoneAttachmentToJson(this);
}

///创建频道分组通知附件
@JsonSerializable(explicitToJson: true)
class QChatCreateChannelCategoryAttachment
    extends QChatSystemNotificationAttachment {
  /// 频道分组信息

  @JsonKey(fromJson: _qChatChannelCategoryFromJsonNullable)
  QChatChannelCategory? channelCategory;

  QChatCreateChannelCategoryAttachment({this.channelCategory});

  factory QChatCreateChannelCategoryAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatCreateChannelCategoryAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatCreateChannelCategoryAttachmentToJson(this);
}

QChatChannelCategory? _qChatChannelCategoryFromJsonNullable(Map? map) {
  if (map == null) {
    return null;
  }
  return QChatChannelCategory.fromJson(map.cast<String, dynamic>());
}

///频道分组信息
@JsonSerializable(explicitToJson: true)
class QChatChannelCategory {
  /// 频道分组id
  int? categoryId;

  /// 获取服务器id

  int? serverId;

  /// 获取名称

  String? name;

  /// 获取自定义扩展

  String? custom;

  /// 获取所有者

  String? owner;

  /// 获取查看模式

  QChatChannelMode? viewMode;

  /// 是否有效

  bool? valid;

  /// 获取创建时间

  int? createTime;

  /// 获取更新时间

  int? updateTime;

  /// 获取频道数量

  int? channelNumber;

  QChatChannelCategory(
      {this.serverId,
      this.updateTime,
      this.createTime,
      this.name,
      this.viewMode,
      this.custom,
      this.valid,
      this.owner,
      this.categoryId,
      this.channelNumber});

  factory QChatChannelCategory.fromJson(Map<String, dynamic> json) =>
      _$QChatChannelCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$QChatChannelCategoryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatCreateChannelNotificationAttachment
    extends QChatSystemNotificationAttachment {
  /// 频道信息
  @JsonKey(fromJson: qChatChannelFromJson)
  QChatChannel? channel;

  QChatCreateChannelNotificationAttachment(this.channel);

  factory QChatCreateChannelNotificationAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatCreateChannelNotificationAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatCreateChannelNotificationAttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatCreateServerAttachment extends QChatSystemNotificationAttachment {
  /// 服务器信息
  @JsonKey(fromJson: serverFromJsonNullable)
  QChatServer? server;

  QChatCreateServerAttachment(this.server);

  factory QChatCreateServerAttachment.fromJson(Map<String, dynamic> json) =>
      _$QChatCreateServerAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$QChatCreateServerAttachmentToJson(this);
}

///删除频道分组通知附件
@JsonSerializable(explicitToJson: true)
class QChatDeleteChannelCategoryAttachment
    extends QChatSystemNotificationAttachment {
  ///  频道分组id

  int? channelCategoryId;

  QChatDeleteChannelCategoryAttachment(this.channelCategoryId);

  factory QChatDeleteChannelCategoryAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatDeleteChannelCategoryAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatDeleteChannelCategoryAttachmentToJson(this);
}

class QChatSystemNotificationAttachmentCommon
    extends QChatSystemNotificationAttachment {
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? json;

  QChatSystemNotificationAttachmentCommon({this.json});

  factory QChatSystemNotificationAttachmentCommon.fromJson(
          Map<String, dynamic> json) =>
      QChatSystemNotificationAttachmentCommon(json: json);

  @override
  Map<String, dynamic> toJson() => json ?? <String, dynamic>{};
}

@JsonSerializable(explicitToJson: true)
class QChatDeleteServerRoleMembersAttachment
    extends QChatSystemNotificationAttachment {
  /// 服务器身份组id

  int? roleId;

  /// 服务器Id

  int? serverId;

  /// 被移出者accid列表

  List<String>? deleteAccids;

  QChatDeleteServerRoleMembersAttachment(
      {this.serverId, this.deleteAccids, this.roleId});

  factory QChatDeleteServerRoleMembersAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatDeleteServerRoleMembersAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatDeleteServerRoleMembersAttachmentToJson(this);
}

///接受服务器成员邀请通知附件
@JsonSerializable(explicitToJson: true)
class QChatInviteServerMemberAcceptAttachment
    extends QChatSystemNotificationAttachment {
  /// 服务器信息
  @JsonKey(fromJson: serverFromJsonNullable)
  QChatServer? server;

  /// 邀请者accid

  String? inviteAccid;

  /// 申请/邀请唯一标识

  int? requestId;

  QChatInviteServerMemberAcceptAttachment(
      {this.server, this.requestId, this.inviteAccid});

  factory QChatInviteServerMemberAcceptAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatInviteServerMemberAcceptAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatInviteServerMemberAcceptAttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatInviteServerMemberAttachment
    extends QChatSystemNotificationAttachment {
  /// 申请/邀请唯一标识

  int? requestId;

  QChatInviteServerMemberAttachment(this.requestId);

  factory QChatInviteServerMemberAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatInviteServerMemberAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatInviteServerMemberAttachmentToJson(this);
}

///已邀请服务器成员通知附件
@JsonSerializable(explicitToJson: true)
class QChatInviteServerMembersDoneAttachment
    extends QChatSystemNotificationAttachment {
  /// 服务器信息
  @JsonKey(fromJson: serverFromJsonNullable)
  QChatServer? server;

  /// 被邀请者accid列表

  List<String>? invitedAccids;

  /// 申请/邀请唯一标识

  int? requestId;

  QChatInviteServerMembersDoneAttachment(
      {this.requestId, this.server, this.invitedAccids});

  factory QChatInviteServerMembersDoneAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatInviteServerMembersDoneAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatInviteServerMembersDoneAttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatJoinServerByInviteCodeAttachment
    extends QChatSystemNotificationAttachment {
  /// 获取服务器信息
  @JsonKey(fromJson: serverFromJsonNullable)
  QChatServer? server;

  /// 申请/邀请唯一标识

  int? requestId;

  /// 邀请码

  String? inviteCode;

  QChatJoinServerByInviteCodeAttachment(
      {this.server, this.requestId, this.inviteCode});

  factory QChatJoinServerByInviteCodeAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatJoinServerByInviteCodeAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatJoinServerByInviteCodeAttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatKickServerMembersDoneAttachment
    extends QChatSystemNotificationAttachment {
  /// 服务器信息
  @JsonKey(fromJson: serverFromJsonNullable)
  QChatServer? server;

  /// 被踢出者accid列表

  List<String>? kickedAccids;

  QChatKickServerMembersDoneAttachment({this.server, this.kickedAccids});

  factory QChatKickServerMembersDoneAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatKickServerMembersDoneAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatKickServerMembersDoneAttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatLeaveServerAttachment extends QChatSystemNotificationAttachment {
  /// 服务器
  @JsonKey(fromJson: serverFromJsonNullable)
  QChatServer? server;

  QChatLeaveServerAttachment(this.server);

  factory QChatLeaveServerAttachment.fromJson(Map<String, dynamic> json) =>
      _$QChatLeaveServerAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$QChatLeaveServerAttachmentToJson(this);
}

///快捷评论通知附件
@JsonSerializable(explicitToJson: true)
class QChatQuickCommentAttachment extends QChatSystemNotificationAttachment {
  /// 快捷评论信息
  @JsonKey(fromJson: _qChatQuickCommentFromJson)
  QChatQuickComment? quickComment;

  QChatQuickCommentAttachment(this.quickComment);

  factory QChatQuickCommentAttachment.fromJson(Map<String, dynamic> json) =>
      _$QChatQuickCommentAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$QChatQuickCommentAttachmentToJson(this);
}

QChatQuickComment? _qChatQuickCommentFromJson(Map? map) {
  if (map != null) {
    return QChatQuickComment.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///消息快捷评论
@JsonSerializable(explicitToJson: true)
class QChatQuickComment {
  /// 获取服务器Id

  int? serverId;

  /// 获取频道Id

  int? channelId;

  /// 获取被评论消息发送者账号

  String? msgSenderAccid;

  /// 获取被评论消息服务端ID

  int? msgIdServer;

  /// 获取被评论消息发送时间

  int? msgTime;

  /// 获取评论类型

  int? type;

  /// 获取快捷评论操作类型

  QChatQuickCommentOperateType? operateType;

  QChatQuickComment(
      {this.serverId,
      this.channelId,
      this.msgIdServer,
      this.type,
      this.operateType,
      this.msgSenderAccid,
      this.msgTime});

  factory QChatQuickComment.fromJson(Map<String, dynamic> json) =>
      _$QChatQuickCommentFromJson(json);

  Map<String, dynamic> toJson() => _$QChatQuickCommentToJson(this);
}

enum QChatQuickCommentOperateType {
  /// 添加
  add,

  /// 移除
  remove,
}

@JsonSerializable(explicitToJson: true)
class QChatRejectApplyServerMemberAttachment
    extends QChatSystemNotificationAttachment {
  /// 申请/邀请唯一标识

  int? requestId;

  QChatRejectApplyServerMemberAttachment(this.requestId);

  factory QChatRejectApplyServerMemberAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatRejectApplyServerMemberAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatRejectApplyServerMemberAttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatRejectInviteServerMemberAttachment
    extends QChatSystemNotificationAttachment {
  /// 申请/邀请唯一标识

  int? requestId;

  QChatRejectInviteServerMemberAttachment(this.requestId);

  factory QChatRejectInviteServerMemberAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatRejectInviteServerMemberAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatRejectInviteServerMemberAttachmentToJson(this);
}

///当前用户进入/离开服务器通知附件
@JsonSerializable(explicitToJson: true)
class QChatServerEnterLeaveAttachment
    extends QChatSystemNotificationAttachment {
  /// 进出事件

  QChatInOutType? inOutType;

  QChatServerEnterLeaveAttachment(this.inOutType);

  factory QChatServerEnterLeaveAttachment.fromJson(Map<String, dynamic> json) =>
      _$QChatServerEnterLeaveAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatServerEnterLeaveAttachmentToJson(this);
}

enum QChatInOutType {
  /// 进入
  inner,

  /// 退出
  out
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateChannelBlackWhiteMemberAttachment
    extends QChatSystemNotificationAttachment {
  /// 服务器Id

  int? serverId;

  /// 频道Id

  int? channelId;

  /// 获取黑白名单类型

  QChatChannelBlackWhiteType? channelBlackWhiteType;

  /// 获取黑白名单操作类型

  QChatChannelBlackWhiteOperateType? channelBlackWhiteOperateType;

  /// 黑白名单被操作账户accid列表

  List<String>? channelBlackWhiteToAccids;

  QChatUpdateChannelBlackWhiteMemberAttachment(
      {this.channelId,
      this.serverId,
      this.channelBlackWhiteOperateType,
      this.channelBlackWhiteToAccids,
      this.channelBlackWhiteType});

  factory QChatUpdateChannelBlackWhiteMemberAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateChannelBlackWhiteMemberAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatUpdateChannelBlackWhiteMemberAttachmentToJson(this);
}

enum QChatChannelBlackWhiteOperateType {
  /// 添加
  add,

  /// 移除
  remove,
}

enum QChatChannelBlackWhiteType {
  /// 白名单
  white,

  /// 黑名单
  black,
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateChannelBlackWhiteRoleAttachment
    extends QChatSystemNotificationAttachment {
  /// 服务器Id

  int? serverId;

  /// 频道Id

  int? channelId;

  /// 获取黑白名单类型

  QChatChannelBlackWhiteType? channelBlackWhiteType;

  /// 获取黑白名单操作类型

  QChatChannelBlackWhiteOperateType? channelBlackWhiteOperateType;

  /// 黑白名单被操作身份组Id

  int? channelBlackWhiteRoleId;

  QChatUpdateChannelBlackWhiteRoleAttachment(
      {this.channelBlackWhiteOperateType,
      this.serverId,
      this.channelId,
      this.channelBlackWhiteRoleId,
      this.channelBlackWhiteType});

  factory QChatUpdateChannelBlackWhiteRoleAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateChannelBlackWhiteRoleAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatUpdateChannelBlackWhiteRoleAttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateChannelCategoryAttachment
    extends QChatSystemNotificationAttachment {
  /// 频道分组信息

  @JsonKey(fromJson: _qChatChannelCategoryFromJsonNullable)
  QChatChannelCategory? channelCategory;

  QChatUpdateChannelCategoryAttachment(this.channelCategory);

  factory QChatUpdateChannelCategoryAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateChannelCategoryAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatUpdateChannelCategoryAttachmentToJson(this);
}

///频道分组修改黑白名单成员通知附件
@JsonSerializable(explicitToJson: true)
class QChatUpdateChannelCategoryBlackWhiteMemberAttachment
    extends QChatSystemNotificationAttachment {
  /// 服务器Id

  int? serverId;

  /// 频道分组Id

  int? channelCategoryId;

  /// 获取黑白名单类型

  QChatChannelBlackWhiteType? channelBlackWhiteType;

  /// 获取黑白名单操作类型

  QChatChannelBlackWhiteOperateType? channelBlackWhiteOperateType;

  /// 黑白名单被操作账户accid列表

  List<String>? toAccids;

  QChatUpdateChannelCategoryBlackWhiteMemberAttachment(
      {this.serverId,
      this.channelCategoryId,
      this.toAccids,
      this.channelBlackWhiteOperateType,
      this.channelBlackWhiteType});

  factory QChatUpdateChannelCategoryBlackWhiteMemberAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateChannelCategoryBlackWhiteMemberAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatUpdateChannelCategoryBlackWhiteMemberAttachmentToJson(this);
}

/// 频道分组修改黑白名单身份组通知附件
@JsonSerializable(explicitToJson: true)
class QChatUpdateChannelCategoryBlackWhiteRoleAttachment
    extends QChatSystemNotificationAttachment {
  /// 服务器Id

  int? serverId;

  /// 频道分组Id

  int? channelCategoryId;

  /// 获取黑白名单类型

  QChatChannelBlackWhiteType? channelBlackWhiteType;

  /// 获取黑白名单操作类型

  QChatChannelBlackWhiteOperateType? channelBlackWhiteOperateType;

  /// 黑白名单被操作身份组Id

  int? roleId;

  QChatUpdateChannelCategoryBlackWhiteRoleAttachment(
      {this.serverId,
      this.channelBlackWhiteOperateType,
      this.channelCategoryId,
      this.roleId,
      this.channelBlackWhiteType});

  factory QChatUpdateChannelCategoryBlackWhiteRoleAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateChannelCategoryBlackWhiteRoleAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatUpdateChannelCategoryBlackWhiteRoleAttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateChannelNotificationAttachment
    extends QChatSystemNotificationAttachment {
  /// 频道信息
  @JsonKey(fromJson: qChatChannelFromJson)
  QChatChannel? channel;

  QChatUpdateChannelNotificationAttachment(this.channel);

  factory QChatUpdateChannelNotificationAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateChannelNotificationAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatUpdateChannelNotificationAttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateChannelRoleAuthsAttachment
    extends QChatSystemNotificationAttachment {
  /// 频道身份组id

  int? roleId;

  /// 服务器Id

  int? serverId;

  /// 频道Id

  int? channelId;

  /// 父身份组id

  int? parentRoleId;

  /// 更新的权限

  @JsonKey(fromJson: resourceAuthsFromJsonNullable)
  Map<QChatRoleResource, QChatRoleOption>? updateAuths;

  QChatUpdateChannelRoleAuthsAttachment(
      {this.roleId,
      this.serverId,
      this.channelId,
      this.parentRoleId,
      this.updateAuths});

  factory QChatUpdateChannelRoleAuthsAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateChannelRoleAuthsAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatUpdateChannelRoleAuthsAttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateChannelVisibilityAttachment
    extends QChatSystemNotificationAttachment {
  /// 进出事件
  QChatInOutType? inOutType;

  QChatUpdateChannelVisibilityAttachment(this.inOutType);

  factory QChatUpdateChannelVisibilityAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateChannelVisibilityAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatUpdateChannelVisibilityAttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateMemberRoleAuthsAttachment
    extends QChatSystemNotificationAttachment {
  /// 成员accid

  String? accid;

  /// 服务器Id

  int? serverId;

  /// 频道Id

  int? channelId;

  /// 更新的权限
  @JsonKey(fromJson: resourceAuthsFromJsonNullable)
  Map<QChatRoleResource, QChatRoleOption>? updateAuths;

  QChatUpdateMemberRoleAuthsAttachment(
      {this.channelId, this.serverId, this.accid, this.updateAuths});

  factory QChatUpdateMemberRoleAuthsAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateMemberRoleAuthsAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatUpdateMemberRoleAuthsAttachmentToJson(this);
}

List<QChatUpdatedMyMemberInfo>? _qChatUpdatedMyMemberInfoFromJson(
    List<dynamic>? messageList) {
  return messageList
      ?.map((e) =>
          QChatUpdatedMyMemberInfo.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class QChatUpdatedMyMemberInfo {
  /// 产生变更的服务器的ID
  int? serverId;

  /// 变更后的昵称
  String? nick;

  /// 昵称是否有变更
  bool? isNickChanged;

  /// 变更后的头像。
  String? avatar;

  /// 头像是否有变更
  bool? isAvatarChanged;

  QChatUpdatedMyMemberInfo(
      {this.serverId,
      this.avatar,
      this.nick,
      this.isAvatarChanged,
      this.isNickChanged});

  factory QChatUpdatedMyMemberInfo.fromJson(Map<String, dynamic> json) =>
      _$QChatUpdatedMyMemberInfoFromJson(json);

  Map<String, dynamic> toJson() => _$QChatUpdatedMyMemberInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatMyMemberInfoUpdatedAttachment
    extends QChatSystemNotificationAttachment {
  @JsonKey(fromJson: _qChatUpdatedMyMemberInfoFromJson)
  List<QChatUpdatedMyMemberInfo>? updatedInfos;

  QChatMyMemberInfoUpdatedAttachment({this.updatedInfos});

  factory QChatMyMemberInfoUpdatedAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatMyMemberInfoUpdatedAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatMyMemberInfoUpdatedAttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateServerAttachment extends QChatSystemNotificationAttachment {
  /// 服务器信息
  @JsonKey(fromJson: serverFromJsonNullable)
  QChatServer? server;

  QChatUpdateServerAttachment(this.server);

  factory QChatUpdateServerAttachment.fromJson(Map<String, dynamic> json) =>
      _$QChatUpdateServerAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$QChatUpdateServerAttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateServerMemberAttachment
    extends QChatSystemNotificationAttachment {
  /// 服务器成员信息
  @JsonKey(fromJson: memberFromJson)
  QChatServerMember? serverMember;

  QChatUpdateServerMemberAttachment(this.serverMember);

  factory QChatUpdateServerMemberAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateServerMemberAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatUpdateServerMemberAttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatUpdateServerRoleAuthsAttachment
    extends QChatSystemNotificationAttachment {
  /// 服务器身份组id

  int? roleId;

  /// 服务器Id

  int? serverId;

  /// 更新的权限

  @JsonKey(fromJson: resourceAuthsFromJsonNullable)
  Map<QChatRoleResource, QChatRoleOption>? updateAuths;

  QChatUpdateServerRoleAuthsAttachment(
      {this.serverId, this.updateAuths, this.roleId});

  factory QChatUpdateServerRoleAuthsAttachment.fromJson(
          Map<String, dynamic> json) =>
      _$QChatUpdateServerRoleAuthsAttachmentFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$QChatUpdateServerRoleAuthsAttachmentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatReplyMessageParam {
  /// 发送消息入参
  QChatSendMessageParam message;

  /// 被回复消息体
  QChatMessage replyMessage;

  QChatReplyMessageParam({required this.message, required this.replyMessage});

  factory QChatReplyMessageParam.fromJson(Map<String, dynamic> json) =>
      _$QChatReplyMessageParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatReplyMessageParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetReferMessagesParam {
  /// 查询消息

  final QChatMessage message;

  /// 消息引用类型

  final QChatMessageReferType referType;

  QChatGetReferMessagesParam({required this.message, required this.referType});

  factory QChatGetReferMessagesParam.fromJson(Map<String, dynamic> json) =>
      _$QChatGetReferMessagesParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetReferMessagesParamToJson(this);
}

enum QChatMessageReferType {
  ///回复的
  replay,

  ///根Thread
  thread,

  ///所有
  all
}

@JsonSerializable(explicitToJson: true)
class QChatGetReferMessagesResult {
  /// 被回复的消息

  @JsonKey(fromJson: qChatMessageFromJson)
  final QChatMessage? replyMessage;

  /// 根消息

  @JsonKey(fromJson: qChatMessageFromJson)
  final QChatMessage? threadMessage;

  QChatGetReferMessagesResult({this.replyMessage, this.threadMessage});

  factory QChatGetReferMessagesResult.fromJson(Map<String, dynamic> json) =>
      _$QChatGetReferMessagesResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetReferMessagesResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetThreadMessagesParam {
  /// 消息

  final QChatMessage message;

  /// 查询选项

  final QChatMessageQueryOption? messageQueryOption;

  QChatGetThreadMessagesParam({required this.message, this.messageQueryOption});

  factory QChatGetThreadMessagesParam.fromJson(Map<String, dynamic> json) =>
      _$QChatGetThreadMessagesParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetThreadMessagesParamToJson(this);
}

///消息查询选项
@JsonSerializable(explicitToJson: true)
class QChatMessageQueryOption {
  /// 起始时间

  int? fromTime;

  /// 结束时间

  int? toTime;

  /// excludeMsgId，排除消息id

  int? excludeMessageId;

  /// limit，条数限制，默认100

  int? limit;

  /// reverse，是否反向

  bool? reverse = false;

  QChatMessageQueryOption(
      {this.toTime,
      this.fromTime,
      this.reverse = false,
      this.excludeMessageId,
      this.limit});

  factory QChatMessageQueryOption.fromJson(Map<String, dynamic> json) =>
      _$QChatMessageQueryOptionFromJson(json);

  Map<String, dynamic> toJson() => _$QChatMessageQueryOptionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetThreadMessagesResult {
  /// thread消息

  @JsonKey(fromJson: qChatMessageFromJson)
  final QChatMessage? threadMessage;

  /// thread聊天信息

  @JsonKey(fromJson: _qChatMessageThreadInfoFromJson)
  final QChatMessageThreadInfo? threadInfo;

  /// 查询到的thread历史消息

  @JsonKey(fromJson: _qChatMessageListFromJson)
  final List<QChatMessage>? messages;

  QChatGetThreadMessagesResult(
      {this.threadMessage, this.messages, this.threadInfo});

  factory QChatGetThreadMessagesResult.fromJson(Map<String, dynamic> json) =>
      _$QChatGetThreadMessagesResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetThreadMessagesResultToJson(this);
}

QChatMessageThreadInfo? _qChatMessageThreadInfoFromJson(Map? map) {
  if (map != null) {
    return QChatMessageThreadInfo.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class QChatMessageThreadInfo {
  /// 获取thread聊天里的总回复数

  int? total;

  /// 获取thread聊天里最后一条消息的时间戳

  int? lastMsgTime;

  QChatMessageThreadInfo({this.total, this.lastMsgTime});

  factory QChatMessageThreadInfo.fromJson(Map<String, dynamic> json) =>
      _$QChatMessageThreadInfoFromJson(json);

  Map<String, dynamic> toJson() => _$QChatMessageThreadInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetMessageThreadInfosParam {
  /// 服务器Id

  final int serverId;

  /// 频道Id

  final int channelId;

  /// 消息列表，一次最多查询100条

  @JsonKey(fromJson: _qChatMessageListFromJson)
  final List<QChatMessage>? msgList;

  QChatGetMessageThreadInfosParam(
      {required this.channelId, required this.serverId, this.msgList});

  factory QChatGetMessageThreadInfosParam.fromJson(Map<String, dynamic> json) =>
      _$QChatGetMessageThreadInfosParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetMessageThreadInfosParamToJson(this);
}

Map<String, QChatMessageThreadInfo>? _qChatMessageThreadInfoStringMapFromJson(
    Map? map) {
  return map?.cast<String, dynamic>().map(
        (k, e) => MapEntry(
            k,
            QChatMessageThreadInfo.fromJson(
                (e as Map).cast<String, dynamic>())),
      );
}

@JsonSerializable(explicitToJson: true)
class QChatGetMessageThreadInfosResult {
  /// 消息Thread聊天信息Map，key为uuid

  @JsonKey(fromJson: _qChatMessageThreadInfoStringMapFromJson)
  final Map<String, QChatMessageThreadInfo>? messageThreadInfoMap;

  QChatGetMessageThreadInfosResult({this.messageThreadInfoMap});

  factory QChatGetMessageThreadInfosResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetMessageThreadInfosResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetMessageThreadInfosResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatQuickCommentParam {
  /// 被评论消息

  final QChatMessage commentMessage;

  /// 评论类型

  final int type;

  QChatQuickCommentParam(this.commentMessage, this.type);

  factory QChatQuickCommentParam.fromJson(Map<String, dynamic> json) =>
      _$QChatQuickCommentParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatQuickCommentParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatAddQuickCommentParam extends QChatQuickCommentParam {
  QChatAddQuickCommentParam(QChatMessage commentMessage, int type)
      : super(commentMessage, type);

  factory QChatAddQuickCommentParam.fromJson(Map<String, dynamic> json) =>
      _$QChatAddQuickCommentParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatAddQuickCommentParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatRemoveQuickCommentParam extends QChatQuickCommentParam {
  QChatRemoveQuickCommentParam(QChatMessage commentMessage, int type)
      : super(commentMessage, type);

  factory QChatRemoveQuickCommentParam.fromJson(Map<String, dynamic> json) =>
      _$QChatRemoveQuickCommentParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatRemoveQuickCommentParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetQuickCommentsParam {
  /// 服务器Id

  final int serverId;

  /// 频道Id

  final int channelId;

  /// 消息列表，1次最多20条

  @JsonKey(fromJson: _qChatMessageListFromJson)
  final List<QChatMessage>? msgList;

  QChatGetQuickCommentsParam(
      {required this.serverId, required this.channelId, this.msgList});

  factory QChatGetQuickCommentsParam.fromJson(Map<String, dynamic> json) =>
      _$QChatGetQuickCommentsParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetQuickCommentsParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetQuickCommentsResult {
  /// 消息快捷评论详情Map，key为MsgIdServer

  @JsonKey(fromJson: _qChatMessageQuickCommentDetailMapIntFromJson)
  final Map<int, QChatMessageQuickCommentDetail>? messageQuickCommentDetailMap;

  QChatGetQuickCommentsResult({this.messageQuickCommentDetailMap});

  factory QChatGetQuickCommentsResult.fromJson(Map<String, dynamic> json) =>
      _$QChatGetQuickCommentsResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatGetQuickCommentsResultToJson(this);
}

Map<int, QChatMessageQuickCommentDetail>?
    _qChatMessageQuickCommentDetailMapIntFromJson(Map? map) {
  return map?.cast<dynamic, dynamic>().map(
        (k, e) => MapEntry(
            int.parse(k.toString()),
            QChatMessageQuickCommentDetail.fromJson(
                (e as Map).cast<String, dynamic>())),
      );
}

@JsonSerializable(explicitToJson: true)
class QChatMessageQuickCommentDetail {
  /// 获取服务器Id

  int? serverId;

  /// 获取channelId

  int? channelId;

  /// 获取消息服务端Id

  int? msgIdServer;

  /// 获取总评论数

  int? totalCount;

  /// 获取消息评论最后一次操作的时间

  int? lastUpdateTime;

  /// 获取评论详情列表

  @JsonKey(fromJson: _qChatQuickCommentDetailListFromJson)
  List<QChatQuickCommentDetail>? details;

  QChatMessageQuickCommentDetail(
      {this.channelId,
      this.serverId,
      this.msgIdServer,
      this.details,
      this.lastUpdateTime,
      this.totalCount});

  factory QChatMessageQuickCommentDetail.fromJson(Map<String, dynamic> json) =>
      _$QChatMessageQuickCommentDetailFromJson(json);

  Map<String, dynamic> toJson() => _$QChatMessageQuickCommentDetailToJson(this);
}

QChatMessageQuickCommentDetail? _qChatMessageQuickCommentDetailFromJson(
    Map? map) {
  if (map != null) {
    return QChatMessageQuickCommentDetail.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

List<QChatQuickCommentDetail>? _qChatQuickCommentDetailListFromJson(
    List<dynamic>? details) {
  return details
      ?.map((e) =>
          QChatQuickCommentDetail.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class QChatQuickCommentDetail {
  /// 获取评论类型

  int? type;

  /// 获取评论数量

  int? count;

  /// 自己是否添加了该类型评论

  bool? hasSelf;

  /// 获取若干个添加了此类型评论的accid列表，不是按照操作时间排序的，可以认为是随机取了N个

  List<String>? severalAccids;

  QChatQuickCommentDetail(
      {this.type, this.count, this.hasSelf, this.severalAccids});

  factory QChatQuickCommentDetail.fromJson(Map<String, dynamic> json) =>
      _$QChatQuickCommentDetailFromJson(json);

  Map<String, dynamic> toJson() => _$QChatQuickCommentDetailToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatMessageCache {
  /// 获取消息体
  @JsonKey(fromJson: qChatMessageFromJson)
  QChatMessage? message;

  /// 获取消息的回复对象
  @JsonKey(fromJson: qChatMessageFromJson)
  QChatMessage? replyMessage;

  /// 获取消息的Thread消息
  @JsonKey(fromJson: qChatMessageFromJson)
  QChatMessage? threadMessage;

  /// 获取消息的快捷评论

  @JsonKey(fromJson: _qChatMessageQuickCommentDetailFromJson)
  QChatMessageQuickCommentDetail? messageQuickCommentDetail;

  QChatMessageCache(
      {this.threadMessage,
      this.message,
      this.replyMessage,
      this.messageQuickCommentDetail});

  factory QChatMessageCache.fromJson(Map<String, dynamic> json) =>
      _$QChatMessageCacheFromJson(json);

  Map<String, dynamic> toJson() => _$QChatMessageCacheToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetLastMessageOfChannelsParam {
  /// 服务器Id

  final int serverId;

  /// 频道Id列表，最多20个，要求都是serverId下的

  final List<int> channelIds;

  QChatGetLastMessageOfChannelsParam(
      {required this.serverId, required this.channelIds});

  factory QChatGetLastMessageOfChannelsParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetLastMessageOfChannelsParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetLastMessageOfChannelsParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetLastMessageOfChannelsResult {
  /// 查询到的消息map,key为channelId
  @JsonKey(fromJson: _qChatMessageMapIntFromJson)
  final Map<int, QChatMessage>? channelMsgMap;

  QChatGetLastMessageOfChannelsResult({this.channelMsgMap});

  factory QChatGetLastMessageOfChannelsResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetLastMessageOfChannelsResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetLastMessageOfChannelsResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatSearchMsgByPageParam {
  /// 检索关键字，目标检索消息名称

  String? keyword;

  /// 服务器ID

  final int serverId;

  /// 频道ID

  int? channelId;

  /// 消息发送者accid

  String? fromAccount;

  /// 查询时间范围的开始时间

  int? fromTime;

  /// 查询时间范围的结束时间，要求比开始时间大

  int? toTime;

  /// 搜索的消息类型列表，目前仅支持[ NIMMessageType.text],[NIMMessageType.image],[NIMMessageType.video],[NIMMessageType.file]

  final List<NIMMessageType> msgTypes;

  /// 搜索的消息子类型列表

  List<int>? subTypes;

  /// 是否包含自己的消息

  bool? isIncludeSelf;

  /// 排序规则 true：正序；false：倒序（默认）

  bool? order;

  /// 检索返回的最大记录数，最大和默认都是100

  int? limit;

  /// 排序条件

  QChatMessageSearchSortEnum? sort;

  /// 查询游标，下次查询的起始位置,第一页设置为null，查询下一页是传入上一页返回的cursor

  String? cursor;

  QChatSearchMsgByPageParam(
      {required this.serverId,
      required this.msgTypes,
      this.channelId,
      this.limit,
      this.fromTime,
      this.toTime,
      this.sort,
      this.fromAccount,
      this.keyword,
      this.cursor,
      this.isIncludeSelf,
      this.order,
      this.subTypes});

  factory QChatSearchMsgByPageParam.fromJson(Map<String, dynamic> json) =>
      _$QChatSearchMsgByPageParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSearchMsgByPageParamToJson(this);
}

enum QChatMessageSearchSortEnum {
  /// 创建时间，默认
  createTime,
}

@JsonSerializable(explicitToJson: true)
class QChatSearchMsgByPageResult extends QChatGetByPageWithCursorResult {
  /// 查询到的消息列表

  @JsonKey(fromJson: _qChatMessageListFromJson)
  final List<QChatMessage>? messages;

  QChatSearchMsgByPageResult(bool? hasMore, int? nextTimeTag, String? cursor,
      {this.messages})
      : super(hasMore, nextTimeTag, cursor);

  factory QChatSearchMsgByPageResult.fromJson(Map<String, dynamic> json) =>
      _$QChatSearchMsgByPageResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSearchMsgByPageResultToJson(this);
}

///"发送消息正在输入事件"接口入参
@JsonSerializable(explicitToJson: true)
class QChatSendTypingEventParam {
  /// 正在输入事件所属的serverId
  final int serverId;

  /// 正在输入事件所属的channelId
  final int channelId;

  /// 扩展字段，SDK会转成JSON字符串使用
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? extension;

  QChatSendTypingEventParam(
      {required this.serverId, required this.channelId, this.extension});

  factory QChatSendTypingEventParam.fromJson(Map<String, dynamic> json) =>
      _$QChatSendTypingEventParamFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSendTypingEventParamToJson(this);
}

///消息正在输入事件
@JsonSerializable(explicitToJson: true)
class QChatTypingEvent {
  /// 事件所属的 serverId
  final int? serverId;

  /// 事件所属的 channelId
  final int? channelId;

  /// 事件发送者的 accid
  final String? fromAccount;

  /// 事件发送方昵称
  final String? fromNick;

  /// 事件发送时间
  final int? time;

  /// 事件扩展字段
  @JsonKey(fromJson: castPlatformMapToDartMap)
  Map<String, dynamic>? extension;

  QChatTypingEvent(
      {this.serverId,
      this.channelId,
      this.extension,
      this.time,
      this.fromAccount,
      this.fromNick});

  factory QChatTypingEvent.fromJson(Map<String, dynamic> json) =>
      _$QChatTypingEventFromJson(json);

  Map<String, dynamic> toJson() => _$QChatTypingEventToJson(this);
}

QChatTypingEvent? qQChatTypingEventFromJson(Map? map) {
  if (map != null) {
    return QChatTypingEvent.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class QChatSendTypingEventResult {
  ///正在输入事件
  @JsonKey(fromJson: qQChatTypingEventFromJson)
  QChatTypingEvent? typingEvent;

  QChatSendTypingEventResult({this.typingEvent});

  factory QChatSendTypingEventResult.fromJson(Map<String, dynamic> json) =>
      _$QChatSendTypingEventResultFromJson(json);

  Map<String, dynamic> toJson() => _$QChatSendTypingEventResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatGetMentionedMeMessagesParam {
  /// 服务器id
  final int serverId;

  /// 频道id
  final int channelId;

  /// 查询时间戳
  final int? timetag;

  /// 查询数量限制，默认200
  final int? limit;

  QChatGetMentionedMeMessagesParam(
      {required this.channelId,
      required this.serverId,
      this.limit,
      this.timetag});

  factory QChatGetMentionedMeMessagesParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetMentionedMeMessagesParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetMentionedMeMessagesParamToJson(this);
}

///分页查询指定频道@我的消息接口 结果
@JsonSerializable(explicitToJson: true)
class QChatGetMentionedMeMessagesResult extends QChatGetByPageWithCursorResult {
  ///查询到的消息列表
  @JsonKey(fromJson: _qChatMessageListFromJson)
  List<QChatMessage>? messages;

  QChatGetMentionedMeMessagesResult(
      bool? hasMore, int? nextTimeTag, String? cursor,
      {this.messages})
      : super(hasMore, nextTimeTag, cursor);

  factory QChatGetMentionedMeMessagesResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatGetMentionedMeMessagesResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatGetMentionedMeMessagesResultToJson(this);
}

///"批量查询消息是否@当前用户"接口入参
@JsonSerializable(explicitToJson: true)
class QChatAreMentionedMeMessagesParam {
  /// 消息列表，一次最多查询100条
  @JsonKey(fromJson: _qChatMessageListNotEmptyFromJson)
  List<QChatMessage> messages;

  QChatAreMentionedMeMessagesParam({required this.messages});

  factory QChatAreMentionedMeMessagesParam.fromJson(
          Map<String, dynamic> json) =>
      _$QChatAreMentionedMeMessagesParamFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatAreMentionedMeMessagesParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QChatAreMentionedMeMessagesResult {
  ///消息是否@当前用户的结果，key为uuid
  @JsonKey(fromJson: castMapToTypeOfBoolString)
  Map<String, bool>? result;

  QChatAreMentionedMeMessagesResult({this.result});

  factory QChatAreMentionedMeMessagesResult.fromJson(
          Map<String, dynamic> json) =>
      _$QChatAreMentionedMeMessagesResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QChatAreMentionedMeMessagesResultToJson(this);
}
