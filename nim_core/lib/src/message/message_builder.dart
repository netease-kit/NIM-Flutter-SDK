// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core;

class MessageBuilder {
  /// 创建空消息
  ///
  /// 创建一条空消息，仅设置了聊天对象以及时间点，用于记录查询
  ///
  /// - [sessionId]   聊天对象ID
  /// - [sessionType] 会话类型
  /// - [timestamp]   查询的时间起点信息
  ///
  static Future<NIMResult<NIMMessage>> createEmptyMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required int timestamp}) async {
    return NIMResult.success(
        data: NIMMessage.emptyMessage(
            sessionId: sessionId,
            sessionType: sessionType,
            timestamp: timestamp));
  }

  /// 创建文本消息
  static Future<NIMResult<NIMMessage>> createTextMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required String text}) async {
    var message = NIMMessage.textEmptyMessage(
        sessionId: sessionId, sessionType: sessionType, text: text);
    return NimCore.instance.messageService._createMessage(message: message);
  }

  /// 创建图片消息
  static Future<NIMResult<NIMMessage>> createImageMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required String filePath,
      required int fileSize,
      String? displayName,
      NIMNosScene nosScene = NIMNosScenes.defaultIm}) async {
    var message = NIMMessage.imageEmptyMessage(
        sessionId: sessionId,
        sessionType: sessionType,
        filePath: filePath,
        fileSize: fileSize,
        displayName: displayName,
        nosScene: nosScene);
    return NimCore.instance.messageService._createMessage(message: message);
  }

  /// 创建音频消息
  static Future<NIMResult<NIMMessage>> createAudioMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required String filePath,
      required int fileSize,
      required int duration,
      String? displayName,
      NIMNosScene nosScene = NIMNosScenes.defaultIm}) async {
    var message = NIMMessage.audioEmptyMessage(
        sessionId: sessionId,
        sessionType: sessionType,
        filePath: filePath,
        fileSize: fileSize,
        duration: duration,
        displayName: displayName,
        nosScene: nosScene);
    return NimCore.instance.messageService._createMessage(message: message);
  }

  /// 创建地理位置消息
  static Future<NIMResult<NIMMessage>> createLocationMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required double latitude,
      required double longitude,
      required String address}) async {
    var message = NIMMessage.locationEmptyMessage(
        sessionId: sessionId,
        sessionType: sessionType,
        latitude: latitude,
        longitude: longitude,
        address: address);
    return NimCore.instance.messageService._createMessage(message: message);
  }

  /// 创建视频消息
  static Future<NIMResult<NIMMessage>> createVideoMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required String filePath,
      int? fileSize,
      required int duration,
      required int width,
      required int height,
      required String displayName,
      NIMNosScene nosScene = NIMNosScenes.defaultIm}) async {
    var message = NIMMessage.videoEmptyMessage(
        sessionId: sessionId,
        sessionType: sessionType,
        filePath: filePath,
        fileSize: fileSize,
        duration: duration,
        width: width,
        height: height,
        displayName: displayName,
        nosScene: nosScene);
    return NimCore.instance.messageService._createMessage(message: message);
  }

  /// 创建文件消息
  static Future<NIMResult<NIMMessage>> createFileMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required String filePath,
      int? fileSize,
      required String displayName,
      NIMNosScene nosScene = NIMNosScenes.defaultIm}) async {
    var message = NIMMessage.fileEmptyMessage(
        sessionId: sessionId,
        sessionType: sessionType,
        filePath: filePath,
        fileSize: fileSize,
        displayName: displayName,
        nosScene: nosScene);
    return NimCore.instance.messageService._createMessage(message: message);
  }

  /// 创建Tip消息
  static Future<NIMResult<NIMMessage>> createTipMessage(
      {required String sessionId, required NIMSessionType sessionType}) async {
    var message = NIMMessage.tipEmptyMessage(
        sessionId: sessionId, sessionType: sessionType);
    return NimCore.instance.messageService._createMessage(message: message);
  }

  /// 创建自定义消息
  static Future<NIMResult<NIMMessage>> createCustomMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      String? content,
      NIMMessageAttachment? attachment,
      NIMCustomMessageConfig? config}) async {
    var message = NIMMessage.customEmptyMessage(
        sessionId: sessionId,
        sessionType: sessionType,
        content: content,
        attachment: attachment,
        config: config);
    return NimCore.instance.messageService._createMessage(message: message);
  }
}
