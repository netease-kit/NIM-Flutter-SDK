// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

@HawkEntryPoint()
class AiService {
  factory AiService() {
    if (_singleton == null) {
      _singleton = AiService._();
    }
    return _singleton!;
  }

  AiService._();

  static AiService? _singleton;

  AIServicePlatform get _platform => AIServicePlatform.instance;

  /// AI 消息的响应的回调
  @HawkApi(ignore: true)
  Stream<NIMAIModelCallResult> get onProxyAIModelCall =>
      _platform.onProxyAIModelCall;

  ///AI 消息的流式响应的回调
  /// 注意：流式过程中回调此方法，流式结束后还是会统一调用onProxyAIModelCall方法
  @HawkApi(ignore: true)
  Stream<NIMAIModelStreamCallResult> get onProxyAIModelStreamCall =>
      _platform.onProxyAIModelStreamCall;

  /// 数字人拉取接口
  Future<NIMResult<List<NIMAIUser>>> getAIUserList() =>
      _platform.getAIUserList();

  /// AI 数字人请求代理接口
  Future<NIMResult<void>> proxyAIModelCall(NIMProxyAIModelCallParams params) =>
      _platform.proxyAIModelCall(params);

  /// 停止流式输出接口
  Future<NIMResult<void>> stopAIModelStreamCall(
          NIMAIModelStreamCallStopParams params) =>
      _platform.stopAIModelStreamCall(params);

  /// 创建用户级 AI Bot
  Future<NIMResult<V2NIMCreateUserAIBotResult>> createUserAIBot(
          V2NIMCreateUserAIBotParams params) =>
      _platform.createUserAIBot(params);

  /// 删除用户级 AI Bot
  Future<NIMResult<void>> deleteUserAIBot(V2NIMDeleteUserAIBotParams params) =>
      _platform.deleteUserAIBot(params);

  /// 更新用户级 AI Bot
  Future<NIMResult<void>> updateUserAIBot(V2NIMUpdateUserAIBotParams params) =>
      _platform.updateUserAIBot(params);

  /// 查询单个用户级 AI Bot
  Future<NIMResult<V2NIMUserAIBot>> getUserAIBot(
          V2NIMGetUserAIBotParams params) =>
      _platform.getUserAIBot(params);

  /// 分页查询用户级 AI Bot 列表
  Future<NIMResult<V2NIMGetUserAIBotListResult>> getUserAIBotList(
          [V2NIMGetUserAIBotListParams? params]) =>
      _platform.getUserAIBotList(params);

  /// 绑定用户级 AI Bot 到二维码
  Future<NIMResult<void>> bindUserAIBotToQrCode(
          V2NIMBindUserAIBotToQrCodeParams params) =>
      _platform.bindUserAIBotToQrCode(params);

  /// 刷新用户级 AI Bot 登录密钥
  Future<NIMResult<V2NIMRefreshUserAIBotTokenResult>> refreshUserAIBotToken(
          V2NIMRefreshUserAIBotTokenParams params) =>
      _platform.refreshUserAIBotToken(params);
}
