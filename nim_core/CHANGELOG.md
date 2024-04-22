## 1.7.7(Apr 11, 2024)

### New Features
* add `enableFcs` for iOS InitializeOptions

### Bug Fixes
* fix VideoAttachment have no `path` in iOS

## 1.7.6(Mar 8, 2024)

### Dependency Updates
* NIMSDK from 9.13.1 to 9.15.0 in Android
* NIMSDK from 9.13.1 to 9.15.1 in iOS

## 1.7.5(Feb 21, 2024)

### New Features
* add `pullHistoryById` in Android and iOS
* add `makeNotifyContentProvider` in Android
* add `makeTickerProvider` in Android
* add `makeRevokeMsgTipProvider` in Android

## 1.7.4(Jan 25, 2024)
### Bug Fixes
* fix offline error when `call` in iOS
* fix `senderClientType` error when receive from web in iOS

### New Features
* add `convertMessageToJson` in Android and iOS
* add `convertJsonToMessage` in Android and iOS
* add `getCurrentAccount` in Android and iOS
* add `onMessagesDelete` in Android and iOS
* add `sendToOnlineUserOnly` on `CustomNotification` in Android and iOS
* add `allMessagesReadForIOS` in iOS

## 1.7.3(Nov 8, 2023)
### Dependency Updates
* yunxin_alog from 1.0.11 to 2.0.0
* NIMSDK from 9.13.0 to 9.13.1 in Android
* NIMSDK from 9.11.0 to 9.13.1 in iOS

### Bug Fixes
* fix getUserInfo error when db have no info in iOS
* fix Team Add issue in iOS

### New Features
* add `setChattingAccount` in iOS

## 1.7.2(Sep 6, 2023)
### Dependency Updates
* NIMSDK from 9.11.0 to 9.13.0 in Android

### Bug Fixes
* fix checkLocalAntiSpam error in iOS

## 1.7.1+1(Aug 15, 2023)

### Bug Fixes
* fix ALog error in Android

## 1.7.1(Aug 10, 2023)

### Bug Fixes
* fix `onCustomNotification` sessionId error on iOS when type is Team

## 1.7.0(Jul 21, 2023)
### Dependency Updates
* nim_core_platform_interface to 1.7.0

### Bug Fixes
* fix eventSubscribeStream error on iOS

### New Features
* add `onTeamMemberUpdate` in TeamService
* add `onTeamMemberRemove` in TeamService
* add `registerBadgeCountHandler` in SettingService for iOS
* support honor push for Android
* add `robotInfo` in Message
* add `getMessagesDynamically` in MessageService
* add `searchResourceFiles` in SettingService
* add `removeResourceFiles` in SettingService

## 1.6.2(Jun 15, 2023)
### Dependency Updates
* NIMSDK from 9.10.0 to 9.11.0
* environment sdk < 4.0.0

## 1.6.1(Jun 1, 2023)
### Bug Fixes
* fix UserInfoProvider error on Meizu devices
* fix downloadAttachment error on Android
* fix delete nick error on Android
* fix SystemMessage time error on iOS
* make lastMsgContent consistent on both Android and iOS

# 1.6.0(Apr 24, 2023)
### Bug Fixes
* fix onReceiveSystemNotification error when update permission
* fix qChat message antiSpamResult error in iOS
* fix qChat multi login error in iOS
* fix StickTopSessionInfo error in iOS
* fix qChat download Attachment error
* fix send qChat Message remoteExtension error in iOS
* fix sendSystemNotification Extension error in iOS
* add `nextTimeTag` for `getChannelsByPage`,`getChannelMembersByPag`,`searchChannelByPage`
* fix MessageBuilder.createTipMessage have no content issue

### New Features
* add `ackTimeTag`, `lastMsgTime` and `time` in QChatUnreadInfo
* add `subscribeAsVisitor` in QChatChannelService
* add `sendTypingEvent` in QChatMessageService
* add `getMentionedMeMessages` in QChatMessageService
* add `areMentionedMeMessages` in QChatMessageService
* add `subscribeAsVisitor` in QChatServerService
* add `enterAsVisitor` in QChatServerService
* add `leaveAsVisitor` in QChatServerService
* add `observeReceiveTypingEvent` in QChatServiceObserver
* add `checkpermissions` in QChatRoleService
* add `visitorMode` in QChatChannel
* add `accIds` in QChatSystemMessageToType

### Dependency Updates
* NIMSDK from 9.8.0 to 9.10.0
* nim_core_platform_interface to 1.6.0

# 1.5.0(Mar 31, 2023)

### Bug Fixes
* fix return different uuid when resend qChat message

### New Features
* Support Address Config when initialize in Android and iOS
* Support Notification title custom in Android
* Add yidunAntiSpamRes for NIMMessage in Android and iOS

### Dependency Updates
* NIMSDK from 9.6.0 to 9.8.0
* nim_core_platform_interface to 1.5.0

# 1.4.8(Mar 20, 2023)

### Bug Fixes
* fix add quick comment error in iOS

# 1.4.7(Feb 23, 2023)

### Bug Fixes
* fix resend qChat message error in iOS
* fix onMessageStatusChange msgType error in Android 
* add inOutType for qChat System Notification in iOS
* add senderClientType for Message in Mac and Windows

### Dependency Updates
* nim_core_windows from 1.0.7 to 1.0.8
* nim_core_macos from 1.0.7 to 1.0.8

# 1.4.6(Feb 10, 2023)

### Bug Fixes
* Add endTime for `pullMessageHistory`

### Dependency Updates
* yunxin_alog depend ^1.0.11

# 1.4.5(Feb 8, 2023)

### Bug Fixes
* Fix crash when reply a message that replied other message before on iOS
* Fix `pullMessageHistory` not callback onSessionUpdate issue on iOS
* Fix team mute mode have no `muteNormal` mode issue on iOS
* Fix audio attachment size(height and width) error on iOS
* Fix message status error on Android
* Fix errorCode(414) error on Android
* Fix QChat system notify attachment empty issue on Android and iOS
* Fix `pullMessageHistoryExType` can't get message issue on PC
* Fix `clearAllSessionUnreadCount` invalid issue on PC 
* Fix `forwardMessage` Message error on PC

### API Changes
* add `ignore` param in `clearChattingHistory` 
* add `mimeType` and `sampleRate` in `voiceToText`

### Dependency Updates
* iOS NIM SDK depend ~> 9.6.3
* nim_core_platform_interface from 1.4.2 to 1.4.3
* nim_core_windows from 1.0.6 to 1.0.7
* nim_core_macos from 1.0.6 to 1.0.7

## 1.4.4(Jan 6, 2023)
### Bug Fixes
* Fix issue in fetchChatroomQueue for iOS
* Add nick, avatar and tags in ChatroomMember for iOS
* Add direction and startTime in NIMHistoryMessageSearchOption for iOS
* Fix fetchMessageAttachment error logic for iOS 
* Fix onAttachmentProgress error for iOS
* Fix removeManagers in Team issue for iOS
* Add body in NIMQChatSendSystemNotificationParam for iOS
* Fix fetchChatroomInfo error for iOS
* Fix updateMyChatroomMemberInfo error for iOS
* Fix onKickOut error in ChatRoom for iOS
* Fix markMemberManager error in ChatRoom for ios
* Fix updateMemberBlack,markMemberManager and markNormalMember for iOS
* Add onSuperTeamMemberUpdate,onSuperTeamMemberRemove,onSuperTeamRemove,onSuperTeamUpdate for iOS
* Add callback in clearMsgDatabase for Android
* Add KickOutOtherOnlineClient for iOS
* Fix NIMSubscribeEvent receive for iOS
* Fix updateMyChatroomMemberInfo error for iOS 
* Fix transferTeam result list error in FLTTeamService for iOS
* Fix addManagers result list error in FLTTeamService for iOS
* Fix removeManagers result list error in FLTTeamService for iOS
* Fix queryMutedTeamMembers null result as empty object in FLTTeamService for iOS
* Fix convertToMessage msgType error when custom message has no attachment in NIMQChatMessage for iOS
* Add NOSService#downloadAttachment implementation on iOS;
* Fix MessageService#pullMessageHistoryExType toTime unit to second iOS;
* Fix NIMMessagePinItem#pinCreateTime/pinUpdateTime unit to second and messageUuid iOS;
* Fix SupperTeamService#muteTeam invalid on Android;
* Fix SupperTeamService#queryMutedTeamMembers invalid on Android;
* Fix SupperTeamService#updateMyMemberExtension invalid on Android;
* Fix MessageService#addCollect uniqueId on iOS;
* Fix ChatroomService#removeChatroomQueueObject error when key is nil on iOS;
* Fix NIMSubscribeEvent#createSubscribeEvent error on iOS;
* Fix MessageService#clearServerHistory clear history on remote server only.
* Add some default value to NIMMessage for iOS
* Add QUERY_OLD for direction in queryMessageListEx for  iOS
* Add sessionTypePair in NIMSession for iOS
* Add fromDic() function in NIMMessageFullKeywordSearchOption for iOS
* Add getArrayFromJSONString() function in NIMNSObject for iOS
* Add enableHistory in createMessage for iOS
* Add teamReceiptEnabled in initSDK for iOS
* Fix joinTime in queryMemberList for Android
* Fix messageStatus in NIMMessage for iOS
* Fix createTime/updateTime in NIMStickTopSessionInfo for iOS
* Fix createTime/updateTime in NIMMessageSearchOption for iOS
* Fix lastMsgType in NIMSession for iOS
* Fix limit and return value in queryMessageListEx for iOS
* Fix input arguments in searchCloudMessageHistory for iOS
* Fix input arguments in searchRoamingMsg for iOS
* Fix input arguments in queryMySessionList for iOS
* Fix joinTime/createTime/extension in NIMTeam for iOS
* Fix toTime in fromDic() of NIMCollectQueryOptions for iOS
* Fix revokeType in toDic() of NIMRevokeMessageNotification for iOS
* Fix lastMsg/lastMsgType/extension/revokeNotification in NIMSession for iOS
* Fix isValid/tag in NIMChatRoom for iOS
* Fix size/sourcePath/fileLength in attachment of NIMMessage for iOS
* Fix limit in getRecentList for iOS
* Fix method of updateSessionWithMessage for iOS
* Fix option.searchRange in searchUserIdListByNick for iOS

### API Changes
* update `download` in `NOSService` param `path` as notNullable

# 1.4.3(Dec 26, 2022)

### Bug Fixes
* Fix QChat custom message type error for ios

# 1.4.2(Dec 16, 2022)

### Bug Fixes
* Fix resetSystemMessageUnreadCountByType error for ios
* Fix createChatRoomCustomMessage attachment error for ios
* Fix clearSystemMessagesByType error for ios

# 1.4.1(Dec 13, 2022)

### Dependency Updates
* minimum environment sdk upgrade to 2.17.0
* update ffi to 2.0.0
* nim_core_platform_interface from 1.4.0 to 1.4.1
* nim_core_web from 1.0.1 to 1.0.2

### Bug Fixes
* Fix querySystemMessageUnreadCountByType error for ios
* Fix createCustomMessage content error for ios
* Fix createTeam extension error for ios
* Fix other known issue

# 1.4.0(Nov 28, 2022)

### Dependency Updates
* iOS updated NIM SDK version to 9.6.3
* Android updated NIM SDK version to 9.6.3
* nim_core_platform_interface from 1.3.1 to 1.4.0

### New Features
* Support IM QChat2.0 in iOS and Android

### Bug Fixes
* Fix send media Message error in Android
* Fix signal pushPayload error in Android

### API Changes
* update `QChatChannelService` for Android and iOS
* update `QChatMessageService` for Android and iOS
* update `QChatObserver` for Android and iOS
* update `QChatRoleService` for Android and iOS
* update `QChatServerService` for Android and iOS
* add `QChatPushService` for Android and iOS
* add `saveMessageToLocalEx` for Android and iOS in MessageService
* add `updateMyTeamNick` for Android and iOS in TeamService
* add `maxMemberCount` for Android and iOS in createTeam
* add `sessionForWeb` for Android and iOS in NIMSession

# 1.3.3(Nov 22, 2022)

### Bug Fixes
* fix first query message list error in iOS
* add base64 for web to send media message

# 1.3.2(Nov 17, 2022)

### Bug Fixes
* Fix getMessageHistory error in iOS

# 1.3.1(Nov 14, 2022)

### Bug Fixes
* Fix chatroom create Message error in iOS
* Fix send Message attach error in iOS
* Fix fromAccount error in iOS

# 1.3.0(Nov 3, 2022)   

### Dependency Updates
* iOS updated NIM SDK version to 9.6.3
* Android updated NIM SDK version to 9.6.3   
* nim_core_platform_interface from 1.0.3 to 1.3.0
* nim_core_windows from 1.0.3 to 1.0.4
* nim_core_macos from 1.0.3 to 1.0.4

### New Features
* Support IM QChat in iOS and Android   

### Bug Fixes   
* Fix team sessionId error in Mac & Windows
* Fix muteTeam error in Mac & Windows   

### API Changes  
* add `QChatChannelService` for Android and iOS
* add `QChatMessageService` for Android and iOS
* add `QChatObserver` for Android and iOS
* add `QChatRoleService` for Android and iOS
* add `QChatServerService` for Android and iOS
* add `QChatService` for Android and iOS

# 1.2.1(Oct 13, 2022)

### Dependency Updates
* iOS updated NIM SDK version to 9.6.1

# 1.2.0(Sep 30, 2022)

### New Features
* Support IM Signalling in iOS and Android

### API Changes
* add `createChannel` in `AvSignallingService`    
* add `closeChannel` in `AvSignallingService`
* add `joinChannel` in `AvSignallingService`
* add `leaveChannel` in `AvSignallingService`
* add `invite` in `AvSignallingService`
* add `cancelInvite` in `AvSignallingService`
* add `rejectInvite` in `AvSignallingService`
* add `acceptInvite` in `AvSignallingService`
* add `sendControl` in `AvSignallingService`
* add `call` in `AvSignallingService`
* add `queryChannelInfo` in `AvSignallingService`
* add `onlineNotification` in `AvSignallingService`
* add `offlineNotification` in `AvSignallingService`
* add `onMemberUpdateNotification` in `AvSignallingService`
* add `otherClientInviteAckNotification` in `AvSignallingService`
* add `syncChannelListNotification` in `AvSignallingService`

### Bug Fixes  
* fix iOS initialize issue

### Dependency Updates
* iOS updated NIM SDK version from 8.11.0 to 9.6.0
* nim_core_platform_interface from 1.0.2 to 1.0.3
* nim_core_web from 1.0.0 to 1.0.1

# 1.1.0(Sep 23, 2022)

### New Features
* Support Web Plugin

### API Changes
* add `idServer` as param for `ackAddFriend` in `UserService`
* add `base64` field in `NIMFileAttachment`
* add `otherAccid` field in `MessageKeywordSearchConfig` which is the param for `searchCloudMessageHistory` in `MessageService`

### Bug Fixes
* iOS fixed message filtering error

# 1.0.11(Sep 15, 2022)

### Bug Fixes
* iOS fixed message status

### Dependency Updates
* iOS updated SDK version 8.11.0

# 1.0.10(Sep 8, 2022)

### New Features
* support iOS simulator

### Behavior changes
* UserService.onMuteListChanged return type change to NIMMuteListChangedNotify
* MessageService.onSessionDelete return type change to nullable

### API Changes
* add queryRoamMsgHasMoreTime in MessageService
* add updateRoamMsgHasMoreTag in MessageService
* add rejectApply in TeamService

### Bug Fixes
* Fix some Known bugs

### Dependency Updates
* nim_core_platform_interface from 1.0.0 to 1.0.1
* Android NIM SDK from 8.11.12 to 8.11.13

# 1.0.9(Sep 2, 2022)

### Bug Fixes
* iOS Fixed can't get latitude and longitude

### Dependency Updates
* nim_core_macos from 1.0.0 to 1.0.2
* nim_core_windows from 1.0.0 to 1.0.2

# 1.0.8(Aug 29, 2022)

### Bug Fixes
* iOS Fixed removeManagers parameter error

# 1.0.7(Aug 23, 2022)

### Bug Fixes
* iOS Fixed issue with fetch top message data being empty
* iOS Fixed fetchUserInfoList forced unpacking
* iOS Fixed empty LastMessage Content

# 1.0.6(Aug 18, 2022)

### Bug Fixes
* Android add updateMyMemberExtension for TeamService
* Android fix sendMessage error in SuperTeam

# 1.0.5(Aug 17, 2022)

### Bug Fixes
* iOS fix getUserinfo ext field is empty

# 1.0.4(Aug 9, 2022)

### Bug Fixes
* Android fix initialized status issue

# 1.0.3(Jul 26, 2022)

### Bug Fixes
* Android fix multi channel issue

# 1.0.2(Jul 22, 2022)

### Bug Fixes
* iOS Fixed an issue where attach was empty

# 1.0.1(Jul 20, 2022)

### Bug Fixes
* add some necessary logs for chatroom message receiver

# 1.0.0(Jul 13, 2022)

### New Features
* first release version
