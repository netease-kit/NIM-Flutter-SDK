// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nim_sdk_ohos_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMOHOSSDKOptions _$NIMOHOSSDKOptionsFromJson(Map<String, dynamic> json) =>
    NIMOHOSSDKOptions(
      logLevel: $enumDecodeNullable(_$LogLevelEnumMap, json['logLevel']) ??
          LogLevel.Debug,
      xhrConnectTimeout: (json['xhrConnectTimeout'] as num?)?.toInt() ?? 30000,
      socketConnectTimeout:
          (json['socketConnectTimeout'] as num?)?.toInt() ?? 30000,
      isOpenConsoleLog: json['isOpenConsoleLog'] as bool? ?? false,
      isFilteringLog: json['isFilteringLog'] as bool? ?? false,
      serverOptions: _serverOptionFromMap(json['serverOptions'] as Map?),
      appKey: json['appKey'] as String,
      sdkRootDir: json['sdkRootDir'] as String?,
      cdnTrackInterval: (json['cdnTrackInterval'] as num?)?.toInt(),
      customClientType: (json['customClientType'] as num?)?.toInt(),
      shouldSyncStickTopSessionInfos:
          json['shouldSyncStickTopSessionInfos'] as bool?,
      enableReportLogAutomatically:
          json['enableReportLogAutomatically'] as bool?,
      loginCustomTag: json['loginCustomTag'] as String?,
      enableDatabaseBackup: json['enableDatabaseBackup'] as bool?,
      shouldSyncUnreadCount: json['shouldSyncUnreadCount'] as bool?,
      shouldConsiderRevokedMessageUnreadCount:
          json['shouldConsiderRevokedMessageUnreadCount'] as bool?,
      enableTeamMessageReadReceipt:
          json['enableTeamMessageReadReceipt'] as bool?,
      shouldTeamNotificationMessageMarkUnread:
          json['shouldTeamNotificationMessageMarkUnread'] as bool?,
      enableAnimatedImageThumbnail:
          json['enableAnimatedImageThumbnail'] as bool?,
      enablePreloadMessageAttachment:
          json['enablePreloadMessageAttachment'] as bool?,
      useAssetServerAddressConfig: json['useAssetServerAddressConfig'] as bool?,
      nosSceneConfig: nosSceneConfigFromMap(json['nosSceneConfig'] as Map?),
      serverConfig: serverConfigFromMap(json['serverConfig'] as Map?),
      enableFcs: json['enableFcs'] as bool? ?? true,
    );

Map<String, dynamic> _$NIMOHOSSDKOptionsToJson(NIMOHOSSDKOptions instance) =>
    <String, dynamic>{
      'appKey': instance.appKey,
      'sdkRootDir': instance.sdkRootDir,
      'customClientType': instance.customClientType,
      'cdnTrackInterval': instance.cdnTrackInterval,
      'enableDatabaseBackup': instance.enableDatabaseBackup,
      'loginCustomTag': instance.loginCustomTag,
      'shouldSyncUnreadCount': instance.shouldSyncUnreadCount,
      'shouldConsiderRevokedMessageUnreadCount':
          instance.shouldConsiderRevokedMessageUnreadCount,
      'enableTeamMessageReadReceipt': instance.enableTeamMessageReadReceipt,
      'shouldTeamNotificationMessageMarkUnread':
          instance.shouldTeamNotificationMessageMarkUnread,
      'enableAnimatedImageThumbnail': instance.enableAnimatedImageThumbnail,
      'enablePreloadMessageAttachment': instance.enablePreloadMessageAttachment,
      'shouldSyncStickTopSessionInfos': instance.shouldSyncStickTopSessionInfos,
      'enableReportLogAutomatically': instance.enableReportLogAutomatically,
      'useAssetServerAddressConfig': instance.useAssetServerAddressConfig,
      'nosSceneConfig': instance.nosSceneConfig,
      'serverConfig': serverConfigToJson(instance.serverConfig),
      'enableFcs': instance.enableFcs,
      'logLevel': _$LogLevelEnumMap[instance.logLevel],
      'xhrConnectTimeout': instance.xhrConnectTimeout,
      'socketConnectTimeout': instance.socketConnectTimeout,
      'isOpenConsoleLog': instance.isOpenConsoleLog,
      'isFilteringLog': instance.isFilteringLog,
      'serverOptions': _serverOptionToJson(instance.serverOptions),
    };

const _$LogLevelEnumMap = {
  LogLevel.Debug: 0,
  LogLevel.Info: 1,
  LogLevel.Warn: 2,
  LogLevel.Error: 3,
};

NIMServiceOptions _$NIMServiceOptionsFromJson(Map<String, dynamic> json) =>
    NIMServiceOptions(
      loginServiceConfig:
          _LoginServiceConfigFromMap(json['loginServiceConfig'] as Map?),
      messageServiceConfig:
          _messageServiceConfigFromMap(json['messageServiceConfig'] as Map?),
      friendServiceConfig:
          _friendServiceConfigFromMap(json['friendServiceConfig'] as Map?),
      pushServiceConfig:
          _pushServiceConfigFromMap(json['pushServiceConfig'] as Map?),
      httpServiceConfig:
          _httpServiceConfigFromMap(json['httpServiceConfig'] as Map?),
      databaseOptions:
          _databaseOptionsFromMap(json['databaseServiceConfig'] as Map?),
      storageServiceConfig:
          _storageServiceConfigFromMap(json['storageServiceConfig'] as Map?),
      conversationConfig:
          _conversationConfigFromMap(json['conversationServiceConfig'] as Map?),
      localConversationConfig: _localConversationConfigFromMap(
          json['localConversationServiceConfig'] as Map?),
      teamServiceConfig:
          _teamServiceConfigFromMap(json['teamServiceConfig'] as Map?),
      searchServiceConfig:
          _searchServiceConfigFromMap(json['searchServiceConfig'] as Map?),
      dataReporterConfig:
          _dataReporterConfigFromMap(json['dataReporterConfig'] as Map?),
      abtServiceConfig:
          _abtServiceConfigFromMap(json['abtServiceConfig'] as Map?),
    );

Map<String, dynamic> _$NIMServiceOptionsToJson(NIMServiceOptions instance) =>
    <String, dynamic>{
      'loginServiceConfig': instance.loginServiceConfig?.toJson(),
      'messageServiceConfig': instance.messageServiceConfig?.toJson(),
      'friendServiceConfig': instance.friendServiceConfig?.toJson(),
      'pushServiceConfig': instance.pushServiceConfig?.toJson(),
      'httpServiceConfig': instance.httpServiceConfig?.toJson(),
      'databaseServiceConfig': instance.databaseOptions?.toJson(),
      'storageServiceConfig': instance.storageServiceConfig?.toJson(),
      'conversationServiceConfig': instance.conversationConfig?.toJson(),
      'localConversationServiceConfig':
          instance.localConversationConfig?.toJson(),
      'teamServiceConfig': instance.teamServiceConfig?.toJson(),
      'searchServiceConfig': instance.searchServiceConfig?.toJson(),
      'dataReporterConfig': instance.dataReporterConfig?.toJson(),
      'abtServiceConfig': instance.abtServiceConfig?.toJson(),
    };

NIMServiceConfig _$NIMServiceConfigFromJson(Map<String, dynamic> json) =>
    NIMServiceConfig(
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$NIMServiceConfigToJson(NIMServiceConfig instance) =>
    <String, dynamic>{
      'services': instance.services,
    };

NIMOHLoginServiceConfig _$NIMOHLoginServiceConfigFromJson(
        Map<String, dynamic> json) =>
    NIMOHLoginServiceConfig(
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      lbsUrls: (json['lbsUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      linkUrl: json['linkUrl'] as String?,
      customClientType: (json['customClientType'] as num?)?.toInt(),
      customTag: json['customTag'] as String?,
      isHttps: json['isHttps'] as bool? ?? false,
      supportProtocolFamily: $enumDecodeNullable(
          _$NIMProtocolFamilyEnumMap, json['supportProtocolFamily']),
      lbsCacheExpirationInterval:
          (json['lbsCacheExpirationInterval'] as num?)?.toInt(),
      lbsCacheRefreshInterval:
          (json['lbsCacheRefreshInterval'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMOHLoginServiceConfigToJson(
        NIMOHLoginServiceConfig instance) =>
    <String, dynamic>{
      'services': instance.services,
      'lbsUrls': instance.lbsUrls,
      'linkUrl': instance.linkUrl,
      'customClientType': instance.customClientType,
      'customTag': instance.customTag,
      'isHttps': instance.isHttps,
      'supportProtocolFamily':
          _$NIMProtocolFamilyEnumMap[instance.supportProtocolFamily],
      'lbsCacheExpirationInterval': instance.lbsCacheExpirationInterval,
      'lbsCacheRefreshInterval': instance.lbsCacheRefreshInterval,
    };

const _$NIMProtocolFamilyEnumMap = {
  NIMProtocolFamily.IPV4: 0,
  NIMProtocolFamily.IPV6: 1,
  NIMProtocolFamily.DUAL_STACK: 2,
};

NIMMessageServiceConfig _$NIMMessageServiceConfigFromJson(
        Map<String, dynamic> json) =>
    NIMMessageServiceConfig(
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$NIMMessageServiceConfigToJson(
        NIMMessageServiceConfig instance) =>
    <String, dynamic>{
      'services': instance.services,
    };

NIMFriendServiceConfig _$NIMFriendServiceConfigFromJson(
        Map<String, dynamic> json) =>
    NIMFriendServiceConfig(
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      enableServerV2FriendAddApplication:
          json['enableServerV2FriendAddApplication'] as bool? ?? false,
    );

Map<String, dynamic> _$NIMFriendServiceConfigToJson(
        NIMFriendServiceConfig instance) =>
    <String, dynamic>{
      'services': instance.services,
      'enableServerV2FriendAddApplication':
          instance.enableServerV2FriendAddApplication,
    };

NIMPushServiceConfig _$NIMPushServiceConfigFromJson(
        Map<String, dynamic> json) =>
    NIMPushServiceConfig(
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      harmonyCertificateName: json['harmonyCertificateName'] as String?,
      customPushContentType: json['customPushContentType'] as String?,
    );

Map<String, dynamic> _$NIMPushServiceConfigToJson(
        NIMPushServiceConfig instance) =>
    <String, dynamic>{
      'services': instance.services,
      'harmonyCertificateName': instance.harmonyCertificateName,
      'customPushContentType': instance.customPushContentType,
    };

NIMHttpServiceConfig _$NIMHttpServiceConfigFromJson(
        Map<String, dynamic> json) =>
    NIMHttpServiceConfig(
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      chunkUploadHost: json['chunkUploadHost'] as String?,
      uploadReplaceFormat: json['uploadReplaceFormat'] as String?,
    );

Map<String, dynamic> _$NIMHttpServiceConfigToJson(
        NIMHttpServiceConfig instance) =>
    <String, dynamic>{
      'services': instance.services,
      'chunkUploadHost': instance.chunkUploadHost,
      'uploadReplaceFormat': instance.uploadReplaceFormat,
    };

DatabaseOptions _$DatabaseOptionsFromJson(Map<String, dynamic> json) =>
    DatabaseOptions(
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      appKey: json['appKey'] as String,
      securityLevel: (json['securityLevel'] as num?)?.toInt() ?? 1,
      encrypt: json['encrypt'] as bool? ?? false,
      backupEnabled: json['backupEnabled'] as bool? ?? true,
      backupRetentionCount:
          (json['backupRetentionCount'] as num?)?.toInt() ?? 2,
      backupIntervalHours: (json['backupIntervalHours'] as num?)?.toInt() ?? 12,
      healthCheckOnOpen: json['healthCheckOnOpen'] as bool? ?? true,
      autoRecoverOnOpenFailure:
          json['autoRecoverOnOpenFailure'] as bool? ?? true,
    );

Map<String, dynamic> _$DatabaseOptionsToJson(DatabaseOptions instance) =>
    <String, dynamic>{
      'services': instance.services,
      'appKey': instance.appKey,
      'securityLevel': instance.securityLevel,
      'encrypt': instance.encrypt,
      'backupEnabled': instance.backupEnabled,
      'backupRetentionCount': instance.backupRetentionCount,
      'backupIntervalHours': instance.backupIntervalHours,
      'healthCheckOnOpen': instance.healthCheckOnOpen,
      'autoRecoverOnOpenFailure': instance.autoRecoverOnOpenFailure,
    };

NIMStorageServiceConfig _$NIMStorageServiceConfigFromJson(
        Map<String, dynamic> json) =>
    NIMStorageServiceConfig(
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      downloadHost: json['downloadHost'] as String?,
      downloadReplaceFormat: json['downloadReplaceFormat'] as String?,
      httpRequestDownload: json['httpRequestDownload'] as bool? ?? false,
    );

Map<String, dynamic> _$NIMStorageServiceConfigToJson(
        NIMStorageServiceConfig instance) =>
    <String, dynamic>{
      'services': instance.services,
      'downloadHost': instance.downloadHost,
      'downloadReplaceFormat': instance.downloadReplaceFormat,
      'httpRequestDownload': instance.httpRequestDownload,
    };

V2NIMConversationConfig _$V2NIMConversationConfigFromJson(
        Map<String, dynamic> json) =>
    V2NIMConversationConfig(
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      loadHistoryConversationLimit:
          (json['loadHistoryConversationLimit'] as num?)?.toInt() ?? 10000,
      enableV2ConversationIncrementalSyncNotify:
          json['enableV2ConversationIncrementalSyncNotify'] as bool? ?? false,
    );

Map<String, dynamic> _$V2NIMConversationConfigToJson(
        V2NIMConversationConfig instance) =>
    <String, dynamic>{
      'services': instance.services,
      'loadHistoryConversationLimit': instance.loadHistoryConversationLimit,
      'enableV2ConversationIncrementalSyncNotify':
          instance.enableV2ConversationIncrementalSyncNotify,
    };

LocalConversationConfig _$LocalConversationConfigFromJson(
        Map<String, dynamic> json) =>
    LocalConversationConfig(
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      useLastMessageOnRevoke: json['useLastMessageOnRevoke'] as bool? ?? false,
      clearUnreadAfterDeleteConversation:
          json['clearUnreadAfterDeleteConversation'] as bool? ?? false,
    );

Map<String, dynamic> _$LocalConversationConfigToJson(
        LocalConversationConfig instance) =>
    <String, dynamic>{
      'services': instance.services,
      'useLastMessageOnRevoke': instance.useLastMessageOnRevoke,
      'clearUnreadAfterDeleteConversation':
          instance.clearUnreadAfterDeleteConversation,
    };

V2NIMTeamConfig _$V2NIMTeamConfigFromJson(Map<String, dynamic> json) =>
    V2NIMTeamConfig(
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      enableServerV2TeamJoinActionInfo:
          json['enableServerV2TeamJoinActionInfo'] as bool? ?? false,
    );

Map<String, dynamic> _$V2NIMTeamConfigToJson(V2NIMTeamConfig instance) =>
    <String, dynamic>{
      'services': instance.services,
      'enableServerV2TeamJoinActionInfo':
          instance.enableServerV2TeamJoinActionInfo,
    };

V2NIMSearchConfig _$V2NIMSearchConfigFromJson(Map<String, dynamic> json) =>
    V2NIMSearchConfig(
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      searchAccountIdEnabled: json['searchAccountIdEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$V2NIMSearchConfigToJson(V2NIMSearchConfig instance) =>
    <String, dynamic>{
      'services': instance.services,
      'searchAccountIdEnabled': instance.searchAccountIdEnabled,
    };

DataReporterConfig _$DataReporterConfigFromJson(Map<String, dynamic> json) =>
    DataReporterConfig(
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isCloseDataReporter: json['isCloseDataReporter'] as bool? ?? false,
      dataReporterAddress: json['dataReporterAddress'] as String?,
    );

Map<String, dynamic> _$DataReporterConfigToJson(DataReporterConfig instance) =>
    <String, dynamic>{
      'services': instance.services,
      'isCloseDataReporter': instance.isCloseDataReporter,
      'dataReporterAddress': instance.dataReporterAddress,
    };

ABTConfig _$ABTConfigFromJson(Map<String, dynamic> json) => ABTConfig(
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      abtUrl: json['abtUrl'] as String,
    );

Map<String, dynamic> _$ABTConfigToJson(ABTConfig instance) => <String, dynamic>{
      'services': instance.services,
      'abtUrl': instance.abtUrl,
    };

V2NIMLocalConversationConfig _$V2NIMLocalConversationConfigFromJson(
        Map<String, dynamic> json) =>
    V2NIMLocalConversationConfig(
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      useLastMessageOnRevoke: json['useLastMessageOnRevoke'] as bool? ?? false,
      clearUnreadAfterDeleteConversation:
          json['clearUnreadAfterDeleteConversation'] as bool? ?? false,
    );

Map<String, dynamic> _$V2NIMLocalConversationConfigToJson(
        V2NIMLocalConversationConfig instance) =>
    <String, dynamic>{
      'services': instance.services,
      'useLastMessageOnRevoke': instance.useLastMessageOnRevoke,
      'clearUnreadAfterDeleteConversation':
          instance.clearUnreadAfterDeleteConversation,
    };
