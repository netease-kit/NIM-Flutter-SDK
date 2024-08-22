// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nim_sdk_pc_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMPCSDKOptions _$NIMPCSDKOptionsFromJson(Map<String, dynamic> json) =>
    NIMPCSDKOptions(
      basicOption:
          NIMBasicOption.fromJson(json['basicOption'] as Map<String, dynamic>),
      linkOption: json['linkOption'] == null
          ? null
          : NIMLinkOption.fromJson(json['linkOption'] as Map<String, dynamic>),
      databaseOption: json['databaseOption'] == null
          ? null
          : NIMDatabaseOption.fromJson(
              json['databaseOption'] as Map<String, dynamic>),
      fcsOption: json['fcsOption'] == null
          ? null
          : NIMFCSOption.fromJson(json['fcsOption'] as Map<String, dynamic>),
      privateServerOption: json['privateServerOption'] == null
          ? null
          : NIMPrivateServerOption.fromJson(
              json['privateServerOption'] as Map<String, dynamic>),
      appKey: json['appKey'] as String,
      sdkRootDir: json['sdkRootDir'] as String?,
    )..enableFcs = json['enableFcs'] as bool? ?? true;

Map<String, dynamic> _$NIMPCSDKOptionsToJson(NIMPCSDKOptions instance) =>
    <String, dynamic>{
      'appKey': instance.appKey,
      'sdkRootDir': instance.sdkRootDir,
      'enableFcs': instance.enableFcs,
      'basicOption': instance.basicOption.toJson(),
      'linkOption': instance.linkOption?.toJson(),
      'databaseOption': instance.databaseOption?.toJson(),
      'fcsOption': instance.fcsOption?.toJson(),
      'privateServerOption': instance.privateServerOption?.toJson(),
    };

NIMBasicOption _$NIMBasicOptionFromJson(Map<String, dynamic> json) =>
    NIMBasicOption(
      useHttps: json['useHttps'] as bool? ?? true,
      useHttpdns: json['useHttpdns'] as bool? ?? true,
      customClientType: (json['customClientType'] as num?)?.toInt(),
      customTag: json['customTag'] as String?,
      logReserveDays: (json['logReserveDays'] as num?)?.toInt() ?? 30,
      sdkLogLevel:
          $enumDecodeNullable(_$NIMSDKLogLevelEnumMap, json['sdkLogLevel']) ??
              NIMSDKLogLevel.nimSdkLogLevelApp,
      disableAppNap: json['disableAppNap'] as bool? ?? true,
    );

Map<String, dynamic> _$NIMBasicOptionToJson(NIMBasicOption instance) =>
    <String, dynamic>{
      'useHttps': instance.useHttps,
      'useHttpdns': instance.useHttpdns,
      'customClientType': instance.customClientType,
      'customTag': instance.customTag,
      'logReserveDays': instance.logReserveDays,
      'sdkLogLevel': _$NIMSDKLogLevelEnumMap[instance.sdkLogLevel]!,
      'disableAppNap': instance.disableAppNap,
    };

const _$NIMSDKLogLevelEnumMap = {
  NIMSDKLogLevel.nimSdkLogLevelFatal: 1,
  NIMSDKLogLevel.nimSdkLogLevelError: 2,
  NIMSDKLogLevel.nimSdkLogLevelWarn: 3,
  NIMSDKLogLevel.nimSdkLogLevelApp: 5,
  NIMSDKLogLevel.nimSdkLogLevelPro: 6,
};

NIMLinkOption _$NIMLinkOptionFromJson(Map<String, dynamic> json) =>
    NIMLinkOption(
      linkTimeout: (json['linkTimeout'] as num?)?.toInt() ?? 3000,
      protocolTimeout: (json['protocolTimeout'] as num?)?.toInt() ?? 3000,
      asymmetricEncryptionAlgorithm: $enumDecodeNullable(
              _$NIMAsymmetricEncryptionAlgorithmEnumMap,
              json['asymmetricEncryptionAlgorithm']) ??
          NIMAsymmetricEncryptionAlgorithm.nimAsymmetricEncryptionAlgorithmRSA,
      symmetricEncryptionAlgorithm: $enumDecodeNullable(
              _$NIMSymmetricEncryptionAlgorithmEnumMap,
              json['symmetricEncryptionAlgorithm']) ??
          NIMSymmetricEncryptionAlgorithm.nimSymmetricEncryptionAlgorithmRC4,
    );

Map<String, dynamic> _$NIMLinkOptionToJson(NIMLinkOption instance) =>
    <String, dynamic>{
      'linkTimeout': instance.linkTimeout,
      'protocolTimeout': instance.protocolTimeout,
      'asymmetricEncryptionAlgorithm':
          _$NIMAsymmetricEncryptionAlgorithmEnumMap[
              instance.asymmetricEncryptionAlgorithm]!,
      'symmetricEncryptionAlgorithm': _$NIMSymmetricEncryptionAlgorithmEnumMap[
          instance.symmetricEncryptionAlgorithm]!,
    };

const _$NIMAsymmetricEncryptionAlgorithmEnumMap = {
  NIMAsymmetricEncryptionAlgorithm.nimAsymmetricEncryptionAlgorithmRSA: 1,
  NIMAsymmetricEncryptionAlgorithm.nimAsymmetricEncryptionAlgorithmSM2: 2,
};

const _$NIMSymmetricEncryptionAlgorithmEnumMap = {
  NIMSymmetricEncryptionAlgorithm.nimSymmetricEncryptionAlgorithmRC4: 1,
  NIMSymmetricEncryptionAlgorithm.nimSymmetricEncryptionAlgorithmAES128: 2,
  NIMSymmetricEncryptionAlgorithm.nimSymmetricEncryptionAlgorithmSM4: 4,
};

NIMDatabaseOption _$NIMDatabaseOptionFromJson(Map<String, dynamic> json) =>
    NIMDatabaseOption(
      encryptionKey: json['encryptionKey'] as String?,
      enableBackup: json['enableBackup'] as bool? ?? true,
      enableRestore: json['enableRestore'] as bool? ?? true,
      backupFolder: json['backupFolder'] as String?,
      sqlcipherVersion: $enumDecodeNullable(
              _$NIMSqlCipherVersionEnumMap, json['sqlcipherVersion']) ??
          NIMSqlCipherVersion.NIMSqlCipherVersion3,
    );

Map<String, dynamic> _$NIMDatabaseOptionToJson(NIMDatabaseOption instance) =>
    <String, dynamic>{
      'encryptionKey': instance.encryptionKey,
      'enableBackup': instance.enableBackup,
      'enableRestore': instance.enableRestore,
      'backupFolder': instance.backupFolder,
      'sqlcipherVersion':
          _$NIMSqlCipherVersionEnumMap[instance.sqlcipherVersion]!,
    };

const _$NIMSqlCipherVersionEnumMap = {
  NIMSqlCipherVersion.NIMSqlCipherVersion3: 3,
  NIMSqlCipherVersion.NIMSqlCipherVersion4: 4,
};

NIMFCSOption _$NIMFCSOptionFromJson(Map<String, dynamic> json) => NIMFCSOption(
      fcsAuthType:
          $enumDecodeNullable(_$NIMFCSAuthTypeEnumMap, json['fcsAuthType']) ??
              NIMFCSAuthType.NIMFCSAuthTypeNone,
      customAuthRefer: json['customAuthRefer'] as String?,
      customAuthUA: json['customAuthUA'] as String?,
    );

Map<String, dynamic> _$NIMFCSOptionToJson(NIMFCSOption instance) =>
    <String, dynamic>{
      'fcsAuthType': _$NIMFCSAuthTypeEnumMap[instance.fcsAuthType]!,
      'customAuthRefer': instance.customAuthRefer,
      'customAuthUA': instance.customAuthUA,
    };

const _$NIMFCSAuthTypeEnumMap = {
  NIMFCSAuthType.NIMFCSAuthTypeNone: 0,
  NIMFCSAuthType.NIMFCSAuthTypeRefer: 1,
  NIMFCSAuthType.NIMFCSAuthTypeTimeToken: 2,
  NIMFCSAuthType.NIMFCSAuthTypeUrlToken: 3,
  NIMFCSAuthType.NIMFCSAuthTypeCustom: 4,
};

NIMPrivateServerOption _$NIMPrivateServerOptionFromJson(
        Map<String, dynamic> json) =>
    NIMPrivateServerOption(
      ipProtocolVersion: $enumDecodeNullable(
              _$NIMIPProtocolVersionEnumMap, json['ipProtocolVersion']) ??
          NIMIPProtocolVersion.NIMIPProtocolVersionIPv4,
      lbsAddresses: (json['lbsAddresses'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      nosLbsAddress: json['nosLbsAddress'] as String?,
      defaultLinkAddress: json['defaultLinkAddress'] as String?,
      defaultLinkAddressIpv6: json['defaultLinkAddressIpv6'] as String?,
      defaultNosUploadAddress: json['defaultNosUploadAddress'] as String?,
      defaultNosUploadHost: json['defaultNosUploadHost'] as String?,
      nosDownloadAddress: json['nosDownloadAddress'] as String?,
      nosAccelerateHosts: (json['nosAccelerateHosts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      nosAccelerateAddress: json['nosAccelerateAddress'] as String?,
      probeIpv4Url: json['probeIpv4Url'] as String?,
      probeIpv6Url: json['probeIpv6Url'] as String?,
      asymmetricEncryptionKeyA: json['asymmetricEncryptionKeyA'] as String?,
      asymmetricEncryptionKeyB: json['asymmetricEncryptionKeyB'] as String?,
      asymmetricEncryptionKeyVersion:
          (json['asymmetricEncryptionKeyVersion'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$NIMPrivateServerOptionToJson(
        NIMPrivateServerOption instance) =>
    <String, dynamic>{
      'ipProtocolVersion':
          _$NIMIPProtocolVersionEnumMap[instance.ipProtocolVersion]!,
      'lbsAddresses': instance.lbsAddresses,
      'nosLbsAddress': instance.nosLbsAddress,
      'defaultLinkAddress': instance.defaultLinkAddress,
      'defaultLinkAddressIpv6': instance.defaultLinkAddressIpv6,
      'defaultNosUploadAddress': instance.defaultNosUploadAddress,
      'defaultNosUploadHost': instance.defaultNosUploadHost,
      'nosDownloadAddress': instance.nosDownloadAddress,
      'nosAccelerateHosts': instance.nosAccelerateHosts,
      'nosAccelerateAddress': instance.nosAccelerateAddress,
      'probeIpv4Url': instance.probeIpv4Url,
      'probeIpv6Url': instance.probeIpv6Url,
      'asymmetricEncryptionKeyA': instance.asymmetricEncryptionKeyA,
      'asymmetricEncryptionKeyB': instance.asymmetricEncryptionKeyB,
      'asymmetricEncryptionKeyVersion': instance.asymmetricEncryptionKeyVersion,
    };

const _$NIMIPProtocolVersionEnumMap = {
  NIMIPProtocolVersion.NIMIPProtocolVersionUnspecified: 0,
  NIMIPProtocolVersion.NIMIPProtocolVersionIPv4: 1,
  NIMIPProtocolVersion.NIMIPProtocolVersionIPv6: 2,
};
