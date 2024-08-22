// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// 消息
@JsonSerializable()
class NIMUserInfo {
  String? accountId;
  String? name;
  String? avatar;
  String? sign;
  int? gender;
  String? email;

  ///yyyy-MM-dd格式
  String? birthday;
  String? mobile;
  String? serverExtension;
  // 创建时间
  int? createTime;
  // 更新时间
  int? updateTime;

  NIMUserInfo(
      {this.accountId,
      this.name,
      this.avatar,
      this.sign,
      this.gender,
      this.email,
      this.birthday,
      this.mobile,
      this.serverExtension,
      this.createTime,
      this.updateTime});

  Map<String, dynamic> toJson() => _$NIMUserInfoToJson(this);

  factory NIMUserInfo.fromJson(Map<String, dynamic> map) =>
      _$NIMUserInfoFromJson(map);
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

/// 消息
@JsonSerializable()
class NIMUserUpdateParam {
  String? name;
  String? avatar;
  String? sign;
  int? gender;
  String? email;

  ///yyyy-MM-dd格式
  String? birthday;
  String? mobile;
  String? serverExtension;

  NIMUserUpdateParam(
      {this.name,
      this.avatar,
      this.sign,
      this.gender,
      this.email,
      this.birthday,
      this.mobile,
      this.serverExtension});
  Map<String, dynamic> toJson() => _$NIMUserUpdateParamToJson(this);
  factory NIMUserUpdateParam.fromJson(Map<String, dynamic> map) =>
      _$NIMUserUpdateParamFromJson(map);
}

@JsonSerializable()
class NIMUserSearchOption {
  String keyword;
  bool? searchName;
  bool? searchAccountId;
  bool? searchMobile;

  NIMUserSearchOption(
      {required this.keyword,
      this.searchName,
      this.searchAccountId,
      this.searchMobile});
  Map<String, dynamic> toJson() => _$NIMUserSearchOptionToJson(this);
  factory NIMUserSearchOption.fromJson(Map<String, dynamic> map) =>
      _$NIMUserSearchOptionFromJson(map);
}

/// 头像路径类型
enum AvatarPathType {
  /// asset 资源类型
  asset,

  /// 文件类型
  file,
}
