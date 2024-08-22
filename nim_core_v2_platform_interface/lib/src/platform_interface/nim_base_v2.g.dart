// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nim_base_v2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMError _$NIMErrorFromJson(Map<String, dynamic> json) => NIMError(
      code: (json['code'] as num?)?.toInt(),
      desc: json['desc'] as String?,
      detail: _getMap(json['detail'] as Map?),
    );

Map<String, dynamic> _$NIMErrorToJson(NIMError instance) => <String, dynamic>{
      'code': instance.code,
      'desc': instance.desc,
      'detail': instance.detail,
    };
