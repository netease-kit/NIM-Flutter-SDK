// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_talk_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMThreadTalkHistory _$NIMThreadTalkHistoryFromJson(
        Map<String, dynamic> json) =>
    NIMThreadTalkHistory(
      thread: messageFromMap(json['thread'] as Map?),
      time: json['time'] as int?,
      replyList: replyListFromMap(json['replyList'] as List?),
    );

Map<String, dynamic> _$NIMThreadTalkHistoryToJson(
    NIMThreadTalkHistory instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('thread', messageToMap(instance.thread));
  val['time'] = instance.time;
  writeNotNull('replyList', replyListToMap(instance.replyList));
  return val;
}
