// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

library nim_core;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hawk_meta/hawk_meta.dart';
import 'package:nim_core/src/event_subscribe/event_subscribe_service.dart';
import 'package:nim_core/src/log/log_service.dart';
import 'package:nim_core/src/system_message/system_message_service.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:universal_io/io.dart';
import 'package:yunxin_alog/yunxin_alog.dart';

export 'package:nim_core/src/event_subscribe/event_subscribe_service.dart';
export 'package:nim_core/src/system_message/system_message_service.dart';
export 'package:nim_core_platform_interface/src/platform_interface/audio/record_info.dart';
export 'package:nim_core_platform_interface/src/platform_interface/auth/auth_models.dart';
export 'package:nim_core_platform_interface/src/platform_interface/avsignalling/avsignalling_models.dart';
export 'package:nim_core_platform_interface/src/platform_interface/chatroom/chatroom_models.dart';
export 'package:nim_core_platform_interface/src/platform_interface/event_subscribe/event.dart';
export 'package:nim_core_platform_interface/src/platform_interface/event_subscribe/event_subscribe_request.dart';
export 'package:nim_core_platform_interface/src/platform_interface/event_subscribe/event_subscribe_result.dart';
export 'package:nim_core_platform_interface/src/platform_interface/event_subscribe/platform_interface_event_subscribe_service.dart';
export 'package:nim_core_platform_interface/src/platform_interface/initialize/nim_sdk_android_options.dart';
export 'package:nim_core_platform_interface/src/platform_interface/initialize/nim_sdk_ios_options.dart';
export 'package:nim_core_platform_interface/src/platform_interface/initialize/nim_sdk_macos_options.dart';
export 'package:nim_core_platform_interface/src/platform_interface/initialize/nim_sdk_options.dart';
export 'package:nim_core_platform_interface/src/platform_interface/initialize/nim_sdk_server_config.dart';
export 'package:nim_core_platform_interface/src/platform_interface/initialize/nim_sdk_windows_options.dart';
export 'package:nim_core_platform_interface/src/platform_interface/message/message.dart';
export 'package:nim_core_platform_interface/src/platform_interface/message/message_keyword_search_config.dart';
export 'package:nim_core_platform_interface/src/platform_interface/message/message_search_option.dart';
export 'package:nim_core_platform_interface/src/platform_interface/message/query_direction_enum.dart';
export 'package:nim_core_platform_interface/src/platform_interface/message/quick_comment.dart';
export 'package:nim_core_platform_interface/src/platform_interface/message/recent_session_list.dart';
export 'package:nim_core_platform_interface/src/platform_interface/message/stick_top_session.dart';
export 'package:nim_core_platform_interface/src/platform_interface/message/talk_ext.dart';
export 'package:nim_core_platform_interface/src/platform_interface/message/thread_talk_history.dart';
export 'package:nim_core_platform_interface/src/platform_interface/nim_base.dart';
export 'package:nim_core_platform_interface/src/platform_interface/nos/nos.dart';
export 'package:nim_core_platform_interface/src/platform_interface/passthrough/pass_through_notifydata.dart';
export 'package:nim_core_platform_interface/src/platform_interface/passthrough/pass_through_proxydata.dart';
export 'package:nim_core_platform_interface/src/platform_interface/qchat/platform_interface_qchat_push_service.dart';
export 'package:nim_core_platform_interface/src/platform_interface/qchat/qchat_base_models.dart';
export 'package:nim_core_platform_interface/src/platform_interface/qchat/qchat_channel_models.dart';
export 'package:nim_core_platform_interface/src/platform_interface/qchat/qchat_message_models.dart';
export 'package:nim_core_platform_interface/src/platform_interface/qchat/qchat_models.dart';
export 'package:nim_core_platform_interface/src/platform_interface/qchat/qchat_observer_models.dart';
export 'package:nim_core_platform_interface/src/platform_interface/qchat/qchat_push_models.dart';
export 'package:nim_core_platform_interface/src/platform_interface/qchat/qchat_role_models.dart';
export 'package:nim_core_platform_interface/src/platform_interface/qchat/qchat_server_models.dart';
export 'package:nim_core_platform_interface/src/platform_interface/robot/robot_message_type.dart';
export 'package:nim_core_platform_interface/src/platform_interface/settings/settings_models.dart';
export 'package:nim_core_platform_interface/src/platform_interface/super_team/platform_interface_super_team_service.dart';
export 'package:nim_core_platform_interface/src/platform_interface/super_team/super_team.dart';
export 'package:nim_core_platform_interface/src/platform_interface/super_team/super_team_member.dart';
export 'package:nim_core_platform_interface/src/platform_interface/system_message/add_friend_notification.dart';
export 'package:nim_core_platform_interface/src/platform_interface/system_message/custom_notification.dart';
export 'package:nim_core_platform_interface/src/platform_interface/system_message/platform_interface_system_message_service.dart';
export 'package:nim_core_platform_interface/src/platform_interface/system_message/system_message.dart';
export 'package:nim_core_platform_interface/src/platform_interface/team/create_team_options.dart';
export 'package:nim_core_platform_interface/src/platform_interface/team/create_team_result.dart';
export 'package:nim_core_platform_interface/src/platform_interface/team/team.dart';
export 'package:nim_core_platform_interface/src/platform_interface/team/team_member.dart';
export 'package:nim_core_platform_interface/src/platform_interface/user/friend.dart';
export 'package:nim_core_platform_interface/src/platform_interface/user/mute_list_changed_notify.dart';
export 'package:nim_core_platform_interface/src/platform_interface/user/user.dart';
export 'package:nim_core_platform_interface/src/utils/converter.dart';

part 'src/audio/audio_service.dart';
part 'src/auth/auth_service.dart';
part 'src/avsignalling/avsignalling_service.dart';
part 'src/chatroom/chatroom_message_builder.dart';
part 'src/chatroom/chatroom_service.dart';
part 'src/message/message_builder.dart';
part 'src/message/message_service.dart';
part 'src/nos/nos_service.dart';
part 'src/passthrough/passthrough_service.dart';
part 'src/qchat/qchat_channel_service.dart';
part 'src/qchat/qchat_message_service.dart';
part 'src/qchat/qchat_observer.dart';
part 'src/qchat/qchat_push_service.dart';
part 'src/qchat/qchat_role_service.dart';
part 'src/qchat/qchat_server_service.dart';
part 'src/qchat/qchat_service.dart';
part 'src/settings/settings_service.dart';
part 'src/settings/settings_service_mobile.dart';
part 'src/super_team/super_team_service.dart';
part 'src/team/team_service.dart';
part 'src/user/user_service.dart';

class NimCore {
  NimCore._();

  static final NimCore instance = NimCore._();

  /// 云信消息服务接口
  final MessageService messageService = MessageService();

  static const String tag = 'nim_core';
  //todo 发版前记得处理此处的版本号，数据统计使用
  static const int _versionCode = 177;
  static const String versionName = '1.7.7';
  static const String _hash = '02566d6321d1d27669d9d369d2f525bc2cdaee10';

  bool _initialized = false;
  NIMSDKOptions? _sdkOptions;

  bool get isInitialized => _initialized;

  NIMSDKOptions? get sdkOptions => _sdkOptions;

  /// 云信用户服务接口
  final UserService userService = UserService();

  /// 云信音频服务接口
  final AudioService audioService = AudioService();

  /// 用户认证服务接口，提供用户登录登出业务接口。
  final AuthService authService = AuthService();

  ///云信事件订阅服务接口，用户可以通过事件发布及订阅，来实现"发布-订阅"的设计模式编程方法。可应用于订阅指定用户在线状态、用户个性化信息订阅等场景
  final EventSubscribeService eventSubscribeService = EventSubscribeService();

  ///系统通知服务，是云信系统内建的消息/通知，由云信服务器推送给用户的通知类消息，用于云信系统类的事件通知。
  final SystemMessageService systemMessageService = SystemMessageService();

  /// 普通群：
  /// 普通群没有权限操作，适用于快速创建多人会话的场景。每个普通群只有一个管理员。
  /// 管理员可以对普通群进行增减员操作，普通成员只能对普通群进行增员操作。
  /// 在添加新成员的时候，并不需要经过对方同意。
  ///
  /// 高级群（推荐）：
  /// 高级群在权限上有更多的限制，权限分为群主、管理员、以及群成员。
  /// 2.4.0之前版本在添加成员的时候需要对方接受邀请；2.4.0版本之后，可以设定被邀请模式（是否需要对方同意）。
  /// 高级群可以覆盖所有普通群的能力，建议开发者创建时选用高级群
  final TeamService teamService = TeamService();

  final SuperTeamService superTeamService = SuperTeamService();

  /// 聊天室服务，提供加入、退出、发送和接收聊天室消息等功能；
  final ChatroomService chatroomService = ChatroomService();

  ///信令服务
  final AvSignallingService avSignallingService = AvSignallingService();

  /// 设置服务
  final SettingsService settingsService = SettingsService();

  final NOSService nosService = NOSService();

  final PassThroughService passThroughService = PassThroughService();

  /// 圈组消息服务
  final QChatMessageService qChatMessageService = QChatMessageService();

  /// 圈组频道服务
  final QChatChannelService qChatChannelService = QChatChannelService();

  /// 圈组身份组服务
  final QChatRoleService qChatRoleService = QChatRoleService();

  /// 圈组服务器服务
  final QChatServerService qChatServerService = QChatServerService();

  /// 圈组服务
  final QChatService qChatService = QChatService();

  ///圈组回调
  final QChatObserver qChatObserver = QChatObserver();

  ///圈组推送相关
  final QChatPushService qChatPushService = QChatPushService();

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
  /// 仅windows&macos平台有效
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
