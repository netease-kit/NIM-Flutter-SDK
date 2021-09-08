import 'package:nim_core_platform_interface/src/platform_interface/nim_base.dart';
import 'package:nim_core_platform_interface/src/platform_interface/passthrough/pass_through_notifydata.dart';
import 'package:nim_core_platform_interface/src/platform_interface/passthrough/pass_through_proxydata.dart';
import 'package:nim_core_platform_interface/src/platform_interface/passthrough/platform_interface_passthorough_service.dart';

class MethodChannelPassThroughService extends PassThroughServicePlatform {
  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onPassthrough':
        PassThroughServicePlatform.instance.onPassThroughNotifyData.add(
            NIMPassThroughNotifyData.fromMap(
                Map<String, dynamic>.from(arguments as Map)));
        break;
    }
    return Future.value(null);
  }

  @override
  String get serviceName => 'PassThroughService';

  Future<NIMResult<NIMPassThroughProxyData>> httpProxy(
    NIMPassThroughProxyData passThroughProxyData,
  ) async {
    final arguments = <String, dynamic>{};
    arguments..['passThroughProxyData'] = passThroughProxyData.toMap();
    return NIMResult<NIMPassThroughProxyData>.fromMap(
      await invokeMethod(
        'httpProxy',
        arguments: arguments,
      ),
      convert: (map) => NIMPassThroughProxyData.fromMap(map),
    );
  }
}
