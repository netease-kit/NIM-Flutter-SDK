// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/src/platform_interface/initialize/nim_sdk_options.dart';

part 'nim_sdk_pc_options.g.dart';

///桌面端初始化参数配置
@JsonSerializable(explicitToJson: true)
class NIMPCSDKOptions extends NIMSDKOptions {
  /// 基础配置
  NIMBasicOption basicOption;

  /// 连接相关配置
  NIMLinkOption? linkOption;

  /// 数据库配置
  NIMDatabaseOption? databaseOption;

  /// 融合存储配置
  NIMFCSOption? fcsOption;

  /// 私有化配置
  NIMPrivateServerOption? privateServerOption;

  NIMPCSDKOptions({
    /// macos configurations
    required this.basicOption,
    this.linkOption,
    this.databaseOption,
    this.fcsOption,
    this.privateServerOption,

    /// common configurations
    required String appKey,
    String? sdkRootDir,
  }) : super(
          appKey: appKey,
          sdkRootDir: sdkRootDir,
        );

  factory NIMPCSDKOptions.fromMap(Map map) {
    return _$NIMPCSDKOptionsFromJson(Map<String, dynamic>.from(map));
  }

  @override
  Map<String, dynamic> toMap() => _$NIMPCSDKOptionsToJson(this);
}

enum NIMSDKLogLevel {
  /// 致命
  @JsonValue(1)
  nimSdkLogLevelFatal,

  /// 错误
  @JsonValue(2)
  nimSdkLogLevelError,

  /// 警告
  @JsonValue(3)
  nimSdkLogLevelWarn,

  /// 应用
  @JsonValue(5)
  nimSdkLogLevelApp,

  /// 调试
  @JsonValue(6)
  nimSdkLogLevelPro,
}

@JsonSerializable(explicitToJson: true)
class NIMBasicOption {
  /// 是否使用 https
  bool useHttps = true;

  /// 是否使用 httpdns
  bool useHttpdns = true;

  /// 自定义客户端类型
  int? customClientType;

  /// 登录自定义信息, 最大 32 个字符
  String? customTag;

  /// 日志保留天数
  int? logReserveDays = 30;

  /// SDK日志级别
  NIMSDKLogLevel sdkLogLevel = NIMSDKLogLevel.nimSdkLogLevelApp;

  /// 是否禁用 macOS 下的 App Nap 功能
  bool disableAppNap = true;

  NIMBasicOption({
    this.useHttps = true,
    this.useHttpdns = true,
    this.customClientType,
    this.customTag,
    this.logReserveDays = 30,
    this.sdkLogLevel = NIMSDKLogLevel.nimSdkLogLevelApp,
    this.disableAppNap = true,
  });

  Map<String, dynamic> toJson() => _$NIMBasicOptionToJson(this);

  factory NIMBasicOption.fromJson(Map<String, dynamic> map) =>
      _$NIMBasicOptionFromJson(map);
}

enum NIMAsymmetricEncryptionAlgorithm {
  @JsonValue(1)
  nimAsymmetricEncryptionAlgorithmRSA,
  @JsonValue(2)
  nimAsymmetricEncryptionAlgorithmSM2,
}

enum NIMSymmetricEncryptionAlgorithm {
  @JsonValue(1)
  nimSymmetricEncryptionAlgorithmRC4,
  @JsonValue(2)
  nimSymmetricEncryptionAlgorithmAES128,
  @JsonValue(4)
  nimSymmetricEncryptionAlgorithmSM4,
}

@JsonSerializable(explicitToJson: true)
class NIMLinkOption {
  /// 连接超时, 单位毫秒
  int linkTimeout = 3000;

  /// 协议超时, 单位毫秒
  int protocolTimeout = 3000;

  /// 非对称加密"交换密钥"协议加密算法
  NIMAsymmetricEncryptionAlgorithm asymmetricEncryptionAlgorithm =
      NIMAsymmetricEncryptionAlgorithm.nimAsymmetricEncryptionAlgorithmRSA;

  /// 对称加密通信加密算法
  NIMSymmetricEncryptionAlgorithm symmetricEncryptionAlgorithm =
      NIMSymmetricEncryptionAlgorithm.nimSymmetricEncryptionAlgorithmRC4;

  NIMLinkOption({
    this.linkTimeout = 3000,
    this.protocolTimeout = 3000,
    this.asymmetricEncryptionAlgorithm =
        NIMAsymmetricEncryptionAlgorithm.nimAsymmetricEncryptionAlgorithmRSA,
    this.symmetricEncryptionAlgorithm =
        NIMSymmetricEncryptionAlgorithm.nimSymmetricEncryptionAlgorithmRC4,
  });

  Map<String, dynamic> toJson() => _$NIMLinkOptionToJson(this);

  factory NIMLinkOption.fromJson(Map<String, dynamic> map) =>
      _$NIMLinkOptionFromJson(map);
}

@JsonSerializable(explicitToJson: true)
class NIMDatabaseOption {
  /// 数据库加密密钥
  String? encryptionKey;

  /// 是否开启用户数据备份(本地)功能
  bool enableBackup = true;

  /// 是否开启用户数据恢复(本地)功能
  bool enableRestore = true;

  /// 用户数据备份(本地)目录, 缺省在数据文件所在目录创建一个dbFile.back目录
  String? backupFolder;

  /// SQLCipher 版本, 仅 macOS / Linux 平台有效
  NIMSqlCipherVersion sqlcipherVersion =
      NIMSqlCipherVersion.NIMSqlCipherVersion3;

  NIMDatabaseOption({
    this.encryptionKey,
    this.enableBackup = true,
    this.enableRestore = true,
    this.backupFolder,
    this.sqlcipherVersion = NIMSqlCipherVersion.NIMSqlCipherVersion3,
  });

  Map<String, dynamic> toJson() => _$NIMDatabaseOptionToJson(this);

  factory NIMDatabaseOption.fromJson(Map<String, dynamic> map) =>
      _$NIMDatabaseOptionFromJson(map);
}

enum NIMSqlCipherVersion {
  @JsonValue(3)
  NIMSqlCipherVersion3,
  @JsonValue(4)
  NIMSqlCipherVersion4,
}

@JsonSerializable(explicitToJson: true)
class NIMFCSOption {
  /// 融合存储认证类型
  NIMFCSAuthType fcsAuthType = NIMFCSAuthType.NIMFCSAuthTypeNone;

  /// 自定义鉴权 Refer 信息
  String? customAuthRefer;

  /// 自定义鉴权 User Agent 信息
  String? customAuthUA;

  NIMFCSOption({
    this.fcsAuthType = NIMFCSAuthType.NIMFCSAuthTypeNone,
    this.customAuthRefer,
    this.customAuthUA,
  });

  Map<String, dynamic> toJson() => _$NIMFCSOptionToJson(this);

  factory NIMFCSOption.fromJson(Map<String, dynamic> map) =>
      _$NIMFCSOptionFromJson(map);
}

enum NIMFCSAuthType {
  /// 无鉴权
  @JsonValue(0)
  NIMFCSAuthTypeNone,

  /// refer 鉴权
  @JsonValue(1)
  NIMFCSAuthTypeRefer,

  /// 基于时间的 token 鉴权
  @JsonValue(2)
  NIMFCSAuthTypeTimeToken,

  /// 基于 URL 的 token 鉴权
  @JsonValue(3)
  NIMFCSAuthTypeUrlToken,

  /// Custom 鉴权
  @JsonValue(4)
  NIMFCSAuthTypeCustom,
}

@JsonSerializable(explicitToJson: true)
class NIMPrivateServerOption {
  /// IP 协议版本
  NIMIPProtocolVersion ipProtocolVersion =
      NIMIPProtocolVersion.NIMIPProtocolVersionIPv4;

  /// lbs 地址
  List<String>? lbsAddresses;

  /// nos lbs 地址
  String? nosLbsAddress;

  /// 默认 link 地址
  String? defaultLinkAddress;

  /// 默认 ipv6 link 地址
  String? defaultLinkAddressIpv6;

  /// 默认 nos 上传地址
  String? defaultNosUploadAddress;

  /// 默认 nos 上传主机地址
  String? defaultNosUploadHost;

  /// nos 下载地址拼接模板, 用于拼接最终得到的下载地址
  String? nosDownloadAddress;

  /// nos 加速域名列表
  List<String>? nosAccelerateHosts;

  /// nos 加速地址拼接模板, 用于获得加速后的下载地址
  String? nosAccelerateAddress;

  /// 探测 ipv4 地址类型使用的 url
  String? probeIpv4Url;

  /// 探测 ipv6 地址类型使用的 url
  String? probeIpv6Url;

  /// 非对称加密密钥 A, RSA: module, SM2: X
  String? asymmetricEncryptionKeyA;

  /// 非对称加密密钥 B, RSA: EXP, SM2: SM2Y
  String? asymmetricEncryptionKeyB;

  /// 非对称加密算法 key 版本号
  int asymmetricEncryptionKeyVersion = 0;

  NIMPrivateServerOption({
    this.ipProtocolVersion = NIMIPProtocolVersion.NIMIPProtocolVersionIPv4,
    this.lbsAddresses,
    this.nosLbsAddress,
    this.defaultLinkAddress,
    this.defaultLinkAddressIpv6,
    this.defaultNosUploadAddress,
    this.defaultNosUploadHost,
    this.nosDownloadAddress,
    this.nosAccelerateHosts,
    this.nosAccelerateAddress,
    this.probeIpv4Url,
    this.probeIpv6Url,
    this.asymmetricEncryptionKeyA,
    this.asymmetricEncryptionKeyB,
    this.asymmetricEncryptionKeyVersion = 0,
  });

  Map<String, dynamic> toJson() => _$NIMPrivateServerOptionToJson(this);

  factory NIMPrivateServerOption.fromJson(Map<String, dynamic> map) =>
      _$NIMPrivateServerOptionFromJson(map);
}

enum NIMIPProtocolVersion {
  /// 未指定, 自动判断
  @JsonValue(0)
  NIMIPProtocolVersionUnspecified,

  /// IPv4
  @JsonValue(1)
  NIMIPProtocolVersionIPv4,

  /// IPv6
  @JsonValue(2)
  NIMIPProtocolVersionIPv6,
}
