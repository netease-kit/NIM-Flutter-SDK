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

  ///yyyy-MM-dd格式
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

/// 用户头像信息
class UserInfoProviderAvatarInfo {
  /// 路径类型
  final AvatarPathType type;

  /// 具体路径
  ///
  /// eg:
  /// 文件类型[AvatarPathType.file] 路径形如 /data/user/0/com.xxx.xxx/cache/test.jpg
  /// 资源类型[AvatarPathType.asset] 路径形如 resources/test.jpg （在 pubspec.yaml 中注册的文件）
  ///
  final String path;

  /// 防止内存溢出，图片内部转换到 bitmap 的采样
  /// 等同于 Android 平台下的 [BitmapFactory.Options.inSampleSize]
  /// 默认值 2
  final int inSampleSize;

  UserInfoProviderAvatarInfo(this.type, this.path, {this.inSampleSize = 2});
}

/// 头像路径类型
enum AvatarPathType {
  /// asset 资源类型
  asset,

  /// 文件类型
  file,
}
