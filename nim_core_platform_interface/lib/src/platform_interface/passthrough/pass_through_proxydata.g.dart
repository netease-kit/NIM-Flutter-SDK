// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pass_through_proxydata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMPassThroughProxyData _$NIMPassThroughProxyDataFromJson(
    Map<String, dynamic> json) {
  return NIMPassThroughProxyData(
    zone: json['zone'] as String,
    path: json['path'] as String,
    method: json['method'] as int,
    header: json['header'] as String,
    body: json['body'] as String,
  );
}

Map<String, dynamic> _$NIMPassThroughProxyDataToJson(
        NIMPassThroughProxyData instance) =>
    <String, dynamic>{
      'zone': instance.zone,
      'path': instance.path,
      'method': instance.method,
      'header': instance.header,
      'body': instance.body,
    };
