// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qchat_message_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMFileAttachment _$NIMFileAttachmentFromJson(Map<String, dynamic> json) =>
    NIMFileAttachment(
      path: json['path'] as String?,
      size: (json['size'] as num?)?.toInt(),
      md5: json['md5'] as String?,
      url: json['url'] as String?,
      base64: json['base64'] as String?,
      displayName: json['name'] as String?,
      extension: json['ext'] as String?,
      expire: (json['expire'] as num?)?.toInt(),
      nosScene: json['sen'] as String? ?? 'defaultIm',
      forceUpload: json['force_upload'] as bool? ?? false,
    );

Map<String, dynamic> _$NIMFileAttachmentToJson(NIMFileAttachment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('url', instance.url);
  writeNotNull('base64', instance.base64);
  val['size'] = instance.size;
  writeNotNull('md5', instance.md5);
  val['name'] = instance.displayName;
  val['ext'] = instance.extension;
  val['expire'] = instance.expire;
  val['sen'] = instance.nosScene;
  val['force_upload'] = instance.forceUpload;
  return val;
}

NIMAudioAttachment _$NIMAudioAttachmentFromJson(Map<String, dynamic> json) =>
    NIMAudioAttachment(
      duration: (json['dur'] as num?)?.toInt(),
      autoTransform: json['autoTransform'] as bool?,
      text: json['text'] as String?,
      path: json['path'] as String?,
      size: (json['size'] as num?)?.toInt(),
      md5: json['md5'] as String?,
      url: json['url'] as String?,
      base64: json['base64'] as String?,
      displayName: json['name'] as String?,
      extension: json['ext'] as String?,
      expire: (json['expire'] as num?)?.toInt(),
      nosScene: json['sen'] as String? ?? 'defaultIm',
      forceUpload: json['force_upload'] as bool? ?? false,
    );

Map<String, dynamic> _$NIMAudioAttachmentToJson(NIMAudioAttachment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('url', instance.url);
  writeNotNull('base64', instance.base64);
  val['size'] = instance.size;
  writeNotNull('md5', instance.md5);
  val['name'] = instance.displayName;
  val['ext'] = instance.extension;
  val['expire'] = instance.expire;
  val['sen'] = instance.nosScene;
  val['force_upload'] = instance.forceUpload;
  val['dur'] = instance.duration;
  val['autoTransform'] = instance.autoTransform;
  val['text'] = instance.text;
  return val;
}

NIMVideoAttachment _$NIMVideoAttachmentFromJson(Map<String, dynamic> json) =>
    NIMVideoAttachment(
      duration: (json['dur'] as num?)?.toInt(),
      width: (json['w'] as num?)?.toInt(),
      height: (json['h'] as num?)?.toInt(),
      thumbPath: json['thumbPath'] as String?,
      thumbUrl: json['thumbUrl'] as String?,
      path: json['path'] as String?,
      size: (json['size'] as num?)?.toInt(),
      md5: json['md5'] as String?,
      url: json['url'] as String?,
      base64: json['base64'] as String?,
      displayName: json['name'] as String?,
      extension: json['ext'] as String?,
      expire: (json['expire'] as num?)?.toInt(),
      nosScene: json['sen'] as String? ?? 'defaultIm',
      forceUpload: json['force_upload'] as bool? ?? false,
    );

Map<String, dynamic> _$NIMVideoAttachmentToJson(NIMVideoAttachment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('url', instance.url);
  writeNotNull('base64', instance.base64);
  val['size'] = instance.size;
  writeNotNull('md5', instance.md5);
  val['name'] = instance.displayName;
  val['ext'] = instance.extension;
  val['expire'] = instance.expire;
  val['sen'] = instance.nosScene;
  val['force_upload'] = instance.forceUpload;
  val['dur'] = instance.duration;
  val['w'] = instance.width;
  val['h'] = instance.height;
  val['thumbPath'] = instance.thumbPath;
  val['thumbUrl'] = instance.thumbUrl;
  return val;
}

NIMImageAttachment _$NIMImageAttachmentFromJson(Map<String, dynamic> json) =>
    NIMImageAttachment(
      thumbPath: json['thumbPath'] as String?,
      thumbUrl: json['thumbUrl'] as String?,
      width: (json['w'] as num?)?.toInt(),
      height: (json['h'] as num?)?.toInt(),
      path: json['path'] as String?,
      base64: json['base64'] as String?,
      size: (json['size'] as num?)?.toInt(),
      md5: json['md5'] as String?,
      url: json['url'] as String?,
      displayName: json['name'] as String?,
      extension: json['ext'] as String?,
      expire: (json['expire'] as num?)?.toInt(),
      nosScene: json['sen'] as String? ?? 'defaultIm',
      forceUpload: json['force_upload'] as bool? ?? false,
    );

Map<String, dynamic> _$NIMImageAttachmentToJson(NIMImageAttachment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('url', instance.url);
  writeNotNull('base64', instance.base64);
  val['size'] = instance.size;
  writeNotNull('md5', instance.md5);
  val['name'] = instance.displayName;
  val['ext'] = instance.extension;
  val['expire'] = instance.expire;
  val['sen'] = instance.nosScene;
  val['force_upload'] = instance.forceUpload;
  writeNotNull('thumbPath', instance.thumbPath);
  writeNotNull('thumbUrl', instance.thumbUrl);
  val['w'] = instance.width;
  val['h'] = instance.height;
  return val;
}

NIMLocationAttachment _$NIMLocationAttachmentFromJson(
        Map<String, dynamic> json) =>
    NIMLocationAttachment(
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      address: json['title'] as String,
    );

Map<String, dynamic> _$NIMLocationAttachmentToJson(
        NIMLocationAttachment instance) =>
    <String, dynamic>{
      'lat': instance.latitude,
      'lng': instance.longitude,
      'title': instance.address,
    };

NIMChatroomNotificationAttachment _$NIMChatroomNotificationAttachmentFromJson(
        Map<String, dynamic> json) =>
    NIMChatroomNotificationAttachment(
      type: (json['type'] as num).toInt(),
      targets:
          (json['targets'] as List<dynamic>?)?.map((e) => e as String).toList(),
      targetNicks: (json['targetNicks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      operator: json['operator'] as String?,
      operatorNick: json['operatorNick'] as String?,
      extension: castPlatformMapToDartMap(json['extension'] as Map?),
    );

Map<String, dynamic> _$NIMChatroomNotificationAttachmentToJson(
        NIMChatroomNotificationAttachment instance) =>
    <String, dynamic>{
      'type': instance.type,
      'targets': instance.targets,
      'targetNicks': instance.targetNicks,
      'operator': instance.operator,
      'operatorNick': instance.operatorNick,
      'extension': instance.extension,
    };

NIMChatroomMemberInAttachment _$NIMChatroomMemberInAttachmentFromJson(
        Map<String, dynamic> json) =>
    NIMChatroomMemberInAttachment(
      muted: json['muted'] as bool? ?? false,
      tempMuted: json['tempMuted'] as bool? ?? false,
      tempMutedDuration: (json['tempMutedDuration'] as num?)?.toInt() ?? 0,
      targets:
          (json['targets'] as List<dynamic>?)?.map((e) => e as String).toList(),
      targetNicks: (json['targetNicks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      operator: json['operator'] as String?,
      operatorNick: json['operatorNick'] as String?,
      extension: castPlatformMapToDartMap(json['extension'] as Map?),
    );

Map<String, dynamic> _$NIMChatroomMemberInAttachmentToJson(
        NIMChatroomMemberInAttachment instance) =>
    <String, dynamic>{
      'targets': instance.targets,
      'targetNicks': instance.targetNicks,
      'operator': instance.operator,
      'operatorNick': instance.operatorNick,
      'extension': instance.extension,
      'muted': instance.muted,
      'tempMuted': instance.tempMuted,
      'tempMutedDuration': instance.tempMutedDuration,
    };

NIMChatroomTempMuteAttachment _$NIMChatroomTempMuteAttachmentFromJson(
        Map<String, dynamic> json) =>
    NIMChatroomTempMuteAttachment(
      type: (json['type'] as num).toInt(),
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      targets:
          (json['targets'] as List<dynamic>?)?.map((e) => e as String).toList(),
      targetNicks: (json['targetNicks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      operator: json['operator'] as String?,
      operatorNick: json['operatorNick'] as String?,
      extension: castPlatformMapToDartMap(json['extension'] as Map?),
    );

Map<String, dynamic> _$NIMChatroomTempMuteAttachmentToJson(
        NIMChatroomTempMuteAttachment instance) =>
    <String, dynamic>{
      'type': instance.type,
      'targets': instance.targets,
      'targetNicks': instance.targetNicks,
      'operator': instance.operator,
      'operatorNick': instance.operatorNick,
      'extension': instance.extension,
      'duration': instance.duration,
    };

NIMChatroomQueueChangeAttachment _$NIMChatroomQueueChangeAttachmentFromJson(
        Map<String, dynamic> json) =>
    NIMChatroomQueueChangeAttachment(
      type: (json['type'] as num).toInt(),
      queueChangeType: $enumDecode(
          _$NIMChatroomQueueChangeTypeEnumMap, json['queueChangeType']),
      content: json['content'] as String?,
      key: json['key'] as String?,
      contentMap: castMapToTypeOfStringString(json['contentMap'] as Map?),
      targets:
          (json['targets'] as List<dynamic>?)?.map((e) => e as String).toList(),
      targetNicks: (json['targetNicks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      operator: json['operator'] as String?,
      operatorNick: json['operatorNick'] as String?,
      extension: castPlatformMapToDartMap(json['extension'] as Map?),
    );

Map<String, dynamic> _$NIMChatroomQueueChangeAttachmentToJson(
        NIMChatroomQueueChangeAttachment instance) =>
    <String, dynamic>{
      'type': instance.type,
      'targets': instance.targets,
      'targetNicks': instance.targetNicks,
      'operator': instance.operator,
      'operatorNick': instance.operatorNick,
      'extension': instance.extension,
      'contentMap': instance.contentMap,
      'queueChangeType':
          _$NIMChatroomQueueChangeTypeEnumMap[instance.queueChangeType]!,
      'key': instance.key,
      'content': instance.content,
    };

const _$NIMChatroomQueueChangeTypeEnumMap = {
  NIMChatroomQueueChangeType.undefined: 'undefined',
  NIMChatroomQueueChangeType.offer: 'offer',
  NIMChatroomQueueChangeType.poll: 'poll',
  NIMChatroomQueueChangeType.drop: 'drop',
  NIMChatroomQueueChangeType.partialClear: 'partialClear',
  NIMChatroomQueueChangeType.batchUpdate: 'batchUpdate',
};
