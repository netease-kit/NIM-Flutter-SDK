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
  /// [base64] 字段为web端专用，web端[filePath] 可传空字符串
  static Future<NIMResult<NIMMessage>> createImageMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required String filePath,
      required int fileSize,
      String? displayName,
      String? base64,
      NIMNosScene nosScene = NIMNosScenes.defaultIm}) async {
    var message = NIMMessage.imageEmptyMessage(
        sessionId: sessionId,
        sessionType: sessionType,
        filePath: filePath,
        fileSize: fileSize,
        base64: base64,
        displayName: displayName,
        nosScene: nosScene);
    return NimCore.instance.messageService._createMessage(message: message);
  }

  /// 创建音频消息
  /// [displayName] 字段无效，不建议使用
  /// [base64] 字段为web端专用，web端[filePath] 可传空字符串
  static Future<NIMResult<NIMMessage>> createAudioMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required String filePath,
      required int fileSize,
      required int duration,
      String? base64,
      String? displayName,
      NIMNosScene nosScene = NIMNosScenes.defaultIm}) async {
    var message = NIMMessage.audioEmptyMessage(
        sessionId: sessionId,
        sessionType: sessionType,
        filePath: filePath,
        fileSize: fileSize,
        base64: base64,
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
  /// [base64] 字段为web端专用，web端[filePath] 可传空字符串
  static Future<NIMResult<NIMMessage>> createVideoMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required String filePath,
      int? fileSize,
      String? base64,
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
        base64: base64,
        width: width,
        height: height,
        displayName: displayName,
        nosScene: nosScene);
    return NimCore.instance.messageService._createMessage(message: message);
  }

  /// 创建文件消息
  /// [base64] 字段为web端专用，web端[filePath] 可传空字符串
  static Future<NIMResult<NIMMessage>> createFileMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      required String filePath,
      String? base64,
      int? fileSize,
      required String displayName,
      NIMNosScene nosScene = NIMNosScenes.defaultIm}) async {
    var message = NIMMessage.fileEmptyMessage(
        sessionId: sessionId,
        sessionType: sessionType,
        base64: base64,
        filePath: filePath,
        fileSize: fileSize,
        displayName: displayName,
        nosScene: nosScene);
    return NimCore.instance.messageService._createMessage(message: message);
  }

  /// 创建Tip消息
  /// /// [content] web端tip内容传这个字段
  static Future<NIMResult<NIMMessage>> createTipMessage(
      {required String sessionId,
      required NIMSessionType sessionType,
      String? content}) async {
    var message = NIMMessage.tipEmptyMessage(
        sessionId: sessionId, sessionType: sessionType);
    message.content = content;
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

  /// NIMMessage转换为json
  static Future<NIMResult<String>> convertMessageToJson(
      {required NIMMessage message}) async {
    return NimCore.instance.messageService._convertMessageToJson(message);
  }

  /// json转换为NIMMessage
  /// 返回结果不支持 yidunAnti相关字段
  static Future<NIMResult<NIMMessage>> convertJsonToMessage(
      {required String json}) async {
    return NimCore.instance.messageService._convertJsonToMessage(json);
  }
}
