// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import '../../nim_core_v2_platform_interface.dart';

class MethodChannelConversationService extends ConversationServicePlatform {
  final _conversationChangedController =
      StreamController<List<NIMConversation>>.broadcast();

  final _conversationCreatedController =
      StreamController<NIMConversation>.broadcast();

  final _conversationDeletedController =
      StreamController<List<String>>.broadcast();

  final _conversationReadTimeUpdatedController =
      StreamController<ReadTimeUpdateResult>.broadcast();

  final _syncFailedController = StreamController<void>.broadcast();

  final _syncFinishedController = StreamController<void>.broadcast();

  final _syncStartedController = StreamController<void>.broadcast();

  final _totalUnreadCountChangedController = StreamController<int>.broadcast();

  final _unreadCountChangedByFilterController =
      StreamController<UnreadChangeFilterResult>.broadcast();

  @override
  Future onEvent(String method, arguments) {
    assert(arguments is Map);
    switch (method) {
      case 'onSyncStarted':
        _syncStartedController.add(null);
        break;
      case 'onSyncFinished':
        _syncFinishedController.add(null);
        break;
      case 'onSyncFailed':
        _syncFailedController.add(null);
        break;
      case 'onConversationCreated':
        _conversationCreatedController.add(
            NIMConversation.fromJson(Map<String, dynamic>.from(arguments)));
        break;
      case 'onConversationDeleted':
        _conversationDeletedController.add(
            (arguments['conversationIdList'] as List)
                .map((e) => e as String)
                .toList());
        break;
      case 'onConversationChanged':
        var conversationList = arguments['conversationList'] as List<dynamic>;
        var result = conversationList
            .map((e) => NIMConversation.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        _conversationChangedController.add(result);
        break;
      case 'onTotalUnreadCountChanged':
        _totalUnreadCountChangedController.add(arguments['unreadCount'] as int);
        break;
      case 'onUnreadCountChangedByFilter':
        assert(arguments is Map);
        _unreadCountChangedByFilterController.add(
            UnreadChangeFilterResult.fromJson(
                Map<String, dynamic>.from(arguments)));
        break;
      case 'onConversationReadTimeUpdated':
        assert(arguments is Map);
        _conversationReadTimeUpdatedController.add(
            ReadTimeUpdateResult.fromJson(
                Map<String, dynamic>.from(arguments)));
        break;
      default:
        throw UnimplementedError();
    }
    return Future.value();
  }

  @override
  String get serviceName => "ConversationService";

  @override
  Stream<List<NIMConversation>> get onConversationChanged =>
      _conversationChangedController.stream;

  @override
  Stream<NIMConversation> get onConversationCreated =>
      _conversationCreatedController.stream;

  @override
  Stream<List<String>> get onConversationDeleted =>
      _conversationDeletedController.stream;

  @override
  Stream<ReadTimeUpdateResult> get onConversationReadTimeUpdated =>
      _conversationReadTimeUpdatedController.stream;

  @override
  Stream<void> get onSyncFailed => _syncFailedController.stream;

  @override
  Stream<void> get onSyncFinished => _syncFinishedController.stream;

  @override
  Stream<void> get onSyncStarted => _syncStartedController.stream;

  @override
  Stream<int> get onTotalUnreadCountChanged =>
      _totalUnreadCountChangedController.stream;

  @override
  Stream<UnreadChangeFilterResult> get onUnreadCountChangedByFilter =>
      _unreadCountChangedByFilterController.stream;

  /// 获取会话列表
  /// offset – 分页偏移，首次传0，后续拉取采用上一次返回的offset limit – 分页拉取数量，不建议超过100;
  Future<NIMResult<NIMConversationResult>> getConversationList(
      int offset, int limit) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'getConversationList',
          arguments: {
            'offset': offset,
            'limit': limit,
          },
        ),
        convert: (json) =>
            NIMConversationResult.fromJson(Map<String, dynamic>.from(json)));
  }

  /// 根据查询参数获取会话列表
  /// offset – 分页偏移，首次传0，后续拉取采用上一次返回的offset
  /// limit – 分页拉取数量，不建议超过100;
  /// option – 查询选项
  Future<NIMResult<NIMConversationResult>> getConversationListByOption(
      int offset, int limit, NIMConversationOption option) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'getConversationListByOption',
          arguments: {
            'offset': offset,
            'limit': limit,
            'option': option.toJson(),
          },
        ),
        convert: (json) =>
            NIMConversationResult.fromJson(Map<String, dynamic>.from(json)));
  }

  /// 获取会话列表，通过会话id
  /// conversationId – 会话id
  Future<NIMResult<NIMConversation>> getConversation(
      String conversationId) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'getConversation',
          arguments: {
            'conversationId': conversationId,
          },
        ),
        convert: (json) =>
            NIMConversation.fromJson(Map<String, dynamic>.from(json)));
  }

  /// 获取会话列表，通过会话id
  /// conversationIds – 会话id列表
  Future<NIMResult<List<NIMConversation>>> getConversationListByIds(
      List<String> conversationIds) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'getConversationListByIds',
          arguments: {
            'conversationIdList': conversationIds,
          },
        ),
        convert: (json) => (json['conversationList'] as List<dynamic>?)
            ?.map((e) =>
                NIMConversation.fromJson((e as Map).cast<String, dynamic>()))
            .toList());
  }

  /// 创建会话
  /// conversationId – 会话id
  Future<NIMResult<NIMConversation>> createConversation(
      String conversationId) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'createConversation',
          arguments: {
            'conversationId': conversationId,
          },
        ),
        convert: (json) =>
            (NIMConversation.fromJson(Map<String, dynamic>.from(json))));
  }

  /// 删除会话
  /// conversationId – 会话id
  /// clearMessage – 是否清除消息
  Future<NIMResult<void>> deleteConversation(
      String conversationId, bool clearMessage) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'deleteConversation',
        arguments: {
          'conversationId': conversationId,
          'clearMessage': clearMessage,
        },
      ),
    );
  }

  /// 删除会话
  /// conversationIds – 会话id列表
  /// clearMessage – 是否清除消息
  Future<NIMResult<List<NIMConversationOperationResult>>>
      deleteConversationListByIds(
          List<String> conversationIds, bool clearMessage) async {
    return NIMResult.fromMap(
        await invokeMethod(
          'deleteConversationListByIds',
          arguments: {
            'conversationIdList': conversationIds,
            'clearMessage': clearMessage,
          },
        ),
        convert: (json) =>
            (json['conversationOperationResult'] as List<dynamic>?)
                ?.map((e) => NIMConversationOperationResult.fromJson(
                    Map<String, dynamic>.from(e)))
                .toList());
  }

  /// 置顶会话
  /// conversationId – 会话id
  /// stickTop – 是否置顶
  Future<NIMResult<void>> stickTopConversation(
      String conversationId, bool stickTop) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'stickTopConversation',
        arguments: {
          'conversationId': conversationId,
          'stickTop': stickTop,
        },
      ),
    );
  }

  /// 更新会话
  /// conversationId – 会话id
  /// updateInfo – 更新信息
  Future<NIMResult<void>> updateConversation(
      String conversationId, NIMConversationUpdate updateInfo) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'updateConversation',
        arguments: {
          'conversationId': conversationId,
          'updateInfo': updateInfo.toJson(),
        },
      ),
    );
  }

  /// 更新会话本地扩展字段
  /// conversationId – 会话id
  /// localExtension – 本地扩展字段更新信息
  Future<NIMResult<void>> updateConversationLocalExtension(
      String conversationId, String? localExtension) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'updateConversationLocalExtension',
        arguments: {
          'conversationId': conversationId,
          'localExtension': localExtension,
        },
      ),
    );
  }

  /// 获取会话总未读数
  Future<NIMResult<int>> getTotalUnreadCount() async {
    return NIMResult.fromMap(await invokeMethod('getTotalUnreadCount'));
  }

  /// 根据会话id获取会话未读数
  /// conversationIds – 会话id列表
  Future<NIMResult<int>> getUnreadCountByIds(
      List<String> conversationIds) async {
    return NIMResult.fromMap(await invokeMethod(
      'getUnreadCountByIds',
      arguments: {
        'conversationIdList': conversationIds,
      },
    ));
  }

  /// 根据过滤条件获取相应的未读数
  /// filter – 查询选项
  Future<NIMResult<int>> getUnreadCountByFilter(
      NIMConversationFilter filter) async {
    return NIMResult.fromMap(await invokeMethod('getUnreadCountByFilter',
        arguments: filter.toJson()));
  }

  /// 清空会话未读数
  Future<NIMResult<void>> clearTotalUnreadCount() async {
    return NIMResult.fromMap(await invokeMethod('clearTotalUnreadCount'));
  }

  /// 根据会话id清空会话未读数
  /// conversationIds – 会话id列表
  Future<NIMResult<List<NIMConversationOperationResult>>> clearUnreadCountByIds(
      List<String> conversationIds) async {
    return NIMResult.fromMap(
        await invokeMethod('clearUnreadCountByIds', arguments: {
          'conversationIdList': conversationIds,
        }),
        convert: (json) =>
            (json['conversationOperationResult'] as List<dynamic>?)
                ?.map((e) => NIMConversationOperationResult.fromJson(
                    (e as Map).cast<String, dynamic>()))
                .toList());
  }

  /// 根据会话id清空会话未读数
  /// groupId – 会话分组Id
  // Future<NIMResult<void>> clearUnreadCountByGroupId(String groupId) async {
  //   return NIMResult.fromMap(await invokeMethod(
  //     'clearUnreadCountByGroupId',
  //     arguments: {
  //       'groupId': groupId,
  //     },
  //   ));
  // }

  /// 根据会话类型清空相应会话的未读数
  /// groupId – 会话分组Id
  Future<NIMResult<void>> clearUnreadCountByTypes(
      List<NIMConversationType> conversationTypes) async {
    return NIMResult.fromMap(await invokeMethod(
      'clearUnreadCountByTypes',
      arguments: {
        'conversationTypeList': conversationTypes.map((e) => e.index).toList(),
      },
    ));
  }

  /// 订阅指定过滤条件的会话未读数
  /// filter – 过滤条件
  Future<NIMResult<NIMError>> subscribeUnreadCountByFilter(
      NIMConversationFilter filter) async {
    return NIMResult.fromMap(
        await invokeMethod('subscribeUnreadCountByFilter',
            arguments: {'filter': filter.toJson()}),
        convert: (json) => NIMError.fromJson(Map<String, dynamic>.from(json)));
  }

  /// 取消订阅指定过滤条件的会话未读数
  /// filter – 过滤条件
  Future<NIMResult<NIMError>> unsubscribeUnreadCountByFilter(
      NIMConversationFilter filter) async {
    return NIMResult.fromMap(
        await invokeMethod('unsubscribeUnreadCountByFilter',
            arguments: {'filter': filter.toJson()}),
        convert: (json) => NIMError.fromJson(Map<String, dynamic>.from(json)));
  }

  /// 获取会话已读时间戳 当前只支持P2P，高级群， 超大群
  /// conversationId – 会话id
  Future<NIMResult<int>> getConversationReadTime(String conversationId) async {
    return NIMResult.fromMap(await invokeMethod(
      'getConversationReadTime',
      arguments: {
        'conversationId': conversationId,
      },
    ));
  }

  /// 更新会话已读时间戳
  /// conversationId – 会话id
  Future<NIMResult<int>> markConversationRead(String conversationId) async {
    return NIMResult.fromMap(await invokeMethod(
      'markConversationRead',
      arguments: {
        'conversationId': conversationId,
      },
    ));
  }
}
