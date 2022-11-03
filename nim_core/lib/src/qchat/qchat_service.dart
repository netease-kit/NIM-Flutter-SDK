// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core;

///圈组服务
///目前仅支持iOS和Android平台
class QChatService {
  factory QChatService() {
    if (_singleton == null) {
      _singleton = QChatService._();
    }
    return _singleton!;
  }

  QChatService._();

  static QChatService? _singleton;

  QChatServicePlatform _platform = QChatServicePlatform.instance;

  /// 登录接口
  ///
  /// 回调中返回成功登陆后的客户端基本信息，以及同时在线的其他端列表
  Future<NIMResult<QChatLoginResult>> login(QChatLoginParam param) {
    return _platform.login(param);
  }

  /// 登出接口
  Future<NIMResult<void>> logout() {
    return _platform.logout();
  }

  /// 踢掉多端同时在线的其他端
  ///
  /// 回调中返回被踢掉的客户端的deviceId列表
  Future<NIMResult<QChatKickOtherClientsResult>> kickOtherClients(
      QChatKickOtherClientsParam param) {
    return _platform.kickOtherClients(param);
  }
}
