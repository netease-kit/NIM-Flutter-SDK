// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import '../../nim_core_v2_platform_interface.dart';

class MethodChannelAIService extends AIServicePlatform {
  // ignore: close_sinks
  final _proxyAIModelCallController =
      StreamController<NIMAIModelCallResult>.broadcast();

  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onProxyAIModelCall':
        assert(arguments is Map);
        _proxyAIModelCallController.add(NIMAIModelCallResult.fromJson(
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
}
