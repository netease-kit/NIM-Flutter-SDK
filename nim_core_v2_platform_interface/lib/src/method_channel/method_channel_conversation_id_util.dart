// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import '../../nim_core_v2_platform_interface.dart';

class MethodChannelConversationIdUtil extends ConversationIdUtilPlatform {
  @override
  Future onEvent(String method, arguments) {
    throw UnimplementedError();
  }

  @override
  String get serviceName => "ConversationIdUtil";

  // Future<NIMResult<String>> conversationId(
  //     String targetId, NIMConversationType conversationType) async {
  //   return NIMResult.fromMap(
  //     await invokeMethod(
  //       'conversationId',
  //       arguments: {
  //         'targetId': targetId,
  //         'conversationType': conversationType.index,
  //       },
  //     ),
  //   );
  // }

  Future<NIMResult<String>> p2pConversationId(String accountId) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'p2pConversationId',
        arguments: {'accountId': accountId},
      ),
    );
  }

  Future<NIMResult<String>> teamConversationId(String teamId) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'teamConversationId',
        arguments: {'teamId': teamId},
      ),
    );
  }

  Future<NIMResult<String>> superTeamConversationId(String superTeamId) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'superTeamConversationId',
        arguments: {'superTeamId': superTeamId},
      ),
    );
  }

  Future<NIMResult<NIMConversationType>> conversationType(
      String conversationId) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'conversationType',
          arguments: {'conversationId': conversationId},
        ), convert: (map) {
      var conversationType = map['conversationType']?.toInt();
      if (conversationType == null) {
        return null;
      } else {
        return NIMConversationTypeClass.fromEnumInt(conversationType);
      }
    });
  }

  Future<NIMResult<String>> conversationTargetId(String conversationId) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'conversationTargetId',
        arguments: {'conversationId': conversationId},
      ),
    );
  }

  // Future<NIMResult<bool>> isConversationIdValid(String conversationId) async {
  //   return NIMResult.fromMap(
  //     await invokeMethod(
  //       'isConversationIdValid',
  //       arguments: {'conversationId': conversationId},
  //     ),
  //   );
  // }

  // Future<NIMResult<NIMSessionType>> sessionTypeV1(
  //     NIMConversationType conversationType) async {
  //   return NIMResult.fromMap(
  //       await invokeMethod(
  //         'sessionTypeV1',
  //         arguments: {'conversationId': conversationId},
  //       ), convert: (map) {NIMSessionType.values[map['sessionType'] as int];
  //   });
  // }
}
