## 10.9.90(Aug 26, 2026)

### New Features
* 鸿蒙端补齐 `V2NIMLocalConversationService.setCurrentConversation` 实现

### Bug Fixes
* 修复 Web 端会话分组创建和更新时可选参数传递错误的问题
* 修复 Android、macOS、Windows 端会话分组参数 `conversationGroupIds` 对齐及兼容旧参数的问题
* 修复 macOS、Windows 未开启云端会话时仍注册会话分组监听的问题
* 修复 macOS、Windows 端发送话题消息时未正确初始化话题创建参数的问题
* 修复 iOS 非免打扰会话未读数订阅及过滤条件处理问题
* 修复 iOS 端新建子会话后列表不显示的问题
* 修复 Web 端 `createConversationGroup`、`updateConversationGroup` 可选参数为空时返回参数错误的问题(Web)

### Dependency Updates
* Android NIMSDK 升级到 10.10.10

## 10.9.8+4(Aug 5, 2026)

### New Features
* 补齐 `V2NIMConversationGroupService` 桌面端实现(macOS/Windows)
* 补齐 `V2NIMLocalConversationService.setCurrentConversation` 鸿蒙端实现(HarmonyOS)

## 10.9.8+3(Jul 17, 2026)

### Dependency Updates
* iOS NIMSDK 升级到 10.10.10

## 10.9.8+2(Jun 23, 2026)

### Bug fix
* 鸿蒙端聊天室消息转换的时候添加undefined 的保护判断

## 10.9.8+1(Jun 12, 2026)

### Bug fix
* 修复android 端偶现的崩溃问题

## 10.9.8(May 18, 2026)

### New Features
* 新增 `V2NIMTopicService` 话题服务，支持话题删除、更新、发送/回复话题消息、查询话题和分页查询话题消息(Android/iOS/Web)
* `NIMMessage` 新增 `topicRefer` 字段，用于标识消息所属话题
* `AiService` 新增用户级 AI Bot 管理接口：`createUserAIBot`、`deleteUserAIBot`、`updateUserAIBot`、`getUserAIBot`、`getUserAIBotList`、`bindUserAIBotToQrCode`、`refreshUserAIBotToken`(Android/iOS/Web)
* 新增 `V2NIMClientAntispamUtil.checkTextAntispam` 客户端本地反垃圾检查接口(Android/iOS/Web/macOS/Windows)

### Dependency Updates
* Android NIMSDK 升级到 10.9.91
* iOS NIMSDK 升级到 10.9.90
* web NIMSDK 升级到 10.9.90
* Mac NIMSDK 升级到 10.10.0

## 10.9.7(May 12, 2026)

### New Features
* 支持鸿蒙平台运行
* 新增鸿蒙初始化配置项 `NIMOHOSSDKOptions`，用于设置鸿蒙端初始化配置项(HarmonyOS)
* 新增鸿蒙 `OhosPushService`，支持开启/关闭第三方推送和查询推送开关状态(HarmonyOS)

## 10.9.6+1(Apr 28, 2026)

### New Features
* web端支持流式消息，新增`onReceiveMessagesModified` 回调接口
* web端和PC端新增`regenAIMessage`，`stopAIStreamMessage`，`clearLocalMessage` 数字人相关接口
* web端新增 `searchCloudMessagesEx`

## 10.9.6(Mar 31, 2026)

### New Features

* `NIMAndroidSDKOptions` 新增 `searchAccountIdEnabled` 配置项，用于开启搜索账号ID功能，默认为 `false`（Android）

#### iOS APNs Token 自动更新
* 新增 APNs Token 自动处理能力，SDK 内部自动监听并更新推送 Token，用户无需手动在 Native 和 Dart 层传递 Token（iOS）
* `NIMIOSSDKOptions` 新增 `autoUpdateApnsToken` 配置项，默认为 `true`，支持关闭自动处理以兼容手动控制场景（iOS）

#### Web 端架构升级（Breaking Change）
* **重大变更**: Web 端从 TypeScript 中间层架构迁移到 Dart `dart:js_interop` 直接调用架构
* 移除 TypeScript 中间桥接层（`nim_core_v2_web/web/` 目录），Dart 通过 `dart:js_interop` 直接调用 NIM Web SDK
* 消除 JSON 序列化/反序列化的性能开销，提升运行时性能
* 统一只需维护 Dart 代码，降低维护成本
* Web 端 Dart SDK 最低版本要求提升至 `>=3.3.0`
* **注意**: 用户接入方式有变化，详见官网

#### 接口变更
* 新增 `V2NIMUtilityService` 工具类服务，提供 `exportMessagesToPath`、`importMessagesFromPath`、`cancelMigrateMessages` 三个消息迁移接口，并新增 `onMessagesProgress` 事件流，用于监听消息数据库导出进度(Android/iOS)
* 新增 `searchTeams` 接口，支持本地搜索群组列表(Android/iOS/macOS/Windows)
* 新增 `searchTeamMembersEx` 接口，支持本地搜索群成员列表(Android/iOS/macOS/Windows)
* 新增 `clearAllAddApplicationEx` 接口，支持按已读/未读筛选清除好友申请记录(Android/iOS/macOS/Windows/Web)
* 新增 `getOwnerTeamList` 接口，获取当前用户创建的群组列表(Android/iOS/macOS/Windows/Web)
* 新增 `getManagerTeamList` 接口，获取当前用户担任管理员的群组列表(Android/iOS/macOS/Windows/Web)
* 新增 `getTeamInfoFromCloud` 接口，从云端获取群组信息(Android/iOS/macOS/Windows/Web)
* 新增 `StatisticsService` 服务及 `getDatabaseInfos` 接口
* 新增 `clearAllTeamJoinActionInfoEx` 接口，支持按群类型和操作类型过滤清除群申请记录(Android/iOS/Web)
* 新增 `clearLocalMessage` 接口，支持清除指定时间点之前的本地消息(Android/iOS)
* 新增 `translateText` 接口，支持文本翻译功能(Android/iOS/macOS/Windows/Web)
* 新增 `V2NIMMessageService.insertMessageToLocalEx` 接口，支持将消息以扩展参数形式插入本地数据库（不发送、不多端同步，仅本端显示）(Android/iOS/macOS/Windows；Web 平台返回不支持错误)

#### 数据结构变更
* 新增 `NIMFriendClearAddApplicationOption` 数据结构，用于清除好友申请参数
* 新增 `NIMTeamSearchParams` 数据结构，用于群组搜索参数
* 新增 `NIMSearchTeamMemberParams` 数据结构，用于群成员搜索参数
* 新增 `NIMTeamRefer` 数据结构，用于标识群组引用
* 新增 `NIMMessageSource` 枚举（消息来源：未知/在线/离线/漫游）
* `NIMMessage` 新增 `messageSource` 字段
* 新增 `NIMMessageIndex` 数据结构，用于消息索引
* `NIMMessageSearchExParams` 新增 `onlyIndex` 字段
* `NIMMessageSearchItem` 新增 `messageIndexs` 字段
* 新增 `NIMDatabaseInfo` 数据结构（数据库信息：path, name, size）
* 新增 `NIMTeamClearJoinActionInfoOption` 数据结构，用于带条件清除群申请参数
* 新增 `NIMPostscript` 数据结构，用于记录附言信息（发送者/接收者/时间/内容）
* `NIMTeamJoinActionInfo` 新增 `serverId` 字段（申请记录服务端 ID）及 `postscripts` 字段（附言列表）
* 新增 `NIMClearLocalMessageParams` 数据结构，用于本地消息清理参数（锚点时间/是否同时删除会话）
* 新增 `NIMTextTranslateParams` 数据结构，用于文本翻译请求参数（待翻译文本、源语言、目标语言）
* 新增 `NIMTranslatorConfig` 数据结构，用于翻译器配置（严格模式）
* 新增 `NIMTextTranslationResult` 数据结构，用于文本翻译结果（翻译文本、源语言、目标语言）
* 新增 `NIMExportMessageOption` 数据结构，用于导出消息选项（文件路径）
* 新增 `NIMImportMessageOption` 数据结构，用于导入消息选项（文件路径）
* 新增 `V2NIMMessageInsertParams` 数据结构，用于 `insertMessageToLocalEx` 插入参数（会话ID、发送者账号、插入时间、是否更新会话最后一条消息）

## 10.9.5+2(Mar 11, 2026)

### Bug fix
* 修复iOS端ALog的兼容性问题

## 10.9.5+1(Feb 10, 2026)

### New Features
* V2NIMMessage 新增 streamConfig 属性，支持流式消息配置(Android/iOS)
* 支持手动提供推送 Token 回调 `registerManuallyProvidePushTokenCallback`，允许 Flutter 层自定义推送 Token 获取逻辑(Android)
* 新增 `onMixPushToken` 事件流，用于监听推送 Token 变化(Android)
* NIMAndroidSDKOptions 新增 `consoleLogEnabled` 配置项，支持控制台日志输出(Android)

### Dependency Updates
* NIMSDK 升级到10.9.75 (Android/iOS)

### Bug fix
*  修复iOS端重发消息的问题

## 10.9.5(Jan 14, 2026)

### Dependency Updates
* NIMSDK 升级到10.9.70

## 10.9.4+3(Jan 5, 2025)

### Dependency Updates
* iOS NIMSDK 升级到10.9.56

## 10.9.4+2(Dec 3, 2025)

### Bug fix
*  export alog

## 10.9.4+1(Nov 27, 2025)

### Bug fix
*  修复clientIP 获取不到的问题(Android/iOS)

## 10.9.4(Oct 30, 2025)

### New Features
*  支持圈组功能包括圈组服务、圈组频道、圈组聊天等(Android/iOS)

## 10.9.3+2(Oct 19, 2025)

### Dependency Updates
* Android NIMSDK 升级到10.9.52
* iOS NIMSDK 升级到10.9.52

## 10.9.3+1(Sep 19, 2025)

### Bug Fixes
* 修复Android 端撤回消息参数无效的问题

### Dependency Updates
* Android NIMSDK 升级到10.9.45
* iOS NIMSDK 升级到10.9.51

## 10.9.3(Sep 3, 2025)

### New Features
* `FLTMessageService`新增接口`clearRoamingMessage`（android/iOS/macOS/Window）
* 'FLTLocalConversationService' 新增接口 `setCurrentConversation`（android/iOS/macOS/Window）
* V2NIMLoginOption 新增offlineMode参数(android/iOS)
* Android支持设置makeCategory(android)，安卓SDK提供了 notificationChannelProvider 接口

## 10.9.1(Jul 23, 2025)

### New Features
* Mac && Windows 支持本地会话功能
* Mac && Windows 支持聊天室
* Mac && Windows 补全接口

### Dependency Updates
* windows NIMSDK 升级到10.9.30
* Mac NIMSDK 升级到10.9.30

## 10.9.0(Jun 25, 2025)

### New Features
* 支持Android 端设置自定义推送Token
* 支持本地消息查询
* 支持消息过滤（Android）
* Android 端初始化新增 `enableUserInfoProvider` 和 `enableMessageNotifierCustomization`来控制SDK通知栏回调
* 补齐缺失接口

### Dependency Updates
* iOS NIMSDK 升级到10.9.10
* Android NIMSDK 升级到10.9.1

### Bug Fixes
* 修复Android 端创建聊天室自定义消息的问题`createCustomMessageWithAttachmentAndSubType`

## 10.8.0(May 26, 2025)

### New Features
* 支持AI 数字人流式输出

## 10.6.1(May 8, 2025)

### New Features
* 支持聊天室队列服务

## 10.6.0(Apr 18, 2025)

### New Features
* 支持本地会话服务
* 支持会话分组服务
* 支持群定向消息

### Bug Fix
* 修复Android 端更新本地消息本地扩展问题`updateMessageLocalExtension`
* 修复iOS 端角标配置问题
* 修复 iOS 端登录回调loginExtension 问题

## 10.5.1(Apr 14, 2025)

### New Features
* Android 端指定Java 编译版本是 1.8

## 10.5.0(Mar 25, 2025)

### New Features
* 支持消息更新操作（Android & iOS）
* 支持聊天室服务 （Android & iOS）
* 支持消息序列化和反序列化（Android & iOS）
* 支持清空验证消息
* 支持Android 端的通知设置

### Bug Fix
* 修复已知问题


## 10.4.0(Jan 20, 2025)

### New Features
* 支持信令功能
* Android 端支持AGP 8.0

### Dependency Updates
* NIMSDK 升级到10.7.0

## 10.3.5(Jan 7, 2025)

### bug fix
* 修复iOS端枚举类型转换错误的问题

## 10.3.4(Dec 24, 2024)

### New Features
* 支持在线订阅功能

## 10.3.3(Nov 22, 2024)

### bug fix
* 修改iOS端群属性更新信息解析错误的问题

## 10.3.1(Sep 2, 2024)

### Dependency Updates
* Mac NIMSDK 升级到10.4.0
* Windows NIMSDK 升级到10.4.0

### Bug Fixes
* Mac 和 Windows 端消息模块问题
* Mac 和 Windows 端存储模块问题
* Mac 和 Windows 端会话模块问题
* Mac 和 Windows 端群组模块问题

## 10.3.0(Aug 22, 2024)

### New Features
* 工程首次提交
