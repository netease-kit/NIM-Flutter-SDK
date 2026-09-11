// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'types.dart';

/// NIM JS SDK 主入口绑定
///
/// Web SDK 的 UMD 包导出到 window.NIM 命名空间，但真正的类在 NIM.default 上。
/// UMD 包包装器执行: (globalThis).NIM = {}
/// 工厂函数最终执行: t.default = NIMClass (包含 getInstance 等静态方法)
///
/// 因此正确的调用路径是: window.NIM['default'].getInstance(options)
/// 注意: "default" 是 JS 保留关键字，不能用 @JS('NIM.default') 注解，
///       需要通过 getProperty('default') 方式安全访问。

/// NIM 全局命名空间 — 对应 window.NIM
@JS('NIM')
extension type JSNIMNamespace._(JSObject _) implements JSObject {}

/// NIM SDK 工厂类 — 即 NIM['default']，包含 getInstance 等静态方法
extension type JSNIMFactory._(JSObject _) implements JSObject {
  /// 调用 getInstance 获取 NIM 实例
  external JSV2NIM getInstance(
    JSNIMInitializeOptions initializeOptions, [
    JSNIMOtherOptions? otherOptions,
  ]);
}

/// 安全获取 NIM.default (NIM SDK 工厂)
/// 通过 getProperty 绕过 "default" 保留字问题
JSNIMFactory getNIMFactory() {
  final nimNamespace =
      JSNIMNamespace._(globalContext.getProperty('NIM'.toJS) as JSObject);
  final defaultExport = (nimNamespace as JSObject).getProperty('default'.toJS);
  if (defaultExport == null || defaultExport.isUndefinedOrNull) {
    throw StateError(
        'NIM.default is undefined. Make sure NIM_BROWSER_SDK.js is loaded before Flutter app.');
  }
  return JSNIMFactory._(defaultExport as JSObject);
}

/// NIM SDK 实例类型 — getInstance 返回的实例对象
/// 实例上的属性包括各种 Service
extension type JSV2NIM._(JSObject _) implements JSObject {
  /// 获取 LoginService
  /// 对应 JS 调用: nimInstance.V2NIMLoginService
  external JSV2NIMLoginServiceJS get V2NIMLoginService;

  /// 获取 MessageService
  external JSV2NIMMessageServiceJS get V2NIMMessageService;

  /// 获取 ConversationService
  external JSV2NIMConversationServiceJS get V2NIMConversationService;

  /// 获取 TeamService
  external JSV2NIMTeamServiceJS get V2NIMTeamService;

  /// 获取 FriendService
  external JSV2NIMFriendServiceJS get V2NIMFriendService;

  /// 获取 UserService
  external JSV2NIMUserServiceJS get V2NIMUserService;

  /// 获取 SettingsService
  external JSV2NIMSettingsServiceJS get V2NIMSettingService;

  /// 获取 StorageService
  external JSV2NIMStorageServiceJS get V2NIMStorageService;

  /// 获取 NotificationService
  external JSV2NIMNotificationServiceJS get V2NIMNotificationService;

  /// 获取 AIService
  external JSV2NIMAIServiceJS get V2NIMAIService;

  /// 获取 SubscriptionService
  external JSV2NIMSubscriptionServiceJS get V2NIMSubscriptionService;

  /// 获取 SignallingService
  external JSV2NIMSignallingServiceJS get V2NIMSignallingService;

  /// 获取 MessageCreator
  external JSV2NIMMessageCreatorJS get V2NIMMessageCreator;

  /// 获取 ConversationIdUtil
  external JSV2NIMConversationIdUtilJS get V2NIMConversationIdUtil;

  /// 获取 ClientAntispamUtil
  external JSV2NIMClientAntispamUtilJS get V2NIMClientAntispamUtil;

  /// 获取 MessageConverter
  external JSV2NIMMessageConverterJS get V2NIMMessageConverter;
}

// Forward declarations — 具体类型定义在各自文件中
// 这里用 JSObject 的 extension type 作为前置声明

extension type JSV2NIMLoginServiceJS(JSObject _) implements JSEventEmitter {}
extension type JSV2NIMMessageServiceJS(JSObject _) implements JSEventEmitter {}
extension type JSV2NIMConversationServiceJS(JSObject _)
    implements JSEventEmitter {}
extension type JSV2NIMTeamServiceJS(JSObject _) implements JSEventEmitter {}
extension type JSV2NIMFriendServiceJS(JSObject _) implements JSEventEmitter {}
extension type JSV2NIMUserServiceJS(JSObject _) implements JSEventEmitter {}
extension type JSV2NIMSettingsServiceJS(JSObject _) implements JSEventEmitter {}
extension type JSV2NIMStorageServiceJS(JSObject _) implements JSEventEmitter {}
extension type JSV2NIMNotificationServiceJS(JSObject _)
    implements JSEventEmitter {}
extension type JSV2NIMAIServiceJS(JSObject _) implements JSEventEmitter {}
extension type JSV2NIMSubscriptionServiceJS(JSObject _)
    implements JSEventEmitter {}
extension type JSV2NIMSignallingServiceJS(JSObject _)
    implements JSEventEmitter {}

/// V2NIMMessageCreator JS 类型
extension type JSV2NIMMessageCreatorJS(JSObject _) implements JSObject {}

/// V2NIMConversationIdUtil JS 类型
extension type JSV2NIMConversationIdUtilJS(JSObject _) implements JSObject {}

/// V2NIMClientAntispamUtil JS 类型
extension type JSV2NIMClientAntispamUtilJS(JSObject _) implements JSObject {}

/// V2NIMMessageConverter JS 类型
/// 参考 Web SDK 文档: V2NIMMessageConverter
extension type JSV2NIMMessageConverterJS(JSObject _) implements JSObject {}
