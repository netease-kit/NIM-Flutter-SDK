// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core;

class SettingsService {
  factory SettingsService() {
    if (_singleton == null) {
      _singleton = SettingsService._();
    }
    return _singleton!;
  }

  SettingsService._() {
    if (Platform.isIOS || Platform.isAndroid) {
      SettingsServicePlatform.instance = _SettingsServiceMobile();
    }
  }

  static SettingsService? _singleton;

  SettingsServicePlatform get _platform => SettingsServicePlatform.instance;

  ///
  /// 设置桌面端(PC/WEB)在线时，移动端是否需要推送
  ///
  /// [enable] true 桌面端在线时移动端需推送；false 桌面端在线时移动端不需推送
  Future<NIMResult<void>> enableMobilePushWhenPCOnline({
    required bool enable,
  }) {
    return _platform.enableMobilePushWhenPCOnline(enable);
  }

  ///
  /// 查询桌面端(PC/WEB)在线时，移动端推送开关状态
  ///
  Future<NIMResult<bool>> isMobilePushEnabledWhenPCOnline() {
    return _platform.isMobilePushEnabledWhenPCOnline();
  }

  /// 配置消息提醒，仅支持 Android 平台，iOS平台请关闭通知权限。
  /// 配置 [updateNotificationConfigAndroid] 才能生效
  ///
  /// <p>[enableRegularNotification] - 普通消息提醒开关
  /// <p>[enableRevokeMessageNotification] - 消息撤回是否提醒
  Future<NIMResult<void>> enableNotificationAndroid({
    required bool enableRegularNotification,
    required bool enableRevokeMessageNotification,
  }) {
    return _platform.enableNotificationAndroid(
      enableRegularNotification: enableRegularNotification,
      enableRevokeMessageNotification: enableRevokeMessageNotification,
    );
  }

  /// 更新通知栏设置，仅支持Android平台
  Future<NIMResult<void>> updateNotificationConfigAndroid(
      NIMStatusBarNotificationConfig config) async {
    return _platform.updateNotificationConfigAndroid(config);
  }

  /// 开启或关闭消息推送；当设置为 false 时，该客户端将接收不到来自云信体系内的推送。
  Future<NIMResult<void>> enablePushServiceAndroid(bool enable) {
    return _platform.enablePushServiceAndroid(enable);
  }

  /// 查询当前推送服务开关
  Future<NIMResult<bool>> isPushServiceEnabledAndroid() {
    return _platform.isPushServiceEnabledAndroid();
  }

  /// 获取当前免打扰设置
  Future<NIMResult<NIMPushNoDisturbConfig>> getPushNoDisturbConfig() {
    return _platform.getPushNoDisturbConfig();
  }

  /// 设置免打扰配置
  Future<NIMResult<void>> setPushNoDisturbConfig(
      NIMPushNoDisturbConfig config) async {
    return _platform.setPushNoDisturbConfig(config);
  }

  /// 查询推送是否显示详情
  Future<NIMResult<bool>> isPushShowDetailEnabled() {
    return _platform.isPushShowDetailEnabled();
  }

  /// 设置推送是否显示详情
  Future<NIMResult<void>> enablePushShowDetail(bool enable) {
    return _platform.enablePushShowDetail(enable);
  }

  /// 更新iOS deviceToken
  ///
  /// [token] 当前设备的 devicetoken
  ///
  /// [customContentKey] 自定义本端推送内容, 设置key可对应业务服务器自定义推送文案; 传空字符串清空配置, null 则不更改
  Future<NIMResult<void>> updateAPNSToken(
      Uint8List token, String? customContentKey) async {
    return _platform.updateAPNSTokenIOS(token, customContentKey);
  }

  /// 打包日志文件，并返回文件路径
  Future<NIMResult<String>> archiveLogs() {
    return _platform.archiveLogs();
  }

  /// 打包日志文件并上传，返回日志文件的 url 地址
  ///
  /// [chatroomId] 聊天室ID 如果没有传空 <br>
  /// [comment] 日志评论, 可选, 最长4096字符 <br>
  /// [partial] true：上传部分/ false: 上传全部。 **Android可用**
  ///
  Future<NIMResult<String>> uploadLogs({
    String? chatroomId,
    String? comment,
    bool partial = true,
  }) {
    return _platform.uploadLogs(
        chatroomId: chatroomId, comment: comment, partial: partial);
  }

  ///
  /// 计算 SDK 缓存文件的大小，例如收发图片消息的缩略图，语音消息录音文件等等。*Android可用*
  ///
  /// [fileTypes] 文件类型列表 <br>
  /// [startTime] 开始时间，毫秒，若设置为0 表示不限起始时间 <br>
  /// [endTime] 结束时间，毫秒，若设置为0 表示不限结束时间 <br>
  ///
  Future<NIMResult<int>> getSizeOfDirCache(
      List<NIMDirCacheFileType> fileTypes, int startTime, int endTime) {
    return _platform.getSizeOfDirCache(fileTypes, startTime, endTime);
  }

  ///
  /// 删除 SDK 指定类型的缓存文件，例如收发图片消息的缩略图，语音消息录音文件等等。*Android可用*
  ///
  /// [fileTypes] 文件类型列表 <br>
  /// [startTime] 开始时间，毫秒，若设置为0 表示不限起始时间 <br>
  /// [endTime] 结束时间，毫秒，若设置为0 表示不限结束时间 <br>
  ///
  Future<NIMResult<void>> clearDirCache(
      List<NIMDirCacheFileType> fileTypes, int startTime, int endTime) {
    return _platform.clearDirCache(fileTypes, startTime, endTime);
  }

  ///搜索缓存的资源文件 *iOS可用*
  Future<NIMResult<List<NIMCacheQueryResult>>> searchResourceFiles(
      NIMResourceQueryOption option) {
    return _platform.searchResourceFiles(option);
  }

  ///  删除缓存的资源文件 *iOS可用*
  Future<NIMResult<int>> removeResourceFiles(NIMResourceQueryOption option) {
    return _platform.removeResourceFiles(option);
  }

  /// 注册自定义云信角标未读数 *iOS可用*
  /// 在每次角标数量变化时调用
  Future<NIMResult<void>> registerBadgeCount(int count) {
    return _platform.registerBadgeCount(count);
  }
}
