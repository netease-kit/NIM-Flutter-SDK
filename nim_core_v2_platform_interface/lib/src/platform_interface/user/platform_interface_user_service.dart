// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:nim_core_v2_platform_interface/src/method_channel/method_channel_user_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class UserServicePlatform extends Service {
  UserServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static UserServicePlatform _instance = MethodChannelUserService();

  static UserServicePlatform get instance => _instance;

  static set instance(UserServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  final StreamController<List<NIMUserInfo>> onUserProfileChanged =
      StreamController<List<NIMUserInfo>>.broadcast();

  final StreamController<NIMUserInfo> onBlockListAdded =
      StreamController<NIMUserInfo>.broadcast();

  final StreamController<String> onBlockListRemoved =
      StreamController<String>.broadcast();

  Future<NIMResult<List<NIMUserInfo>>> getUserList(List<String> userId) async {
    throw UnimplementedError('getUserList() is not implemented');
  }

  Future<NIMResult<List<NIMUserInfo>>> getUserListFromCloud(
      List<String> userId) async {
    throw UnimplementedError('getUserListFromCloud() is not implemented');
  }

  Future<NIMResult<void>> updateSelfUserProfile(
      NIMUserUpdateParam param) async {
    throw UnimplementedError('updateSelfUserProfile() is not implemented');
  }

  Future<NIMResult<void>> addUserToBlockList(String userId) async {
    throw UnimplementedError('addUserToBlockList() is not implemented');
  }

  Future<NIMResult<void>> removeUserFromBlockList(String userId) async {
    throw UnimplementedError('removeUserFromBlockList() is not implemented');
  }

  Future<NIMResult<List<String>>> getBlockList() async {
    throw UnimplementedError('getBlockList() is not implemented');
  }

  Future<NIMResult<List<NIMUserInfo>>> searchUserByOption(
      NIMUserSearchOption userSearchOption) async {
    throw UnimplementedError('searchUserByOption() is not implemented');
  }
}
