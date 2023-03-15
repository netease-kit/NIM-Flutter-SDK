// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// import 'dart:html' as html;
import 'dart:async';
import 'dart:js';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class NimCoreWebPlugin extends PlatformMethodCallHandler {
  NimCoreWebPlugin() {
    // injectCssAndJSLibraries();
    initEmit();
  }

  void initEmit() {
    context["__yx_emit__"] = (serviceName, method, params) {
      params['serviceName'] = serviceName;
      handlePlatformMethod(MethodCall(method,
          jsonDecode(context['JSON'].callMethod('stringify', [params]))));
    };
  }

  static NimCoreWebPlugin _instance = NimCoreWebPlugin();

  static NimCoreWebPlugin get instance => _instance;

  static set instance(instance) {
    _instance = instance;
  }

  static void registerWith(Registrar registrar) {
    // registrar: Instance of 'PluginRegistry'
    PlatformMethodCallHandler.instance = instance;
  }

  Future<Map<String, dynamic>?> invokePlatformMethod(
    String serviceName,
    String method, {
    Map<String, dynamic>? arguments,
  }) async {
    Completer<Map<String, dynamic>> completer = Completer();
    final Map<String, dynamic> callInfoMap = {
      'serviceName': serviceName,
      'method': method,
      'params': JsObject.jsify(arguments!),
      'successCallback': allowInterop((res) {
        Map<String, dynamic> map =
            jsonDecode(context['JSON'].callMethod('stringify', [res]));
        completer.complete(map);
      }),
      'errorCallback': allowInterop((err) {
        Map<String, dynamic> map =
            jsonDecode(context['JSON'].callMethod('stringify', [err]));
        completer.complete(map);
        // completer.completeError(err);
      })
    };

    context.callMethod('dartCallNativeJs', [JsObject.jsify(callInfoMap)]);
    return completer.future;
  }

  // Future<void> injectCssAndJSLibraries() async {
  //   final List<Future<void>> loading = <Future<void>>[];
  //   final List<html.HtmlElement> tags = <html.HtmlElement>[];
  //   List paths = [
  //     // 'assets/packages/nim_core_web/assets/sdk/NIM_Web_SDK_v9.1.2.js',
  //     'assets/packages/nim_core_web/assets/main.js',
  //     // 'assets/packages/nim_core_web/assets/utils.js',
  //   ];

  //   for (var i = 0; i < paths.length; i++) {
  //     final html.ScriptElement script = html.ScriptElement()
  //       // ..defer = true
  //       ..src = '${paths[i]}';
  //     // loading.add(script.onLoad.first);
  //     tags.add(script);
  //   }
  //   html
  //       .querySelector('head')!
  //       .insertAllBefore(tags, html.querySelector('head')!.children[0]);
  //   await Future.wait(loading);
  // }
}
