// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';

class MessageSearchOption {
  //起始时间点单位毫秒
  int? startTime = 0;

  //结束时间点单位毫秒
  int? endTime = 0;

  //本次查询的消息条数上限(默认100条)
  int? limit = 100;

  //检索方向
  SearchOrder? order = SearchOrder.DESC;

  //消息类型组合
  List<NIMMessageType>? msgTypeList;

  //消息子类型组合
  List<int>? messageSubTypes;

  //是否搜索全部消息类型
  bool? allMessageTypes = false;

  //搜索文本内容
  String? searchContent;

  //消息说话者帐号列表
  List<String>? fromIds;

  //将搜索文本中的正则特殊字符转义，默认 true
  bool? enableContentTransfer = true;

  MessageSearchOption(
      {this.startTime,
      this.endTime,
      this.limit,
      this.order,
      this.msgTypeList,
      this.messageSubTypes,
      this.allMessageTypes,
      required this.searchContent,
      this.fromIds,
      this.enableContentTransfer});

  Map<String, dynamic> toMap() => <String, dynamic>{
        "startTime": startTime,
        "endTime": endTime,
        "limit": limit,
        "order": order?.index,
        "msgTypeList": msgTypeList
            ?.map((e) => NIMMessageTypeConverter(messageType: e).toValue())
            .toList(),
        "messageSubTypes": messageSubTypes,
        "allMessageTypes": allMessageTypes,
        "searchContent": searchContent,
        "fromIds": fromIds,
        "enableContentTransfer": enableContentTransfer,
      };

  factory MessageSearchOption.fromMap(Map<String, dynamic> param) {
    return MessageSearchOption(
      startTime: param['startTime'] as int,
      endTime: param['endTime'] as int,
      limit: param['limit'] as int,
      order: (param['order'] as String?) == 'DESC'
          ? SearchOrder.DESC
          : SearchOrder.ASC,
      msgTypeList: (param['msgTypeList'] as List<dynamic>?)
          ?.map((e) => NIMMessageTypeConverter().fromValue(e))
          .toList(),
      messageSubTypes: (param['messageSubTypes'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      allMessageTypes: param['allMessageTypes'] as bool?,
      searchContent: param['searchContent'] as String?,
      fromIds: (param['fromIds'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      enableContentTransfer: param['enableContentTransfer'] as bool?,
    );
  }
}
