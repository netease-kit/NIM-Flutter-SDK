// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:universal_html/html.dart' as html;

class MethodChannelMessageCreatorService extends MessageCreatorServicePlatform {
  @override
  String get serviceName => 'MessageCreatorService';

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) {
    return Future.value(null);
  }

  /// 构造文本消息
  ///
  /// @param text 需要发送的文本内容
  /// @return NIMMessage
  Future<NIMResult<NIMMessage>> createTextMessage(String text) async {
    return NIMResult.fromMap(
        await invokeMethod('createTextMessage', arguments: {'text': text}),
        convert: (json) =>
            NIMMessage.fromJson((json as Map).cast<String, dynamic>()));
  }

  /// 构造图片消息
  ///
  /// @param imagePath 图片文件地址
  /// @param name 文件显示名称
  /// @param sceneName 文件存储场景名
  /// @param width 图片文件宽度
  /// @param height 图片文件高度
  /// @return NIMMessage
  Future<NIMResult<NIMMessage>> createImageMessage(
    String imagePath,
    String? name,
    String? sceneName,
    int width,
    int height, {
    html.File? imageObj,
  }) async {
    return NIMResult.fromMap(
        await invokeMethod('createImageMessage', arguments: {
          'imagePath': imagePath,
          'imageObj': imageObj,
          'name': name,
          'sceneName': sceneName,
          'width': width,
          'height': height
        }),
        convert: (json) =>
            NIMMessage.fromJson((json as Map).cast<String, dynamic>()));
  }

  /// 构造语音消息
  ///
  /// @param audioPath 视频文件地址
  /// @param name 视频文件显示名称
  /// @param sceneName 文件存储场景名
  /// 自定义场景使用之前， 需要先调用V2NIMStorageService.addCustomStorageScene新增自定义场景值
  /// 传空默认使用：V2NIMStorageSceneConfig.DEFAULT_IM
  /// @param duration 语音文件播放长度
  /// @return NIMMessage
  Future<NIMResult<NIMMessage>> createAudioMessage(
    String audioPath,
    String? name,
    String? sceneName,
    int duration, {
    html.File? audioObj,
  }) async {
    return NIMResult.fromMap(
        await invokeMethod('createAudioMessage', arguments: {
          'audioPath': audioPath,
          'name': name,
          'sceneName': sceneName,
          'duration': duration,
          'audioObj': audioObj
        }),
        convert: (json) =>
            NIMMessage.fromJson((json as Map).cast<String, dynamic>()));
  }

  /// 构造视频消息
  ///
  /// @param videoPath 视频文件地址
  /// @param name 视频文件显示名称
  /// @param sceneName 文件存储场景名
  /// 自定义场景使用之前， 需要先调用V2NIMStorageService.addCustomStorageScene新增自定义场景值
  /// 传空默认使用：V2NIMStorageSceneConfig.DEFAULT_IM
  /// @param duration 视频文件播放长度
  /// @param width 视频文件宽度
  /// @param height 视频文件高度
  /// @return NIMMessage
  Future<NIMResult<NIMMessage>> createVideoMessage(
    String videoPath,
    String? name,
    String? sceneName,
    int duration,
    int width,
    int height, {
    html.File? videoObj,
  }) async {
    return NIMResult.fromMap(
        await invokeMethod('createVideoMessage', arguments: {
          'videoPath': videoPath,
          'name': name,
          'sceneName': sceneName,
          'duration': duration,
          'width': width,
          'height': height,
          'videoObj': videoObj
        }),
        convert: (json) =>
            NIMMessage.fromJson((json as Map).cast<String, dynamic>()));
  }

  /// 构造文件消息
  ///
  /// @param filePath 文件地址
  /// @param name 文件显示名称
  /// @param sceneName 场景名
  /// 自定义场景使用之前， 需要先调用V2NIMStorageService.addCustomStorageScene新增自定义场景值
  /// 传空默认使用：V2NIMStorageSceneConfig.DEFAULT_IM
  /// @return NIMMessage
  Future<NIMResult<NIMMessage>> createFileMessage(
    String filePath,
    String? name,
    String? sceneName, {
    html.File? fileObj,
  }) async {
    return NIMResult.fromMap(
        await invokeMethod('createFileMessage', arguments: {
          'filePath': filePath,
          'name': name,
          'sceneName': sceneName,
          'fileObj': fileObj
        }),
        convert: (json) =>
            NIMMessage.fromJson((json as Map).cast<String, dynamic>()));
  }

  /// 构造地理位置消息
  ///
  /// @param latitude 纬度
  /// @param longitude 经度
  /// @param address 详细位置信息
  /// @return NIMMessage
  Future<NIMResult<NIMMessage>> createLocationMessage(
      double latitude, double longitude, String address) async {
    return NIMResult.fromMap(
        await invokeMethod('createLocationMessage', arguments: {
          'latitude': latitude,
          'longitude': longitude,
          'address': address
        }),
        convert: (json) =>
            NIMMessage.fromJson((json as Map).cast<String, dynamic>()));
  }

  /// 构造自定义消息消息
  /// Params:text – 需要发送的文本内容 rawAttachment – 需要发送的附件
  Future<NIMResult<NIMMessage>> createCustomMessage(
      String text, String rawAttachment) async {
    return NIMResult.fromMap(
        await invokeMethod('createCustomMessage',
            arguments: {'text': text, 'rawAttachment': rawAttachment}),
        convert: (json) =>
            NIMMessage.fromJson((json as Map).cast<String, dynamic>()));
  }

  /// 构造提醒消息
  ///
  /// @param text 提醒内容
  /// @return NIMMessage
  Future<NIMResult<NIMMessage>> createTipsMessage(String text) async {
    return NIMResult.fromMap(
        await invokeMethod('createTipsMessage', arguments: {'text': text}),
        convert: (json) =>
            NIMMessage.fromJson((json as Map).cast<String, dynamic>()));
  }

  /// 构造转发消息，消息内容与原消息一样
  /// 转发消息类型不能为：V2NIM_MESSAGE_TYPE_NOTIFICATION，V2NIM_MESSAGE_TYPE_ROBOT，V2NIM_MESSAGE_TYPE_TIP，V2NIM_MESSAGE_TYPE_AVCHAT
  /// 转发的消息消息必须为发送成功的消息
  /// @param [message] 需要转发的消息体

  Future<NIMResult<NIMMessage?>> createForwardMessage(
      NIMMessage message) async {
    return NIMResult.fromMap(
        await invokeMethod('createForwardMessage',
            arguments: {'message': message.toJson()}),
        convert: (json) =>
            NIMMessage.fromJson((json as Map).cast<String, dynamic>()));
  }

  ///构造话单消息
  ///[type] – 话单类型， 业务自定义，内容不校验 建议： 音频：1 视频：2
  /// [channelId] – 话单频道ID， 内容不校验
  /// [status] – 通话状态，业务自定义状态， 内容不校验 建议： 通话完成：1 通话取消：2 通话拒绝：3 超时未接听：4 对方忙： 5
  /// [durations] – 通话成员时长列表， 内容不校验
  /// [text] – 话单描述
  Future<NIMResult<NIMMessage>> createCallMessage(int type, String channelId,
      int status, List<NIMMessageCallDuration>? durations, String? text) async {
    return NIMResult.fromMap(
        await invokeMethod('createCallMessage', arguments: {
          'type': type,
          'channelId': channelId,
          'status': status,
          'durations': durations?.map((e) => e.toJson()).toList(),
          'text': text
        }),
        convert: (json) =>
            NIMMessage.fromJson((json as Map).cast<String, dynamic>()));
  }
}
