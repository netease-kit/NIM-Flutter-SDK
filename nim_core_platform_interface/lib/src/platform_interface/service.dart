// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:nim_core_platform_interface/src/utils/log.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class Service extends PlatformInterface {
  Service({required Object token}) : super(token: token) {
    ServiceDispatcher.instance.register(this);
  }

  String get serviceName;

  static MethodChannel _channel = ServiceDispatcher.instance.channel;

  Future<dynamic> onEvent(String method, dynamic arguments);

  Future<Map<String, dynamic>> invokeMethod(String method,
      {Map<String, dynamic>? arguments}) async {
    Log.i(serviceName, 'invoke method: ==$method==');
    if (arguments == null) arguments = {};
    arguments['serviceName'] = serviceName;
    final Map<String, dynamic>? replyMap =
        await _channel.invokeMapMethod<String, dynamic>(method, arguments);
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

class ServiceDispatcher {
  final Map<String, Service> services = {};
  MethodChannel channel = MethodChannel(
    'flutter.yunxin.163.com/nim_core',
  );

  static final ServiceDispatcher instance = ServiceDispatcher._();

  ServiceDispatcher._() {
    channel.setMethodCallHandler(dispatch);
  }

  void register(Service service) {
    services[service.serviceName] = service;
  }

  void unregister(String serviceName) => services.remove(serviceName);

  Future<dynamic> dispatch(MethodCall call) {
    String method = call.method;
    dynamic arguments = call.arguments;
    if (arguments == null) return Future.value(null);
    String serviceName = arguments['serviceName'] ?? "";
    return services[serviceName]?.handleMethodCall(method, arguments) ??
        Future.value(null);
  }
}
