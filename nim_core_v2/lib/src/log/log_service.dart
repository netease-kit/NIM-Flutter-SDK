// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yunxin_alog/yunxin_alog.dart';

extension ALogLevelExtension on ALogLevel {
  static ALogLevel get(int? mode) {
    return ALogLevel.values.firstWhere(
      (element) => element.index == mode,
      orElse: () => ALogLevel.verbose,
    );
  }
}

class ALoggerConfig {
  final ALogLevel level;
  final String? path;
  final String? namePrefix;

  const ALoggerConfig({
    ALogLevel? level,
    this.path,
    this.namePrefix,
  }) : this.level = kDebugMode ? ALogLevel.verbose : ALogLevel.info;

  static ALoggerConfig? fromMap(Map? map) {
    if (map == null) {
      return null;
    }
    return ALoggerConfig(
      level: ALogLevelExtension.get(map['level'] as int?),
      path: map['path'] as String?,
      namePrefix: map['namePrefix'] as String?,
    );
  }

  @override
  String toString() {
    return 'ALoggerConfig{level: $level, path: $path, namePrefix: $namePrefix}';
  }
}

class ALogService {
  static final ALogService _instance = ALogService._();

  ALogService._();

  factory ALogService() => _instance;

  String? _rootPath;

  String get rootPath => _rootPath ?? '';

  String get _flutterSDKPath {
    if (kIsWeb) {
      return '';
    }
    if (Platform.isAndroid) {
      return '${rootPath}extra_log/NIMFlutter/';
    } else if (Platform.isIOS) {
      return '${rootPath}NIMSDK/Logs/extra_log/';
    }
    return '${rootPath}NIMFlutter/';
  }

  ///nim ios默认增加 [NIMSDK] ，此处增加平台处理
  // String get _platformSDKPath => Platform.isIOS ? rootPath : '${rootPath}NIMSDK/';

  Future<bool> init({ALoggerConfig? config}) async {
    if (kIsWeb) {
      return true;
    }
    if (_rootPath != null) {
      return true;
    }

    config ??= ALoggerConfig();
    var logRootPath = config.path;
    if (logRootPath?.isEmpty ?? true) {
      logRootPath = await _defaultLogRootPath;
    }

    _rootPath = logRootPath!.endsWith('/') ? logRootPath : '$logRootPath/';
    if (!(await _createDirectory(rootPath))) return false;
    // if (!(await _createDirectory(_platformSDKPath))) return false;

    final success = Alog.init(
        config.level, _flutterSDKPath, config.namePrefix ?? 'nim_flutter_sdk');
    print('ALogService init with path: $_flutterSDKPath, success: $success');
    if (!success) {
      _rootPath = null;
    }
    return success;
  }

  static Future<bool> _createDirectory(String path) async {
    var isCreate = false;
    var filePath = Directory(path);
    try {
      if (!await filePath.exists()) {
        await filePath.create();
        isCreate = true;
      } else {
        isCreate = true;
      }
    } catch (e) {
      isCreate = false;
      print('error $e');
    }
    return isCreate;
  }

  /// 确保拉取 sdk 日志的时候带上 Flutter 的日志
  static Future<String> get _defaultLogRootPath async {
    Directory directory;
    if (kIsWeb) {
      return '';
    }

    if (Platform.isIOS) {
      /// im sdk iOS 默认日志路径：Documents/NIMSDK/Logs/
      directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } else if (Platform.isAndroid) {
      //directory = await getExternalStorageDirectory();
      final directory = await getTemporaryDirectory();
      return '${directory.path}/nim/';
    } else if (Platform.isWindows) {
      directory = await getApplicationDocumentsDirectory();
    } else if (Platform.isMacOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      throw UnsupportedError(
          'Unsupported platform: ${Platform.operatingSystem}');
    }
    return '${directory.path}/log/';
  }
}
