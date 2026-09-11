// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../method_channel/method_channel_chatroom_message_creator_service.dart';

abstract class ChatroomMessageCreatorServicePlatform extends Service {
  ChatroomMessageCreatorServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static ChatroomMessageCreatorServicePlatform _instance =
      MethodChannelChatroomMessageCreatorService();

  static ChatroomMessageCreatorServicePlatform get instance => _instance;

  static set instance(ChatroomMessageCreatorServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 构造文本消息
  Future<NIMResult<V2NIMChatroomMessage>> createTextMessage(String text) {
    throw UnimplementedError('createTextMessage() is not implemented');
  }

  /// 构造图片消息
  Future<NIMResult<V2NIMChatroomMessage>> createImageMessage(String imagePath,
      String? name, String? sceneName, int? width, int? height) {
    throw UnimplementedError('createImageMessage() is not implemented');
  }

  /// 构造语音消息
  Future<NIMResult<V2NIMChatroomMessage>> createAudioMessage(
      String audioPath, String? name, String? sceneName, int? duration) {
    throw UnimplementedError('createAudioMessage() is not implemented');
  }

  /// 构造视频消息
  Future<NIMResult<V2NIMChatroomMessage>> createVideoMessage(String videoPath,
      String? name, String? sceneName, int? duration, int? width, int? height) {
    throw UnimplementedError('createVideoMessage() is not implemented');
  }

  /// 构造文件消息
  Future<NIMResult<V2NIMChatroomMessage>> createFileMessage(
      String filePath, String? name, String? sceneName) {
    throw UnimplementedError('createFileMessage() is not implemented');
  }

  /// 构造地理位置消息
  Future<NIMResult<V2NIMChatroomMessage>> createLocationMessage(
      double latitude, double longitude, String? address) {
    throw UnimplementedError('createLocationMessage() is not implemented');
  }

  /// 构造自定义消息消息
  Future<NIMResult<V2NIMChatroomMessage>> createCustomMessage(
      String rawAttachment) {
    throw UnimplementedError('createCustomMessage() is not implemented');
  }

  /// 构造自定义消息消息
  Future<NIMResult<V2NIMChatroomMessage>>
      createCustomMessageWithAttachmentAndSubType(
          String attachment, int subType) {
    throw UnimplementedError(
        'createCustomMessageWithAttachmentAndSubType() is not implemented');
  }

  /// 构造转发消息，消息内容与原消息一样
  Future<NIMResult<V2NIMChatroomMessage>> createForwardMessage(
      V2NIMChatroomMessage message) {
    throw UnimplementedError('createForwardMessage() is not implemented');
  }

  /// 构造提示消息
  Future<NIMResult<V2NIMChatroomMessage>> createTipsMessage(String text) {
    throw UnimplementedError('createTipsMessage() is not implemented');
  }
}
