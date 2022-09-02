// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.
import 'dart:convert';
import 'dart:io';

import 'package:nim_core/nim_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

import 'method_name_value.dart';

class GuessAttachment {
  final int guess;

  GuessAttachment(this.guess);

  Map<String, dynamic> toMap() {
    return {'guess': guess};
  }

  factory GuessAttachment.fromMap(Map<String, dynamic> map) {
    return GuessAttachment(map['guess']);
  }
}

class HandleSendMessageCase extends HandleBaseCase {
  HandleSendMessageCase();

  @override
  Future<ResultBean?> handle(event) async {
    super.handle(event);
    print("case id $event");

    switch (methodName) {
      /* 使用 HandleLoginCase
      case "login":
        var map = jsonDecode(params![0]);
        var result = await NimCore.instance.authService.login(NIMLoginInfo.fromMap(map["loginInfo"]));
        print('send message login result =========>>${result.code}');
        NIMResult<List<NIMFriend>> fResult =
        await NimCore.instance.userService.getFriendList();
        fResult.data!.forEach((element) {
          print("friend id ${element.userId}");
          print("friend name ${element.alias}");
        });
        print("friend count : ${fResult.data!.length}");
        handleCaseResult = ResultBean(
            code: result.code,
            data: result.toString(),
            message: result.errorDetails);
        break;
        */
      case sendTextMessage:
        var map = jsonDecode(params![0]);
        map["timestamp"] = 0;
        print("send text message map ${map.toString()}");
        var caseParam = NIMMessage.fromMap(map);
        NIMResult<NIMMessage> retCreateMsg =
            await MessageBuilder.createTextMessage(
                sessionId: caseParam.sessionId!,
                sessionType: caseParam.sessionType!,
                text: "this is text message");
        var message = retCreateMsg.data;
        assert(message != null);
        NIMResult<NIMMessage> result = await NimCore.instance.messageService
            .sendMessage(message: message!);
        print("send message text code ${result.code}  ${result.errorDetails}");
        handleCaseResult = ResultBean(
            code: result.code, data: result.toMap(), message: methodName);
        break;
      case sendImageMessage:
        var imagePath = '/sdcard/image.jpeg';
        var map = jsonDecode(params![0]);
        map["timestamp"] = 0;
        var caseParam = NIMMessage.fromMap(map);
        var imageAttachment = caseParam.messageAttachment as NIMImageAttachment;
        if (Platform.isIOS || Platform.isWindows || Platform.isMacOS) {
          Directory appDocDir = await getApplicationDocumentsDirectory();
          imagePath = appDocDir.path + "/test.jpg";
          print("imagePath:" + File(imagePath).path);
        }

        NIMResult<NIMMessage> retCreateMsg =
            await MessageBuilder.createImageMessage(
                sessionId: caseParam.sessionId!,
                sessionType: caseParam.sessionType!,
                filePath: imagePath,
                fileSize: imageAttachment.size!);
        var message = retCreateMsg.data;
        assert(message != null);
        NIMResult<NIMMessage> result = await NimCore.instance.messageService
            .sendMessage(message: message!, resend: false);
        print("send message image code ${result.code} ${result.errorDetails}");
        handleCaseResult = ResultBean(
            code: result.code, data: result.toMap(), message: methodName);
        break;

      case sendAudioMessage:
        var audioPath = '/sdcard/audio.aac';
        if (Platform.isIOS || Platform.isWindows || Platform.isMacOS) {
          Directory appDocDir = await getApplicationDocumentsDirectory();
          audioPath = appDocDir.path + "/test.mp3";
          print("audioPath:" + File(audioPath).path);
        }
        var map = jsonDecode(params![0]);
        var caseParam = NIMMessage.fromMap(map);
        var audioAttachment = caseParam.messageAttachment as NIMAudioAttachment;
        NIMResult<NIMMessage> retCreateMsg =
            await MessageBuilder.createAudioMessage(
                sessionId: caseParam.sessionId!,
                sessionType: caseParam.sessionType!,
                filePath: audioPath,
                fileSize: audioAttachment.size!,
                duration: audioAttachment.duration!);
        var message = retCreateMsg.data;
        assert(message != null);
        NIMResult<NIMMessage> result = await NimCore.instance.messageService
            .sendMessage(message: message!, resend: false);
        print("send audio message result ${result.code}");
        handleCaseResult = ResultBean(
            code: result.code, data: result.toMap(), message: methodName);
        break;

      case sendVideoMessage:
        var videoPath = '/sdcard/video.mp4';
        if (Platform.isIOS || Platform.isWindows || Platform.isMacOS) {
          Directory appDocDir = await getApplicationDocumentsDirectory();
          videoPath = appDocDir.path + "/test.mp4";
          print("videoPath:" + File(videoPath).path);
        }
        var map = jsonDecode(params![0]);
        var caseParam = NIMMessage.fromMap(map);
        var videoAttachment = caseParam.messageAttachment as NIMVideoAttachment;
        NIMResult<NIMMessage> retCreateMsg =
            await MessageBuilder.createVideoMessage(
                sessionId: caseParam.sessionId!,
                sessionType: caseParam.sessionType!,
                filePath: videoPath,
                duration: videoAttachment.duration!,
                width: videoAttachment.width!,
                height: videoAttachment.height!,
                displayName: videoAttachment.displayName!);
        var message = retCreateMsg.data;
        assert(message != null);
        NIMResult<NIMMessage> result = await NimCore.instance.messageService
            .sendMessage(message: message!, resend: false);
        print("send video message result ${result.code}");
        handleCaseResult = ResultBean(
            code: result.code, data: result.toMap(), message: methodName);
        break;

      case sendLocationMessage:
        var map = jsonDecode(params![0]);
        var caseParam = NIMMessage.fromMap(map);
        var locationAttachment =
            caseParam.messageAttachment as NIMLocationAttachment;
        NIMResult<NIMMessage> retCreateMsg =
            await MessageBuilder.createLocationMessage(
                sessionId: caseParam.sessionId!,
                sessionType: caseParam.sessionType!,
                latitude: locationAttachment.latitude,
                longitude: locationAttachment.longitude,
                address: locationAttachment.address);
        var message = retCreateMsg.data;
        assert(message != null);
        NIMResult<NIMMessage> result = await NimCore.instance.messageService
            .sendMessage(message: message!, resend: false);
        print("send location message result ${result.code}");
        handleCaseResult = ResultBean(
            code: result.code, data: result.toMap(), message: methodName);
        break;

      case sendFileMessage:
        var filePath = '/sdcard/video.mp4';
        if (Platform.isIOS || Platform.isWindows || Platform.isMacOS) {
          Directory appDocDir = await getApplicationDocumentsDirectory();
          filePath = appDocDir.path + "/test.mp4";
          print("filePath:" + File(filePath).path);
        }
        var map = jsonDecode(params![0]);
        var caseParam = NIMMessage.fromMap(map);
        var fileAttachment = caseParam.messageAttachment as NIMFileAttachment;
        NIMResult<NIMMessage> retCreateMsg =
            await MessageBuilder.createFileMessage(
                sessionId: caseParam.sessionId!,
                sessionType: caseParam.sessionType!,
                filePath: filePath,
                displayName: fileAttachment.displayName!);
        var message = retCreateMsg.data;
        assert(message != null);
        NIMResult<NIMMessage> result = await NimCore.instance.messageService
            .sendMessage(message: message!, resend: false);
        print("send file message result ${result.code}");
        handleCaseResult = ResultBean(
            code: result.code, data: result.toMap(), message: methodName);
        break;

      case sendTipMessage:
        var map = jsonDecode(params![0]);
        var caseParam = NIMMessage.fromMap(map);
        NIMResult<NIMMessage> retCreateMsg =
            await MessageBuilder.createTipMessage(
                sessionId: caseParam.sessionId!,
                sessionType: caseParam.sessionType!);
        var message = retCreateMsg.data;
        assert(message != null);
        var text = map["text"];
        if (text != null && message != null) {
          message.content = text;
        }
        NIMResult<NIMMessage> result = await NimCore.instance.messageService
            .sendMessage(message: message!, resend: false);
        print("send tip message result ${result.code}");
        handleCaseResult = ResultBean(
            code: result.code, data: result.toMap(), message: methodName);
        break;

      case sendCustomObjectMessage:
        var map = jsonDecode(params![0]);
        var caseParam = NIMMessage.fromMap(map);
        var guessAttachment = GuessAttachment(10);
        var customAttachment =
            NIMCustomMessageAttachment.fromMap(guessAttachment.toMap());
        NIMResult<NIMMessage> retCreateMsg =
            await MessageBuilder.createCustomMessage(
                sessionId: caseParam.sessionId!,
                sessionType: caseParam.sessionType!,
                attachment: customAttachment);
        var message = retCreateMsg.data;
        assert(message != null);
        NIMResult<NIMMessage> result = await NimCore.instance.messageService
            .sendMessage(message: message!, resend: false);
        print("send custom message result ${result.code}");
        handleCaseResult = ResultBean(
            code: result.code, data: result.toMap(), message: methodName);
        break;

      case sendCustomFileMessage:
        var filePath = '/sdcard/video.mp4';
        if (Platform.isIOS || Platform.isWindows || Platform.isMacOS) {
          Directory appDocDir = await getApplicationDocumentsDirectory();
          filePath = appDocDir.path + "/test.mp4";
          print("filePath:" + File(filePath).path);
        }
        var caseParam = NIMMessage.fromMap(jsonDecode(jsonDecode(params![0])));
        var videoAttachment = caseParam.messageAttachment as NIMVideoAttachment;
        var fileAttachment = NIMFileAttachment(
            path: filePath,
            size: videoAttachment.size,
            displayName: videoAttachment.displayName,
            extension: videoAttachment.extension);
        NIMResult<NIMMessage> retCreateMsg =
            await MessageBuilder.createCustomMessage(
                sessionId: '',

                ///TODO
                sessionType: NIMSessionType.p2p,
                attachment: fileAttachment);
        var message = retCreateMsg.data;
        assert(message != null);
        NIMResult<NIMMessage> result = await NimCore.instance.messageService
            .sendMessage(message: message!, resend: false);
        print("send custom file message result ${result.code}");
        handleCaseResult = ResultBean(
            code: result.code, data: result.toMap(), message: methodName);
        break;
    }
    return handleCaseResult;
  }
}
