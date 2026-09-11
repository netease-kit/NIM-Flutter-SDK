## 10.9.90(Aug 26, 2026)

### Bug Fixes
* 修复 `NIMMessageCallAttachment.channelId` 非字符串值反序列化导致 Web 端显示异常的问题
* `updateConversationGroup` 支持传入 null 表示不更新分组名

## 10.9.80(May 18, 2026)

### New Features
* 新增 `V2NIMTopicServicePlatform`、`MethodChannelV2NIMTopicService` 和话题相关数据结构
* 新增 `V2NIMTopic`、`V2NIMTopicRefer`、`V2NIMUpdateTopicParams`、`V2NIMRemoveTopicsParams`、`V2NIMCreateTopicParams`、`V2NIMSendTopicMessageParams`、`V2NIMTopicListOption`、`V2NIMTopicListResult`、`V2NIMTopicMessageListOption`、`V2NIMTopicMessageListResult`
* `NIMMessage` 新增 `topicRefer` 字段
* `AIServicePlatform` 和 `MethodChannelAIService` 新增用户级 AI Bot 管理接口
* 新增用户级 AI Bot 相关数据结构：`V2NIMUserAIBot`、`V2NIMCreateUserAIBotParams`、`V2NIMDeleteUserAIBotParams`、`V2NIMUpdateUserAIBotParams`、`V2NIMGetUserAIBotParams`、`V2NIMGetUserAIBotListParams`、`V2NIMBindUserAIBotToQrCodeParams`、`V2NIMRefreshUserAIBotTokenParams`、`V2NIMCreateUserAIBotResult`、`V2NIMGetUserAIBotListResult`、`V2NIMRefreshUserAIBotTokenResult`
* 新增 `V2NIMClientAntispamUtilPlatform` 和 `MethodChannelV2NIMClientAntispamUtil`，支持 `checkTextAntispam` 客户端本地反垃圾检查接口
* Web 初始化 `NIMOtherOptions` 补齐 Web SDK 文档中的模块配置参数

## 10.9.70(May 12, 2026)

### New Features
* 支持鸿蒙平台运行
* 新增鸿蒙初始化配置项 `NIMOHOSSDKOptions`，用于设置鸿蒙端初始化配置项(HarmonyOS)
* 新增鸿蒙 `OhosPushService`，支持开启/关闭第三方推送和查询推送开关状态(HarmonyOS)

## 10.9.62(Apr 28, 2026)

### New Features
* web端支持流式消息，新增`onReceiveMessagesModified` 回调接口
* web端和PC端新增`regenAIMessage`，`stopAIStreamMessage`，`clearLocalMessage` 数字人相关接口
* web端新增 `searchCloudMessagesEx`

## 10.9.61(Mar 31, 2026)

### New Features
* `MessageServicePlatform` 新增抽象方法 `translateText`，支持文本翻译
* `MessageServicePlatform` 新增抽象方法 `exportLocalMessages`，支持导出本地消息数据库
* `MessageServicePlatform` 新增抽象方法 `importLocalMessages`，支持导入本地消息数据库
* 新增 `NIMTextTranslateParams` 数据结构，用于文本翻译请求参数
* 新增 `NIMTranslatorConfig` 数据结构，用于翻译器配置
* 新增 `NIMTextTranslationResult` 数据结构，用于文本翻译结果
* 新增 `NIMExportMessageOption` 数据结构，用于导出消息文件选项
* 新增 `NIMImportMessageOption` 数据结构，用于导入消息文件选项
* `MethodChannelMessageService` 新增 `translateText`、`exportLocalMessages`、`importLocalMessages` 方法通道实现
* 新增 `NIMMessageSource` 枚举（消息来源：未知/在线/离线/漫游）


## 10.9.6(Feb 10, 2026)

### New Features
* V2NIMMessage 新增 streamConfig 属性，支持流式消息配置(Android/iOS)
* 支持手动提供推送 Token 回调 `registerManuallyProvidePushTokenCallback`，允许 Flutter 层自定义推送 Token 获取逻辑(Android)
* 新增 `onMixPushToken` 事件流，用于监听推送 Token 变化(Android)
* NIMAndroidSDKOptions 新增 `consoleLogEnabled` 配置项，支持控制台日志输出(Android)

## 10.9.5(Jan 14, 2026)

### Dependency Updates
* NIMSDK 升级到10.9.70

## 10.9.4(Oct 30, 2025)
### New Features
*  支持圈组功能包括圈组服务、圈组频道、圈组聊天等(Android/iOS)

## 10.9.3+1(Sep 19, 2025)

### Bug Fixes
* 删除不需要的ffi依赖，解决web端编译问题

## 10.9.3(Sep 3, 2025)

### New Features
* `FLTMessageService`新增接口`clearRoamingMessage`（android/iOS/macOS/Window）
* 'FLTLocalConversationService' 新增接口 `setCurrentConversation`（android/iOS/macOS/Window）
* V2NIMLoginOption 新增offlineMode参数(android/iOS)
* Android支持设置makeCategory(android)，安卓SDK提供了 notificationChannelProvider 接口

## 10.9.1+1(Jul 31, 2025)

### Bug fix
* 解决全员禁言的问题

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

## 10.5.1(Mar 25, 2025)

### New Features
* Android 初始化参数的属性修改

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

### Dependency Updates
* NIMSDK 升级到10.7.0

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
