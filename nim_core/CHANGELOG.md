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
