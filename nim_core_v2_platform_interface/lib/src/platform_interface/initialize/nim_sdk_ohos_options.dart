// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

part 'nim_sdk_ohos_options.g.dart';

@JsonSerializable()
class NIMOHOSSDKOptions extends NIMSDKOptions {
  ///
  /// 日志分级， SDK 将根据您设置的级别，进行日志采集，建议您，将log级别设置为 Debug。您也可以不进行设置，默认级别就是Debug
  /// 可选值 "Error" | "Warn" | "Info" | "Debug"。
  /// 和鸿蒙系统日志方案相同， 如果选择 Debug， 将输出全部等级log，选择Error 只会输出Error 级别log
  ///
  @JsonKey(defaultValue: LogLevel.Debug)
  final LogLevel? logLevel;

  ///
  /// 建立连接时的 xhr 请求的超时时间。默认为 30000 ms
  ///
  @JsonKey(defaultValue: 30000)
  final int xhrConnectTimeout;

  ///
  /// 建立 socket 长连接的超时时间。默认为 30000 ms
  ///
  @JsonKey(defaultValue: 30000)
  final int socketConnectTimeout;

  ///
  /// 是否将SDK log 输出到控制台, 默认不输出。
  ///
  @JsonKey(defaultValue: false)
  final bool isOpenConsoleLog;

  ///
  /// 是否将过滤输出到日志文件内信息。
  ///
  @JsonKey(defaultValue: false)
  final bool isFilteringLog;

  /// 配置专属服务器的地址
  @JsonKey(fromJson: _serverOptionFromMap, toJson: _serverOptionToJson)
  NIMServiceOptions? serverOptions;

  NIMOHOSSDKOptions({
    /// ohos configurations
    this.logLevel,
    this.xhrConnectTimeout = 30000,
    this.socketConnectTimeout = 2000,
    this.isOpenConsoleLog = false,
    this.isFilteringLog = false,
    this.serverOptions,

    /// common configurations
    required String appKey,
    String? sdkRootDir,
    int? cdnTrackInterval,
    int? customClientType,
    bool? shouldSyncStickTopSessionInfos,
    bool? enableReportLogAutomatically,
    String? loginCustomTag,
    bool? enableDatabaseBackup,
    bool? shouldSyncUnreadCount,
    bool? shouldConsiderRevokedMessageUnreadCount,
    bool? enableTeamMessageReadReceipt,
    bool? shouldTeamNotificationMessageMarkUnread,
    bool? enableAnimatedImageThumbnail,
    bool? enablePreloadMessageAttachment,
    bool? useAssetServerAddressConfig,
    Map<NIMNosScene, int>? nosSceneConfig,
    NIMServerConfig? serverConfig,
    bool enableFcs = true,
  }) : super(
          appKey: appKey,
          sdkRootDir: sdkRootDir,
          cdnTrackInterval: cdnTrackInterval,
          customClientType: customClientType,
          shouldSyncStickTopSessionInfos: shouldSyncStickTopSessionInfos,
          enableReportLogAutomatically: enableReportLogAutomatically,
          loginCustomTag: loginCustomTag,
          enableDatabaseBackup: enableDatabaseBackup,
          shouldSyncUnreadCount: shouldSyncUnreadCount,
          shouldConsiderRevokedMessageUnreadCount:
              shouldConsiderRevokedMessageUnreadCount,
          enableTeamMessageReadReceipt: enableTeamMessageReadReceipt,
          shouldTeamNotificationMessageMarkUnread:
              shouldTeamNotificationMessageMarkUnread,
          enableAnimatedImageThumbnail: enableAnimatedImageThumbnail,
          enablePreloadMessageAttachment: enablePreloadMessageAttachment,
          useAssetServerAddressConfig: useAssetServerAddressConfig,
          nosSceneConfig: nosSceneConfig,
          serverConfig: serverConfig,
          enableFcs: enableFcs,
        );

  factory NIMOHOSSDKOptions.fromMap(Map options) =>
      _$NIMOHOSSDKOptionsFromJson(Map<String, dynamic>.from(options));

  @override
  Map<String, dynamic> toMap() => _$NIMOHOSSDKOptionsToJson(this);
}

NIMServiceOptions? _serverOptionFromMap(Map? map) => map == null
    ? null
    : NIMServiceOptions.fromJson(map.cast<String, dynamic>());

Map? _serverOptionToJson(NIMServiceOptions? serverOption) =>
    serverOption?.toJson();

/// 服务配置选项总类
@JsonSerializable(explicitToJson: true)
class NIMServiceOptions {
  /// 登录模块特殊配置
  @JsonKey(fromJson: _LoginServiceConfigFromMap)
  final NIMOHLoginServiceConfig? loginServiceConfig;

  /// 消息模块配置
  @JsonKey(fromJson: _messageServiceConfigFromMap)
  final NIMMessageServiceConfig? messageServiceConfig;

  /// 好友模块配置
  @JsonKey(fromJson: _friendServiceConfigFromMap)
  NIMFriendServiceConfig? friendServiceConfig;

  /// 推送配置
  @JsonKey(fromJson: _pushServiceConfigFromMap)
  final NIMPushServiceConfig? pushServiceConfig;

  /// HTTP配置
  @JsonKey(fromJson: _httpServiceConfigFromMap)
  final NIMHttpServiceConfig? httpServiceConfig;

  /// 数据库配置
  @JsonKey(name: 'databaseServiceConfig', fromJson: _databaseOptionsFromMap)
  final DatabaseOptions? databaseOptions;

  /// 存储服务配置
  @JsonKey(fromJson: _storageServiceConfigFromMap)
  final NIMStorageServiceConfig? storageServiceConfig;

  /// 云端会话配置
  @JsonKey(
      name: 'conversationServiceConfig', fromJson: _conversationConfigFromMap)
  final V2NIMConversationConfig? conversationConfig;

  /// 本地会话配置
  @JsonKey(
      name: 'localConversationServiceConfig',
      fromJson: _localConversationConfigFromMap)
  final LocalConversationConfig? localConversationConfig;

  /// 群组配置
  @JsonKey(fromJson: _teamServiceConfigFromMap)
  V2NIMTeamConfig? teamServiceConfig;

  /// 搜索配置
  @JsonKey(fromJson: _searchServiceConfigFromMap)
  final V2NIMSearchConfig? searchServiceConfig;

  /// 数据上报配置
  @JsonKey(fromJson: _dataReporterConfigFromMap)
  final DataReporterConfig? dataReporterConfig;

  /// ABT配置
  @JsonKey(fromJson: _abtServiceConfigFromMap)
  final ABTConfig? abtServiceConfig;

  NIMServiceOptions({
    this.loginServiceConfig,
    this.messageServiceConfig,
    this.friendServiceConfig,
    this.pushServiceConfig,
    this.httpServiceConfig,
    this.databaseOptions,
    this.storageServiceConfig,
    this.conversationConfig,
    this.localConversationConfig,
    this.teamServiceConfig,
    this.searchServiceConfig,
    this.dataReporterConfig,
    this.abtServiceConfig,
  });

  factory NIMServiceOptions.fromJson(Map<String, dynamic> json) =>
      _$NIMServiceOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$NIMServiceOptionsToJson(this);
}

/// 基础服务配置
@JsonSerializable()
class NIMServiceConfig {
  /// 登录账号
  @JsonKey(defaultValue: [])
  final List<String>? services;

  NIMServiceConfig({
    this.services,
  });

  factory NIMServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMServiceConfigFromJson(json);

  Map<String, dynamic> toJson() => _$NIMServiceConfigToJson(this);
}

NIMOHLoginServiceConfig? _LoginServiceConfigFromMap(Map? map) => map == null
    ? null
    : NIMOHLoginServiceConfig.fromJson(map.cast<String, dynamic>());

NIMMessageServiceConfig? _messageServiceConfigFromMap(Map? map) => map == null
    ? null
    : NIMMessageServiceConfig.fromJson(map.cast<String, dynamic>());

NIMFriendServiceConfig? _friendServiceConfigFromMap(Map? map) => map == null
    ? null
    : NIMFriendServiceConfig.fromJson(map.cast<String, dynamic>());

NIMPushServiceConfig? _pushServiceConfigFromMap(Map? map) => map == null
    ? null
    : NIMPushServiceConfig.fromJson(map.cast<String, dynamic>());

NIMHttpServiceConfig? _httpServiceConfigFromMap(Map? map) => map == null
    ? null
    : NIMHttpServiceConfig.fromJson(map.cast<String, dynamic>());
DatabaseOptions? _databaseOptionsFromMap(Map? map) =>
    map == null ? null : DatabaseOptions.fromJson(map.cast<String, dynamic>());
NIMStorageServiceConfig? _storageServiceConfigFromMap(Map? map) => map == null
    ? null
    : NIMStorageServiceConfig.fromJson(map.cast<String, dynamic>());
V2NIMConversationConfig? _conversationConfigFromMap(Map? map) => map == null
    ? null
    : V2NIMConversationConfig.fromJson(map.cast<String, dynamic>());
LocalConversationConfig? _localConversationConfigFromMap(Map? map) =>
    map == null
        ? null
        : LocalConversationConfig.fromJson(map.cast<String, dynamic>());
V2NIMTeamConfig? _teamServiceConfigFromMap(Map? map) =>
    map == null ? null : V2NIMTeamConfig.fromJson(map.cast<String, dynamic>());
V2NIMSearchConfig? _searchServiceConfigFromMap(Map? map) => map == null
    ? null
    : V2NIMSearchConfig.fromJson(map.cast<String, dynamic>());
DataReporterConfig? _dataReporterConfigFromMap(Map? map) => map == null
    ? null
    : DataReporterConfig.fromJson(map.cast<String, dynamic>());
ABTConfig? _abtServiceConfigFromMap(Map? map) =>
    map == null ? null : ABTConfig.fromJson(map.cast<String, dynamic>());

/// 登录模块配置
@JsonSerializable()
class NIMOHLoginServiceConfig extends NIMServiceConfig {
  NIMOHLoginServiceConfig({
    super.services,
    this.lbsUrls,
    this.linkUrl,
    this.customClientType,
    this.customTag,
    this.isHttps,
    this.supportProtocolFamily,
    this.lbsCacheExpirationInterval,
    this.lbsCacheRefreshInterval,
  });

  @JsonKey(defaultValue: [])
  final List<String>? lbsUrls;

  @JsonKey(defaultValue: null)
  final String? linkUrl;

  @JsonKey(defaultValue: null)
  final int? customClientType;

  @JsonKey(defaultValue: null)
  final String? customTag;

  @JsonKey(defaultValue: false)
  final bool? isHttps;

  @JsonKey(defaultValue: null)
  final NIMProtocolFamily? supportProtocolFamily;

  /// lbs 缓存过期时间，默认 1000 * 3600 * 24 * 7
  @JsonKey(defaultValue: null)
  final int? lbsCacheExpirationInterval;

  /// lbs 刷新间隔，默认 1000 * 3600 * 24 * 1
  @JsonKey(defaultValue: null)
  final int? lbsCacheRefreshInterval;

  factory NIMOHLoginServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMOHLoginServiceConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NIMOHLoginServiceConfigToJson(this);
}

enum NIMProtocolFamily {
  @JsonValue(0)
  IPV4,

  @JsonValue(1)
  IPV6,

  @JsonValue(2)
  DUAL_STACK,
}

/// 消息模块配置
@JsonSerializable()
class NIMMessageServiceConfig extends NIMServiceConfig {
  NIMMessageServiceConfig({super.services, this.shouldIgnore});

  /// 消息过滤函数
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool Function(dynamic msg)? shouldIgnore;

  factory NIMMessageServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMMessageServiceConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NIMMessageServiceConfigToJson(this);
}

/// 好友模块配置
@JsonSerializable()
class NIMFriendServiceConfig extends NIMServiceConfig {
  NIMFriendServiceConfig({
    super.services,
    this.enableServerV2FriendAddApplication,
  });

  /// 是否开启服务端好友申请记录功能
  @JsonKey(defaultValue: false)
  final bool? enableServerV2FriendAddApplication;

  factory NIMFriendServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMFriendServiceConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NIMFriendServiceConfigToJson(this);
}

/// 推送配置
@JsonSerializable()
class NIMPushServiceConfig extends NIMServiceConfig {
  NIMPushServiceConfig({
    super.services,
    this.harmonyCertificateName,
    this.customPushContentType,
  });

  /// 鸿蒙推送证书名，与云信控制台推送证书的证书名称对应。
  @JsonKey(defaultValue: null)
  final String? harmonyCertificateName;

  /// 鸿蒙自定义推送文案类型。
  @JsonKey(defaultValue: null)
  final String? customPushContentType;

  factory NIMPushServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMPushServiceConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NIMPushServiceConfigToJson(this);
}

/// HTTP服务配置
@JsonSerializable()
class NIMHttpServiceConfig extends NIMServiceConfig {
  /// NOS上传地址（分片）
  final String? chunkUploadHost;

  /// 发送文件消息中文件的url的通配符地址
  final String? uploadReplaceFormat;

  NIMHttpServiceConfig({
    super.services,
    this.chunkUploadHost,
    this.uploadReplaceFormat,
  });

  factory NIMHttpServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMHttpServiceConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NIMHttpServiceConfigToJson(this);
}

/// 数据库配置
@JsonSerializable()
class DatabaseOptions extends NIMServiceConfig {
  /// 初始化appKey（必须与初始化使用的一致）
  final String appKey;

  /// 数据库安全级别（默认S1）
  @JsonKey(defaultValue: 1)
  final int? securityLevel;

  /// 是否加密（默认不加密）
  @JsonKey(defaultValue: false)
  final bool? encrypt;

  /// 是否启用数据库自动备份。默认 true。
  @JsonKey(defaultValue: true)
  final bool? backupEnabled;

  /// 每个库保留的备份数量。默认 2。
  @JsonKey(defaultValue: 2)
  final int? backupRetentionCount;

  /// 自动备份时间间隔，单位小时。默认 12。
  @JsonKey(defaultValue: 12)
  final int? backupIntervalHours;

  /// 打开数据库后是否执行健康检查。默认 true。
  @JsonKey(defaultValue: true)
  final bool? healthCheckOnOpen;

  /// 打开失败或健康检查失败时是否自动尝试恢复。默认 true。
  @JsonKey(defaultValue: true)
  final bool? autoRecoverOnOpenFailure;

  DatabaseOptions({
    super.services,
    required this.appKey,
    this.securityLevel,
    this.encrypt,
    this.backupEnabled,
    this.backupRetentionCount,
    this.backupIntervalHours,
    this.healthCheckOnOpen,
    this.autoRecoverOnOpenFailure,
  });

  factory DatabaseOptions.fromJson(Map<String, dynamic> json) =>
      _$DatabaseOptionsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DatabaseOptionsToJson(this);
}

/// 存储服务配置
@JsonSerializable()
class NIMStorageServiceConfig extends NIMServiceConfig {
  /// NOS下载地址
  final String? downloadHost;

  /// 下载url通配符地址
  final String? downloadReplaceFormat;

  /// 是否选择 http request download，默认 false
  @JsonKey(defaultValue: false)
  final bool? httpRequestDownload;

  NIMStorageServiceConfig({
    super.services,
    this.downloadHost,
    this.downloadReplaceFormat,
    this.httpRequestDownload,
  });

  factory NIMStorageServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMStorageServiceConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NIMStorageServiceConfigToJson(this);
}

/// 云端会话配置
@JsonSerializable()
class V2NIMConversationConfig extends NIMServiceConfig {
  /// 历史会话加载限制（默认10000）
  @JsonKey(defaultValue: 10000)
  final int? loadHistoryConversationLimit;

  /// V2 云端会话增量同步时是否分发会话变更通知并即时刷新未读
  @JsonKey(defaultValue: false)
  final bool? enableV2ConversationIncrementalSyncNotify;

  V2NIMConversationConfig({
    super.services,
    this.loadHistoryConversationLimit,
    this.enableV2ConversationIncrementalSyncNotify,
  });

  factory V2NIMConversationConfig.fromJson(Map<String, dynamic> json) =>
      _$V2NIMConversationConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$V2NIMConversationConfigToJson(this);
}

/// 本地会话配置
@JsonSerializable()
class LocalConversationConfig extends NIMServiceConfig {
  /// 未读数过滤函数
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool Function(dynamic msg)? unreadCountFilterFn;

  /// 最后一条消息过滤函数
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool Function(dynamic msg)? lastMessageFilterFn;

  /// 撤回消息后，本地会话最后一条消息是否使用上一条消息
  @JsonKey(defaultValue: false)
  final bool? useLastMessageOnRevoke;

  /// 删除会话后，是否清理会话未读数
  @JsonKey(defaultValue: false)
  final bool? clearUnreadAfterDeleteConversation;

  LocalConversationConfig({
    super.services,
    this.unreadCountFilterFn,
    this.lastMessageFilterFn,
    this.useLastMessageOnRevoke,
    this.clearUnreadAfterDeleteConversation,
  });

  factory LocalConversationConfig.fromJson(Map<String, dynamic> json) =>
      _$LocalConversationConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LocalConversationConfigToJson(this);
}

/// 群组设置
@JsonSerializable()
class V2NIMTeamConfig extends NIMServiceConfig {
  V2NIMTeamConfig({
    super.services,
    this.enableServerV2TeamJoinActionInfo,
  });

  /// 是否使用新的群申请通知
  @JsonKey(defaultValue: false)
  final bool? enableServerV2TeamJoinActionInfo;

  factory V2NIMTeamConfig.fromJson(Map<String, dynamic> json) =>
      _$V2NIMTeamConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$V2NIMTeamConfigToJson(this);
}

/// 搜索设置
@JsonSerializable()
class V2NIMSearchConfig extends NIMServiceConfig {
  V2NIMSearchConfig({
    super.services,
    this.searchAccountIdEnabled,
  });

  /// 云信账号 ID 字段全文检索索引构建开关
  @JsonKey(defaultValue: false)
  final bool? searchAccountIdEnabled;

  factory V2NIMSearchConfig.fromJson(Map<String, dynamic> json) =>
      _$V2NIMSearchConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$V2NIMSearchConfigToJson(this);
}

/// 数据上报配置
@JsonSerializable()
class DataReporterConfig extends NIMServiceConfig {
  /// 是否关闭异常上报（默认false，即开启）
  @JsonKey(defaultValue: false)
  final bool isCloseDataReporter;

  /// 异常上报地址
  final String? dataReporterAddress;

  DataReporterConfig({
    super.services,
    required this.isCloseDataReporter,
    this.dataReporterAddress,
  });

  factory DataReporterConfig.fromJson(Map<String, dynamic> json) =>
      _$DataReporterConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DataReporterConfigToJson(this);
}

/// ABT配置
@JsonSerializable()
class ABTConfig extends NIMServiceConfig {
  /// ABT 地址
  final String abtUrl;

  ABTConfig({
    super.services,
    required this.abtUrl,
  });

  factory ABTConfig.fromJson(Map<String, dynamic> json) =>
      _$ABTConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ABTConfigToJson(this);
}

/// 本地会话设置（原V2NIMLocalConversationConfig）
@JsonSerializable()
class V2NIMLocalConversationConfig extends NIMServiceConfig {
  V2NIMLocalConversationConfig({
    super.services,
    this.useLastMessageOnRevoke,
    this.clearUnreadAfterDeleteConversation,
  });

  /// 撤回消息后，本地会话最后一条消息是否使用上一条消息
  @JsonKey(defaultValue: false)
  final bool? useLastMessageOnRevoke;

  /// 删除会话后，是否清理会话未读数
  @JsonKey(defaultValue: false)
  final bool? clearUnreadAfterDeleteConversation;

  factory V2NIMLocalConversationConfig.fromJson(Map<String, dynamic> json) =>
      _$V2NIMLocalConversationConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$V2NIMLocalConversationConfigToJson(this);
}

enum LogLevel {
  @JsonValue(0)
  Debug,
  @JsonValue(1)
  Info,
  @JsonValue(2)
  Warn,
  @JsonValue(3)
  Error
}
