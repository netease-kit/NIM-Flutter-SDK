/*
 * Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import Foundation

enum ServiceType: String {
    case MessageService = "MessageService"
    case LifeCycleService = "InitializeService"
    case UserService = "UserService"
    case EventSubscribeService = "EventSubscribeService"
    case ConversationService = "ConversationService"
    case SystemNotificationService = "SystemMessageService"
    case AudioRecordService = "AudioRecordService"
    case AuthService = "AuthService"
    case SessionService = "SessionService"
    case TeamService = "TeamService"
    case ChatroomService = "ChatroomService"
    case NOSService = "NOSService"
    case ChatExtendService = "ChatExtendService"
    case PassThroughService = "PassThroughService"
    case SettingService = "SettingsService"
    case SuperTeamService = "SuperTeamService"
}

protocol FLTService {
    
    func serviceName() -> String
    
    func onMethodCalled(_ method: String, _ arguments: [String: Any], _ resultCallback: ResultCallback)
    
    func register(_ nimCore: NimCore)
    
    func onInitialized()
}
