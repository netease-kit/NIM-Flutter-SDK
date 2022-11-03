// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class MethodChannelAvSignallingService extends AvSignallingServicePlatform {
  // ignore: close_sinks
  final _onlineNotificationStream =
      StreamController<ChannelCommonEvent>.broadcast();

  // ignore: close_sinks
  final _offlineNotificationStream =
      StreamController<List<ChannelCommonEvent>>.broadcast();

  // ignore: close_sinks
  final _otherClientInviteAckNotificationStream =
      StreamController<ChannelCommonEvent>.broadcast();

  // ignore: close_sinks
  final _syncChannelListNotificationStream =
      StreamController<List<SyncChannelEvent>>.broadcast();

  // ignore: close_sinks
  final _onMemberUpdateNotificationStream =
      StreamController<SyncChannelEvent>.broadcast();

  @override
  Stream<List<ChannelCommonEvent>> get offlineNotification =>
      _offlineNotificationStream.stream;

  @override
  Stream<SyncChannelEvent> get onMemberUpdateNotification =>
      _onMemberUpdateNotificationStream.stream;

  @override
  Stream<ChannelCommonEvent> get onlineNotification =>
      _onlineNotificationStream.stream;

  @override
  Stream<ChannelCommonEvent> get otherClientInviteAckNotification =>
      _otherClientInviteAckNotificationStream.stream;

  @override
  Stream<List<SyncChannelEvent>> get syncChannelListNotification =>
      _syncChannelListNotificationStream.stream;

  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onlineNotification':
        assert(arguments is Map);
        _onlineNotificationStream.add(ChannelCommonEvent.fromJson(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'offlineNotification':
        assert(arguments is Map);
        _offlineNotificationStream.add((arguments['eventList'] as List)
            .whereType<Map>()
            .map((e) =>
                ChannelCommonEvent.fromJson(Map<String, dynamic>.from(e)))
            .toList());
        break;
      case 'otherClientInviteAckNotification':
        assert(arguments is Map);
        _otherClientInviteAckNotificationStream.add(ChannelCommonEvent.fromJson(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'syncChannelListNotification':
        assert(arguments is Map);
        _syncChannelListNotificationStream.add((arguments['eventList'] as List)
            .whereType<Map>()
            .map((e) => SyncChannelEvent.fromJson(Map<String, dynamic>.from(e)))
            .toList());
        break;
      case 'onMemberUpdateNotification':
        assert(arguments is Map);
        _onMemberUpdateNotificationStream.add(
            SyncChannelEvent.fromJson(Map<String, dynamic>.from(arguments)));
        break;
      default:
        throw UnimplementedError();
    }
    return Future.value();
  }

  @override
  String get serviceName => 'AvSignallingService';

  @override
  Future<NIMResult<ChannelBaseInfo>> createChannel(
      {required ChannelType type,
      String? channelName,
      String? channelExt}) async {
    return NIMResult<ChannelBaseInfo>.fromMap(
        await invokeMethod('createChannel', arguments: {
          'type': type.name,
          'channelName': channelName,
          'channelExt': channelExt
        }),
        convert: (json) => ChannelBaseInfo.fromJson(json));
  }

  @override
  Future<NIMResult<void>> closeChannel(
      {required String channelId,
      required bool offlineEnabled,
      String? customInfo}) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('closeChannel', arguments: {
      'channelId': channelId,
      'offlineEnabled': offlineEnabled,
      'customInfo': customInfo
    }));
  }

  @override
  Future<NIMResult<ChannelFullInfo>> joinChannel(
      {required String channelId,
      int? selfUid,
      String? customInfo,
      required bool offlineEnabled}) async {
    return NIMResult<ChannelFullInfo>.fromMap(
        await invokeMethod('joinChannel', arguments: {
          'channelId': channelId,
          'selfUid': selfUid,
          'customInfo': customInfo,
          'offlineEnabled': offlineEnabled
        }),
        convert: (json) => ChannelFullInfo.fromJson(json));
  }

  @override
  Future<NIMResult<void>> leaveChannel(
      {required String channelId,
      required bool offlineEnabled,
      String? customInfo}) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('leaveChannel', arguments: {
      'channelId': channelId,
      'offlineEnabled': offlineEnabled,
      'customInfo': customInfo
    }));
  }

  @override
  Future<NIMResult<void>> invite(InviteParam inviteParam) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('invite', arguments: inviteParam.toJson()));
  }

  @override
  Future<NIMResult<void>> cancelInvite(InviteParam inviteParam) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('cancelInvite', arguments: inviteParam.toJson()));
  }

  @override
  Future<NIMResult<void>> rejectInvite(InviteParam inviteParam) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('rejectInvite', arguments: inviteParam.toJson()));
  }

  @override
  Future<NIMResult<void>> acceptInvite(InviteParam inviteParam) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('acceptInvite', arguments: inviteParam.toJson()));
  }

  @override
  Future<NIMResult<void>> sendControl(
      {required String channelId,
      required String accountId,
      String? customInfo}) async {
    return NIMResult<void>.fromMap(await invokeMethod('sendControl',
        arguments: {
          'channelId': channelId,
          'accountId': accountId,
          'customInfo': customInfo
        }));
  }

  @override
  Future<NIMResult<ChannelFullInfo>> call(CallParam callParam) async {
    return NIMResult<ChannelFullInfo>.fromMap(
        await invokeMethod('call', arguments: callParam.toJson()),
        convert: (json) => ChannelFullInfo.fromJson(json));
  }

  @override
  Future<NIMResult<ChannelFullInfo>> queryChannelInfo(
      String channelName) async {
    return NIMResult<ChannelFullInfo>.fromMap(
        await invokeMethod('queryChannelInfo',
            arguments: {'channelName': channelName}),
        convert: (json) => ChannelFullInfo.fromJson(json));
  }
}
