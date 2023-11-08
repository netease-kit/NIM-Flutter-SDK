// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nim_core/nim_core.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // For Publish Use
  static const appKey = 'Your_App_Key';
  static const account = 'Account_ID';
  static const token = 'Account_Token';
  static const friendAccount = 'Friend_Account_ID';
  static const chatroomId = '123456789';

  final subsriptions = <StreamSubscription>[];

  Uint8List? _deviceToken;

  void updateAPNsToken() {
    if (NimCore.instance.isInitialized &&
        Platform.isIOS &&
        _deviceToken != null) {
      NimCore.instance.settingsService.updateAPNSToken(_deviceToken!, null);
    }
  }

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      MethodChannel('com.netease.NIM.demo/settings')
          .setMethodCallHandler((call) async {
        if (call.method == 'updateAPNsToken') {
          print('update APNs token');
          _deviceToken = call.arguments as Uint8List;
        }
        return null;
      });
    }

    subsriptions.add(NimCore.instance.authService.authStatus.listen((event) {
      print('AuthService##auth status event : ${event.status.name}');
    }));

    subsriptions
        .add(NimCore.instance.messageService.onMessage.listen((messages) {
      messages.forEach((message) {
        print(
            'MessageService##receive message: ${message.fromNickname} says ${message.content}');
      });
    }));

    subsriptions
        .add(NimCore.instance.messageService.onMessagePinNotify.listen((event) {
      print('MessageService##receive message pin: $event ');
    }));

    subsriptions.add(
        NimCore.instance.messageService.onStickTopSessionAdd.listen((session) {
      print('MessageService##onStickTopSessionAdd: $session ');
    }));

    subsriptions.add(NimCore.instance.messageService.onStickTopSessionUpdate
        .listen((session) {
      print('MessageService##onStickTopSessionUpdate: $session ');
    }));

    subsriptions.add(NimCore.instance.messageService.onStickTopSessionRemove
        .listen((session) {
      print('MessageService##onStickTopSessionRemove: $session ');
    }));

    subsriptions.add(
        NimCore.instance.messageService.onSyncStickTopSession.listen((session) {
      print('MessageService##onSyncStickTopSession: ${session.join('##')} ');
    }));

    subsriptions.add(
        NimCore.instance.messageService.onQuickCommentAdd.listen((comment) {
      print('MessageService##onQuickCommentAdd: $comment');
    }));

    subsriptions.add(
        NimCore.instance.messageService.onQuickCommentRemove.listen((comment) {
      print('MessageService##onQuickCommentRemove: $comment');
    }));

    subsriptions.add(
        NimCore.instance.messageService.onMySessionUpdate.listen((session) {
      print('MessageService##onMySessionUpdate: $session');
    }));

    subsriptions
        .add(NimCore.instance.messageService.onSessionDelete.listen((session) {
      print('MessageService##onSessionDelete: $session');
    }));

    subsriptions
        .add(NimCore.instance.messageService.onSessionUpdate.listen((session) {
      print('MessageService##onSessionUpdate: $session');
    }));

    subsriptions.add(
        NimCore.instance.avSignallingService.onlineNotification.listen((event) {
      print(
          'AVSignallingService##onlineNotification: ${event.signallingEvent.eventType}');
      if (event.signallingEvent.eventType == SignallingEventType.invite) {
        var param = InviteParam(
            channelId: event.signallingEvent.channelBaseInfo.channelId,
            accountId: event.signallingEvent.fromAccountId,
            requestId: event.requestId!);
        NimCore.instance.avSignallingService.acceptInvite(param).then((value) {
          print('AVSignallingService##acceptInvite result : ${value.code}');
          NimCore.instance.avSignallingService
              .joinChannel(
                  channelId: event.signallingEvent.channelBaseInfo.channelId,
                  offlineEnabled: true)
              .then((join) {
            print(
                'AVSignallingService## invite joinChannel result : ${join.code}');
            NimCore.instance.avSignallingService
                .sendControl(
                    channelId: event.signallingEvent.channelBaseInfo.channelId,
                    accountId: event.signallingEvent.fromAccountId)
                .then((control) {
              print('AVSignallingService## sendControl result : ${join.code}');
            });
          });
        });
      }
    }));

    _doInitializeSDK();
  }

  void _doInitializeSDK() async {
    late NIMSDKOptions options;
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      options = NIMAndroidSDKOptions(
          appKey: appKey,
          shouldSyncStickTopSessionInfos: true,
          sdkRootDir:
              directory != null ? '${directory.path}/NIMFlutter' : null);
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      options = NIMIOSSDKOptions(
        appKey: appKey,
        shouldSyncStickTopSessionInfos: true,
        sdkRootDir: '${directory.path}/NIMFlutter',
        apnsCername: 'ENTERPRISE',
        pkCername: 'DEMO_PUSH_KIT',
      );
    } else if (kIsWeb) {
      options = NIMIOSSDKOptions(
        appKey: appKey,
        shouldSyncStickTopSessionInfos: true,
        sdkRootDir: null,
        apnsCername: 'ENTERPRISE',
        pkCername: 'DEMO_PUSH_KIT',
      );
    }

    NimCore.instance.initialize(options).then((value) async {
      NimCore.instance.authService.dynamicTokenProvider = (account) async {
        print('AuthService##getDynamicToken: $account');
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        final ttl = 600;
        final secret = '';
        final signature =
            sha1.convert(utf8.encode('$appKey$account$currentTime$ttl$secret'));
        return base64.encode(utf8.encode(
            '{"signature":"$signature","curTime":$currentTime,"ttl":$ttl}'));
      };
      final loginResult = await NimCore.instance.authService.login(NIMLoginInfo(
        account: account,
        token: token,
        //authType: NIMAuthType.authTypeDynamic,
      ));
      // _testSuperTeam();
      // _testTeam();
      print('login result: $loginResult');
      updateAPNsToken();

      var textMessage1 = await MessageBuilder.createTextMessage(
        sessionId: friendAccount,
        sessionType: NIMSessionType.p2p,
        text: '快捷评论消息',
      );

      await NimCore.instance.messageService.sendMessageReceipt(
          message: textMessage1.data!, sessionId: '1212121');

      // TEST
      textMessage1 = await NimCore.instance.messageService
          .sendMessage(message: textMessage1.data!);

      final imagePath = Platform.isAndroid
          ? (await getExternalStorageDirectory())!.path + "/test.jpg"
          : (await getApplicationDocumentsDirectory()).path + "/test.jpg";

      MessageBuilder.createImageMessage(
        sessionId: friendAccount,
        sessionType: NIMSessionType.p2p,
        filePath: imagePath,
        fileSize: 0,
        displayName: 'image',
        //content: 'Nice to meet you!',
        // attachment: NIMCustomMessageAttachment(
        //     data: {
        //       'key': account,
        //       'list': [1, 2, 3, 4],
        //     }
        // )
      ).then<NIMResult>((result) {
        if (result.isSuccess) {
          result.data!.config = NIMCustomMessageConfig(enablePush: true);
          return NimCore.instance.messageService
              .sendMessage(message: result.data!);
        } else {
          return result;
        }
      }).then((result) {
        print(
            'MessageService##send message: ${result.code} ${result.errorDetails}');
      });

      {
        NimCore.instance.messageService
            .deleteSession(
          sessionInfo: NIMSessionInfo(
            sessionId: friendAccount,
            sessionType: NIMSessionType.p2p,
          ),
          deleteType: NIMSessionDeleteType.local,
          sendAck: true,
        )
            .then((value) {
          print('MessageService##delete session: $value');
        });
      }

      // web暂时不支持chatRoom
      if (!kIsWeb) {
        setupChatroom();
      }

      var textMessage = await MessageBuilder.createTextMessage(
        sessionId: friendAccount,
        sessionType: NIMSessionType.p2p,
        text: '快捷评论消息',
      );

      textMessage = await NimCore.instance.messageService
          .sendMessage(message: textMessage.data!);
      var result = await NimCore.instance.messageService.addQuickComment(
          textMessage.data!,
          1,
          'ext',
          true,
          true,
          'pushTitle',
          'pushContent',
          {'key': 'value'});
      print('add quick comment result: ${result.toMap()}');

      var result2 = await NimCore.instance.messageService
          .queryQuickComment([textMessage.data!]);
      print('query quick comment result: ${result2.toMap()}');

      var result3 = await NimCore.instance.messageService.removeQuickComment(
          textMessage.data!,
          1,
          'ext',
          true,
          true,
          'pushTitle',
          'pushContent',
          {'key': 'value'});
      print('remove quick comment result: ${result3.toMap()}');

      var mySessionResult = await NimCore.instance.messageService
          .queryMySession(friendAccount, NIMSessionType.p2p);
      print('queryMySession result: ${mySessionResult.toMap()}');

      var updateMySessionResult = await NimCore.instance.messageService
          .updateMySession(friendAccount, NIMSessionType.p2p, 'new ext');
      print('updateMySession result: ${updateMySessionResult.toMap()}');

      var mySessionResult2 = await NimCore.instance.messageService
          .queryMySession(friendAccount, NIMSessionType.p2p);
      print('queryMySession2 result: ${mySessionResult2.toMap()}');

      var mySessionListResult = await NimCore.instance.messageService
          .queryMySessionList(0, 0, 1, 100, 1);
      print('queryMySessionList result: ${mySessionListResult.toMap()}');

      var deleteMySessionResult = await NimCore.instance.messageService
          .deleteMySession([
        NIMMySessionKey(
            sessionId: friendAccount, sessionType: NIMSessionType.p2p)
      ]);
      print('deleteMySession result: ${deleteMySessionResult.toMap()}');

      var mySessionResult3 = await NimCore.instance.messageService
          .queryMySession(friendAccount, NIMSessionType.p2p);
      print('queryMySession3 result: ${mySessionResult3.toMap()}');

      NimCore.instance.messageService
          .querySessionList()
          .then((value) => print("session call back"));
    });
  }

  @override
  void dispose() {
    subsriptions.forEach((subsription) {
      subsription.cancel();
    });
    super.dispose();
  }

  void sendSignalingInvite() {
    NimCore.instance.avSignallingService
        .createChannel(type: ChannelType.video)
        .then((channel) {
      print('AVSignallingService##createChannel result =  ${channel.code}');
      if (channel.isSuccess) {
        NimCore.instance.avSignallingService
            .joinChannel(
                channelId: channel.data!.channelId, offlineEnabled: true)
            .then((join) {
          print('AVSignallingService##joinChannel  result =  ${join.code}');
          if (join.isSuccess) {
            var param = InviteParam(
                channelId: channel.data!.channelId,
                accountId: friendAccount,
                requestId: '6');
            NimCore.instance.avSignallingService.invite(param).then((invite) {
              print('AVSignallingService##invite result =  ${invite.code}');
            });
          }
        });
      }
    });
  }

  void loginQChat() async {
    var result = await NimCore.instance.qChatService.login(QChatLoginParam());
    print("login qchat result => $result.");
  }

  void testForQChatServer() async {
    var antiSpamConfig = QChatAntiSpamConfig()..antiSpamBusinessId = '100';
    var param = QChatCreateServerParam("fluterQChatServer1")
      ..applyJoinMode = QChatApplyJoinMode.agreeNeed
      ..inviteMode = QChatInviteMode.agreeNeedNot
      ..custom = 'custom'
      ..searchEnable = true
      ..searchType = 1
      ..antiSpamConfig = antiSpamConfig
      ..icon = '';
    var result = await NimCore.instance.qChatServerService.createServer(param);
    print("createServer qchat result => $result.");
  }

  void logoutQChat() async {
    var result = await NimCore.instance.qChatService.logout();
    print("logout qchat result => $result.");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(),
      ),
    );
  }

  void setupChatroom() {
    var chatroomService = NimCore.instance.chatroomService;
    chatroomService.onEventNotified.listen((event) {
      print('ChatroomService##on event notified: $event');
    });

    chatroomService.onMessageStatusChanged.listen((event) {
      print(
          'ChatroomService##on message status changed: ${event.uuid} ${event.status}');
    });

    chatroomService.onMessageAttachmentProgressUpdate.listen((event) {
      print(
          'ChatroomService##on message attachment progress update: ${event.id} ${event.progress}');
    });

    chatroomService.onMessageReceived.listen((messages) {
      messages.forEach((message) {
        print(
            'ChatroomService##on message received: ${message.fromAccount} ${message.fromNickname} '
            '\'${message.content}\' ${message.extension?.nickname} ${message.extension?.senderExtension}');
        final attachment = message.messageAttachment;
        if (attachment is NIMChatroomNotificationAttachment) {
          print('ChatroomService##on notification: ${attachment.operatorNick} '
              '${NIMChatroomNotificationTypes.typeToString(attachment.type)}');
        }
        if (message.content == 'fetch room info') {
          chatroomService.fetchChatroomInfo(chatroomId).then((value) {
            print(
                'ChatroomService##fetch updated chatroom info: ${value.data?.name} '
                '${value.data?.announcement}');
          });
        }

        final setAnnouncement = RegExp(r'^set announcement (.+)$')
            .firstMatch(message.content ?? '');
        if (setAnnouncement != null) {
          chatroomService
              .updateChatroomInfo(
            roomId: chatroomId,
            request: NIMChatroomUpdateRequest(
              announcement: setAnnouncement.group(1),
            ),
            needNotify: true,
          )
              .then((value) {
            print(
                'ChatroomService##set chatroom announcement:  ${value.code} ${value.errorDetails}');
          });
        }

        final pollMessage = RegExp(r'^poll message( [0-9]*)$')
            .firstMatch(message.content ?? '');
        if (pollMessage != null) {
          chatroomService.fetchMessageHistory(
            roomId: chatroomId,
            startTime: DateTime.now().millisecondsSinceEpoch,
            limit:
                max(1, int.tryParse(pollMessage.group(1)?.trim() ?? '1') ?? 1),
            direction: QueryDirection.QUERY_OLD,
            messageTypeList: [NIMMessageType.text],
          ).then((messages) {
            var index = 0;
            messages.data?.forEach((message) {
              print(
                  'ChatroomService##message  history: ${index++} ${message.fromAccount} ${message.fromNickname} '
                  '\'${message.content}\'');
            });
          });
        }

        if (message.content == 'poll queue') {
          chatroomService.fetchChatroomQueue(chatroomId).then((value) {
            print(
                'ChatroomService##poll queue: ${value.code} ${value.errorDetails} '
                '${value.data?.map((e) => '${e.key}:${e.value}').toList()}');
          });
        }

        if (message.content == 'clear queue') {
          chatroomService.clearChatroomQueue(message.sessionId!).then((value) {
            print(
                'ChatroomService##clear queue: ${value.code} ${value.errorDetails}');
          });
        }

        final pollQueueEntry = RegExp(r'^poll queue entry (.+)$')
            .firstMatch(message.content ?? '');
        if (pollQueueEntry != null) {
          chatroomService
              .pollChatroomQueueEntry(chatroomId, pollQueueEntry.group(1))
              .then((value) {
            print(
                'ChatroomService##poll queue entry: ${value.code} ${value.errorDetails} ${value.data?.key} ${value.data?.value}');
          });
        }

        final addQueueEntry = RegExp(r'^add queue entry (.+) (.+)$')
            .firstMatch(message.content ?? '');
        if (addQueueEntry != null) {
          chatroomService
              .updateChatroomQueueEntry(
            roomId: chatroomId,
            entry: NIMChatroomQueueEntry(
              key: addQueueEntry.group(1) as String,
              value: addQueueEntry.group(2) as String,
            ),
            isTransient: true,
          )
              .then((value) {
            print(
                'ChatroomService##add queue entry: ${value.code} ${value.errorDetails}');
          });
        }

        // if (message.content == 'exit') {
        //   chatroomService.exitChatroom(message.sessionId!).then((value) {
        //     print(
        //         'ChatroomService##exit chatroom: ${value.code} ${value.errorDetails}');
        //   });
        // }

        final setNickname =
            RegExp(r'^set nickname (.+)$').firstMatch(message.content ?? '');
        if (setNickname != null) {
          chatroomService
              .updateChatroomMyMemberInfo(
            roomId: chatroomId,
            request: NIMChatroomUpdateMyMemberInfoRequest(
              nickname: setNickname.group(1) as String,
              needSave: true,
            ),
          )
              .then((value) {
            print(
                'ChatroomService##update chatroom my info:  ${value.code} ${value.errorDetails}');
          });
        }

        if (message.content == 'ping') {
          ChatroomMessageBuilder.createChatroomTextMessage(
            roomId: message.sessionId!,
            text: 'pong',
          ).then<NIMResult>((result) {
            if (result.isSuccess) {
              return chatroomService.sendChatroomMessage(result.data!);
            } else {
              return result;
            }
          }).then((value) {
            print(
                'ChatroomService##send message: ${value.code} ${value.errorDetails}');
          });
        }

        final fetchMembers = RegExp(r'^fetch members( [0-9]*)$')
            .firstMatch(message.content ?? '');
        if (fetchMembers != null) {
          chatroomService
              .fetchChatroomMembers(
            roomId: chatroomId,
            queryType: NIMChatroomMemberQueryType.values.firstWhere(
                (element) =>
                    element.index ==
                    int.tryParse(fetchMembers.group(1)?.trim() ?? '0'),
                orElse: () => NIMChatroomMemberQueryType.allNormalMember),
            limit: 10,
          )
              .then((result) {
            var index = 0;
            result.data?.forEach((member) {
              print(
                  'ChatroomService fetchChatroomMembers ##member_${index++}: ${member.account} ${member.nickname} ${member.memberType}');
            });
          });
        }

        final fetchMember =
            RegExp(r'^fetch member (.+)$').firstMatch(message.content ?? '');
        if (fetchMember != null) {
          chatroomService.fetchChatroomMembersByAccount(
              roomId: chatroomId,
              accountList: [fetchMember.group(1) as String]).then((result) {
            final member = result.data != null && result.data!.isNotEmpty
                ? result.data![0]
                : null;
            print(
                'ChatroomService fetch member: ${member?.account} ${member?.nickname} ${member?.memberType}');
          });
        }

        if (message.content == 'mute me') {
          chatroomService
              .markChatroomMemberTempMuted(
            duration: 5000,
            options: NIMChatroomMemberOptions(
              roomId: chatroomId,
              account: message.fromAccount!,
            ),
            needNotify: true,
          )
              .then((result) {
            print(
                'ChatroomService temp mute member: ${result.code} ${result.errorDetails}');
          });
        }
      });
    });

    chatroomService
        .enterChatroom(NIMChatroomEnterRequest(
      roomId: chatroomId,
      notifyExtension: {
        'senderAccount': account,
        'sendDate': DateTime.now().toString(),
        'platform': Platform.operatingSystem,
      },
      extension: {
        'senderAccount': account,
        'sendDate': DateTime.now().toString(),
        'platform': Platform.operatingSystem,
      },
    ))
        .then((value) {
      print(
          'ChatroomService##enter chatroom: ${value.code} ${value.errorDetails}');

      ChatroomMessageBuilder.createChatroomTextMessage(
        roomId: chatroomId,
        text: 'Hello everybody. This is $account',
      ).then((value) {
        chatroomService.sendChatroomMessage(value.data!).then((value) {
          print('send text chatroom message');
        });
      });
    });
  }
}
