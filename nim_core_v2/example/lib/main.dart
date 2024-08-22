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
import 'package:nim_core_v2/nim_core.dart';
import 'package:path_provider/path_provider.dart';

import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;

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
      //TODO update APNs token
      //NimCore.instance.settingsService.updateAPNSToken(_deviceToken!, null);
    }
  }

  String loginListener = "";

  TextEditingController accountEditingController =
      TextEditingController(text: account);

  TextEditingController passwordEditingController =
      TextEditingController(text: token);

  TextEditingController reConnectEditingController = TextEditingController();

  //动态token
  String syncToken = "";

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
        .add(NimCore.instance.conversationService.onSyncFailed.listen((e) {
      print('conversationService##onSyncFailed: ');
      setState(() {
        loginListener =
            loginListener + '\n conversationService##onSyncFailed: ';
      });
    }));

    subsriptions.add(NimCore.instance.teamService.onSyncFailed.listen((e) {
      print('teamService##onSyncFailed: ');
      setState(() {
        loginListener = loginListener + '\n teamService##onSyncFailed: ';
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

  void loginSync() async {
    var options = NIMLoginOption();

    options.authType = NIMLoginAuthType.authTypeDynamicToken;

    NimCore.instance.loginService.tokenProvider = (String accountId) async {
      print('login sync token : $accountId');
      return 'georgeSYncToken';
    };

    NimCore.instance.loginService.loginExtensionProvider =
        (String accountId) async {
      print('dart loginExtensionProvider');
      return "abd/$accountId";
    };

    final loginResult = await NimCore.instance.loginService.login(
        accountEditingController.text, passwordEditingController.text, options);
    print('login syncToken result: $loginResult');
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
              Text(syncToken),
              TextButton(
                  onPressed: () {
                    loginNormal();
                  },
                  child: Text('普通登录')),
              TextButton(
                  onPressed: () {
                    loginSync();
                  },
                  child: Text('动态token登录')),
              Text('重连次数'),
              TextField(
                controller: reConnectEditingController,
                keyboardType: TextInputType.number,
              ),
              TextButton(
                  onPressed: () {
                    NimCore.instance.loginService
                        .setReconnectDelayProvider((time) async {
                      int inputNum = int.parse(reConnectEditingController.text);
                      print(
                          "getReconnectDelay flutter result ${time + inputNum}");
                      return time + inputNum;
                    });
                  },
                  child: Text('设置重连次数')),
            ],
          ),
        ),
      ),
    );
  }
}
