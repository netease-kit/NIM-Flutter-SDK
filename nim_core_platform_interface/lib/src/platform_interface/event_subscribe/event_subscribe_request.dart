// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

class EventSubscribeRequest {
  ///事件类型，1-99999 为云信保留类型，自定义的订阅事件请选择此范围意外的值
  final int eventType;

  ///订阅的有效期，范围为 60s 到 30days，数值单位为秒
  final int expiry;

  ///订阅后是否立刻同步事件状态值，默认为 false，如果填 true，则会收到事件状态回调
  final bool? syncCurrentValue;

  ///事件发布者的账号集合
  final List<String> publishers;

  EventSubscribeRequest(
      {required this.eventType,
      required this.expiry,
      this.syncCurrentValue,
      required this.publishers});

  factory EventSubscribeRequest.createEventSubscribe(
      {required int expiry,
      bool? syncCurrentValue,
      required List<String> publishers}) {
    return EventSubscribeRequest(
        eventType: 1,
        expiry: expiry,
        syncCurrentValue: syncCurrentValue,
        publishers: publishers);
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'eventType': eventType,
        'expiry': expiry,
        if (syncCurrentValue != null) 'syncCurrentValue': syncCurrentValue,
        'publishers': publishers
      };
}
