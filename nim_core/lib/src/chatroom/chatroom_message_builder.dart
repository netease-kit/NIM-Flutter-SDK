// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core;

class ChatroomMessageBuilder {
  /// 创建文本消息
  static Future<NIMResult<NIMChatroomMessage>> createChatroomTextMessage({
    required String roomId,
    required String text,
  }) async {
    return NimCore.instance.chatroomService._createMessage({
      'roomId': roomId,
      'text': text,
      'messageType': 'text',
    });
  }

  /// 创建图片消息
  static Future<NIMResult<NIMChatroomMessage>> createChatroomImageMessage({
    required String roomId,
    required String filePath,
    String? displayName,
    NIMNosScene nosScene = NIMNosScenes.defaultIm,
  }) async {
    return NimCore.instance.chatroomService._createMessage({
      'roomId': roomId,
      'filePath': filePath,
      'displayName': displayName,
      'nosScene': nosScene,
      'messageType': 'image',
    });
  }

  /// 创建音频消息
  static Future<NIMResult<NIMChatroomMessage>> createChatroomAudioMessage({
    required String roomId,
    required String filePath,
    required int duration,
    NIMNosScene nosScene = NIMNosScenes.defaultIm,
  }) async {
    return NimCore.instance.chatroomService._createMessage({
      'roomId': roomId,
      'filePath': filePath,
      'duration': duration,
      'nosScene': nosScene,
      'messageType': 'audio',
    });
  }

  /// 创建地理位置消息
  static Future<NIMResult<NIMChatroomMessage>> createChatroomLocationMessage({
    required String roomId,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    return NimCore.instance.chatroomService._createMessage({
      'roomId': roomId,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'messageType': 'location',
    });
  }

  /// 创建视频消息
  static Future<NIMResult<NIMChatroomMessage>> createChatroomVideoMessage({
    required String roomId,
    required String filePath,
    required int duration,
    required int width,
    required int height,
    String? displayName,
    NIMNosScene nosScene = NIMNosScenes.defaultIm,
  }) async {
    return NimCore.instance.chatroomService._createMessage({
      'roomId': roomId,
      'filePath': filePath,
      'duration': duration,
      'width': width,
      'height': height,
      'displayName': displayName,
      'nosScene': nosScene,
      'messageType': 'video',
    });
  }

  /// 创建文件消息
  static Future<NIMResult<NIMChatroomMessage>> createChatroomFileMessage({
    required String roomId,
    required String filePath,
    required String displayName,
    NIMNosScene nosScene = NIMNosScenes.defaultIm,
  }) async {
    return NimCore.instance.chatroomService._createMessage({
      'roomId': roomId,
      'filePath': filePath,
      'displayName': displayName,
      'nosScene': nosScene,
      'messageType': 'file',
    });
  }

  /// 创建Tip消息
  static Future<NIMResult<NIMChatroomMessage>> createChatroomTipMessage({
    required String roomId,
  }) async {
    return NimCore.instance.chatroomService._createMessage({
      'roomId': roomId,
      'messageType': 'tip',
    });
  }

  /// 创建机器人消息
  static Future<NIMResult<NIMChatroomMessage>> createChatroomRobotMessage({
    required String roomId,
    required String robotAccount,
    required NIMRobotMessageType type,
    String? text,
    String? content,
    String? target,
    String? params,
  }) async {
    return NimCore.instance.chatroomService._createMessage({
      'roomId': roomId,
      'robotAccount': robotAccount,
      'robotMessageType': _robotMessageTypeMap[type],
      'text': text,
      'content': content,
      'target': target,
      'params': params,
      'messageType': 'robot',
    });
  }

  static Future<NIMResult<NIMChatroomMessage>> createChatroomCustomMessage({
    required String roomId,
    NIMMessageAttachment? attachment,
  }) async {
    return NimCore.instance.chatroomService._createMessage({
      'roomId': roomId,
      'attachment': attachment?.toMap(),
      'messageType': 'custom',
    });
  }
}

const _robotMessageTypeMap = {
  NIMRobotMessageType.text: 'text',
  NIMRobotMessageType.welcome: 'welcome',
  NIMRobotMessageType.link: 'link',
};
