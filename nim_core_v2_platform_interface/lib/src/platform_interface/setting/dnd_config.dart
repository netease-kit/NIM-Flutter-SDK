// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/src/platform_interface/team/team_enum.dart';
import 'setting_enum.dart';
part 'dnd_config.g.dart';

/// 免打扰配置
@JsonSerializable()
class NIMDndConfig {
  /// 是否显示详情
  /// true：显示
  /// false：不限制
  bool? showDetail;

  /// 免打扰是否开启
  /// true：开启
  /// false：关闭
  bool? dndOn;

  /// 如果开启免打扰，开始小时数(Integer)
  /// dndOn， 该字段必传
  int? fromH;

  /// 如果开启免打扰，开始分钟数(Integer)
  /// dndOn， 该字段必传
  int? fromM;

  /// 如果开启免打扰，截止小时数(Integer)
  /// dndOn， 该字段必传
  int? toH;

  /// 如果开启免打扰，截止分钟数(Integer)
  /// dndOn， 该字段必传
  int? toM;

  NIMDndConfig({
    this.showDetail,
    this.dndOn,
    this.fromH,
    this.fromM,
    this.toH,
    this.toM,
  });

  factory NIMDndConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMDndConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMDndConfigToJson(this);
}

@JsonSerializable()
class SettingEnumClass {
  NIMTeamMessageMuteMode teamMessageMuteMode;
  NIMP2PMessageMuteMode p2pMessageMuteMode;
  SettingEnumClass({
    required this.teamMessageMuteMode,
    required this.p2pMessageMuteMode,
  });
}

@JsonSerializable()
class TeamMuteModeChangedResult {
  String teamId;

  NIMTeamType teamType;

  NIMTeamMessageMuteMode muteMode;

  TeamMuteModeChangedResult({
    required this.teamId,
    required this.teamType,
    required this.muteMode,
  });

  factory TeamMuteModeChangedResult.fromJson(Map<String, dynamic> map) =>
      _$TeamMuteModeChangedResultFromJson(map);

  Map<String, dynamic> toJson() => _$TeamMuteModeChangedResultToJson(this);
}

@JsonSerializable()
class P2PMuteModeChangedResult {
  String accountId;

  NIMP2PMessageMuteMode muteMode;

  P2PMuteModeChangedResult({
    required this.accountId,
    required this.muteMode,
  });

  factory P2PMuteModeChangedResult.fromJson(Map<String, dynamic> map) =>
      _$P2PMuteModeChangedResultFromJson(map);

  Map<String, dynamic> toJson() => _$P2PMuteModeChangedResultToJson(this);
}

@JsonSerializable()
class NIMP2PMessageMuteModeClass {
  NIMP2PMessageMuteMode muteMode;
  NIMP2PMessageMuteModeClass({
    required this.muteMode,
  });

  factory NIMP2PMessageMuteModeClass.fromJson(Map<String, dynamic> map) =>
      _$NIMP2PMessageMuteModeClassFromJson(map);

  Map<String, dynamic> toJson() => _$NIMP2PMessageMuteModeClassToJson(this);

  /// 转换成 int
  int toValue() {
    return _$NIMP2PMessageMuteModeEnumMap[muteMode]!;
  }

  /// 从 int 转换成枚举
  static NIMP2PMessageMuteMode fromEnumInt(int enumInt) {
    return _$NIMP2PMessageMuteModeEnumMap.entries
        .firstWhere((element) => element.value == enumInt)
        .key;
  }
}

@JsonSerializable()
class NIMTeamMessageMuteModeClass {
  NIMTeamMessageMuteMode muteMode;
  NIMTeamMessageMuteModeClass({
    required this.muteMode,
  });

  factory NIMTeamMessageMuteModeClass.fromJson(Map<String, dynamic> map) =>
      _$NIMTeamMessageMuteModeClassFromJson(map);

  Map<String, dynamic> toJson() => _$NIMTeamMessageMuteModeClassToJson(this);

  /// 转换成 int
  int toValue() {
    return _$NIMTeamMessageMuteModeEnumMap[muteMode]!;
  }

  /// 从 int 转换成枚举
  static NIMTeamMessageMuteMode fromEnumInt(int enumInt) {
    return _$NIMTeamMessageMuteModeEnumMap.entries
        .firstWhere((element) => element.value == enumInt)
        .key;
  }
}
