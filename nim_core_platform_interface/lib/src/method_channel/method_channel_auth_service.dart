// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/src/platform_interface/auth/auth_models.dart';
import 'package:nim_core_platform_interface/src/platform_interface/auth/platform_interface_auth_service.dart';
import 'package:nim_core_platform_interface/src/platform_interface/nim_base.dart';

class MethodChannelAuthService extends AuthServicePlatform {
  // ignore: close_sinks
  final _authStatusController =
      StreamController<NIMAuthStatusEvent>.broadcast();

  final _onlineClientsController =
      StreamController<List<NIMOnlineClient>>.broadcast();

  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onAuthStatusChanged':
        return onAuthStatusChanged(arguments);
      case 'onOnlineClientsUpdated':
        return onOnlineClientsUpdated(arguments);
      case 'getDynamicToken':
        return onGetDynamicToken(arguments);
      default:
        throw UnimplementedError();
    }
  }

  @override
  String get serviceName => 'AuthService';

  @override
  Future<NIMResult<void>> login(NIMLoginInfo loginInfo) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'login',
        arguments: loginInfo.toMap(),
      ),
    );
  }

  @override
  Future<NIMResult<void>> logout() async {
    return NIMResult.fromMap(
      await invokeMethod(
        'logout',
      ),
    );
  }

  @override
  Stream<NIMAuthStatusEvent> get authStatus => _authStatusController.stream;

  @override
  Stream<List<NIMOnlineClient>> get onlineClients =>
      _onlineClientsController.stream;

  @override
  Future<NIMResult<void>> kickOutOtherOnlineClient(
      NIMOnlineClient client) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'kickOutOtherOnlineClient',
        arguments: client.toMap(),
      ),
    );
  }

  Future onAuthStatusChanged(arguments) {
    assert(arguments is Map);
    assert(arguments['status'] is String);
    final status = NIMAuthStatus.values.firstWhere(
        (element) =>
            element.name.toLowerCase() ==
            (arguments['status'] as String).toLowerCase(),
        orElse: () => NIMAuthStatus.unknown);
    if (status != NIMAuthStatus.unknown) {
      final event;
      if (status == NIMAuthStatus.kickOutByOtherClient) {
        event = NIMKickOutByOtherClientEvent(
          status,
          arguments['clientType'] as int?,
          arguments['customClientType'] as int?,
        );
      } else if (status == NIMAuthStatus.dataSyncStart ||
          status == NIMAuthStatus.dataSyncFinish) {
        event = NIMDataSyncStatusEvent(status);
      } else {
        event = NIMAuthStatusEvent(status);
      }
      _authStatusController.add(event);
    }
    return Future.value();
  }

  Future onOnlineClientsUpdated(arguments) {
    assert(arguments is Map);
    if (arguments['clients'] is List) {
      _onlineClientsController.add((arguments['clients'] as List).map((e) {
        assert(e is Map);
        return NIMOnlineClient.fromMap(Map<String, dynamic>.from(e));
      }).toList(growable: false));
    } else {
      _onlineClientsController.add([]);
    }
    return Future.value();
  }

  Future<String?> onGetDynamicToken(arguments) async {
    assert(arguments is Map);
    final tokenProvider = dynamicTokenProvider;
    final account = arguments['account'] as String?;
    assert(dynamicTokenProvider != null);
    assert(account != null);
    if (tokenProvider == null || account == null) return null;
    return await tokenProvider(account);
  }
}
