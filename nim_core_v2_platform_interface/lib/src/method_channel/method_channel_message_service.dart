// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

class MethodChannelMessageService extends MessageServicePlatform {
  static MessageServicePlatform _instance = MethodChannelMessageService();

  @override
  String get serviceName => 'MessageService';

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) {
    assert(() {
      print(
          'MethodChannelMessageService onEvent method = $method arguments = ${arguments.toString()}');
      return true;
    }());
    switch (method) {
      case 'onSendMessage':
        var message = NIMMessage.fromJson(Map<String, dynamic>.from(arguments));
        MessageServicePlatform.instance.onSendMessage.add(message);
        break;
      case 'onSendMessageProgress':
        var messageProgress = NIMSendMessageProgress.fromJson(
            Map<String, dynamic>.from(arguments));
        MessageServicePlatform.instance.onSendMessageProgress
            .add(messageProgress);
        break;
      case 'onReceiveMessages':
        var messageList = arguments['messages'] as List<dynamic>?;
        List<NIMMessage>? list = messageList
            ?.map((e) => NIMMessage.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null)
          MessageServicePlatform.instance.onReceiveMessages.add(list);
        break;
      case 'onReceiveP2PMessageReadReceipts':
        var messageReceiptList =
            arguments['p2pMessageReadReceipts'] as List<dynamic>?;
        List<NIMP2PMessageReadReceipt>? list = messageReceiptList
            ?.map((e) =>
                NIMP2PMessageReadReceipt.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null)
          MessageServicePlatform.instance.onReceiveP2PMessageReadReceipts
              .add(list);
        break;
      case 'onReceiveTeamMessageReadReceipts':
        var teamMessageReceiptList =
            arguments['teamMessageReadReceipts'] as List<dynamic>?;
        List<NIMTeamMessageReadReceipt>? list = teamMessageReceiptList
            ?.map((e) => NIMTeamMessageReadReceipt.fromJson(
                Map<String, dynamic>.from(e)))
            .toList();
        if (list != null) {
          MessageServicePlatform.instance.onReceiveTeamMessageReadReceipts
              .add(list);
        }
        break;
      case 'onMessageRevokeNotifications':
        var data = arguments['revokeNotifications'] as List<dynamic>?;
        List<NIMMessageRevokeNotification>? list = data
            ?.map((e) => NIMMessageRevokeNotification.fromJson(
                Map<String, dynamic>.from(e)))
            .toList();
        if (list != null)
          MessageServicePlatform.instance.onMessageRevokeNotifications
              .add(list);
        break;
      case 'onMessagePinNotification':
        var pinNotification = NIMMessagePinNotification.fromJson(
            Map<String, dynamic>.from(arguments));
        MessageServicePlatform.instance.onMessagePinNotification
            .add(pinNotification);
        break;
      case 'onMessageQuickCommentNotification':
        var quickCommentNotification =
            NIMMessageQuickCommentNotification.fromJson(
                Map<String, dynamic>.from(arguments));
        MessageServicePlatform.instance.onMessageQuickCommentNotification
            .add(quickCommentNotification);
        break;
      case 'onMessageDeletedNotifications':
        var data = arguments['deletedNotifications'] as List<dynamic>?;
        List<NIMMessageDeletedNotification>? list = data
            ?.map((e) => NIMMessageDeletedNotification.fromJson(
                Map<String, dynamic>.from(e)))
            .toList();
        if (list != null)
          MessageServicePlatform.instance.onMessageDeletedNotifications
              .add(list);
        break;
      case 'onClearHistoryNotifications':
        var data = arguments['clearHistoryNotifications'] as List<dynamic>?;
        List<NIMClearHistoryNotification>? list = data
            ?.map((e) => NIMClearHistoryNotification.fromJson(
                Map<String, dynamic>.from(e)))
            .toList();
        if (list != null)
          MessageServicePlatform.instance.onClearHistoryNotifications.add(list);
        break;
      default:
        throw UnimplementedError('$method has not been implemented');
    }
    return Future.value(null);
  }

  /// 查询历史消息，分页接口，每次默认50条，可以根据参数组合查询各种类型
  /// - Parameters:
  ///   - option: 查询消息配置选项
  @override
  Future<NIMResult<List<NIMMessage>>> getMessageList(
      {required NIMMessageListOption option}) async {
    Map<String, dynamic> arguments = option.toJson();
    return NIMResult<List<NIMMessage>>.fromMap(
        await invokeMethod(
          'getMessageList',
          arguments: {'option': arguments},
        ),
        convert: (json) => (json['messages'] as List<dynamic>?)
            ?.map(
                (e) => NIMMessage.fromJson((e as Map).cast<String, dynamic>()))
            .toList());
  }

  /// 根据ID列表查询消息，只查询本地数据库
  /// - Parameters:
  ///   - messageClientIds: 需要查询的消息客户端ID列表
  @override
  Future<NIMResult<List<NIMMessage>>> getMessageListByIds(
      {required List<String> messageClientIds}) async {
    return NIMResult<List<NIMMessage>>.fromMap(
        await invokeMethod(
          'getMessageListByIds',
          arguments: {'messageClientIds': messageClientIds},
        ),
        convert: (json) => (json['messages'] as List<dynamic>?)
            ?.map(
                (e) => NIMMessage.fromJson((e as Map).cast<String, dynamic>()))
            .toList());
  }

  /// 根据MessageRefer列表查询消息
  /// - Parameters:
  ///   - messageRefers 需要查询的消息Refer列表
  @override
  Future<NIMResult<List<NIMMessage>>> getMessageListByRefers(
      {required List<NIMMessageRefer> messageRefers}) async {
    List<Map<String, dynamic>> messageReferList =
        messageRefers.map((e) => e.toJson()).toList();
    return NIMResult<List<NIMMessage>>.fromMap(
        await invokeMethod(
          'getMessageListByRefers',
          arguments: {
            'messageRefers': messageReferList,
          },
        ),
        convert: (json) => (json['messages'] as List<dynamic>?)
            ?.map(
                (e) => NIMMessage.fromJson((e as Map).cast<String, dynamic>()))
            .toList());
  }

  /// 搜索云端消息
  /// - Parameters:
  ///   - params: 消息检索参数
  @override
  Future<NIMResult<List<NIMMessage>>> searchCloudMessages(
      {required NIMMessageSearchParams params}) async {
    Map<String, dynamic> arguments = params.toJson();
    return NIMResult<List<NIMMessage>>.fromMap(
        await invokeMethod(
          'searchCloudMessages',
          arguments: {'params': arguments},
        ),
        convert: (json) => (json['messages'] as List<dynamic>?)
            ?.map(
                (e) => NIMMessage.fromJson((e as Map).cast<String, dynamic>()))
            .toList());
  }

  /// 本地查询thread聊天消息列表
  /// 如果消息已经删除， 回复数， 回复列表不包括已删除消息
  /// - Parameters:
  ///  - messageRefer: 需要查询的消息引用，如果该消息为根消息，则参数为当前消息；否则需要获取当前消息的跟消息作为输入参数查询；否则查询失败
  @override
  Future<NIMResult<NIMThreadMessageListResult>> getLocalThreadMessageList(
      {required NIMMessageRefer messageRefer}) async {
    Map<String, dynamic> arguments = messageRefer.toJson();
    return NIMResult<NIMThreadMessageListResult>.fromMap(
      await invokeMethod(
        'getLocalThreadMessageList',
        arguments: {'messageRefer': arguments},
      ),
      convert: (map) {
        return NIMThreadMessageListResult.fromJson(map);
      },
    );
  }

  /// 查询thread聊天云端消息列表
  /// 建议查询getLocalThreadMessageList， 本地消息已经完全同步，减少网络请求， 以及避免触发请求频控
  /// - Parameters:
  /// - threadMessageListOption: thread消息查询选项
  @override
  Future<NIMResult<NIMThreadMessageListResult>> getThreadMessageList(
      {required NIMThreadMessageListOption threadMessageListOption}) async {
    Map<String, dynamic> arguments = threadMessageListOption.toJson();
    return NIMResult<NIMThreadMessageListResult>.fromMap(
      await invokeMethod(
        'getThreadMessageList',
        arguments: {'option': arguments},
      ),
      convert: (map) {
        return NIMThreadMessageListResult.fromJson(map);
      },
    );
  }

  /// 插入一条本地消息， 该消息不会
  /// 该消息不会多端同步，只是本端显示
  /// 插入成功后， SDK会抛出回调
  /// - Parameters:
  ///   - message: 需要插入的消息体
  ///   - conversationId: 会话 ID
  ///   - senderId: 消息发送者账号
  ///   - createTime: 指定插入消息时间
  @override
  Future<NIMResult<NIMMessage>> insertMessageToLocal(
      {required NIMMessage message,
      required String conversationId,
      String? senderId,
      int? createTime}) async {
    return NIMResult<NIMMessage>.fromMap(
      await invokeMethod(
        'insertMessageToLocal',
        arguments: {
          'message': message.toJson(),
          'conversationId': conversationId,
          'senderId': senderId,
          'createTime': createTime
        },
      ),
      convert: (map) {
        return NIMMessage.fromJson(map);
      },
    );
  }

  /// 更新消息本地扩展字段
  /// - Parameters:
  ///   - message: 需要被更新的消息体
  ///   - localExtension: 扩展字段
  @override
  Future<NIMResult<NIMMessage>> updateMessageLocalExtension(
      {required NIMMessage message, required String localExtension}) async {
    return NIMResult<NIMMessage>.fromMap(
      await invokeMethod(
        'updateMessageLocalExtension',
        arguments: {
          'message': message.toJson(),
          'localExtension': localExtension
        },
      ),
      convert: (map) {
        return NIMMessage.fromJson(map);
      },
    );
  }

  /// 发送消息
  /// 如果需要更新发送状态，请监听 [onSendMessage]。
  /// 如果需要更新发送进度，请监听 [onSendMessageProgress]。
  /// - Parameters:
  ///   - message: 需要发送的消息体
  ///   - conversationId: 会话Id
  ///   - params: 发送消息相关配置参数
  @override
  Future<NIMResult<NIMSendMessageResult>> sendMessage(
      {required NIMMessage message,
      required String conversationId,
      NIMSendMessageParams? params}) async {
    return NIMResult<NIMSendMessageResult>.fromMap(
      await invokeMethod(
        'sendMessage',
        arguments: {
          'message': message.toJson(),
          'conversationId': conversationId,
          'params': params?.toJson()
        },
      ),
      convert: (map) {
        return NIMSendMessageResult.fromJson(map);
      },
    );
  }

  /// 回复消息
  /// - Parameters:
  ///   - message: 需要发送的消息体
  ///   - replyMessage: 被回复的消息
  @override
  Future<NIMResult<NIMSendMessageResult>> replyMessage(
      {required NIMMessage message,
      required NIMMessage replyMessage,
      NIMSendMessageParams? params}) async {
    return NIMResult<NIMSendMessageResult>.fromMap(
      await invokeMethod(
        'replyMessage',
        arguments: {
          'message': message.toJson(),
          'replyMessage': replyMessage.toJson(),
          'params': params?.toJson()
        },
      ),
      convert: (map) {
        return NIMSendMessageResult.fromJson(map);
      },
    );
  }

  /// 撤回消息
  /// 只能撤回已经发送成功的消息
  /// - Parameters:
  ///   - message: 要撤回的消息
  ///   - revokeParams: 撤回消息相关参数
  @override
  Future<NIMResult<void>> revokeMessage(
      {required NIMMessage message,
      NIMMessageRevokeParams? revokeParams}) async {
    Map<String, dynamic>? revokeParamsJson = revokeParams?.toJson();
    return NIMResult<void>.fromMap(await invokeMethod(
      'revokeMessage',
      arguments: {
        'message': message.toJson(),
        'revokeParams': revokeParamsJson
      },
    ));
  }

  /// Pin一条消息
  /// - Parameters:
  ///   - message: 需要被pin的消息体
  ///   - serverExtension: 扩展字段
  @override
  Future<NIMResult<void>> pinMessage(
      {required NIMMessage message, String? serverExtension}) async {
    return NIMResult<void>.fromMap(await invokeMethod(
      'pinMessage',
      arguments: {
        'message': message.toJson(),
        'serverExtension': serverExtension
      },
    ));
  }

  /// 取消一条Pin消息
  /// - Parameters:
  ///   - messageRefer: 需要被unpin的消息体
  ///   - serverExtension: 扩展字段
  @override
  Future<NIMResult<void>> unpinMessage(
      {required NIMMessageRefer messageRefer, String? serverExtension}) async {
    return NIMResult<void>.fromMap(await invokeMethod(
      'unpinMessage',
      arguments: {
        'messageRefer': messageRefer.toJson(),
        'serverExtension': serverExtension
      },
    ));
  }

  /// 更新一条Pin消息
  /// - Parameters:
  ///   - message: 需要被更新pin的消息体
  ///   - serverExtension: 扩展字段
  @override
  Future<NIMResult<void>> updatePinMessage(
      {required NIMMessage message, String? serverExtension}) async {
    return NIMResult<void>.fromMap(await invokeMethod(
      'updatePinMessage',
      arguments: {
        'message': message.toJson(),
        'serverExtension': serverExtension
      },
    ));
  }

  /// 获取 pin 消息列表
  /// - Parameters:
  ///   - conversationId: 会话 ID
  @override
  Future<NIMResult<List<NIMMessagePin>>> getPinnedMessageList(
      {required String conversationId}) async {
    return NIMResult<List<NIMMessagePin>>.fromMap(
        await invokeMethod(
          'getPinnedMessageList',
          arguments: {'conversationId': conversationId},
        ),
        convert: (json) => (json['pinMessages'] as List<dynamic>?)
            ?.map((e) =>
                NIMMessagePin.fromJson((e as Map).cast<String, dynamic>()))
            .toList());
  }

  /// 添加快捷评论
  /// - Parameters:
  ///   - message: 被快捷评论的消息
  ///   - index: 快捷评论映射标识符
  ///            可以自定义映射关系，例如 表情回复： 可以本地构造映射关系， 1：笑脸  2：大笑， 当前读取到对应的index后，界面展示可以替换对应的表情 还可以应用于其他场景， 文本快捷回复等
  ///   - serverExtension: 扩展字段， 最大8个字符
  ///   - pushConfig: 快捷评论推送配置
  @override
  Future<NIMResult<void>> addQuickComment(
      {required NIMMessage message,
      required int index,
      String? serverExtension,
      NIMMessageQuickCommentPushConfig? pushConfig}) async {
    return NIMResult<void>.fromMap(await invokeMethod(
      'addQuickComment',
      arguments: {
        'message': message.toJson(),
        'index': index,
        'serverExtension': serverExtension,
        'pushConfig': pushConfig?.toJson()
      },
    ));
  }

  /// 移除快捷评论
  /// - Parameters:
  ///   - messageRefer: 被快捷评论的消息
  ///   - index: 快捷评论索引
  ///   - serverExtension: 扩展字段， 最大8个字符
  @override
  Future<NIMResult<void>> removeQuickComment(
      {required NIMMessageRefer messageRefer,
      required int index,
      String? serverExtension}) async {
    return NIMResult<void>.fromMap(await invokeMethod(
      'removeQuickComment',
      arguments: {
        'messageRefer': messageRefer.toJson(),
        'index': index,
        'serverExtension': serverExtension
      },
    ));
  }

  /// 获取快捷评论
  /// - Parameters:
  ///   - messages: 被快捷评论的消息
  @override
  Future<NIMResult<Map<String, List<NIMMessageQuickComment>?>>>
      getQuickCommentList({required List<NIMMessage> messages}) async {
    List<Map<String, dynamic>> messageList =
        messages.map((e) => e.toJson()).toList();
    return NIMResult<Map<String, List<NIMMessageQuickComment>?>>.fromMap(
      await invokeMethod(
        'getQuickCommentList',
        arguments: {'messages': messageList},
      ),
      convert: (map) {
        return (map as Map?)?.map((key, value) {
          return MapEntry(
              key as String,
              (value as List?)
                  ?.map((e) => NIMMessageQuickComment.fromJson(
                      Map<String, dynamic>.from(e as Map)))
                  .toList());
        });
      },
    );
  }

  /// 删除消息
  /// 如果消息未发送成功,则只删除本地消息
  /// - Parameters:
  ///   - message: 需要删除的消息
  ///   - serverExtension: 扩展字段
  ///   - onlyDeleteLocal: 是否只删除本地消息
  ///   true：只删除本地，本地会将该消息标记为删除,getMessage会过滤该消息，界面不展示，卸载重装会再次显示
  ///   fasle：同时删除云端
  @override
  Future<NIMResult<void>> deleteMessage(
      {required NIMMessage message,
      String? serverExtension,
      bool? onlyDeleteLocal}) async {
    return NIMResult<void>.fromMap(await invokeMethod(
      'deleteMessage',
      arguments: {
        'message': message.toJson(),
        'serverExtension': serverExtension,
        'onlyDeleteLocal': onlyDeleteLocal
      },
    ));
  }

  /// 批量删除消息
  /// 如果单条消息未发送成功， 则只删除本地消息
  /// 每次50条, 不能跨会话删除,所有消息都属于同一个会话
  /// 删除本地消息不会多端同步，删除云端会多端同步
  /// - Parameters:
  ///   - messages: 需要删除的消息列表
  ///   - serverExtension: 扩展字段
  ///   - onlyDeleteLocal: 是否只删除本地消息
  ///   true：只删除本地，本地会将该消息标记为删除， getHistoryMessage会过滤该消息，界面不展示，卸载重装会再次显示
  ///   fasle：同时删除云端
  @override
  Future<NIMResult<void>> deleteMessages(
      {required List<NIMMessage> messages,
      String? serverExtension,
      bool? onlyDeleteLocal}) async {
    List<Map<String, dynamic>> messageList =
        messages.map((e) => e.toJson()).toList();
    return NIMResult<void>.fromMap(await invokeMethod(
      'deleteMessages',
      arguments: {
        'messages': messageList,
        'serverExtension': serverExtension,
        'onlyDeleteLocal': onlyDeleteLocal
      },
    ));
  }

  /// 清空历史消息
  /// 同步删除本地消息，云端消息
  /// 会话不会被删除
  /// - Parameters:
  ///   - option: 清空消息配置选项
  @override
  Future<NIMResult<void>> clearHistoryMessage(
      {required NIMClearHistoryMessageOption option}) async {
    Map<String, dynamic> arguments = option.toJson();
    return NIMResult<void>.fromMap(await invokeMethod(
      'clearHistoryMessage',
      arguments: {'option': arguments},
    ));
  }

  /// 发送消息已读回执
  /// - Parameters:
  ///   - message: 需要发送已读回执的消息
  @override
  Future<NIMResult<void>> sendP2PMessageReceipt(
      {required NIMMessage message}) async {
    Map<String, dynamic> arguments = message.toJson();
    return NIMResult<void>.fromMap(await invokeMethod(
      'sendP2PMessageReceipt',
      arguments: {'message': arguments},
    ));
  }

  /// 查询点对点消息已读回执
  /// - Parameters:
  ///   - conversationId: 需要查询已读回执的会话
  @override
  Future<NIMResult<NIMP2PMessageReadReceipt>> getP2PMessageReceipt(
      {required String conversationId}) async {
    return NIMResult<NIMP2PMessageReadReceipt>.fromMap(
      await invokeMethod(
        'getP2PMessageReceipt',
        arguments: {'conversationId': conversationId},
      ),
      convert: (map) {
        return NIMP2PMessageReadReceipt.fromJson(map);
      },
    );
  }

  /// 查询点对点消息是否对方已读 内部判断逻辑为： 消息时间小于对方已读回执时间都为true
  /// - Parameter message: 消息体
  @override
  Future<NIMResult<bool>> isPeerRead({required NIMMessage message}) async {
    Map<String, dynamic> arguments = message.toJson();
    return NIMResult<bool>.fromMap(await invokeMethod(
      'isPeerRead',
      arguments: {'message': arguments},
    ));
  }

  /// 发送群消息已读回执
  /// 所有消息必须属于同一个会话
  /// - Parameters:
  ///   - messages: 需要发送已读回执的消息列表
  @override
  Future<NIMResult<void>> sendTeamMessageReceipts(
      {required List<NIMMessage> messages}) async {
    List<Map<String, dynamic>> messageList =
        messages.map((e) => e.toJson()).toList();
    return NIMResult<void>.fromMap(await invokeMethod(
      'sendTeamMessageReceipts',
      arguments: {'messages': messageList},
    ));
  }

  /// 获取群消息已读回执状态
  /// - Parameters:
  ///   - messages: 需要查询已读回执状态的消息
  @override
  Future<NIMResult<List<NIMTeamMessageReadReceipt>>> getTeamMessageReceipts(
      {required List<NIMMessage> messages}) async {
    List<Map<String, dynamic>> messageList =
        messages.map((e) => e.toJson()).toList();
    return NIMResult<List<NIMTeamMessageReadReceipt>>.fromMap(
        await invokeMethod(
          'getTeamMessageReceipts',
          arguments: {'messages': messageList},
        ),
        convert: (json) => (json['readReceipts'] as List<dynamic>?)
            ?.map((e) => NIMTeamMessageReadReceipt.fromJson(
                (e as Map).cast<String, dynamic>()))
            .toList());
  }

  /// 获取群消息已读回执状态详情
  /// - Parameters:
  ///   - message: 需要查询已读回执状态的消息
  ///   - memberAccountIds: 查找指定的账号列表已读未读
  @override
  Future<NIMResult<NIMTeamMessageReadReceiptDetail>>
      getTeamMessageReceiptDetail(
          {required NIMMessage message, Set<String>? memberAccountIds}) async {
    return NIMResult<NIMTeamMessageReadReceiptDetail>.fromMap(
      await invokeMethod(
        'getTeamMessageReceiptDetail',
        arguments: {
          'message': message.toJson(),
          'memberAccountIds': memberAccountIds?.toList()
        },
      ),
      convert: (map) {
        return NIMTeamMessageReadReceiptDetail.fromJson(map);
      },
    );
  }

  /// 添加收藏
  /// - Parameter params: 收藏参数
  @override
  Future<NIMResult<NIMCollection>> addCollection(
      {required NIMAddCollectionParams params}) async {
    Map<String, dynamic> arguments = params.toJson();
    return NIMResult<NIMCollection>.fromMap(
      await invokeMethod(
        'addCollection',
        arguments: {'params': arguments},
      ),
      convert: (map) {
        return NIMCollection.fromJson(map);
      },
    );
  }

  /// 移除收藏
  /// - Parameter collections: 要移除的收藏列表
  /// - Returns: 返回移除收藏成功的数量
  @override
  Future<NIMResult<int>> removeCollections(
      {required List<NIMCollection> collections}) async {
    List<Map<String, dynamic>> collectionList =
        collections.map((e) => e.toJson()).toList();
    return NIMResult<int>.fromMap(await invokeMethod(
      'removeCollections',
      arguments: {'collections': collectionList},
    ));
  }

  /// 更新收藏扩展字段
  /// - Parameter collection: 需要更新的收藏信息
  /// - Parameter serverExtension: 扩展字段。为空， 表示移除扩展字段, 否则更新为新扩展字段
  @override
  Future<NIMResult<NIMCollection>> updateCollectionExtension(
      {required NIMCollection collection, String? serverExtension}) async {
    return NIMResult<NIMCollection>.fromMap(
      await invokeMethod(
        'updateCollectionExtension',
        arguments: {
          'collection': collection.toJson(),
          'serverExtension': serverExtension
        },
      ),
      convert: (map) {
        return NIMCollection.fromJson(map);
      },
    );
  }

  /// 获取收藏列表
  /// - Parameter option: 查询参数
  @override
  Future<NIMResult<List<NIMCollection>>> getCollectionListByOption(
      {required NIMCollectionOption option}) async {
    Map<String, dynamic> arguments = option.toJson();
    return NIMResult<List<NIMCollection>>.fromMap(
        await invokeMethod(
          'getCollectionListByOption',
          arguments: {'option': arguments},
        ),
        convert: (json) => (json['collections'] as List<dynamic>?)
            ?.map((e) =>
                NIMCollection.fromJson((e as Map).cast<String, dynamic>()))
            .toList());
  }

  /// 语音转文字
  /// - Parameter params: 语音转文字参数
  @override
  Future<NIMResult<String>> voiceToText(
      {required NIMVoiceToTextParams params}) async {
    Map<String, dynamic> arguments = params.toJson();
    return NIMResult<String>.fromMap(await invokeMethod(
      'voiceToText',
      arguments: {'params': arguments},
    ));
  }

  ///取消文件类附件上传，只有文件类消息可以调用该接口
  /// - Parameter message: 需要取消附件上传的消息体
  @override
  Future<NIMResult<void>> cancelMessageAttachmentUpload(
      {required NIMMessage message}) async {
    Map<String, dynamic> arguments = message.toJson();
    return NIMResult<void>.fromMap(
      await invokeMethod(
        'cancelMessageAttachmentUpload',
        arguments: {'message': arguments},
      ),
    );
  }
}
