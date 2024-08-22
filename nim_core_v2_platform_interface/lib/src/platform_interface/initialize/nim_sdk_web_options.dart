// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/src/platform_interface/initialize/nim_sdk_options.dart';

part 'nim_sdk_web_options.g.dart';

@JsonSerializable(explicitToJson: true)
class NIMInitializeOptions {
  /// app key
  final String appkey;

  /// api 版本，请传入 'v2'
  final String? apiVersion;

  /// 是否采用二进制的形式传输数据，默认为 true
  final bool? binaryWebsocket;

  /// 日志级别，默认为 off，即不输出任何日志
  /// off: 不输出任何日志
  /// debug: 输出所有日志
  /// log: 输出 log、warn、 error 级别的日志
  /// warn: 输出 warn 和 error 级别的日志
  /// error: 输出 error 级别的日志
  final String? debugLevel;

  /// loginSDKTypeParamCompat
  final bool? loginSDKTypeParamCompat;

  /// loginExtensionProvider 延迟加载时间，单位毫秒，默认 500 ms
  final int? loginExtensionProviderDelay;

  /// tokenProvider 延迟加载时间，单位毫秒，默认 500 ms
  final int? tokenProviderDelay;

  /// reconnectDelayProvider 延迟加载时间，单位毫秒，默认 500 ms
  final int? reconnectDelayProviderDelay;

  NIMInitializeOptions({
    required this.appkey,
    this.apiVersion,
    this.binaryWebsocket,
    this.debugLevel,
    this.loginSDKTypeParamCompat,
    this.loginExtensionProviderDelay,
    this.tokenProviderDelay,
    this.reconnectDelayProviderDelay,
  });

  factory NIMInitializeOptions.fromJson(Map<String, dynamic> json) =>
      _$NIMInitializeOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$NIMInitializeOptionsToJson(this);
}

NIMLoginServiceConfig? _nimLoginServiceConfigFromJson(Map? map) {
  if (map != null) {
    return NIMLoginServiceConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMAbtestConfig? _nimAbtestConfigFromJson(Map? map) {
  if (map != null) {
    return NIMAbtestConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMCloudStorageConfig? _nimCloudStorageConfigJson(Map? map) {
  if (map != null) {
    return NIMCloudStorageConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

NIMReporterConfig? _nimReporterConfigFromJson(Map? map) {
  if (map != null) {
    return NIMReporterConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class NIMOtherOptions {
  /// v2 登录模块的特殊配置
  @JsonKey(fromJson: _nimLoginServiceConfigFromJson)
  final NIMLoginServiceConfig? loginServiceConfig;

  /// ABtest 配置
  @JsonKey(fromJson: _nimAbtestConfigFromJson)
  final NIMAbtestConfig? abtestConfig;

  /// cloud storage 模块配置
  @JsonKey(fromJson: _nimCloudStorageConfigJson)
  final NIMCloudStorageConfig? cloudStorageConfig;

  /// SDK 上报收集数据的配置
  @JsonKey(fromJson: _nimReporterConfigFromJson)
  final NIMReporterConfig? reporterConfig;

  /// session 模块配置
  // final NIMSessionConfig? sessionConfig;

  NIMOtherOptions({
    this.loginServiceConfig,
    this.abtestConfig,
    this.cloudStorageConfig,
    this.reporterConfig,
    // this.sessionConfig,
  });

  factory NIMOtherOptions.fromJson(Map<String, dynamic> json) =>
      _$NIMOtherOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$NIMOtherOptionsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMLoginServiceConfig {
  /// 自定义客户端类型，大于0
  final int? customClientType;

  /// 客户端自定义 tag, 登录时多端同步该字段，最大32个字符
  final String? customTag;

  /// 是否 deviceId 需要固定下来。默认 false。
  /// true：sdk 随机对设备生成一个设备标识并存入 localstorage 缓存起来，也就是说一个浏览器来说所有 SDK 实例连接都被认为是共同的设备。
  /// false：每一个 sdk 实例连接时，使用随机的字符串作为设备标识，相当于每个实例采用的不同的设备连接上来的。
  /// 注意：这个参数会影响多端互踢的策略。有关于多端互踢策略的配置可以参见服务器文档。
  final bool? isFixedDeviceId;

  /// lbs 地址，默认为云信公网提供的链接。SDK 连接时会向 lbs 地址请求得到 socket 连接地址。
  /// 注：为了防止 lbs 链接被网络运营商劫持，开发者可以传入自己代理的地址做备份，['公网地址', '代理地址']
  final List<String>? lbsUrls;

  /// socket 备用地址，当 lbs 请求失败时，尝试直接连接 socket 备用地址。
  /// 注：优先级最高的是 lbs 地址下发的 socket 连接地址， 次为开发者在此填的 socket 备用地址（如果不填这个字段， SDK 会有内部默认的备用地址）
  final String? linkUrl;

  NIMLoginServiceConfig({
    this.customClientType,
    this.customTag,
    this.isFixedDeviceId,
    this.lbsUrls,
    this.linkUrl,
  });

  factory NIMLoginServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMLoginServiceConfigFromJson(json);

  Map<String, dynamic> toJson() => _$NIMLoginServiceConfigToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMCloudStorageConfig {
  /// NOS 上传专用的 cdn 配置
  final NIMCdnConfig? cdn;

  /// NOS上传地址（分片）
  final String? chunkUploadHost;

  /// NOS上传地址（直传）
  final String? commonUploadHost;

  /// 收到哪些host地址，需要替换成downloadUrl，例：收到nos.netease.com/{bucket}/{obj}
  final List<String>? downloadHostList;

  /// 接收到文件消息的替换模版 这个是用来接到消息后，要按一定模式替换掉文件链接的。给予一个安全下载链接。 例：'https://{bucket}-nosdn.netease.im/{object}'
  final String? downloadUrl;

  /// 是否需要开启融合存储整个策略。默认为 true
  /// 注: 为 false 则不会进行 lbs 灰度开关和策略获取，直接退化到老的 nos 上传逻辑。
  final bool? isNeedToGetUploadPolicyFromServer;

  /// 服务器下发的域名存在，并且对象前缀匹配成功，那么强行替换为${protocol}${serverCdnDomain}/${decodePath.slice(prefixIndex)}
  final bool? nosCdnEnable;

  /// 是否使用 amazon aws s3 sdk
  final bool? s3;

  /// localStorage 缓存的云存储配置的键名的前缀。默认叫 NIMClient
  /// 注: 举个例子，根据默认配置，策略缓存的键叫 'NIMClient-AllGrayscaleConfig'。
  final String? storageKeyPrefix;

  /// 发送文件消息中文件的url的通配符地址，例：'https://{host}/{object}'
  final String? uploadReplaceFormat;

  NIMCloudStorageConfig({
    this.cdn,
    this.chunkUploadHost,
    this.commonUploadHost,
    this.downloadHostList,
    this.downloadUrl,
    this.isNeedToGetUploadPolicyFromServer,
    this.nosCdnEnable,
    this.s3,
    this.storageKeyPrefix,
    this.uploadReplaceFormat,
  });

  factory NIMCloudStorageConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMCloudStorageConfigFromJson(json);

  Map<String, dynamic> toJson() => _$NIMCloudStorageConfigToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMCdnConfig {
  /// 桶名, 一般 NOS 默认为 "nim"
  final String? bucket;

  /// 下载域名
  final String? cdnDomain;

  /// 默认的下载域名
  final String? defaultCdnDomain;

  /// 路径前缀，一般不需要填写
  final String? objectNamePrefix;

  NIMCdnConfig({
    this.bucket,
    this.cdnDomain,
    this.defaultCdnDomain,
    this.objectNamePrefix,
  });

  factory NIMCdnConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMCdnConfigFromJson(json);

  Map<String, dynamic> toJson() => _$NIMCdnConfigToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMReporterConfig {
  /// 是否开启数据上报，默认是true
  final bool? isDataReportEnable;

  /// 获取数据上报配置的地址
  final String? reportConfigUrl;

  /// 数据上报地址
  final String? reportUrl;

  NIMReporterConfig({
    this.isDataReportEnable,
    this.reportConfigUrl,
    this.reportUrl,
  });

  factory NIMReporterConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMReporterConfigFromJson(json);

  Map<String, dynamic> toJson() => _$NIMReporterConfigToJson(this);
}

// class NIMSessionConfig {
//   /// TODO lastMessageFilterFn

//   /// TODO unreadCountFilterFn
// }

@JsonSerializable(explicitToJson: true)
class NIMAbtestConfig {
  /// abTest 服务器下发地址
  final String? abtestUrl;

  /// ABtest 是否开启，默认 true 开启
  /// 注: 打开这个开关，在 sdk 内部会试探某些新功能的开启，建议开发者不要轻易设置它。
  final bool? isAbtestEnable;

  NIMAbtestConfig({
    this.abtestUrl,
    this.isAbtestEnable,
  });

  factory NIMAbtestConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMAbtestConfigFromJson(json);

  Map<String, dynamic> toJson() => _$NIMAbtestConfigToJson(this);
}

NIMInitializeOptions _nimInitializeOptionsFromJson(Map map) {
  return NIMInitializeOptions.fromJson(map.cast<String, dynamic>());
}

NIMOtherOptions? _nimOtherOptionsFromJson(Map? map) {
  if (map != null) {
    return NIMOtherOptions.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class NIMWebSDKOptions extends NIMSDKOptions {
  /// define iOS options here

  /// 初始化参数
  @JsonKey(fromJson: _nimInitializeOptionsFromJson)
  NIMInitializeOptions initializeOptions;

  /// 其他初始化参数
  @JsonKey(fromJson: _nimOtherOptionsFromJson)
  NIMOtherOptions? otherOptions;

  NIMWebSDKOptions({
    required this.initializeOptions,
    this.otherOptions,
    required super.appKey,
  });

  factory NIMWebSDKOptions.fromMap(Map<String, dynamic> json) =>
      _$NIMWebSDKOptionsFromJson(json);

  Map<String, dynamic> toMap() => _$NIMWebSDKOptionsToJson(this);
}
