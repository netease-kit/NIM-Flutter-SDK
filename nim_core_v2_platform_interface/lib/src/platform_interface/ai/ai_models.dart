// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import '../../../nim_core_v2_platform_interface.dart';

part 'ai_models.g.dart';

@JsonSerializable(explicitToJson: true)
class NIMAIUser extends NIMUserInfo {
  ///大模型类型
  @Deprecated('use aiModelType instead')
  @JsonKey(unknownEnumValue: NIMAIModelType.nimAiModelTypeUKnown)
  NIMAIModelType? modelType;

  /// 获取大模型类型
  /// 	 * 0: 未知
  /// 	 * 1: 通义千问
  /// 	 * 2: 微软Azure
  /// 	 * 3: 私有本地大模型
  int? aiModelType;

  ///大模型配置
  @JsonKey(fromJson: _nimAIModelConfigFromJson)
  NIMAIModelConfig? modelConfig;

  NIMAIUser(
      {this.modelType,
      this.modelConfig,
      this.aiModelType,
      String? accountId,
      String? name,
      String? avatar,
      String? sign,
      int? gender,
      String? email,
      String? birthday,
      String? mobile,
      String? serverExtension,
      int? createTime,
      int? updateTime})
      : super(
            accountId: accountId,
            name: name,
            avatar: avatar,
            sign: sign,
            gender: gender,
            email: email,
            birthday: birthday,
            mobile: mobile,
            serverExtension: serverExtension,
            createTime: createTime,
            updateTime: updateTime);

  Map<String, dynamic> toJson() => _$NIMAIUserToJson(this);

  factory NIMAIUser.fromJson(Map<String, dynamic> map) =>
      _$NIMAIUserFromJson(map);
}

NIMAIModelConfig? _nimAIModelConfigFromJson(Map? map) {
  if (map != null) {
    return NIMAIModelConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

enum NIMAIModelType {
  /// 未知
  @JsonValue(0)
  nimAiModelTypeUKnown,

  /// 通义千问
  @JsonValue(1)
  nimAiModelTypeQwen,

  /// 微软Azure
  @JsonValue(2)
  nimAiModelTypeAzure,

  /// 私有本地大模型
  @JsonValue(3)
  nimAiModelTypePrivate;
}

NIMAIModelStreamCallChunk? NIMAIModelStreamCallChunkFromJson(Map? map) {
  if (map != null) {
    return NIMAIModelStreamCallChunk.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///代理请求响应的流式分片信息。
@JsonSerializable(explicitToJson: true)
class NIMAIModelStreamCallChunk {
  ///数字人流式回复分片文本
  String? content;

  ///数字人流式回复当前分片时间
  int? chunkTime;

  ///类型，当前仅支持0表示文本
  int type = 0;

  ///分片序号，从0开始
  int index = 0;

  NIMAIModelStreamCallChunk(
      {this.content, this.chunkTime, this.type = 0, this.index = 0});

  factory NIMAIModelStreamCallChunk.fromJson(Map<String, dynamic> map) =>
      _$NIMAIModelStreamCallChunkFromJson(map);

  Map<String, dynamic> toJson() => _$NIMAIModelStreamCallChunkToJson(this);
}

///代理请求响应的流式回复内容。
@JsonSerializable(explicitToJson: true)
class NIMAIModelStreamCallContent {
  ///数字人流式回复分片组装好后的文本
  String? msg;

  ///类型，当前仅支持0表示文本
  int type = 0;

  ///数字人流式回复最近一个分片
  @JsonKey(fromJson: NIMAIModelStreamCallChunkFromJson)
  NIMAIModelStreamCallChunk? lastChunk;

  NIMAIModelStreamCallContent({this.msg, this.type = 0, this.lastChunk});

  factory NIMAIModelStreamCallContent.fromJson(Map<String, dynamic> map) =>
      _$NIMAIModelStreamCallContentFromJson(map);

  Map<String, dynamic> toJson() => _$NIMAIModelStreamCallContentToJson(this);
}

///数字人请求代理接口的流式回复的结构体。
@JsonSerializable(explicitToJson: true)
class NIMAIModelStreamCallResult {
  ///AI 响应的状态码。
  ///默认值为200，表示请求成功。
  int code = 200;

  ///获取数字人的 accountId。
  ///这是数字人唯一的标识符。
  String accountId;

  ///获取本次响应的标识。
  ///每次请求都会生成一个唯一的 requestId，用于追踪请求和响应。
  String requestId;

  ///请求 AI 的回复内容。
  ///这个对象包含了流式回复的具体内容。
  @JsonKey(fromJson: NIMAIModelStreamCallContentFromJson)
  NIMAIModelStreamCallContent? content;

  ///获取数字人回复内容的引用资源列表。
  ///这些资源可能包含图片、音频等多媒体信息。
  @JsonKey(fromJson: NIMAIRAGInfoListFromJson)
  List<NIMAIRAGInfo>? aiRAGs;

  ///获取分片的时间戳。
  ///表示该分片生成的时间点。
  int? timestamp;

  NIMAIModelStreamCallResult(
      {this.code = 200,
      required this.accountId,
      required this.requestId,
      this.content,
      this.aiRAGs,
      this.timestamp});

  factory NIMAIModelStreamCallResult.fromJson(Map<String, dynamic> map) =>
      _$NIMAIModelStreamCallResultFromJson(map);

  Map<String, dynamic> toJson() => _$NIMAIModelStreamCallResultToJson(this);
}

NIMAIModelStreamCallContent? NIMAIModelStreamCallContentFromJson(Map? map) {
  if (map != null) {
    return NIMAIModelStreamCallContent.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///停止数字人代理请求的 AI 流式回复参数。
@JsonSerializable(explicitToJson: true)
class NIMAIModelStreamCallStopParams {
  ///机器人账号ID，AIUser对应的账号ID
  String accountId;

  ///请求id
  String requestId;

  NIMAIModelStreamCallStopParams(
      {required this.accountId, required this.requestId});

  factory NIMAIModelStreamCallStopParams.fromJson(Map<String, dynamic> map) =>
      _$NIMAIModelStreamCallStopParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMAIModelStreamCallStopParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMCreateUserAIBotParams {
  /// Bot 的账号 ID，需全局唯一
  String? accid;

  /// Bot 的昵称
  String? name;

  /// Bot 的头像 URL
  String? icon;

  /// Bot 的个性签名
  String? sign;

  /// 扩展字段
  String? ex;

  V2NIMCreateUserAIBotParams({
    this.accid,
    this.name,
    this.icon,
    this.sign,
    this.ex,
  });

  factory V2NIMCreateUserAIBotParams.fromJson(Map<String, dynamic> map) =>
      _$V2NIMCreateUserAIBotParamsFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMCreateUserAIBotParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMUpdateUserAIBotParams {
  /// 需要更新的 Bot 账号 ID
  String? accid;

  /// 新的昵称
  String? name;

  /// 新的头像 URL
  String? icon;

  /// 新的个性签名
  String? sign;

  /// 新的扩展字段
  String? ex;

  V2NIMUpdateUserAIBotParams({
    this.accid,
    this.name,
    this.icon,
    this.sign,
    this.ex,
  });

  factory V2NIMUpdateUserAIBotParams.fromJson(Map<String, dynamic> map) =>
      _$V2NIMUpdateUserAIBotParamsFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMUpdateUserAIBotParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMDeleteUserAIBotParams {
  /// 需要删除的 Bot 账号 ID
  String? accid;

  V2NIMDeleteUserAIBotParams({this.accid});

  factory V2NIMDeleteUserAIBotParams.fromJson(Map<String, dynamic> map) =>
      _$V2NIMDeleteUserAIBotParamsFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMDeleteUserAIBotParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMGetUserAIBotParams {
  /// 需要查询的 Bot 账号 ID
  String? accid;

  V2NIMGetUserAIBotParams({this.accid});

  factory V2NIMGetUserAIBotParams.fromJson(Map<String, dynamic> map) =>
      _$V2NIMGetUserAIBotParamsFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMGetUserAIBotParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMGetUserAIBotListParams {
  /// 分页标记，首次查询不传，后续翻页传上一次响应的 nextToken
  String? pageToken;

  /// 每页返回的数量
  int? limit;

  V2NIMGetUserAIBotListParams({this.pageToken, this.limit});

  factory V2NIMGetUserAIBotListParams.fromJson(Map<String, dynamic> map) =>
      _$V2NIMGetUserAIBotListParamsFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMGetUserAIBotListParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMBindUserAIBotToQrCodeParams {
  /// Bot 的账号 ID
  String? accid;

  /// Bot 的登录密钥
  String? token;

  /// 二维码标识，UUID，有效期 300 秒
  String? qrCode;

  V2NIMBindUserAIBotToQrCodeParams({
    this.accid,
    this.token,
    this.qrCode,
  });

  factory V2NIMBindUserAIBotToQrCodeParams.fromJson(Map<String, dynamic> map) =>
      _$V2NIMBindUserAIBotToQrCodeParamsFromJson(map);

  Map<String, dynamic> toJson() =>
      _$V2NIMBindUserAIBotToQrCodeParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMRefreshUserAIBotTokenParams {
  /// 需要刷新的 Bot 账号 ID
  String? accid;

  V2NIMRefreshUserAIBotTokenParams({this.accid});

  factory V2NIMRefreshUserAIBotTokenParams.fromJson(Map<String, dynamic> map) =>
      _$V2NIMRefreshUserAIBotTokenParamsFromJson(map);

  Map<String, dynamic> toJson() =>
      _$V2NIMRefreshUserAIBotTokenParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMUserAIBot {
  /// Bot 的账号 ID
  String? accid;

  /// 应用 ID
  int? appid;

  /// Bot 的昵称
  String? name;

  /// Bot 的头像
  String? icon;

  /// Bot 的个性签名
  String? sign;

  /// 性别
  int? gender;

  /// 邮箱
  String? email;

  /// 生日
  String? birth;

  /// 手机号
  String? mobile;

  /// 扩展字段
  String? ex;

  /// 类型
  int? type;

  /// 模型配置，JSON 字符串
  String? modelConfig;

  /// 云信配置，JSON 字符串
  String? yunxinConfig;

  /// 有效标志
  int? validFlag;

  /// 创建时间，Unix 时间戳，毫秒
  int? createTime;

  /// 更新时间，Unix 时间戳，毫秒
  int? updateTime;

  /// 业务类型
  int? business;

  /// 等级：1 应用级，2 用户级
  int? level;

  /// 所有者 ID
  String? ownerid;

  /// 登录密钥
  String? token;

  V2NIMUserAIBot({
    this.accid,
    this.appid,
    this.name,
    this.icon,
    this.sign,
    this.gender,
    this.email,
    this.birth,
    this.mobile,
    this.ex,
    this.type,
    this.modelConfig,
    this.yunxinConfig,
    this.validFlag,
    this.createTime,
    this.updateTime,
    this.business,
    this.level,
    this.ownerid,
    this.token,
  });

  factory V2NIMUserAIBot.fromJson(Map<String, dynamic> map) =>
      _$V2NIMUserAIBotFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMUserAIBotToJson(this);
}

V2NIMUserAIBot? v2NIMUserAIBotFromJson(Map? map) {
  if (map != null) {
    return V2NIMUserAIBot.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

List<V2NIMUserAIBot>? v2NIMUserAIBotListFromJson(List? list) {
  return list
      ?.map((e) => V2NIMUserAIBot.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

@JsonSerializable(explicitToJson: true)
class V2NIMCreateUserAIBotResult {
  /// 该 Bot 的登录密钥，用于后续以机器人账号身份登录
  String? token;

  V2NIMCreateUserAIBotResult({this.token});

  factory V2NIMCreateUserAIBotResult.fromJson(Map<String, dynamic> map) =>
      _$V2NIMCreateUserAIBotResultFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMCreateUserAIBotResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMGetUserAIBotListResult {
  /// Bot 账号信息列表
  @JsonKey(fromJson: v2NIMUserAIBotListFromJson)
  List<V2NIMUserAIBot>? bots;

  /// 是否还有更多数据
  bool? hasMore;

  /// 下一页的分页标记
  String? nextToken;

  V2NIMGetUserAIBotListResult({
    this.bots,
    this.hasMore,
    this.nextToken,
  });

  factory V2NIMGetUserAIBotListResult.fromJson(Map<String, dynamic> map) =>
      _$V2NIMGetUserAIBotListResultFromJson(map);

  Map<String, dynamic> toJson() => _$V2NIMGetUserAIBotListResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class V2NIMRefreshUserAIBotTokenResult {
  /// 刷新后的新登录密钥，旧 token 立即失效
  String? token;

  V2NIMRefreshUserAIBotTokenResult({this.token});

  factory V2NIMRefreshUserAIBotTokenResult.fromJson(Map<String, dynamic> map) =>
      _$V2NIMRefreshUserAIBotTokenResultFromJson(map);

  Map<String, dynamic> toJson() =>
      _$V2NIMRefreshUserAIBotTokenResultToJson(this);
}
