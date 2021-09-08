// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/src/platform_interface/message/message.dart';
import 'package:nim_core_platform_interface/src/platform_interface/message/message_keyword_search_config.dart';
import 'package:nim_core_platform_interface/src/platform_interface/message/message_search_option.dart';
import 'package:nim_core_platform_interface/src/platform_interface/message/platform_interface_message_service.dart';
import 'package:nim_core_platform_interface/src/platform_interface/message/query_direction_enum.dart';
import 'package:nim_core_platform_interface/src/platform_interface/message/thread_talk_history.dart';
import 'package:nim_core_platform_interface/src/platform_interface/nim_base.dart';
import 'package:nim_core_platform_interface/src/utils/converter.dart';

class MethodChannelMessageService extends MessageServicePlatform {
  @override
  Future<NIMResult<NIMMessage>> sendMessage(
      {required NIMMessage message, bool resend = false}) async {
    Map<String, dynamic> arguments = message.toMap();
    Map<String, dynamic> replyMap = await invokeMethod('sendMessage',
        arguments: arguments..['resend'] = resend);
    return NIMResult.fromMap(replyMap,
        convert: (map) => NIMMessage.fromMap(map));
  }

  @override
  Future<NIMResult<void>> sendMessageReceipt(
      {required String sessionId, required NIMMessage message}) async {
    Map<String, dynamic> arguments = message.toMap();
    Map<String, dynamic> replyMap = await invokeMethod('sendMessageReceipt',
        arguments: arguments..['sessionId'] = sessionId);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<void>> sendTeamMessageReceipt(NIMMessage message) async {
    Map<String, dynamic> arguments = message.toMap();
    Map<String, dynamic> replyMap =
        await invokeMethod('sendTeamMessageReceipt', arguments: arguments);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<NIMMessage>> saveMessage(
      {required NIMMessage message, required String fromAccount}) async {
    Map<String, dynamic> arguments = message.toMap();
    Map<String, dynamic> replyMap = await invokeMethod('saveMessage',
        arguments: arguments..['fromAccount'] = fromAccount);
    return NIMResult.fromMap(replyMap,
        convert: (map) => NIMMessage.fromMap(map));
  }

  @override
  Future<NIMResult<NIMMessage>> createMessage(
      {required NIMMessage message}) async {
    Map<String, dynamic> replyMap =
        await invokeMethod('createMessage', arguments: message.toMap());
    print("createMessage reply json : " + replyMap.toString());
    return NIMResult.fromMap(replyMap,
        convert: (map) => NIMMessage.fromMap(map));
  }

  @override
  Future<NIMResult<void>> downloadAttachment(
      {required NIMMessage message, required bool thumb}) async {
    Map<String, dynamic> arguments = message.toMap();
    Map<String, dynamic> replyMap = await invokeMethod('downloadAttachment',
        arguments: arguments..['thumb'] = thumb);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<void>> cancelUploadAttachment(NIMMessage message) async {
    Map<String, dynamic> arguments = message.toMap();
    Map<String, dynamic> replyMap =
        await invokeMethod('cancelUploadAttachment', arguments: arguments);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<void>> revokeMessage(
      {required NIMMessage message,
      String? customApnsText,
      Map<String, Object>? pushPayload,
      bool? shouldNotifyBeCount,
      String? postscript,
      String? attach}) async {
    Map<String, dynamic> arguments = message.toMap();
    Map<String, dynamic> replyMap = await invokeMethod('revokeMessage',
        arguments: arguments
          ..['customApnsText'] = customApnsText
          ..['pushPayload'] = pushPayload
          ..['shouldNotifyBeCount'] = shouldNotifyBeCount
          ..['postscript'] = postscript
          ..['attach'] = attach);
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<void>> updateMessage(NIMMessage message) async {
    Map<String, dynamic> arguments = message.toMap();
    Map<String, dynamic> replyMap =
        await invokeMethod('updateMessage', arguments: arguments);
    return NIMResult.fromMap(replyMap);
  }

  Future<NIMResult<void>> refreshTeamMessageReceipt(
      List<NIMMessage> messageList) async {
    Map<String, dynamic> arguments = Map();
    arguments["messageList"] = messageList.map((e) => e.toMap()).toList();
    Map<String, dynamic> replyMap =
        await invokeMethod('refreshTeamMessageReceipt', arguments: arguments);
    return NIMResult.fromMap(replyMap);
  }

  Future<NIMResult<NIMTeamMessageAckInfo>> fetchTeamMessageReceiptDetail(
      {required NIMMessage message, List<String>? accountList}) async {
    Map<String, dynamic> arguments = message.toMap();
    arguments["accountList"] = accountList?.map((e) => e.toString()).toList();
    Map<String, dynamic> replyMap = await invokeMethod(
        'fetchTeamMessageReceiptDetail',
        arguments: arguments);
    print("fetchTeamMessageReceiptDetail reply json : " + replyMap.toString());
    return NIMResult.fromMap(replyMap,
        convert: (map) => NIMTeamMessageAckInfo.fromMap(map));
  }

  Future<NIMResult<NIMTeamMessageAckInfo>> queryTeamMessageReceiptDetail(
      {required NIMMessage message, List<String>? accountList}) async {
    Map<String, dynamic> arguments = message.toMap();
    arguments["accountList"] = accountList?.map((e) => e.toString()).toList();
    Map<String, dynamic> replyMap = await invokeMethod(
        'queryTeamMessageReceiptDetail',
        arguments: arguments);
    print("queryTeamMessageReceiptDetail reply json : " + replyMap.toString());
    return NIMResult.fromMap(replyMap,
        convert: (map) => NIMTeamMessageAckInfo.fromMap(map));
  }

  @override
  Future<NIMResult<void>> forwardMessage(
      NIMMessage message, String sessionId, NIMSessionType sessionType) async {
    Map<String, dynamic> arguments = message.toMap();
    Map<String, dynamic> replyMap = await invokeMethod('forwardMessage',
        arguments: arguments
          ..['sessionId'] = sessionId
          ..["sessionType"] =
              NIMSessionTypeConverter(sessionType: sessionType).toValue());
    return NIMResult.fromMap(replyMap);
  }

  @override
  Future<NIMResult<String>> voiceToText(
      {required NIMMessage message, String? scene}) async {
    Map<String, dynamic> arguments = message.toMap();
    Map<String, dynamic> replyMap = await invokeMethod('voiceToText',
        arguments: arguments..['scene'] = scene);
    return NIMResult.fromMap(replyMap);
  }

  @override
  String get serviceName => 'MessageService';

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) {
    assert(() {
      print(
          'MethodChannelMessageService onEvent method = $method arguments = ${arguments.toString()}');
      return true;
    }());
    switch (method) {
      case 'onMessage':
        var messageList = arguments['messageList'] as List<dynamic>?;
        List<NIMMessage>? list = messageList
            ?.map((e) => NIMMessage.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null) MessageServicePlatform.instance.onMessage.add(list);
        break;
      case 'onMessageStatus':
        var message = NIMMessage.fromMap(Map<String, dynamic>.from(arguments));
        MessageServicePlatform.instance.onMessageStatus.add(message);
        break;
      case 'onMessageReceipt':
        var messageReceiptList = arguments['messageReceiptList'] as List<dynamic>?;
        List<NIMMessageReceipt>? list = messageReceiptList
            ?.map((e) => NIMMessageReceipt.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null) MessageServicePlatform.instance.onMessageReceipt.add(list);
        break;
      case 'onTeamMessageReceipt':
        var receipt =
            NIMTeamMessageReceipt.fromMap(Map<String, dynamic>.from(arguments));
        MessageServicePlatform.instance.onTeamMessageReceipt.add(receipt);
        break;
      case 'onMessageRevoked':
        var revokeMessage =
            NIMRevokeMessage.fromMap(Map<String, dynamic>.from(arguments));
        MessageServicePlatform.instance.onMessageRevoked.add(revokeMessage);
        break;
      case 'onAttachmentProgress':
        var attachmentProgress =
            NIMAttachmentProgress.fromMap(Map<String, dynamic>.from(arguments));
        MessageServicePlatform.instance.onAttachmentProgress
            .add(attachmentProgress);
        break;
      case 'onBroadcastMessage':
        var broadcastMessage =
            NIMBroadcastMessage.fromMap(Map<String, dynamic>.from(arguments));
        MessageServicePlatform.instance.onBroadcastMessage
            .add(broadcastMessage);
        break;
      case 'onSessionUpdate':
        final data = arguments["data"] as List?;
        if (data != null) {
          final list = data.whereType<Map>().map((e) {
            return NIMSession.fromMap(Map<String, dynamic>.from(e));
          }).toList();
          MessageServicePlatform.instance.onSessionUpdate.add(list);
        }
        break;
      case 'onSessionDelete':
        final session =
            NIMSession.fromMap(Map<String, dynamic>.from(arguments));
        MessageServicePlatform.instance.onSessionDelete.add(session);
        break;
      default:
        throw UnimplementedError('$method has not been implemented');
    }
    return Future.value(null);
  }

  @override
  Future<NIMResult<List<NIMMessage>>> queryMessageList(
      String account, NIMSessionType sessionType, int limit) async {
    Map<String, dynamic> arguments = Map();
    arguments["account"] = account;
    arguments["sessionType"] =
        NIMSessionTypeConverter(sessionType: sessionType).toValue();
    arguments["limit"] = limit;
    Map<String, dynamic> replyMap =
        await invokeMethod('queryMessageList', arguments: arguments);
    return notifyMessageListResult(replyMap);
  }

  @override
  Future<NIMResult<List<NIMMessage>>> queryMessageListEx(
      NIMMessage anchor, QueryDirection direction, int limit) async {
    Map<String, dynamic> arguments = Map();
    arguments["message"] = anchor.toMap();
    arguments["direction"] = direction.index;
    arguments["limit"] = limit;
    Map<String, dynamic> replyMap =
        await invokeMethod('queryMessageListEx', arguments: arguments);
    return notifyMessageListResult(replyMap);
  }

  //查询最近一条消息
  @override
  Future<NIMResult<NIMMessage>> queryLastMessage(
      String account, NIMSessionType sessionType) async {
    Map<String, dynamic> arguments = Map();
    arguments["account"] = account;
    arguments["sessionType"] =
        NIMSessionTypeConverter(sessionType: sessionType).toValue();
    Map<String, dynamic> replyMap =
        await invokeMethod('queryLastMessage', arguments: arguments);
    return NIMResult.fromMap(replyMap,
        convert: (map) => NIMMessage.fromMap(map));
  }

  //按消息uuid查询
  @override
  Future<NIMResult<List<NIMMessage>>> queryMessageListByUuid(
      List<String> uuid, String sessionId, NIMSessionType sessionType) async {
    Map<String, dynamic> arguments = Map();
    arguments["uuidList"] = uuid.map((e) => e.toString()).toList();
    arguments["sessionId"] = sessionId;
    arguments["sessionType"] =
        NIMSessionTypeConverter(sessionType: sessionType).toValue();
    Map<String, dynamic> replyMap =
        await invokeMethod('queryMessageListByUuid', arguments: arguments);
    return notifyMessageListResult(replyMap);
  }

  // 删除一条消息记录
  @override
  Future<void> deleteChattingHistory(NIMMessage anchor, bool ignore) async {
    Map<String, dynamic> arguments = Map();
    arguments["message"] = anchor.toMap();
    arguments["ignore"] = ignore;
    await invokeMethod('deleteChattingHistory', arguments: arguments);
  }

  //指定多条消息进行本地删除
  @override
  Future<void> deleteChattingHistoryList(
      List<NIMMessage> msgList, bool ignore) async {
    Map<String, dynamic> arguments = Map();
    arguments["messageList"] = msgList.map((e) => e.toMap()).toList();
    arguments["ignore"] = ignore;
    await invokeMethod('deleteChattingHistoryList', arguments: arguments);
  }

  //删除指定会话内消息
  @override
  Future<void> clearChattingHistory(
      String account, NIMSessionType sessionType) async {
    Map<String, dynamic> arguments = Map();
    arguments["account"] = account;
    arguments["sessionType"] =
        NIMSessionTypeConverter(sessionType: sessionType).toValue();
    await invokeMethod('clearChattingHistory', arguments: arguments);
  }

  //删除所有消息
  @override
  Future<void> clearMsgDatabase(bool clearRecent) async {
    Map<String, dynamic> arguments = Map();
    arguments["clearRecent"] = clearRecent;
    await invokeMethod('clearMsgDatabase', arguments: arguments);
  }

  //从服务器拉取消息历史记录，可以指定查询的消息类型，结果不存本地消息数据库。
  @override
  Future<NIMResult<List<NIMMessage>>> pullMessageHistoryExType(
      NIMMessage anchor,
      int toTime,
      int limit,
      QueryDirection direction,
      List<NIMMessageType> msgTypeList,
      bool persist) async {
    Map<String, dynamic> arguments = Map();
    arguments["message"] = anchor.toMap();
    arguments["toTime"] = toTime;
    arguments["limit"] = limit;
    arguments["direction"] = direction.index;
    arguments["messageTypeList"] = msgTypeList
        .map((e) => NIMMessageTypeConverter(messageType: e).toValue())
        .toList();
    arguments["persist"] = persist;
    Map<String, dynamic> replyMap =
        await invokeMethod('pullMessageHistoryExType', arguments: arguments);
    return notifyMessageListResult(replyMap);
  }

  @override
  Future<NIMResult<List<NIMMessage>>> pullMessageHistory(
      NIMMessage anchor, int limit, bool persist) async {
    Map<String, dynamic> arguments = Map();
    arguments["message"] = anchor.toMap();
    arguments["limit"] = limit;
    arguments["persist"] = persist;
    Map<String, dynamic> replyMap =
        await invokeMethod('pullMessageHistory', arguments: arguments);
    return notifyMessageListResult(replyMap);
  }

  //删除单会话云端历史消息
  @override
  Future<void> clearServerHistory(
      String sessionId, NIMSessionType sessionType, bool sync) async {
    Map<String, dynamic> arguments = Map();
    arguments["sessionId"] = sessionId;
    arguments["sessionType"] =
        NIMSessionTypeConverter(sessionType: sessionType).toValue();
    arguments["sync"] = sync;
    await invokeMethod('clearServerHistory', arguments: arguments);
  }

  //单向删除单条云端历史消息
  @override
  Future<NIMResult<int>> deleteMsgSelf(NIMMessage msg, String ext) async {
    Map<String, dynamic> arguments = Map();
    arguments["message"] = msg.toMap();
    arguments["ext"] = ext;
    Map<String, dynamic> replyMap =
        await invokeMethod('deleteMsgSelf', arguments: arguments);
    return NIMResult.fromMap(replyMap);
  }

  //单向删除多条云端历史消息
  @override
  Future<NIMResult<int>> deleteMsgListSelf(
      List<NIMMessage> msgList, String ext) async {
    Map<String, dynamic> arguments = Map();
    arguments["messageList"] = msgList.map((e) => e.toMap()).toList();
    arguments["ext"] = ext;
    Map<String, dynamic> replyMap =
        await invokeMethod('deleteMsgListSelf', arguments: arguments);
    return NIMResult.fromMap(replyMap);
  }

  //单会话检索(新)
  @override
  Future<NIMResult<List<NIMMessage>>> searchMessage(NIMSessionType sessionType,
      String sessionId, MessageSearchOption searchOption) async {
    Map<String, dynamic> arguments = Map();
    arguments["sessionType"] =
        NIMSessionTypeConverter(sessionType: sessionType).toValue();
    arguments["sessionId"] = sessionId;
    arguments["searchOption"] = searchOption.toMap();
    Map<String, dynamic> replyMap =
        await invokeMethod('searchMessage', arguments: arguments);
    return notifyMessageListResult(replyMap);
  }

  //全局检索(新)
  @override
  Future<NIMResult<List<NIMMessage>>> searchAllMessage(
      MessageSearchOption searchOption) async {
    Map<String, dynamic> arguments = Map();
    arguments["searchOption"] = searchOption.toMap();
    Map<String, dynamic> replyMap =
        await invokeMethod('searchAllMessage', arguments: arguments);
    return notifyMessageListResult(replyMap);
  }

  // 单聊云端消息检索
  @override
  Future<NIMResult<List<NIMMessage>>> searchRoamingMsg(
      String otherAccid,
      int fromTime,
      int endTime,
      String keyword,
      int limit,
      bool reverse) async {
    Map<String, dynamic> arguments = Map();
    arguments["otherAccid"] = otherAccid;
    arguments["fromTime"] = fromTime;
    arguments["endTime"] = endTime;
    arguments["keyword"] = keyword;
    arguments["limit"] = limit;
    arguments["reverse"] = reverse;
    Map<String, dynamic> replyMap =
        await invokeMethod('searchRoamingMsg', arguments: arguments);
    return notifyMessageListResult(replyMap);
  }

  //全文云端消息检索
  @override
  Future<NIMResult<List<NIMMessage>>> searchCloudMessageHistory(
      MessageKeywordSearchConfig config) async {
    Map<String, dynamic> arguments = Map();
    arguments["messageKeywordSearchConfig"] = config.toMap();
    Map<String, dynamic> replyMap =
        await invokeMethod('searchCloudMessageHistory', arguments: arguments);
    return notifyMessageListResult(replyMap);
  }

  NIMResult<List<NIMMessage>> notifyMessageListResult(
      Map<String, dynamic> replyMap) {
    return NIMResult.fromMap(replyMap, convert: (map) {
      var messageList = map['messageList'] as List<dynamic>;
      return messageList
          .map((e) => NIMMessage.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    });
  }

  Future<NIMResult<List<NIMSession>>> querySessionList([int? limit]) async {
    return NIMResult<List<NIMSession>>.fromMap(
      await invokeMethod(
        'querySessionList',
        arguments: {
          'limit': limit,
        },
      ),
      convert: (map) {
        return (map['resultList'] as List?)
            ?.map(
                (e) => NIMSession.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList();
      },
    );
  }

  Future<NIMResult<List<NIMSession>>> querySessionListFiltered(
      List<NIMMessageType> filterMessageTypeList) async {
    return NIMResult<List<NIMSession>>.fromMap(
      await invokeMethod(
        'querySessionListFiltered',
        arguments: {
          'filterMessageTypeList': filterMessageTypeList
              .map((type) =>
                  NIMMessageTypeConverter(messageType: type).toValue())
              .toList(),
        },
      ),
      convert: (map) {
        return (map['resultList'] as List?)
            ?.map(
                (e) => NIMSession.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList();
      },
    );
  }

  // Future<NIMResult<List<NIMSession>>> queryLatestSessionListByPage({
  //   NIMSession? anchor,
  //   QueryDirection direction = QueryDirection.QUERY_NEW,
  //   int limit = 100,
  // }) async {
  //   throw UnimplementedError(
  //       'queryLatestSessionListByPage() is not implemented');
  // }

  Future<NIMResult<NIMSession>> querySession(NIMSessionInfo sessionInfo) async {
    return NIMResult<NIMSession>.fromMap(
      await invokeMethod(
        'querySession',
        arguments: sessionInfo.toMap(),
      ),
      convert: (e) => NIMSession.fromMap(Map<String, dynamic>.from(e)),
    );
  }

  Future<NIMResult<NIMSession>> createSession({
    required String sessionId,
    required NIMSessionType sessionType,
    int tag = 0,
    required int time,
    bool linkToLastMessage = false,
  }) async {
    return NIMResult<NIMSession>.fromMap(
      await invokeMethod(
        'createSession',
        arguments: {
          'sessionId': sessionId,
          'sessionType':
              NIMSessionTypeConverter(sessionType: sessionType).toValue(),
          'tag': tag,
          'time': time,
          'linkToLastMessage': linkToLastMessage,
        },
      ),
      convert: (e) => NIMSession.fromMap(Map<String, dynamic>.from(e)),
    );
  }

  // Future<NIMResult<NIMSession>> createSessionByMessage({
  //   required NIMMessage message,
  //   bool needNotify = true,
  // }) async {
  //   return NIMResult<NIMSession>.fromMap(
  //     await invokeMethod(
  //     'createSession',
  //     arguments: {
  //       'sessionId': sessionId,
  //       'sessionType': NIMSessionTypeConverter(sessionType: sessionType).toValue(),
  //       'tag': tag,
  //       'time': time,
  //       'linkToLastMessage': linkToLastMessage,
  //     },
  //   ),
  //   convert: (e) => NIMSession.fromMap(Map<String, dynamic>.from(e)),
  //   );
  // }

  Future<NIMResult<void>> updateSession({
    required NIMSession session,
    bool needNotify = false,
  }) async {
    return NIMResult<void>.fromMap(
      await invokeMethod(
        'updateSession',
        arguments: {
          'session': session.toMap(),
          'needNotify': needNotify,
        },
      ),
    );
  }

  Future<NIMResult<void>> updateSessionWithMessage({
    required NIMMessage message,
    bool needNotify = false,
  }) async {
    return NIMResult<void>.fromMap(
      await invokeMethod(
        'updateSessionWithMessage',
        arguments: {
          'message': message.toMap(),
          'needNotify': needNotify,
        },
      ),
    );
  }

  Future<NIMResult<int>> queryTotalUnreadCount({
    NIMUnreadCountQueryType queryType = NIMUnreadCountQueryType.all,
  }) async {
    return NIMResult<int>.fromMap(
      await invokeMethod(
        'queryTotalUnreadCount',
        arguments: {
          'queryType': queryType.index,
        },
      ),
      convert: (map) => map['count'] as int,
    );
  }

  Future<NIMResult<void>> setChattingAccount({
    required String sessionId,
    required NIMSessionType sessionType,
  }) async {
    return NIMResult<void>.fromMap(
      await invokeMethod(
        'setChattingAccount',
        arguments: {
          'sessionId': sessionId,
          'sessionType':
              NIMSessionTypeConverter(sessionType: sessionType).toValue(),
        },
      ),
    );
  }

  Future<NIMResult<List<NIMSessionInfo>>> clearSessionUnreadCount(
    List<NIMSessionInfo> sessionInfoList,
  ) async {
    return NIMResult<List<NIMSessionInfo>>.fromMap(
      await invokeMethod(
        'clearSessionUnreadCount',
        arguments: {
          'requestList': sessionInfoList.map((e) => e.toMap()).toList(),
        },
      ),
      convert: (map) {
        return (map['failList'] as List?)
            ?.map((e) =>
                NIMSessionInfo.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList();
      },
    );
  }

  // Future<NIMResult<void>> deleteRoamingSession(
  //   NIMSessionInfo sessionInfo,
  // ) async {
  //   return NIMResult<void>.fromMap(
  //     await invokeMethod(
  //       'deleteRoamingSession',
  //       arguments: {
  //         'session': sessionInfo.toMap(),
  //       },
  //     ),
  //   );
  // }

  Future<NIMResult<void>> deleteSession({
    required NIMSessionInfo sessionInfo,
    required NIMSessionDeleteType deleteType,
    required bool sendAck,
  }) async {
    return NIMResult<void>.fromMap(
      await invokeMethod(
        'deleteSession',
        arguments: {
          'sessionInfo': sessionInfo.toMap(),
          'deleteType': sessionDeleteTypeToString(deleteType),
          'sendAck': sendAck,
        },
      ),
    );
  }

  Future<NIMResult<void>> replyMessage(
      {required NIMMessage msg,
      required NIMMessage replyMsg,
      required bool resend}) async {
    return NIMResult<void>.fromMap(
      await invokeMethod(
        'replyMessage',
        arguments: {
          'message': msg.toMap(),
          'replyMsg': replyMsg.toMap(),
          'resend': resend,
        },
      ),
    );
  }

  Future<NIMResult<int>> queryReplyCountInThreadTalkBlock(
      NIMMessage msg) async {
    return NIMResult<int>.fromMap(
      await invokeMethod(
        'queryReplyCountInThreadTalkBlock',
        arguments: {
          'message': msg.toMap(),
        },
      ),
    );
  }

  Future<NIMResult<NIMThreadTalkHistory>> queryThreadTalkHistory(
      {required NIMMessage anchor,
      required int fromTime,
      required int toTime,
      required int limit,
      required QueryDirection direction,
      required bool persist}) async {
    return NIMResult<NIMThreadTalkHistory>.fromMap(
      await invokeMethod(
        'queryReplyCountInThreadTalkBlock',
        arguments: {
          'message': anchor.toMap(),
          'fromTime': fromTime,
          'toTime': toTime,
          'limit': limit,
          'direction': direction.index,
          'persist': persist,
        },
      ),
      convert: (e) =>
          NIMThreadTalkHistory.fromMap(Map<String, dynamic>.from(e)),
    );
  }

  @override
  Future<NIMResult<NIMLocalAntiSpamResult>> checkLocalAntiSpam(
      String content, String replacement) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'checkLocalAntiSpam',
        arguments: {
          'content': content,
          'replacement': replacement,
        },
      ),
      convert: (map) => NIMLocalAntiSpamResult.fromMap(map),
    );
  }
}
