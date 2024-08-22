// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMAIUser _$NIMAIUserFromJson(Map<String, dynamic> json) => NIMAIUser(
      modelType:
          $enumDecodeNullable(_$NIMAIModelTypeEnumMap, json['modelType']),
      modelConfig: _nimAIModelConfigFromJson(json['modelConfig'] as Map?),
      accountId: json['accountId'] as String?,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      sign: json['sign'] as String?,
      gender: (json['gender'] as num?)?.toInt(),
      email: json['email'] as String?,
      birthday: json['birthday'] as String?,
      mobile: json['mobile'] as String?,
      serverExtension: json['serverExtension'] as String?,
      createTime: (json['createTime'] as num?)?.toInt(),
      updateTime: (json['updateTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMAIUserToJson(NIMAIUser instance) => <String, dynamic>{
      'accountId': instance.accountId,
      'name': instance.name,
      'avatar': instance.avatar,
      'sign': instance.sign,
      'gender': instance.gender,
      'email': instance.email,
      'birthday': instance.birthday,
      'mobile': instance.mobile,
      'serverExtension': instance.serverExtension,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'modelType': _$NIMAIModelTypeEnumMap[instance.modelType],
      'modelConfig': instance.modelConfig?.toJson(),
    };

const _$NIMAIModelTypeEnumMap = {
  NIMAIModelType.nimAiModelTypeUKnown: 0,
  NIMAIModelType.nimAiModelTypeQwen: 1,
  NIMAIModelType.nimAiModelTypeAzure: 2,
  NIMAIModelType.nimAiModelTypePrivate: 3,
};
