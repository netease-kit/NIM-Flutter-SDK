// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import '../../nim_core_v2_platform_interface.dart';

class MethodChannelAIService extends AIServicePlatform {
  // ignore: close_sinks
  final _proxyAIModelCallController =
      StreamController<NIMAIModelCallResult>.broadcast();

  // ignore: close_sinks
  final _onProxyAIModelStreamCallController =
      StreamController<NIMAIModelStreamCallResult>.broadcast();

  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onProxyAIModelCall':
        assert(arguments is Map);
        _proxyAIModelCallController.add(NIMAIModelCallResult.fromJson(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onProxyAIModelStreamCall':
        assert(arguments is Map);
        _onProxyAIModelStreamCallController.add(
            NIMAIModelStreamCallResult.fromJson(
                Map<String, dynamic>.from(arguments as Map)));
        break;
      default:
        throw UnimplementedError();
    }
    return Future.value();
  }

  @override
  String get serviceName => 'AIService';

  @override
  Future<NIMResult<List<NIMAIUser>>> getAIUserList() async {
    return NIMResult.fromMap(
      await invokeMethod(
        'getAIUserList',
      ),
      convert: (map) {
        return (map['userList'] as List?)
            ?.map((e) => NIMAIUser.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
      },
    );
  }

  @override
  Stream<NIMAIModelCallResult> get onProxyAIModelCall =>
      _proxyAIModelCallController.stream;

  @override
  Future<NIMResult<void>> proxyAIModelCall(
      NIMProxyAIModelCallParams params) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'proxyAIModelCall',
        arguments: {
          'params': params.toJson(),
        },
      ),
    );
  }

  @override
  Future<NIMResult<void>> stopAIModelStreamCall(
      NIMAIModelStreamCallStopParams params) async {
    return NIMResult.fromMap(
        await invokeMethod('stopAIModelStreamCall', arguments: {
      'params': params.toJson(),
    }));
  }

  @override
  Stream<NIMAIModelStreamCallResult> get onProxyAIModelStreamCall =>
      _onProxyAIModelStreamCallController.stream;

  @override
  Future<NIMResult<V2NIMCreateUserAIBotResult>> createUserAIBot(
      V2NIMCreateUserAIBotParams params) async {
    return NIMResult<V2NIMCreateUserAIBotResult>.fromMap(
      await invokeMethod(
        'createUserAIBot',
        arguments: {'params': params.toJson()},
      ),
      convert: (json) => V2NIMCreateUserAIBotResult.fromJson(json),
    );
  }

  @override
  Future<NIMResult<void>> deleteUserAIBot(
      V2NIMDeleteUserAIBotParams params) async {
    return NIMResult<void>.fromMap(
      await invokeMethod(
        'deleteUserAIBot',
        arguments: {'params': params.toJson()},
      ),
    );
  }

  @override
  Future<NIMResult<void>> updateUserAIBot(
      V2NIMUpdateUserAIBotParams params) async {
    return NIMResult<void>.fromMap(
      await invokeMethod(
        'updateUserAIBot',
        arguments: {'params': params.toJson()},
      ),
    );
  }

  @override
  Future<NIMResult<V2NIMUserAIBot>> getUserAIBot(
      V2NIMGetUserAIBotParams params) async {
    return NIMResult<V2NIMUserAIBot>.fromMap(
      await invokeMethod(
        'getUserAIBot',
        arguments: {'params': params.toJson()},
      ),
      convert: (json) => V2NIMUserAIBot.fromJson(json),
    );
  }

  @override
  Future<NIMResult<V2NIMGetUserAIBotListResult>> getUserAIBotList(
      V2NIMGetUserAIBotListParams? params) async {
    return NIMResult<V2NIMGetUserAIBotListResult>.fromMap(
      await invokeMethod(
        'getUserAIBotList',
        arguments: {'params': params?.toJson()},
      ),
      convert: (json) => V2NIMGetUserAIBotListResult.fromJson(json),
    );
  }

  @override
  Future<NIMResult<void>> bindUserAIBotToQrCode(
      V2NIMBindUserAIBotToQrCodeParams params) async {
    return NIMResult<void>.fromMap(
      await invokeMethod(
        'bindUserAIBotToQrCode',
        arguments: {'params': params.toJson()},
      ),
    );
  }

  @override
  Future<NIMResult<V2NIMRefreshUserAIBotTokenResult>> refreshUserAIBotToken(
      V2NIMRefreshUserAIBotTokenParams params) async {
    return NIMResult<V2NIMRefreshUserAIBotTokenResult>.fromMap(
      await invokeMethod(
        'refreshUserAIBotToken',
        arguments: {'params': params.toJson()},
      ),
      convert: (json) => V2NIMRefreshUserAIBotTokenResult.fromJson(json),
    );
  }
}
