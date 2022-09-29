// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avsignalling_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelBaseInfo _$ChannelBaseInfoFromJson(Map<String, dynamic> json) =>
    ChannelBaseInfo(
      channelName: json['channelName'] as String,
      channelId: json['channelId'] as String,
      channelExt: json['channelExt'] as String?,
      createTimestamp: json['createTimestamp'] as int,
      expireTimestamp: json['expireTimestamp'] as int,
      creatorAccountId: json['creatorAccountId'] as String,
      type: $enumDecode(_$ChannelTypeEnumMap, json['type']),
      channelStatus: $enumDecode(_$ChannelStatusEnumMap, json['channelStatus']),
    );

Map<String, dynamic> _$ChannelBaseInfoToJson(ChannelBaseInfo instance) =>
    <String, dynamic>{
      'channelName': instance.channelName,
      'channelId': instance.channelId,
      'type': _$ChannelTypeEnumMap[instance.type]!,
      'channelExt': instance.channelExt,
      'createTimestamp': instance.createTimestamp,
      'expireTimestamp': instance.expireTimestamp,
      'creatorAccountId': instance.creatorAccountId,
      'channelStatus': _$ChannelStatusEnumMap[instance.channelStatus]!,
    };

const _$ChannelTypeEnumMap = {
  ChannelType.audio: 'audio',
  ChannelType.video: 'video',
  ChannelType.custom: 'custom',
};

const _$ChannelStatusEnumMap = {
  ChannelStatus.normal: 'normal',
  ChannelStatus.invalid: 'invalid',
};

ChannelFullInfo _$ChannelFullInfoFromJson(Map<String, dynamic> json) =>
    ChannelFullInfo(
      channelBaseInfo: _channelBaseInfoFromJson(json['channelBaseInfo'] as Map),
      members: _memberListFromJson(json['members'] as List?),
    );

Map<String, dynamic> _$ChannelFullInfoToJson(ChannelFullInfo instance) =>
    <String, dynamic>{
      'channelBaseInfo': _channelBaseInfoToJson(instance.channelBaseInfo),
      'members': instance.members?.map((e) => e.toJson()).toList(),
    };

MemberInfo _$MemberInfoFromJson(Map<String, dynamic> json) => MemberInfo(
      accountId: json['accountId'] as String,
      uid: json['uid'] as int,
      joinTime: json['joinTime'] as int,
      expireTime: json['expireTime'] as int,
    );

Map<String, dynamic> _$MemberInfoToJson(MemberInfo instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'uid': instance.uid,
      'joinTime': instance.joinTime,
      'expireTime': instance.expireTime,
    };

InviteParam _$InviteParamFromJson(Map<String, dynamic> json) => InviteParam(
      channelId: json['channelId'] as String,
      accountId: json['accountId'] as String,
      requestId: json['requestId'] as String,
      customInfo: json['customInfo'] as String?,
      pushConfig: _signallingPushConfigFromJson(json['pushConfig'] as Map?),
      offlineEnabled: json['offlineEnabled'] as bool?,
    );

Map<String, dynamic> _$InviteParamToJson(InviteParam instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'accountId': instance.accountId,
      'requestId': instance.requestId,
      'customInfo': instance.customInfo,
      'pushConfig': instance.pushConfig?.toJson(),
      'offlineEnabled': instance.offlineEnabled,
    };

SignallingPushConfig _$SignallingPushConfigFromJson(
        Map<String, dynamic> json) =>
    SignallingPushConfig(
      needPush: json['needPush'] as bool,
      pushTitle: json['pushTitle'] as String?,
      pushContent: json['pushContent'] as String?,
      pushPayload: castPlatformMapToDartMap(json['pushPayload'] as Map?),
    );

Map<String, dynamic> _$SignallingPushConfigToJson(
        SignallingPushConfig instance) =>
    <String, dynamic>{
      'needPush': instance.needPush,
      'pushTitle': instance.pushTitle,
      'pushContent': instance.pushContent,
      'pushPayload': instance.pushPayload,
    };

CallParam _$CallParamFromJson(Map<String, dynamic> json) => CallParam(
      channelType: $enumDecode(_$ChannelTypeEnumMap, json['channelType']),
      requestId: json['requestId'] as String,
      accountId: json['accountId'] as String,
      channelName: json['channelName'] as String?,
      channelExt: json['channelExt'] as String?,
      selfUid: json['selfUid'] as int?,
      offlineEnable: json['offlineEnable'] as bool?,
      pushConfig: _signallingPushConfigFromJson(json['pushConfig'] as Map?),
      customInfo: json['customInfo'] as String?,
    );

Map<String, dynamic> _$CallParamToJson(CallParam instance) => <String, dynamic>{
      'channelType': _$ChannelTypeEnumMap[instance.channelType]!,
      'accountId': instance.accountId,
      'requestId': instance.requestId,
      'channelName': instance.channelName,
      'channelExt': instance.channelExt,
      'selfUid': instance.selfUid,
      'offlineEnable': instance.offlineEnable,
      'customInfo': instance.customInfo,
      'pushConfig': instance.pushConfig?.toJson(),
    };

SignallingEvent _$SignallingEventFromJson(Map<String, dynamic> json) =>
    SignallingEvent(
      channelBaseInfo: _channelBaseInfoFromJson(json['channelBaseInfo'] as Map),
      eventType: $enumDecode(_$SignallingEventTypeEnumMap, json['eventType']),
      fromAccountId: json['fromAccountId'] as String,
      time: json['time'] as int,
      customInfo: json['customInfo'] as String?,
    );

Map<String, dynamic> _$SignallingEventToJson(SignallingEvent instance) =>
    <String, dynamic>{
      'channelBaseInfo': _channelBaseInfoToJson(instance.channelBaseInfo),
      'fromAccountId': instance.fromAccountId,
      'customInfo': instance.customInfo,
      'eventType': _$SignallingEventTypeEnumMap[instance.eventType]!,
      'time': instance.time,
    };

const _$SignallingEventTypeEnumMap = {
  SignallingEventType.unKnow: 'unKnow',
  SignallingEventType.close: 'close',
  SignallingEventType.join: 'join',
  SignallingEventType.invite: 'invite',
  SignallingEventType.cancelInvite: 'cancelInvite',
  SignallingEventType.reject: 'reject',
  SignallingEventType.accept: 'accept',
  SignallingEventType.leave: 'leave',
  SignallingEventType.control: 'control',
};

ChannelCommonEvent _$ChannelCommonEventFromJson(Map<String, dynamic> json) =>
    ChannelCommonEvent(
      _signallingEventFromJson(json['signallingEvent'] as Map),
      requestId: json['requestId'] as String?,
      toAccountId: json['toAccountId'] as String?,
      ackStatus:
          $enumDecodeNullable(_$InviteAckStatusEnumMap, json['ackStatus']),
      pushConfig: _signallingPushConfigFromJson(json['pushConfig'] as Map?),
      joinMember: _memberInfoFromJson(json['joinMember'] as Map?),
    );

Map<String, dynamic> _$ChannelCommonEventToJson(ChannelCommonEvent instance) =>
    <String, dynamic>{
      'toAccountId': instance.toAccountId,
      'requestId': instance.requestId,
      'ackStatus': _$InviteAckStatusEnumMap[instance.ackStatus],
      'pushConfig': instance.pushConfig?.toJson(),
      'joinMember': instance.joinMember?.toJson(),
      'signallingEvent': instance.signallingEvent.toJson(),
    };

const _$InviteAckStatusEnumMap = {
  InviteAckStatus.reject: 'reject',
  InviteAckStatus.accept: 'accept',
};

SyncChannelEvent _$SyncChannelEventFromJson(Map<String, dynamic> json) =>
    SyncChannelEvent(
      _channelFullInfoFromJson(json['channelFullInfo'] as Map),
    );

Map<String, dynamic> _$SyncChannelEventToJson(SyncChannelEvent instance) =>
    <String, dynamic>{
      'channelFullInfo': instance.channelFullInfo.toJson(),
    };
