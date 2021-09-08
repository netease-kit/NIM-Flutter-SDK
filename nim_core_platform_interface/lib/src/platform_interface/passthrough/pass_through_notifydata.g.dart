// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pass_through_notifydata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMPassThroughNotifyData _$NIMPassThroughNotifyDataFromJson(
    Map<String, dynamic> json) {
  return NIMPassThroughNotifyData(
    fromAccid: json['fromAccid'] as String?,
    body: json['body'] as String?,
    time: json['time'] as int?,
  );
}

Map<String, dynamic> _$NIMPassThroughNotifyDataToJson(
        NIMPassThroughNotifyData instance) =>
    <String, dynamic>{
      'fromAccid': instance.fromAccid,
      'body': instance.body,
      'time': instance.time,
    };
