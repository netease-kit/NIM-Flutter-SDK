// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class MessageKeywordSearchConfig {
  // 关键词
  String? keyword;

  // 起始时间
  int? fromTime;

  // 终止时间
  int? toTime;

  // 会话数量上限
  int? sessionLimit;

  // 会话数量下限
  int? msgLimit;

  // 消息排序规则，默认false
  bool? asc = false;

  // P2P范围，要查询的会话范围是此参数与{@link MsgFullKeywordSearchConfig#teamList} 的并集
  List<String>? p2pList;

  // 群范围，如果只查询指定群中的消息，则输入这些群的ID
  List<String>? teamList;

  // 发送方列表
  List<String>? senderList;

  // 消息类型列表
  List<NIMMessageType>? msgTypeList;

  // 消息子类型列表
  List<int>? msgSubtypeList;

  MessageKeywordSearchConfig(
      {required this.keyword,
      this.fromTime,
      this.toTime,
      this.sessionLimit,
      this.msgLimit,
      this.asc,
      this.p2pList,
      this.teamList,
      this.senderList,
      this.msgTypeList,
      this.msgSubtypeList});

  Map<String, dynamic> toMap() => <String, dynamic>{
        "keyword": keyword,
        "fromTime": fromTime,
        "toTime": toTime,
        "sessionLimit": sessionLimit,
        "msgLimit": msgLimit,
        "asc": asc,
        "p2pList": p2pList,
        "teamList": teamList,
        "senderList": senderList,
        "msgTypeList": msgTypeList
            ?.map((e) => NIMMessageTypeConverter(messageType: e).toValue())
            .toList(),
        "msgSubtypeList": msgSubtypeList,
      };

  factory MessageKeywordSearchConfig.fromMap(Map<String, dynamic> param) {
    return MessageKeywordSearchConfig(
      keyword: param['keyword'] as String?,
      fromTime: param['fromTime'] as int?,
      toTime: param['toTime'] as int?,
      sessionLimit: param['sessionLimit'] as int?,
      msgLimit: param['msgLimit'] as int?,
      asc: param['asc'] as bool?,
      p2pList: (param['p2pList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      teamList: (param['teamList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      senderList: (param['senderList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      msgTypeList: (param['messageTypeList'] as List<dynamic>?)
          ?.map((e) => NIMMessageTypeConverter().fromValue(e))
          .toList(),
      msgSubtypeList: (param['msgSubtypeList'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
    );
  }
}
