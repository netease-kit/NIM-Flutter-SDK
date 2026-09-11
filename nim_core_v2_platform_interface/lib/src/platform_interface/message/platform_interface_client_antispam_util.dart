// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_v2_platform_interface/src/method_channel/method_channel_client_antispam_util.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../../nim_core_v2_platform_interface.dart';

abstract class V2NIMClientAntispamUtilPlatform extends Service {
  V2NIMClientAntispamUtilPlatform() : super(token: _token);

  static final Object _token = Object();

  static V2NIMClientAntispamUtilPlatform _instance =
      MethodChannelV2NIMClientAntispamUtil();

  static V2NIMClientAntispamUtilPlatform get instance => _instance;

  static set instance(V2NIMClientAntispamUtilPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<NIMResult<NIMClientAntispamResult>> checkTextAntispam(
      String text, String? replace) async {
    throw UnimplementedError('checkTextAntispam() is not implemented');
  }
}
