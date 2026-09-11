## 10.9.90(Aug 26, 2026)

### Bug Fixes
* 修复会话分组参数 `conversationGroupIds` 对齐及兼容旧参数的问题
* 修复未开启云端会话时仍注册会话分组监听的问题
* 修复发送话题消息时未正确初始化话题创建参数的问题

## 10.9.8+1(Aug 5, 2026)

### New Features
* 补齐 `V2NIMConversationGroupService` 桌面端实现(macOS/Windows)

## 10.9.8(May 18, 2026)

### New Features
* 新增 `V2NIMClientAntispamUtil` 服务，支持 `checkTextAntispam` 客户端本地反垃圾检查接口
* 补齐 `AIService` 用户级 AI Bot 管理接口和 `TopicService` 话题服务接口
* 补齐 `V2NIMConversationGroupService` 会话分组服务实现

## 10.9.6+1(Apr 28, 2026)

### New Features
* web端支持流式消息，新增`onReceiveMessagesModified` 回调接口
* web端和PC端新增`regenAIMessage`，`stopAIStreamMessage`，`clearLocalMessage` 数字人相关接口
* web端新增 `searchCloudMessagesEx`

## 10.9.6(Mar 31, 2026)

### New Features
* 实现 `StatisticsService.getDatabaseInfos` 接口
* 消息序列化支持 `messageSource` 字段
* 搜索接口支持 `onlyIndex` 参数及返回 `messageIndexs`

## 10.9.5(Jan 14, 2026)

### Dependency Updates
* NIMSDK 升级到10.9.70

### New Features
* 增加群定向消息功能
* 支持查询消息返回更多信息

### bug fix
* 兼容M系列芯片，编译universal版本
* 修复TeamService 兼容性
* 修复 消息过滤问题
* 修复消息序列化和反序列化的问题

## 10.9.3(Sep 3, 2025)

### New Features
* `FLTMessageService`新增接口`clearRoamingMessage`（android/iOS/macOS/Window）
* 'FLTLocalConversationService' 新增接口 `setCurrentConversation`（android/iOS/macOS/Window）

## 10.9.1(Jul 23, 2025)

### New Features
* 支持本地会话功能
* 支持聊天室
* 补全接口

### Dependency Updates
* NIMSDK 升级到10.9.30

## 10.4.0(Jan 20, 2025)

### New Features
* 支持信令功能

### Dependency Updates
* NIMSDK 升级到10.7.0

## 10.3.5(Jan 7, 2025)

### bug fix
* 修复getMessageList 拉取群变更消息问题

## 10.3.4(Dec 24, 2024)

### New Features
* 支持在线订阅功能

## 10.3.2(Oct 23, 2024)

### New Features
* 替换SDK下载逻辑，兼容Mac pub依赖

## 10.3.1(Sep 2, 2024)

### Dependency Updates
* Mac NIMSDK 升级到10.4.0

### Bug Fixes
* Mac 和 Windows 端消息模块问题
* Mac 和 Windows 端存储模块问题
* Mac 和 Windows 端会话模块问题
* Mac 和 Windows 端群组模块问题

## 10.3.0(Aug 22, 2024)

### New Features
* 工程首次提交
