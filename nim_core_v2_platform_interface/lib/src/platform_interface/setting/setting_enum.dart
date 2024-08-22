// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

/// 群组消息免打扰模式
enum NIMTeamMessageMuteMode {
  /// 群组所有消息免打扰关闭
  @JsonValue(0)
  teamMessageMuteModeOff,

  /// 所有消息均免打扰开启
  @JsonValue(1)
  teamMessageMuteModeOn,

  /// 只群主，管理员消息免打扰关闭
  @JsonValue(2)
  teamMessageMuteModeManagerOff,
}

/// 点对点消息免打扰模式
enum NIMP2PMessageMuteMode {
  /// 点对点消息免打扰关闭
  @JsonValue(0)
  p2pMessageMuteModeOff,

  /// 点对点消息免打扰开启
  @JsonValue(1)
  p2pMessageMuteModeOn,
}
