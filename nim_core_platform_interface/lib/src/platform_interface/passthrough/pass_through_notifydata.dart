import 'package:json_annotation/json_annotation.dart';

part 'pass_through_notifydata.g.dart';

@JsonSerializable()
class NIMPassThroughNotifyData {
  final String? fromAccid;

  /// 透传内容
  final String? body;

  /// 发送时间时间戳
  final int? time;

  NIMPassThroughNotifyData({this.fromAccid, this.body, this.time});

  factory NIMPassThroughNotifyData.fromMap(Map<String, dynamic> map) =>
      _$NIMPassThroughNotifyDataFromJson(map);

  @override
  Map<String, dynamic> toMap() => _$NIMPassThroughNotifyDataToJson(this);
}
