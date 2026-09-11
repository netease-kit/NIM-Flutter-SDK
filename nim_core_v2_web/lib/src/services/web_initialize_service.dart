// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

import '../converters/js_dart_converter.dart';
import '../js_interop/nim_sdk.dart';
import '../js_interop/types.dart';

/// Web 端 SDK 初始化服务
/// 管理 NIM Web SDK 的 JS 实例生命周期
class WebInitializeService extends InitializeServicePlatform {
  /// 全局 NIM SDK JS 实例引用
  static JSV2NIM? nimInstance;

  /// 初始化选项缓存
  static NIMWebSDKOptions? webOptions;

  /// 所有需要在 initialize 后初始化的 service 回调
  static final List<void Function(JSV2NIM nim)> _onInitCallbacks = [];

  /// 所有需要在 release 时清理的 service 回调
  static final List<void Function()> _onReleaseCallbacks = [];

  /// 注册初始化回调
  static void registerOnInit(void Function(JSV2NIM nim) callback) {
    _onInitCallbacks.add(callback);
    // 如果已经初始化过，立即回调
    if (nimInstance != null) {
      callback(nimInstance!);
    }
  }

  /// 注册释放回调
  static void registerOnRelease(void Function() callback) {
    _onReleaseCallbacks.add(callback);
  }

  @override
  String get serviceName => 'InitializeService';

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async {
    // Web 新模式不通过 onEvent 接收事件
    return null;
  }

  @override
  Future<NIMResult<void>> initialize(
    NIMSDKOptions options, [
    Map<String, dynamic>? extras,
  ]) async {
    try {
      if (options is! NIMWebSDKOptions) {
        return NIMResult<void>.fromMap({
          'code': -1,
          'errorDetails': 'NIMWebSDKOptions is required for Web platform',
        });
      }

      webOptions = options;

      // 构建 JS 初始化选项
      final initOptionsMap = options.initializeOptions.toJson();
      final jsInitOptions =
          dartMapToJsObject(initOptionsMap) as JSNIMInitializeOptions;

      // 获取 NIM 实例 — 通过 getNIMFactory() 安全访问 NIM['default']
      final factory = getNIMFactory();

      // 构建 JS 其他选项
      // 注意: 当 otherOptions 为 null 时，不传第二个参数（让 JS 使用 undefined），
      // 这样 JS SDK 的默认参数 `u = {}` 才能生效。
      // 如果传入 Dart null，dart:js_interop 会转为 JS null，
      // 而 JS 默认参数只对 undefined 生效，导致 null.loggerConfig 报错。
      if (options.otherOptions != null) {
        final jsOtherOptions = dartMapToJsObject(options.otherOptions!.toJson())
            as JSNIMOtherOptions;
        nimInstance = factory.getInstance(jsInitOptions, jsOtherOptions);
      } else {
        nimInstance = factory.getInstance(jsInitOptions);
      }

      // 通知所有已注册的 Service 进行初始化
      for (final callback in _onInitCallbacks) {
        callback(nimInstance!);
      }

      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return NIMResult<void>.fromMap({
        'code': -1,
        'errorDetails': e.toString(),
      });
    }
  }

  @override
  Future<NIMResult<void>> releaseDesktop() async {
    try {
      // 通知所有 Service 清理
      for (final callback in _onReleaseCallbacks) {
        callback();
      }

      nimInstance = null;
      webOptions = null;

      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return NIMResult<void>.fromMap({
        'code': -1,
        'errorDetails': e.toString(),
      });
    }
  }
}
