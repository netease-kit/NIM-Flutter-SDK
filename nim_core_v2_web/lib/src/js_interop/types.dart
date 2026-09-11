// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:js_interop';

/// V2NIMError JS 类型绑定
extension type JSV2NIMError(JSObject _) implements JSObject {
  external JSNumber? get code;
  external JSString? get desc;
  @JS('toString')
  external JSString toJSString();
}

/// NIM SDK 初始化选项
extension type JSNIMInitializeOptions._(JSObject _) implements JSObject {
  external factory JSNIMInitializeOptions({
    JSString appkey,
    JSString? debugLevel,
    JSNumber? loginExtensionProviderDelay,
    JSNumber? tokenProviderDelay,
    JSNumber? reconnectDelayProviderDelay,
    JSBoolean? enableV2CloudConversation,
    JSString? flutterSdkVersion,
  });

  external JSString get appkey;
  external JSString? get debugLevel;
  external JSNumber? get loginExtensionProviderDelay;
  external JSNumber? get tokenProviderDelay;
  external JSNumber? get reconnectDelayProviderDelay;
  external JSBoolean? get enableV2CloudConversation;
  external JSString? get flutterSdkVersion;
}

/// NIM SDK 其他选项
extension type JSNIMOtherOptions._(JSObject _) implements JSObject {
  external factory JSNIMOtherOptions();
}

/// 通用的事件监听 JS 接口
extension type JSEventEmitter(JSObject _) implements JSObject {
  external void on(JSString eventName, JSFunction callback);
  external void off(JSString eventName, JSFunction callback);
}
