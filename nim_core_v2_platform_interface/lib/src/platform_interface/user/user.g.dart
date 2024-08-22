// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMUserInfo _$NIMUserInfoFromJson(Map<String, dynamic> json) => NIMUserInfo(
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

Map<String, dynamic> _$NIMUserInfoToJson(NIMUserInfo instance) =>
    <String, dynamic>{
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
    };

NIMUserUpdateParam _$NIMUserUpdateParamFromJson(Map<String, dynamic> json) =>
    NIMUserUpdateParam(
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      sign: json['sign'] as String?,
      gender: (json['gender'] as num?)?.toInt(),
      email: json['email'] as String?,
      birthday: json['birthday'] as String?,
      mobile: json['mobile'] as String?,
      serverExtension: json['serverExtension'] as String?,
    );

Map<String, dynamic> _$NIMUserUpdateParamToJson(NIMUserUpdateParam instance) =>
    <String, dynamic>{
      'name': instance.name,
      'avatar': instance.avatar,
      'sign': instance.sign,
      'gender': instance.gender,
      'email': instance.email,
      'birthday': instance.birthday,
      'mobile': instance.mobile,
      'serverExtension': instance.serverExtension,
    };

NIMUserSearchOption _$NIMUserSearchOptionFromJson(Map<String, dynamic> json) =>
    NIMUserSearchOption(
      keyword: json['keyword'] as String,
      searchName: json['searchName'] as bool?,
      searchAccountId: json['searchAccountId'] as bool?,
      searchMobile: json['searchMobile'] as bool?,
    );

Map<String, dynamic> _$NIMUserSearchOptionToJson(
        NIMUserSearchOption instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'searchName': instance.searchName,
      'searchAccountId': instance.searchAccountId,
      'searchMobile': instance.searchMobile,
    };
