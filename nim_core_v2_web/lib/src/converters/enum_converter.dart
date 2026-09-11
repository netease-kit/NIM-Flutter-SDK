// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// 枚举值的 JS 数字 ↔ Dart 枚举映射
//
// 由于所有 Dart model 类都使用 @JsonValue 注解 + json_serializable 生成的
// fromJson/toJson 方法，枚举的序列化/反序列化由框架自动处理。
//
// JS SDK 返回的数值会通过 jsObjectToMap() 转为 Dart Map，其中枚举字段为 int，
// 然后传入 model.fromJson() 时由 $enumDecode 自动映射为 Dart 枚举。
//
// 此文件提供 Web 端传参时所需的枚举 → @JsonValue 转换工具函数。
// 注意：禁止使用 enum.index（Dart 枚举的从0开始的位置索引），
// 必须使用以下辅助函数获取 @JsonValue 定义的实际值，
// 尤其是枚举中存在负值或跳号时（如 -1, 3 等）。

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

// ============================================================
// NIMTeamChatBannedMode → @JsonValue
// unknown=-1, chatBannedModeNone=0, chatBannedModeBannedNormal=1, chatBannedModeBannedAll=3
// ============================================================
int nimTeamChatBannedModeToValue(NIMTeamChatBannedMode mode) {
  switch (mode) {
    case NIMTeamChatBannedMode.unknown:
      return -1;
    case NIMTeamChatBannedMode.chatBannedModeNone:
      return 0;
    case NIMTeamChatBannedMode.chatBannedModeBannedNormal:
      return 1;
    case NIMTeamChatBannedMode.chatBannedModeBannedAll:
      return 3;
  }
}

// ============================================================
// NIMSignallingChannelType → @JsonValue
// nimSignallingChannelTypeAudio=1, Video=2, Custom=3
// ============================================================
int nimSignallingChannelTypeToValue(NIMSignallingChannelType type) {
  switch (type) {
    case NIMSignallingChannelType.nimSignallingChannelTypeAudio:
      return 1;
    case NIMSignallingChannelType.nimSignallingChannelTypeVideo:
      return 2;
    case NIMSignallingChannelType.nimSignallingChannelTypeCustom:
      return 3;
  }
}
