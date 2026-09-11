// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation

enum ServiceType: String {
  case MessageService
  case ClientAntispamUtil = "V2NIMClientAntispamUtil"
  case ChatRoomClient = "V2NIMChatroomClient"
  case ChatRoomService = "V2NIMChatroomService"
  case ChatRoomQueueService = "V2NIMChatroomQueueService"
  case LifeCycleService = "InitializeService"
  case UserService
  case EventSubscribeService
  case ConversationService
  case LocalConversationService = "V2NIMLocalConversationService"
  case ConversationGroupService = "V2NIMConversationGroupService"
  case SystemNotificationService = "SystemMessageService"
  case AudioRecordService = "AudioRecorderService"
  case AuthService
  case TeamService
  case NOSService
  case ChatExtendService
  case PassThroughService
  case SettingService = "SettingsService"
  case SuperTeamService
  case SignallingService
  case QChatObserver
  case QChatService
  case QChatServerService
  case QChatChannelService
  case QChatMessageService
  case QChatRoleService
  case QChatPushService
  case LoginService
  case FriendService
  case MessageCreatorService
  case ChatRoomMessageCreatorService = "V2NIMChatroomMessageCreator"
  case StorageService
  case APNSService
  case ConversationIdUtil
  case AIService
  case TopicService
  case SubscriptionService
  case StatisticsService
  case UtilityService
}

protocol FLTService {
  func serviceName() -> String

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback)

  func register(_ nimCore: NimCore)

  func onInitialized()
}
