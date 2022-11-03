// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core;

///信令服务类
///目前仅支持iOS和Android平台
class AvSignallingService {
  factory AvSignallingService() {
    if (_singleton == null) {
      _singleton = AvSignallingService._();
    }
    return _singleton!;
  }

  AvSignallingService._();

  static AvSignallingService? _singleton;

  AvSignallingServicePlatform _platform = AvSignallingServicePlatform.instance;

  /// 在线通知事件回调
  /// 回调返回为[ChannelCommonEvent]的对象
  /// 可以根据事件类型获取对象中的特殊属性
  Stream<ChannelCommonEvent> get onlineNotification =>
      _platform.onlineNotification;

  ///离线通知事件观察者，在用户登录后sdk 会去服务器同步用户离线期间发生的各种通知，并以列表的形式返回。
  /// 列表的排序方式为时间递增排序。
  /// 注意：登录后第一次注册此回调时，如果sdk已经获取到了相应的离线通知列表，会立即回调一次（仅此一次）。
  /// 可以根据事件类型获取对象中的特殊属性
  Stream<List<ChannelCommonEvent>> get offlineNotification =>
      _platform.offlineNotification;

  /// 频道成员更新事件回调
  ///
  /// 回调参数为成员更新事件，其中包含了最新的频道的完整信息(频道信息+成员列表)
  /// 注意：如果是有成员离开或加入频道，正常情况下会优先通过[onlineNotification]的回调来通知用户。
  /// 此回调的时机如下： 如果有成员信息的变更（而不是成员数量增减）或异常情况（有成员数量变更但是sdk没有回调[onlineNotification]）
  Stream<SyncChannelEvent> get onMemberUpdateNotification =>
      _platform.onMemberUpdateNotification;

  ///其他端响应（接收/拒绝）邀请事件回调，当其他端响应了邀请时触发
  Stream<ChannelCommonEvent> get otherClientInviteAckNotification =>
      _platform.otherClientInviteAckNotification;

  /// 同步未退出频道列表事件回调 ，在用户登录后sdk会去服务器获取当前还未退出的频道列表 。
  /// 注意：登录后第一次注册此回调时，如果sdk已经获取到了相应的频道列表，会立即回调一次（仅此一次）。
  Stream<List<SyncChannelEvent>> get syncChannelListNotification =>
      _platform.syncChannelListNotification;

  /// 创建频道
  /// 同一时刻频道名互斥，不能重复创建，但如果频道名缺省，服务器会自动分配频道id。
  /// 错误码如下：
  /// 10405：频道已存在
  ///
  /// [type] 频道类型
  /// [channelName] 频道名，可缺省
  /// [channelExt]  频道的自定义扩展信息，可缺省
  Future<NIMResult<ChannelBaseInfo>> createChannel(
      {required ChannelType type, String? channelName, String? channelExt}) {
    return _platform.createChannel(
        type: type, channelName: channelName, channelExt: channelExt);
  }

  /// 关闭频道
  /// 错误码如下：
  /// 10406：不在频道内
  ///
  /// [channelId]      对应频道id
  /// [offlineEnabled] 通知事件是否存离线
  /// [customInfo]     操作者附加的自定义信息，透传给其他人，可缺省
  Future<NIMResult<void>> closeChannel(
      {required String channelId,
      required bool offlineEnabled,
      String? customInfo}) {
    return _platform.closeChannel(
        channelId: channelId,
        offlineEnabled: offlineEnabled,
        customInfo: customInfo);
  }

  /// 加入频道
  /// 错误码如下：
  /// 10407：已经频道内
  /// 10417：uid冲突
  /// 10419：频道人数超限,默认100，可通过APPID配置
  /// 10420：自己的其他端已经在频道内
  ///
  ///  [channelId]     对应频道id
  ///  [selfUid]       自己在频道中对应的uid，可选，大于零有效，无效时服务器会分配随机唯一的uid， 也可以自己生成，但要保证唯一性
  ///  [customInfo]    操作者附加的自定义信息，透传给其他人，可缺省
  ///  [offlineEnable] 通知事件是否存离线
  Future<NIMResult<ChannelFullInfo>> joinChannel(
      {required String channelId,
      int? selfUid,
      String? customInfo,
      required bool offlineEnabled}) {
    return _platform.joinChannel(
        channelId: channelId,
        selfUid: selfUid,
        customInfo: customInfo,
        offlineEnabled: offlineEnabled);
  }

  /// 离开频道
  /// 错误码如下：
  /// 10406：不在频道内
  ///
  ///  [channelId]     对应频道id
  ///  [offlineEnable] 通知事件是否存离线
  ///  [customInfo]    操作者附加的自定义信息，透传给其他人，可缺省
  Future<NIMResult<void>> leaveChannel(
      {required String channelId,
      required bool offlineEnabled,
      String? customInfo}) {
    return _platform.leaveChannel(
        channelId: channelId,
        offlineEnabled: offlineEnabled,
        customInfo: customInfo);
  }

  /// 邀请他人加入频道
  /// 该接口用于邀请对方加入频道，邀请者必须是创建者或者是频道中成员。如果需要对离线成员邀请，
  /// 可以打开离线邀请开关并填写推送信息，被邀请者上线后通过离线通知接收到该邀请。
  /// 错误码如下：
  /// 10201：已经成功发出邀请但是对方不在线（推送可达，但是离线）
  /// 10202：已经成功发出邀请但是对方推送不可达
  /// 10404：频道不存在
  /// 10406：自己不在频道内（仅对于普通用户，频道创建者不在频道内也可以邀请别人）
  /// 10407：对方已经频道内
  /// 10419：频道人数超限
  /// [inviteParam]
  Future<NIMResult<void>> invite(InviteParam inviteParam) {
    return _platform.invite(inviteParam);
  }

  /// 取消邀请
  /// 错误码如下：
  /// 10404：频道不存在
  /// 10408：邀请不存在或已过期 （过期时间2min）
  /// 10409：邀请已经拒绝
  /// 10410：邀请已经接受
  /// [inviteParam]
  Future<NIMResult<void>> cancelInvite(InviteParam inviteParam) {
    return _platform.cancelInvite(inviteParam);
  }

  /// 拒绝对方邀请
  /// 错误码如下：
  /// 10201：已经成功拒绝邀请但是对方不在线（推送可达，但是离线）
  /// 10404：频道不存在
  /// 10408：邀请不存在或已过期
  /// 10409：邀请已经拒绝
  /// 10410：邀请已经接受
  /// [paramBuilder]
  Future<NIMResult<void>> rejectInvite(InviteParam inviteParam) {
    return _platform.rejectInvite(inviteParam);
  }

  /// 接受对方邀请，但并不代表加入了频道
  /// 错误码如下：
  /// 10201：已经成功接受邀请但是对方不在线（推送可达，但是离线）
  /// 10404：频道不存在
  /// 10408：邀请不存在或已过期
  /// 10409：邀请已经拒绝
  /// 10410：邀请已经接受
  /// [paramBuilder]
  Future<NIMResult<void>> acceptInvite(InviteParam inviteParam) {
    return _platform.acceptInvite(inviteParam);
  }

  /// 该接口用于在频道中透传一些自定义指令，协助频道管理。该接口允许非频道内成员调用，但接收者必须是频道内成员或创建者
  ///
  /// 错误码如下：
  /// 10201：已经成功发出命令但是对方不在线（推送可达，但是离线）
  /// 10404:频道不存在
  /// 10406:不在频道内（自己或者对方）
  /// [channelId]  频道id
  /// [accountId]  对方accid，如果为空，则通知所有人
  /// [customInfo] 操作者附加的自定义信息，透传给其他人，可缺省
  Future<NIMResult<void>> sendControl(
      {required String channelId,
      required String accountId,
      String? customInfo}) {
    return _platform.sendControl(
        channelId: channelId, accountId: accountId, customInfo: customInfo);
  }

  /// 直接呼叫 ， 用于用户新开一个频道并邀请对方加入频道。该接口为组合接口，等同于用户先创建频道，然后加入频道并邀请对方。
  /// 错误码如下：
  /// 10201:已经成功发出邀请但是对方不在线（推送可达，但是离线）
  /// 10202:已经成功发出邀请但是对方推送不可达
  /// 10405:频道已存在
  /// [callParamBuilder]
  Future<NIMResult<ChannelFullInfo>> call(CallParam callParam) {
    return _platform.call(callParam);
  }

  /// 根据channelName反查channelInfo
  /// 10404:频道不存在
  /// [channelName]
  Future<NIMResult<ChannelFullInfo>> queryChannelInfo(String channelName) {
    return _platform.queryChannelInfo(channelName);
  }
}
