// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import '../../../nim_core_v2_platform_interface.dart';

part 'ai_models.g.dart';

@JsonSerializable(explicitToJson: true)
class NIMAIUser extends NIMUserInfo {
  ///大模型类型
  NIMAIModelType? modelType;

  ///大模型配置
  @JsonKey(fromJson: _nimAIModelConfigFromJson)
  NIMAIModelConfig? modelConfig;

  NIMAIUser(
      {this.modelType,
      this.modelConfig,
      String? accountId,
      String? name,
      String? avatar,
      String? sign,
      int? gender,
      String? email,
      String? birthday,
      String? mobile,
      String? serverExtension,
      int? createTime,
      int? updateTime})
      : super(
            accountId: accountId,
            name: name,
            avatar: avatar,
            sign: sign,
            gender: gender,
            email: email,
            birthday: birthday,
            mobile: mobile,
            serverExtension: serverExtension,
            createTime: createTime,
            updateTime: updateTime);

  Map<String, dynamic> toJson() => _$NIMAIUserToJson(this);

  factory NIMAIUser.fromJson(Map<String, dynamic> map) =>
      _$NIMAIUserFromJson(map);
}

NIMAIModelConfig? _nimAIModelConfigFromJson(Map? map) {
  if (map != null) {
    return NIMAIModelConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

enum NIMAIModelType {
  /// 未知
  @JsonValue(0)
  nimAiModelTypeUKnown,

  /// 通义千问
  @JsonValue(1)
  nimAiModelTypeQwen,

  /// 微软Azure
  @JsonValue(2)
  nimAiModelTypeAzure,

  /// 私有本地大模型
  @JsonValue(3)
  nimAiModelTypePrivate;
}
