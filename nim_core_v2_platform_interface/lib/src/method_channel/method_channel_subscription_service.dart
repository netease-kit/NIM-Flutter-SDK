// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import '../../nim_core_v2_platform_interface.dart';

class MethodChannelSubscriptionService extends SubscriptionServicePlatform {
  final _userStatusChangedController =
      StreamController<List<NIMUserStatus>>.broadcast();

  @override
  Future onEvent(String method, arguments) {
    assert(arguments is Map);
    switch (method) {
      case 'onUserStatusChanged':
        var userStatusList = arguments['userStatusList'] as List<dynamic>;
        var result = userStatusList
            .map((e) => NIMUserStatus.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        _userStatusChangedController.add(result);
        break;
      default:
        throw UnimplementedError();
    }
    return Future.value();
  }

  @override
  get onUserStatusChanged => _userStatusChangedController.stream;

  @override
  String get serviceName => "SubscriptionService";

  ///订阅指定账号的在线状态事件
  Future<NIMResult<List<String>>> subscribeUserStatus(
      NIMSubscribeUserStatusOption option) async {
    // 检查参数
    if (option.accountIds.length <= 0 || option.accountIds.length > 100) {
      return NIMResult(NIMClientCode.paramError, null,
          'accountIds length must be greater than 0 and less than 100');
    }
    if (option.duration != null &&
        (option.duration! < 60 || option.duration! > 30 * 24 * 60 * 60)) {
      return NIMResult(NIMClientCode.paramError, null,
          'duration must be greater than 60s and less than 30 days');
    }
    return NIMResult.fromMap(
        await invokeMethod('subscribeUserStatus',
            arguments: {'option': option.toJson()}),
        convert: (json) => (List<String>.from(json['accountIds'])));
  }

  ///取消指定事件的全部订阅关系,只需填写事件类型
  Future<NIMResult<List<String>>> unsubscribeUserStatus(
      NIMUnsubscribeUserStatusOption option) async {
    return NIMResult.fromMap(
        await invokeMethod('unsubscribeUserStatus',
            arguments: {'option': option.toJson()}),
        convert: (json) => (List<String>.from(json['accountIds'])));
  }

  ///取消订阅指定账号的在线状态事件,只需填写事件类型和事件发布者账号集合
  Future<NIMResult<NIMCustomUserStatusPublishResult>> publishCustomUserStatus(
      NIMCustomUserStatusParams params) async {
    // 检查参数
    if (params.statusType != null && (params.statusType! < 10000)) {
      return NIMResult(NIMClientCode.paramError, null,
          'statusType must be greater than or equal to 10000');
    }
    if (params.duration != null &&
        (params.duration! < 60 || params.duration! > 7 * 24 * 60 * 60)) {
      return NIMResult(NIMClientCode.paramError, null,
          'duration must be greater than 60s and less than 7 days');
    }
    return NIMResult.fromMap(
        await invokeMethod('publishCustomUserStatus',
            arguments: {'params': params.toJson()}),
        convert: (json) => (NIMCustomUserStatusPublishResult.fromJson(
            Map<String, dynamic>.from(json))));
  }

  ///查询事件订阅，用于查询某种事件的订阅关系
  Future<NIMResult<List<NIMUserStatusSubscribeResult>>>
      queryUserStatusSubscriptions(List<String> accountIds) async {
    return NIMResult.fromMap(
        await invokeMethod('queryUserStatusSubscriptions',
            arguments: {'accountIds': accountIds}),
        convert: (json) => (json['subscribeResultList'] as List<dynamic>?)
            ?.map((e) => NIMUserStatusSubscribeResult.fromJson(
                (e as Map).cast<String, dynamic>()))
            .toList());
  }
}
