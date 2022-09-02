// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:nim_core/nim_core.dart';
import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

class HandleHistoryMessageCase extends HandleBaseCase {
  HandleHistoryMessageCase();

  @override
  Future<ResultBean?> handle(event) async {
    super.handle(event);
    switch (methodName) {
      case "queryMessageList":
        // var inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
        // var account = inputParams['account'] as String;
        // var sessionType = NIMSessionTypeConverter()
        //     .fromValue(inputParams['sessionType'] as String);
        // var limit = inputParams['limit'] as int;
        // final result = await NimCore.instance.messageService
        //     .queryMessageList(account, sessionType, limit);
        // print(
        //     '=========>>MessageService:queryMessageList = ${result.code}：${result.errorDetails}}');
        // handleCaseResult =
        //     ResultBean(code: result.code, data: result.data, message: '');
        break;

      case "queryMessageListEx":
        var inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
        var messageJson = inputParams["message"];
        var message = NIMMessage.textEmptyMessage(
            sessionId: messageJson['sessionId'],
            sessionType:
                NIMSessionTypeConverter().fromValue(messageJson['sessionType']),
            text: messageJson['text']);
        var direction =
            convertStringToQueryDirection(inputParams['queryDirection']);
        var limit = inputParams['limit'] as int;
        final result = await NimCore.instance.messageService
            .queryMessageListEx(message, direction, limit);
        print(
            '=========>>MessageService:queryMessageListEx=${result.code}：${result.errorDetails}');
        handleCaseResult =
            ResultBean(code: result.code, data: result.data, message: '');
        break;

      case "queryLastMessage":
        var inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
        var account = inputParams['account'] as String;
        var sessionType = NIMSessionTypeConverter()
            .fromValue(inputParams['sessionType'] as String);
        final result = await NimCore.instance.messageService
            .queryLastMessage(account, sessionType);
        print(
            '=========>>MessageService:queryLastMessage=${result.code}：${result.errorDetails}');
        handleCaseResult =
            ResultBean(code: result.code, data: result.data, message: '');
        break;

      case "queryMessageListByUuid":
        var inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
        var uuids = inputParams['uuids'] as List<dynamic>;
        List<String> uuidsList = uuids.map((e) => e.toString()).toList();
        var sessionId = inputParams['sessionId'] as String;
        var sessionType =
            NIMSessionTypeConverter().fromValue(inputParams['sessionType']);
        final result = await NimCore.instance.messageService
            .queryMessageListByUuid(uuidsList, sessionId, sessionType);
        print(
            '=========>>MessageService:queryMessageListByUuid=${result.code}：${result.errorDetails}');
        handleCaseResult =
            ResultBean(code: result.code, data: result.data, message: '');
        break;

      case "deleteChattingHistory":
        print('=========>>MessageService:deleteChattingHistory0');
        handleCaseResult = ResultBean(code: 0, data: null, message: '');
        break;

      case "deleteChattingHistoryList":
        if (Platform.isWindows || Platform.isMacOS) {
          handleCaseResult =
              ResultBean.success(message: "desktop default success");
          break;
        }
        var inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
        var messageList = inputParams['messageList'] as List<dynamic>;
        List<NIMMessage> mList = messageList
            .map((e) => NIMMessage.textEmptyMessage(
                sessionId: e['sessionId'],
                sessionType:
                    NIMSessionTypeConverter().fromValue(e['sessionType']),
                text: e['text']))
            .toList();
        var ignore = inputParams['ignore'] as bool;
        await NimCore.instance.messageService
            .deleteChattingHistoryList(mList, ignore);
        print('=========>>MessageService:deleteChattingHistoryList0');
        handleCaseResult = ResultBean(code: 0, data: null, message: '');
        break;

      case "clearChattingHistory":
        var inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
        var account = inputParams['account'] as String;
        var sessionType = NIMSessionTypeConverter()
            .fromValue(inputParams['sessionType'] as String);
        await NimCore.instance.messageService
            .clearChattingHistory(account, sessionType);
        print('=========>>MessageService:0');
        handleCaseResult = ResultBean(code: 0, data: null, message: '');
        break;

      case "clearMsgDatabase":
        var inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
        var clearRecent = inputParams['clearRecent'] as bool;
        await NimCore.instance.messageService.clearMsgDatabase(clearRecent);
        print('=========>>MessageService:0');
        handleCaseResult = ResultBean(code: 0, data: null, message: '');
        break;

      case "pullMessageHistory":
        var inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
        var messageJson = inputParams["message"];
        var message = NIMMessage.textEmptyMessage(
            sessionId: messageJson['sessionId'],
            sessionType:
                NIMSessionTypeConverter().fromValue(messageJson['sessionType']),
            text: messageJson['text']);
        var limit = inputParams['limit'] as int;
        var persist = inputParams['persist'] as bool;
        var result = await NimCore.instance.messageService
            .pullMessageHistory(message, limit, persist);
        print(
            '=========>>MessageService:pullMessageHistory=${result.code}：${result.errorDetails}');
        handleCaseResult =
            ResultBean(code: result.code, data: result.data, message: '');
        break;

      case "pullMessageHistoryExType":
        var inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
        var messageJson = inputParams["message"];
        var message = NIMMessage.textEmptyMessage(
            sessionId: messageJson['sessionId'],
            sessionType:
                NIMSessionTypeConverter().fromValue(messageJson['sessionType']),
            text: messageJson['text']);
        var toTime = inputParams['toTime'] as int;
        var limit = inputParams['limit'] as int;
        var direction =
            convertStringToQueryDirection(inputParams['queryDirection']);
        var messageTypeList = inputParams['messageTypeList'] as List<dynamic>;
        List<NIMMessageType> mList = messageTypeList
            .map((e) => NIMMessageTypeConverter().fromValue(e))
            .toList();
        var persist = inputParams['persist'] as bool;
        var result = await NimCore.instance.messageService
            .pullMessageHistoryExType(
                message, toTime, limit, direction, mList, persist);
        print(
            '=========>>MessageService:pullMessageHistoryExType=${result.code}：${result.errorDetails}');
        handleCaseResult =
            ResultBean(code: result.code, data: result.data, message: '');
        break;

      case "clearServerHistory":
        var inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
        var sessionId = inputParams['sessionId'] as String;
        var sync = inputParams['sync'] as bool;
        var sessionType = NIMSessionTypeConverter()
            .fromValue(inputParams['sessionType'] as String);
        await NimCore.instance.messageService
            .clearServerHistory(sessionId, sessionType, sync);
        print('=========>>MessageService:0');
        handleCaseResult = ResultBean(code: 0, data: null, message: '');
        break;

      case "deleteMsgSelf":
        var inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
        var messageJson = inputParams["message"];
        var message = NIMMessage.textEmptyMessage(
            sessionId: messageJson['sessionId'],
            sessionType:
                NIMSessionTypeConverter().fromValue(messageJson['sessionType']),
            text: messageJson['text']);
        var ext = inputParams['ext'] as String;
        var result =
            await NimCore.instance.messageService.deleteMsgSelf(message, ext);
        print(
            '=========>>MessageService:deleteMsgSelf=${result.code}：${result.errorDetails}');
        handleCaseResult =
            ResultBean(code: result.code, data: result.data, message: '');
        break;

      case "deleteMsgListSelf":
        var inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
        var messageList = inputParams['messageList'] as List<dynamic>;
        List<NIMMessage> mList = messageList
            .map((e) => NIMMessage.textEmptyMessage(
                sessionId: e['sessionId'],
                sessionType:
                    NIMSessionTypeConverter().fromValue(e['sessionType']),
                text: e['text']))
            .toList();
        var ext = inputParams['ext'] as String;
        var result =
            await NimCore.instance.messageService.deleteMsgListSelf(mList, ext);
        print(
            '=========>>MessageService:deleteMsgListSelf=${result.code}：${result.errorDetails}');
        handleCaseResult =
            ResultBean(code: result.code, data: result.data, message: '');
        break;

      case "searchMessage":
        var inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
        var sessionId = inputParams['sessionId'] as String;
        var searchOption = MessageSearchOption.fromMap(
            inputParams['searchOption'] as Map<String, dynamic>);
        var sessionType = NIMSessionTypeConverter()
            .fromValue(inputParams['sessionType'] as String);
        var result = await NimCore.instance.messageService
            .searchMessage(sessionType, sessionId, searchOption);
        print(
            '=========>>MessageService:searchMessage=${result.code}：${result.errorDetails}');
        handleCaseResult =
            ResultBean(code: result.code, data: result.data, message: '');
        break;

      case "searchAllMessage":
        var inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
        var searchOption = MessageSearchOption.fromMap(
            inputParams['searchOption'] as Map<String, dynamic>);
        var result = await NimCore.instance.messageService
            .searchAllMessage(searchOption);
        print(
            '=========>>MessageService:searchAllMessage=${result.code}：${result.errorDetails}');
        handleCaseResult =
            ResultBean(code: result.code, data: result.data, message: '');
        break;

      case "searchCloudMessageHistory":
        var inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
        var messageKeywordSearchConfig = MessageKeywordSearchConfig.fromMap(
            inputParams['searchOption'] as Map<String, dynamic>);
        var result = await NimCore.instance.messageService
            .searchCloudMessageHistory(messageKeywordSearchConfig);
        print(
            '=========>>MessageService:searchCloudMessageHistory=${result.code}：${result.errorDetails}');
        handleCaseResult =
            ResultBean(code: result.code, data: result.data, message: '');
        break;
      case 'searchRoamingMsg':
        var inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
        var otherAccid = inputParams['otherAccid'] as String;
        var keyword = inputParams['keyword'] as String;
        var startTime = inputParams['startTime'] as int;
        var endTime = inputParams['endTime'] as int;
        var limit = inputParams['limit'] as int;
        var reverse = inputParams['reverse'] as bool;
        var result = await NimCore.instance.messageService.searchRoamingMsg(
            otherAccid, startTime, endTime, keyword, limit, reverse);
        print(
            '=========>>MessageService:searchRoamingMsg=${result.code}：${result.errorDetails}');
        handleCaseResult =
            ResultBean(code: result.code, data: result.data, message: '');
        break;
    }

    return handleCaseResult;
  }

  QueryDirection convertStringToQueryDirection(String param) {
    return param == 'QUERY_NEW'
        ? QueryDirection.QUERY_NEW
        : QueryDirection.QUERY_OLD;
  }
}
