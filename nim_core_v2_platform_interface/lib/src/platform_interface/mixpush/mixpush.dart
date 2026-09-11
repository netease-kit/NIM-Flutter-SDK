// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

/// 推送类型枚举
/// 与 Android SDK PushType 保持一致
enum NIMPushType {
  /// 未知 (UNKNOWN = -1)
  unknown(-1),

  /// 禁用 (DISABLE = 0)
  disable(0),

  /// 小米 (XIAO_MI = 5)
  xiaomi(5),

  /// 华为 (HUA_WEI = 6)
  huawei(6),

  /// 魅族 (MEI_ZU = 7)
  meizu(7),

  /// FCM (FCM = 8)
  fcm(8),

  /// VIVO (VIVO = 9)
  vivo(9),

  /// OPPO (OPPO = 10)
  oppo(10),

  /// 荣耀 (HONOR = 11)
  honor(11);

  final int value;
  const NIMPushType(this.value);

  static NIMPushType fromValue(int value) {
    return NIMPushType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => NIMPushType.unknown,
    );
  }
}

/// 推送 Token 信息
class NIMMixPushToken {
  /// 推送类型
  final NIMPushType pushType;

  /// Token 字符串
  final String token;

  /// Token 名称（可选，仅在 onMixPushToken 回调中有值）
  final String? tokenName;

  NIMMixPushToken({
    required this.pushType,
    required this.token,
    this.tokenName,
  });

  Map<String, dynamic> toMap() {
    return {
      'pushType': pushType.value,
      'token': token,
      if (tokenName != null) 'tokenName': tokenName,
    };
  }

  factory NIMMixPushToken.fromMap(Map<String, dynamic> map) {
    return NIMMixPushToken(
      pushType: NIMPushType.fromValue(map['pushType'] as int? ?? 0),
      token: map['token'] as String? ?? '',
      tokenName: map['tokenName'] as String?,
    );
  }

  @override
  String toString() {
    return 'NIMMixPushToken{pushType: $pushType, token: $token, tokenName: $tokenName}';
  }
}
