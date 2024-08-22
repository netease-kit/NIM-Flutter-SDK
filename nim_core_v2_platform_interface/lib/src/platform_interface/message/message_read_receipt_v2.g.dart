// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_read_receipt_v2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMP2PMessageReadReceipt _$NIMP2PMessageReadReceiptFromJson(
        Map<String, dynamic> json) =>
    NIMP2PMessageReadReceipt(
      conversationId: json['conversationId'] as String?,
      timestamp: (json['timestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMP2PMessageReadReceiptToJson(
        NIMP2PMessageReadReceipt instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'timestamp': instance.timestamp,
    };

NIMTeamMessageReadReceipt _$NIMTeamMessageReadReceiptFromJson(
        Map<String, dynamic> json) =>
    NIMTeamMessageReadReceipt(
      conversationId: json['conversationId'] as String?,
      messageServerId: json['messageServerId'] as String?,
      messageClientId: json['messageClientId'] as String?,
      readCount: (json['readCount'] as num?)?.toInt(),
      unreadCount: (json['unreadCount'] as num?)?.toInt(),
      latestReadAccount: json['latestReadAccount'] as String?,
    );

Map<String, dynamic> _$NIMTeamMessageReadReceiptToJson(
        NIMTeamMessageReadReceipt instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'messageServerId': instance.messageServerId,
      'messageClientId': instance.messageClientId,
      'readCount': instance.readCount,
      'unreadCount': instance.unreadCount,
      'latestReadAccount': instance.latestReadAccount,
    };

NIMTeamMessageReadReceiptDetail _$NIMTeamMessageReadReceiptDetailFromJson(
        Map<String, dynamic> json) =>
    NIMTeamMessageReadReceiptDetail(
      readReceipt:
          _nimTeamMessageReadReceiptFromJson(json['readReceipt'] as Map?),
      readAccountList: (json['readAccountList'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      unreadAccountList: (json['unreadAccountList'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
    );

Map<String, dynamic> _$NIMTeamMessageReadReceiptDetailToJson(
        NIMTeamMessageReadReceiptDetail instance) =>
    <String, dynamic>{
      'readReceipt': instance.readReceipt?.toJson(),
      'readAccountList': instance.readAccountList,
      'unreadAccountList': instance.unreadAccountList,
    };
