// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

part "message.g.dart";

typedef MessageAction = Future Function(NIMMessage message);

/// 消息附件协议
@JsonSerializable(explicitToJson: true)
class NIMMessageAttachment {
  /// 消息对象
  String? raw;

  NIMMessageAttachment({this.raw});

  factory NIMMessageAttachment.fromJson(Map<String, dynamic> map) {
    var messageType = map['nimCoreMessageType'] == null
        ? NIMMessageType.invalid
        : $enumDecode(_$NIMMessageTypeEnumMap, map['nimCoreMessageType']);
    switch (messageType) {
      case NIMMessageType.audio:
        return NIMMessageAudioAttachment.fromJson(map);
      case NIMMessageType.video:
        return NIMMessageVideoAttachment.fromJson(map);
      case NIMMessageType.file:
        return NIMMessageFileAttachment.fromJson(map);
      case NIMMessageType.image:
        return NIMMessageImageAttachment.fromJson(map);
      case NIMMessageType.location:
        return NIMMessageLocationAttachment.fromJson(map);
      case NIMMessageType.notification:
        return NIMMessageNotificationAttachment.fromJson(map);
      case NIMMessageType.call:
        return NIMMessageCallAttachment.fromJson(map);
      default:
        return _$NIMMessageAttachmentFromJson(map);
    }
  }

  Map<String, dynamic> toJson() {
    return _$NIMMessageAttachmentToJson(this);
  }
}

/// 消息文件附件
@JsonSerializable(explicitToJson: true)
class NIMMessageFileAttachment extends NIMMessageAttachment {
  /// 文件本地路径
  String? path;

  /// 文件数据大小
  int? size;

  /// 文件数据md5
  String? md5;

  /// 文件上传服务器路径
  String? url;

  /// 文件类型
  String? ext;

  /// 文件显示名称
  String? name;

  /// 文件存储场景
  String? sceneName;

  /// 上传状态
  NIMMessageAttachmentUploadState? uploadState;

  NIMMessageFileAttachment(
      {this.path,
      this.size,
      this.md5,
      this.url,
      this.ext,
      this.name,
      this.sceneName,
      this.uploadState});

  @override
  factory NIMMessageFileAttachment.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageFileAttachmentFromJson(map);

  @override
  Map<String, dynamic> toJson() => _$NIMMessageFileAttachmentToJson(this)
    ..['nimCoreMessageType'] = _$NIMMessageTypeEnumMap[NIMMessageType.file];
}

/// 图片附件对象
@JsonSerializable(explicitToJson: true)
class NIMMessageImageAttachment extends NIMMessageFileAttachment {
  /// 图片宽度
  int? width;

  /// 图片高度
  int? height;

  NIMMessageImageAttachment({this.width, this.height});

  @override
  factory NIMMessageImageAttachment.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageImageAttachmentFromJson(map);

  @override
  Map<String, dynamic> toJson() => _$NIMMessageImageAttachmentToJson(this)
    ..['nimCoreMessageType'] = _$NIMMessageTypeEnumMap[NIMMessageType.image];
}

/// 语音附件对象
@JsonSerializable(explicitToJson: true)
class NIMMessageAudioAttachment extends NIMMessageFileAttachment {
  /// 语音文件播放时长
  int? duration;

  NIMMessageAudioAttachment({this.duration});

  @override
  factory NIMMessageAudioAttachment.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageAudioAttachmentFromJson(map);

  @override
  Map<String, dynamic> toJson() => _$NIMMessageAudioAttachmentToJson(this)
    ..['nimCoreMessageType'] = _$NIMMessageTypeEnumMap[NIMMessageType.audio];
}

/// 视频附件对象
@JsonSerializable(explicitToJson: true)
class NIMMessageVideoAttachment extends NIMMessageFileAttachment {
  /// 视频文件播放时长
  int? duration;

  /// 视频宽度
  int? width;

  /// 视频高度
  int? height;

  NIMMessageVideoAttachment({this.duration, this.width, this.height});

  @override
  factory NIMMessageVideoAttachment.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageVideoAttachmentFromJson(map);

  @override
  Map<String, dynamic> toJson() => _$NIMMessageVideoAttachmentToJson(this)
    ..['nimCoreMessageType'] = _$NIMMessageTypeEnumMap[NIMMessageType.video];
}

/// 消息地理位置附件
@JsonSerializable(explicitToJson: true)
class NIMMessageLocationAttachment extends NIMMessageAttachment {
  /// 经度
  double? longitude;

  /// 纬度
  double? latitude;

  /// 详细位置信息
  String? address;

  NIMMessageLocationAttachment({this.longitude, this.latitude, this.address});

  @override
  factory NIMMessageLocationAttachment.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageLocationAttachmentFromJson(map);

  @override
  Map<String, dynamic> toJson() => _$NIMMessageLocationAttachmentToJson(this)
    ..['nimCoreMessageType'] = _$NIMMessageTypeEnumMap[NIMMessageType.location];
}

/// 通知附件对象
@JsonSerializable(explicitToJson: true)
class NIMMessageNotificationAttachment extends NIMMessageAttachment {
  /// 通知类型
  NIMMessageNotificationType? type;

  /// 扩展字段
  String? serverExtension;

  /// 被操作者ID列表
  List<String?>? targetIds;

  /// 群成员是否被禁言
  bool? chatBanned;

  /// 群信息更新字段
  @JsonKey(fromJson: _nimUpdatedTeamInfoFromJson)
  NIMUpdatedTeamInfo? updatedTeamInfo;

  NIMMessageNotificationAttachment(
      {this.type,
      this.serverExtension,
      this.targetIds,
      this.chatBanned,
      this.updatedTeamInfo});

  @override
  factory NIMMessageNotificationAttachment.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageNotificationAttachmentFromJson(map);

  @override
  Map<String, dynamic> toJson() =>
      _$NIMMessageNotificationAttachmentToJson(this)
        ..['nimCoreMessageType'] =
            _$NIMMessageTypeEnumMap[NIMMessageType.notification];
}

NIMUpdatedTeamInfo? _nimUpdatedTeamInfoFromJson(Map? map) {
  if (map != null) {
    return NIMUpdatedTeamInfo.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

/// 话单时长
@JsonSerializable(explicitToJson: true)
class NIMMessageCallDuration {
  /// 话单对应成员的账号ID
  String? accountId;

  /// 通话时长
  int? duration;

  NIMMessageCallDuration({this.accountId, this.duration});

  factory NIMMessageCallDuration.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageCallDurationFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessageCallDurationToJson(this);
}

/// 话单附件
@JsonSerializable(explicitToJson: true)
class NIMMessageCallAttachment extends NIMMessageAttachment {
  /**
   * 话单类型， 业务自定义，内容不校验
   * 建议：
   * 音频：1
   * 视频：2
   */
  int? type;

  /// 话单频道ID， 内容不校验
  String? channelId;

  /**
   * 通话状态，业务自定义状态， 内容不校验
   * 建议：
   * 通话完成：1
   * 通话取消：2
   * 通话拒绝：3
   * 超时未接听：4
   * 对方忙： 5
   */
  int? status;

  /// 通话成员时长列表， 内容不校验
  @JsonKey(fromJson: _nimMessageCallDurationListFromJson)
  List<NIMMessageCallDuration?>? durations;

  NIMMessageCallAttachment(
      {this.type, this.channelId, this.status, this.durations});

  @override
  factory NIMMessageCallAttachment.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageCallAttachmentFromJson(map);

  @override
  Map<String, dynamic> toJson() => _$NIMMessageCallAttachmentToJson(this)
    ..['nimCoreMessageType'] = _$NIMMessageTypeEnumMap[NIMMessageType.call];
}

List<NIMMessageCallDuration>? _nimMessageCallDurationListFromJson(
    List<dynamic>? applicationList) {
  return applicationList
      ?.map((e) =>
          NIMMessageCallDuration.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class NIMMessageRefer {
  /// 发送者账号
  String? senderId;

  /// 接收者账号
  String? receiverId;

  /// 客户端消息ID
  String? messageClientId;

  /// 服务器消息ID
  String? messageServerId;

  /// 会话类型
  NIMConversationType? conversationType;

  /// 会话 ID
  String? conversationId;

  /// 消息时间
  int? createTime;

  NIMMessageRefer(
      {this.senderId,
      this.receiverId,
      this.messageClientId,
      this.messageServerId,
      this.conversationType,
      this.conversationId,
      this.createTime});

  factory NIMMessageRefer.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageReferFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessageReferToJson(this);
}

/// 消息
@JsonSerializable(explicitToJson: true)
class NIMMessage extends NIMMessageRefer {
  /// 消息发送者是否是自己
  bool? isSelf;

  /// 附件上传状态
  @JsonKey(unknownEnumValue: NIMMessageAttachmentUploadState.unknown)
  NIMMessageAttachmentUploadState? attachmentUploadState;

  /// 消息发送状态 可以主动查询 也可以根据回调监听来确认
  NIMMessageSendingState? sendingState;

  /// 类型
  NIMMessageType? messageType;

  /// 子类型
  int? subType;

  /// 文本
  String? text;

  /// 附件
  @JsonKey(fromJson: _nimMessageAttachmentFromJson)
  NIMMessageAttachment? attachment;

  /// 服务端扩展信息，必须是Json 字符串，要不然会解析失败。
  String? serverExtension;

  /// 客户端本地扩展信息
  String? localExtension;

  /// 第三方回调扩展字段， 透传字段
  final String? callbackExtension;

  /// 消息相关配置，具体参见每一个字段定义
  @JsonKey(fromJson: _nimMessageConfigFromJson)
  final NIMMessageConfig? messageConfig;

  /// 推送设置
  @JsonKey(fromJson: _nimMessagePushConfigFromJson)
  final NIMMessagePushConfig? pushConfig;

  /// 路由抄送相关配置
  @JsonKey(fromJson: _nimMessageRouteConfigFromJson)
  NIMMessageRouteConfig? routeConfig;

  /// 反垃圾相关
  @JsonKey(fromJson: _nimMessageAntispamConfigFromJson)
  NIMMessageAntispamConfig? antispamConfig;

  /// 机器人相关配置
  @JsonKey(fromJson: _nimMessageRobotConfigFromJson)
  NIMMessageRobotConfig? robotConfig;

  /// Thread消息引用
  @JsonKey(fromJson: nimMessageReferFromJson)
  NIMMessageRefer? threadRoot;

  /// 回复消息引用
  @JsonKey(fromJson: nimMessageReferFromJson)
  NIMMessageRefer? threadReply;

  /// AI数字人相关信息
  @JsonKey(fromJson: _nimMessageAIConfigFromJson)
  NIMMessageAIConfig? aiConfig;

  /// 消息状态相关
  @JsonKey(fromJson: _nimMessageStatusFromJson)
  NIMMessageStatus? messageStatus;

  NIMMessage(
      {this.isSelf,
      this.attachmentUploadState,
      this.sendingState,
      this.messageType,
      this.subType,
      this.text,
      this.attachment,
      this.serverExtension,
      this.localExtension,
      this.callbackExtension,
      this.messageConfig,
      this.pushConfig,
      this.routeConfig,
      this.antispamConfig,
      this.robotConfig,
      this.threadRoot,
      this.threadReply,
      this.aiConfig,
      this.messageStatus});

  @override
  factory NIMMessage.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageFromJson(map);

  @override
  Map<String, dynamic> toJson() => _$NIMMessageToJson(this);
}

NIMMessageAttachment? _nimMessageAttachmentFromJson(Map? map) {
  if (map != null) {
    return NIMMessageAttachment.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMMessageConfig? _nimMessageConfigFromJson(Map? map) {
  if (map != null) {
    return NIMMessageConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMMessagePushConfig? _nimMessagePushConfigFromJson(Map? map) {
  if (map != null) {
    return NIMMessagePushConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMMessageRouteConfig? _nimMessageRouteConfigFromJson(Map? map) {
  if (map != null) {
    return NIMMessageRouteConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMMessageAntispamConfig? _nimMessageAntispamConfigFromJson(Map? map) {
  if (map != null) {
    return NIMMessageAntispamConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMMessageRobotConfig? _nimMessageRobotConfigFromJson(Map? map) {
  if (map != null) {
    return NIMMessageRobotConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMMessageRefer? nimMessageReferFromJson(Map? map) {
  if (map != null) {
    return NIMMessageRefer.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMMessageAIConfig? _nimMessageAIConfigFromJson(Map? map) {
  if (map != null) {
    return NIMMessageAIConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMMessageStatus? _nimMessageStatusFromJson(Map? map) {
  if (map != null) {
    return NIMMessageStatus.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

/// 消息推送设置
@JsonSerializable(explicitToJson: true)
class NIMSendMessageProgress {
  /// 消息 id
  String? messageClientId;

  /// 发送进度
  int? progress;

  NIMSendMessageProgress({this.messageClientId, this.progress});

  factory NIMSendMessageProgress.fromJson(Map<String, dynamic> map) =>
      _$NIMSendMessageProgressFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSendMessageProgressToJson(this);
}

/// 消息推送设置
@JsonSerializable(explicitToJson: true)
class NIMMessagePushConfig {
  /// 是否需要推送消息。YES：需要，NO：不需要，默认YES
  bool? pushEnabled;

  /// 是否需要推送消息发送者昵称。YES：需要，NO：不需要，默认YES
  bool? pushNickEnabled;

  /// 推送文本
  String? pushContent;

  /// 推送数据
  String? pushPayload;

  /// 是否强制推送，忽略用户消息提醒相关设置
  bool? forcePush;

  /// 强制推送文案，只消息类型有效
  String? forcePushContent;

  /// 强制推送目标账号列表
  List<String?>? forcePushAccountIds;

  NIMMessagePushConfig(
      {this.pushEnabled,
      this.pushNickEnabled,
      this.pushContent,
      this.pushPayload,
      this.forcePush,
      this.forcePushContent,
      this.forcePushAccountIds});

  factory NIMMessagePushConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMMessagePushConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessagePushConfigToJson(this);
}

/// 消息配置
@JsonSerializable(explicitToJson: true)
class NIMMessageConfig {
  /// 是否不需要群消息已读回执信息。YES：需要，NO：不需要，默认为NO
  bool? readReceiptEnabled;

  /// 是否需要更新消息所属的会话信息。YES：需要，NO：不需要，默认为NO
  bool? lastMessageUpdateEnabled;

  /// 是否需要在服务端保存历史消息。YES：需要，NO：不需要，默认NO
  bool? historyEnabled;

  /// 是否需要漫游消息。YES：需要，NO：不需要，默认NO
  bool? roamingEnabled;

  /// 是否需要发送方多端在线同步消息。YES：需要，NO：不需要，默认NO
  bool? onlineSyncEnabled;

  /// 是否需要存离线消息。YES：需要，NO：不需要，默认NO
  bool? offlineEnabled;

  /// 是否需要计未读。YES：需要，NO：不需要，默认NO
  bool? unreadEnabled;

  NIMMessageConfig(
      {this.readReceiptEnabled,
      this.lastMessageUpdateEnabled,
      this.historyEnabled,
      this.roamingEnabled,
      this.onlineSyncEnabled,
      this.offlineEnabled,
      this.unreadEnabled});

  factory NIMMessageConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessageConfigToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMMessageRouteConfig {
  /// 是否需要路由消息。YES：需要，NO：不需要，默认YES
  bool? routeEnabled;

  /// 环境变量，用于指向不同的抄送，第三方回调等配置
  String? routeEnvironment;

  NIMMessageRouteConfig({this.routeEnabled, this.routeEnvironment});

  factory NIMMessageRouteConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageRouteConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessageRouteConfigToJson(this);
}

/// 消息反垃圾设置
@JsonSerializable(explicitToJson: true)
class NIMMessageAntispamConfig {
  /// 指定是否需要过安全通（对于已开通安全通的用户有效，默认消息都会走安全通，如果对单条消息设置 enable 为false，则此消息不会走安全通）。
  /// true：需要，
  /// false：不需要
  /// 该字段为true，其他字段才生效
  bool? antispamEnabled;

  /// 指定易盾业务id，而不使用云信后台配置的
  String? antispamBusinessId;

  /// 自定义消息中需要反垃圾的内容（仅当消息类型为自定义消息时有效）
  String? antispamCustomMessage;

  /// 易盾反作弊（辅助检测数据），json格式，限制长度1024
  String? antispamCheating;

  /// 易盾反垃圾（增强检测数据），json格式，限制长度1024
  String? antispamExtension;

  NIMMessageAntispamConfig(
      {this.antispamEnabled,
      this.antispamBusinessId,
      this.antispamCustomMessage,
      this.antispamCheating,
      this.antispamExtension});

  factory NIMMessageAntispamConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageAntispamConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessageAntispamConfigToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMMessageRobotConfig {
  /// 机器人账号，对应控制台提前设置好的机器人
  /// 仅在群聊中有效，点对点聊天室中该字段会被忽略
  String? accountId;

  /// 机器人消息话题
  String? topic;

  /// 机器人具体功能
  String? function;

  /// 机器人自定义内容
  String? customContent;

  NIMMessageRobotConfig(
      {this.accountId, this.topic, this.function, this.customContent});

  factory NIMMessageRobotConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageRobotConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessageRobotConfigToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMMessageAIConfig {
  /// 数字人的 accountId
  String? accountId;

  /// 该 AI 消息的询问和应答标识
  /// 0 表示普通消息
  /// 1 表示是一个艾特数字人的消息
  /// 2 表示是数字人响应艾特的消息
  /// 响应回参
  NIMMessageAIStatus? aiStatus;

  NIMMessageAIConfig({this.accountId, this.aiStatus});

  factory NIMMessageAIConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageAIConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessageAIConfigToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMMessageAIConfigParams {
  /// 数字人的 accountId
  String? accountId;

  /// 请求大模型的内容
  @JsonKey(fromJson: _nimAIModelCallContentFromJson)
  NIMAIModelCallContent? content;

  /// 上下文内容
  /// 当前只支持文本消息
  @JsonKey(fromJson: _aiModelCallMessageListFromJson)
  List<NIMAIModelCallMessage?>? messages;

  /// 提示词变量占位符替换
  /// JSON 格式的字符串
  /// 用于填充prompt中的变量
  String? promptVariables;

  /// 请求接口模型相关参数配置， 如果参数不为空，则默认覆盖控制相关配置
  @JsonKey(fromJson: _nimAIModelConfigParamsFromJson)
  NIMAIModelConfigParams? modelConfigParams;

  NIMMessageAIConfigParams(
      {this.accountId,
      this.content,
      this.messages,
      this.promptVariables,
      this.modelConfigParams});

  factory NIMMessageAIConfigParams.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageAIConfigParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessageAIConfigParamsToJson(this);
}

NIMAIModelCallContent? _nimAIModelCallContentFromJson(Map? map) {
  if (map != null) {
    return NIMAIModelCallContent.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

List<NIMAIModelCallMessage>? _aiModelCallMessageListFromJson(
    List<dynamic>? applicationList) {
  return applicationList
      ?.map((e) =>
          NIMAIModelCallMessage.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class NIMMessageStatus {
  /// 消息发送错误码
  /// 客户端回填，以及服务器回填
  /// 客户端回填的时候， 发送状态为失败
  /// 服务器回填的时候， 发送状态为成功
  /// 包括如下情况:
  /// 1，本地命中发垃圾拦截
  /// 2，本地发送超时
  /// 3，服务器AI响应消息由于反垃圾失败返回
  /// 4，服务器AI响应消息由于三方回调拦截返回
  /// 3，4两种情况服务器默认下发消息类型为tips消息，同时下发消息错误码， 由端上拦截处理上抛界面
  /// 5，被对方拉黑发送失败
  /// 6，以及其他发送失败情况
  int? errorCode;

  /// 群消息开启已读回执配置， 客户端收到消息后需要发送已读回执请求， 该字段记录是否已经发送过已读回执请求， 避免重复发送
  /// 只对群消息有效
  bool? readReceiptSent;

  NIMMessageStatus({this.errorCode, this.readReceiptSent});

  factory NIMMessageStatus.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageStatusFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessageStatusToJson(this);
}

/// 消息发送相关参数
@JsonSerializable(explicitToJson: true)
class NIMSendMessageParams {
  /// 消息相关配置
  @JsonKey(fromJson: _nimMessageConfigFromJson)
  NIMMessageConfig? messageConfig;

  /// 路由抄送相关配置
  @JsonKey(fromJson: _nimMessageRouteConfigFromJson)
  NIMMessageRouteConfig? routeConfig;

  /// 推送相关配置
  @JsonKey(fromJson: _nimMessagePushConfigFromJson)
  NIMMessagePushConfig? pushConfig;

  /// 反垃圾相关配置
  @JsonKey(fromJson: _nimMessageAntispamConfigFromJson)
  NIMMessageAntispamConfig? antispamConfig;

  /// 机器人相关配置
  @JsonKey(fromJson: _nimMessageRobotConfigFromJson)
  NIMMessageRobotConfig? robotConfig;

  /// 请求大模型的相关参数
  @JsonKey(fromJson: _nimMessageAIConfigParamsFromJson)
  NIMMessageAIConfigParams? aiConfig;

  ///是否启用本地反垃圾
  ///只针对文本消息生效
  ///发送消息时候，如果改字段为true，文本消息则走本地反垃圾检测，检测后返回NIMMessageClientAntispamOperatorType，
  ///返回0，直接发送该消息
  ///返回1，发送替换后的文本消息
  ///返回2，消息发送失败， 返回本地错误码
  ///返回3，消息正常发送，由服务端拦截
  bool? clientAntispamEnabled;

  /// 反垃圾命中后替换的文本
  String? clientAntispamReplace;

  NIMSendMessageParams(
      {this.messageConfig,
      this.routeConfig,
      this.pushConfig,
      this.antispamConfig,
      this.robotConfig,
      this.aiConfig,
      this.clientAntispamEnabled,
      this.clientAntispamReplace});

  factory NIMSendMessageParams.fromJson(Map<String, dynamic> map) =>
      _$NIMSendMessageParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSendMessageParamsToJson(this);
}

NIMMessageAIConfigParams? _nimMessageAIConfigParamsFromJson(Map? map) {
  if (map != null) {
    return NIMMessageAIConfigParams.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

/// 发送消息结果
@JsonSerializable(explicitToJson: true)
class NIMSendMessageResult {
  /// 发送成功后的消息体
  @JsonKey(fromJson: nimMessageFromJson)
  NIMMessage? message;

  /// 反垃圾返回的结果
  String? antispamResult;

  /// 客户端本地反垃圾结果
  @JsonKey(fromJson: _nimClientAntispamResultFromJson)
  NIMClientAntispamResult? clientAntispamResult;

  NIMSendMessageResult(
      {this.message, this.antispamResult, this.clientAntispamResult});

  factory NIMSendMessageResult.fromJson(Map<String, dynamic> map) =>
      _$NIMSendMessageResultFromJson(map);

  Map<String, dynamic> toJson() => _$NIMSendMessageResultToJson(this);
}

NIMMessage? nimMessageFromJson(Map? map) {
  if (map != null) {
    return NIMMessage.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMClientAntispamResult? _nimClientAntispamResultFromJson(Map? map) {
  if (map != null) {
    return NIMClientAntispamResult.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

/// 消息发送相关参数
@JsonSerializable(explicitToJson: true)
class NIMMessageListOption {
  /// 消息所属会话ID 由senderId, conversationType， receiverId拼装而成 [必填]
  String? conversationId;

  /// 根据消息类型查询会话， 为null或空列表， 则表示查询所有消息类型 [选填]
  /// @see NIMMessageType
  List<int>? messageTypes;

  /// 消息查询开始时间，闭区间 [选填]
  int? beginTime;

  /// 消息查询结束时间，闭区间 [选填]
  int? endTime;

  /// 每次查询条数，默认50 最大值100 [选填]
  int? limit;

  /// 锚点消息，根据锚点消息查询，不包含该消息 [选填]
  @JsonKey(fromJson: nimMessageFromJson)
  NIMMessage? anchorMessage;

  /// 消息查询方向，如果其它参数都不填 [选填]
  /// 如果查询older， 则beginTime默认为long.maxValue，否则以beginTime向老查询
  /// 如果查询newer， 则beginTime默认为0, 否则以beginTime开始向最新查询
  NIMQueryDirection? direction;

  /// 严格模式，默认为NO [选填]
  /// true：如果无法确定消息完整性，则返回错误
  /// false：如果无法确定消息完整性，从数据库中查询并返回
  bool? strictMode;

  NIMMessageListOption(
      {this.conversationId,
      this.messageTypes,
      this.beginTime,
      this.endTime,
      this.limit,
      this.anchorMessage,
      this.direction,
      this.strictMode});

  factory NIMMessageListOption.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageListOptionFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessageListOptionToJson(this);
}

/// 消息发送相关参数
@JsonSerializable(explicitToJson: true)
class NIMClearHistoryMessageOption {
  /// 需要清空消息的对应的会话ID
  String? conversationId;

  /// 是否同步删除漫游消息，默认删除，该字段只P2P时有效 true：删除 false：保留漫游消息 默认 true
  bool? deleteRoam;

  /// 是否多端同步，默认不同步 true：同步到其它端 false：不同步V2NIMSendMessageParam
  bool? onlineSync;

  /// 扩展字段，多端同步时会同步到其它端
  String? serverExtension;

  NIMClearHistoryMessageOption(
      {this.conversationId,
      this.deleteRoam,
      this.onlineSync,
      this.serverExtension});

  factory NIMClearHistoryMessageOption.fromJson(Map<String, dynamic> map) =>
      _$NIMClearHistoryMessageOptionFromJson(map);

  Map<String, dynamic> toJson() => _$NIMClearHistoryMessageOptionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMClientAntispamResult {
  /// 客户端反垃圾文本命中后操作类型
  NIMClientAntispamOperateType? operateType;

  /// 处理后的文本内容
  String? replacedText;

  NIMClientAntispamResult({this.operateType, this.replacedText});

  factory NIMClientAntispamResult.fromJson(Map<String, dynamic> map) =>
      _$NIMClientAntispamResultFromJson(map);

  Map<String, dynamic> toJson() => _$NIMClientAntispamResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMAIModelCallContent {
  /// 请求/响应的文本内容
  String? msg;

  /// 类型,暂时只有0，代表文本，预留扩展能力
  int type;

  NIMAIModelCallContent({this.msg, required this.type});

  factory NIMAIModelCallContent.fromJson(Map<String, dynamic> map) =>
      _$NIMAIModelCallContentFromJson(map);

  Map<String, dynamic> toJson() => _$NIMAIModelCallContentToJson(this);
}

/// 请求调用上下文内容
@JsonSerializable(explicitToJson: true)
class NIMAIModelCallMessage {
  /// 上下文内容的角色
  NIMAIModelRoleType? role;

  /// 上下文内容的内容
  String? msg;

  /// 类型
  int type;

  NIMAIModelCallMessage({this.role, this.msg, required this.type});

  factory NIMAIModelCallMessage.fromJson(Map<String, dynamic> map) =>
      _$NIMAIModelCallMessageFromJson(map);

  Map<String, dynamic> toJson() => _$NIMAIModelCallMessageToJson(this);
}

/// Ai 大模型配置覆盖， 配置了该字段， 则默认覆盖控制台相关配置
/// 如果所有字段均为空，则以控制台配置为准， 本地不做格式校验
/// 如果设置参数超过范围， 则会主动纠正到正确范围
@JsonSerializable(explicitToJson: true)
class NIMAIModelConfigParams {
  /// 提示词
  String? prompt;

  /// 模型最大tokens数量
  int? maxTokens;

/**
 *  取值范围（0，1），生成时，核采样方法的概率阈值。
 *  例如，取值为0.8时，仅保留累计概率之和大于等于0.8的概率分布中的token，作为随机采样的候选集。取值范围为（0,1.0)，取值越大，生成的随机性越高；取值越低，生成的随机性越低。
 *  默认值 0.5。注意，取值不要大于等于1
 */

  double? topP;

/**
 *  取值范围(0,2)，用于控制随机性和多样性的程度。
 *  具体来说，temperature值控制了生成文本时对每个候选词的概率分布进行平滑的程度。较高的temperature值会降低概率分布的峰值，使得更多的低概率词被选择，生成结果更加多样化；而较低的temperature值则会增强概率分布的峰值，使得高概率词更容易被选择，生成结果更加确定。
 */
  double? temperature;

  NIMAIModelConfigParams(
      {this.prompt, this.maxTokens, this.topP, this.temperature});

  factory NIMAIModelConfigParams.fromJson(Map<String, dynamic> map) =>
      _$NIMAIModelConfigParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMAIModelConfigParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMProxyAIModelCallParams {
  /// 机器人账号ID
  String? accountId;

  /// 请求id
  String? requestId;

  /// 请求大模型的内容
  @JsonKey(fromJson: _nimAIModelCallContentFromJson)
  NIMAIModelCallContent? content;

  /// 上下文内容
  @JsonKey(fromJson: _aiModelCallMessageListFromJson)
  List<NIMAIModelCallMessage?>? messages;

  /// 提示词变量占位符替换
  /// JSON 格式的字符串
  /// 用于填充prompt中的变量
  String? promptVariables;

  /// 请求接口模型相关参数配置， 如果参数不为空，则默认覆盖控制相关配置
  @JsonKey(fromJson: _nimAIModelConfigParamsFromJson)
  NIMAIModelConfigParams? modelConfigParams;

  /// AI 透传接口的反垃圾配置
  @JsonKey(fromJson: _nimProxyAICallAntispamConfigFromJson)
  NIMProxyAICallAntispamConfig? antispamConfig;

  NIMProxyAIModelCallParams(
      {this.accountId,
      this.requestId,
      this.content,
      this.messages,
      this.promptVariables,
      this.modelConfigParams,
      this.antispamConfig});

  factory NIMProxyAIModelCallParams.fromJson(Map<String, dynamic> map) =>
      _$NIMProxyAIModelCallParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMProxyAIModelCallParamsToJson(this);
}

NIMAIModelConfigParams? _nimAIModelConfigParamsFromJson(Map? map) {
  if (map != null) {
    return NIMAIModelConfigParams.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMProxyAICallAntispamConfig? _nimProxyAICallAntispamConfigFromJson(Map? map) {
  if (map != null) {
    return NIMProxyAICallAntispamConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class NIMAIModelConfig {
  /// 具体大模型版本模型名
  String? model;

  /// 提示词
  String? prompt;

  /// 提示词对应的变量
  List? promptKeys;

  /// 模型最大tokens数量
  int? maxTokens;

/**
 *  取值范围（0，1），生成时，核采样方法的概率阈值。
 *  例如，取值为0.8时，仅保留累计概率之和大于等于0.8的概率分布中的token，作为随机采样的候选集。取值范围为（0,1.0)，取值越大，生成的随机性越高；取值越低，生成的随机性越低。
 *  默认值 0.5。注意，取值不要大于等于1
 */

  double? topP;

/**
 *  取值范围(0,2)，用于控制随机性和多样性的程度。
 *  具体来说，temperature值控制了生成文本时对每个候选词的概率分布进行平滑的程度。较高的temperature值会降低概率分布的峰值，使得更多的低概率词被选择，生成结果更加多样化；而较低的temperature值则会增强概率分布的峰值，使得高概率词更容易被选择，生成结果更加确定。
 */
  double? temperature;

  NIMAIModelConfig(
      {this.model,
      this.prompt,
      this.promptKeys,
      this.maxTokens,
      this.topP,
      this.temperature});

  factory NIMAIModelConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMAIModelConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMAIModelConfigToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMProxyAICallAntispamConfig {
  /// 指定消息是否需要经过安全通。默认为 true
  /// 对于已开通安全通的用户有效，默认消息都会走安全通，如果对单条消息设置 enable 为 false，则此消息不会走安全通
  bool? antispamEnabled;

  /// 指定易盾业务id
  String? antispamBusinessId;

  NIMProxyAICallAntispamConfig({this.antispamEnabled, this.antispamBusinessId});

  factory NIMProxyAICallAntispamConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMProxyAICallAntispamConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMProxyAICallAntispamConfigToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMAIModelCallResult {
  /// 数字人的accountId
  String? accountId;

  /// 本次响应的标识
  String? requestId;

  /// 请求AI的回复
  @JsonKey(fromJson: _nimAIModelCallContentFromJson)
  NIMAIModelCallContent? content;

  /// AI响应的状态码
  int? code;

  NIMAIModelCallResult(
      {this.accountId, this.requestId, this.content, this.code});

  factory NIMAIModelCallResult.fromJson(Map<String, dynamic> map) =>
      _$NIMAIModelCallResultFromJson(map);

  Map<String, dynamic> toJson() => _$NIMAIModelCallResultToJson(this);
}

/// 消息删除通知
@JsonSerializable(explicitToJson: true)
class NIMMessageDeletedNotification {
  /// 被删除的消息引用
  @JsonKey(fromJson: nimMessageReferFromJson)
  NIMMessageRefer? messageRefer;

  /// 被删除的时间
  int? deleteTime;

  /// 被删除时填入的扩展字段
  String? serverExtension;

  NIMMessageDeletedNotification(
      {this.messageRefer, this.deleteTime, this.serverExtension});

  factory NIMMessageDeletedNotification.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageDeletedNotificationFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessageDeletedNotificationToJson(this);
}

/// 撤回消息通知
@JsonSerializable(explicitToJson: true)
class NIMMessageRevokeNotification {
  /// 被撤回的消息摘要
  @JsonKey(fromJson: nimMessageReferFromJson)
  NIMMessageRefer? messageRefer;

  /// 扩展信息
  String? serverExtension;

  /// 消息撤回者账号
  String? revokeAccountId;

  /// 扩展信息
  String? postscript;

  /// 消息撤回类型
  NIMMessageRevokeType? revokeType;

  /// 第三方回调传入的自定义扩展字段
  String? callbackExtension;

  NIMMessageRevokeNotification(
      {this.messageRefer,
      this.serverExtension,
      this.revokeAccountId,
      this.postscript,
      this.revokeType,
      this.callbackExtension});

  factory NIMMessageRevokeNotification.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageRevokeNotificationFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessageRevokeNotificationToJson(this);
}

/// 撤回消息参数
@JsonSerializable(explicitToJson: true)
class NIMMessageRevokeParams {
  /// 撤回的附言
  String? postscript;

  /// 扩展信息
  String? serverExtension;

  /// 推送内容,长度限制500字
  String? pushContent;

  /// 推送数据,长度限制 2K
  String? pushPayload;

  /// 路由抄送地址
  String? env;

  NIMMessageRevokeParams(
      {this.postscript,
      this.serverExtension,
      this.pushContent,
      this.pushPayload,
      this.env});

  factory NIMMessageRevokeParams.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageRevokeParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessageRevokeParamsToJson(this);
}

/// 消息检索参数
@JsonSerializable(explicitToJson: true)
class NIMMessageSearchParams {
  /// 检索的关键字
  String? keyword;

  /// 查询开始时间，小于endTime
  int? beginTime;

  /// 查询结束时间吗，如果为0，表示当前时间
  int? endTime;

  /// 检索的会话条数如果>0： 按会话分组 否则：按时间排序，不按会话分组 note：协议 7-26   7-27
  int? conversationLimit;

  /// 返回的消息条数.最多不超过X， 跟当前版本对齐
  int? messageLimit;

  /// 消息排序规则
  NIMSortOrder? sortOrder;

  /// P2P账号列表， 最大20个，超过20个返回参数错误
  List<String?>? p2pAccountIds;

  /// 高级群账号列表， 最大20个， 超过20个返回参数错误.不支持超大群
  List<String?>? teamIds;

  /// 检索的发送账号列表，最大20个， 超过20个返回参数错误
  List<String?>? senderAccountIds;

  /// 根据消息类型检索消息， 为null或空列表， 则表示查询所有消息类型 V2NIMMessageType
  List<int>? messageTypes;

  /// 根据消息子类型检索消息， 为null或空列表， 则表示查询所有消息子类型
  List? messageSubtypes;

  NIMMessageSearchParams(
      {this.keyword,
      this.beginTime,
      this.endTime,
      this.conversationLimit,
      this.messageLimit,
      this.sortOrder,
      this.p2pAccountIds,
      this.teamIds,
      this.senderAccountIds,
      this.messageTypes,
      this.messageSubtypes});

  factory NIMMessageSearchParams.fromJson(Map<String, dynamic> map) =>
      _$NIMMessageSearchParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMMessageSearchParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMVoiceToTextParams {
  /// 本地语音文件路径 voicePath/ voiceUrl必须二选一
  String? voicePath;

  /// 语音url，如果没有内部自动上传 voicePath/ voiceUrl必须二选一
  String? voiceUrl;

  /// 音频类型：语音类型，aac, wav, mp3, amr等
  String? mimeType;

  /// 采样率，8000kHz, 16000kHz等
  String? sampleRate;

  /// 语音时长, 单位毫秒
  int? duration;

  /// 文件存储场景
  String? sceneName;

  NIMVoiceToTextParams(
      {this.voicePath,
      this.voiceUrl,
      this.mimeType,
      this.sampleRate,
      this.duration,
      this.sceneName});

  factory NIMVoiceToTextParams.fromJson(Map<String, dynamic> map) =>
      _$NIMVoiceToTextParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMVoiceToTextParamsToJson(this);
}
