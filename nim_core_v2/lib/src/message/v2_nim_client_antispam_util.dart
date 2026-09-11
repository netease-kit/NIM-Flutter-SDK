// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

/// 客户端本地反垃圾工具类
@HawkEntryPoint()
class V2NIMClientAntispamUtil {
  factory V2NIMClientAntispamUtil() {
    if (_singleton == null) {
      _singleton = V2NIMClientAntispamUtil._();
    }
    return _singleton!;
  }

  V2NIMClientAntispamUtil._();

  static V2NIMClientAntispamUtil? _singleton;

  V2NIMClientAntispamUtilPlatform get _platform =>
      V2NIMClientAntispamUtilPlatform.instance;

  /// 对文本进行本地反垃圾检查，并可能替换文本
  ///
  /// [text] 待检查文本
  /// [replace] 命中替换时使用的屏蔽文本
  Future<NIMResult<NIMClientAntispamResult>> checkTextAntispam(
      String text, String? replace) async {
    return _platform.checkTextAntispam(text, replace);
  }
}
