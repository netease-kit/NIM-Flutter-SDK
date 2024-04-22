// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

part 'nim_sdk_android_options.g.dart';

@JsonSerializable()
class NIMAndroidSDKOptions extends NIMSDKOptions {
  ///
  /// 是否提高SDK进程优先级（默认提高，可以降低SDK核心进程被系统回收的概率）；
  /// 如果部分机型有意外的情况，可以根据机型决定是否开启。
  /// 4.6.0版本起，弱 IM 模式下，强制不提高SDK进程优先级
  ///
  @JsonKey(defaultValue: true)
  final bool improveSDKProcessPriority;

  ///
  /// 预加载服务，默认true，不建议设置为false，预加载连接可以优化登陆流程，提升用户体验
  ///
  @JsonKey(defaultValue: true)
  final bool preLoadServers;

  ///
  /// 是否是弱IM场景(慎用)
  /// <p>
  /// 默认为 false，即强 IM 场景。
  /// 弱 IM 场景：APP 仅在部分场景按需使用 IM 能力(不需要在应用启动时就做自动登录)，
  /// 并不需要保证消息通知、数据的实时性，那么这里可以填 true。
  /// <p>
  /// 在弱 IM 场景下，SDK 将在初始化过程中不启动 push 进程(维护与云信服务器的长连接)，
  /// 一直延迟到 IM 手动登录过程再做懒启动。
  /// 在弱 IM 场景下，push 进程的生命周期同 UI 进程，即当 UI 进程被销毁后，push 进程将自行退出，
  /// 不占用系统资源，也不再保持与云信服务器的连接。
  /// 注意：弱 IM 场景下，请不要使用自动登录，如果使用了自动登录，那么该设置自动失效。
  ///
  @JsonKey(defaultValue: false)
  final bool reducedIM;

  ///
  /// 是否检查 Manifest 配置
  /// 最好在调试阶段打开，调试通过之后请关掉
  ///
  @JsonKey(defaultValue: false)
  final bool checkManifestConfig;

  ///
  /// 禁止后台进程唤醒ui进程
  ///
  @JsonKey(defaultValue: false)
  final bool disableAwake;

  ///
  /// 获取服务器时间连续请求间隔时间, 最小1000ms， 默认2000ms
  ///
  @JsonKey(defaultValue: 2000)
  final int fetchServerTimeInterval;

  ///
  /// 离线推送不显示详情时，要显示的文案对应的类型名称
  ///
  final String? customPushContentType;

  ///
  /// 数据库加密秘钥，用于消息数据库加密。<br/>
  /// 如果不设置，数据库处于明文状态；
  /// 设置后，数据库会加密保存数据，之前明文保存的历史数据会被转为加密保存；
  /// 一旦开启过加密功能后，不支持退回明文保存状态。
  ///
  final String? databaseEncryptKey;

  ///
  /// 消息缩略图的尺寸。<br>
  /// 该值为最长边的大小。下载的缩略图最长边不会超过该值。
  ///
  final int thumbnailSize;

  /// 第三方推送配置
  @JsonKey(toJson: _mixPushConfigToMap, fromJson: _mixPushConfigFromMap)
  final NIMMixPushConfig? mixPushConfig;

  /// 通知栏配置
  @JsonKey(
      toJson: _notificationConfigToMap, fromJson: _notificationConfigFromMap)
  final NIMStatusBarNotificationConfig? notificationConfig;

  /// 是否开启圈组消息缓存支持，默认不开启
  @JsonKey(defaultValue: false)
  final bool enabledQChatMessageCache;

  /// 为通知栏提供消息发送者显示名称（例如：如果是P2P聊天，可以显示备注名、昵称、帐号等；如果是群聊天，可以显示备注名，群昵称，昵称、帐号等）
  /// 如果返回 null，SDK将会使用服务器下发昵称
  /// [account]     消息发送者账号
  /// [sessionId]   会话ID（如果是P2P聊天，那么会话ID即为发送者账号，如果是群聊天，那么会话ID就是群号）
  /// [sessionType] 会话类型
  /// 返回消息发送者对应的显示名称
  final NIMDisplayNameForMessageNotifierProvider?
      displayNameForMessageNotifierProvider;

  /// 为云信通知栏提醒提供头像（个人、群组）
  /// 一般从本地图片缓存中获取，若未下载或本地不存在，请返回默认本地头像（可以返回默认头像资源路径）
  /// 目前仅支持 jpg 和 png 格式
  ///
  /// [sessionType] 会话类型（个人、群组）
  /// [sessionId]  用户账号或者群ID
  /// 返回头像信息
  final NIMAvatarForMessageNotifierProvider? avatarForMessageNotifierProvider;

  /// 为通知栏提供消息title显示名称（例如：如果是群聊天，可以设置自定义群名称等;如果圈组，可以显示圈组频道名称等）
  /// 如果返回null，SDK 群和超大群会显示群名称，其他类型将会使用当前app名称展示
  /// 不可以做耗时操作
  /// [message] 收到的消息
  /// 返回消息title显示名称
  final NIMDisplayTitleForMessageNotifierProvider?
      displayTitleForMessageNotifierProvider;

  ///定制消息提醒（通知栏提醒）內容文案 主要在通知栏下拉后展现其通知内容：content=[nick:发来一条消息]
  NIMMakeNotifyContentProvider? makeNotifyContentProvider;

  ///定制消息提醒（通知栏提醒）Ticker文案 主要在通知栏弹框提醒时的内容：ticker=[nick有新消息]
  ///Android 5.0 后废弃
  NIMMakeTickerProvider? makeTickerProvider;

  ///定制消息撤回提醒文案
  NIMMakeRevokeMsgTipProvider? makeRevokeMsgTipProvider;

  NIMAndroidSDKOptions({
    /// android configurations
    this.improveSDKProcessPriority = true,
    this.preLoadServers = true,
    this.reducedIM = false,
    this.checkManifestConfig = false,
    this.disableAwake = false,
    this.enabledQChatMessageCache = false,
    this.databaseEncryptKey,
    this.thumbnailSize = 350,
    this.fetchServerTimeInterval = 2000,
    this.customPushContentType,
    this.mixPushConfig,
    this.notificationConfig,
    this.displayNameForMessageNotifierProvider,
    this.avatarForMessageNotifierProvider,
    this.displayTitleForMessageNotifierProvider,
    this.makeNotifyContentProvider,
    this.makeTickerProvider,
    this.makeRevokeMsgTipProvider,

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
    NIMLoginInfo? autoLoginInfo,
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
          autoLoginInfo: autoLoginInfo,
          nosSceneConfig: nosSceneConfig,
          serverConfig: serverConfig,
          enableFcs: enableFcs,
        );

  factory NIMAndroidSDKOptions.fromMap(Map options) =>
      _$NIMAndroidSDKOptionsFromJson(Map<String, dynamic>.from(options));

  @override
  Map<String, dynamic> toMap() => _$NIMAndroidSDKOptionsToJson(this);
}

/// 消息推送配置
@JsonSerializable()
class NIMMixPushConfig {
  ///
  /// 小米推送 appId
  ///
  @JsonKey(name: 'KEY_XM_APP_ID')
  final String? xmAppId;

  ///
  /// 小米推送 appKey
  ///
  @JsonKey(name: 'KEY_XM_APP_KEY')
  final String? xmAppKey;

  ///
  /// 小米推送证书，请在云信管理后台申请
  ///
  @JsonKey(name: 'KEY_XM_CERTIFICATE_NAME')
  final String? xmCertificateName;

  ///
  /// 华为推送 hwAppId
  ///
  @JsonKey(name: 'KEY_HW_APP_ID')
  final String? hwAppId;

  ///
  /// 华为推送证书，请在云信管理后台申请
  ///
  @JsonKey(name: 'KEY_HW_CERTIFICATE_NAME')
  final String? hwCertificateName;

  ///
  /// 魅族推送 appId
  ///
  @JsonKey(name: 'KEY_MZ_APP_ID')
  final String? mzAppId;

  ///
  /// 魅族推送 appKey
  ///
  @JsonKey(name: 'KEY_MZ_APP_KEY')
  final String? mzAppKey;

  ///
  /// 魅族推送证书，请在云信管理后台申请
  ///
  @JsonKey(name: 'KEY_MZ_CERTIFICATE_NAME')
  final String? mzCertificateName;

  ///
  /// FCM 推送证书，请在云信管理后台申请
  /// 海外客户使用
  ///
  @JsonKey(name: 'KEY_FCM_CERTIFICATE_NAME')
  final String? fcmCertificateName;

  ///
  /// VIVO推送 appId apiKey请在 AndroidManifest.xml 文件中配置
  /// VIVO推送证书，请在云信管理后台申请
  ///
  @JsonKey(name: 'KEY_VIVO_CERTIFICATE_NAME')
  final String? vivoCertificateName;

  ///
  /// oppo 推送appId
  ///
  @JsonKey(name: 'KEY_OPPO_APP_ID')
  final String? oppoAppId;

  ///
  /// oppo 推送appKey
  ///
  @JsonKey(name: 'KEY_OPPO_APP_KEY')
  final String? oppoAppKey;

  ///
  /// oppo 推送AppSecret
  ///
  @JsonKey(name: 'KEY_OPPO_APP_SERCET')
  final String? oppoAppSecret;

  ///
  /// OPPO推送证书，请在云信管理后台申请
  ///
  @JsonKey(name: 'KEY_OPPO_CERTIFICATE_NAME')
  final String? oppoCertificateName;

  ///
  /// 是否根据token自动选择推送类型
  ///
  @JsonKey(name: 'KEY_AUTO_SELECT_PUSH_TYPE')
  final bool autoSelectPushType;

  ///荣耀推送 appId请在 AndroidManifest.xml 文件中配置 荣耀推送证书，请在云信管理后台申请
  @JsonKey(name: 'KEY_HONOR_CERTIFICATE_NAME')
  final String? honorCertificateName;

  NIMMixPushConfig({
    this.xmAppId,
    this.xmAppKey,
    this.xmCertificateName,
    this.hwAppId,
    this.hwCertificateName,
    this.mzAppId,
    this.mzAppKey,
    this.mzCertificateName,
    this.fcmCertificateName,
    this.vivoCertificateName,
    this.oppoAppId,
    this.oppoAppKey,
    this.oppoAppSecret,
    this.oppoCertificateName,
    this.autoSelectPushType = false,
    this.honorCertificateName,
  });

  factory NIMMixPushConfig.fromMap(Map<String, dynamic> json) {
    return _$NIMMixPushConfigFromJson(json);
  }

  Map<String, dynamic> toMap() => _$NIMMixPushConfigToJson(this);
}

_mixPushConfigToMap(NIMMixPushConfig? config) => config?.toMap();

NIMMixPushConfig? _mixPushConfigFromMap(Map? map) {
  return map != null
      ? NIMMixPushConfig.fromMap(map.cast<String, dynamic>())
      : null;
}

///
/// SDK提供状态栏提醒的配置
///
@JsonSerializable()
class NIMStatusBarNotificationConfig {
  ///
  /// 状态栏提醒的小图标的资源名称。<br>
  /// 如果不提供，使用app的icon
  ///
  ///final String? notificationSmallIconName;

  ///
  /// 是否需要响铃提醒。<br>
  /// 默认为true
  ///
  final bool ring;

  ///
  /// 响铃提醒的声音资源，如果不提供，使用系统默认提示音。
  ///
  final String? notificationSound;

  ///
  /// 是否需要振动提醒。<br>
  /// 默认为true
  ///
  final bool vibrate;

  ///
  /// 呼吸灯的颜色
  /// 建议尽量使用绿色、蓝色、红色等基本颜色，不要去用混合色。
  ///
  ///
  final int? ledARGB;

  ///
  /// 呼吸灯亮时的持续时间（毫秒）
  ///
  final int? ledOnMs;

  ///
  /// 呼吸灯熄灭时的持续时间（毫秒）
  ///
  final int? ledOffMs;

  ///
  /// 不显示消息详情开关, 同时也不再显示消息发送者昵称<br>
  /// 默认为false
  ///
  final bool hideContent;

  ///
  /// 免打扰设置开关。默认为关闭。
  ///
  final bool downTimeToggle;

  ///
  /// 免打扰的开始时间, 格式为HH:mm(24小时制)。
  ///
  final String? downTimeBegin;

  ///
  /// 免打扰的结束时间, 格式为HH:mm(24小时制)。<br>
  /// 如果结束时间小于开始时间，免打扰时间为开始时间-24:00-结束时间。
  ///
  final String? downTimeEnd;

  ///
  /// 免打扰期间，是否显示通知，默认为显示
  ///
  final bool downTimeEnableNotification;

  ///
  /// 通知栏提醒的响应intent的activity类型。<br>
  /// 可以为null。如果未提供，将使用包的launcher的入口intent的activity。
  ///
  final String? notificationEntranceClassName;

  ///
  /// 通知栏提醒的标题是否只显示应用名。默认是 false，当有一个会话发来消息时，显示会话名；当有多个会话发来时，显示应用名。
  /// 修改为true，那么无论一个还是多个会话发来消息，标题均显示应用名。
  /// 应用名称请在AndroidManifest的application节点下设置android:label。
  ///
  final bool titleOnlyShowAppName;

  ///
  /// 消息通知栏的折叠类型，不配置时，以notificationFolded的值为准, 如果为null，表示默认所有折叠
  ///
  @JsonKey(defaultValue: NIMNotificationFoldStyle.all)
  final NIMNotificationFoldStyle notificationFoldStyle;

  ///
  /// 消息通知栏颜色，将应用到 NotificationCompat.Builder 的 setColor 方法
  /// 对Android 5.0 以后机型会影响到smallIcon
  ///
  final int? notificationColor;

  ///
  /// 是否APP图标显示未读数(红点)
  /// 仅针对Android 8.0+有效
  ///
  final bool showBadge;

  ///
  /// 如果群名称为null 或者空串，则使用customTitleWhenTeamNameEmpty 作为通知栏title
  ///
  final String? customTitleWhenTeamNameEmpty;

  ///
  /// 点击通知栏传递的extra类型
  ///
  @JsonKey(defaultValue: NIMNotificationExtraType.message)
  final NIMNotificationExtraType notificationExtraType;

  NIMStatusBarNotificationConfig({
    this.ring = true,
    this.notificationSound,
    this.vibrate = true,
    this.ledARGB,
    this.ledOnMs,
    this.ledOffMs,
    this.hideContent = false,
    this.downTimeToggle = false,
    this.downTimeBegin,
    this.downTimeEnd,
    this.downTimeEnableNotification = true,
    this.notificationEntranceClassName,
    this.titleOnlyShowAppName = false,
    this.notificationFoldStyle = NIMNotificationFoldStyle.all,
    this.notificationColor,
    this.showBadge = true,
    this.customTitleWhenTeamNameEmpty,
    this.notificationExtraType = NIMNotificationExtraType.message,
  });

  factory NIMStatusBarNotificationConfig.fromMap(Map<String, dynamic> map) {
    return _$NIMStatusBarNotificationConfigFromJson(map);
  }

  Map<String, dynamic> toMap() => _$NIMStatusBarNotificationConfigToJson(this);
}

_notificationConfigToMap(NIMStatusBarNotificationConfig? config) =>
    config?.toMap();

NIMStatusBarNotificationConfig? _notificationConfigFromMap(Map? map) {
  return map != null
      ? NIMStatusBarNotificationConfig.fromMap(map.cast<String, dynamic>())
      : null;
}

/// 通知折叠方式
enum NIMNotificationFoldStyle {
  ///
  /// 折叠所有通知栏消息为一条通知
  ///
  all,

  ///
  /// 不折叠通知栏消息
  ///
  expand,

  ///
  /// 将同一个会话下的消息折叠为一条通知，不同会话之间不折叠
  ///
  contact,
}

/// 通知传递的extra类型
enum NIMNotificationExtraType {
  /// 传递消息对象
  message,

  /// 将消息转为JsonArray的字符串格式
  jsonArrStr,
}

/// 为通知栏提供消息发送者显示名称（例如：如果是P2P聊天，可以显示备注名、昵称、帐号等；如果是群聊天，可以显示备注名，群昵称，昵称、帐号等） 如果返回 null，SDK将会使用服务器下发昵称
typedef NIMDisplayNameForMessageNotifierProvider = Future<String?> Function(
    String? account, String? sessionId, NIMSessionType? sessionType);

///为云信通知栏提醒提供头像（个人、群组） 一般从本地图片缓存中获取，若未下载或本地不存在，请返回默认本地头像（可以返回默认头像资源ID对应的Bitmap）
typedef NIMAvatarForMessageNotifierProvider
    = Future<UserInfoProviderAvatarInfo?> Function(
        NIMSessionType? sessionType, String? sessionId);

///为通知栏提供消息title显示名称（例如：如果是群聊天，可以设置自定义群名称等;如果圈组，可以显示圈组频道名称等） 如果返回null，SDK 群和超大群会显示群名称，其他类型将会使用当前app名称展示
typedef NIMDisplayTitleForMessageNotifierProvider = Future<String?> Function(
    NIMMessage? message);

///定制消息提醒（通知栏提醒）內容文案 主要在通知栏下拉后展现其通知内容：content=[nick:发来一条消息]
/// Params:
/// [nick] – 发送者昵称 [message] – 发来的消息
/// Returns:
/// 定制的消息提醒内容文案
typedef NIMMakeNotifyContentProvider = Future<String?> Function(
    String? nick, NIMMessage? message);

///定制消息提醒（通知栏提醒）Ticker文案 主要在通知栏弹框提醒时的内容：ticker=[nick有新消息]
///params:
/// [nick] – 发送者昵称 [message] – 发来的消息
/// Returns:
/// 定制的通知栏Ticker文案
typedef NIMMakeTickerProvider = Future<String?> Function(
    String? nick, NIMMessage? message);

///定制消息撤回提醒文案
///Params:
/// [revokeAccount] – 撤回操作者账号 [message] – 被撤回的消息
/// Returns:
/// 消息撤回提醒文案
typedef NIMMakeRevokeMsgTipProvider = Future<String?> Function(
    String? revokeAccount, NIMMessage? message);
