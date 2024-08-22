// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

class EventSubscribeResult {
  //事件类型，1-99999 为云信保留类型
  final int? eventType;

  //事件的有效期，范围为 60s 到 7days，数值单位为秒
  final int? expiry;

  //事件发布的时间
  final int? time;

  //事件发布者的账号
  final String? publisherAccount;

  EventSubscribeResult(
      {required this.eventType,
      required this.expiry,
      this.time,
      this.publisherAccount});

  factory EventSubscribeResult.fromMap(Map<String, dynamic>? json) {
    return EventSubscribeResult(
        eventType: json?['eventType'] as int?,
        expiry: json?['expiry'] as int?,
        time: json?['time'] as int?,
        publisherAccount: json?['publisherAccount'] as String?);
  }
}
