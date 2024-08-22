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
    };

NIMOtherOptions _$NIMOtherOptionsFromJson(Map<String, dynamic> json) =>
    NIMOtherOptions(
      loginServiceConfig:
          _nimLoginServiceConfigFromJson(json['loginServiceConfig'] as Map?),
      abtestConfig: _nimAbtestConfigFromJson(json['abtestConfig'] as Map?),
      cloudStorageConfig:
          _nimCloudStorageConfigJson(json['cloudStorageConfig'] as Map?),
      reporterConfig:
          _nimReporterConfigFromJson(json['reporterConfig'] as Map?),
    );

Map<String, dynamic> _$NIMOtherOptionsToJson(NIMOtherOptions instance) =>
    <String, dynamic>{
      'loginServiceConfig': instance.loginServiceConfig?.toJson(),
      'abtestConfig': instance.abtestConfig?.toJson(),
      'cloudStorageConfig': instance.cloudStorageConfig?.toJson(),
      'reporterConfig': instance.reporterConfig?.toJson(),
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

NIMCloudStorageConfig _$NIMCloudStorageConfigFromJson(
        Map<String, dynamic> json) =>
    NIMCloudStorageConfig(
      cdn: json['cdn'] == null
          ? null
          : NIMCdnConfig.fromJson(json['cdn'] as Map<String, dynamic>),
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
