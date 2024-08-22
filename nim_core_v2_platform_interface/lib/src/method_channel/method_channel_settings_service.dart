// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_v2_platform_interface/src/platform_interface/nim_base.dart';
import 'package:nim_core_v2_platform_interface/src/platform_interface/setting/dnd_config.dart';
import 'package:nim_core_v2_platform_interface/src/platform_interface/setting/setting_enum.dart';
import 'package:nim_core_v2_platform_interface/src/platform_interface/team/team_enum.dart';
import '../platform_interface/setting/platform_interface_settings_service.dart';

class MethodChannelSettingsService extends SettingsServicePlatform {
  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onTeamMessageMuteModeChanged':
        if (arguments != null) {
          TeamMuteModeChangedResult result = TeamMuteModeChangedResult.fromJson(
              Map<String, dynamic>.from(arguments as Map));
          SettingsServicePlatform.instance.onTeamMessageMuteModeChanged
              .add(result);
        }
        break;
      case 'onP2PMessageMuteModeChanged':
        if (arguments != null) {
          print("onP2PMessageMuteModeChanged flutter 1");
          P2PMuteModeChangedResult result = P2PMuteModeChangedResult.fromJson(
              Map<String, dynamic>.from(arguments as Map));
          print("onP2PMessageMuteModeChanged flutter 2");

          SettingsServicePlatform.instance.onP2PMessageMuteModeChanged
              .add(result);
        }
        break;
      default:
        break;
    }

    return Future.value(null);
  }

  @override
  String get serviceName => 'SettingsService';

  /// 获取免打扰配置
  /// @return NIMDndConfig
  @override
  Future<NIMResult<NIMDndConfig>> getDndConfig() async {
    return NIMResult.fromMap(await invokeMethod('getDndConfig'),
        convert: (json) => NIMDndConfig.fromJson(json));
  }

  /// 获取会话消息免打扰状态
  /// @return bool
  @override
  Future<NIMResult<bool>> getConversationMuteStatus(
      String conversationId) async {
    return NIMResult.fromMap(await invokeMethod('getConversationMuteStatus',
        arguments: {'conversationId': conversationId}));
  }

  /// 获取群组消息免打扰模式
  /// @param teamId 群组id
  @override
  Future<NIMResult<List<String>>> getP2PMessageMuteList() async {
    return NIMResult.fromMap(await invokeMethod('getP2PMessageMuteList'),
        convert: (json) => List<String>.from(json['muteList']));
  }

  /// 获取点对点消息免打扰模式
  /// @param accountId 账号Id
  @override
  Future<NIMResult<NIMP2PMessageMuteMode>> getP2PMessageMuteMode(
      String accountId) async {
    return NIMResult.fromMap(
        await invokeMethod('getP2PMessageMuteMode',
            arguments: {'accountId': accountId}), convert: (json) {
      var model = json['muteMode']?.toInt();
      if (model == null) {
        return null;
      } else {
        return NIMP2PMessageMuteModeClass.fromEnumInt(model);
      }
    });
  }

  /// 获取群组消息免打扰模式
  /// @param teamId 群组id
  @override
  Future<NIMResult<NIMTeamMessageMuteMode?>> getTeamMessageMuteMode(
      String teamId, NIMTeamType teamType) async {
    return NIMResult.fromMap(
        await invokeMethod('getTeamMessageMuteMode',
            arguments: {'teamId': teamId, 'teamType': teamType.index}),
        convert: (json) {
      var model = json['muteMode']?.toInt();
      if (model == null) {
        return null;
      } else {
        return NIMTeamMessageMuteModeClass.fromEnumInt(model);
      }
    });
  }

  /// 设置免打扰配置
  /// @param config 免打扰配置
  @override
  Future<NIMResult<void>> setDndConfig(NIMDndConfig config) async {
    return NIMResult.fromMap(await invokeMethod('setDndConfig',
        arguments: {'config': config?.toJson()}));
  }

  /// 设置当桌面端在线时，移动端是否需要推送
  /// @param mute 是否免打扰
  /// @param badge 角标数量
  @override
  Future<NIMResult<void>> setAppBackground(bool isBackground, int badge) async {
    return NIMResult.fromMap(await invokeMethod('setAppBackground',
        arguments: {'isBackground': isBackground, 'badge': badge}));
  }

  /// 设置单聊消息免打扰
  ///  @param accountId 账号Id
  ///  @param muteMode 免打扰模式
  @override
  Future<NIMResult<void>> setP2PMessageMuteMode(
      String accountId, NIMP2PMessageMuteMode muteMode) async {
    return NIMResult.fromMap(await invokeMethod('setP2PMessageMuteMode',
        arguments: {'accountId': accountId, 'muteMode': muteMode.index}));
  }

  @override
  Future<NIMResult<void>> setPushMobileOnDesktopOnline(bool need) async {
    return NIMResult.fromMap(await invokeMethod('setPushMobileOnDesktopOnline',
        arguments: {'need': need}));
  }

  @override
  Future<NIMResult<void>> setTeamMessageMuteMode(String teamId,
      NIMTeamType teamType, NIMTeamMessageMuteMode muteMode) async {
    return NIMResult.fromMap(await invokeMethod('setTeamMessageMuteMode',
        arguments: {
          'teamId': teamId,
          'teamType': teamType.index,
          'muteMode': muteMode.index
        }));
  }
}
