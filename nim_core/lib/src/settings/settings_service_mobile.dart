// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
part of nim_core;

class _SettingsServiceMobile extends SettingsServicePlatform {
  @override
  Future onEvent(String method, arguments) {
    throw UnimplementedError();
  }

  @override
  String get serviceName => 'SettingsService';

  @override
  Future<NIMResult<void>> enableMobilePushWhenPCOnline(bool enable) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'enableMobilePushWhenPCOnline',
        arguments: {
          'enable': enable,
        },
      ),
    );
  }

  @override
  Future<NIMResult<bool>> isMobilePushEnabledWhenPCOnline() async {
    return NIMResult.fromMap(
      await invokeMethod(
        'isMobilePushEnabledWhenPCOnline',
      ),
    );
  }

  @override
  Future<NIMResult<void>> enableNotificationAndroid({
    required bool enableRegularNotification,
    required bool enableRevokeMessageNotification,
  }) async {
    if (Platform.isAndroid) {
      return NIMResult.fromMap(
        await invokeMethod(
          'enableNotification',
          arguments: {
            'enableRegularNotification': enableRegularNotification,
            'enableRevokeMessageNotification': enableRevokeMessageNotification,
          },
        ),
      );
    }
    return NIMResult(-1, null, 'Support Android platform only');
  }

  Future<NIMResult<void>> updateNotificationConfigAndroid(
      NIMStatusBarNotificationConfig config) async {
    if (Platform.isAndroid) {
      return NIMResult.fromMap(
        await invokeMethod(
          'updateNotificationConfig',
          arguments: config.toMap(),
        ),
      );
    }
    return NIMResult(-1, null, 'Support Android platform only');
  }

  Future<NIMResult<void>> enablePushServiceAndroid(bool enable) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'enablePushService',
        arguments: {
          'enable': enable,
        },
      ),
    );
  }

  Future<NIMResult<bool>> isPushServiceEnabledAndroid() async {
    return NIMResult.fromMap(
      await invokeMethod(
        'isPushServiceEnabled',
      ),
    );
  }

  Future<NIMResult<NIMPushNoDisturbConfig>> getPushNoDisturbConfig() async {
    return NIMResult.fromMap(
      await invokeMethod(
        'getPushNoDisturbConfig',
      ),
      convert: (map) {
        return NIMPushNoDisturbConfig.fromMap(Map<String, dynamic>.from(map));
      },
    );
  }

  Future<NIMResult<void>> setPushNoDisturbConfig(
      NIMPushNoDisturbConfig config) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'setPushNoDisturbConfig',
        arguments: config.toMap(),
      ),
    );
  }

  Future<NIMResult<bool>> isPushShowDetailEnabled() async {
    return NIMResult.fromMap(
      await invokeMethod(
        'isPushShowDetailEnabled',
      ),
    );
  }

  Future<NIMResult<void>> enablePushShowDetail(bool enable) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'enablePushShowDetail',
        arguments: {
          'enable': enable,
        },
      ),
    );
  }

  /// 更新iOS deviceToken
  @override
  Future<NIMResult<void>> updateAPNSTokenIOS(
      Uint8List token, String? customContentKey) async {
    if (Platform.isIOS) {
      return NIMResult.fromMap(
        await invokeMethod(
          'updateAPNSToken',
          arguments: {
            'token': token,
            'key': customContentKey,
          },
        ),
      );
    }
    return NIMResult(-1, null, 'Support iOS platform only');
  }

  /// 打包日志文件，并返回文件路径
  Future<NIMResult<String>> archiveLogs() async {
    return NIMResult.fromMap(await invokeMethod('archiveLogs'));
  }

  /// 打包日志文件并上传，返回日志文件的 url 地址
  ///
  /// [chatroomId] 聊天室ID 如果没有 <br>
  /// [comment] 日志评论, 可选, 最长4096字符 <br>
  /// [partial] true：上传全部/ false: 上传全部。 **Android可用**
  ///
  Future<NIMResult<String>> uploadLogs(
      {String? chatroomId, String? comment, bool partial = true}) async {
    return NIMResult.fromMap(await invokeMethod(
      'uploadLogs',
      arguments: {
        'chatroomId': chatroomId ?? '',
        'comment': comment,
        'partial': partial,
      },
    ));
  }

  ///
  /// 计算 SDK 缓存文件的大小，例如收发图片消息的缩略图，语音消息录音文件等等。*Android可用*
  ///
  /// [fileTypes] 文件类型列表 <br>
  /// [startTime] 开始时间，毫秒，若设置为0 表示不限起始时间 <br>
  /// [endTime] 结束时间，毫秒，若设置为0 表示不限结束时间 <br>
  ///
  Future<NIMResult<int>> getSizeOfDirCache(
      List<NIMDirCacheFileType> fileTypes, int startTime, int endTime) async {
    return NIMResult<int>.fromMap(
      await invokeMethod(
        'getSizeOfDirCache',
        arguments: {
          'fileTypes':
              fileTypes.map((e) => stringifyDirCacheFileTypeName(e)).toList(),
          'startTime': startTime,
          'endTime': endTime,
        },
      ),
    );
  }

  ///
  /// 删除 SDK 指定类型的缓存文件，例如收发图片消息的缩略图，语音消息录音文件等等。*Android可用*
  ///
  /// [fileTypes] 文件类型列表 <br>
  /// [startTime] 开始时间，毫秒，若设置为0 表示不限起始时间 <br>
  /// [endTime] 结束时间，毫秒，若设置为0 表示不限结束时间 <br>
  ///
  Future<NIMResult<void>> clearDirCache(
      List<NIMDirCacheFileType> fileTypes, int startTime, int endTime) async {
    return NIMResult<void>.fromMap(
      await invokeMethod(
        'clearDirCache',
        arguments: {
          'fileTypes':
              fileTypes.map((e) => stringifyDirCacheFileTypeName(e)).toList(),
          'startTime': startTime,
          'endTime': endTime,
        },
      ),
    );
  }

  @override
  Future<NIMResult<int>> removeResourceFiles(
      NIMResourceQueryOption option) async {
    return NIMResult<int>.fromMap(
      await invokeMethod(
        'removeResourceFiles',
        arguments: option.toMap(),
      ),
    );
  }

  @override
  Future<NIMResult<List<NIMCacheQueryResult>>> searchResourceFiles(
      NIMResourceQueryOption option) async {
    return NIMResult<List<NIMCacheQueryResult>>.fromMap(
      await invokeMethod(
        'searchResourceFiles',
        arguments: option.toMap(),
      ),
      convert: (map) {
        return (map['result'] as List?)
            ?.map((e) =>
                NIMCacheQueryResult.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      },
    );
  }

  @override
  Future<NIMResult<void>> registerBadgeCount(int count) async {
    return NIMResult<void>.fromMap(
      await invokeMethod('registerBadgeCountHandler',
          arguments: {'count': count}),
    );
  }
}
