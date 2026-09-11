// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nim_team_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMTeamSearchParams _$NIMTeamSearchParamsFromJson(Map<String, dynamic> json) =>
    NIMTeamSearchParams(
      keywordList: (json['keywordList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      keywordMatchType: $enumDecodeNullable(
          _$NIMTeamKeywordMatchTypeEnumMap, json['keywordMatchType']),
      teamTypes: (json['teamTypes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$NIMTeamTypeEnumMap, e))
          .toList(),
      nextToken: json['nextToken'] as String?,
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMTeamSearchParamsToJson(
        NIMTeamSearchParams instance) =>
    <String, dynamic>{
      'keywordList': instance.keywordList,
      'keywordMatchType':
          _$NIMTeamKeywordMatchTypeEnumMap[instance.keywordMatchType],
      'teamTypes':
          instance.teamTypes?.map((e) => _$NIMTeamTypeEnumMap[e]!).toList(),
      'nextToken': instance.nextToken,
      'limit': instance.limit,
    };

const _$NIMTeamKeywordMatchTypeEnumMap = {
  NIMTeamKeywordMatchType.single: 0,
  NIMTeamKeywordMatchType.multiple: 1,
};

const _$NIMTeamTypeEnumMap = {
  NIMTeamType.typeInvalid: 0,
  NIMTeamType.typeNormal: 1,
  NIMTeamType.typeSuper: 2,
};

NIMTeamRefer _$NIMTeamReferFromJson(Map<String, dynamic> json) => NIMTeamRefer(
      teamId: json['teamId'] as String,
      teamType: $enumDecode(_$NIMTeamTypeEnumMap, json['teamType']),
    );

Map<String, dynamic> _$NIMTeamReferToJson(NIMTeamRefer instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'teamType': _$NIMTeamTypeEnumMap[instance.teamType]!,
    };

NIMSearchTeamMemberParams _$NIMSearchTeamMemberParamsFromJson(
        Map<String, dynamic> json) =>
    NIMSearchTeamMemberParams(
      keywordList: (json['keywordList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      keywordMatchType: $enumDecodeNullable(
          _$NIMTeamKeywordMatchTypeEnumMap, json['keywordMatchType']),
      teamRefers: _nimTeamReferListFromJson(json['teamRefers'] as List?),
      searchAccountId: json['searchAccountId'] as bool?,
      searchTeamNick: json['searchTeamNick'] as bool?,
      nextToken: json['nextToken'] as String?,
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMSearchTeamMemberParamsToJson(
        NIMSearchTeamMemberParams instance) =>
    <String, dynamic>{
      'keywordList': instance.keywordList,
      'keywordMatchType':
          _$NIMTeamKeywordMatchTypeEnumMap[instance.keywordMatchType],
      'teamRefers': instance.teamRefers?.map((e) => e.toJson()).toList(),
      'searchAccountId': instance.searchAccountId,
      'searchTeamNick': instance.searchTeamNick,
      'nextToken': instance.nextToken,
      'limit': instance.limit,
    };
