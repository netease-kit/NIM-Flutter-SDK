// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/src/platform_interface/auth/auth_models.dart';
import 'package:nim_core_platform_interface/src/platform_interface/initialize/nim_sdk_options.dart';
import 'package:nim_core_platform_interface/src/platform_interface/nim_base.dart';

part 'nim_sdk_windows_options.g.dart';

@JsonSerializable()
class NIMWINDOWSSDKOptions extends NIMSDKOptions {
  /// define WINDOWS options here

  /// 数据库秘钥，必填，目前只支持最多32个字符的加密密钥！建议使用32个字符
  String? databaseEncryptKey;

  /// 预下载图片质量，选填，范围 0-100
  int? preloadImageQuality;

  /// 预下载图片基于长宽做内缩略,选填,比如宽100高50,则赋值为100x50,中间为字母小写x
  String? preloadImageResize;

  /// string 预下载图片命名规则，以{filename}为token进行替换
  String? preloadImageNameTemplate;

  /// int 登录重试最大次数，如需设置建议设置大于3次，默认填0，SDK默认设置次数
  int? maxAutoLoginRetryTimes;

  /// bool 是否启用HTTPS协议，默认为true
  bool? enabledHttps;

  ///  语音消息未接通消息是否计入未读数，默认为false
  bool? shouldVchatMissMessageMarkUnread;

  ///  客户端反垃圾，默认为false，如需开启请提前咨询技术支持或销售
  bool? enableClientAntispam;

  /// 在进行重新登录前是否先刷新一下lbs,对于切换网络的场景适用
  bool? needUpdateLbsBeforeRelogin;

  /// 是否使用私有化配置
  bool? useAssetServerConfig;

  NIMWINDOWSSDKOptions({
    /// windows configurations
    this.databaseEncryptKey,
    this.enableClientAntispam = false,
    this.enabledHttps = true,
    this.needUpdateLbsBeforeRelogin = false,
    this.shouldVchatMissMessageMarkUnread = false,
    this.maxAutoLoginRetryTimes = 0,
    this.preloadImageNameTemplate,
    this.preloadImageQuality,
    this.preloadImageResize,
    this.useAssetServerConfig,

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
          appKey: appKey,
          autoLoginInfo: autoLoginInfo,
          nosSceneConfig: nosSceneConfig,
          sdkRootDir: sdkRootDir,
          cdnTrackInterval: cndTrackInterval,
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

  factory NIMWINDOWSSDKOptions.fromMap(Map map) {
    return _$NIMWINDOWSSDKOptionsFromJson(Map<String, dynamic>.from(map));
  }

  @override
  Map<String, dynamic> toMap() => _$NIMWINDOWSSDKOptionsToJson(this);
}
