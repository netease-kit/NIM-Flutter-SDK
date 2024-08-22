// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_v2_platform_interface/src/method_channel/method_channel_conversation_id_util.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../../nim_core_v2_platform_interface.dart';

abstract class ConversationIdUtilPlatform extends Service {
  ConversationIdUtilPlatform() : super(token: _token);

  static final Object _token = Object();

  static ConversationIdUtilPlatform _instance =
      MethodChannelConversationIdUtil();

  static ConversationIdUtilPlatform get instance => _instance;

  static set instance(ConversationIdUtilPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // Future<NIMResult<String>> conversationId(
  //     String targetId, NIMConversationType conversationType) async {
  //   throw UnimplementedError('conversationId() is not implemented');
  // }

  Future<NIMResult<String>> p2pConversationId(String accountId) async {
    throw UnimplementedError('p2pConversationId() is not implemented');
  }

  Future<NIMResult<String>> teamConversationId(String teamId) async {
    throw UnimplementedError('teamConversationId() is not implemented');
  }

  Future<NIMResult<String>> superTeamConversationId(String superTeamId) async {
    throw UnimplementedError('superTeamConversationId() is not implemented');
  }

  Future<NIMResult<NIMConversationType>> conversationType(
      String conversationId) async {
    throw UnimplementedError('conversationType() is not implemented');
  }

  Future<NIMResult<String>> conversationTargetId(String conversationId) async {
    throw UnimplementedError('conversationTargetId() is not implemented');
  }

  // Future<NIMResult<bool>> isConversationIdValid(String conversationId) async {
  //   throw UnimplementedError('isConversationIdValid() is not implemented');
  // }

  // Future<NIMResult<NIMSessionType>> sessionTypeV1(
  //     NIMConversationType conversationType) async {
  //   throw UnimplementedError('sessionTypeV1() is not implemented');
  // }
}
