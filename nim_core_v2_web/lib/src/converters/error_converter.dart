// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

/// 将 JS 错误转为 NIMResult.failure
///
/// V2NIMError 继承自原生 JS Error，不能直接使用 extension type 的 external getter
/// （在 DDC 开发模式下类型断言可能失败），必须使用 getProperty + isA<> 显式类型检测
NIMResult<T> convertJSErrorToNIMResult<T>(Object error) {
  if (error is JSObject) {
    final errObj = error as JSObject;

    // 使用 getProperty + isA<> 安全提取 code（int）
    int code = -1;
    final codeJs = errObj.getProperty('code'.toJS);
    if (codeJs != null && codeJs.isA<JSNumber>()) {
      code = (codeJs as JSNumber).toDartInt;
    }

    // 使用 getProperty + isA<> 安全提取 desc（String）
    String? desc;
    final descJs = errObj.getProperty('desc'.toJS);
    if (descJs != null && descJs.isA<JSString>()) {
      desc = (descJs as JSString).toDart;
    }

    return NIMResult<T>.fromMap({
      'code': code,
      'errorDetails': desc ?? 'NIM Error code: $code',
    });
  }
  return NIMResult<T>.fromMap({'code': -1, 'errorDetails': error.toString()});
}

/// 包装异步 JS 调用，统一捕获错误并转为 NIMResult
Future<NIMResult<T>> wrapJSPromise<T>(
  Future<T> Function() fn, {
  T Function(JSAny? result)? converter,
}) async {
  try {
    final result = await fn();
    return NIMResult<T>.fromMap({'code': 0, 'data': result});
  } catch (e) {
    return convertJSErrorToNIMResult<T>(e);
  }
}

/// 包装返回 void 的 JS Promise 调用
Future<NIMResult<void>> wrapJSPromiseVoid(Future<void> Function() fn) async {
  try {
    await fn();
    return NIMResult<void>.fromMap({'code': 0});
  } catch (e) {
    return convertJSErrorToNIMResult<void>(e);
  }
}
