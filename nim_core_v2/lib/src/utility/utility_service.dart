// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

/// 工具类服务，提供消息迁移相关功能
@HawkEntryPoint()
class V2NIMUtilityService {
  factory V2NIMUtilityService() {
    if (_singleton == null) {
      _singleton = V2NIMUtilityService._();
    }
    return _singleton!;
  }

  V2NIMUtilityService._();

  static V2NIMUtilityService? _singleton;

  V2NIMUtilityServicePlatform get _platform =>
      V2NIMUtilityServicePlatform.instance;

  /// 导出/导入消息进度回调（0–100）
  /// 在 exportMessagesToPath 和 importMessagesFromPath 操作中持续上报进度
  @HawkApi(ignore: true)
  Stream<int> get onMessagesProgress => _platform.onMessagesProgress.stream;

  /// 导出消息到指定路径
  /// [option] 导出参数，包含导出路径、时间范围等
  /// 成功时返回导出文件的实际路径
  Future<NIMResult<String>> exportMessagesToPath(
      NIMExportMessageOption option) async {
    return _platform.exportMessagesToPath(option);
  }

  /// 从指定路径导入消息到本地数据库
  /// [option] 导入参数，包含导入文件路径等
  Future<NIMResult<void>> importMessagesFromPath(
      NIMImportMessageOption option) async {
    return _platform.importMessagesFromPath(option);
  }

  /// 取消当前导入/导出消息
  Future<NIMResult<void>> cancelMigrateMessages() async {
    return _platform.cancelMigrateMessages();
  }
}
