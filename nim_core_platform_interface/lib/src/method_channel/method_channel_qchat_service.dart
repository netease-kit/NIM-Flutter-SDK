// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class MethodChannelQChatService extends QChatServicePlatform {
  @override
  String get serviceName => 'QChatService';

  @override
  Future onEvent(String method, arguments) {
    throw UnimplementedError();
  }

  @override
  Future<NIMResult<QChatLoginResult>> login(QChatLoginParam param) async {
    return NIMResult<QChatLoginResult>.fromMap(
        await invokeMethod('login', arguments: param.toJson()),
        convert: (json) => QChatLoginResult.fromJson(json));
  }

  @override
  Future<NIMResult<void>> logout() async {
    return NIMResult<void>.fromMap(await invokeMethod('logout', arguments: {}));
  }

  @override
  Future<NIMResult<QChatKickOtherClientsResult>> kickOtherClients(
      QChatKickOtherClientsParam param) async {
    return NIMResult<QChatKickOtherClientsResult>.fromMap(
        await invokeMethod('kickOtherClients', arguments: param.toJson()),
        convert: (json) => QChatKickOtherClientsResult.fromJson(json));
  }
}
