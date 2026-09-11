// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:nim_core_v2/nim_core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('canLaunch android || ios', () {
    test('interface ', () {
      final result = NimCore.instance.messageService;
      expect(result, null);
    });
  });

  group('NIMConversation lastReadTime', () {
    Map<String, dynamic> conversationJson() => <String, dynamic>{
          'conversationId': 'conversation-id',
          'type': 1,
          'mute': false,
          'stickTop': false,
          'createTime': 1,
          'updateTime': 2,
        };

    test('parses and serializes a value', () {
      final json = conversationJson()..['lastReadTime'] = 1723456789123;

      final conversation = NIMConversation.fromJson(json);

      expect(conversation.lastReadTime, 1723456789123);
      expect(conversation.toJson()['lastReadTime'], 1723456789123);
    });

    test('keeps an absent value nullable', () {
      final conversation = NIMConversation.fromJson(conversationJson());

      expect(conversation.lastReadTime, isNull);
    });

    test('keeps an explicit null value nullable', () {
      final json = conversationJson()..['lastReadTime'] = null;

      final conversation = NIMConversation.fromJson(json);

      expect(conversation.lastReadTime, isNull);
      expect(conversation.toJson()['lastReadTime'], isNull);
    });

    test('keeps existing constructor calls compatible', () {
      final conversation = NIMConversation(
        conversationId: 'conversation-id',
        type: NIMConversationType.p2p,
        mute: false,
        stickTop: false,
        createTime: 1,
        updateTime: 2,
      );

      expect(conversation.lastReadTime, isNull);
    });
  });
}
