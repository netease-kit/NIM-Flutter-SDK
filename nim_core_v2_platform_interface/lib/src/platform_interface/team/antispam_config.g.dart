// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antispam_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMAntispamConfig _$NIMAntispamConfigFromJson(Map<String, dynamic> json) =>
    NIMAntispamConfig(
      antispamBusinessId: json['antispamBusinessId'] as String?,
    );

Map<String, dynamic> _$NIMAntispamConfigToJson(NIMAntispamConfig instance) =>
    <String, dynamic>{
      'antispamBusinessId': instance.antispamBusinessId,
    };
