// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// 消息
@JsonSerializable()
class NIMUser {
  String? userId;
  String? nick;
  @JsonKey(name: "signature")
  String? sign;
  String? avatar;
  NIMUserGenderEnum? gender;
  String? email;
  @JsonKey(name: "birthday")
  String? birth;
  String? mobile;
  @JsonKey(name: "extension")
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
