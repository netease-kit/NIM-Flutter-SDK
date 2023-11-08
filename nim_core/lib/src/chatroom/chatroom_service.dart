// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core;

class ChatroomService {
  factory ChatroomService() {
    if (_singleton == null) {
      _singleton = ChatroomService._();
    }
    return _singleton!;
  }

  ChatroomService._();

  static ChatroomService? _singleton;

  ChatroomServicePlatform get _platform => ChatroomServicePlatform.instance;

  /// 获取聊天室独立模式link地址提供者。
  /// 独立模式下需要设置该字段，否则无法进入聊天室
  NIMChatroomIndependentModeLinkAddressProvider?
      get independentModeLinkAddressProvider {
    return _platform.independentModeLinkAddressProvider;
  }

  /// 设置聊天室独立模式link地址提供者。
  /// 独立模式由于不依赖IM连接，SDK无法自动获取聊天室服务器的地址，需要客户端向SDK提供该地址。
  /// 独立模式下需要设置该字段，否则无法进入聊天室
  set independentModeLinkAddressProvider(
      NIMChatroomIndependentModeLinkAddressProvider? provider) {
    _platform.independentModeLinkAddressProvider = provider;
  }

  // /// 获取动态登录token提供者
  // get dynamicChatroomTokenProvider => _platform.dynamicChatroomTokenProvider;
  //
  // /// 设置动态登录token提供者, loginAuthType=1时必须要设置
  // set dynamicChatroomTokenProvider(dynamicChatroomTokenProvider) =>
  //     _platform.dynamicChatroomTokenProvider = dynamicChatroomTokenProvider;

  /// 加入聊天室
  Future<NIMResult<NIMChatroomEnterResult>> enterChatroom(
      NIMChatroomEnterRequest request) {
    return _platform.enterChatroom(request);
  }

  /// 退出聊天室
  Future<NIMResult<void>> exitChatroom(String roomId) {
    return _platform.exitChatroom(roomId);
  }

  /// 创建消息
  Future<NIMResult<NIMChatroomMessage>> _createMessage(
      Map<String, dynamic> arguments) {
    return _platform.createChatroomMessage(arguments);
  }

  /// 发送聊天室消息
  ///
  /// 聊天室消息通过 [ChatroomMessageBuilder] 进行创建
  ///
  /// [resend] 如果是发送失败后重发，标记为true，否则填false，默认为
  Future<NIMResult<NIMChatroomMessage>> sendChatroomMessage(
      NIMChatroomMessage message,
      [bool resend = false]) async {
    return _platform.sendChatroomMessage(message, resend);
  }

  /// 发送聊天室文本消息
  Future<NIMResult<NIMChatroomMessage>> sendChatroomTextMessage({
    required String roomId,
    required String text,
    bool resend = false,
    ChatroomMessageAction? action,
  }) async {
    return _createMessage({
      'roomId': roomId,
      'text': text,
      'messageType': 'text',
    }).then((messageResult) async {
      if (messageResult.isSuccess) {
        final message = messageResult.data as NIMChatroomMessage;
        await action?.call(message);
        return sendChatroomMessage(message, resend);
      } else {
        return messageResult;
      }
    });
  }

  /// 发送聊天室图片消息
  Future<NIMResult<NIMChatroomMessage>> sendChatroomImageMessage({
    required String roomId,
    required String filePath,
    String? displayName,
    NIMNosScene nosScene = NIMNosScenes.defaultIm,
    bool resend = false,
    ChatroomMessageAction? action,
  }) async {
    return _createMessage({
      'roomId': roomId,
      'filePath': filePath,
      'displayName': displayName,
      'nosScene': nosScene,
      'messageType': 'image',
    }).then((messageResult) async {
      if (messageResult.isSuccess) {
        final message = messageResult.data as NIMChatroomMessage;
        await action?.call(message);
        return sendChatroomMessage(message, resend);
      } else {
        return messageResult;
      }
    });
  }

  /// 发送聊天室音频消息
  Future<NIMResult<NIMChatroomMessage>> sendChatroomAudioMessage({
    required String roomId,
    required String filePath,
    required int duration,
    NIMNosScene nosScene = NIMNosScenes.defaultIm,
    bool resend = false,
    ChatroomMessageAction? action,
  }) async {
    return _createMessage({
      'roomId': roomId,
      'filePath': filePath,
      'duration': duration,
      'nosScene': nosScene,
      'messageType': 'audio',
    }).then((messageResult) async {
      if (messageResult.isSuccess) {
        final message = messageResult.data as NIMChatroomMessage;
        await action?.call(message);
        return sendChatroomMessage(message, resend);
      } else {
        return messageResult;
      }
    });
  }

  /// 发送聊天室地理位置消息
  Future<NIMResult<NIMChatroomMessage>> sendChatroomLocationMessage({
    required String roomId,
    required double latitude,
    required double longitude,
    required String address,
    bool resend = false,
    ChatroomMessageAction? action,
  }) async {
    return _createMessage({
      'roomId': roomId,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'messageType': 'location',
    }).then((messageResult) async {
      if (messageResult.isSuccess) {
        final message = messageResult.data as NIMChatroomMessage;
        await action?.call(message);
        return sendChatroomMessage(message, resend);
      } else {
        return messageResult;
      }
    });
  }

  /// 发送聊天室视频消息
  Future<NIMResult<NIMChatroomMessage>> sendChatroomVideoMessage({
    required String roomId,
    required String filePath,
    required int duration,
    required int width,
    required int height,
    String? displayName,
    NIMNosScene nosScene = NIMNosScenes.defaultIm,
    bool resend = false,
    ChatroomMessageAction? action,
  }) async {
    return _createMessage({
      'roomId': roomId,
      'filePath': filePath,
      'duration': duration,
      'width': width,
      'height': height,
      'displayName': displayName,
      'nosScene': nosScene,
      'messageType': 'video',
    }).then((messageResult) async {
      if (messageResult.isSuccess) {
        final message = messageResult.data as NIMChatroomMessage;
        await action?.call(message);
        return sendChatroomMessage(message, resend);
      } else {
        return messageResult;
      }
    });
  }

  /// 发送聊天室文件消息
  Future<NIMResult<NIMChatroomMessage>> sendChatroomFileMessage({
    required String roomId,
    required String filePath,
    required String displayName,
    NIMNosScene nosScene = NIMNosScenes.defaultIm,
    bool resend = false,
    ChatroomMessageAction? action,
  }) async {
    return _createMessage({
      'roomId': roomId,
      'filePath': filePath,
      'displayName': displayName,
      'nosScene': nosScene,
      'messageType': 'file',
    }).then((messageResult) async {
      if (messageResult.isSuccess) {
        final message = messageResult.data as NIMChatroomMessage;
        await action?.call(message);
        return sendChatroomMessage(message, resend);
      } else {
        return messageResult;
      }
    });
  }

  /// 发送聊天室Tip消息
  Future<NIMResult<NIMChatroomMessage>> sendChatroomTipMessage({
    required String roomId,
    bool resend = false,
    ChatroomMessageAction? action,
  }) async {
    return _createMessage({
      'roomId': roomId,
      'messageType': 'tip',
    }).then((messageResult) async {
      if (messageResult.isSuccess) {
        final message = messageResult.data as NIMChatroomMessage;
        await action?.call(message);
        return sendChatroomMessage(message, resend);
      } else {
        return messageResult;
      }
    });
  }

  /// 创建机器人消息
  Future<NIMResult<NIMChatroomMessage>> sendChatroomRobotMessage({
    required String roomId,
    required String robotAccount,
    required NIMRobotMessageType type,
    String? text,
    String? content,
    String? target,
    String? params,
    bool resend = false,
    ChatroomMessageAction? action,
  }) async {
    return _createMessage({
      'roomId': roomId,
      'robotAccount': robotAccount,
      'robotMessageType': _robotMessageTypeMap[type],
      'text': text,
      'content': content,
      'target': target,
      'params': params,
      'messageType': 'robot',
    }).then((messageResult) async {
      if (messageResult.isSuccess) {
        final message = messageResult.data as NIMChatroomMessage;
        await action?.call(message);
        return sendChatroomMessage(message, resend);
      } else {
        return messageResult;
      }
    });
  }

  /// 发送聊天室自定义消息
  Future<NIMResult<NIMChatroomMessage>> sendChatroomCustomMessage({
    required String roomId,
    NIMMessageAttachment? attachment,
    bool resend = false,
    ChatroomMessageAction? action,
  }) async {
    return _createMessage({
      'roomId': roomId,
      'attachment': attachment?.toMap(),
      'messageType': 'custom',
    }).then((messageResult) async {
      if (messageResult.isSuccess) {
        final message = messageResult.data as NIMChatroomMessage;
        await action?.call(message);
        return sendChatroomMessage(message, resend);
      } else {
        return messageResult;
      }
    });
  }

  /// 聊天室事件流
  ///
  /// [NIMChatroomStatusEvent] 聊天室状态事件
  ///
  /// [NIMChatroomKickOutEvent] 聊天室离开事件
  Stream<NIMChatroomEvent> get onEventNotified {
    return _platform.onEventNotified;
  }

  /// 聊天室消息
  ///
  Stream<List<NIMChatroomMessage>> get onMessageReceived {
    return _platform.onMessageReceived;
  }

  /// 聊天室消息状态变更事件
  ///
  Stream<NIMChatroomMessage> get onMessageStatusChanged =>
      _platform.onMessageStatusChanged;

  /// 聊天室消息附件上传/下载进度通知，以 [NIMMessage.uuid] 作为key
  ///
  Stream<NIMAttachmentProgress> get onMessageAttachmentProgressUpdate =>
      _platform.onMessageAttachmentProgressUpdate;

  /// 下载聊天室消息附件
  Future<NIMResult<void>> downloadAttachment(NIMChatroomMessage message,
      [bool thumb = false]) {
    return _platform.downloadAttachment(message, thumb);
  }

  /// 获取历史消息,可选择给定时间往前或者往后查询，若方向往前，则结果排序按时间逆序，反之则结果排序按时间顺序。
  /// 拉取到的消息中也包含聊天室通知消息。
  ///
  /// [roomId]    聊天室id <p>
  /// [startTime] 时间戳，单位毫秒 <p>
  /// [limit]     可拉取的消息数量，最多100条 <p>
  /// [direction] 查询方向 <p>
  /// [messageTypeList] 查询的消息类型
  Future<NIMResult<List<NIMChatroomMessage>>> fetchMessageHistory({
    required String roomId,
    required int startTime,
    required int limit,
    required QueryDirection direction,
    List<NIMMessageType>? messageTypeList,
  }) {
    return _platform.fetchMessageHistory(
      roomId: roomId,
      startTime: startTime,
      limit: limit,
      direction: direction,
      messageTypeList: messageTypeList,
    );
  }

  /// 获取当前聊天室信息
  Future<NIMResult<NIMChatroomInfo>> fetchChatroomInfo(String roomId) {
    return _platform.fetchChatroomInfo(roomId);
  }

  /// 更新聊天室信息。只有创建者和管理员拥有权限修改聊天室信息。
  /// 可以设置修改是否通知，若设置通知，聊天室内会收到类型为 [NIMChatroomNotificationTypes.chatRoomInfoUpdated] 的消息。
  ///
  /// - [roomId]             聊天室id
  /// - [request]            可更新的聊天室信息
  /// - [needNotify]         是否通知
  /// - [notifyExtension]    更新聊天室信息操作的扩展字段，这个字段会放到更新聊天室信息通知消息的扩展字段中
  Future<NIMResult<void>> updateChatroomInfo({
    required String roomId,
    required NIMChatroomUpdateRequest request,
    bool needNotify = true,
    Map<String, Object>? notifyExtension,
  }) {
    return _platform.updateChatroomInfo(
      roomId: roomId,
      request: request,
      needNotify: needNotify,
      notifyExtension: notifyExtension,
    );
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
  }) {
    return _platform.fetchChatroomMembers(
      roomId: roomId,
      queryType: queryType,
      limit: limit,
      lastMemberAccount: lastMemberAccount,
    );
  }

  /// 获取当前聊天室成员
  ///
  /// [roomId]      聊天室id <p>
  /// [accountList] 成员账号列表 <p>
  Future<NIMResult<List<NIMChatroomMember>>> fetchChatroomMembersByAccount({
    required String roomId,
    required List<String> accountList,
  }) async {
    return _platform.fetchChatroomMembersByAccount(
        roomId: roomId, accountList: accountList);
  }

  /// 更新聊天室内的自身信息
  /// - [roomId]               聊天室id
  /// - [request]              可更新的本人角色信息
  /// - [needNotify]           是否通知
  /// - [notifyExtension]      更新聊天室信息扩展字段，这个字段会放到更新聊天室信息通知的扩展字段中
  Future<NIMResult<void>> updateChatroomMyMemberInfo({
    required String roomId,
    required NIMChatroomUpdateMyMemberInfoRequest request,
    bool needNotify = true,
    Map<String, dynamic>? notifyExtension,
  }) async {
    return _platform.updateChatroomMyMemberInfo(
      roomId: roomId,
      request: request,
      needNotify: needNotify,
      notifyExtension: notifyExtension,
    );
  }

  ///
  /// 设置/取消设置聊天室管理员
  ///
  /// - [isAdd]        true:设置, false:取消设置
  /// - [memberOption] 请求参数，包含聊天室id，帐号id以及可选的扩展字段
  Future<NIMResult<NIMChatroomMember>> markChatroomMemberBeManager({
    required bool isAdd,
    required NIMChatroomMemberOptions options,
  }) {
    return _platform.markChatroomMemberBeManager(
        isAdd: isAdd, options: options);
  }

  ///
  /// 设置/取消设置聊天室普通成员
  ///
  /// - [isAdd]        true:设置, false:取消设置
  /// - [memberOption] 请求参数，包含聊天室id，帐号id以及可选的扩展字段
  Future<NIMResult<NIMChatroomMember>> markChatroomMemberBeNormal({
    required bool isAdd,
    required NIMChatroomMemberOptions options,
  }) {
    return _platform.markChatroomMemberBeNormal(isAdd: isAdd, options: options);
  }

  ///
  /// 踢掉聊天室特定成员
  ///
  /// [memberOption] 请求参数，包含聊天室id，帐号id以及可选的扩展字段
  Future<NIMResult<void>> kickChatroomMember(NIMChatroomMemberOptions options) {
    return _platform.kickChatroomMember(options);
  }

  ///
  /// 添加/移出聊天室黑名单
  ///
  /// - [isAdd]        true:设置, false:取消设置
  /// - [memberOption] 请求参数，包含聊天室id，帐号id以及可选的扩展字段
  Future<NIMResult<NIMChatroomMember>> markChatroomMemberInBlackList({
    required bool isAdd,
    required NIMChatroomMemberOptions options,
  }) {
    return _platform.markChatroomMemberInBlackList(
        isAdd: isAdd, options: options);
  }

  ///
  /// 添加/解除禁言聊天室成员
  ///
  /// - [isAdd]        true:设置, false:取消设置
  /// - [memberOption] 请求参数，包含聊天室id，帐号id以及可选的扩展字段
  Future<NIMResult<NIMChatroomMember>> markChatroomMemberMuted({
    required bool isAdd,
    required NIMChatroomMemberOptions options,
  }) {
    return _platform.markChatroomMemberMuted(isAdd: isAdd, options: options);
  }

  ///
  /// 添加/解除临时禁言聊天室成员
  ///
  /// - [duration]     禁言时长，单位ms。设置为 0 会取消禁言
  /// - [memberOption] 请求参数，包含聊天室id，帐号id以及可选的扩展字段
  /// - [needNotify]   是否需要发送广播通知，true：通知，false：不通知
  Future<NIMResult<void>> markChatroomMemberTempMuted({
    required int duration,
    required NIMChatroomMemberOptions options,
    bool needNotify = false,
  }) {
    return _platform.markChatroomMemberTempMuted(
      duration: duration,
      options: options,
      needNotify: needNotify,
    );
  }

  /// 获取聊天室队列
  ///
  /// [roomId] 聊天室ID <p>
  Future<NIMResult<List<NIMChatroomQueueEntry>>> fetchChatroomQueue(
      String roomId) {
    return _platform.fetchChatroomQueue(roomId);
  }

  /// 更新聊天室队列
  ///
  /// [roomId] 聊天室ID <p>
  /// [entry] 要更新的队列项 <p>
  /// [isTransient] (可选参数，不传默认false)。true表示当提交这个新元素的用户从聊天室掉线或退出的时候，需要删除这个元素；默认false表示不删除
  Future<NIMResult<void>> updateChatroomQueueEntry({
    required String roomId,
    required NIMChatroomQueueEntry entry,
    bool isTransient = false,
  }) {
    return _platform.updateChatroomQueueEntry(
      roomId: roomId,
      entry: entry,
      isTransient: isTransient,
    );
  }

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
  }) {
    return _platform.batchUpdateChatroomQueue(
      roomId: roomId,
      entryList: entryList,
      needNotify: needNotify,
      notifyExtension: notifyExtension,
    );
  }

  /// 从列表中删除某个元素
  ///
  /// [roomId] 聊天室ID <p>
  /// [key] 要删除的key，null表示移除队头元素 <p>
  Future<NIMResult<NIMChatroomQueueEntry>> pollChatroomQueueEntry(
      String roomId, String? key) {
    return _platform.pollChatroomQueueEntry(roomId, key);
  }

  /// 清空聊天室队列
  Future<NIMResult<void>> clearChatroomQueue(String roomId) {
    return _platform.clearChatroomQueue(roomId);
  }
}
