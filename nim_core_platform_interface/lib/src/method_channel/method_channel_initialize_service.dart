// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class MethodChannelInitializeService extends InitializeServicePlatform {
  NIMDisplayNameForMessageNotifierProvider?
      _displayNameForMessageNotifierProvider;
  NIMAvatarForMessageNotifierProvider? _avatarForMessageNotifierProvider;
  NIMDisplayTitleForMessageNotifierProvider?
      _displayTitleForMessageNotifierProvider;

  ///定制消息提醒（通知栏提醒）內容文案 主要在通知栏下拉后展现其通知内容：content=[nick:发来一条消息]
  NIMMakeNotifyContentProvider? _makeNotifyContentProvider;

  ///定制消息提醒（通知栏提醒）Ticker文案 主要在通知栏弹框提醒时的内容：ticker=[nick有新消息]
  NIMMakeTickerProvider? _makeTickerProvider;

  ///定制消息撤回提醒文案
  NIMMakeRevokeMsgTipProvider? _makeRevokeMsgTipProvider;

  @override
  Future<NIMResult<void>> initialize(NIMSDKOptions options,
      [Map<String, dynamic>? extras]) async {
    if (options is NIMAndroidSDKOptions) {
      this._displayNameForMessageNotifierProvider =
          options.displayNameForMessageNotifierProvider;
      this._avatarForMessageNotifierProvider =
          options.avatarForMessageNotifierProvider;
      this._displayTitleForMessageNotifierProvider =
          options.displayTitleForMessageNotifierProvider;
      this._makeNotifyContentProvider = options.makeNotifyContentProvider;
      this._makeTickerProvider = options.makeTickerProvider;
      this._makeRevokeMsgTipProvider = options.makeRevokeMsgTipProvider;
    }
    return NIMResult.fromMap(
      await invokeMethod(
        'initialize',
        arguments: options.toMap()..['extras'] = extras ?? {},
      ),
    );
  }

  @override
  Future<NIMResult<void>> releaseDesktop() async {
    return NIMResult.fromMap(
      await invokeMethod(
        'releaseDesktop',
      ),
    );
  }

  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onGetDisplayNameForMessageNotifier':
        return onGetDisplayNameForMessageNotifier(arguments);
      case 'onGetAvatarForMessageNotifier':
        return onGetAvatarForMessageNotifier(arguments);
      case 'onGetDisplayTitleForMessageNotifier':
        return onGetDisplayTitleForMessageNotifier(arguments);
      case 'onMakeNotifyContent':
        return onMakeNotifyContent(arguments);
      case 'onMakeTicker':
        return onMakeTicker(arguments);
      case 'onMakeRevokeMsgTip':
        return onMakeRevokeMsgTip(arguments);
      default:
        throw UnimplementedError('$method has not been implemented');
    }
  }

  ///定制消息提醒
  Future<String?> onMakeNotifyContent(arguments) async {
    if (_makeNotifyContentProvider == null) {
      return Future.value(null);
    }
    final nick = arguments['nick'] as String?;
    final messageMap = arguments['message'] as Map?;
    final message =
        messageMap != null ? NIMMessage.fromMap(messageMap.cast()) : null;
    final result = await _makeNotifyContentProvider!(nick, message);
    return result;
  }

  ///定制消息提醒Ticker文案
  Future<String?> onMakeTicker(arguments) async {
    if (_makeTickerProvider == null) {
      return Future.value(null);
    }
    final nick = arguments['nick'] as String?;
    final messageMap = arguments['message'] as Map?;
    final message =
        messageMap != null ? NIMMessage.fromMap(messageMap.cast()) : null;
    final result = await _makeTickerProvider!(nick, message);
    return result;
  }

  ///定制消息撤回提醒文案
  Future<String?> onMakeRevokeMsgTip(arguments) async {
    if (_makeRevokeMsgTipProvider == null) {
      return Future.value(null);
    }
    final revokeAccount = arguments['revokeAccount'] as String?;
    final messageMap = arguments['item'] as Map?;
    final message =
        messageMap != null ? NIMMessage.fromMap(messageMap.cast()) : null;
    final result = await _makeRevokeMsgTipProvider!(revokeAccount, message);
    return result;
  }

  Future<String?> onGetDisplayNameForMessageNotifier(arguments) async {
    if (_displayNameForMessageNotifierProvider == null) {
      return Future.value(null);
    }
    final account = arguments['account'] as String?;
    final sessionId = arguments['sessionId'] as String?;
    final sessionType = NIMSessionTypeConverter().fromValue(
        arguments['sessionType'] as String? ?? "",
        defaultType: NIMSessionType.p2p);
    final result = await _displayNameForMessageNotifierProvider!(
        account, sessionId, sessionType);
    return result;
  }

  Future<Map<String, dynamic>?> onGetAvatarForMessageNotifier(arguments) async {
    if (_avatarForMessageNotifierProvider == null) {
      return null;
    }
    final sessionType = NIMSessionTypeConverter().fromValue(
        arguments['sessionType'] as String? ?? "",
        defaultType: NIMSessionType.p2p);
    final sessionId = arguments['sessionId'] as String?;
    final result =
        await _avatarForMessageNotifierProvider!(sessionType, sessionId);
    if (result == null) {
      return null;
    }
    return <String, dynamic>{
      "type": result.type.name,
      "path": result.path,
      "inSampleSize": result.inSampleSize,
    };
  }

  Future<String?> onGetDisplayTitleForMessageNotifier(arguments) async {
    if (_displayTitleForMessageNotifierProvider == null) {
      return null;
    }
    final messageMap = arguments['message'] as Map?;
    final message =
        messageMap != null ? NIMMessage.fromMap(messageMap.cast()) : null;
    final result = await _displayTitleForMessageNotifierProvider!(message);
    return result;
  }

  @override
  String get serviceName => 'InitializeService';
}
