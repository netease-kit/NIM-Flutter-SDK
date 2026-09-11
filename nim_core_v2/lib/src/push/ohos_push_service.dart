// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

/// 鸿蒙第三方推送服务。
@HawkEntryPoint()
class OhosPushService {
  factory OhosPushService() {
    if (_singleton == null) {
      _singleton = OhosPushService._();
    }
    return _singleton!;
  }

  OhosPushService._();

  static OhosPushService? _singleton;

  OhosPushServicePlatform get _platform => OhosPushServicePlatform.instance;

  /// 开启/关闭第三方推送服务。
  ///
  /// [enable] true 开启，false 关闭。
  Future<NIMResult<void>> enable(bool enable) {
    return _platform.enable(enable);
  }

  /// 查询当前是否开启第三方推送服务。
  Future<NIMResult<bool>> isEnable() {
    return _platform.isEnable();
  }
}
