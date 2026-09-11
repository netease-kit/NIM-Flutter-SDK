// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMAIUser _$NIMAIUserFromJson(Map<String, dynamic> json) => NIMAIUser(
      modelType: $enumDecodeNullable(_$NIMAIModelTypeEnumMap, json['modelType'],
          unknownValue: NIMAIModelType.nimAiModelTypeUKnown),
      modelConfig: _nimAIModelConfigFromJson(json['modelConfig'] as Map?),
      aiModelType: (json['aiModelType'] as num?)?.toInt(),
      accountId: json['accountId'] as String?,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      sign: json['sign'] as String?,
      gender: (json['gender'] as num?)?.toInt(),
      email: json['email'] as String?,
      birthday: json['birthday'] as String?,
      mobile: json['mobile'] as String?,
      serverExtension: json['serverExtension'] as String?,
      createTime: (json['createTime'] as num?)?.toInt(),
      updateTime: (json['updateTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMAIUserToJson(NIMAIUser instance) => <String, dynamic>{
      'accountId': instance.accountId,
      'name': instance.name,
      'avatar': instance.avatar,
      'sign': instance.sign,
      'gender': instance.gender,
      'email': instance.email,
      'birthday': instance.birthday,
      'mobile': instance.mobile,
      'serverExtension': instance.serverExtension,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'modelType': _$NIMAIModelTypeEnumMap[instance.modelType],
      'aiModelType': instance.aiModelType,
      'modelConfig': instance.modelConfig?.toJson(),
    };

const _$NIMAIModelTypeEnumMap = {
  NIMAIModelType.nimAiModelTypeUKnown: 0,
  NIMAIModelType.nimAiModelTypeQwen: 1,
  NIMAIModelType.nimAiModelTypeAzure: 2,
  NIMAIModelType.nimAiModelTypePrivate: 3,
};

NIMAIModelStreamCallChunk _$NIMAIModelStreamCallChunkFromJson(
        Map<String, dynamic> json) =>
    NIMAIModelStreamCallChunk(
      content: json['content'] as String?,
      chunkTime: (json['chunkTime'] as num?)?.toInt(),
      type: (json['type'] as num?)?.toInt() ?? 0,
      index: (json['index'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$NIMAIModelStreamCallChunkToJson(
        NIMAIModelStreamCallChunk instance) =>
    <String, dynamic>{
      'content': instance.content,
      'chunkTime': instance.chunkTime,
      'type': instance.type,
      'index': instance.index,
    };

NIMAIModelStreamCallContent _$NIMAIModelStreamCallContentFromJson(
        Map<String, dynamic> json) =>
    NIMAIModelStreamCallContent(
      msg: json['msg'] as String?,
      type: (json['type'] as num?)?.toInt() ?? 0,
      lastChunk: NIMAIModelStreamCallChunkFromJson(json['lastChunk'] as Map?),
    );

Map<String, dynamic> _$NIMAIModelStreamCallContentToJson(
        NIMAIModelStreamCallContent instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'type': instance.type,
      'lastChunk': instance.lastChunk?.toJson(),
    };

NIMAIModelStreamCallResult _$NIMAIModelStreamCallResultFromJson(
        Map<String, dynamic> json) =>
    NIMAIModelStreamCallResult(
      code: (json['code'] as num?)?.toInt() ?? 200,
      accountId: json['accountId'] as String,
      requestId: json['requestId'] as String,
      content: NIMAIModelStreamCallContentFromJson(json['content'] as Map?),
      aiRAGs: NIMAIRAGInfoListFromJson(json['aiRAGs'] as List?),
      timestamp: (json['timestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMAIModelStreamCallResultToJson(
        NIMAIModelStreamCallResult instance) =>
    <String, dynamic>{
      'code': instance.code,
      'accountId': instance.accountId,
      'requestId': instance.requestId,
      'content': instance.content?.toJson(),
      'aiRAGs': instance.aiRAGs?.map((e) => e.toJson()).toList(),
      'timestamp': instance.timestamp,
    };

NIMAIModelStreamCallStopParams _$NIMAIModelStreamCallStopParamsFromJson(
        Map<String, dynamic> json) =>
    NIMAIModelStreamCallStopParams(
      accountId: json['accountId'] as String,
      requestId: json['requestId'] as String,
    );

Map<String, dynamic> _$NIMAIModelStreamCallStopParamsToJson(
        NIMAIModelStreamCallStopParams instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'requestId': instance.requestId,
    };

V2NIMCreateUserAIBotParams _$V2NIMCreateUserAIBotParamsFromJson(
        Map<String, dynamic> json) =>
    V2NIMCreateUserAIBotParams(
      accid: json['accid'] as String?,
      name: json['name'] as String?,
      icon: json['icon'] as String?,
      sign: json['sign'] as String?,
      ex: json['ex'] as String?,
    );

Map<String, dynamic> _$V2NIMCreateUserAIBotParamsToJson(
        V2NIMCreateUserAIBotParams instance) =>
    <String, dynamic>{
      'accid': instance.accid,
      'name': instance.name,
      'icon': instance.icon,
      'sign': instance.sign,
      'ex': instance.ex,
    };

V2NIMUpdateUserAIBotParams _$V2NIMUpdateUserAIBotParamsFromJson(
        Map<String, dynamic> json) =>
    V2NIMUpdateUserAIBotParams(
      accid: json['accid'] as String?,
      name: json['name'] as String?,
      icon: json['icon'] as String?,
      sign: json['sign'] as String?,
      ex: json['ex'] as String?,
    );

Map<String, dynamic> _$V2NIMUpdateUserAIBotParamsToJson(
        V2NIMUpdateUserAIBotParams instance) =>
    <String, dynamic>{
      'accid': instance.accid,
      'name': instance.name,
      'icon': instance.icon,
      'sign': instance.sign,
      'ex': instance.ex,
    };

V2NIMDeleteUserAIBotParams _$V2NIMDeleteUserAIBotParamsFromJson(
        Map<String, dynamic> json) =>
    V2NIMDeleteUserAIBotParams(
      accid: json['accid'] as String?,
    );

Map<String, dynamic> _$V2NIMDeleteUserAIBotParamsToJson(
        V2NIMDeleteUserAIBotParams instance) =>
    <String, dynamic>{
      'accid': instance.accid,
    };

V2NIMGetUserAIBotParams _$V2NIMGetUserAIBotParamsFromJson(
        Map<String, dynamic> json) =>
    V2NIMGetUserAIBotParams(
      accid: json['accid'] as String?,
    );

Map<String, dynamic> _$V2NIMGetUserAIBotParamsToJson(
        V2NIMGetUserAIBotParams instance) =>
    <String, dynamic>{
      'accid': instance.accid,
    };

V2NIMGetUserAIBotListParams _$V2NIMGetUserAIBotListParamsFromJson(
        Map<String, dynamic> json) =>
    V2NIMGetUserAIBotListParams(
      pageToken: json['pageToken'] as String?,
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$V2NIMGetUserAIBotListParamsToJson(
        V2NIMGetUserAIBotListParams instance) =>
    <String, dynamic>{
      'pageToken': instance.pageToken,
      'limit': instance.limit,
    };

V2NIMBindUserAIBotToQrCodeParams _$V2NIMBindUserAIBotToQrCodeParamsFromJson(
        Map<String, dynamic> json) =>
    V2NIMBindUserAIBotToQrCodeParams(
      accid: json['accid'] as String?,
      token: json['token'] as String?,
      qrCode: json['qrCode'] as String?,
    );

Map<String, dynamic> _$V2NIMBindUserAIBotToQrCodeParamsToJson(
        V2NIMBindUserAIBotToQrCodeParams instance) =>
    <String, dynamic>{
      'accid': instance.accid,
      'token': instance.token,
      'qrCode': instance.qrCode,
    };

V2NIMRefreshUserAIBotTokenParams _$V2NIMRefreshUserAIBotTokenParamsFromJson(
        Map<String, dynamic> json) =>
    V2NIMRefreshUserAIBotTokenParams(
      accid: json['accid'] as String?,
    );

Map<String, dynamic> _$V2NIMRefreshUserAIBotTokenParamsToJson(
        V2NIMRefreshUserAIBotTokenParams instance) =>
    <String, dynamic>{
      'accid': instance.accid,
    };

V2NIMUserAIBot _$V2NIMUserAIBotFromJson(Map<String, dynamic> json) =>
    V2NIMUserAIBot(
      accid: json['accid'] as String?,
      appid: (json['appid'] as num?)?.toInt(),
      name: json['name'] as String?,
      icon: json['icon'] as String?,
      sign: json['sign'] as String?,
      gender: (json['gender'] as num?)?.toInt(),
      email: json['email'] as String?,
      birth: json['birth'] as String?,
      mobile: json['mobile'] as String?,
      ex: json['ex'] as String?,
      type: (json['type'] as num?)?.toInt(),
      modelConfig: json['modelConfig'] as String?,
      yunxinConfig: json['yunxinConfig'] as String?,
      validFlag: (json['validFlag'] as num?)?.toInt(),
      createTime: (json['createTime'] as num?)?.toInt(),
      updateTime: (json['updateTime'] as num?)?.toInt(),
      business: (json['business'] as num?)?.toInt(),
      level: (json['level'] as num?)?.toInt(),
      ownerid: json['ownerid'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$V2NIMUserAIBotToJson(V2NIMUserAIBot instance) =>
    <String, dynamic>{
      'accid': instance.accid,
      'appid': instance.appid,
      'name': instance.name,
      'icon': instance.icon,
      'sign': instance.sign,
      'gender': instance.gender,
      'email': instance.email,
      'birth': instance.birth,
      'mobile': instance.mobile,
      'ex': instance.ex,
      'type': instance.type,
      'modelConfig': instance.modelConfig,
      'yunxinConfig': instance.yunxinConfig,
      'validFlag': instance.validFlag,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'business': instance.business,
      'level': instance.level,
      'ownerid': instance.ownerid,
      'token': instance.token,
    };

V2NIMCreateUserAIBotResult _$V2NIMCreateUserAIBotResultFromJson(
        Map<String, dynamic> json) =>
    V2NIMCreateUserAIBotResult(
      token: json['token'] as String?,
    );

Map<String, dynamic> _$V2NIMCreateUserAIBotResultToJson(
        V2NIMCreateUserAIBotResult instance) =>
    <String, dynamic>{
      'token': instance.token,
    };

V2NIMGetUserAIBotListResult _$V2NIMGetUserAIBotListResultFromJson(
        Map<String, dynamic> json) =>
    V2NIMGetUserAIBotListResult(
      bots: v2NIMUserAIBotListFromJson(json['bots'] as List?),
      hasMore: json['hasMore'] as bool?,
      nextToken: json['nextToken'] as String?,
    );

Map<String, dynamic> _$V2NIMGetUserAIBotListResultToJson(
        V2NIMGetUserAIBotListResult instance) =>
    <String, dynamic>{
      'bots': instance.bots?.map((e) => e.toJson()).toList(),
      'hasMore': instance.hasMore,
      'nextToken': instance.nextToken,
    };

V2NIMRefreshUserAIBotTokenResult _$V2NIMRefreshUserAIBotTokenResultFromJson(
        Map<String, dynamic> json) =>
    V2NIMRefreshUserAIBotTokenResult(
      token: json['token'] as String?,
    );

Map<String, dynamic> _$V2NIMRefreshUserAIBotTokenResultToJson(
        V2NIMRefreshUserAIBotTokenResult instance) =>
    <String, dynamic>{
      'token': instance.token,
    };
