// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:js_interop';

import 'js_dart_converter.dart';

/// 格式化 V2NIM 消息对象
/// 对应 TS 中间层的 formatV2Message()
/// 在 attachment 中注入 nimCoreMessageType 字段，
/// 使 NIMMessageAttachment.fromJson() 能正确解析附件类型
Map<String, dynamic> formatV2Message(JSObject jsMessage) {
  final map = jsObjectToMap(jsMessage);
  _injectMessageType(map);
  _formatPushConfig(map);
  _normalizeMessageStringFields(map);
  return map;
}

/// 格式化会话中的 lastMessage
/// 对应 TS 中间层的 formatV2ConversationLastMessage()
Map<String, dynamic> formatV2ConversationLastMessage(JSObject jsConversation) {
  final map = jsObjectToMap(jsConversation);
  final lastReadTime = getJSIntProperty(jsConversation, 'lastReadTime');
  if (lastReadTime != null) {
    map['lastReadTime'] = lastReadTime;
  }
  final lastMessage = map['lastMessage'];
  if (lastMessage is Map<String, dynamic>) {
    _injectMessageType(lastMessage);
  } else if (lastMessage is Map) {
    // dartify() 产生的嵌套 lastMessage 可能是 Map<dynamic, dynamic>，需要转换后写回
    final lastMessageMap = Map<String, dynamic>.from(lastMessage);
    _injectMessageType(lastMessageMap);
    map['lastMessage'] = lastMessageMap;
  }
  return map;
}

/// 在消息的 attachment 中注入 nimCoreMessageType
/// jsObjectToMap 的顶层是 Map<String, dynamic>，但其嵌套值经 dartify() 转换后
/// 可能是 Map<dynamic, dynamic>，需要先做类型转换再注入字段并写回。
void _injectMessageType(Map<String, dynamic> messageMap) {
  final attachment = messageMap['attachment'];
  if (attachment == null) return;
  if (attachment is Map<String, dynamic>) {
    attachment['nimCoreMessageType'] = messageMap['messageType'];
  } else if (attachment is Map) {
    // dartify() 产生的嵌套 Map 是 Map<dynamic, dynamic>，需要转换后写回
    final attachmentMap = Map<String, dynamic>.from(attachment);
    attachmentMap['nimCoreMessageType'] = messageMap['messageType'];
    messageMap['attachment'] = attachmentMap;
  }
}

/// 格式化 pushConfig，确保 forcePushAccountIds 是列表
/// 对应 TS 中间层的 formatV2PushConfig()
void _formatPushConfig(Map<String, dynamic> messageMap) {
  final pushConfig = messageMap['pushConfig'];
  if (pushConfig is Map<String, dynamic>) {
    final forcePushAccountIds = pushConfig['forcePushAccountIds'];
    if (forcePushAccountIds is String) {
      pushConfig['forcePushAccountIds'] = <String>[];
    }
  }
}

/// 批量格式化消息列表
List<Map<String, dynamic>> formatV2MessageList(JSArray jsMessages) {
  final dartList = jsMessages.toDart;
  return dartList.map((item) {
    if (item != null && item.isA<JSObject>()) {
      return formatV2Message(item as JSObject);
    }
    return <String, dynamic>{};
  }).toList();
}

/// 批量格式化会话列表（处理 lastMessage）
List<Map<String, dynamic>> formatV2ConversationList(JSArray jsConversations) {
  final dartList = jsConversations.toDart;
  return dartList.map((item) {
    if (item != null && item.isA<JSObject>()) {
      return formatV2ConversationLastMessage(item as JSObject);
    }
    return <String, dynamic>{};
  }).toList();
}

/// 将消息 Map 中 JS 侧可能返回数字类型的 String? 字段统一转为字符串
///
/// Web SDK 的 V2NIMMessageConverter.messageDeserialization() 返回的对象中，
/// messageServerId 是 JS number 类型，但 Dart 模型声明为 String?。
/// NIMMessage.g.dart 和 NIMMessageRefer.g.dart 均使用 `as String?` 强转，
/// 若类型不匹配会抛出 TypeError。本函数在进入 fromJson 前统一做安全转换。
void _normalizeMessageStringFields(Map<String, dynamic> messageMap) {
  // 顶层消息字段
  _coerceToString(messageMap, 'messageServerId');

  // threadRoot / threadReply 中的 messageServerId
  for (final refKey in ['threadRoot', 'threadReply']) {
    final ref = messageMap[refKey];
    if (ref is Map<String, dynamic>) {
      _coerceToString(ref, 'messageServerId');
    }
  }
}

/// 将 [map] 中 [key] 对应的值安全转换为字符串（仅当值为非 String 时）
void _coerceToString(Map<String, dynamic> map, String key) {
  final value = map[key];
  if (value != null && value is! String) {
    map[key] = value.toString();
  }
}

/// 对嵌套 messageRefer Map 中的 messageServerId 做字符串安全转换
void _normalizeMessageReferStringFields(Map<String, dynamic> referMap) {
  _coerceToString(referMap, 'messageServerId');
}

/// 格式化 NIMMessagePin / NIMMessagePinNotification 对象
///
/// 处理路径：
/// - getPinnedMessageList 返回的 List<JSObject>
/// - onMessagePinNotification 回调的 JSObject（顶层为 NIMMessagePinNotification）
///
/// 修复点：pin.messageRefer.messageServerId 在 JS 侧为 number，
/// 若不转换则 NIMMessageRefer.g.dart 的 `as String?` 强转会抛出 TypeError。
Map<String, dynamic> formatV2MessagePin(Map<String, dynamic> pinMap) {
  // 处理顶层直接是 NIMMessagePin 的情况（getPinnedMessageList 返回值）
  _normalizePinMessageRefer(pinMap);

  // 处理顶层是 NIMMessagePinNotification 的情况（onMessagePinNotification 回调）
  // NIMMessagePinNotification 包含 pin 字段（NIMMessagePin）
  final pin = pinMap['pin'];
  if (pin is Map<String, dynamic>) {
    _normalizePinMessageRefer(pin);
  }

  return pinMap;
}

/// 格式化单个 NIMMessagePin 中的 messageRefer 字段
void _normalizePinMessageRefer(Map<String, dynamic> pinMap) {
  final messageRefer = pinMap['messageRefer'];
  if (messageRefer is Map<String, dynamic>) {
    _normalizeMessageReferStringFields(messageRefer);
  }
}

/// 格式化 NIMMessageQuickComment / NIMMessageQuickCommentNotification 对象
///
/// 处理路径：
/// - getQuickCommentList 返回的 Map<clientId, List> 中每个评论条目
/// - onMessageQuickCommentNotification 回调的 JSObject（顶层为 NIMMessageQuickCommentNotification）
///
/// 修复点：quickComment.messageRefer.messageServerId 在 JS 侧为 number，需转换为 String。
Map<String, dynamic> formatV2QuickComment(Map<String, dynamic> commentMap) {
  // 处理顶层直接是 NIMMessageQuickComment 的情况
  _normalizeQuickCommentMessageRefer(commentMap);

  // 处理顶层是 NIMMessageQuickCommentNotification 的情况（onMessageQuickCommentNotification 回调）
  // NIMMessageQuickCommentNotification 包含 quickComment 字段（NIMMessageQuickComment）
  final quickComment = commentMap['quickComment'];
  if (quickComment is Map<String, dynamic>) {
    _normalizeQuickCommentMessageRefer(quickComment);
  }

  return commentMap;
}

/// 格式化单个 NIMMessageQuickComment 中的 messageRefer 字段
void _normalizeQuickCommentMessageRefer(Map<String, dynamic> commentMap) {
  final messageRefer = commentMap['messageRefer'];
  if (messageRefer is Map<String, dynamic>) {
    _normalizeMessageReferStringFields(messageRefer);
  }
}

/// 格式化 NIMMessageSearchResult 对象
///
/// 处理路径：searchCloudMessagesEx 返回的 NIMMessageSearchResult
///
/// 修复点：
/// - items[].messages[] 需要注入 nimCoreMessageType（附件类型分发）
/// - items[].messages[].messageServerId 需要转换为 String（JS 侧为 number）
Map<String, dynamic> formatV2SearchResult(Map<String, dynamic> resultMap) {
  final items = resultMap['items'];
  if (items is List) {
    for (final item in items) {
      if (item is Map<String, dynamic>) {
        final messages = item['messages'];
        if (messages is List) {
          for (final msg in messages) {
            if (msg is Map<String, dynamic>) {
              _injectMessageType(msg);
              _coerceToString(msg, 'messageServerId');
            }
          }
        }
      }
    }
  }
  return resultMap;
}

/// 格式化 NIMClearHistoryNotification 对象
///
/// 处理路径：onClearHistoryNotifications 回调的每个通知对象
///
/// 修复点：deleteTime 在 Dart 模型中声明为 double?，但 JS 的 dartify() 在整数值时
/// 会返回 int，导致 NIMClearHistoryNotification.g.dart 的 `as double?` 强转失败。
/// 统一将 deleteTime 转换为 double 类型。
Map<String, dynamic> formatV2ClearHistoryNotification(
    Map<String, dynamic> notificationMap) {
  final deleteTime = notificationMap['deleteTime'];
  if (deleteTime != null && deleteTime is! double) {
    notificationMap['deleteTime'] = (deleteTime as num).toDouble();
  }
  return notificationMap;
}
