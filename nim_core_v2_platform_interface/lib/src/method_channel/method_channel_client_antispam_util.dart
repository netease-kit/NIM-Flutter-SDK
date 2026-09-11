// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import '../../nim_core_v2_platform_interface.dart';

class MethodChannelV2NIMClientAntispamUtil
    extends V2NIMClientAntispamUtilPlatform {
  @override
  Future onEvent(String method, arguments) {
    throw UnimplementedError();
  }

  @override
  String get serviceName => 'V2NIMClientAntispamUtil';

  @override
  Future<NIMResult<NIMClientAntispamResult>> checkTextAntispam(
      String text, String? replace) async {
    return NIMResult<NIMClientAntispamResult>.fromMap(
      await invokeMethod(
        'checkTextAntispam',
        arguments: {
          'text': text,
          'replace': replace,
        },
      ),
      convert: (map) => NIMClientAntispamResult.fromJson(
          (map as Map).cast<String, dynamic>()),
    );
  }
}
