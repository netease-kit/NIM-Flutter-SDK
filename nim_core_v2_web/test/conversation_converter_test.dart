// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

@TestOn('browser')
library;

import 'dart:js_interop';

import 'package:flutter_test/flutter_test.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:nim_core_v2_web/src/converters/message_converter.dart';

void main() {
  test('preserves lastReadTime for the public conversation model', () {
    final jsConversation = <String, Object>{
      'conversationId': 'conversation-id',
      'type': 1,
      'mute': false,
      'stickTop': false,
      'createTime': 1,
      'updateTime': 2,
      'lastReadTime': 1723456789123,
    }.jsify() as JSObject;

    final map = formatV2ConversationLastMessage(jsConversation);
    final conversation = NIMConversation.fromJson(map);

    expect(conversation.lastReadTime, 1723456789123);
  });

  test('does not invent lastReadTime when the JS object omits it', () {
    final jsConversation = <String, Object>{
      'conversationId': 'conversation-id',
      'type': 1,
      'mute': false,
      'stickTop': false,
      'createTime': 1,
      'updateTime': 2,
    }.jsify() as JSObject;

    final map = formatV2ConversationLastMessage(jsConversation);

    expect(map.containsKey('lastReadTime'), isFalse);
  });
}
