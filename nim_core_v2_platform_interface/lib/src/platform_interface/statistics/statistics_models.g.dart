// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMDatabaseInfo _$NIMDatabaseInfoFromJson(Map<String, dynamic> json) =>
    NIMDatabaseInfo(
      path: json['path'] as String?,
      name: json['name'] as String?,
      size: json['size'] as int?,
    );

Map<String, dynamic> _$NIMDatabaseInfoToJson(NIMDatabaseInfo instance) =>
    <String, dynamic>{
      'path': instance.path,
      'name': instance.name,
      'size': instance.size,
    };
