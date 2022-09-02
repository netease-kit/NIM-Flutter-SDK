// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/src/platform_interface/auth/auth_models.dart';
import 'package:nim_core_platform_interface/src/platform_interface/initialize/nim_sdk_options.dart';
import 'package:nim_core_platform_interface/src/platform_interface/initialize/nim_sdk_windows_options.dart';
import 'package:nim_core_platform_interface/src/platform_interface/nim_base.dart';

part 'nim_sdk_macos_options.g.dart';

@JsonSerializable()
class NIMMACOSSDKOptions extends NIMWINDOWSSDKOptions {
  /// define macos options here

  /// 云信后台配置的推送证书名称
  String? pushCertName;

  /// 推送的设备token
  String? pushToken;

  /// 是否启用macos下的App Nap功能，默认为false
  bool? enableAppNap = false;

  NIMMACOSSDKOptions({
    /// macos configurations
    this.enableAppNap = false,
    this.pushCertName,
    this.pushToken,

    /// windows configurations
    String? databaseEncryptKey,
    bool? enableClientAntispam = false,
    bool? enabledHttps = true,
    bool? needUpdateLbsBeforeRelogin = false,
    bool? shouldVchatMissMessageMarkUnread = false,
    int? maxAutoLoginRetryTimes = 0,
    String? preloadImageNameTemplate,
    int? preloadImageQuality,
    String? preloadImageResize,
    bool? useAssetServerConfig = false,

    /// common configurations
    required String appKey,
    String? sdkRootDir,
    int? cndTrackInterval,
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
    NIMLoginInfo? autoLoginInfo,
    Map<NIMNosScene, int>? nosSceneConfig,
  }) : super(
          databaseEncryptKey: databaseEncryptKey,
          enableClientAntispam: enableClientAntispam,
          enabledHttps: enabledHttps,
          needUpdateLbsBeforeRelogin: needUpdateLbsBeforeRelogin,
          shouldVchatMissMessageMarkUnread: shouldVchatMissMessageMarkUnread,
          maxAutoLoginRetryTimes: maxAutoLoginRetryTimes,
          preloadImageNameTemplate: preloadImageNameTemplate,
          preloadImageQuality: preloadImageQuality,
          preloadImageResize: preloadImageResize,
          useAssetServerConfig: useAssetServerConfig,
          appKey: appKey,
          autoLoginInfo: autoLoginInfo,
          nosSceneConfig: nosSceneConfig,
          sdkRootDir: sdkRootDir,
          cndTrackInterval: cndTrackInterval,
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
        );

  factory NIMMACOSSDKOptions.fromMap(Map map) {
    return _$NIMMACOSSDKOptionsFromJson(Map<String, dynamic>.from(map));
  }

  @override
  Map<String, dynamic> toMap() => _$NIMMACOSSDKOptionsToJson(this);
}
