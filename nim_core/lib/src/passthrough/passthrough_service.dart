part of nim_core;

class PassThroughService {
  factory PassThroughService() {
    if (_singleton == null) {
      _singleton = PassThroughService._();
    }
    return _singleton!;
  }

  PassThroughService._();

  static PassThroughService? _singleton;

  PassThroughServicePlatform get _platform =>
      PassThroughServicePlatform.instance;

  /// 代理客户端http请求到应用服务器
  Future<NIMResult<NIMPassThroughProxyData>> httpProxy(
    NIMPassThroughProxyData passThroughProxyData,
  ) async {
    return _platform.httpProxy(passThroughProxyData);
  }

  Stream<NIMPassThroughNotifyData> get onPassThroughNotifyData =>
      _platform.onPassThroughNotifyData.stream;
}
