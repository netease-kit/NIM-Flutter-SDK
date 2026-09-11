## 10.9.90(Aug 26, 2026)

### Bug Fixes
* 修复创建会话分组时可选参数传递 undefined 导致调用失败的问题
* 会话分组更新接口支持可选分组名，并对齐 Web SDK 的位置参数

## 10.9.8(May 18, 2026)

### New Features
* 新增 `WebV2NIMTopicService`，支持话题删除、更新、发送/回复话题消息、查询话题和分页查询话题消息
* `WebAIService` 新增用户级 AI Bot 管理接口：`createUserAIBot`、`deleteUserAIBot`、`updateUserAIBot`、`getUserAIBot`、`getUserAIBotList`、`bindUserAIBotToQrCode`、`refreshUserAIBotToken`
* 新增 `WebV2NIMClientAntispamUtil`，支持 `checkTextAntispam` 客户端本地反垃圾检查接口

## 10.9.6+1(Apr 28, 2026)

### New Features
* web端支持流式消息，新增`onReceiveMessagesModified` 回调接口
* web端和PC端新增`regenAIMessage`，`stopAIStreamMessage`，`clearLocalMessage` 数字人相关接口
* web端新增 `searchCloudMessagesEx`

## 10.9.6(Mar 31, 2026)

### New Features
* 新增 `WebStatisticsService`，实现 `StatisticsService.getDatabaseInfos` 接口（Web 平台返回空列表）

#### Web 端架构升级（Breaking Change）
* **重大变更**: Web 端从 TypeScript 中间层架构迁移到 Dart `dart:js_interop` 直接调用架构
* 移除 TypeScript 中间桥接层（`nim_core_v2_web/web/` 目录），Dart 通过 `dart:js_interop` 直接调用 NIM Web SDK
* 消除 JSON 序列化/反序列化的性能开销，提升运行时性能
* 统一只需维护 Dart 代码，降低维护成本
* Web 端 Dart SDK 最低版本要求提升至 `>=3.3.0`
* **注意**: 用户接入方式有变化，详见官网

## 10.4.0(Jan 20, 2025)

### New Features
* 支持信令功能

### Dependency Updates
* NIMSDK 升级到10.7.0

## 10.3.4(Dec 24, 2024)

### New Features
* 支持在线订阅功能

## 10.3.1(Sep 2, 2024)

### Bug Fixes
* 已知问题修复

## 10.3.0(Aug 22, 2024)

### New Features
* 工程首次提交
