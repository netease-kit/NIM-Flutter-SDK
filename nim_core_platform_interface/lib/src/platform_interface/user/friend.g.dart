// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMFriend _$NIMFriendFromJson(Map<String, dynamic> json) {
  return NIMFriend(
    userId: json['userId'] as String?,
    alias: json['alias'] as String?,
    serverExt: json['serverExt'] as String?,
  );
}

Map<String, dynamic> _$NIMFriendToJson(NIMFriend instance) => <String, dynamic>{
      'userId': instance.userId,
      'alias': instance.alias,
      'serverExt': instance.serverExt,
    };
