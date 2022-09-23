// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMFriend _$NIMFriendFromJson(Map<String, dynamic> json) {
  return NIMFriend(
    userId: json['userId'] as String?,
    alias: json['alias'] as String?,
    ext: json['extension'] as String?,
    serverExt: json['serverExtension'] as String?,
  );
}

Map<String, dynamic> _$NIMFriendToJson(NIMFriend instance) => <String, dynamic>{
      'userId': instance.userId,
      'alias': instance.alias,
      'extension': instance.ext,
      'serverExtension': instance.serverExt,
    };
