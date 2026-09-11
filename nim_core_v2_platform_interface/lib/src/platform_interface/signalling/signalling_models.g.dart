// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signalling_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMSignallingCallParams _$NIMSignallingCallParamsFromJson(
        Map<String, dynamic> json) =>
    NIMSignallingCallParams(
      calleeAccountId: json['calleeAccountId'] as String,
      requestId: json['requestId'] as String,
      channelType:
          $enumDecode(_$NIMSignallingChannelTypeEnumMap, json['channelType']),
      channelName: json['channelName'] as String?,
      channelExtension: json['channelExtension'] as String?,
      serverExtension: json['serverExtension'] as String?,
      signallingConfig:
          _NIMSignallingConfigFromJson(json['signallingConfig'] as Map?),
      pushConfig: _NIMSignallingPushConfigFromJson(json['pushConfig'] as Map?),
      rtcConfig: _NIMSignallingRtcConfigFromJson(json['rtcConfig'] as Map?),
    );

Map<String, dynamic> _$NIMSignallingCallParamsToJson(
        NIMSignallingCallParams instance) =>
    <String, dynamic>{
      'calleeAccountId': instance.calleeAccountId,
      'requestId': instance.requestId,
      'channelType': _$NIMSignallingChannelTypeEnumMap[instance.channelType]!,
      'channelName': instance.channelName,
      'channelExtension': instance.channelExtension,
      'serverExtension': instance.serverExtension,
      'signallingConfig': instance.signallingConfig?.toJson(),
      'pushConfig': instance.pushConfig?.toJson(),
      'rtcConfig': instance.rtcConfig?.toJson(),
    };

const _$NIMSignallingChannelTypeEnumMap = {
  NIMSignallingChannelType.nimSignallingChannelTypeAudio: 1,
  NIMSignallingChannelType.nimSignallingChannelTypeVideo: 2,
  NIMSignallingChannelType.nimSignallingChannelTypeCustom: 3,
};

NIMSignallingConfig _$NIMSignallingConfigFromJson(Map<String, dynamic> json) =>
    NIMSignallingConfig(
      offlineEnabled: json['offlineEnabled'] as bool? ?? true,
      unreadEnabled: json['unreadEnabled'] as bool? ?? true,
      selfUid: (json['selfUid'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMSignallingConfigToJson(
        NIMSignallingConfig instance) =>
    <String, dynamic>{
      'offlineEnabled': instance.offlineEnabled,
      'unreadEnabled': instance.unreadEnabled,
      'selfUid': instance.selfUid,
    };

NIMSignallingPushConfig _$NIMSignallingPushConfigFromJson(
        Map<String, dynamic> json) =>
    NIMSignallingPushConfig(
      pushEnabled: json['pushEnabled'] as bool?,
      pushTitle: json['pushTitle'] as String?,
      pushContent: json['pushContent'] as String?,
      pushPayload: json['pushPayload'] as String?,
    );

Map<String, dynamic> _$NIMSignallingPushConfigToJson(
        NIMSignallingPushConfig instance) =>
    <String, dynamic>{
      'pushEnabled': instance.pushEnabled,
      'pushTitle': instance.pushTitle,
      'pushContent': instance.pushContent,
      'pushPayload': instance.pushPayload,
    };

NIMSignallingRtcConfig _$NIMSignallingRtcConfigFromJson(
        Map<String, dynamic> json) =>
    NIMSignallingRtcConfig(
      rtcChannelName: json['rtcChannelName'] as String?,
      rtcTokenTtl: (json['rtcTokenTtl'] as num?)?.toInt(),
      rtcParams: json['rtcParams'] as String?,
    );

Map<String, dynamic> _$NIMSignallingRtcConfigToJson(
        NIMSignallingRtcConfig instance) =>
    <String, dynamic>{
      'rtcChannelName': instance.rtcChannelName,
      'rtcTokenTtl': instance.rtcTokenTtl,
      'rtcParams': instance.rtcParams,
    };

NIMSignallingCallResult _$NIMSignallingCallResultFromJson(
        Map<String, dynamic> json) =>
    NIMSignallingCallResult(
      roomInfo: _NIMSignallingRoomInfoFromJson(json['roomInfo'] as Map?),
      rtcInfo: _NIMSignallingRtcInfoFromJson(json['rtcInfo'] as Map?),
      callStatus: (json['callStatus'] as num).toInt(),
    );

Map<String, dynamic> _$NIMSignallingCallResultToJson(
        NIMSignallingCallResult instance) =>
    <String, dynamic>{
      'roomInfo': instance.roomInfo?.toJson(),
      'rtcInfo': instance.rtcInfo?.toJson(),
      'callStatus': instance.callStatus,
    };

NIMSignallingRtcInfo _$NIMSignallingRtcInfoFromJson(
        Map<String, dynamic> json) =>
    NIMSignallingRtcInfo(
      rtcToken: json['rtcToken'] as String,
      rtcTokenTtl: (json['rtcTokenTtl'] as num?)?.toInt(),
      rtcParams: json['rtcParams'] as String?,
    );

Map<String, dynamic> _$NIMSignallingRtcInfoToJson(
        NIMSignallingRtcInfo instance) =>
    <String, dynamic>{
      'rtcToken': instance.rtcToken,
      'rtcTokenTtl': instance.rtcTokenTtl,
      'rtcParams': instance.rtcParams,
    };

NIMSignallingCallSetupParams _$NIMSignallingCallSetupParamsFromJson(
        Map<String, dynamic> json) =>
    NIMSignallingCallSetupParams(
      channelId: json['channelId'] as String,
      callerAccountId: json['callerAccountId'] as String,
      requestId: json['requestId'] as String,
      serverExtension: json['serverExtension'] as String?,
      signallingConfig:
          _NIMSignallingConfigFromJson(json['signallingConfig'] as Map?),
      rtcConfig: _NIMSignallingRtcConfigFromJson(json['rtcConfig'] as Map?),
    );

Map<String, dynamic> _$NIMSignallingCallSetupParamsToJson(
        NIMSignallingCallSetupParams instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'callerAccountId': instance.callerAccountId,
      'requestId': instance.requestId,
      'serverExtension': instance.serverExtension,
      'signallingConfig': instance.signallingConfig?.toJson(),
      'rtcConfig': instance.rtcConfig?.toJson(),
    };

NIMSignallingCallSetupResult _$NIMSignallingCallSetupResultFromJson(
        Map<String, dynamic> json) =>
    NIMSignallingCallSetupResult(
      roomInfo: _NIMSignallingRoomInfoFromJson(json['roomInfo'] as Map?),
      rtcInfo: _NIMSignallingRtcInfoFromJson(json['rtcInfo'] as Map?),
      callStatus: (json['callStatus'] as num).toInt(),
    );

Map<String, dynamic> _$NIMSignallingCallSetupResultToJson(
        NIMSignallingCallSetupResult instance) =>
    <String, dynamic>{
      'roomInfo': instance.roomInfo?.toJson(),
      'rtcInfo': instance.rtcInfo?.toJson(),
      'callStatus': instance.callStatus,
    };

NIMSignallingChannelInfo _$NIMSignallingChannelInfoFromJson(
        Map<String, dynamic> json) =>
    NIMSignallingChannelInfo(
      channelName: json['channelName'] as String?,
      channelId: json['channelId'] as String,
      channelType:
          $enumDecode(_$NIMSignallingChannelTypeEnumMap, json['channelType']),
      channelExtension: json['channelExtension'] as String?,
      createTime: (json['createTime'] as num?)?.toInt(),
      expireTime: (json['expireTime'] as num?)?.toInt(),
      creatorAccountId: json['creatorAccountId'] as String,
    );

Map<String, dynamic> _$NIMSignallingChannelInfoToJson(
        NIMSignallingChannelInfo instance) =>
    <String, dynamic>{
      'channelName': instance.channelName,
      'channelId': instance.channelId,
      'channelType': _$NIMSignallingChannelTypeEnumMap[instance.channelType]!,
      'channelExtension': instance.channelExtension,
      'createTime': instance.createTime,
      'expireTime': instance.expireTime,
      'creatorAccountId': instance.creatorAccountId,
    };

NIMSignallingJoinParams _$NIMSignallingJoinParamsFromJson(
        Map<String, dynamic> json) =>
    NIMSignallingJoinParams(
      channelId: json['channelId'] as String,
      serverExtension: json['serverExtension'] as String?,
      signallingConfig:
          _NIMSignallingConfigFromJson(json['signallingConfig'] as Map?),
      rtcConfig: _NIMSignallingRtcConfigFromJson(json['rtcConfig'] as Map?),
    );

Map<String, dynamic> _$NIMSignallingJoinParamsToJson(
        NIMSignallingJoinParams instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'serverExtension': instance.serverExtension,
      'signallingConfig': instance.signallingConfig?.toJson(),
      'rtcConfig': instance.rtcConfig?.toJson(),
    };

NIMSignallingRoomInfo _$NIMSignallingRoomInfoFromJson(
        Map<String, dynamic> json) =>
    NIMSignallingRoomInfo(
      channelInfo:
          _NIMSignallingChannelInfoFromJson(json['channelInfo'] as Map?),
      members: _NIMSignallingMemberListFromJson(json['members'] as List?),
    );

Map<String, dynamic> _$NIMSignallingRoomInfoToJson(
        NIMSignallingRoomInfo instance) =>
    <String, dynamic>{
      'channelInfo': instance.channelInfo?.toJson(),
      'members': instance.members?.map((e) => e.toJson()).toList(),
    };

NIMSignallingMember _$NIMSignallingMemberFromJson(Map<String, dynamic> json) =>
    NIMSignallingMember(
      accountId: json['accountId'] as String,
      uid: (json['uid'] as num).toInt(),
      joinTime: (json['joinTime'] as num?)?.toInt(),
      expireTime: (json['expireTime'] as num?)?.toInt(),
      deviceId: json['deviceId'] as String,
    );

Map<String, dynamic> _$NIMSignallingMemberToJson(
        NIMSignallingMember instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'uid': instance.uid,
      'joinTime': instance.joinTime,
      'expireTime': instance.expireTime,
      'deviceId': instance.deviceId,
    };

NIMSignallingInviteParams _$NIMSignallingInviteParamsFromJson(
        Map<String, dynamic> json) =>
    NIMSignallingInviteParams(
      channelId: json['channelId'] as String,
      inviteeAccountId: json['inviteeAccountId'] as String,
      requestId: json['requestId'] as String,
      serverExtension: json['serverExtension'] as String?,
      signallingConfig:
          _NIMSignallingConfigFromJson(json['signallingConfig'] as Map?),
      pushConfig: _NIMSignallingPushConfigFromJson(json['pushConfig'] as Map?),
    );

Map<String, dynamic> _$NIMSignallingInviteParamsToJson(
        NIMSignallingInviteParams instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'inviteeAccountId': instance.inviteeAccountId,
      'requestId': instance.requestId,
      'serverExtension': instance.serverExtension,
      'signallingConfig': instance.signallingConfig?.toJson(),
      'pushConfig': instance.pushConfig?.toJson(),
    };

NIMSignallingCancelInviteParams _$NIMSignallingCancelInviteParamsFromJson(
        Map<String, dynamic> json) =>
    NIMSignallingCancelInviteParams(
      channelId: json['channelId'] as String,
      inviteeAccountId: json['inviteeAccountId'] as String,
      requestId: json['requestId'] as String,
      serverExtension: json['serverExtension'] as String?,
      offlineEnabled: json['offlineEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$NIMSignallingCancelInviteParamsToJson(
        NIMSignallingCancelInviteParams instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'inviteeAccountId': instance.inviteeAccountId,
      'requestId': instance.requestId,
      'serverExtension': instance.serverExtension,
      'offlineEnabled': instance.offlineEnabled,
    };

NIMSignallingRejectInviteParams _$NIMSignallingRejectInviteParamsFromJson(
        Map<String, dynamic> json) =>
    NIMSignallingRejectInviteParams(
      channelId: json['channelId'] as String,
      inviterAccountId: json['inviterAccountId'] as String,
      requestId: json['requestId'] as String,
      serverExtension: json['serverExtension'] as String?,
      offlineEnabled: json['offlineEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$NIMSignallingRejectInviteParamsToJson(
        NIMSignallingRejectInviteParams instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'inviterAccountId': instance.inviterAccountId,
      'requestId': instance.requestId,
      'serverExtension': instance.serverExtension,
      'offlineEnabled': instance.offlineEnabled,
    };

NIMSignallingAcceptInviteParams _$NIMSignallingAcceptInviteParamsFromJson(
        Map<String, dynamic> json) =>
    NIMSignallingAcceptInviteParams(
      channelId: json['channelId'] as String,
      inviterAccountId: json['inviterAccountId'] as String,
      requestId: json['requestId'] as String,
      serverExtension: json['serverExtension'] as String?,
      offlineEnabled: json['offlineEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$NIMSignallingAcceptInviteParamsToJson(
        NIMSignallingAcceptInviteParams instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'inviterAccountId': instance.inviterAccountId,
      'requestId': instance.requestId,
      'serverExtension': instance.serverExtension,
      'offlineEnabled': instance.offlineEnabled,
    };

NIMSignallingEvent _$NIMSignallingEventFromJson(Map<String, dynamic> json) =>
    NIMSignallingEvent(
      eventType:
          $enumDecode(_$NIMSignallingEventTypeEnumMap, json['eventType']),
      channelInfo:
          _NIMSignallingChannelInfoFromJson(json['channelInfo'] as Map?),
      operatorAccountId: json['operatorAccountId'] as String,
      serverExtension: json['serverExtension'] as String?,
      time: (json['time'] as num).toInt(),
      inviteeAccountId: json['inviteeAccountId'] as String?,
      inviterAccountId: json['inviterAccountId'] as String?,
      requestId: json['requestId'] as String?,
      pushConfig: _NIMSignallingPushConfigFromJson(json['pushConfig'] as Map?),
      unreadEnabled: json['unreadEnabled'] as bool?,
      member: _NIMSignallingMemberFromJson(json['member'] as Map?),
    );

Map<String, dynamic> _$NIMSignallingEventToJson(NIMSignallingEvent instance) =>
    <String, dynamic>{
      'eventType': _$NIMSignallingEventTypeEnumMap[instance.eventType]!,
      'channelInfo': instance.channelInfo?.toJson(),
      'operatorAccountId': instance.operatorAccountId,
      'serverExtension': instance.serverExtension,
      'time': instance.time,
      'inviteeAccountId': instance.inviteeAccountId,
      'inviterAccountId': instance.inviterAccountId,
      'requestId': instance.requestId,
      'pushConfig': instance.pushConfig?.toJson(),
      'unreadEnabled': instance.unreadEnabled,
      'member': instance.member?.toJson(),
    };

const _$NIMSignallingEventTypeEnumMap = {
  NIMSignallingEventType.NIMSignallingEventTypeUnknown: 0,
  NIMSignallingEventType.NIMSignallingEventTypeClose: 1,
  NIMSignallingEventType.NIMSignallingEventTypeJoin: 2,
  NIMSignallingEventType.NIMSignallingEventTypeInvite: 3,
  NIMSignallingEventType.NIMSignallingEventTypeCancelInvite: 4,
  NIMSignallingEventType.NIMSignallingEventTypeReject: 5,
  NIMSignallingEventType.NIMSignallingEventTypeAccept: 6,
  NIMSignallingEventType.NIMSignallingEventTypeLeave: 7,
  NIMSignallingEventType.NIMSignallingEventTypeControl: 8,
};

V2NIMSignallingJoinResult _$V2NIMSignallingJoinResultFromJson(
        Map<String, dynamic> json) =>
    V2NIMSignallingJoinResult(
      roomInfo: _NIMSignallingRoomInfoFromJson(json['roomInfo'] as Map?),
      rtcInfo: _NIMSignallingRtcInfoFromJson(json['rtcInfo'] as Map?),
    );

Map<String, dynamic> _$V2NIMSignallingJoinResultToJson(
        V2NIMSignallingJoinResult instance) =>
    <String, dynamic>{
      'roomInfo': instance.roomInfo?.toJson(),
      'rtcInfo': instance.rtcInfo?.toJson(),
    };
