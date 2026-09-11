// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

class MethodChannelChatroomMessageCreatorService
    extends ChatroomMessageCreatorServicePlatform {
  @override
  String get serviceName => 'V2NIMChatroomMessageCreator';

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) {
    return Future.value(null);
  }

  // 构造文本消息
  Future<NIMResult<V2NIMChatroomMessage>> createTextMessage(String text) async {
    return NIMResult.fromMap(
        await invokeMethod('createTextMessage', arguments: {'text': text}),
        convert: (json) => V2NIMChatroomMessage.fromJson(
            (json as Map).cast<String, dynamic>()));
  }

  /// 构造图片消息
  Future<NIMResult<V2NIMChatroomMessage>> createImageMessage(String imagePath,
      String? name, String? sceneName, int? width, int? height) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'createImageMessage',
          arguments: {
            'imagePath': imagePath,
            'name': name,
            'sceneName': sceneName,
            'width': width,
            'height': height
          },
        ),
        convert: (json) => V2NIMChatroomMessage.fromJson(
            (json as Map).cast<String, dynamic>()));
  }

  /// 构造语音消息
  Future<NIMResult<V2NIMChatroomMessage>> createAudioMessage(
      String audioPath, String? name, String? sceneName, int? duration) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'createAudioMessage',
          arguments: {
            'audioPath': audioPath,
            'name': name,
            'sceneName': sceneName,
            'duration': duration
          },
        ),
        convert: (json) => V2NIMChatroomMessage.fromJson(
            (json as Map).cast<String, dynamic>()));
  }

  /// 构造视频消息
  Future<NIMResult<V2NIMChatroomMessage>> createVideoMessage(
      String videoPath,
      String? name,
      String? sceneName,
      int? duration,
      int? width,
      int? height) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'createVideoMessage',
          arguments: {
            'videoPath': videoPath,
            'name': name,
            'sceneName': sceneName,
            'duration': duration,
            'width': width,
            'height': height
          },
        ),
        convert: (json) => V2NIMChatroomMessage.fromJson(
            (json as Map).cast<String, dynamic>()));
  }

  /// 构造文件消息
  Future<NIMResult<V2NIMChatroomMessage>> createFileMessage(
      String filePath, String? name, String? sceneName) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'createFileMessage',
          arguments: {
            'filePath': filePath,
            'name': name,
            'sceneName': sceneName,
          },
        ),
        convert: (json) => V2NIMChatroomMessage.fromJson(
            (json as Map).cast<String, dynamic>()));
  }

  /// 构造地理位置消息
  Future<NIMResult<V2NIMChatroomMessage>> createLocationMessage(
      double latitude, double longitude, String? address) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'createLocationMessage',
          arguments: {
            'latitude': latitude,
            'longitude': longitude,
            'address': address,
          },
        ),
        convert: (json) => V2NIMChatroomMessage.fromJson(
            (json as Map).cast<String, dynamic>()));
  }

  /// 构造自定义消息消息
  Future<NIMResult<V2NIMChatroomMessage>> createCustomMessage(
      String rawAttachment) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'createCustomMessage',
          arguments: {
            'rawAttachment': rawAttachment,
          },
        ),
        convert: (json) => V2NIMChatroomMessage.fromJson(
            (json as Map).cast<String, dynamic>()));
  }

  /// 构造自定义消息消息
  Future<NIMResult<V2NIMChatroomMessage>>
      createCustomMessageWithAttachmentAndSubType(
          String attachment, int subType) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'createCustomMessageWithAttachmentAndSubType',
          arguments: {
            'attachment': attachment,
            'subType': subType,
          },
        ),
        convert: (json) => V2NIMChatroomMessage.fromJson(
            (json as Map).cast<String, dynamic>()));
  }

  /// 构造转发消息，消息内容与原消息一样
  Future<NIMResult<V2NIMChatroomMessage>> createForwardMessage(
      V2NIMChatroomMessage message) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'createForwardMessage',
          arguments: {
            'message': message.toJson(),
          },
        ),
        convert: (json) => V2NIMChatroomMessage.fromJson(
            (json as Map).cast<String, dynamic>()));
  }

  /// 构造提示消息
  Future<NIMResult<V2NIMChatroomMessage>> createTipsMessage(String text) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'createTipsMessage',
          arguments: {
            'text': text,
          },
        ),
        convert: (json) => V2NIMChatroomMessage.fromJson(
            (json as Map).cast<String, dynamic>()));
  }
}
