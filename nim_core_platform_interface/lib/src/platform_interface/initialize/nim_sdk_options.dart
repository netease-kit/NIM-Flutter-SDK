// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

/// 初始化基础配置
abstract class NIMSDKOptions {
  /// app key
  final String appKey;

  /// sdk 根目录
  final String? sdkRootDir;

  /// 自定义客户端类型，小于等于0视为没有自定义类型
  final int? customClientType;

  /// cdn统计回调触发间隔。触发cdn拉流前设置，触发拉流后改动将不生效
  /// windows&macos 暂不支持
  final int? cdnTrackInterval;

  /// 是否开启数据库备份功能，默认关闭
  final bool? enableDatabaseBackup;

  /// 登录时的自定义字段，登陆成功后会同步给其他端
  final String? loginCustomTag;

  /// 是否开启会话已读多端同步，支持多端同步会话未读数，默认关闭
  final bool? shouldSyncUnreadCount;

  /// 开启时，如果被撤回的消息本地还未读，那么当消息发生撤回时，
  /// 对应会话的未读计数将减 1 以保持最近会话未读数的一致性。默认关闭
  final bool? shouldConsiderRevokedMessageUnreadCount;

  /// 是否启用群消息已读功能，默认关闭
  final bool? enableTeamMessageReadReceipt;

  /// 群通知消息是否计入未读数，默认不计入未读
  final bool? shouldTeamNotificationMessageMarkUnread;

  /// 默认情况下，从服务器获取原图缩略图时，如果原图为动图，我们将返回原图第一帧的缩略图。
  /// 而开启这个选项后，我们将返回缩略图后的动图。
  /// 这个选项只影响从服务器获取的缩略图，不影响本地生成的缩略图。默认关闭
  final bool? enableAnimatedImageThumbnail;

  /// 是否需要SDK自动预加载多媒体消息的附件。
  /// 如果打开，SDK收到多媒体消息后，图片和视频会自动下载缩略图，音频会自动下载文件。
  /// 如果关闭，第三方APP可以只有决定要不要下载以及何时下载附件内容，典型时机为消息列表第一次滑动到
  /// 这条消息时，才触发下载，以节省用户流量。
  /// 默认打开。
  final bool? enablePreloadMessageAttachment;

  /// 是否同步置顶会话记录，默认关闭
  final bool? shouldSyncStickTopSessionInfos;

  /// 是否开启IM日志自动上报，默认关闭
  final bool? enableReportLogAutomatically;

  /// 是否使用自定义服务器地址配置文件
  final bool? useAssetServerAddressConfig;

  /// 自动登录账号信息
  /// windows&macos 暂不支持自动登录
  @JsonKey(
    toJson: loginInfoToMap,
    fromJson: loginInfoFromMap,
    includeIfNull: false,
  )
  final NIMLoginInfo? autoLoginInfo;

  ///
  /// SDK nos 场景配置
  /// <p>
  /// 默认场景对应的默认过期时间为[NIMNosScenes.expireTimeNever]，用户可以修改默认场景的过期时间。
  /// 同时用户可以新增自己的场景并指定对应的过期时间（sceneKey-> expireTimeByDay），目前最多10个.
  /// <p>
  /// 用户发送消息或直接上传文件等情况下都可以任意指定相应的场景 ，不指定走默认的。
  /// 如果要指定相应的场景，只需要指定相应的sceneKey 即可
  /// <p>
  ///
  @JsonKey(fromJson: nosSceneConfigFromMap)
  final Map<NIMNosScene, int>? nosSceneConfig;

  /// 配置专属服务器的地址
  @JsonKey(fromJson: serverConfigFromMap, toJson: serverConfigToJson)
  final NIMServerConfig? serverConfig;

  ///是否开启融合存储,仅支持Android，iOS
  @JsonKey(defaultValue: true)
  bool enableFcs;

  NIMSDKOptions(
      {required this.appKey,
      this.sdkRootDir,
      this.cdnTrackInterval,
      this.shouldSyncStickTopSessionInfos,
      this.enableReportLogAutomatically,
      this.enableDatabaseBackup,
      this.loginCustomTag,
      this.customClientType,
      this.shouldSyncUnreadCount,
      this.shouldConsiderRevokedMessageUnreadCount,
      this.enableTeamMessageReadReceipt,
      this.shouldTeamNotificationMessageMarkUnread,
      this.enableAnimatedImageThumbnail,
      this.enablePreloadMessageAttachment,
      this.useAssetServerAddressConfig,
      this.autoLoginInfo,
      this.nosSceneConfig,
      this.serverConfig,
      this.enableFcs = true});

  Map<String, dynamic> toMap();
}

Map? loginInfoToMap(NIMLoginInfo? loginInfo) => loginInfo?.toMap();

NIMLoginInfo? loginInfoFromMap(Map? map) =>
    map == null ? null : NIMLoginInfo.fromMap(map.cast<String, dynamic>());

Map<String, int>? nosSceneConfigFromMap(Map? map) {
  return map?.cast<String, int>();
}

NIMServerConfig? serverConfigFromMap(Map? map) =>
    map == null ? null : NIMServerConfig.fromJson(map.cast<String, dynamic>());

Map? serverConfigToJson(NIMServerConfig? serverConfig) =>
    serverConfig?.toJson();
