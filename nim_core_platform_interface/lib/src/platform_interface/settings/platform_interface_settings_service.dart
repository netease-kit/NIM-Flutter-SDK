// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/method_channel/method_channel_settings_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class SettingsServicePlatform extends Service {
  SettingsServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static SettingsServicePlatform _instance = MethodChannelSettingsService();

  static SettingsServicePlatform get instance => _instance;

  static set instance(SettingsServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  ///
  /// 设置桌面端(PC/WEB)在线时，移动端是否需要推送
  ///
  /// [enable] true 桌面端在线时移动端需推送；false 桌面端在线时移动端不需推送
  Future<NIMResult<void>> enableMobilePushWhenPCOnline(bool enable);

  /// 查询桌面端(PC/WEB)在线时，移动端推送开关
  Future<NIMResult<bool>> isMobilePushEnabledWhenPCOnline();

  /// 配置 Android 消息提醒
  ///
  /// <p>[enableRegularNotification] - 普通消息提醒开关
  /// <p>[enableRevokeMessageNotification] - 消息撤回是否提醒
  Future<NIMResult<void>> enableNotification({
    required bool enableRegularNotification,
    required bool enableRevokeMessageNotification,
  });

  /// 更新通知栏设置，仅支持Android平台
  Future<NIMResult<void>> updateNotificationConfig(
      NIMStatusBarNotificationConfig config);

  /// 开启或关闭消息推送；当设置为 false 时，该客户端将接收不到来自云信体系内的推送。
  Future<NIMResult<void>> enablePushService(bool enable);

  /// 查询当前推送服务开关
  Future<NIMResult<bool>> isPushServiceEnabled();

  /// 获取当前免打扰设置
  Future<NIMResult<NIMPushNoDisturbConfig>> getPushNoDisturbConfig();

  /// 设置免打扰配置
  Future<NIMResult<void>> setPushNoDisturbConfig(NIMPushNoDisturbConfig config);

  /// 查询推送是否显示详情
  Future<NIMResult<bool>> isPushShowDetailEnabled();

  /// 设置推送是否显示详情
  Future<NIMResult<void>> enablePushShowDetail(bool enable);
}
