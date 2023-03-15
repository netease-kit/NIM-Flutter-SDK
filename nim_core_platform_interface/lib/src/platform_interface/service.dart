// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nim_core_platform_interface/src/utils/log.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

final Map<String, Service> services = {};

abstract class Service extends PlatformInterface {
  final _methodCallHandler = kIsWeb
      ? PlatformMethodCallHandler.instance
      : _MethodChannelHandler.instance;

  Service({required Object token}) : super(token: token) {
    _methodCallHandler._register(this);
  }

  String get serviceName;

  Future<dynamic> onEvent(String method, dynamic arguments);

  Future<Map<String, dynamic>> invokeMethod(String method,
      {Map<String, dynamic>? arguments}) async {
    Log.i(serviceName, 'invoke method: ==$method==');
    if (arguments == null) arguments = {};
    arguments['serviceName'] = serviceName;
    final Map<String, dynamic>? replyMap = await _methodCallHandler
        .invokePlatformMethod(serviceName, method, arguments: arguments);
    if (replyMap == null) {
      Log.i(serviceName, 'invoke method ==$method== return null');
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else {
      return replyMap;
    }
  }

  Future<dynamic> handleMethodCall(String method, dynamic arguments) {
    Log.i(serviceName, 'handle method call: ==$method==');
    return onEvent(method, arguments);
  }
}

abstract class PlatformMethodCallHandler {
  static PlatformMethodCallHandler? _instance;

  static PlatformMethodCallHandler get instance {
    return _instance!;
  }

  static set instance(PlatformMethodCallHandler instance) {
    _instance = instance;
  }

  static final Map<String, Service> services = {};

  void _register(Service service) {
    services[service.serviceName] = service;
  }

  // void _unregister(String serviceName) => services.remove(serviceName);

  /// 调用平台的接口
  Future<Map<String, dynamic>?> invokePlatformMethod(
    String serviceName,
    String method, {
    Map<String, dynamic>? arguments,
  });

  /// 处理平台的调用
  Future<dynamic> handlePlatformMethod(MethodCall call) {
    String method = call.method;
    dynamic arguments = call.arguments;
    if (arguments == null) return Future.value(null);
    String serviceName = arguments['serviceName'] ?? "";
    return services[serviceName]?.handleMethodCall(method, arguments) ??
        Future.value(null);
  }
}

class _MethodChannelHandler extends PlatformMethodCallHandler {
  static final _MethodChannelHandler instance = _MethodChannelHandler._();

  static const MethodChannel channel = MethodChannel(
    'flutter.yunxin.163.com/nim_core',
  );

  _MethodChannelHandler._() {
    channel.setMethodCallHandler(handlePlatformMethod);
  }

  @override
  Future<Map<String, dynamic>?> invokePlatformMethod(
    String serviceName,
    String method, {
    Map<String, dynamic>? arguments,
  }) {
    return channel.invokeMapMethod<String, dynamic>(method, arguments);
  }
}
