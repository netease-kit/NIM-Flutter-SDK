// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:typed_data';

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
  /// 仅Android
  /// <p>[enableRegularNotification] - 普通消息提醒开关
  /// <p>[enableRevokeMessageNotification] - 消息撤回是否提醒
  Future<NIMResult<void>> enableNotificationAndroid({
    required bool enableRegularNotification,
    required bool enableRevokeMessageNotification,
  });

  /// 更新通知栏设置，仅支持Android平台
  Future<NIMResult<void>> updateNotificationConfigAndroid(
      NIMStatusBarNotificationConfig config);

  /// 开启或关闭消息推送；当设置为 false 时，该客户端将接收不到来自云信体系内的推送。
  /// 仅android
  Future<NIMResult<void>> enablePushServiceAndroid(bool enable);

  /// 查询当前推送服务开关
  /// 仅android
  Future<NIMResult<bool>> isPushServiceEnabledAndroid();

  /// 获取当前免打扰设置
  Future<NIMResult<NIMPushNoDisturbConfig>> getPushNoDisturbConfig();

  /// 设置免打扰配置
  Future<NIMResult<void>> setPushNoDisturbConfig(NIMPushNoDisturbConfig config);

  /// 查询推送是否显示详情
  Future<NIMResult<bool>> isPushShowDetailEnabled();

  /// 设置推送是否显示详情
  Future<NIMResult<void>> enablePushShowDetail(bool enable);

  /// 更新iOS deviceToken 仅iOS
  Future<NIMResult<void>> updateAPNSTokenIOS(
      Uint8List token, String? customContentKey);

  /// 打包日志文件，并返回文件路径
  Future<NIMResult<String>> archiveLogs();

  /// 打包日志文件并上传，返回日志文件的 url 地址
  ///
  /// [chatroomId] 聊天室ID 如果没有 <br>
  /// [comment] 日志评论, 可选, 最长4096字符 <br>
  /// [partial] true：上传全部/ false: 上传全部。 **Android可用**
  ///
  Future<NIMResult<String>> uploadLogs({
    String? chatroomId,
    String? comment,
    bool partial = true,
  });

  ///
  /// 计算 SDK 缓存文件的大小，以字节为单位。例如收发图片消息的缩略图，语音消息录音文件等等。*Android可用*
  ///
  /// [fileTypes] 文件类型列表 <br>
  /// [startTime] 开始时间，毫秒，若设置为0 表示不限起始时间 <br>
  /// [endTime] 结束时间，毫秒，若设置为0 表示不限结束时间 <br>
  ///
  Future<NIMResult<int>> getSizeOfDirCache(
      List<NIMDirCacheFileType> fileTypes, int startTime, int endTime);

  ///
  /// 删除 SDK 指定类型的缓存文件，例如收发图片消息的缩略图，语音消息录音文件等等。*Android可用*
  ///
  /// [fileTypes] 文件类型列表 <br>
  /// [startTime] 开始时间，毫秒，若设置为0 表示不限起始时间 <br>
  /// [endTime] 结束时间，毫秒，若设置为0 表示不限结束时间 <br>
  ///
  Future<NIMResult<void>> clearDirCache(
      List<NIMDirCacheFileType> fileTypes, int startTime, int endTime);

  ///搜索缓存的资源文件 *iOS可用*
  Future<NIMResult<List<NIMCacheQueryResult>>> searchResourceFiles(
      NIMResourceQueryOption option);

  ///  删除缓存的资源文件 *iOS可用*
  Future<NIMResult<int>> removeResourceFiles(NIMResourceQueryOption option);

  /// 注册自定义云信角标未读数 *iOS可用*
  Future<NIMResult<void>> registerBadgeCount(int count);
}
