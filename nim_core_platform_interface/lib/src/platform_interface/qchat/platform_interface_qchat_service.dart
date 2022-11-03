// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/method_channel/method_channel_qchat_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class QChatServicePlatform extends Service {
  QChatServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static QChatServicePlatform _instance = MethodChannelQChatService();

  static QChatServicePlatform get instance => _instance;

  static set instance(QChatServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<NIMResult<QChatLoginResult>> login(QChatLoginParam param) async {
    throw UnimplementedError('login is not implemented');
  }

  Future<NIMResult<void>> logout() async {
    throw UnimplementedError('logout is not implemented');
  }

  Future<NIMResult<QChatKickOtherClientsResult>> kickOtherClients(
      QChatKickOtherClientsParam param) async {
    throw UnimplementedError('kickOtherClients is not implemented');
  }
}
