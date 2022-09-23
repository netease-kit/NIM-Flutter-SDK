// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'friend.g.dart';

/// 消息
@JsonSerializable()
class NIMFriend {
  final String? userId;
  final String? alias;
  @JsonKey(name: "extension")
  final String? ext;
  @JsonKey(name: "serverExtension")
  final String? serverExt;

  NIMFriend({this.userId, this.alias, this.ext, this.serverExt});

  Map<String, dynamic> toMap() => _$NIMFriendToJson(this);

  factory NIMFriend.fromMap(Map<String, dynamic> map) =>
      _$NIMFriendFromJson(map);
}

/// 添加好友确认类型
enum NIMVerifyType {
  directAdd,
  verifyRequest,
}
