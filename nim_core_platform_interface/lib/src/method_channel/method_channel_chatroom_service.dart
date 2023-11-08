// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class MethodChannelChatroomService extends ChatroomServicePlatform {
  // ignore: close_sinks
  final _eventStream = StreamController<NIMChatroomEvent>.broadcast();

  // ignore: close_sinks
  final _messageStream = StreamController<List<NIMChatroomMessage>>.broadcast();

  // ignore: close_sinks
  final _messageStatusStream = StreamController<NIMChatroomMessage>.broadcast();

  // ignore: close_sinks
  final _messageAttachmentProgressStream =
      StreamController<NIMAttachmentProgress>.broadcast();

  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onStatusChanged':
        assert(arguments is Map);
        _eventStream.add(NIMChatroomStatusEvent.fromMap(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onKickOut':
        assert(arguments is Map);
        _eventStream.add(NIMChatroomKickOutEvent.fromMap(
            Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onMessageReceived':
        assert(arguments is Map && arguments['messageList'] is List);
        _messageStream
            .add((arguments['messageList'] as List).whereType<Map>().map((e) {
          return NIMChatroomMessage.fromMap(Map<String, dynamic>.from(e));
        }).toList());
        break;
      case 'onMessageStatusChanged':
        assert(arguments is Map);
        _messageStatusStream.add(
            NIMChatroomMessage.fromMap(Map<String, dynamic>.from(arguments)));
        break;
      case 'onMessageAttachmentProgressUpdate':
        assert(arguments is Map);
        _messageAttachmentProgressStream.add(NIMAttachmentProgress.fromMap(
            Map<String, dynamic>.from(arguments)));
        break;
      case 'getIndependentModeLinkAddress':
        return onGetIndependentModeLinkAddress(arguments);
      case 'getChatRoomDynamicToken':
        return onGetChatRoomDynamicToken(arguments);
      default:
        throw UnimplementedError();
    }
    return Future.value();
  }

  @override
  String get serviceName => 'ChatroomService';

  @override
  Future<NIMResult<NIMChatroomEnterResult>> enterChatroom(
      NIMChatroomEnterRequest request) async {
    return NIMResult<NIMChatroomEnterResult>.fromMap(
      await invokeMethod('enterChatroom', arguments: request.toJson()),
      convert: (json) => NIMChatroomEnterResult.fromMap(json),
    );
  }

  @override
  Future<NIMResult<void>> exitChatroom(String roomId) async {
    return NIMResult<void>.fromMap(
      await invokeMethod(
        'exitChatroom',
        arguments: {'roomId': roomId},
      ),
    );
  }

  @override
  Stream<NIMChatroomEvent> get onEventNotified => _eventStream.stream;

  Stream<List<NIMChatroomMessage>> get onMessageReceived =>
      _messageStream.stream;

  Stream<NIMChatroomMessage> get onMessageStatusChanged =>
      _messageStatusStream.stream;

  Stream<NIMAttachmentProgress> get onMessageAttachmentProgressUpdate =>
      _messageAttachmentProgressStream.stream;

  @override
  Future<NIMResult<NIMChatroomMessage>> sendChatroomMessage(
      NIMChatroomMessage message,
      [bool resend = false]) async {
    return NIMResult<NIMChatroomMessage>.fromMap(
      await invokeMethod(
        'sendMessage',
        arguments: {
          'message': message.toMap(),
          'resend': resend,
        },
      ),
      convert: (map) => NIMChatroomMessage.fromMap(map),
    );
  }

  @override
  Future<NIMResult<NIMChatroomMessage>> createChatroomMessage(
      Map<String, dynamic> arguments) async {
    return NIMResult<NIMChatroomMessage>.fromMap(
      await invokeMethod(
        'createMessage',
        arguments: arguments,
      ),
      convert: (map) => NIMChatroomMessage.fromMap(map),
    );
  }

  @override
  Future<NIMResult<void>> downloadAttachment(NIMChatroomMessage message,
      [bool thumb = false]) async {
    return NIMResult<void>.fromMap(
      await invokeMethod(
        'downloadAttachment',
        arguments: {
          'message': message.toMap(),
          'thumb': thumb,
        },
      ),
    );
  }

  @override
  Future<NIMResult<List<NIMChatroomMessage>>> fetchMessageHistory({
    required String roomId,
    required int startTime,
    required int limit,
    required QueryDirection direction,
    List<NIMMessageType>? messageTypeList,
  }) async {
    final result = await invokeMethod('fetchMessageHistory', arguments: {
      'roomId': roomId,
      'startTime': startTime,
      'limit': limit,
      'direction': direction.index,
      'messageTypeList': messageTypeList
          ?.map((e) => NIMMessageTypeConverter(messageType: e).toValue())
          .toList(),
    });
    return NIMResult<List<NIMChatroomMessage>>.fromMap(result, convert: (map) {
      assert(map['messageList'] is List);
      return (map['messageList'] as List).whereType<Map>().map((e) {
        return NIMChatroomMessage.fromMap(Map<String, dynamic>.from(e));
      }).toList();
    });
  }

  @override
  Future<NIMResult<NIMChatroomInfo>> fetchChatroomInfo(String roomId) async {
    return NIMResult<NIMChatroomInfo>.fromMap(
      await invokeMethod(
        'fetchChatroomInfo',
        arguments: {
          'roomId': roomId,
        },
      ),
      convert: (map) => NIMChatroomInfo.fromMap(map),
    );
  }

  Future<NIMResult<void>> updateChatroomInfo({
    required String roomId,
    required NIMChatroomUpdateRequest request,
    bool needNotify = true,
    Map<String, dynamic>? notifyExtension,
  }) async {
    return NIMResult<void>.fromMap(
      await invokeMethod(
        'updateChatroomInfo',
        arguments: {
          'roomId': roomId,
          'request': request.toMap(),
          'needNotify': needNotify,
          'notifyExtension': notifyExtension
        },
      ),
    );
  }

  @override
  Future<NIMResult<List<NIMChatroomMember>>> fetchChatroomMembers({
    required String roomId,
    required NIMChatroomMemberQueryType queryType,
    required int limit,
    String? lastMemberAccount,
  }) async {
    final result = await invokeMethod('fetchChatroomMembers', arguments: {
      'roomId': roomId,
      'queryType': queryType.index,
      'limit': limit,
      'lastMemberAccount': lastMemberAccount,
    });
    return NIMResult<List<NIMChatroomMember>>.fromMap(result, convert: (map) {
      // assert(map['memberList'] is List);
      return (map['memberList'] as List?)?.whereType<Map>().map((e) {
        return NIMChatroomMember.fromMap(Map<String, dynamic>.from(e));
      }).toList();
    });
  }

  Future<NIMResult<List<NIMChatroomMember>>> fetchChatroomMembersByAccount({
    required String roomId,
    required List<String> accountList,
  }) async {
    final result =
        await invokeMethod('fetchChatroomMembersByAccount', arguments: {
      'roomId': roomId,
      'accountList': accountList,
    });
    return NIMResult<List<NIMChatroomMember>>.fromMap(result, convert: (map) {
      // assert(map['memberList'] is List);
      return (map['memberList'] as List?)?.whereType<Map>().map((e) {
        return NIMChatroomMember.fromMap(Map<String, dynamic>.from(e));
      }).toList();
    });
  }

  Future<NIMResult<void>> updateChatroomMyMemberInfo({
    required String roomId,
    required NIMChatroomUpdateMyMemberInfoRequest request,
    bool needNotify = true,
    Map<String, dynamic>? notifyExtension,
  }) async {
    return NIMResult<NIMChatroomInfo>.fromMap(
      await invokeMethod(
        'updateChatroomMyMemberInfo',
        arguments: {
          'roomId': roomId,
          'request': request.toMap(),
          'needNotify': needNotify,
          'notifyExtension': notifyExtension
        },
      ),
    );
  }

  @override
  Future<NIMResult<void>> kickChatroomMember(
      NIMChatroomMemberOptions options) async {
    return NIMResult<void>.fromMap(
      await invokeMethod(
        'kickChatroomMember',
        arguments: options.toMap(),
      ),
    );
  }

  @override
  Future<NIMResult<NIMChatroomMember>> markChatroomMemberBeManager({
    required bool isAdd,
    required NIMChatroomMemberOptions options,
  }) async {
    return NIMResult<NIMChatroomMember>.fromMap(
      await invokeMethod(
        'markChatroomMemberBeManager',
        arguments: {
          'isAdd': isAdd,
          'options': options.toMap(),
        },
      ),
      convert: (map) =>
          NIMChatroomMember.fromMap(Map<String, dynamic>.from(map)),
    );
  }

  @override
  Future<NIMResult<NIMChatroomMember>> markChatroomMemberBeNormal({
    required bool isAdd,
    required NIMChatroomMemberOptions options,
  }) async {
    return NIMResult<NIMChatroomMember>.fromMap(
      await invokeMethod(
        'markChatroomMemberBeNormal',
        arguments: {
          'isAdd': isAdd,
          'options': options.toMap(),
        },
      ),
      convert: (map) =>
          NIMChatroomMember.fromMap(Map<String, dynamic>.from(map)),
    );
  }

  @override
  Future<NIMResult<NIMChatroomMember>> markChatroomMemberInBlackList({
    required bool isAdd,
    required NIMChatroomMemberOptions options,
  }) async {
    return NIMResult<NIMChatroomMember>.fromMap(
      await invokeMethod(
        'markChatroomMemberInBlackList',
        arguments: {
          'isAdd': isAdd,
          'options': options.toMap(),
        },
      ),
      convert: (map) =>
          NIMChatroomMember.fromMap(Map<String, dynamic>.from(map)),
    );
  }

  @override
  Future<NIMResult<NIMChatroomMember>> markChatroomMemberMuted({
    required bool isAdd,
    required NIMChatroomMemberOptions options,
  }) async {
    return NIMResult<NIMChatroomMember>.fromMap(
      await invokeMethod(
        'markChatroomMemberMuted',
        arguments: {
          'isAdd': isAdd,
          'options': options.toMap(),
        },
      ),
      convert: (map) =>
          NIMChatroomMember.fromMap(Map<String, dynamic>.from(map)),
    );
  }

  @override
  Future<NIMResult<void>> markChatroomMemberTempMuted({
    required int duration,
    required NIMChatroomMemberOptions options,
    bool needNotify = false,
  }) async {
    return NIMResult<NIMChatroomMember>.fromMap(
      await invokeMethod(
        'markChatroomMemberTempMuted',
        arguments: {
          'duration': duration,
          'options': options.toMap(),
          'needNotify': needNotify,
        },
      ),
    );
  }

  @override
  Future<NIMResult<List<String>>> batchUpdateChatroomQueue({
    required String roomId,
    required List<NIMChatroomQueueEntry> entryList,
    bool needNotify = true,
    Map<String, dynamic>? notifyExtension,
  }) async {
    return NIMResult<List<String>>.fromMap(
      await invokeMethod(
        'batchUpdateChatroomQueue',
        arguments: {
          'roomId': roomId,
          'needNotify': needNotify,
          'notifyExtension': notifyExtension,
          'entryList': entryList.map((e) => e.toMap()).toList(),
        },
      ),
      convert: (map) =>
          (map['missingKeys'] as List).map((e) => e.toString()).toList(),
    );
  }

  @override
  Future<NIMResult<void>> clearChatroomQueue(String roomId) async {
    return NIMResult<void>.fromMap(
      await invokeMethod(
        'clearChatroomQueue',
        arguments: {
          'roomId': roomId,
        },
      ),
    );
  }

  @override
  Future<NIMResult<List<NIMChatroomQueueEntry>>> fetchChatroomQueue(
      String roomId) async {
    return NIMResult<List<NIMChatroomQueueEntry>>.fromMap(
      await invokeMethod(
        'fetchChatroomQueue',
        arguments: {
          'roomId': roomId,
        },
      ),
      convert: (map) {
        return (map['entryList'] as List?)
            ?.map((e) => NIMChatroomQueueEntry.fromMap(
                Map<String, dynamic>.from(e as Map)))
            .toList();
      },
    );
  }

  @override
  Future<NIMResult<NIMChatroomQueueEntry>> pollChatroomQueueEntry(
      String roomId, String? key) async {
    return NIMResult<NIMChatroomQueueEntry>.fromMap(
        await invokeMethod(
          'pollChatroomQueueEntry',
          arguments: {
            'roomId': roomId,
            'key': key,
          },
        ),
        convert: (map) =>
            NIMChatroomQueueEntry.fromMap(Map<String, dynamic>.from(map)));
  }

  @override
  Future<NIMResult<void>> updateChatroomQueueEntry({
    required String roomId,
    required NIMChatroomQueueEntry entry,
    bool isTransient = false,
  }) async {
    return NIMResult<void>.fromMap(
      await invokeMethod(
        'updateChatroomQueueEntry',
        arguments: {
          'roomId': roomId,
          'entry': entry.toMap(),
          'isTransient': isTransient,
        },
      ),
    );
  }

  Future<List<String>?> onGetIndependentModeLinkAddress(arguments) async {
    assert(arguments is Map);
    final linkAddressProvider = independentModeLinkAddressProvider;
    final roomId = arguments['roomId'] as String;
    final account = arguments['account'] as String?;
    assert(linkAddressProvider != null);
    if (linkAddressProvider == null) return null;
    return await linkAddressProvider(roomId, account);
  }

  Future<String?> onGetChatRoomDynamicToken(arguments) async {
    assert(arguments is Map);
    final tokenProvider = dynamicChatroomTokenProvider;
    final account = arguments['account'] as String?;
    final roomId = arguments['roomId'] as String?;
    assert(dynamicChatroomTokenProvider != null);
    assert(account != null);
    assert(roomId != null);
    if (tokenProvider == null || account == null || roomId == null) return null;
    return await tokenProvider(account, roomId);
  }
}
