// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/src/platform_interface/auth/auth_models.dart';
import 'package:nim_core_platform_interface/src/platform_interface/initialize/nim_sdk_options.dart';
import 'package:nim_core_platform_interface/src/platform_interface/initialize/nim_sdk_server_config.dart';
import 'package:nim_core_platform_interface/src/platform_interface/nim_base.dart';

part 'nim_sdk_ios_options.g.dart';

@JsonSerializable()
class NIMIOSSDKOptions extends NIMSDKOptions {
  /// define iOS options here

  /// 云信 Apns 推送证书名
  String? apnsCername;

  /// 云信 PushKit 推送证书名
  String? pkCername;

  /// 设置禁用NIMSDK tracroute 能力
  /// 默认为NO,SDK会在请求失败时,进行 traceroute ,探测网路中各节点,以判断在哪个节点失去连接
  bool? disableTraceroute;

  /// 日志上传大小上限，默认 0，不限制，单位(byte)
  int? maxUploadLogSize;

  /// 是否在收到聊天室消息后自动下载附件
  /// @discussion 默认为NO
  bool? enableFetchAttachmentAutomaticallyAfterReceivingInChatroom;

  /// 是否使用 NSFileProtectionNone 作为云信文件的 NSProtectionKey
  ///  @discussion 默认为 NO，只有在上层 APP 开启了 Data Protection 时才起效
  bool? enableFileProtectionNone;

  /// 针对用户信息开启 https 支持
  ///  @discusssion 默认为 YES。在默认情况下，我们认为用户头像，群头像，聊天室类用户头像等信息都是默认托管在云信上，所以 SDK 会针对他们自动开启 https 支持。
  ///                        但如果你需要将这些信息都托管在自己的服务器上，需要设置这个接口为 NO，避免 SDK 自动将你的 http url 自动转换为 https url。
  bool? enabledHttpsForInfo;

  /// 针对消息内容开启 https 支持
  ///  @discusssion 默认为 YES。在默认情况下，我们认为消息，包括图片，视频，音频信息都是默认托管在云信上，所以 SDK 会针对他们自动开启 https 支持。
  ///                         但如果你需要将这些信息都托管在自己的服务器上，需要设置这个接口为 NO，避免 SDK 自动将你的 http url 自动转换为 https url。 (强烈不建议)
  ///                         需要注意的是即时设置了这个属性，通过 iOS SDK 发出去的消息 URL 仍是 https 的，设置这个值只影响接收到的消息 URL 格式转换
  bool? enabledHttpsForMessage;

  /// 自动登录重试次数
  ///  @discusssion 默认为 0。即默认情况下，自动登录将无限重试。设置成大于 0 的值后，在没有登录成功前，自动登录将重试最多 maxAutoLoginRetryTimes 次。
  int? maxAutoLoginRetryTimes;

  ///  本地 log 存活期
  ///  @discusssion 默认为 7 天。即超过 7 天的 log 将被清除。只能设置大于等于 2 的值。
  int? maximumLogDays;

  ///  是否禁止后台重连
  ///  @discusssion 默认为 NO。即默认情况下，当程序退到后台断开连接后，如果 App 仍能运行，SDK 将继续执行自动重连机制。设置为 YES 后在后台将不自动重连，重连将被推迟到前台进行。
  ///                只有特殊用户场景才需要此设置，无明确原因请勿设置。
  bool? disableReconnectInBackgroundState;

  /// 是否开启群回执功能
  ///  @discusssion 默认为 NO。
  bool? enableTeamReceipt;

  /// 文件快传本地开关，默认YES
  bool? enableFileQuickTransfer;

  /// 是否开启异步读取最近会话，默认NO，不开启
  /// @discussion 对于最近会话比较多的用户，初始读取数据库时，可能影响到启动速度，用户可以选择开启该选项，开启异步读取最近会话，
  ///  querySessionList会优先返回一部分最近会话，等到全部读取完成时，通过回调通知用户刷新UI。
  bool? enableAsyncLoadRecentSession;

  bool? linkQuickSwitch;

  /// 是否开启圈组消息缓存支持，默认不开启
  bool? enabledQChatMessageCache;

  NIMIOSSDKOptions({
    /// android configurations
    this.apnsCername,
    this.pkCername,
    this.maxUploadLogSize,
    this.enableFetchAttachmentAutomaticallyAfterReceivingInChatroom,
    this.enableFileProtectionNone,
    this.enabledHttpsForInfo,
    this.enabledHttpsForMessage,
    this.maxAutoLoginRetryTimes,
    this.maximumLogDays,
    this.disableReconnectInBackgroundState,
    this.enableTeamReceipt,
    this.enableFileQuickTransfer,
    this.enableAsyncLoadRecentSession,
    this.linkQuickSwitch,
    this.enabledQChatMessageCache,

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
    bool? useAssetServerAddressConfig,
    NIMLoginInfo? autoLoginInfo,
    Map<NIMNosScene, int>? nosSceneConfig,
    NIMServerConfig? serverConfig,
    bool enableFcs = true,
  }) : super(
          appKey: appKey,
          autoLoginInfo: autoLoginInfo,
          nosSceneConfig: nosSceneConfig,
          serverConfig: serverConfig,
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
          useAssetServerAddressConfig: useAssetServerAddressConfig,
          enableFcs: enableFcs,

          /// iOS => 是否在收到消息后自动下载附件 (群和个人)
          /// 默认为YES,SDK会在第一次收到消息是直接下载消息附件,上层开发可以根据自己的需要进行设置
        );

  factory NIMIOSSDKOptions.fromMap(Map map) {
    return _$NIMIOSSDKOptionsFromJson(Map<String, dynamic>.from(map));
  }

  @override
  Map<String, dynamic> toMap() => _$NIMIOSSDKOptionsToJson(this);
}
