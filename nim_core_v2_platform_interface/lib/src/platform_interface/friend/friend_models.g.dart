// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMFriend _$NIMFriendFromJson(Map<String, dynamic> json) => NIMFriend(
      accountId: json['accountId'] as String,
      alias: json['alias'] as String?,
      serverExtension: json['serverExtension'] as String?,
      customerExtension: json['customerExtension'] as String?,
      createTime: (json['createTime'] as num).toInt(),
      updateTime: (json['updateTime'] as num?)?.toInt(),
      userProfile: _nimUserInfoFromJson(json['userProfile'] as Map?),
    );

Map<String, dynamic> _$NIMFriendToJson(NIMFriend instance) => <String, dynamic>{
      'accountId': instance.accountId,
      'alias': instance.alias,
      'serverExtension': instance.serverExtension,
      'customerExtension': instance.customerExtension,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'userProfile': instance.userProfile?.toJson(),
    };

NIMFriendAddParams _$NIMFriendAddParamsFromJson(Map<String, dynamic> json) =>
    NIMFriendAddParams(
      addMode: $enumDecode(_$NIMFriendAddModeEnumMap, json['addMode']),
      postscript: json['postscript'] as String?,
    );

Map<String, dynamic> _$NIMFriendAddParamsToJson(NIMFriendAddParams instance) =>
    <String, dynamic>{
      'addMode': _$NIMFriendAddModeEnumMap[instance.addMode]!,
      'postscript': instance.postscript,
    };

const _$NIMFriendAddModeEnumMap = {
  NIMFriendAddMode.nimFriendModeTypeAdd: 1,
  NIMFriendAddMode.nimFriendModeTypeApply: 2,
};

NIMFriendDeleteParams _$NIMFriendDeleteParamsFromJson(
        Map<String, dynamic> json) =>
    NIMFriendDeleteParams(
      deleteAlias: json['deleteAlias'] as bool?,
    );

Map<String, dynamic> _$NIMFriendDeleteParamsToJson(
        NIMFriendDeleteParams instance) =>
    <String, dynamic>{
      'deleteAlias': instance.deleteAlias,
    };

NIMFriendAddApplication _$NIMFriendAddApplicationFromJson(
        Map<String, dynamic> json) =>
    NIMFriendAddApplication(
      applicantAccountId: json['applicantAccountId'] as String?,
      recipientAccountId: json['recipientAccountId'] as String?,
      operatorAccountId: json['operatorAccountId'] as String?,
      postscript: json['postscript'] as String?,
      status: $enumDecodeNullable(
          _$NIMFriendAddApplicationStatusEnumMap, json['status']),
      timestamp: (json['timestamp'] as num?)?.toInt(),
      postscriptHistory:
          _v2NIMPostscriptListFromJson(json['postscriptHistory'] as List?),
      serverId: json['serverId'] as String?,
      updateTimestamp: (json['updateTimestamp'] as num?)?.toInt(),
      read: json['read'] as bool?,
    );

Map<String, dynamic> _$NIMFriendAddApplicationToJson(
        NIMFriendAddApplication instance) =>
    <String, dynamic>{
      'applicantAccountId': instance.applicantAccountId,
      'recipientAccountId': instance.recipientAccountId,
      'operatorAccountId': instance.operatorAccountId,
      'postscript': instance.postscript,
      'status': _$NIMFriendAddApplicationStatusEnumMap[instance.status],
      'timestamp': instance.timestamp,
      'read': instance.read,
      'postscriptHistory':
          instance.postscriptHistory?.map((e) => e.toJson()).toList(),
      'serverId': instance.serverId,
      'updateTimestamp': instance.updateTimestamp,
    };

const _$NIMFriendAddApplicationStatusEnumMap = {
  NIMFriendAddApplicationStatus.nimFriendAddApplicationStatusInit: 0,
  NIMFriendAddApplicationStatus.nimFriendAddApplicationStatusAgreed: 1,
  NIMFriendAddApplicationStatus.nimFriendAddApplicationStatusRejected: 2,
  NIMFriendAddApplicationStatus.nimFriendAddApplicationStatusExpired: 3,
  NIMFriendAddApplicationStatus.nimFriendAddApplicationStatusDirectAdd: 4,
};

V2NIMPostscript _$V2NIMPostscriptFromJson(Map<String, dynamic> json) =>
    V2NIMPostscript(
      fromAccount: json['fromAccount'] as String?,
      content: json['content'] as String?,
      time: (json['time'] as num?)?.toInt(),
    );

Map<String, dynamic> _$V2NIMPostscriptToJson(V2NIMPostscript instance) =>
    <String, dynamic>{
      'fromAccount': instance.fromAccount,
      'content': instance.content,
      'time': instance.time,
    };

NIMFriendSetParams _$NIMFriendSetParamsFromJson(Map<String, dynamic> json) =>
    NIMFriendSetParams(
      alias: json['alias'] as String?,
      serverExtension: json['serverExtension'] as String?,
    );

Map<String, dynamic> _$NIMFriendSetParamsToJson(NIMFriendSetParams instance) =>
    <String, dynamic>{
      'alias': instance.alias,
      'serverExtension': instance.serverExtension,
    };

NIMFriendAddApplicationQueryOption _$NIMFriendAddApplicationQueryOptionFromJson(
        Map<String, dynamic> json) =>
    NIMFriendAddApplicationQueryOption(
      offset: (json['offset'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      status: (json['status'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$NIMFriendAddApplicationStatusEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$NIMFriendAddApplicationQueryOptionToJson(
        NIMFriendAddApplicationQueryOption instance) =>
    <String, dynamic>{
      'offset': instance.offset,
      'limit': instance.limit,
      'status': instance.status
          ?.map((e) => _$NIMFriendAddApplicationStatusEnumMap[e]!)
          .toList(),
    };

NIMFriendAddApplicationResult _$NIMFriendAddApplicationResultFromJson(
        Map<String, dynamic> json) =>
    NIMFriendAddApplicationResult(
      infos: _friendAddApplicationListFromJson(json['infos'] as List?),
      offset: (json['offset'] as num).toInt(),
      finished: json['finished'] as bool?,
    );

Map<String, dynamic> _$NIMFriendAddApplicationResultToJson(
        NIMFriendAddApplicationResult instance) =>
    <String, dynamic>{
      'infos': instance.infos?.map((e) => e.toJson()).toList(),
      'offset': instance.offset,
      'finished': instance.finished,
    };

NIMFriendSearchOption _$NIMFriendSearchOptionFromJson(
        Map<String, dynamic> json) =>
    NIMFriendSearchOption(
      keyword: json['keyword'] as String,
      searchAlias: json['searchAlias'] as bool? ?? true,
      searchAccountId: json['searchAccountId'] as bool? ?? true,
    );

Map<String, dynamic> _$NIMFriendSearchOptionToJson(
        NIMFriendSearchOption instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'searchAlias': instance.searchAlias,
      'searchAccountId': instance.searchAccountId,
    };

NIMFriendClearAddApplicationOption _$NIMFriendClearAddApplicationOptionFromJson(
        Map<String, dynamic> json) =>
    NIMFriendClearAddApplicationOption(
      timestamp: (json['timestamp'] as num?)?.toInt(),
      type: $enumDecodeNullable(
          _$NIMFriendAddApplicationTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$NIMFriendClearAddApplicationOptionToJson(
        NIMFriendClearAddApplicationOption instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'type': _$NIMFriendAddApplicationTypeEnumMap[instance.type],
    };

const _$NIMFriendAddApplicationTypeEnumMap = {
  NIMFriendAddApplicationType.nimFriendAddApplicationTypeLegacy: 0,
  NIMFriendAddApplicationType.nimFriendAddApplicationTypeFromSelf: 1,
  NIMFriendAddApplicationType.nimFriendAddApplicationTypeToSelf: 2,
  NIMFriendAddApplicationType.nimFriendAddApplicationTypeAll: 3,
};

NIMFriendDeletion _$NIMFriendDeletionFromJson(Map<String, dynamic> json) =>
    NIMFriendDeletion(
      accountId: json['accountId'] as String,
      deletionType:
          $enumDecode(_$NIMFriendDeletionTypeEnumMap, json['deletionType']),
    );

Map<String, dynamic> _$NIMFriendDeletionToJson(NIMFriendDeletion instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'deletionType': _$NIMFriendDeletionTypeEnumMap[instance.deletionType]!,
    };

const _$NIMFriendDeletionTypeEnumMap = {
  NIMFriendDeletionType.nimFriendDeletionTypeBySelf: 1,
  NIMFriendDeletionType.nimFriendDeletionTypeByFriend: 2,
};
