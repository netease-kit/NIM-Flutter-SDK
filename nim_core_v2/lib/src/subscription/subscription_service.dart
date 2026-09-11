// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

@HawkEntryPoint()
class SubscriptionService {
  factory SubscriptionService() {
    if (_singleton == null) {
      _singleton = SubscriptionService._();
    }
    return _singleton!;
  }

  SubscriptionService._();

  static SubscriptionService? _singleton;

  SubscriptionServicePlatform get _platform =>
      SubscriptionServicePlatform.instance;

  ///其它用户状态变更，包括在线状态，和自定义状态 同账号发布时，指定了多端同步的状态
  ///在线状态默认值为： 登录：1 登出：2 断开连接： 3 在线状态事件会受推送的影响：如果应用被清理，
  ///但厂商推送（APNS、小米、华为、OPPO、VIVO、魅族、FCM）可达，则默认不会触发该用户断开连接的事件,
  ///若开发者需要该种情况下视为离线，请前往网易云信控制台>选择应用>IM 即时通讯>功能配置>全局功能>在线状态订阅
  // Params:
  // userStatusList – 用户状态列表
  @HawkApi(ignore: true)
  Stream<List<NIMUserStatus>> get onUserStatusChanged =>
      _platform.onUserStatusChanged;

  ///订阅用户状态，包括在线状态，或自定义状态 单次订阅人数最多100，
  ///如果有较多人数需要调用，需多次调用该接口
  ///如果同一账号多端重复订阅， 订阅有效期会默认后一次覆盖前一次时长 总订阅人数最多3000，
  ///被订阅人数3000，为了性能考虑， 在线状态事件订阅是单向的，双方需要各自订阅。
  ///如果接口整体失败，则返回调用错误码 如果部分账号失败，则返回失败账号列表
  ///订阅接口后，有成员在线状态变更会触发回调：onUserStatusChanged
  // Params:
  // option – 订阅请求参数
  // 返回订阅失败的账号列表
  Future<NIMResult<List<String>>> subscribeUserStatus(
      NIMSubscribeUserStatusOption option) async {
    return _platform.subscribeUserStatus(option);
  }

  ///取消用户状态订阅请求
  // Params:
  // option – 取消订阅请求参数
  // 返回取消订阅失败的账号列表
  Future<NIMResult<List<String>>> unsubscribeUserStatus(
      NIMUnsubscribeUserStatusOption option) async {
    return _platform.unsubscribeUserStatus(option);
  }

  ///发布用户自定义状态，如果默认在线状态不满足业务需求，可以发布自定义用户状态
  // Params:
  // params – 自定义用户状态参数
  Future<NIMResult<NIMCustomUserStatusPublishResult>> publishCustomUserStatus(
      NIMCustomUserStatusParams params) async {
    return _platform.publishCustomUserStatus(params);
  }

  ///查询用户状态订阅关系 输入账号列表，查询自己订阅了哪些账号列表， 返回订阅账号列表
  // Params:
  // accountIds – 需要查询的账号列表，查询自己是否订阅了对应账号
  // 如果账号列表为空， 表示查询用户状态的所有订阅关系，就是自定全部订阅了哪些账号
  // 如果账号列表不为空，单次查询不超过3000， 数值越大查询时间越久，尽量按需查询，建议限制在100以内
  Future<NIMResult<List<NIMUserStatusSubscribeResult>>>
      queryUserStatusSubscriptions(List<String> accountIds) async {
    return _platform.queryUserStatusSubscriptions(accountIds);
  }
}
