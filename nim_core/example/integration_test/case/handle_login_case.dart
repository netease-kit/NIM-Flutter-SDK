// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:nim_core/nim_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:netease_auto_test_kit/netease_auto_test_kit.dart';

import 'method_name_value.dart';

class HandleLoginCase extends HandleBaseCase {
  HandleLoginCase();

  @override
  Future<ResultBean?> handle(event) async {
    super.handle(event);
    var handled = false;
    var result;
    switch (methodName) {
      case login:
        Map map = jsonDecode(params![0])['loginInfo'];
        result = await NimCore.instance.authService
            .login(NIMLoginInfo.fromMap(Map<String, dynamic>.from(map)));
        _addUserObserver();
        _addMessageObserver();
        _testNOS();
        _addProgressObserver();
        handled = true;
        break;
      case logout:
        result = await NimCore.instance.authService.logout();
        handled = true;
        break;
    }
    if (handled) {
      print('AuthServiceTest#$methodName result: ${result.code}');
      handleCaseResult = ResultBean(
        code: result.code,
        data: result.toMap(),
        message: result.errorDetails,
      );
    }
    return handleCaseResult;
  }

  _addUserObserver() {
    print('Test_Observer addUserObserver');
    NimCore.instance.userService.onFriendAddedOrUpdated.listen((event) {
      print(
          'Test_Observer onFriendAddedOrUpdated ${event.map((e) => e.toMap()).toList()}');
    });

    NimCore.instance.userService.onUserInfoChange.listen((event) {
      print('Test_Observer onUserInfoChange ${event.toString()}');
    });

    NimCore.instance.userService.onFriendDeleted.listen((event) {
      print('Test_Observer onFriendDeleted ${event.toString()}');
    });

    NimCore.instance.userService.onBlackListChanged.listen((event) {
      print('Test_Observer onBlackListChanged');
    });

    NimCore.instance.userService.onMuteListChanged.listen((event) {
      print('Test_Observer onMuteListChanged');
    });

    NimCore.instance.systemMessageService.onReceiveSystemMsg.listen((event) {
      print(
          'Test_Observer onReceiveSystemMsg ${event.type} ${event.fromAccount}');
      if (event.type == SystemMessageType.addFriend) {
        NimCore.instance.userService
            .ackAddFriend(userId: event.fromAccount ?? '', isAgree: true);
      }
    });
  }

  _addMessageObserver() {
    print('Test_Observer addMessageObserver');
    NimCore.instance.messageService.onMessageRevoked.listen((event) {
      print('Test_Observer onMessageRevoked ${event.toMap()}');
    });

    NimCore.instance.messageService.onMessageReceipt.listen((event) {
      print(
          'Test_Observer onMessageReceipt ${event.map((e) => e.toMap()).toList()}');
    });

    NimCore.instance.messageService.onTeamMessageReceipt.listen((event) {
      print('Test_Observer onTeamMessageReceipt ${event.toString()}');
    });

    NimCore.instance.messageService.onAttachmentProgress.listen((event) {
      print('Test_Observer onAttachmentProgress ${event.toMap()}');
    });

    NimCore.instance.messageService.onMessage.listen((event) {
      print('Test_Observer onMessage ${event.map((e) => e.toMap()).toList()}');
      for (NIMMessage m in event) {
        if (m.sessionType == NIMSessionType.p2p) {
          NimCore.instance.messageService
              .sendMessageReceipt(sessionId: m.fromAccount!, message: m);
        } else if (m.sessionType == NIMSessionType.team) {
          NimCore.instance.messageService.sendTeamMessageReceipt(m);
        }
      }
    });

    NimCore.instance.messageService.onSessionUpdate.listen((event) {
      print(
          'Test_Observer onSessionUpdate ${event.map((e) => e.toMap()).toList()}');
    });
  }

  _testNOS() async {
    NimCore.instance.nosService.onNOSTransferStatus.listen((event) {
      print('Test_Observer onNOSTransferStatus ${event.toMap().toString()}');
    });
    NimCore.instance.nosService.onNOSTransferProgress.listen((event) {
      print('Test_Observer onNOSTransferProgress ${event.toString()}');
    });
    var imagePath = '/sdcard/image.jpeg';
    if (Platform.isIOS || Platform.isWindows || Platform.isMacOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      imagePath = appDocDir.path + "/test.jpg";
    }
    print('start upload ${imagePath.toString()}');
    NimCore.instance.nosService.upload(filePath: imagePath);
  }

  _addProgressObserver() {
    NimCore.instance.messageService.onAttachmentProgress.listen((event) {
      print('Test_Observer onAttachmentProgress ${event.id} ${event.progress}');
    });
  }
}
