// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

library nim_core_v2;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hawk_meta/hawk_meta.dart';
import 'package:nim_core_v2/src/log/log_service.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:universal_io/io.dart';
import 'package:yunxin_alog/yunxin_alog.dart';
import 'package:universal_html/html.dart' as html;

export 'package:nim_core_v2_platform_interface/src/platform_interface/auth/auth_models.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/avsignalling/avsignalling_models.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/event_subscribe/event.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/event_subscribe/event_subscribe_request.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/event_subscribe/event_subscribe_result.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/event_subscribe/platform_interface_event_subscribe_service.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/initialize/nim_sdk_android_options.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/initialize/nim_sdk_web_options.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/initialize/nim_sdk_ios_options.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/initialize/nim_sdk_pc_options.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/initialize/nim_sdk_options.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/initialize/nim_sdk_server_config.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/message/message.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/message/message_collection_v2.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/message/message_notification_v2.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/message/message_pin_v2.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/message/message_quick_comment_v2.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/message/message_read_receipt_v2.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/message/message_thread_v2.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/message/v2_message_enum.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/message/platform_interface_message_service.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/nim_base.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/nos/nos.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/passthrough/pass_through_notifydata.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/passthrough/pass_through_proxydata.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/qchat/platform_interface_qchat_push_service.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/qchat/qchat_base_models.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/qchat/qchat_channel_models.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/qchat/qchat_message_models.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/qchat/qchat_models.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/qchat/qchat_observer_models.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/qchat/qchat_push_models.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/qchat/qchat_role_models.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/qchat/qchat_server_models.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/robot/robot_message_type.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/user/mute_list_changed_notify.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/user/user.dart';
export 'package:nim_core_v2_platform_interface/src/utils/converter.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/login/login_models.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/friend/friend_models.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/conversation/conversation_models.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/conversation/platform_interface_conversation_service.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/conversation/platform_interface_conversation_id_util.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/storage/storage_models.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/team/platform_interface_team_service.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/team/team.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/team/team_member.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/team/team_param.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/team/team_result.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/team/antispam_config.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/team/team_enum.dart';

export 'package:nim_core_v2_platform_interface/src/platform_interface/setting/platform_interface_settings_service.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/setting/setting_enum.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/setting/dnd_config.dart';

export 'package:nim_core_v2_platform_interface/src/platform_interface/apns/platform_interface_apns_service.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/apns/apns_data.dart';
export 'package:nim_core_v2_platform_interface/src/platform_interface/notify/notify_models.dart';

part 'src/login/login_service.dart';
part 'src/message/message_service.dart';
part 'src/user/user_service.dart';
part 'src/friend/friend_service.dart';
part 'src/message/message_creator.dart';
part 'src/conversation/conversation_service.dart';
part 'src/conversation/conversation_id_util.dart';
part 'src/storage/storage_service.dart';
part 'src/storage/storage_utils.dart';
part 'src/notification/notification_service.dart';
part 'src/team/team_service.dart';
part 'src/settings/setting_service.dart';
part 'src/apns/apns_service.dart';
part 'src/ai/ai_service.dart';

class NimCore {
  NimCore._();

  static final NimCore instance = NimCore._();

  static const String tag = 'nim_core_v2';
  //todo 发版前记得处理此处的版本号，数据统计使用
  static const int _versionCode = 1031;
  static const String versionName = '10.3.1';
  static const String _hash = '02566d6321d1d27669d9d369d2f525bc2cdaee10';

  bool _initialized = false;
  NIMSDKOptions? _sdkOptions;

  bool get isInitialized => _initialized;

  NIMSDKOptions? get sdkOptions => _sdkOptions;

  /// 云信用户服务接口
  final UserService userService = UserService();

  /// 用户登录
  final LoginService loginService = LoginService();

  /// 消息服务
  final MessageService messageService = MessageService();

  /// 会话列表
  final ConversationService conversationService = ConversationService();

  /// 会话工具
  final ConversationIdUtil conversationIdUtil = ConversationIdUtil();

  /// 群组服务
  final TeamService teamService = TeamService();

  /// 设置服务
  final SettingsService settingsService = SettingsService();

  /// 云信好友服务接口
  final FriendService friendService = FriendService();

  /// 存储服务
  final StorageService storageService = StorageService();

  /// 存储工具
  final StorageUtil storageUtil = StorageUtil();

  ///通知服务
  final NotificationService notificationService = NotificationService();

  ///AI 数字人服务
  final AiService aiService = AiService();

  /// 推送
  final APNSService apnsService = APNSService();

  /// 初始化云信 IM SDK
  ///
  /// [options] 初始化配置参数。
  /// Android 平台使用 [NIMAndroidSDKOptions] 类进行配置；
  /// iOS 平台使用 [NIMIOSSDKOptions] 类进行配置；
  Future<NIMResult<void>> initialize(NIMSDKOptions options) async {
    final startTS = DateTime.now();
    final handler = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      Alog.e(
        tag: tag,
        moduleName: tag,
        content:
            'flutter error detected: ${details.exceptionAsString()} \n ${details.stack}',
      );
      handler?.call(details);
    };
    Log.instance = _Alog();
    return ALogService()
        .init(config: ALoggerConfig(path: options.sdkRootDir))
        .then((value) {
      print('ALog init result: $value');
      Alog.i(
          tag: tag,
          moduleName: tag,
          content: 'print sdk info ==== '
              'operatingSystem: ${Platform.operatingSystem}, operatingSystemVersion: ${Platform.operatingSystemVersion};'
              'verCode: $_versionCode, verName: $versionName, hash: $_hash; ');
      final extras = {
        'versionCode': _versionCode,
        'versionName': versionName,
      };
      return InitializeServicePlatform.instance.initialize(options, extras);
    }).then((initResult) {
      Alog.i(
          tag: tag,
          moduleName: tag,
          content: 'initialize done ==== '
              'sdkRootDir: ${options.sdkRootDir}, '
              'success: ${initResult.isSuccess}, '
              'elapsed: ${DateTime.now().difference(startTS).inMilliseconds}');
      if (initResult.isSuccess) {
        _initialized = true;
        _sdkOptions = options;
      }
      return initResult;
    });
  }

  /// 释放云信 IM SDK
  /// 仅windows&macos&web平台有效
  Future<NIMResult<void>> releaseDesktop() async {
    return InitializeServicePlatform.instance.releaseDesktop();
  }
}

class _Alog with LogMixin {
  static const module = 'nim_interface';

  void v(String tag, String msg) {
    Alog.v(
      tag: tag,
      moduleName: module,
      content: msg,
    );
  }

  void d(String tag, String msg) {
    Alog.d(
      tag: tag,
      moduleName: module,
      content: msg,
    );
  }

  void i(String tag, String msg) {
    Alog.i(
      tag: tag,
      moduleName: module,
      content: msg,
    );
  }

  void w(String tag, String msg) {
    Alog.w(
      tag: tag,
      moduleName: module,
      content: msg,
    );
  }

  void e(String tag, String msg) {
    Alog.e(
      tag: tag,
      moduleName: module,
      content: msg,
    );
  }
}
