// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

/// 信令服务
@HawkEntryPoint()
class SignallingService {
  factory SignallingService() {
    if (_singleton == null) {
      _singleton = SignallingService._();
    }
    return _singleton!;
  }

  SignallingService._();

  static SignallingService? _singleton;

  SignallingServicePlatform get _platform => SignallingServicePlatform.instance;

  /// 在线事件回调
  @HawkApi(ignore: true)
  Stream<NIMSignallingEvent> get onOnlineEvent => _platform.onOnlineEvent;

  /// 离线事件回调
  @HawkApi(ignore: true)
  Stream<List<NIMSignallingEvent>> get onOfflineEvent =>
      _platform.onOfflineEvent;

  /// 多端事件回调
  @HawkApi(ignore: true)
  Stream<NIMSignallingEvent> get onMultiClientEvent =>
      _platform.onMultiClientEvent;

  /// 同步还在的信令频道房间列表
  @HawkApi(ignore: true)
  Stream<List<NIMSignallingRoomInfo>> get onSyncRoomInfoList =>
      _platform.onSyncRoomInfoList;

  /// 直接呼叫对方加入房间
  /// 信令正常流程：
  /// 创建房间（createRoom），房间创建默认有效时间2个小时，
  /// 自己加入房间（join）
  /// 邀请对方加入房间（invite）
  /// 上述的房间是信令的房间，不是音视频的房间，因此需要三次向服务器交互才能建立相关流程
  /// call接口同时由服务器实现了上述三个接口的功能， 可以加速呼叫流程， 如果你需要精确控制每一步，则需要调用上述每一个接口
  ///
  /// @param params 呼叫参数
  /// @return Future representing the result of the call
  Future<NIMResult<NIMSignallingCallResult>> call(
      NIMSignallingCallParams params) {
    return _platform.call(params);
  }

  /// 呼叫建立， 包括加入信令频道房间， 同时接受对方呼叫
  /// 组合接口（join+accept）
  /// 如果需要详细处理每一步骤， 则可以单独调用join接口，之后再调用accept接口
  ///
  /// @param params 接受呼叫参数
  /// @return Future representing the result of the call setup
  Future<NIMResult<NIMSignallingCallSetupResult>> callSetup(
      NIMSignallingCallSetupParams params) {
    return _platform.callSetup(params);
  }

  /// 创建信令房间
  /// 频道与房间一一对应， 可以理解为同一个东西
  /// 相同的频道名，在服务器同时只能存在一个
  /// 房间创建默认有效时间2个小时
  ///
  /// @param channelType 频道类型
  /// @param channelName 频道名称
  /// @param channelExtension 频道扩展字段
  /// @return Future representing the result of the room creation
  Future<NIMResult<NIMSignallingChannelInfo>> createRoom(
      NIMSignallingChannelType channelType,
      String? channelName,
      String? channelExtension) {
    return _platform.createRoom(channelType, channelName, channelExtension);
  }

  /// 关闭信令房间
  /// 该接口调用后会触发关闭通知给房间内所有人
  /// 房间内的所有人均可以调用该接口
  /// 信令房间如果没有主动调用接口关闭，会等待2个小时，2个小时没有新的用户加入，则服务器自行销毁对应的信令房间
  ///
  /// @param channelId 频道ID
  /// @param offlineEnabled 是否需要存离线消息。如果存离线，则用户离线再上线会收到该通知
  /// @param serverExtension 服务端扩展字段， 长度限制4096
  /// @return Future representing the result of the room closure
  Future<NIMResult<void>> closeRoom(
      String channelId, bool? offlineEnabled, String? serverExtension) {
    return _platform.closeRoom(channelId, offlineEnabled, serverExtension);
  }

  /// 加入信令房间
  /// 该接口调用后会触发加入通知给房间内所有人
  /// 默认有效期为5分钟
  ///
  /// @param params 加入房间参数
  /// @return Future representing the result of joining the room
  Future<NIMResult<V2NIMSignallingJoinResult>> joinRoom(
      NIMSignallingJoinParams params) {
    return _platform.joinRoom(params);
  }

  /// 离开信令房间
  /// 该接口调用后会触发离开通知给房间内所有人
  ///
  /// @param channelId 频道ID
  /// @param offlineEnabled 是否需要存离线消息。如果存离线，则用户离线再上线会收到该通知
  /// @param serverExtension 服务端扩展字段， 长度限制4096
  /// @return Future representing the result of leaving the room
  Future<NIMResult<void>> leaveRoom(
      String channelId, bool? offlineEnabled, String? serverExtension) {
    return _platform.leaveRoom(channelId, offlineEnabled, serverExtension);
  }

  /// 邀请他人加入信令房间
  /// 该接口调用后会触发邀请通知给对方， 发送方可以配置是否需要发送推送
  /// 默认不推送
  /// 如果不配置推送相关信息， 则服务器回填默认内容
  /// 音频： xx邀请你进行语音通话
  /// 视频：xx邀请你进行视频通话
  /// 其它： xx邀请你进行音视频通话
  /// 房间内的人均可以发送邀请
  ///
  /// @param params 邀请参数
  /// @return Future representing the result of the invitation
  Future<NIMResult<void>> invite(NIMSignallingInviteParams params) {
    return _platform.invite(params);
  }

  /// 取消邀请
  ///
  /// @param params 取消邀请参数
  /// @return Future representing the result of the invitation cancellation
  Future<NIMResult<void>> cancelInvite(NIMSignallingCancelInviteParams params) {
    return _platform.cancelInvite(params);
  }

  /// 拒绝别人的邀请加入信令房间请求
  /// 该接口调用后会触发拒绝邀请通知给对方
  ///
  /// @param params 拒绝邀请参数
  /// @return Future representing the result of rejecting the invitation
  Future<NIMResult<void>> rejectInvite(NIMSignallingRejectInviteParams params) {
    return _platform.rejectInvite(params);
  }

  /// 接受别人的邀请加入信令房间请求
  /// 该接口调用后会触发接受邀请通知给对方
  ///
  /// @param params 接受邀请参数
  /// @return Future representing the result of accepting the invitation
  Future<NIMResult<void>> acceptInvite(NIMSignallingAcceptInviteParams params) {
    return _platform.acceptInvite(params);
  }

  /// 发送控制消息
  /// 发送自定义控制指令，可以实现自定义相关的业务逻辑
  /// 可以发送给指定用户， 如果不指定， 则发送给信令房间内的所有人
  /// 该接口不做成员校验， 允许非频道房间内的成员调用， 但是接受者必须在频道房间内或者是创建者
  /// 接口调用后会发送一个控制通知
  /// 如果指定了接受者： 则通知发送给接受者
  /// 如果未指定接受者：则发送给房间内的所有人
  /// 通知仅发在线
  ///
  /// @param channelId 频道ID
  /// @param receiverAccountId 接收者账号ID， 如果
  /// 空，则发送给房间内所有人
  /// @param serverExtension 服务端扩展字段， 长度限制4096，自定义控制数据，建议json格式
  /// @return Future representing the result of sending the control message
  Future<NIMResult<void>> sendControl(
      String channelId, String receiverAccountId, String? serverExtension) {
    return _platform.sendControl(channelId, receiverAccountId, serverExtension);
  }

  /// 根据频道名称查询频道房间信息
  /// 相同的频道名，在服务器同时只能存在一个
  ///
  /// @param channelName 房间名称
  /// @return Future representing the result of getting room information by channel name
  Future<NIMResult<NIMSignallingRoomInfo>> getRoomInfoByChannelName(
      String channelName) {
    return _platform.getRoomInfoByChannelName(channelName);
  }
}
