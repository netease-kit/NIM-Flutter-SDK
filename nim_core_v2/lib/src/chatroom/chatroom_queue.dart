// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

@HawkEntryPoint()
class V2NIMChatroomQueueService {
  int instanceId;

  V2NIMChatroomQueueService(this.instanceId);

  ChatroomQueuePlatform get _platform => ChatroomQueuePlatform.instance;

  @HawkApi(ignore: true)
  List<StreamSubscription> _listeners = [];

  @HawkApi(ignore: true)
  final _onChatroomQueueBatchOfferedController =
      StreamController<List<V2NIMChatroomQueueElement>>.broadcast();

  @HawkApi(ignore: true)
  final _onChatroomQueueBatchUpdatedController =
      StreamController<List<V2NIMChatroomQueueElement>>.broadcast();

  @HawkApi(ignore: true)
  final _onChatroomQueueDroppedController = StreamController<void>.broadcast();

  @HawkApi(ignore: true)
  final _onChatroomQueueOfferedController =
      StreamController<V2NIMChatroomQueueElement>.broadcast();

  @HawkApi(ignore: true)
  final _onChatroomQueuePartClearedController =
      StreamController<List<V2NIMChatroomQueueElement>>.broadcast();

  @HawkApi(ignore: true)
  final _onChatroomQueuePolledController =
      StreamController<V2NIMChatroomQueueElement>.broadcast();

  /// 聊天室新增队列元素
  /// @param element 新增的队列内容
  @HawkApi(ignore: true)
  Stream<V2NIMChatroomQueueElement> get onChatroomQueueOffered =>
      _onChatroomQueueOfferedController.stream;

  /// 聊天室删除队列元素
  /// @param element 删除的队列内容
  @HawkApi(ignore: true)
  Stream<V2NIMChatroomQueueElement> get onChatroomQueuePolled =>
      _onChatroomQueuePolledController.stream;

  /// 聊天室清空队列元素
  @HawkApi(ignore: true)
  Stream<void> get onChatroomQueueDropped =>
      _onChatroomQueueDroppedController.stream;

  /// 聊天室清理部分队列元素
  /// @param elements 清理的队列列表
  @HawkApi(ignore: true)
  Stream<List<V2NIMChatroomQueueElement>> get onChatroomQueuePartCleared =>
      _onChatroomQueuePartClearedController.stream;

  /// 聊天室批量更新元素
  /// @param elements 更新的队列列表
  @HawkApi(ignore: true)
  Stream<List<V2NIMChatroomQueueElement>> get onChatroomQueueBatchUpdated =>
      _onChatroomQueueBatchUpdatedController.stream;

  /// 聊天室批量新增元素
  /// @param elements 新增的队列列表
  @HawkApi(ignore: true)
  Stream<List<V2NIMChatroomQueueElement>> get onChatroomQueueBatchOffered =>
      _onChatroomQueueBatchOfferedController.stream;

  /// 聊天室队列新增或更新元素
  ///  [offerParams] 新增或更新元素参数
  Future<NIMResult<void>> queueOffer(
      V2NIMChatroomQueueOfferParams offerParams) async {
    return _platform.queueOffer(instanceId, offerParams);
  }

  /// 取出头元素或者指定的元素
  /// 仅管理员和创建者可以操作
  /// [elementKey] 如果为空表示取出头元素，如果不为空，取出指定的元素
  Future<NIMResult<V2NIMChatroomQueueElement>> queuePoll(
      String elementKey) async {
    return _platform.queuePoll(instanceId, elementKey);
  }

  /// 排序列出所有元素
  Future<NIMResult<List<V2NIMChatroomQueueElement>>> queueList() async {
    return _platform.queueList(instanceId);
  }

  /// 查看队头元素，不删除
  Future<NIMResult<V2NIMChatroomQueueElement>> queuePeek() async {
    return _platform.queuePeek(instanceId);
  }

  /// 清空队列
  /// 仅管理员/创建者可以操作
  Future<NIMResult<void>> queueDrop() async {
    return _platform.queueDrop(instanceId);
  }

  /// 初始化队列
  ///  [size] 初始化队列的长度，长度限制：0~1000，超过返回参数错误
  Future<NIMResult<void>> queueInit(int size) async {
    return _platform.queueInit(instanceId, size);
  }

  /// 批量更新队列元素
  ///  [elements] 批量更新元素，size为空，size==0，size>100，返回参数错误
  ///  [notificationEnabled] 是否发送广播通知，默认为true
  ///  [notificationExtension] 本次操作生成的通知中的扩展字段，长度限制：2048字节
  Future<NIMResult<List<String>?>> queueBatchUpdate(
      List<V2NIMChatroomQueueElement> elements,
      {bool notificationEnabled = true,
      String? notificationExtension}) async {
    return _platform.queueBatchUpdate(
        instanceId, elements, notificationEnabled, notificationExtension);
  }

  /// 添加聊天室队列监听器
  Future<NIMResult<void>> addQueueListener() async {
    return _platform.addQueueListener(instanceId).then((value) {
      if (value.isSuccess) {
        _listeners.addAll([
          _platform.onChatroomQueueOffered.listen((event) {
            if (event.instanceId == instanceId && event.element != null) {
              _onChatroomQueueOfferedController.add(event.element!);
            }
          }),
          _platform.onChatroomQueuePolled.listen((event) {
            if (event.instanceId == instanceId && event.element != null) {
              _onChatroomQueuePolledController.add(event.element!);
            }
          }),
          _platform.onChatroomQueueDropped.listen((event) {
            if (event.instanceId == instanceId) {
              _onChatroomQueueDroppedController.add(null);
            }
          }),
          _platform.onChatroomQueuePartCleared.listen((event) {
            if (event.instanceId == instanceId && event.elements != null) {
              _onChatroomQueuePartClearedController.add(event.elements!);
            }
          }),
          _platform.onChatroomQueueBatchOffered.listen((event) {
            if (event.instanceId == instanceId && event.elements != null) {
              _onChatroomQueueBatchOfferedController.add(event.elements!);
            }
          }),
          _platform.onChatroomQueueBatchUpdated.listen((event) {
            if (event.instanceId == instanceId && event.elements != null) {
              _onChatroomQueueBatchUpdatedController.add(event.elements!);
            }
          })
        ]);
      }
      return value;
    });
  }

  /// 移除聊天室队列监听器
  Future<NIMResult<void>> removeQueueListener() async {
    return _platform.removeQueueListener(instanceId).then((value) {
      if (value.isSuccess) {
        _listeners.forEach((e) => e.cancel());
        _listeners.clear();
      }
      return value;
    });
  }
}
