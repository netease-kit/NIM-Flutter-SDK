// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMLoginOption _$NIMLoginOptionFromJson(Map<String, dynamic> json) =>
    NIMLoginOption(
      retryCount: (json['retryCount'] as num?)?.toInt(),
      timeout: (json['timeout'] as num?)?.toInt(),
      authType:
          $enumDecodeNullable(_$NIMLoginAuthTypeEnumMap, json['authType']),
      forceMode: json['forceMode'] as bool?,
      syncLevel:
          $enumDecodeNullable(_$NIMDataSyncLevelEnumMap, json['syncLevel']),
    );

Map<String, dynamic> _$NIMLoginOptionToJson(NIMLoginOption instance) =>
    <String, dynamic>{
      'retryCount': instance.retryCount,
      'timeout': instance.timeout,
      'forceMode': instance.forceMode,
      'authType': _$NIMLoginAuthTypeEnumMap[instance.authType],
      'syncLevel': _$NIMDataSyncLevelEnumMap[instance.syncLevel],
    };

const _$NIMLoginAuthTypeEnumMap = {
  NIMLoginAuthType.authTypeDefault: 0,
  NIMLoginAuthType.authTypeDynamicToken: 1,
  NIMLoginAuthType.authTypeThirdParty: 2,
};

const _$NIMDataSyncLevelEnumMap = {
  NIMDataSyncLevel.dataSyncLevelFull: 0,
  NIMDataSyncLevel.dataSyncLevelBasic: 1,
};

NIMLoginStatusClass _$NIMLoginStatusClassFromJson(Map<String, dynamic> json) =>
    NIMLoginStatusClass(
      $enumDecode(_$NIMLoginStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$NIMLoginStatusClassToJson(
        NIMLoginStatusClass instance) =>
    <String, dynamic>{
      'status': _$NIMLoginStatusEnumMap[instance.status]!,
    };

const _$NIMLoginStatusEnumMap = {
  NIMLoginStatus.loginStatusLogout: 0,
  NIMLoginStatus.loginStatusLogined: 1,
  NIMLoginStatus.loginStatusLogining: 2,
  NIMLoginStatus.loginStatusUnlogin: 3,
};

NIMLoginClient _$NIMLoginClientFromJson(Map<String, dynamic> json) =>
    NIMLoginClient(
      type: $enumDecodeNullable(_$NIMLoginClientTypeEnumMap, json['type']),
      clientId: json['clientId'] as String?,
      os: json['os'] as String?,
      customClientType: (json['customClientType'] as num?)?.toInt(),
      customTag: json['customTag'] as String?,
      timestamp: (json['timestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMLoginClientToJson(NIMLoginClient instance) =>
    <String, dynamic>{
      'type': _$NIMLoginClientTypeEnumMap[instance.type],
      'os': instance.os,
      'timestamp': instance.timestamp,
      'customTag': instance.customTag,
      'customClientType': instance.customClientType,
      'clientId': instance.clientId,
    };

const _$NIMLoginClientTypeEnumMap = {
  NIMLoginClientType.loginClientTypeUnknown: 0,
  NIMLoginClientType.loginClientTypeAndroid: 1,
  NIMLoginClientType.loginClientTypeIOS: 2,
  NIMLoginClientType.loginClientTypePC: 4,
  NIMLoginClientType.loginClientTypeWinPhone: 8,
  NIMLoginClientType.loginClientTypeWeb: 16,
  NIMLoginClientType.loginClientTypeRestful: 32,
  NIMLoginClientType.loginClientTypeMac: 64,
  NIMLoginClientType.loginClientTypeHarmony: 65,
};

NIMKickedOfflineDetail _$NIMKickedOfflineDetailFromJson(
        Map<String, dynamic> json) =>
    NIMKickedOfflineDetail(
      customClientType: (json['customClientType'] as num?)?.toInt(),
      clientType:
          $enumDecodeNullable(_$NIMLoginClientTypeEnumMap, json['clientType']),
      reason:
          $enumDecodeNullable(_$NIMKickedOfflineReasonEnumMap, json['reason']),
      reasonDesc: json['reasonDesc'] as String?,
    );

Map<String, dynamic> _$NIMKickedOfflineDetailToJson(
        NIMKickedOfflineDetail instance) =>
    <String, dynamic>{
      'reason': _$NIMKickedOfflineReasonEnumMap[instance.reason],
      'reasonDesc': instance.reasonDesc,
      'clientType': _$NIMLoginClientTypeEnumMap[instance.clientType],
      'customClientType': instance.customClientType,
    };

const _$NIMKickedOfflineReasonEnumMap = {
  NIMKickedOfflineReason.kickedOfflineReasonClientExclusive: 1,
  NIMKickedOfflineReason.kickedOfflineReasonServer: 2,
  NIMKickedOfflineReason.kickedOfflineReasonClient: 3,
};

NIMConnectStatusClass _$NIMConnectStatusClassFromJson(
        Map<String, dynamic> json) =>
    NIMConnectStatusClass(
      $enumDecode(_$NIMConnectStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$NIMConnectStatusClassToJson(
        NIMConnectStatusClass instance) =>
    <String, dynamic>{
      'status': _$NIMConnectStatusEnumMap[instance.status]!,
    };

const _$NIMConnectStatusEnumMap = {
  NIMConnectStatus.nimConnectStatusDisconnected: 0,
  NIMConnectStatus.nimConnectStatusConnected: 1,
  NIMConnectStatus.nimConnectStatusConnecting: 2,
  NIMConnectStatus.nimConnectStatusWaiting: 3,
};

NIMDataSyncDetail _$NIMDataSyncDetailFromJson(Map<String, dynamic> json) =>
    NIMDataSyncDetail(
      type: $enumDecodeNullable(_$NIMDataSyncTypeEnumMap, json['type']),
      state: $enumDecodeNullable(_$NIMDataSyncStateEnumMap, json['state']),
    );

Map<String, dynamic> _$NIMDataSyncDetailToJson(NIMDataSyncDetail instance) =>
    <String, dynamic>{
      'type': _$NIMDataSyncTypeEnumMap[instance.type],
      'state': _$NIMDataSyncStateEnumMap[instance.state],
    };

const _$NIMDataSyncTypeEnumMap = {
  NIMDataSyncType.nimDataSyncUnknown: 0,
  NIMDataSyncType.nimDataSyncMain: 1,
  NIMDataSyncType.nimDataSyncTeamMember: 2,
  NIMDataSyncType.nimDataSyncSuperTeamMember: 3,
};

const _$NIMDataSyncStateEnumMap = {
  NIMDataSyncState.nimDataSyncStateWaiting: 1,
  NIMDataSyncState.nimDataSyncStateInSyncing: 2,
  NIMDataSyncState.nimDataSyncStateCompleted: 3,
};

NIMLoginClientChangeEvent _$NIMLoginClientChangeEventFromJson(
        Map<String, dynamic> json) =>
    NIMLoginClientChangeEvent(
      change:
          $enumDecodeNullable(_$NIMLoginClientChangeEnumMap, json['change']),
      clients: _loginClientListFromJson(json['clients'] as List?),
    );

Map<String, dynamic> _$NIMLoginClientChangeEventToJson(
        NIMLoginClientChangeEvent instance) =>
    <String, dynamic>{
      'change': _$NIMLoginClientChangeEnumMap[instance.change],
      'clients': instance.clients?.map((e) => e.toJson()).toList(),
    };

const _$NIMLoginClientChangeEnumMap = {
  NIMLoginClientChange.nimLoginClientChangeList: 1,
  NIMLoginClientChange.nimLoginClientChangeLogin: 2,
  NIMLoginClientChange.nimLoginClientChangeLogout: 3,
};
