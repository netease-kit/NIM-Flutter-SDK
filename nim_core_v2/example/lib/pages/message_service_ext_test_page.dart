// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nim_core_v2/nim_core.dart';
import 'package:universal_io/io.dart';

import '../widgets/test_case_tile.dart';

const _kFriendAccount = '345211367645440';

const _kSelfAccount = '334665458163968';

class MessageServiceExtTestPage extends StatelessWidget {
  const MessageServiceExtTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MessageService 扩展测试')),
      body: ListView(
        children: [
          // ─── insertMessageToLocalEx ────────────────────────────────────────
          TestCaseTile(
            title: '1. insertMessageToLocalEx - 插入本地消息（不发送）',
            description: '创建文本消息并插入本地数据库，验证 messageClientId 非空。Web 平台不支持。',
            onRun: () async {
              if (kIsWeb) {
                throw Exception('Web 平台不支持此接口，预期行为');
              }
              // 先获取 p2p 会话 ID
              final convResult = await NimCore.instance.conversationIdUtil
                  .p2pConversationId(_kFriendAccount);
              if (!convResult.isSuccess || convResult.data == null) {
                throw Exception('获取 conversationId 失败: ${convResult.code}');
              }
              final conversationId = convResult.data!;

              // 创建文本消息
              final msgResult =
                  await MessageCreator.createTextMessage('本地插入测试消息');
              if (!msgResult.isSuccess || msgResult.data == null) {
                throw Exception('创建消息失败: ${msgResult.code}');
              }

              final params = V2NIMMessageInsertParams(
                conversationId: conversationId,
                senderId: _kSelfAccount,
                createTime: DateTime.now().millisecondsSinceEpoch,
                lastMessageUpdateEnabled: true,
              );

              final result =
                  await NimCore.instance.messageService.insertMessageToLocalEx(
                message: msgResult.data!,
                params: params,
              );

              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final inserted = result.data;
              if (inserted == null) throw Exception('返回消息为 null');
              if (inserted.messageClientId == null ||
                  inserted.messageClientId!.isEmpty) {
                throw Exception('messageClientId 为空');
              }
              print(
                  '[insertMessageToLocalEx] clientId=${inserted.messageClientId}');
            },
          ),
          TestCaseTile(
            title: '2. insertMessageToLocalEx - conversationId 为空',
            description: '传入空 conversationId，预期接口返回失败',
            onRun: () async {
              if (kIsWeb) {
                throw Exception('Web 平台不支持此接口');
              }
              final msgResult = await MessageCreator.createTextMessage('测试消息');
              if (!msgResult.isSuccess || msgResult.data == null) {
                throw Exception('创建消息失败: ${msgResult.code}');
              }
              final params = V2NIMMessageInsertParams(
                conversationId: '',
                senderId: '334665458163968',
                createTime: DateTime.now().millisecondsSinceEpoch,
              );
              final result =
                  await NimCore.instance.messageService.insertMessageToLocalEx(
                message: msgResult.data!,
                params: params,
              );
              if (result.isSuccess) {
                throw Exception('预期失败但接口返回成功');
              }
              print(
                  '[insertMessageToLocalEx] empty convId, code=${result.code}');
            },
          ),
          // ─── clearLocalMessage ─────────────────────────────────────────────
          TestCaseTile(
            title: '3. clearLocalMessage - 清除30天前本地消息 ⚠️',
            description: '⚠️ 警告：会删除30天前的本地消息！仅 Android/iOS 支持。',
            onRun: () async {
              if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
                throw Exception('当前平台不支持此接口（仅 Android/iOS）');
              }
              final anchorTime = DateTime.now()
                  .subtract(const Duration(days: 30))
                  .millisecondsSinceEpoch;
              final params = NIMClearLocalMessageParams(
                anchorTime: anchorTime,
                deleteConversation: false,
              );
              final result = await NimCore.instance.messageService
                  .clearLocalMessage(params);
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              print('[clearLocalMessage] 30天前消息清除成功');
            },
          ),
          TestCaseTile(
            title: '4. clearLocalMessage - 同时删除会话 ⚠️',
            description:
                '⚠️ 传入 deleteConversation: true，清除昨天前消息并删除会话。仅 Android/iOS 支持。',
            onRun: () async {
              if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
                throw Exception('当前平台不支持此接口（仅 Android/iOS）');
              }
              final anchorTime = DateTime.now()
                  .subtract(const Duration(days: 1))
                  .millisecondsSinceEpoch;
              final params = NIMClearLocalMessageParams(
                anchorTime: anchorTime,
                deleteConversation: true,
              );
              final result = await NimCore.instance.messageService
                  .clearLocalMessage(params);
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              print('[clearLocalMessage] 昨天前消息清除+删除会话成功');
            },
          ),
          // ─── translateText ──────────────────────────────────────────────────
          TestCaseTile(
            title: '5. translateText - 中文翻译为英文',
            description: '传入"你好世界"，targetLanguage: "en"，验证 translatedText 非空',
            onRun: () async {
              final params = NIMTextTranslateParams(
                text: '你好世界',
                targetLanguage: 'en',
              );
              final result = await NimCore.instance.messageService
                  .translateText(params: params);
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final translated = result.data?.translatedText;
              if (translated == null || translated.isEmpty) {
                throw Exception('translatedText 为空');
              }
              print('[translateText] zh->en: "$translated"');
            },
          ),
          TestCaseTile(
            title: '6. translateText - 英文翻译为中文',
            description: '传入"Hello World"，targetLanguage: "zh-CHS"',
            onRun: () async {
              final params = NIMTextTranslateParams(
                text: 'Hello World',
                targetLanguage: 'zh-CHS',
              );
              final result = await NimCore.instance.messageService
                  .translateText(params: params);
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              final translated = result.data?.translatedText;
              if (translated == null || translated.isEmpty) {
                throw Exception('translatedText 为空');
              }
              print('[translateText] en->zh: "$translated"');
            },
          ),
          TestCaseTile(
            title: '7. translateText - 指定源语言（法语→英文）',
            description: '传入 sourceLanguage: "fr"，targetLanguage: "en"',
            onRun: () async {
              final params = NIMTextTranslateParams(
                text: 'Bonjour le monde',
                sourceLanguage: 'fr',
                targetLanguage: 'en',
              );
              final result = await NimCore.instance.messageService
                  .translateText(params: params);
              if (!result.isSuccess) {
                throw Exception(
                    'code=${result.code}, msg=${result.errorDetails}');
              }
              print('[translateText] fr->en: "${result.data?.translatedText}"');
            },
          ),
          TestCaseTile(
            title: '8. translateText - 空文本翻译（预期失败）',
            description: '传入空字符串，预期接口返回失败',
            onRun: () async {
              final params = NIMTextTranslateParams(
                text: '',
                targetLanguage: 'en',
              );
              final result = await NimCore.instance.messageService
                  .translateText(params: params);
              if (result.isSuccess &&
                  (result.data?.translatedText?.isNotEmpty == true)) {
                throw Exception(
                    '预期空文本翻译失败，但接口返回了结果：${result.data?.translatedText}');
              }
              print('[translateText] empty text, code=${result.code}');
            },
          ),
        ],
      ),
    );
  }
}
