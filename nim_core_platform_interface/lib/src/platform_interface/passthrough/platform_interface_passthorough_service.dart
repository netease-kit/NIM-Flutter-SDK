import 'dart:async';

import 'package:nim_core_platform_interface/nim_core_platform_interface.dart';
import 'package:nim_core_platform_interface/src/method_channel/method_channel_passthough_service.dart';
import 'package:nim_core_platform_interface/src/platform_interface/nim_base.dart';
import 'package:nim_core_platform_interface/src/platform_interface/passthrough/pass_through_notifydata.dart';
import 'package:nim_core_platform_interface/src/platform_interface/passthrough/pass_through_proxydata.dart';
import 'package:nim_core_platform_interface/src/platform_interface/service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class PassThroughServicePlatform extends Service {
  PassThroughServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static PassThroughServicePlatform _instance =
      MethodChannelPassThroughService();

  static PassThroughServicePlatform get instance => _instance;

  static set instance(PassThroughServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<NIMResult<NIMPassThroughProxyData>> httpProxy(
    NIMPassThroughProxyData passThroughProxyData,
  ) async {
    throw UnimplementedError('httpProxy() is not implemented');
  }

  final StreamController<NIMPassThroughNotifyData> onPassThroughNotifyData =
      StreamController<NIMPassThroughNotifyData>.broadcast();
}
