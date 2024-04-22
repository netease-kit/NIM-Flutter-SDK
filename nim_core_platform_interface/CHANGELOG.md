## 1.7.7(Apr 11, 2024)

### New Features
* add `enableFcs` for iOS InitializeOptions

## 1.7.5(Feb 21, 2024)

### New Features
* add `pullHistoryById` in Android and iOS
* add `makeNotifyContentProvider` in Android
* add `makeTickerProvider` in Android
* add `makeRevokeMsgTipProvider` in Android

## 1.7.4(Jan 24, 2024)

### New Features
* add `convertMessageToJson` in Android and iOS
* add `convertJsonToMessage` in Android and iOS
* add `getCurrentAccount` in Android and iOS
* add `onMessagesDelete` in Android and iOS
* add `sendToOnlineUserOnly` on `CustomNotification` in Android and iOS
* add `allMessagesReadForIOS` in iOS

## 1.7.0(Jul 21, 2023)

### New Features
* add `onTeamMemberUpdate` in TeamService
* add `onTeamMemberRemove` in TeamService
* add `registerBadgeCountHandler` in SettingService for iOS
* support honor push for Android
* add `robotInfo` in Message
* add `getMessagesDynamically` in MessageService
* add `searchResourceFiles` in SettingService
* add `removeResourceFiles` in SettingService

# 1.6.0(Apr 24, 2023)

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

# 1.5.0(Mar 31, 2023)

### New Features
* Support Address Config when initialize in Android and iOS
* Support Notification title custom in Android
* Add yidunAntiSpamRes for NIMMessage in Android and iOS

# 1.4.3(Feb 8, 2023)

### API Changes
* add `ignore` param in `clearChattingHistory`
* add `mimeType` and `sampleRate` in `voiceToText`

## 1.4.2(Jan 5, 2023)
### Bug Fixes
* Fix Known issues

## 1.4.1(Dec 13, 2022)
### Bug Fixes
* Fix Known issues

## 1.4.0(Nov 28, 2022)
### New Features
* Support IM QChat2.0 in iOS and Android

## 1.3.1(Nov 22, 2022)
### Bug Fixes
* add base64 for web to send Image/Video/Audio message

## 1.3.0(Nov 3, 2022)
### New Features
* Support IM QChat in iOS and Android

## 1.0.4(Sep 30, 2022)
### Bug Fixes
* Fix enum .name error in sdk less than 2.15.0

## 1.0.3(Sep 30, 2022)
### New Features
* Support IM Signalling in iOS and Android

## 1.0.2(Sep 23, 2022)
### New Features
* Support Web Plugin

## 1.0.1(Sep 8, 2022)

### Bug Fixes
* Bug fix for nim_core version 1.0.10

## 1.0.0(Jul 13, 2022)

### New Features
* first release version
