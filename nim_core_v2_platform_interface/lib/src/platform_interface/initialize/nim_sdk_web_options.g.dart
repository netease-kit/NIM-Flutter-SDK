// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nim_sdk_web_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMInitializeOptions _$NIMInitializeOptionsFromJson(
        Map<String, dynamic> json) =>
    NIMInitializeOptions(
      appkey: json['appkey'] as String,
      apiVersion: json['apiVersion'] as String?,
      binaryWebsocket: json['binaryWebsocket'] as bool?,
      debugLevel: json['debugLevel'] as String?,
      loginSDKTypeParamCompat: json['loginSDKTypeParamCompat'] as bool?,
      loginExtensionProviderDelay:
          (json['loginExtensionProviderDelay'] as num?)?.toInt(),
      tokenProviderDelay: (json['tokenProviderDelay'] as num?)?.toInt(),
      reconnectDelayProviderDelay:
          (json['reconnectDelayProviderDelay'] as num?)?.toInt(),
      enableV2CloudConversation: json['enableV2CloudConversation'] as bool?,
      flutterSdkVersion: json['flutterSdkVersion'] as String?,
    );

Map<String, dynamic> _$NIMInitializeOptionsToJson(
        NIMInitializeOptions instance) =>
    <String, dynamic>{
      'appkey': instance.appkey,
      'apiVersion': instance.apiVersion,
      'binaryWebsocket': instance.binaryWebsocket,
      'debugLevel': instance.debugLevel,
      'loginSDKTypeParamCompat': instance.loginSDKTypeParamCompat,
      'loginExtensionProviderDelay': instance.loginExtensionProviderDelay,
      'tokenProviderDelay': instance.tokenProviderDelay,
      'reconnectDelayProviderDelay': instance.reconnectDelayProviderDelay,
      'enableV2CloudConversation': instance.enableV2CloudConversation,
      'flutterSdkVersion': instance.flutterSdkVersion,
    };

NIMOtherOptions _$NIMOtherOptionsFromJson(Map<String, dynamic> json) =>
    NIMOtherOptions(
      V2NIMLoginServiceConfig: _nimLoginServiceConfigFromJson(
          json['V2NIMLoginServiceConfig'] as Map?),
      V2NIMClientAntispamUtilConfig: _nimClientAntispamUtilConfigFromJson(
          json['V2NIMClientAntispamUtilConfig'] as Map?),
      V2NIMFriendServiceConfig: _nimFriendServiceConfigFromJson(
          json['V2NIMFriendServiceConfig'] as Map?),
      V2NIMTeamServiceConfig:
          _nimTeamServiceConfigFromJson(json['V2NIMTeamServiceConfig'] as Map?),
      abtestConfig: _nimAbtestConfigFromJson(json['abtestConfig'] as Map?),
      cloudStorageConfig:
          _nimCloudStorageConfigJson(json['cloudStorageConfig'] as Map?),
      reporterConfig:
          _nimReporterConfigFromJson(json['reporterConfig'] as Map?),
      qchatChannelConfig:
          _nimQChatChannelConfigFromJson(json['qchatChannelConfig'] as Map?),
    );

Map<String, dynamic> _$NIMOtherOptionsToJson(NIMOtherOptions instance) =>
    <String, dynamic>{
      'V2NIMLoginServiceConfig': instance.V2NIMLoginServiceConfig?.toJson(),
      'V2NIMClientAntispamUtilConfig':
          instance.V2NIMClientAntispamUtilConfig?.toJson(),
      'V2NIMFriendServiceConfig': instance.V2NIMFriendServiceConfig?.toJson(),
      'V2NIMTeamServiceConfig': instance.V2NIMTeamServiceConfig?.toJson(),
      'abtestConfig': instance.abtestConfig?.toJson(),
      'cloudStorageConfig': instance.cloudStorageConfig?.toJson(),
      'reporterConfig': instance.reporterConfig?.toJson(),
      'qchatChannelConfig': instance.qchatChannelConfig?.toJson(),
    };

NIMLoginServiceConfig _$NIMLoginServiceConfigFromJson(
        Map<String, dynamic> json) =>
    NIMLoginServiceConfig(
      customClientType: (json['customClientType'] as num?)?.toInt(),
      customTag: json['customTag'] as String?,
      isFixedDeviceId: json['isFixedDeviceId'] as bool?,
      lbsUrls:
          (json['lbsUrls'] as List<dynamic>?)?.map((e) => e as String).toList(),
      linkUrl: json['linkUrl'] as String?,
    );

Map<String, dynamic> _$NIMLoginServiceConfigToJson(
        NIMLoginServiceConfig instance) =>
    <String, dynamic>{
      'customClientType': instance.customClientType,
      'customTag': instance.customTag,
      'isFixedDeviceId': instance.isFixedDeviceId,
      'lbsUrls': instance.lbsUrls,
      'linkUrl': instance.linkUrl,
    };

NIMClientAntispamUtilConfig _$NIMClientAntispamUtilConfigFromJson(
        Map<String, dynamic> json) =>
    NIMClientAntispamUtilConfig(
      enable: json['enable'] as bool?,
    );

Map<String, dynamic> _$NIMClientAntispamUtilConfigToJson(
        NIMClientAntispamUtilConfig instance) =>
    <String, dynamic>{
      'enable': instance.enable,
    };

V2WebNIMFriendServiceConfig _$NIMFriendServiceConfigFromJson(
        Map<String, dynamic> json) =>
    V2WebNIMFriendServiceConfig(
      enableServerV2FriendAddApplication:
          json['enableServerV2FriendAddApplication'] as bool?,
    );

Map<String, dynamic> _$NIMFriendServiceConfigToJson(
        V2WebNIMFriendServiceConfig instance) =>
    <String, dynamic>{
      'enableServerV2FriendAddApplication':
          instance.enableServerV2FriendAddApplication,
    };

NIMTeamServiceConfig _$NIMTeamServiceConfigFromJson(
        Map<String, dynamic> json) =>
    NIMTeamServiceConfig(
      enableServerV2TeamJoinActionInfo:
          json['enableServerV2TeamJoinActionInfo'] as bool?,
    );

Map<String, dynamic> _$NIMTeamServiceConfigToJson(
        NIMTeamServiceConfig instance) =>
    <String, dynamic>{
      'enableServerV2TeamJoinActionInfo':
          instance.enableServerV2TeamJoinActionInfo,
    };

NIMCloudStorageConfig _$NIMCloudStorageConfigFromJson(
        Map<String, dynamic> json) =>
    NIMCloudStorageConfig(
      cdn: _nimCdnConfigFromJson(json['cdn'] as Map?),
      chunkUploadHost: json['chunkUploadHost'] as String?,
      commonUploadHost: json['commonUploadHost'] as String?,
      downloadHostList: (json['downloadHostList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      downloadUrl: json['downloadUrl'] as String?,
      isNeedToGetUploadPolicyFromServer:
          json['isNeedToGetUploadPolicyFromServer'] as bool?,
      nosCdnEnable: json['nosCdnEnable'] as bool?,
      s3: json['s3'] as bool?,
      storageKeyPrefix: json['storageKeyPrefix'] as String?,
      uploadReplaceFormat: json['uploadReplaceFormat'] as String?,
    );

Map<String, dynamic> _$NIMCloudStorageConfigToJson(
        NIMCloudStorageConfig instance) =>
    <String, dynamic>{
      'cdn': instance.cdn?.toJson(),
      'chunkUploadHost': instance.chunkUploadHost,
      'commonUploadHost': instance.commonUploadHost,
      'downloadHostList': instance.downloadHostList,
      'downloadUrl': instance.downloadUrl,
      'isNeedToGetUploadPolicyFromServer':
          instance.isNeedToGetUploadPolicyFromServer,
      'nosCdnEnable': instance.nosCdnEnable,
      's3': instance.s3,
      'storageKeyPrefix': instance.storageKeyPrefix,
      'uploadReplaceFormat': instance.uploadReplaceFormat,
    };

NIMCdnConfig _$NIMCdnConfigFromJson(Map<String, dynamic> json) => NIMCdnConfig(
      bucket: json['bucket'] as String?,
      cdnDomain: json['cdnDomain'] as String?,
      defaultCdnDomain: json['defaultCdnDomain'] as String?,
      objectNamePrefix: json['objectNamePrefix'] as String?,
    );

Map<String, dynamic> _$NIMCdnConfigToJson(NIMCdnConfig instance) =>
    <String, dynamic>{
      'bucket': instance.bucket,
      'cdnDomain': instance.cdnDomain,
      'defaultCdnDomain': instance.defaultCdnDomain,
      'objectNamePrefix': instance.objectNamePrefix,
    };

NIMReporterConfig _$NIMReporterConfigFromJson(Map<String, dynamic> json) =>
    NIMReporterConfig(
      isDataReportEnable: json['isDataReportEnable'] as bool?,
      reportConfigUrl: json['reportConfigUrl'] as String?,
      reportUrl: json['reportUrl'] as String?,
    );

Map<String, dynamic> _$NIMReporterConfigToJson(NIMReporterConfig instance) =>
    <String, dynamic>{
      'isDataReportEnable': instance.isDataReportEnable,
      'reportConfigUrl': instance.reportConfigUrl,
      'reportUrl': instance.reportUrl,
    };

NIMQChatChannelConfig _$NIMQChatChannelConfigFromJson(
        Map<String, dynamic> json) =>
    NIMQChatChannelConfig(
      autoSubscribe: json['autoSubscribe'] as bool?,
    );

Map<String, dynamic> _$NIMQChatChannelConfigToJson(
        NIMQChatChannelConfig instance) =>
    <String, dynamic>{
      'autoSubscribe': instance.autoSubscribe,
    };

NIMAbtestConfig _$NIMAbtestConfigFromJson(Map<String, dynamic> json) =>
    NIMAbtestConfig(
      abtestUrl: json['abtestUrl'] as String?,
      isAbtestEnable: json['isAbtestEnable'] as bool?,
    );

Map<String, dynamic> _$NIMAbtestConfigToJson(NIMAbtestConfig instance) =>
    <String, dynamic>{
      'abtestUrl': instance.abtestUrl,
      'isAbtestEnable': instance.isAbtestEnable,
    };

NIMWebSDKOptions _$NIMWebSDKOptionsFromJson(Map<String, dynamic> json) =>
    NIMWebSDKOptions(
      initializeOptions:
          _nimInitializeOptionsFromJson(json['initializeOptions'] as Map),
      otherOptions: _nimOtherOptionsFromJson(json['otherOptions'] as Map?),
      appKey: json['appKey'] as String,
    )..enableFcs = json['enableFcs'] as bool? ?? true;

Map<String, dynamic> _$NIMWebSDKOptionsToJson(NIMWebSDKOptions instance) =>
    <String, dynamic>{
      'appKey': instance.appKey,
      'enableFcs': instance.enableFcs,
      'initializeOptions': instance.initializeOptions.toJson(),
      'otherOptions': instance.otherOptions?.toJson(),
    };
