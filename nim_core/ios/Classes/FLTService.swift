// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation

enum ServiceType: String {
  case MessageService
  case LifeCycleService = "InitializeService"
  case UserService
  case EventSubscribeService
  case ConversationService
  case SystemNotificationService = "SystemMessageService"
  case AudioRecordService = "AudioRecorderService"
  case AuthService
  case SessionService
  case TeamService
  case ChatroomService
  case NOSService
  case ChatExtendService
  case PassThroughService
  case SettingService = "SettingsService"
  case SuperTeamService
  case AvSignallingService
  case QChatObserver
  case QChatService
  case QChatServerService
  case QChatChannelService
  case QChatMessageService
  case QChatRoleService
  case QChatPushService
}

protocol FLTService {
  func serviceName() -> String

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback)

  func register(_ nimCore: NimCore)

  func onInitialized()
}
