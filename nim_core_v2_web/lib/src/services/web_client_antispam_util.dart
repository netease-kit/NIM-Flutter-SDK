// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

import '../converters/error_converter.dart';
import '../converters/js_dart_converter.dart';
import '../js_interop/nim_sdk.dart';
import 'web_initialize_service.dart';

/// Web 端客户端本地反垃圾工具实现
class WebV2NIMClientAntispamUtil extends V2NIMClientAntispamUtilPlatform {
  JSObject? _jsUtil;

  WebV2NIMClientAntispamUtil() {
    WebInitializeService.registerOnInit(_onNimInit);
    WebInitializeService.registerOnRelease(_onNimRelease);
  }

  void _onNimInit(JSV2NIM nim) {
    final util = (nim as JSObject).getProperty('V2NIMClientAntispamUtil'.toJS);
    if (util != null && util.isA<JSObject>()) {
      _jsUtil = util as JSObject;
    }
  }

  void _onNimRelease() {
    _jsUtil = null;
  }

  @override
  String get serviceName => 'V2NIMClientAntispamUtil';

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async => null;

  @override
  Future<NIMResult<NIMClientAntispamResult>> checkTextAntispam(
      String text, String? replace) async {
    final util = _jsUtil;
    if (util == null) {
      return NIMResult<NIMClientAntispamResult>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    }

    try {
      final method = util.getProperty('checkTextAntispam'.toJS) as JSFunction;
      final result =
          method.callAsFunction(util, text.toJS, (replace ?? '').toJS);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject);
        return NIMResult<NIMClientAntispamResult>.fromMap(
          {'code': 0, 'data': map},
          convert: (data) => NIMClientAntispamResult.fromJson(
              (data as Map).cast<String, dynamic>()),
        );
      }
      return NIMResult<NIMClientAntispamResult>.fromMap({
        'code': -1,
        'errorDetails': 'checkTextAntispam returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMClientAntispamResult>(e);
    }
  }
}
