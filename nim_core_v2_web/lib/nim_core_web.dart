// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

import 'src/services/web_ai_service.dart';
import 'src/services/web_client_antispam_util.dart';
import 'src/services/web_conversation_group_service.dart';
import 'src/services/web_conversation_id_util.dart';
import 'src/services/web_conversation_service.dart';
import 'src/services/web_friend_service.dart';
import 'src/services/web_initialize_service.dart';
import 'src/services/web_local_conversation_service.dart';
import 'src/services/web_login_service.dart';
import 'src/services/web_message_creator_service.dart';
import 'src/services/web_message_service.dart';
import 'src/services/web_notification_service.dart';
import 'src/services/web_settings_service.dart';
import 'src/services/web_signalling_service.dart';
import 'src/services/web_statistics_service.dart';
import 'src/services/web_storage_service.dart';
import 'src/services/web_subscription_service.dart';
import 'src/services/web_team_service.dart';
import 'src/services/web_topic_service.dart';
import 'src/services/web_user_service.dart';
import 'src/services/web_utility_service.dart';

/// NIM Core Web Plugin
///
/// 通过 dart:js_interop 直接调用 NIM Web SDK，
/// 替代旧的 MethodChannel + TypeScript 中间层模式。
class NimCoreWebPlugin {
  static void registerWith(Registrar registrar) {
    // 替换 InitializeService
    InitializeServicePlatform.instance = WebInitializeService();

    // 替换 LoginService
    LoginServicePlatform.instance = WebLoginService();

    // 替换 MessageCreatorService
    final messageCreatorService = WebMessageCreatorService();
    MessageCreatorServicePlatform.instance = messageCreatorService;

    // 替换 MessageService
    final messageService = WebMessageService();
    messageService.setCreatorService(messageCreatorService);
    MessageServicePlatform.instance = messageService;

    // 替换 V2NIMClientAntispamUtil
    V2NIMClientAntispamUtilPlatform.instance = WebV2NIMClientAntispamUtil();

    // 替换 ConversationService
    ConversationServicePlatform.instance = WebConversationService();

    // 替换 TeamService
    TeamServicePlatform.instance = WebTeamService();

    // 替换 FriendService
    FriendServicePlatform.instance = WebFriendService();

    // 替换 UserService
    UserServicePlatform.instance = WebUserService();

    // 替换 SettingsService
    SettingsServicePlatform.instance = WebSettingsService();

    // 替换 StorageService
    StorageServicePlatform.instance = WebStorageService();

    // 替换 NotificationService
    NotificationServicePlatform.instance = WebNotificationService();

    // 替换 AIService
    AIServicePlatform.instance = WebAIService();

    // 替换 V2NIMTopicService
    V2NIMTopicServicePlatform.instance = WebV2NIMTopicService();

    // 替换 SubscriptionService
    SubscriptionServicePlatform.instance = WebSubscriptionService();

    // 替换 SignallingService
    SignallingServicePlatform.instance = WebSignallingService();

    // 替换 StatisticsService
    StatisticsServicePlatform.instance = WebStatisticsService();

    // 替换 LocalConversationService
    LocalConversationServicePlatform.instance = WebLocalConversationService();

    // 替换 ConversationGroupService
    ConversationServiceGroupPlatform.instance = WebConversationGroupService();

    // 替换 ConversationIdUtil
    ConversationIdUtilPlatform.instance = WebConversationIdUtil();

    // 替换 UtilityService
    V2NIMUtilityServicePlatform.instance = WebUtilityService();
  }
}
