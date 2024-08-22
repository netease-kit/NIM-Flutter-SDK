// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

part "message_collection_v2.g.dart";

@JsonSerializable(explicitToJson: true)
class NIMCollectionOption {
  /// 查询开始时间区间，闭区间
  int? beginTime;

  /// 查询结束时间区间，闭区间 endTime大于beginTime
  int? endTime;

  /// 查询方向,默认按时间从大到小查询
  NIMQueryDirection? direction;

  /// 查询锚点
  /// 如果anchor为空， 则以beginTime，endTime为准
  /// 如果anchor不为空如果direction为DESC，
  /// endTime不为0， 则必须等于anchor的时间， 否则报错
  /// endTime为0， 则以anchor为准
  /// 如果dirction为ASC
  /// beginTime不为0， 则必须等于anchor的时间， 否则报错
  /// beginTime为0， 则以anhor为准
  /// 查询内部不包括anchor
  @JsonKey(fromJson: _nimCollectionFromJson)
  NIMCollection? anchorCollection;

  /// 每次查询收藏条数,不超过200
  int? limit;

  /// 收藏类型,为0表示查询所有类型
  int? collectionType;

  NIMCollectionOption(
      {this.beginTime,
      this.endTime,
      this.direction,
      this.anchorCollection,
      this.limit,
      this.collectionType});

  factory NIMCollectionOption.fromJson(Map<String, dynamic> map) =>
      _$NIMCollectionOptionFromJson(map);

  Map<String, dynamic> toJson() => _$NIMCollectionOptionToJson(this);
}

NIMCollection? _nimCollectionFromJson(Map? map) {
  if (map != null) {
    return NIMCollection.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class NIMCollection {
  /// 收藏信息客户端 ID, 收藏时若存在相同客户端 ID 则覆盖
  String? collectionId;

  /// 收藏索引,大于 0， 可以按该字段分类
  int? collectionType;

  /// 收藏数据, 最大 20480 字节
  String? collectionData;

  /// 收藏信息客户端 ID, 收藏时若存在相同客户端 ID 则覆盖
  String? serverExtension;

  /// 创建时间
  int? createTime;

  /// 更新时间
  int? updateTime;

  /// 去重唯一ID， 如果ID相同， 则不会新增收藏，只更新之前的收藏内容
  String? uniqueId;

  NIMCollection(
      {this.collectionId,
      this.collectionType,
      this.collectionData,
      this.serverExtension,
      this.createTime,
      this.updateTime,
      this.uniqueId});

  factory NIMCollection.fromJson(Map<String, dynamic> map) =>
      _$NIMCollectionFromJson(map);

  Map<String, dynamic> toJson() => _$NIMCollectionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NIMAddCollectionParams {
  /// 收藏索引,大于 0， 可以按该字段分类
  int? collectionType;

  /// 收藏数据, 最大 20480 字节
  String? collectionData;

  /// 收藏信息客户端 ID, 收藏时若存在相同客户端 ID 则覆盖
  String? serverExtension;

  /// 去重唯一ID， 如果ID相同， 则不会新增收藏，只更新之前的收藏内容
  String? uniqueId;

  NIMAddCollectionParams(
      {this.collectionType,
      this.collectionData,
      this.serverExtension,
      this.uniqueId});

  factory NIMAddCollectionParams.fromJson(Map<String, dynamic> map) =>
      _$NIMAddCollectionParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMAddCollectionParamsToJson(this);
}
