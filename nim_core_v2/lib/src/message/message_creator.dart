// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

///消息构建方法
@HawkEntryPoint()
class MessageCreator {
  static MessageCreatorServicePlatform get _platform =>
      MessageCreatorServicePlatform.instance;

  /// 构造文本消息
  ///
  ///  [text] 需要发送的文本内容
  /// @return NIMMessage
  static Future<NIMResult<NIMMessage>> createTextMessage(String text) {
    return _platform.createTextMessage(text);
  }

  /// 构造图片消息
  ///
  ///  [imagePath] 图片文件地址，如果是Web，传""即可
  ///  [imageObj] 图片文件对象, 仅用于web端
  ///  [name] 文件显示名称
  ///  [sceneName] 文件存储场景名
  ///  [width] 图片文件宽度
  ///  [height] 图片文件高度
  ///  [imageObj] 图片文件对象, 仅用于web端
  /// @return NIMMessage
  static Future<NIMResult<NIMMessage>> createImageMessage(
    String imagePath,
    String? name,
    String? sceneName,
    int width,
    int height, {
    html.File? imageObj,
  }) {
    return _platform.createImageMessage(
        imagePath, name, sceneName, width, height,
        imageObj: imageObj);
  }

  /// 构造语音消息
  ///
  ///  [audioPath] 音频文件地址
  ///  [name] 音频文件显示名称
  ///  [sceneName] 文件存储场景名
  /// 自定义场景使用之前， 需要先调用NIMStorageService.addCustomStorageScene新增自定义场景值
  /// 传空默认使用：NIMStorageSceneConfig.DEFAULT_IM
  ///  [duration] 语音文件播放长度
  ///  [audioObj] 语音文件对象, 仅用于web端
  /// @return NIMMessage
  static Future<NIMResult<NIMMessage>> createAudioMessage(
    String audioPath,
    String? name,
    String? sceneName,
    int duration, {
    html.File? audioObj,
  }) {
    return _platform.createAudioMessage(audioPath, name, sceneName, duration,
        audioObj: audioObj);
  }

  /// 构造视频消息
  ///
  ///  [videoPath] 视频文件地址
  ///  [name] 视频文件显示名称
  ///  [sceneName] 文件存储场景名
  /// 自定义场景使用之前， 需要先调用V2NIMStorageService.addCustomStorageScene新增自定义场景值
  /// 传空默认使用：V2NIMStorageSceneConfig.DEFAULT_IM
  ///  [duration] 视频文件播放长度
  ///  [width] 视频文件宽度
  ///  [height] 视频文件高度
  ///  [videoObj] 视频文件对象, 仅用于web端
  /// @return NIMMessage
  static Future<NIMResult<NIMMessage>> createVideoMessage(
    String videoPath,
    String? name,
    String? sceneName,
    int duration,
    int width,
    int height, {
    html.File? videoObj,
  }) {
    return _platform.createVideoMessage(
        videoPath, name, sceneName, duration, width, height,
        videoObj: videoObj);
  }

  /// 构造文件消息
  ///
  ///  [filePath] 文件地址
  ///  [name] 文件显示名称
  ///  [sceneName] 场景名
  /// 自定义场景使用之前， 需要先调用V2NIMStorageService.addCustomStorageScene新增自定义场景值
  /// 传空默认使用：V2NIMStorageSceneConfig.DEFAULT_IM
  /// [fileObj] 文件对象，仅web
  /// @return NIMMessage
  static Future<NIMResult<NIMMessage>> createFileMessage(
    String filePath,
    String? name,
    String? sceneName, {
    html.File? fileObj,
  }) {
    return _platform.createFileMessage(filePath, name, sceneName,
        fileObj: fileObj);
  }

  /// 构造地理位置消息
  ///
  ///  [latitude] 纬度
  ///  [longitude] 经度
  ///  [address] 详细位置信息
  /// @return NIMMessage
  static Future<NIMResult<NIMMessage>> createLocationMessage(
      double latitude, double longitude, String address) {
    return _platform.createLocationMessage(latitude, longitude, address);
  }

  /// 构造自定义消息消息
  /// Params:[text] – 需要发送的文本内容 [rawAttachment] – 需要发送的附件
  static Future<NIMResult<NIMMessage>> createCustomMessage(
      String text, String rawAttachment) {
    return _platform.createCustomMessage(text, rawAttachment);
  }

  /// 构造提醒消息
  ///
  ///  [text] 提醒内容
  /// @return NIMMessage
  static Future<NIMResult<NIMMessage>> createTipsMessage(String text) {
    return _platform.createTipsMessage(text);
  }

  /// 构造转发消息，消息内容与原消息一样
  /// 转发消息类型不能为：V2NIM_MESSAGE_TYPE_NOTIFICATION，V2NIM_MESSAGE_TYPE_ROBOT，V2NIM_MESSAGE_TYPE_TIP，V2NIM_MESSAGE_TYPE_AVCHAT
  /// 转发的消息消息必须为发送成功的消息
  ///  [message] 需要转发的消息体

  static Future<NIMResult<NIMMessage?>> createForwardMessage(
      NIMMessage message) {
    return _platform.createForwardMessage(message);
  }

  ///构造话单消息
  ///[type] – 话单类型， 业务自定义，内容不校验 建议： 音频：1 视频：2
  /// [channelId] – 话单频道ID， 内容不校验
  /// [status] – 通话状态，业务自定义状态， 内容不校验 建议： 通话完成：1 通话取消：2 通话拒绝：3 超时未接听：4 对方忙： 5
  /// [durations] – 通话成员时长列表， 内容不校验
  /// [text] – 话单描述
  static Future<NIMResult<NIMMessage>> createCallMessage(
      int type,
      String channelId,
      int status,
      List<NIMMessageCallDuration>? durations,
      String? text) {
    return _platform.createCallMessage(
        type, channelId, status, durations, text);
  }
}
