// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// 会话服务

part of nim_core_v2;

@HawkEntryPoint()
class ConversationIdUtil {
// 消息服务
  factory ConversationIdUtil() {
    if (_singleton == null) {
      _singleton = ConversationIdUtil._();
    }
    return _singleton!;
  }

  ConversationIdUtil._();

  static ConversationIdUtil? _singleton;

  ConversationIdUtilPlatform get _platform =>
      ConversationIdUtilPlatform.instance;

  // Future<NIMResult<String>> conversationId(
  //     String targetId, NIMConversationType conversationType) async {
  //   return _platform.conversationId(targetId, conversationType);
  // }

  Future<NIMResult<String>> p2pConversationId(String accountId) async {
    return _platform.p2pConversationId(accountId);
  }

  Future<NIMResult<String>> teamConversationId(String teamId) async {
    return _platform.teamConversationId(teamId);
  }

  Future<NIMResult<String>> superTeamConversationId(String superTeamId) async {
    return _platform.superTeamConversationId(superTeamId);
  }

  Future<NIMResult<NIMConversationType>> conversationType(
      String conversationId) async {
    return _platform.conversationType(conversationId);
  }

  Future<NIMResult<String>> conversationTargetId(String conversationId) async {
    return _platform.conversationTargetId(conversationId);
  }

  // Future<NIMResult<bool>> isConversationIdValid(String conversationId) async {
  //   return _platform.isConversationIdValid(conversationId);
  // }

  // Future<NIMResult<NIMSessionType>> sessionTypeV1(
  //     NIMConversationType conversationType) async {
  //   return _platform.sessionTypeV1(conversationType);
  // }
}
