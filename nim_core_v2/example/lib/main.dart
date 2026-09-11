// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nim_core_v2/nim_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_io/io.dart';

import 'pages/test_main_page.dart';

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

  static const teamId = '123456789';

  V2NIMChatroomClient? chatroomClient;

  final subsriptions = <StreamSubscription>[];

  final chatroomSubsriptions = <StreamSubscription>[];

  // 注意：APNs Token 现在由 SDK 自动处理，无需手动更新
  // 如需手动控制，可在 NIMIOSSDKOptions 中设置 autoUpdateApnsToken = false
  // 然后通过 NimCore.instance.apnsService.updateApnsToken() 手动更新

  String loginListener = "";

  TextEditingController accountEditingController =
      TextEditingController(text: account);

  TextEditingController passwordEditingController =
      TextEditingController(text: token);

  TextEditingController providerToken = TextEditingController();

  TextEditingController providerExtension = TextEditingController();

  TextEditingController providerTimeout = TextEditingController();

  TextEditingController reConnectEditingController = TextEditingController();

  //动态token
  String syncToken = "";

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      // APNs Token 由 SDK 自动处理，无需手动监听
      _copyResources();
    }

    subsriptions
        .add(NimCore.instance.loginService.onConnectFailed.listen((event) {
      print('LoginService##onConnectFailed: ${event.toJson()}');
      setState(() {
        loginListener = loginListener +
            '\n LoginService##onConnectFailed: ${event.toJson()}';
      });
    }));

    subsriptions
        .add(NimCore.instance.loginService.onDisconnected.listen((event) {
      print('LoginService##onDisconnected: ${event.toJson()}');
      setState(() {
        loginListener = loginListener +
            '\n LoginService##onDisconnected: ${event.toJson()}';
      });
    }));

    subsriptions
        .add(NimCore.instance.loginService.onLoginFailed.listen((event) {
      print('LoginService##onLoginFailed: ${event.toJson()}');
      setState(() {
        loginListener =
            loginListener + '\n LoginService##onLoginFailed: ${event.toJson()}';
      });
    }));

    subsriptions
        .add(NimCore.instance.loginService.onLoginStatus.listen((event) {
      print('LoginService##onLoginStatus: ${event.name}');
      setState(() {
        loginListener =
            loginListener + '\n LoginService##onLoginStatus: ${event.name}';
      });
    }));

    _doInitializeSDK();
  }

  void _doInitializeSDK() async {
    late NIMSDKOptions options;
    if (kIsWeb) {
      var base = NIMInitializeOptions(
        appkey: appKey,
        apiVersion: 'v2',
        debugLevel: 'debug',
      );
      options = NIMWebSDKOptions(
        appKey: appKey,
        initializeOptions: base,
      );
    } else if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      options = NIMAndroidSDKOptions(
          appKey: appKey,
          enableUserInfoProvider: true,
          enableMessageNotifierCustomization: true,
          shouldSyncStickTopSessionInfos: true,
          consoleLogEnabled: true,
          sdkRootDir: directory != null ? '${directory.path}/NIMFlutter' : null,
          mixPushConfig: _buildMixPushConfig());
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      options = NIMIOSSDKOptions(
        appKey: appKey,
        shouldSyncStickTopSessionInfos: true,
        sdkRootDir: '${directory.path}/NIMFlutter',
        apnsCername: 'ENTERPRISE',
        pkCername: 'DEMO_PUSH_KIT',
      );
    } else if (Platform.isMacOS || Platform.isWindows) {
      NIMBasicOption basicOption = NIMBasicOption();
      options = NIMPCSDKOptions(basicOption: basicOption, appKey: appKey);
    } else if (kIsWeb) {
      var base = NIMInitializeOptions(
        appkey: appKey,
      );
      options = NIMWebSDKOptions(
        appKey: appKey,
        initializeOptions: base,
      );
    }
    // else {
    //   options = NIMOHOSSDKOptions(
    //     appKey: appKey,
    //   );
    // }
    NimCore.instance.initialize(options).then((value) async {
      print('initialize result: $value');
    });
  }

  Future<String> getTokenFromServer(String account) async {
    var requestBody = {"appkey": appKey, "accid": account};

    var header = <String, String>{
      'content-type': 'application/x-www-form-urlencoded'
    };

    var url = Uri.parse(
        "http://imtest.netease.im/nimserver/god/mockDynamicToken.action");
    var response = await http.post(url, headers: header, body: requestBody);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      int code = responseData["code"];
      if (code != 200) {
        return "";
      }
      String token = responseData["data"];
      return token;
    } else {
      return "";
    }
  }

  Future<dynamic> createImgMsg() async {
    html.File? imageObj;
    String imageUrl =
        'https://img2.baidu.com/it/u=1008561530,2313586183&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1730';
    http.Response response = await http.get(Uri.parse(imageUrl));
    var blob = html.Blob([response.bodyBytes], 'image/jpeg', 'native');
    imageObj = html.File([blob], 'image.jpg');

    return MessageCreator.createImageMessage(
      '',
      'name',
      '',
      40,
      40,
      imageObj: imageObj,
    );
  }

  @override
  void dispose() {
    subsriptions.forEach((subsription) {
      subsription.cancel();
    });
    // 取消推送 Token 监听
    _mixPushTokenSubscription?.cancel();
    _mixPushTokenSubscription = null;
    // 取消消息监听
    _receiveMessagesSubscription?.cancel();
    _receiveMessagesModifiedSubscription?.cancel();
    super.dispose();
  }

  void loginNormal() async {
    var options = NIMLoginOption();

    NimCore.instance.loginService.loginExtensionProvider =
        (String accountId) async {
      print('dart loginExtensionProvider');
      return "abd/$accountId";
    };

    final loginResult = await NimCore.instance.loginService.login(
        accountEditingController.text, passwordEditingController.text, options);
    print('login result: $loginResult');
  }

  void loginOffModel() async {
    var options = NIMLoginOption();
    options.offlineMode = true;
    NimCore.instance.loginService.loginExtensionProvider =
        (String accountId) async {
      print('dart offlineMode loginExtensionProvider');
      return "abd/$accountId";
    };

    final loginResult = await NimCore.instance.loginService.login(
        accountEditingController.text, passwordEditingController.text, options);
    loginListener = loginListener + '\n loginService##result: $loginResult';
    print('login result: $loginResult');
  }

  void loginSync() async {
    var options = NIMLoginOption();

    options.authType = NIMLoginAuthType.authTypeDynamicToken;

    NimCore.instance.loginService.tokenProvider = (String accountId) async {
      print('login sync token : $accountId');
      return providerToken.text;
    };

    NimCore.instance.loginService.loginExtensionProvider =
        (String accountId) async {
      print('dart loginExtensionProvider');
      return providerExtension.text;
    };

    NimCore.instance.loginService.setReconnectDelayProvider((int time) async {
      print('dart setReconnectDelayProvider');
      return int.parse(providerTimeout.text);
    });

    final loginResult = await NimCore.instance.loginService.login(
        accountEditingController.text, passwordEditingController.text, options);
    print('login syncToken result: $loginResult');
  }

  ///发送文本消息
  void sendP2PTextMessage() async {
    final message =
        (await MessageCreator.createTextMessage('P2p text test message')).data;
    final conversationId = (await NimCore.instance.conversationIdUtil
            .p2pConversationId(friendAccount))
        .data!;
    if (message != null) {
      message.pushConfig = NIMMessagePushConfig(forcePush: true);
      final sendMessageResult = await NimCore.instance.messageService
          .sendMessage(message: message, conversationId: conversationId);
      if (sendMessageResult.isSuccess) {
        print(
            'fdsfsendMessage result: ${sendMessageResult.isSuccess} data ${sendMessageResult.data?.toJson()}');
      }
    }
  }

  void setCurrentConversation() async {
    final conversationIdResult = await NimCore.instance.conversationIdUtil
        .p2pConversationId(friendAccount);
    final conversationId = conversationIdResult.data;
    if (!conversationIdResult.isSuccess || conversationId == null) {
      print(
          'setCurrentConversation 获取会话 ID 失败: code=${conversationIdResult.code}, error=${conversationIdResult.errorDetails}');
      return;
    }

    final result = await NimCore.instance.localConversationService
        .setCurrentConversation(conversationId);
    print(
        'setCurrentConversation result: ${result.isSuccess}, conversationId=$conversationId, code=${result.code}, error=${result.errorDetails}');
  }

  void searchMessage() async {
    final conversationId = (await NimCore.instance.conversationIdUtil
            .p2pConversationId(friendAccount))
        .data;

    NimCore.instance.messageService
        .searchLocalMessages(NIMMessageSearchExParams(
            conversationId: conversationId,
            keywordList: ['P2p text'],
            limit: 5))
        .then((result) {
      print('Test searchLocalMessages result ${result.isSuccess}');
      if (result.isSuccess && result.data != null) {
        print('Test searchLocalMessages success');
        result.data?.items?.forEach((e) {
          e.messages?.forEach((message) {
            print('Test searchLocalMessages result = ${message.text}');
          });
        });
      }
    });
  }

  void setMessageFilter() {
    NimCore.instance.messageService.onReceiveMessages.listen((messages) {
      for (var message in messages) {
        print('Filter onReceiveMessages: ${message.toJson()}');
      }
    });

    NimCore.instance.messageService.setMessageFilter((message) async {
      print('setMessageFilter: ${message.toJson()}');
      if (message.messageType == NIMMessageType.notification) {
        return true;
      }
      return false;
    });
  }

  void searchMessageLocal() async {
    final conversationId =
        (await NimCore.instance.conversationIdUtil.teamConversationId(teamId))
            .data;
    final params = NIMMessageSearchExParams(
        conversationId: conversationId, keywordList: ['test'], limit: 10);
    NimCore.instance.messageService.searchLocalMessages(params).then((result) {
      print('searchMessageLocal message size = ${result.data?.count}');
    });
  }

  void searchMessageCloud() async {
    final conversationId =
        (await NimCore.instance.conversationIdUtil.teamConversationId(teamId))
            .data;
    final params = NIMMessageSearchExParams(
        pageToken: '',
        conversationId: conversationId,
        keywordList: ['test'],
        limit: 10);
    NimCore.instance.messageService
        .searchCloudMessagesEx(params)
        .then((result) {
      print('searchMessageCloud message size = ${result.data?.count}');
    });
  }

  //创建聊天室并进入
  void createChatroom() async {
    chatroomClient = (await V2NIMChatroomClient.newInstance()).data;
    print('chatroom: ${chatroomClient?.instanceId}');

    if (chatroomClient != null) {
      chatroomClient!.addChatroomClientListener();

      chatroomSubsriptions.addAll([
        chatroomClient!.onChatroomEntered.listen((event) {
          print('ChatroomClient:onChatroomEntered');
        }),
        chatroomClient!.onChatroomExited.listen((event) {
          print('ChatroomClient:onChatroomExited');
        })
      ]);

      final links = await NimCore.instance.loginService
          .getChatroomLinkAddress(chatroomId1);

      Alog.d(
          tag: 'ChatroomClient',
          content: 'enter result:${links?.isSuccess} data ${links?.data}');

      final enterParams = V2NIMChatroomEnterParams(
          authType: NIMLoginAuthType.authTypeDefault,
          accountId: account,
          token: token);

      chatroomClient!.linkProvider =
          (int instanceId, String roomId, String accountId) async {
        return links.data!;
      };

      final enterResult = await chatroomClient!.enter(chatroomId1, enterParams);

      print(
          'enter result:${enterResult?.isSuccess} data ${enterResult?.data?.toJson()}');

      Alog.d(
          tag: 'ChatroomClient',
          content:
              'enter result:${enterResult?.isSuccess} data ${enterResult?.data?.toJson()}');

      final chatroomInfoResult = await chatroomClient?.getChatroomInfo();

      print(
          'chatroomInfo result: ${chatroomInfoResult?.isSuccess} data ${chatroomInfoResult?.data?.toJson()}');

      Alog.d(
          tag: 'ChatroomClient',
          content:
              'chatroomInfo result: ${chatroomInfoResult?.isSuccess} data ${chatroomInfoResult?.data?.toJson()}');
    }
  }

  void getMessageList() async {
    String? conversationId =
        (await NimCore.instance.conversationIdUtil.teamConversationId(teamId))
            .data;
    NIMMessageListOption option =
        NIMMessageListOption(conversationId: conversationId);
    NimCore.instance.messageService
        .getMessageList(option: option)
        .then((result) {
      print(
          'getMessageList flutter result: ${result.isSuccess} data ${result.data?.length}');
    });
  }

  //添加监听
  void chatroomServiceListener() async {
    final addresult =
        await chatroomClient?.getChatroomService().addChatroomListener();

    chatroomSubsriptions.addAll([
      chatroomClient!.getChatroomService().onReceiveMessages.listen((event) {
        print('getChatroomService:onReceiveMessages');
      }),
      chatroomClient!.getChatroomService().onSendMessage.listen((event) {
        print('getChatroomService:onSendMessage ${event.message?.toJson()}');
      }),
      chatroomClient!
          .getChatroomService()
          .onSendMessageProgress
          .listen((event) {
        print(
            'getChatroomService:onSendMessageProgress  ${event.messageClientId} process ${event.progress}');
      }),
    ]);
  }

  void sendChatroomTextMessage() async {
    final message = (await V2NIMChatroomMessageCreator.createTextMessage(
            'test text chatroom message'))
        .data;

    final chatroomService = chatroomClient?.getChatroomService();

    if (message != null) {
      V2NIMSendChatroomMessageParams params = V2NIMSendChatroomMessageParams();
      final messageSender = await chatroomService?.sendMessage(message, params);
      print(
          'messageSender: ${messageSender?.isSuccess} data ${messageSender?.data?.toJson()}');
      Alog.d(
          tag: 'ChatroomService',
          content:
              'messageSender: ${messageSender?.isSuccess} data ${messageSender?.data?.toJson()}');
    }
  }

  void sendChatroomVideoMessage() async {
    final videoPath = Platform.isAndroid
        ? (await getExternalStorageDirectory())!.path + "/test.mp4"
        : (await getApplicationDocumentsDirectory()).path + "/test.mp4";

    if (!File(videoPath).existsSync()) {
      print('File $videoPath 不存在');
    }

    final message = (await V2NIMChatroomMessageCreator.createVideoMessage(
            videoPath,
            duration: 70000,
            width: 102,
            height: 150))
        .data;

    final chatroomService = chatroomClient?.getChatroomService();

    if (message != null) {
      V2NIMSendChatroomMessageParams params = V2NIMSendChatroomMessageParams();
      final messageSender = await chatroomService?.sendMessage(message, params);
      print(
          'messageSender: ${messageSender?.isSuccess} data ${messageSender?.data?.toJson()}');
      Alog.d(
          tag: 'ChatroomService',
          content:
              'messageSender: ${messageSender?.isSuccess} data ${messageSender?.data?.toJson()}');
    }
  }

  void sendChatroomImageMessage() async {
    final imagePath = Platform.isAndroid
        ? (await getExternalStorageDirectory())!.path + "/test.jpg"
        : (await getApplicationDocumentsDirectory()).path + "/test.jpg";

    if (!File(imagePath).existsSync()) {
      print('File $imagePath 不存在');
    }

    final message = (await V2NIMChatroomMessageCreator.createImageMessage(
            imagePath,
            width: 0,
            height: 0))
        .data;

    final chatroomService = chatroomClient?.getChatroomService();

    if (message != null) {
      V2NIMSendChatroomMessageParams params = V2NIMSendChatroomMessageParams();
      final messageSender = await chatroomService?.sendMessage(message, params);
      print(
          'messageSender: ${messageSender?.isSuccess} data ${messageSender?.data?.toJson()}');
      Alog.d(
          tag: 'ChatroomService',
          content:
              'messageSender: ${messageSender?.isSuccess} data ${messageSender?.data?.toJson()}');
    }
  }

  void sendChatroomAudioMessage() async {
    final audioPath = Platform.isAndroid
        ? (await getExternalStorageDirectory())!.path + "/test.mp3"
        : (await getApplicationDocumentsDirectory()).path + "/test.mp3";

    if (!File(audioPath).existsSync()) {
      print('File $audioPath 不存在');
    }

    final message = (await V2NIMChatroomMessageCreator.createAudioMessage(
            audioPath,
            duration: 6000))
        .data;

    final chatroomService = chatroomClient?.getChatroomService();

    if (message != null) {
      V2NIMSendChatroomMessageParams params = V2NIMSendChatroomMessageParams();
      final audioMessageSender =
          await chatroomService?.sendMessage(message, params);
      print(
          'audioMessageSender: ${audioMessageSender?.isSuccess} data ${audioMessageSender?.data?.toJson()}');
      Alog.d(
          tag: 'ChatroomService',
          content:
              'audioMessageSender: ${audioMessageSender?.isSuccess} data ${audioMessageSender?.data?.toJson()}');
    }
  }

  // void getMessageList() async {
  //   final chatroomService = chatroomClient?.getChatroomService();
  //   if (chatroomService != null) {
  //     final option = V2NIMChatroomMessageListOption(limit: 2);
  //     final messageList = (await chatroomService.getMessageList(option));
  //     if (messageList.data != null) {
  //       messageList.data!.forEach((message) {
  //         print('messageList : ${message.toJson()}');
  //       });
  //     }
  //   }
  // }

  void addQueueListener() {
    final chatroomQueue = chatroomClient?.getChatroomQueueService();
    chatroomQueue?.addQueueListener();
    chatroomSubsriptions.addAll([
      chatroomQueue!.onChatroomQueueOffered.listen((event) {
        print('onChatroomQueueOffered: ${event.toJson()}');
      }),
      chatroomQueue.onChatroomQueuePolled.listen((event) {
        print('onChatroomQueuePolled: ${event.toJson()}');
      }),
      chatroomQueue.onChatroomQueueBatchUpdated.listen((event) {
        print('onChatroomQueueBatchUpdated: ${event.length}');
      })
    ]);
  }

  void queueOffer() async {
    final params = V2NIMChatroomQueueOfferParams(
        elementKey: 'testKey', elementValue: 'testValue');
    final chatroomQueue = chatroomClient?.getChatroomQueueService();
    final result = await chatroomQueue?.queueOffer(params);
    print('queueOffer result: ${result?.isSuccess} data ');
  }

  void queuePeek() async {
    final chatroomQueue = chatroomClient?.getChatroomQueueService();
    final result = await chatroomQueue?.queuePeek();
    print(
        'queuePeek result: ${result?.isSuccess} data ${result?.data?.toJson()}');
    final updateResult = await chatroomQueue?.queueBatchUpdate([result!.data!]);
    print('queueBatchUpdate result: ${updateResult?.isSuccess} data');
  }

  void queueInit() async {
    final chatroomQueue = chatroomClient?.getChatroomQueueService();
    final result = await chatroomQueue?.queueInit(3);
    print('queueInit result: ${result?.isSuccess} ');
  }

  void queueList() async {
    final chatroomQueue = chatroomClient?.getChatroomQueueService();
    final result = await chatroomQueue?.queueList();
    print(
        'queueList result: ${result?.isSuccess} data ${result?.data?.length}');
  }

  void getAIUserList() async {
    NimCore.instance.aiService.getAIUserList().then((result) {
      print('getAIUserList result: ${result.isSuccess}');
      if (result.data?.isNotEmpty == true) {
        for (var element in result.data!) {
          print('getAIUserList element: ${element.toJson()}');
        }
      }
    });
  }

  void _copyResources() async {
    // copy image
    var bytes = await rootBundle.load("resources/test.jpg");
    Directory? documentDir = await getApplicationDocumentsDirectory();
    File tempFile = new File("${documentDir?.path}/test.jpg");
    if (!tempFile.existsSync()) {
      tempFile.createSync();
    }
    tempFile.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    // copy mp3
    bytes = await rootBundle.load("resources/test.mp3");
    tempFile = new File("${documentDir?.path}/test.mp3");
    if (!tempFile.existsSync()) {
      tempFile.createSync();
    }
    tempFile.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    // copy mp4
    bytes = await rootBundle.load("resources/test.mp4");
    tempFile = new File("${documentDir?.path}/test.mp4");
    if (!tempFile.existsSync()) {
      tempFile.createSync();
    }
    tempFile.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
  }

  /// 注册手动提供 Token 回调
  bool _isManualTokenCallbackRegistered = false;

  void _registerManualTokenCallback() {
    if (_isManualTokenCallbackRegistered) {
      // 已注册，传 null 取消
      NimCore.instance.mixPushService
          .registerManuallyProvidePushTokenCallback(null);
      _isManualTokenCallbackRegistered = false;
      print('手动 Token 回调已取消');
      setState(() {
        loginListener = loginListener + '\n 🔕 手动 Token 回调已取消';
      });
    } else {
      // 未注册，注册回调
      NimCore.instance.mixPushService.registerManuallyProvidePushTokenCallback(
        (pushType) {
          print('收到手动 Token 请求, pushType: $pushType');
          // 注意：这里不能使用 setState，因为回调可能在后台线程执行

          // 这里模拟返回一个测试 Token
          // 实际场景中应该根据 pushType 从对应厂商 SDK 获取真实 Token
          return NIMMixPushToken(
            pushType: pushType,
            token:
                'aq/LX2Yijj3DxfJ/sNGIKq/tKS9/F/XvHo1jgrGYxfEJEb4rZlSQFo8v8xSNLGs7',
          );
        },
      );
      _isManualTokenCallbackRegistered = true;
      print('手动 Token 回调已注册');
      setState(() {
        loginListener = loginListener + '\n 🔔 手动 Token 回调已注册';
      });
    }
  }

  /// 消息监听订阅
  StreamSubscription<List<NIMMessage>>? _receiveMessagesSubscription;
  StreamSubscription<List<NIMMessage>>? _receiveMessagesModifiedSubscription;

  /// 监听推送 Token 变化事件
  ///
  /// 订阅 onMixPushToken 事件流，当推送 Token 发生变化时会收到回调
  /// 适用于：
  /// 1. 正常模式：SDK 自动获取厂商 Token 后通知
  /// 2. 手动模式：手动提供 Token 后确认生效
  StreamSubscription<NIMMixPushToken>? _mixPushTokenSubscription;

  void _observeMixPushToken() {
    // 避免重复订阅
    if (_mixPushTokenSubscription != null) {
      print('推送 Token 监听已存在，请勿重复注册');
      setState(() {
        loginListener = loginListener + '\n ⚠️ 推送 Token 监听已存在';
      });
      return;
    }

    _mixPushTokenSubscription =
        NimCore.instance.mixPushService.onMixPushToken.listen(
      (token) {
        print('收到推送 Token 变化通知:');
        print('  - pushType: ${token.pushType}');
        print('  - token: ${token.token}');
        print('  - tokenName: ${token.tokenName}');

        setState(() {
          loginListener = loginListener +
              '\n ✅ 收到推送 Token:' +
              '\n    pushType: ${token.pushType}' +
              '\n    token: ${_truncateToken(token.token)}' +
              '\n    tokenName: ${token.tokenName ?? "N/A"}';
        });
      },
      onError: (error) {
        print('推送 Token 监听发生错误: $error');
        setState(() {
          loginListener = loginListener + '\n ❌ 推送 Token 监听错误: $error';
        });
      },
    );

    print('推送 Token 监听已注册');
    setState(() {
      loginListener = loginListener + '\n 🔔 推送 Token 监听已注册';
    });
  }

  /// 截断过长的 Token 用于显示
  String _truncateToken(String? token) {
    if (token == null || token.isEmpty) return 'N/A';
    if (token.length <= 20) return token;
    return '${token.substring(0, 10)}...${token.substring(token.length - 10)}';
  }

  /// 打印 streamConfig 完整内容到控制台
  void _printStreamConfig(V2NIMMessageStreamConfig? streamConfig) {
    print('  - streamConfig: ${streamConfig != null ? "存在" : "null"}');
    if (streamConfig != null) {
      // 1. 流式消息状态
      print('    - status: ${streamConfig.status}');

      // 2. 最近一个分片 lastChunk
      final lastChunk = streamConfig.lastChunk;
      print('    - lastChunk: ${lastChunk != null ? "存在" : "null"}');
      if (lastChunk != null) {
        print('      - content: ${lastChunk.content}');
        print('      - type: ${lastChunk.type}');
        print('      - index: ${lastChunk.index}');
        print('      - messageTime: ${lastChunk.messageTime}');
        print('      - chunkTime: ${lastChunk.chunkTime}');
      }

      // 3. RAG 引用资源列表
      final rags = streamConfig.rags;
      print('    - rags: ${rags != null ? "${rags.length} 个" : "null"}');
      if (rags != null && rags.isNotEmpty) {
        for (var i = 0; i < rags.length; i++) {
          final rag = rags[i];
          print('      [$i] name: ${rag.name}');
          print('          title: ${rag.title}');
          print('          description: ${rag.description}');
          print('          url: ${rag.url}');
          print('          icon: ${rag.icon}');
          print('          time: ${rag.time}');
        }
      }
    }
  }

  /// 构建 streamConfig 信息用于界面显示
  String _buildStreamConfigInfo(V2NIMMessageStreamConfig? streamConfig) {
    if (streamConfig == null) {
      return '\n    streamConfig: ❌ null';
    }

    final buffer = StringBuffer();
    buffer.write('\n    streamConfig: ✅ 存在');

    // 1. 状态
    buffer.write('\n      - status: ${streamConfig.status}');

    // 2. lastChunk
    final lastChunk = streamConfig.lastChunk;
    if (lastChunk != null) {
      buffer.write('\n      - lastChunk: ✅ 存在');
      buffer.write('\n        - content: ${_truncateToken(lastChunk.content)}');
      buffer.write('\n        - type: ${lastChunk.type}');
      buffer.write('\n        - index: ${lastChunk.index}');
      buffer.write('\n        - messageTime: ${lastChunk.messageTime}');
      buffer.write('\n        - chunkTime: ${lastChunk.chunkTime}');
    } else {
      buffer.write('\n      - lastChunk: null');
    }

    // 3. rags
    final rags = streamConfig.rags;
    if (rags != null && rags.isNotEmpty) {
      buffer.write('\n      - rags: ${rags.length} 个');
      for (var i = 0; i < rags.length && i < 2; i++) {
        // 最多显示2个
        final rag = rags[i];
        buffer.write('\n        [$i] name: ${rag.name}');
        buffer.write('\n            title: ${_truncateToken(rag.title)}');
        buffer.write('\n            url: ${_truncateToken(rag.url)}');
      }
      if (rags.length > 2) {
        buffer.write('\n        ... 还有 ${rags.length - 2} 个');
      }
    } else {
      buffer.write('\n      - rags: ${rags == null ? "null" : "空列表"}');
    }

    return buffer.toString();
  }

  /// 取消推送 Token 监听
  void _cancelMixPushTokenObserver() {
    if (_mixPushTokenSubscription != null) {
      _mixPushTokenSubscription!.cancel();
      _mixPushTokenSubscription = null;
      print('推送 Token 监听已取消');
      setState(() {
        loginListener = loginListener + '\n 🔕 推送 Token 监听已取消';
      });
    } else {
      print('没有活跃的推送 Token 监听');
      setState(() {
        loginListener = loginListener + '\n ⚠️ 没有活跃的推送 Token 监听';
      });
    }
  }

  /// 是否已开启消息监听
  bool _isMessageListenerRegistered = false;

  /// 注册消息监听 (onReceiveMessages & onReceiveMessagesModified)
  void _registerMessageListener() {
    if (_isMessageListenerRegistered) {
      // 已注册，取消监听
      _cancelMessageListener();
      return;
    }

    final messageService = NimCore.instance.messageService;

    // 监听接收消息 onReceiveMessages
    _receiveMessagesSubscription = messageService.onReceiveMessages.listen(
      (messages) {
        print('onReceiveMessages: 收到新消息 ${messages.length} 条');
        for (var msg in messages) {
          print('  - 发送者: ${msg.senderId}');
          print('  - 类型: ${msg.messageType}');
          print('  - 内容: ${msg.text ?? "[非文本]"}');
          print('  - messageClientId: ${msg.messageClientId}');
          // 打印 streamConfig 完整内容
          _printStreamConfig(msg.streamConfig);
        }

        final firstMsg = messages.firstOrNull;
        final streamInfo = _buildStreamConfigInfo(firstMsg?.streamConfig);

        setState(() {
          loginListener = loginListener +
              '\n 📩 onReceiveMessages: ${messages.length} 条' +
              '\n    发送者: ${firstMsg?.senderId ?? "N/A"}' +
              '\n    类型: ${firstMsg?.messageType}' +
              '\n    内容: ${_truncateToken(firstMsg?.text)}' +
              streamInfo;
        });
      },
      onError: (error) {
        print('onReceiveMessages 监听错误: $error');
        setState(() {
          loginListener = loginListener + '\n ❌ onReceiveMessages 错误: $error';
        });
      },
    );

    // 监听消息修改 onReceiveMessagesModified
    _receiveMessagesModifiedSubscription =
        messageService.onReceiveMessagesModified.listen(
      (messages) {
        print('onReceiveMessagesModified: 消息被修改 ${messages.length} 条');
        for (var msg in messages) {
          print('  - messageClientId: ${msg.messageClientId}');
          print('  - 类型: ${msg.messageType}');
          print('  - 发送者: ${msg.senderId}');
          // 打印 streamConfig 完整内容
          _printStreamConfig(msg.streamConfig);
        }

        final firstMsg = messages.firstOrNull;
        final streamInfo = _buildStreamConfigInfo(firstMsg?.streamConfig);

        setState(() {
          loginListener = loginListener +
              '\n ✏️ onReceiveMessagesModified: ${messages.length} 条' +
              '\n    messageClientId: ${firstMsg?.messageClientId ?? "N/A"}' +
              '\n    发送者: ${firstMsg?.senderId}' +
              '\n    类型: ${firstMsg?.messageType}' +
              streamInfo;
        });
      },
      onError: (error) {
        print('onReceiveMessagesModified 监听错误: $error');
        setState(() {
          loginListener =
              loginListener + '\n ❌ onReceiveMessagesModified 错误: $error';
        });
      },
    );

    _isMessageListenerRegistered = true;
    print('消息监听已注册 (onReceiveMessages & onReceiveMessagesModified)');
    setState(() {
      loginListener = loginListener + '\n 🔔 消息监听已注册';
    });
  }

  /// 取消消息监听
  void _cancelMessageListener() {
    _receiveMessagesSubscription?.cancel();
    _receiveMessagesSubscription = null;

    _receiveMessagesModifiedSubscription?.cancel();
    _receiveMessagesModifiedSubscription = null;

    _isMessageListenerRegistered = false;
    print('消息监听已取消');
    setState(() {
      loginListener = loginListener + '\n 🔕 消息监听已取消';
    });
  }

  /// 构建推送配置（参考 im_demo 配置）
  NIMMixPushConfig _buildMixPushConfig() {
    return NIMMixPushConfig(
      // xiaomi
      xmAppId: '2882303761520055541',
      xmAppKey: '5222005592541',
      xmCertificateName: 'KIT_FLUTTER_MI_PUSH',
      // huawei
      hwAppId: '106776305',
      hwCertificateName: 'KIT_FLUTTER_HW_PUSH',
      // meizu
      mzAppId: '149497',
      mzAppKey: '59aea173afc94791ad271f7d51e4bded',
      mzCertificateName: 'KIT_FLUTTER_MEIZU_PUSH',
      // vivo
      vivoCertificateName: 'KIT_FLUTTER_VIVO_PUSH',
      // oppo
      oppoAppId: '30853511',
      oppoAppKey: 'b2fe114b4f744f0ca6855731d18a2d54',
      oppoAppSecret: 'dc093c8c4d154722a75cc3a69af73ce9',
      oppoCertificateName: 'KIT_FLUTTER_OPPO_PUSH',
      // 启用手动提供 Push Token 模式
      manualProvidePushToken: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text('登录回调'),
              Text(
                loginListener,
                maxLines: 6,
              ),
              Text('账号'),
              TextField(
                controller: accountEditingController,
              ),
              Text('token'),
              TextField(
                controller: passwordEditingController,
              ),
              Text('动态token'),
              TextField(
                controller: providerToken,
              ),
              Text('登录扩展'),
              TextField(
                controller: providerExtension,
              ),
              Text('登录重连延时回调'),
              TextField(
                controller: providerTimeout,
                keyboardType: TextInputType.number, // 弹出数字键盘
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly // 只允许输入数字
                ],
              ),
              TextButton(
                  onPressed: () {
                    loginNormal();
                  },
                  child: Text('普通登录')),
              TextButton(
                  onPressed: () {
                    loginOffModel();
                  },
                  child: Text('离线登录')),
              TextButton(
                  onPressed: () {
                    sendP2PTextMessage();
                  },
                  child: Text('发送消息')),
              TextButton(
                  onPressed: () {
                    setCurrentConversation();
                  },
                  child: Text('设置当前会话')),
              TextButton(
                  onPressed: () {
                    searchMessage();
                  },
                  child: Text('搜索消息')),
              TextButton(
                  onPressed: () {
                    searchMessageLocal();
                  },
                  child: Text('本地查询')),
              TextButton(
                  onPressed: () {
                    searchMessageCloud();
                  },
                  child: Text('云端查询')),
              TextButton(
                  onPressed: () {
                    getAIUserList();
                  },
                  child: Text('获取AI用户')),
              // TextButton(
              //     onPressed: () {
              //       chatroomServiceListener();
              //     },
              //     child: Text('添加聊天室服务')),
              // TextButton(
              //     onPressed: () {
              //       addQueueListener();
              //     },
              //     child: Text('添加队列监听')),
              // TextButton(
              //     onPressed: () {
              //       queueInit();
              //     },
              //     child: Text('初始化队列')),
              // TextButton(
              //     onPressed: () {
              //       queueOffer();
              //     },
              //     child: Text('新增队列')),
              // TextButton(
              //     onPressed: () {
              //       queueList();
              //     },
              //     child: Text('拉取队列')),
              // TextButton(
              //     onPressed: () {
              //       queuePeek();
              //     },
              //     child: Text('更新队列')),
              // TextButton(
              //     onPressed: () {
              //       sendChatroomTextMessage();
              //     },
              //     child: Text('发送消息')),
              // TextButton(
              //     onPressed: () {
              //       sendChatroomImageMessage();
              //     },
              //     child: Text('发送图片消息')),
              // TextButton(
              //     onPressed: () {
              //       sendChatroomVideoMessage();
              //     },
              //     child: Text('发送视频消息')),
              // TextButton(
              //     onPressed: () {
              //       sendChatroomAudioMessage();
              //     },
              //     child: Text('发送语音消息')),
              TextButton(
                  onPressed: () {
                    _registerManualTokenCallback();
                  },
                  child: Text(_isManualTokenCallbackRegistered
                      ? '取消手动Token回调'
                      : '注册手动Token回调')),
              TextButton(
                  onPressed: () {
                    _observeMixPushToken();
                  },
                  child: Text('监听推送Token')),
              TextButton(
                  onPressed: () {
                    _cancelMixPushTokenObserver();
                  },
                  child: Text('取消Token监听')),
              TextButton(
                  onPressed: () {
                    _registerMessageListener();
                  },
                  child:
                      Text(_isMessageListenerRegistered ? '取消消息监听' : '注册消息监听')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      loginListener = "";
                    });
                  },
                  child: Text('清空回调信息')),
              // ─── 接口测试入口 ──────────────────────────────────────────────
              Builder(
                  builder: (ctx) => ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(ctx).push(
                          MaterialPageRoute(
                              builder: (_) => const TestMainPage()),
                        );
                      },
                      icon: const Text('📋'),
                      label: const Text('接口测试'))),
            ],
          ),
        ),
      ),
    );
  }
}
