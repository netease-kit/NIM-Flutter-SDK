// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/method_channel/method_channel_avsignalling_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class AvSignallingServicePlatform extends Service {
  AvSignallingServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static AvSignallingServicePlatform _instance =
      MethodChannelAvSignallingService();

  static AvSignallingServicePlatform get instance => _instance;

  Stream<ChannelCommonEvent> get onlineNotification;

  Stream<List<ChannelCommonEvent>> get offlineNotification;

  Stream<ChannelCommonEvent> get otherClientInviteAckNotification;

  Stream<List<SyncChannelEvent>> get syncChannelListNotification;

  Stream<SyncChannelEvent> get onMemberUpdateNotification;

  static set instance(AvSignallingServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<NIMResult<ChannelBaseInfo>> createChannel(
      {required ChannelType type,
      String? channelName,
      String? channelExt}) async {
    throw UnimplementedError('createChannel is not implemented');
  }

  Future<NIMResult<void>> closeChannel(
      {required String channelId,
      required bool offlineEnabled,
      String? customInfo}) async {
    throw UnimplementedError('closeChannel is not implemented');
  }

  Future<NIMResult<ChannelFullInfo>> joinChannel(
      {required String channelId,
      int? selfUid,
      String? customInfo,
      required bool offlineEnabled}) async {
    throw UnimplementedError('joinChannel is not implemented');
  }

  Future<NIMResult<void>> leaveChannel(
      {required String channelId,
      required bool offlineEnabled,
      String? customInfo}) async {
    throw UnimplementedError('leaveChannel is not implemented');
  }

  Future<NIMResult<void>> invite(InviteParam inviteParam) async {
    throw UnimplementedError('invite is not implemented');
  }

  Future<NIMResult<void>> cancelInvite(InviteParam inviteParam) async {
    throw UnimplementedError('cancelInvite is not implemented');
  }

  Future<NIMResult<void>> rejectInvite(InviteParam inviteParam) async {
    throw UnimplementedError('rejectInvite is not implemented');
  }

  Future<NIMResult<void>> acceptInvite(InviteParam inviteParam) async {
    throw UnimplementedError('acceptInvite is not implemented');
  }

  Future<NIMResult<void>> sendControl(
      {required String channelId,
      required String accountId,
      String? customInfo}) async {
    throw UnimplementedError('sendControl is not implemented');
  }

  Future<NIMResult<ChannelFullInfo>> call(CallParam callParam) async {
    throw UnimplementedError('call is not implemented');
  }

  Future<NIMResult<ChannelFullInfo>> queryChannelInfo(
      String channelName) async {
    throw UnimplementedError('queryChannelInfo is not implemented');
  }
}
