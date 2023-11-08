// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/method_channel/method_channel_chatroom_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class ChatroomServicePlatform extends Service {
  ChatroomServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static ChatroomServicePlatform _instance = MethodChannelChatroomService();

  static ChatroomServicePlatform get instance => _instance;

  static set instance(ChatroomServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 设置聊天室独立模式link地址提供者。
  /// 独立模式由于不依赖IM连接，SDK无法自动获取聊天室服务器的地址，需要客户端向SDK提供该地址。
  /// 独立模式下需要设置该字段，否则无法进入聊天室
  NIMChatroomIndependentModeLinkAddressProvider?
      independentModeLinkAddressProvider;

  /// 鉴权模式为动态Token或者第三方鉴权的时候需要使用的token提供者
  NIMChatroomDynamicTokenProvider? dynamicChatroomTokenProvider;

  /// 加入聊天室
  /// [request] 加入请求
  Future<NIMResult<NIMChatroomEnterResult>> enterChatroom(
      NIMChatroomEnterRequest request);

  /// 退出聊天室
  Future<NIMResult<void>> exitChatroom(String roomId);

  /// 聊天室事件流
  ///
  /// [NIMChatroomStatusEvent] 聊天室状态事件
  ///
  /// [NIMChatroomKickOutEvent] 聊天室离开事件
  Stream<NIMChatroomEvent> get onEventNotified;

  /// 创建聊天室消息
  Future<NIMResult<NIMChatroomMessage>> createChatroomMessage(
      Map<String, dynamic> arguments);

  /// 发送聊天室消息
  Future<NIMResult<NIMChatroomMessage>> sendChatroomMessage(
      NIMChatroomMessage message,
      [bool resend = false]);

  /// 接收到聊天室消息
  ///
  Stream<List<NIMChatroomMessage>> get onMessageReceived;

  /// 聊天室消息状态变更
  ///
  Stream<NIMChatroomMessage> get onMessageStatusChanged;

  /// 聊天室消息附件上传/下载进度通知，以 [NIMMessage.uuid] 作为key
  ///
  Stream<NIMAttachmentProgress> get onMessageAttachmentProgressUpdate;

  /// 下载聊天室消息附件
  Future<NIMResult<void>> downloadAttachment(NIMChatroomMessage message,
      [bool thumb = false]) {
    throw UnimplementedError('downloadAttachment() is not implemented');
  }

  /// 获取历史消息,可选择给定时间往前或者往后查询，若方向往前，则结果排序按时间逆序，反之则结果排序按时间顺序。
  ///
  /// [roomId]    聊天室id <p>
  /// [startTime] 时间戳，单位毫秒 <p>
  /// [limit]     可拉取的消息数量 <p>
  /// [direction] 查询方向 <p>
  /// [messageTypeList] 查询的消息类型
  Future<NIMResult<List<NIMChatroomMessage>>> fetchMessageHistory({
    required String roomId,
    required int startTime,
    required int limit,
    required QueryDirection direction,
    List<NIMMessageType>? messageTypeList,
  }) async {
    throw UnimplementedError('fetchMessageHistory is not implemented');
  }

  /// 获取当前聊天室信息
  Future<NIMResult<NIMChatroomInfo>> fetchChatroomInfo(String roomId) async {
    throw UnimplementedError('fetchChatroomInfo is not implemented');
  }

  /// 更新聊天室信息
  Future<NIMResult<void>> updateChatroomInfo({
    required String roomId,
    required NIMChatroomUpdateRequest request,
    bool needNotify = true,
    Map<String, dynamic>? notifyExtension,
  }) async {
    throw UnimplementedError('updateChatroomInfo is not implemented');
  }

  /// 获取当前聊天室成员
  ///
  /// [roomId]    聊天室id <p>
  /// [queryType] 查询的类型, [NIMChatroomMemberQueryType]
  /// [limit]     可拉取的消息数量 <p>
  /// [lastMemberAccount] 最后一位成员锚点，不包括此成员。填nil会使用当前服务器最新时间开始查询，即第一页。 <p>
  Future<NIMResult<List<NIMChatroomMember>>> fetchChatroomMembers({
    required String roomId,
    required NIMChatroomMemberQueryType queryType,
    required int limit,
    String? lastMemberAccount,
  }) async {
    throw UnimplementedError('fetchChatroomMembers is not implemented');
  }

  /// 获取当前聊天室成员
  ///
  /// [roomId]      聊天室id <p>
  /// [accountList] 成员账号列表 <p>
  Future<NIMResult<List<NIMChatroomMember>>> fetchChatroomMembersByAccount({
    required String roomId,
    required List<String> accountList,
  }) async {
    throw UnimplementedError(
        'fetchChatroomMembersByAccount is not implemented');
  }

  /// 更新聊天室内的自身信息
  /// [roomId]               聊天室id
  /// [request]              可更新的本人角色信息
  /// [needNotify]           是否通知
  /// [notifyExtension]      更新聊天室信息扩展字段，这个字段会放到更新聊天室信息通知的扩展字段中
  Future<NIMResult<void>> updateChatroomMyMemberInfo({
    required String roomId,
    required NIMChatroomUpdateMyMemberInfoRequest request,
    bool needNotify = true,
    Map<String, dynamic>? notifyExtension,
  }) async {
    throw UnimplementedError('updateChatroomMyMemberInfo is not implemented');
  }

  ///
  /// 设置/取消设置聊天室管理员
  ///
  /// [isAdd]        true:设置, false:取消设置
  /// [memberOption] 请求参数，包含聊天室id，帐号id以及可选的扩展字段
  Future<NIMResult<NIMChatroomMember>> markChatroomMemberBeManager({
    required bool isAdd,
    required NIMChatroomMemberOptions options,
  });

  ///
  /// 设置/取消设置聊天室普通成员
  ///
  /// [isAdd]        true:设置, false:取消设置
  /// [memberOption] 请求参数，包含聊天室id，帐号id以及可选的扩展字段
  Future<NIMResult<NIMChatroomMember>> markChatroomMemberBeNormal({
    required bool isAdd,
    required NIMChatroomMemberOptions options,
  });

  ///
  /// 踢掉聊天室特定成员
  ///
  /// [memberOption] 请求参数，包含聊天室id，帐号id以及可选的扩展字段
  Future<NIMResult<void>> kickChatroomMember(NIMChatroomMemberOptions options);

  ///
  /// 添加/移出聊天室黑名单
  ///
  /// [isAdd]        true:设置, false:取消设置
  /// [memberOption] 请求参数，包含聊天室id，帐号id以及可选的扩展字段
  Future<NIMResult<NIMChatroomMember>> markChatroomMemberInBlackList({
    required bool isAdd,
    required NIMChatroomMemberOptions options,
  });

  ///
  /// 添加/解除禁言聊天室成员
  ///
  /// [isAdd]        true:设置, false:取消设置
  /// [memberOption] 请求参数，包含聊天室id，帐号id以及可选的扩展字段
  Future<NIMResult<NIMChatroomMember>> markChatroomMemberMuted({
    required bool isAdd,
    required NIMChatroomMemberOptions options,
  });

  ///
  /// 添加/解除临时禁言聊天室成员
  ///
  /// [duration]     禁言时长，单位ms。设置为 0 会取消禁言
  /// [memberOption] 请求参数，包含聊天室id，帐号id以及可选的扩展字段
  /// [needNotify]   是否需要发送广播通知，true：通知，false：不通知
  Future<NIMResult<void>> markChatroomMemberTempMuted({
    required int duration,
    required NIMChatroomMemberOptions options,
    bool needNotify = false,
  });

  /// 获取聊天室队列
  ///
  /// [roomId] 聊天室ID <p>
  Future<NIMResult<List<NIMChatroomQueueEntry>>> fetchChatroomQueue(
      String roomId);

  /// 更新聊天室队列
  ///
  /// [roomId] 聊天室ID <p>
  /// [entry] 要更新的队列项 <p>
  /// [isTransient] (可选参数，不传默认false)。true表示当提交这个新元素的用户从聊天室掉线或退出的时候，需要删除这个元素；默认false表示不删除
  Future<NIMResult<void>> updateChatroomQueueEntry({
    required String roomId,
    required NIMChatroomQueueEntry entry,
    bool isTransient = false,
  });

  /// 批量更新聊天室队列
  ///
  /// [roomId]          聊天室ID <p>
  /// [entry]           要更新的队列项列表 <p>
  /// [needNotify]      是否需要发送广播通知 <p>
  /// [notifyExtension] 通知中的自定义字段 <p>
  /// 返回不在队列中的元素列表
  Future<NIMResult<List<String>>> batchUpdateChatroomQueue({
    required String roomId,
    required List<NIMChatroomQueueEntry> entryList,
    bool needNotify = true,
    Map<String, dynamic>? notifyExtension,
  });

  /// 从列表中删除某个元素
  ///
  /// [roomId] 聊天室ID <p>
  /// [key] 要删除的key，null表示移除队头元素 <p>
  Future<NIMResult<NIMChatroomQueueEntry>> pollChatroomQueueEntry(
      String roomId, String? key);

  /// 清空聊天室队列
  Future<NIMResult<void>> clearChatroomQueue(String roomId);
}

typedef NIMChatroomIndependentModeLinkAddressProvider = Future<List<String>>
    Function(String roomId, String? account);

typedef NIMChatroomDynamicTokenProvider = Future<String> Function(
    String account, String roomId);
