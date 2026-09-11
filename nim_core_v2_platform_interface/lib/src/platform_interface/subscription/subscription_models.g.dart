// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMUserStatus _$NIMUserStatusFromJson(Map<String, dynamic> json) =>
    NIMUserStatus(
      accountId: json['accountId'] as String,
      clientType: $enumDecode(_$NIMClientTypeEnumMap, json['clientType'],
          unknownValue: NIMClientType.unknown),
      statusType: (json['statusType'] as num?)?.toInt(),
      publishTime: (json['publishTime'] as num).toInt(),
      uniqueId: json['uniqueId'] as String,
      extension: json['extension'] as String?,
      serverExtension: json['serverExtension'] as String?,
    );

Map<String, dynamic> _$NIMUserStatusToJson(NIMUserStatus instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'clientType': _$NIMClientTypeEnumMap[instance.clientType]!,
      'statusType': instance.statusType,
      'publishTime': instance.publishTime,
      'uniqueId': instance.uniqueId,
      'extension': instance.extension,
      'serverExtension': instance.serverExtension,
    };

const _$NIMClientTypeEnumMap = {
  NIMClientType.unknown: 'unknown',
  NIMClientType.android: 'android',
  NIMClientType.ios: 'ios',
  NIMClientType.windows: 'windows',
  NIMClientType.wp: 'wp',
  NIMClientType.web: 'web',
  NIMClientType.rest: 'rest',
  NIMClientType.macos: 'macos',
};

NIMCustomUserStatusPublishResult _$NIMCustomUserStatusPublishResultFromJson(
        Map<String, dynamic> json) =>
    NIMCustomUserStatusPublishResult(
      uniqueId: json['uniqueId'] as String,
      serverId: json['serverId'] as String?,
      publishTime: (json['publishTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMCustomUserStatusPublishResultToJson(
        NIMCustomUserStatusPublishResult instance) =>
    <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'serverId': instance.serverId,
      'publishTime': instance.publishTime,
    };

NIMUserStatusSubscribeResult _$NIMUserStatusSubscribeResultFromJson(
        Map<String, dynamic> json) =>
    NIMUserStatusSubscribeResult(
      accountId: json['accountId'] as String,
      duration: (json['duration'] as num?)?.toInt(),
      subscribeTime: (json['subscribeTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMUserStatusSubscribeResultToJson(
        NIMUserStatusSubscribeResult instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'duration': instance.duration,
      'subscribeTime': instance.subscribeTime,
    };

NIMSubscribeUserStatusOption _$NIMSubscribeUserStatusOptionFromJson(
        Map<String, dynamic> json) =>
    NIMSubscribeUserStatusOption(
      accountIds: (json['accountIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      duration: (json['duration'] as num?)?.toInt(),
      immediateSync: json['immediateSync'] as bool?,
    );

Map<String, dynamic> _$NIMSubscribeUserStatusOptionToJson(
        NIMSubscribeUserStatusOption instance) =>
    <String, dynamic>{
      'accountIds': instance.accountIds,
      'duration': instance.duration,
      'immediateSync': instance.immediateSync,
    };

NIMUnsubscribeUserStatusOption _$NIMUnsubscribeUserStatusOptionFromJson(
        Map<String, dynamic> json) =>
    NIMUnsubscribeUserStatusOption(
      accountIds: (json['accountIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$NIMUnsubscribeUserStatusOptionToJson(
        NIMUnsubscribeUserStatusOption instance) =>
    <String, dynamic>{
      'accountIds': instance.accountIds,
    };

NIMCustomUserStatusParams _$NIMCustomUserStatusParamsFromJson(
        Map<String, dynamic> json) =>
    NIMCustomUserStatusParams(
      statusType: (json['statusType'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      extension: json['extension'] as String?,
      onlineOnly: json['onlineOnly'] as bool?,
      multiSync: json['multiSync'] as bool?,
    );

Map<String, dynamic> _$NIMCustomUserStatusParamsToJson(
        NIMCustomUserStatusParams instance) =>
    <String, dynamic>{
      'statusType': instance.statusType,
      'duration': instance.duration,
      'extension': instance.extension,
      'onlineOnly': instance.onlineOnly,
      'multiSync': instance.multiSync,
    };
