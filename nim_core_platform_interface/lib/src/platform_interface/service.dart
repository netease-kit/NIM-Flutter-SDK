// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class Service extends PlatformInterface {
  Service({required Object token}) : super(token: token) {
    ServiceDispatcher.register(this);
  }

  String get serviceName;

  static const MethodChannel _channel = ServiceDispatcher.channel;
  Future<dynamic> onEvent(String method, dynamic arguments);

  Future<Map<String, dynamic>> invokeMethod(String method,
      {Map<String, dynamic>? arguments}) async {
    print(
        'serviceName = $serviceName invokeMethod method = $method arguments = $arguments');
    if (arguments == null) arguments = {};
    arguments['serviceName'] = serviceName;
    final Map<String, dynamic>? replyMap =
        await _channel.invokeMapMethod<String, dynamic>(method, arguments);
    if (replyMap == null) {
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
    return onEvent(method, arguments);
  }
}

class ServiceDispatcher {
  static final Map<String, Service> services = {};
  static const MethodChannel channel = MethodChannel(
    'flutter.yunxin.163.com/nim_core',
  );

  static void register(Service service) {
    services[service.serviceName] = service;
    if (!channel.checkMethodCallHandler(dispatch)) {
      channel.setMethodCallHandler(dispatch);
    }
  }

  static void unregister(String serviceName) => services.remove(serviceName);

  static Future<dynamic> dispatch(MethodCall call) {
    String method = call.method;
    dynamic arguments = call.arguments;
    print('ServiceDispatcher dispatch method = $method arguments = $arguments');
    if (arguments == null) return Future.value(null);
    String serviceName = arguments['serviceName'] ?? "";
    print('ServiceDispatcher serviceName = $serviceName services = $services');
    return services[serviceName]?.handleMethodCall(method, arguments) ??
        Future.value(null);
  }
}
