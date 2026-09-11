// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

class V2NIMChatroomMessageCreator {
  static ChatroomMessageCreatorServicePlatform get _platform =>
      ChatroomMessageCreatorServicePlatform.instance;

  /// 构造文本消息
  static Future<NIMResult<V2NIMChatroomMessage>> createTextMessage(
      String text) {
    return _platform.createTextMessage(text);
  }

  /// 构造图片消息
  static Future<NIMResult<V2NIMChatroomMessage>> createImageMessage(
      String imagePath,
      {String? name,
      String? sceneName,
      required int width,
      required int height}) {
    return _platform.createImageMessage(
        imagePath, name, sceneName, width, height);
  }

  /// 构造语音消息
  static Future<NIMResult<V2NIMChatroomMessage>> createAudioMessage(
      String audioPath,
      {String? name,
      String? sceneName,
      required int duration}) {
    return _platform.createAudioMessage(audioPath, name, sceneName, duration);
  }

  /// 构造视频消息
  static Future<NIMResult<V2NIMChatroomMessage>> createVideoMessage(
      String videoPath,
      {String? name,
      String? sceneName,
      required int duration,
      required int width,
      required int height}) {
    return _platform.createVideoMessage(
        videoPath, name, sceneName, duration, width, height);
  }

  /// 构造文件消息
  static Future<NIMResult<V2NIMChatroomMessage>> createFileMessage(
      String filePath,
      {String? name,
      String? sceneName}) {
    return _platform.createFileMessage(filePath, name, sceneName);
  }

  /// 构造地理位置消息
  static Future<NIMResult<V2NIMChatroomMessage>> createLocationMessage(
      double latitude, double longitude, String? address) {
    return _platform.createLocationMessage(latitude, longitude, address);
  }

  /// 构造自定义消息消息
  static Future<NIMResult<V2NIMChatroomMessage>> createCustomMessage(
      String rawAttachment) {
    return _platform.createCustomMessage(rawAttachment);
  }

  /// 构造自定义消息消息
  static Future<NIMResult<V2NIMChatroomMessage>>
      createCustomMessageWithAttachmentAndSubType(
          String attachment, int subType) {
    return _platform.createCustomMessageWithAttachmentAndSubType(
        attachment, subType);
  }

  /// 构造转发消息，消息内容与原消息一样
  static Future<NIMResult<V2NIMChatroomMessage>> createForwardMessage(
      V2NIMChatroomMessage message) {
    return _platform.createForwardMessage(message);
  }

  /// 构造提示消息
  static Future<NIMResult<V2NIMChatroomMessage>> createTipsMessage(
      String text) {
    return _platform.createTipsMessage(text);
  }
}
