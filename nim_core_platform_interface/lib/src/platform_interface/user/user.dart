// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// 消息
@JsonSerializable()
class NIMUser {
  String? userId;
  String? nick;
  String? avatar;
  String? sign;
  NIMUserGenderEnum? gender;
  String? email;
  String? birth;
  String? mobile;
  String? ext;

  NIMUser(
      {this.userId,
      this.nick,
      this.avatar,
      this.sign,
      this.gender,
      this.email,
      this.birth,
      this.mobile,
      this.ext});

  Map<String, dynamic> toMap() => _$NIMUserToJson(this);
  factory NIMUser.fromMap(Map<String, dynamic> map) => _$NIMUserFromJson(map);
}

/// 认证类型
enum NIMUserGenderEnum {
  unknown,
  male,
  female,
}
