// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nim_sdk_server_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMServerConfig _$NIMServerConfigFromJson(Map<String, dynamic> json) =>
    NIMServerConfig(
      module: json['module'] as String?,
      publicKeyVersion: json['publicKeyVersion'] as int? ?? 0,
      lbs: json['lbs'] as String?,
      defaultLink: json['defaultLink'] as String?,
      nosUploadLbs: json['nosUploadLbs'] as String?,
      nosUploadDefaultLink: json['nosUploadDefaultLink'] as String?,
      nosUpload: json['nosUpload'] as String?,
      nosSupportHttps: json['nosSupportHttps'] as bool? ?? true,
      nosDownloadUrlFormat: json['nosDownloadUrlFormat'] as String?,
      nosDownload: json['nosDownload'] as String?,
      nosAccess: json['nosAccess'] as String?,
      negoKeyNeca:
          $enumDecodeNullable(_$AsymmetricTypeEnumMap, json['negoKeyNeca']) ??
              AsymmetricType.rsa,
      negoKeyEncaKeyVersion: json['negoKeyEncaKeyVersion'] as int?,
      negoKeyEncaKeyParta: json['negoKeyEncaKeyParta'] as String?,
      negoKeyEncaKeyPartb: json['negoKeyEncaKeyPartb'] as String?,
      commEnca: $enumDecodeNullable(_$SymmetryTypeEnumMap, json['commEnca']) ??
          SymmetryType.rc4,
      linkIpv6: json['linkIpv6'] as String?,
      ipProtocolVersion:
          $enumDecodeNullable(_$IPVersionEnumMap, json['ipProtocolVersion']) ??
              IPVersion.ipv4,
      probeIpv4Url: json['probeIpv4Url'] as String?,
      probeIpv6Url: json['probeIpv6Url'] as String?,
      handshakeType: $enumDecodeNullable(
              _$NimHandshakeTypeEnumMap, json['handshakeType']) ??
          NimHandshakeType.v1,
      nosCdnEnable: json['nosCdnEnable'] as bool? ?? true,
      nosDownloadSet: (json['nosDownloadSet'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toSet(),
    );

Map<String, dynamic> _$NIMServerConfigToJson(NIMServerConfig instance) =>
    <String, dynamic>{
      'module': instance.module,
      'publicKeyVersion': instance.publicKeyVersion,
      'lbs': instance.lbs,
      'defaultLink': instance.defaultLink,
      'nosUploadLbs': instance.nosUploadLbs,
      'nosUploadDefaultLink': instance.nosUploadDefaultLink,
      'nosUpload': instance.nosUpload,
      'nosSupportHttps': instance.nosSupportHttps,
      'nosDownloadUrlFormat': instance.nosDownloadUrlFormat,
      'nosDownload': instance.nosDownload,
      'nosAccess': instance.nosAccess,
      'negoKeyNeca': _$AsymmetricTypeEnumMap[instance.negoKeyNeca]!,
      'negoKeyEncaKeyVersion': instance.negoKeyEncaKeyVersion,
      'negoKeyEncaKeyParta': instance.negoKeyEncaKeyParta,
      'negoKeyEncaKeyPartb': instance.negoKeyEncaKeyPartb,
      'commEnca': _$SymmetryTypeEnumMap[instance.commEnca]!,
      'linkIpv6': instance.linkIpv6,
      'ipProtocolVersion': _$IPVersionEnumMap[instance.ipProtocolVersion]!,
      'probeIpv4Url': instance.probeIpv4Url,
      'probeIpv6Url': instance.probeIpv6Url,
      'handshakeType': _$NimHandshakeTypeEnumMap[instance.handshakeType]!,
      'nosCdnEnable': instance.nosCdnEnable,
      'nosDownloadSet': instance.nosDownloadSet?.toList(),
    };

const _$AsymmetricTypeEnumMap = {
  AsymmetricType.rsa: 'rsa',
  AsymmetricType.sm2: 'sm2',
  AsymmetricType.rsaOaep1: 'rsaOaep1',
  AsymmetricType.rsaOaep256: 'rsaOaep256',
};

const _$SymmetryTypeEnumMap = {
  SymmetryType.rc4: 'rc4',
  SymmetryType.aes: 'aes',
  SymmetryType.sm4: 'sm4',
};

const _$IPVersionEnumMap = {
  IPVersion.ipv4: 'ipv4',
  IPVersion.ipv6: 'ipv6',
  IPVersion.any: 'any',
};

const _$NimHandshakeTypeEnumMap = {
  NimHandshakeType.v0: 'v0',
  NimHandshakeType.v1: 'v1',
};
