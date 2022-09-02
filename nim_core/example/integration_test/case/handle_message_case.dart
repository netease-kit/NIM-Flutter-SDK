// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:nim_core/nim_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

import 'method_name_value.dart';

// 为防止冲突，先单独建文件，最后再与handle_send_message_case合并
class HandleMessageCase extends HandleBaseCase {
  HandleMessageCase();

  NIMMessage? _cacheMessage;
  NIMMessage? _resendMessage;

  @override
  Future<ResultBean?> handle(event) async {
    super.handle(event);

    var inputParams = Map<String, dynamic>();
    if (params != null && params!.length > 0) {
      inputParams = jsonDecode(params![0]) as Map<String, dynamic>;
    }
    switch (methodName) {
      case saveMessage:
        NIMResult<NIMMessage> retCreateMsg =
            await MessageBuilder.createTextMessage(
                sessionId: inputParams['toAccount'] as String,
                sessionType: NIMSessionType.p2p,
                text: inputParams['text'] as String);
        var message = retCreateMsg.data;
        assert(message != null);
        NIMResult<NIMMessage> result = await NimCore.instance.messageService
            .saveMessage(
                message: message!,
                fromAccount: inputParams['fromAccount'] as String);
        if (result.data != null) {
          // 存下消息，作为后续用例的入参
          _cacheMessage = result.data!;
        }
        handleCaseResult = ResultBean(
            code: result.code, data: result.data?.toMap(), message: methodName);
        break;
      case updateMessage:
        if (_cacheMessage == null) {
          handleCaseResult = ResultBean(
              code: -1, data: '_updateMessage is null', message: methodName);
        } else {
          _cacheMessage!.localExtension = {
            'localExtension': inputParams['localExtension']
          };
          NIMResult<void> result = await NimCore.instance.messageService
              .updateMessage(_cacheMessage!);
          handleCaseResult =
              ResultBean(code: result.code, data: null, message: methodName);
        }
        break;
      case cancelUploadAttachment:
        // 先发送一张图片，然后取消
        NIMResult<NIMMessage> ret =
            await sendImageMessage(inputParams['toAccount'] as String);
        if (ret.isSuccess && ret.data != null) {
          NIMResult<void> result = await NimCore.instance.messageService
              .cancelUploadAttachment(ret.data!);
          if (result.isSuccess) {
            // 存下消息，作为resendMessage的入参
            _resendMessage = ret.data!;
          }
          handleCaseResult =
              ResultBean(code: result.code, data: null, message: methodName);
        } else {
          handleCaseResult = ResultBean(
              code: -1, data: 'message send failed', message: methodName);
        }
        break;
      case resendMessage:
        // handleCaseResult = ResultBean(code: 0, data: null, message: methodName);
        // dart层写死了resend参数
        // if (_resendMessage == null) {
        //   handleCaseResult = ResultBean(
        //       code: -1, data: '_resendMessage is null', message: methodName);
        // } else {
        //   NIMResult<NIMMessage> result = await NimCore.instance.messageService.sendMessage(message: _resendMessage!, resend: true);
        //   handleCaseResult = ResultBean(
        //       code: result.code, data: result.data?.toMap(), message: methodName);
        // }
        NIMResult<NIMMessage> retCreateMsg =
            await MessageBuilder.createTextMessage(
                sessionId: inputParams['toAccount'] as String,
                sessionType: NIMSessionType.p2p,
                text: inputParams['text'] as String);
        var message = retCreateMsg.data;
        assert(message != null);
        NIMResult<NIMMessage> result = await NimCore.instance.messageService
            .sendMessage(message: message!, resend: false);
        handleCaseResult = ResultBean(
            code: result.code, data: result.data?.toMap(), message: methodName);
        break;
      case forwardMessage:
        if (_resendMessage == null) {
          handleCaseResult = ResultBean(
              code: -1, data: '_forwardMessage is null', message: methodName);
        } else {
          NIMResult<void> result = await NimCore.instance.messageService
              .forwardMessage(_resendMessage!, inputParams['toAccount'],
                  NIMSessionType.p2p);
          handleCaseResult =
              ResultBean(code: result.code, data: null, message: methodName);
        }
        break;
      case revokeMessage:
        NIMResult<NIMMessage> retCreateMsg =
            await MessageBuilder.createTextMessage(
                sessionId: inputParams['toAccount'] as String,
                sessionType: NIMSessionType.p2p,
                text: inputParams['text'] as String);
        var message = retCreateMsg.data;
        assert(message != null);
        NIMResult<NIMMessage> ret = await NimCore.instance.messageService
            .sendMessage(message: message!);
        if (ret.isSuccess) {
          NIMResult<void> result = await NimCore.instance.messageService
              .revokeMessage(message: ret.data!);
          handleCaseResult =
              ResultBean(code: result.code, data: null, message: methodName);
        } else {
          handleCaseResult = ResultBean(
              code: -1, data: 'send message failed', message: methodName);
        }
        break;
      default:
        break;
    }
    return handleCaseResult;
  }

  Future<NIMResult<NIMMessage>> sendImageMessage(String sessionId) async {
    var imagePath = '/sdcard/image.jpeg';
    var imageSize = 1000;
    if (Platform.isIOS || Platform.isWindows || Platform.isMacOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      imagePath = appDocDir.path + "/test.jpg";
      print("imagePath:" + File(imagePath).path);
      if (Platform.isWindows || Platform.isMacOS) {
        imageSize = File(imagePath).lengthSync();
      }
    }
    // var filesize = jsonEncode(params![0]["fileSize"]) as int ?? 0;
    NIMResult<NIMMessage> retCreateMsg =
        await MessageBuilder.createImageMessage(
            sessionId: sessionId,
            sessionType: NIMSessionType.p2p,
            filePath: imagePath,
            fileSize: imageSize);
    var message = retCreateMsg.data;
    assert(message != null);
    return NimCore.instance.messageService
        .sendMessage(message: message!, resend: false);
  }
}
