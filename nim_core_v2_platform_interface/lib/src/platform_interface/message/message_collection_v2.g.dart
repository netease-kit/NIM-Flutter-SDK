// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_collection_v2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMCollectionOption _$NIMCollectionOptionFromJson(Map<String, dynamic> json) =>
    NIMCollectionOption(
      beginTime: (json['beginTime'] as num?)?.toInt(),
      endTime: (json['endTime'] as num?)?.toInt(),
      direction:
          $enumDecodeNullable(_$NIMQueryDirectionEnumMap, json['direction']),
      anchorCollection:
          _nimCollectionFromJson(json['anchorCollection'] as Map?),
      limit: (json['limit'] as num?)?.toInt(),
      collectionType: (json['collectionType'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMCollectionOptionToJson(
        NIMCollectionOption instance) =>
    <String, dynamic>{
      'beginTime': instance.beginTime,
      'endTime': instance.endTime,
      'direction': _$NIMQueryDirectionEnumMap[instance.direction],
      'anchorCollection': instance.anchorCollection?.toJson(),
      'limit': instance.limit,
      'collectionType': instance.collectionType,
    };

const _$NIMQueryDirectionEnumMap = {
  NIMQueryDirection.desc: 0,
  NIMQueryDirection.asc: 1,
};

NIMCollection _$NIMCollectionFromJson(Map<String, dynamic> json) =>
    NIMCollection(
      collectionId: json['collectionId'] as String?,
      collectionType: (json['collectionType'] as num?)?.toInt(),
      collectionData: json['collectionData'] as String?,
      serverExtension: json['serverExtension'] as String?,
      createTime: (json['createTime'] as num?)?.toInt(),
      updateTime: (json['updateTime'] as num?)?.toInt(),
      uniqueId: json['uniqueId'] as String?,
    );

Map<String, dynamic> _$NIMCollectionToJson(NIMCollection instance) =>
    <String, dynamic>{
      'collectionId': instance.collectionId,
      'collectionType': instance.collectionType,
      'collectionData': instance.collectionData,
      'serverExtension': instance.serverExtension,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'uniqueId': instance.uniqueId,
    };

NIMAddCollectionParams _$NIMAddCollectionParamsFromJson(
        Map<String, dynamic> json) =>
    NIMAddCollectionParams(
      collectionType: (json['collectionType'] as num?)?.toInt(),
      collectionData: json['collectionData'] as String?,
      serverExtension: json['serverExtension'] as String?,
      uniqueId: json['uniqueId'] as String?,
    );

Map<String, dynamic> _$NIMAddCollectionParamsToJson(
        NIMAddCollectionParams instance) =>
    <String, dynamic>{
      'collectionType': instance.collectionType,
      'collectionData': instance.collectionData,
      'serverExtension': instance.serverExtension,
      'uniqueId': instance.uniqueId,
    };
