// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

/// SDK 状态码
class NIMResultCode {
  /// 操作失败
  static const fail = -1;

  ///  操作成功
  static const success = 0;

  static const success_200 = 200;

  ///  密码不正确
  static const passwordError = 302;

  ///  登录ip或mac被禁
  static const addrBlocked = 310;

  ///  内部帐户不允许在该地址登陆
  static const ipNotAllowed = 315;

  ///  版本号太旧，需要升级
  static const versionExpired = 317;

  ///  应用被封禁
  static const forbidden = 403;

  ///  目标(对象或用户)不存在
  static const nonExist = 404;

  ///  操作超时
  static const timeout = 408;

  ///  参数错误
  static const paramError = 414;

  ///  网络连接出现问题
  static const connectionError = 415;

  ///  操作太过频繁
  static const frequently = 416;

  ///  对象已经存在
  static const alreadyExist = 417;

  ///  帐号被禁用
  static const accountBlocked = 422;

  ///  设备不在信任设备表里
  static const deviceNotTrust = 431;

  ///  服务器内部错误
  static const unknownError = 500;

  ///  操作数据库失败
  static const dbException = 502;

  ///  服务器太忙
  static const serverBusy = 503;

  ///  超过期限
  static const overdue = 508;

  ///  已经失效
  static const invalid = 509;

  ///  红包功能不可用
  static const rpInvalid = 515;

  ///  清空会话未读数部分成功
  static const clearUnreadPartSuccess = 700;

  // 群错误码
  ///  已达到人数限制
  static const teamAccountLimit = 801;

  ///  没有权限
  static const teamInaccessible = 802;

  ///  群不存在
  static const teamNotExist = 803;

  ///  用户不在群里面
  static const teamMemberNotExist = 804;

  ///  群类型不对
  static const teamErrorType = 805;

  ///  群数量达到上限
  static const teamLimit = 806;

  ///  群成员状态不对
  static const teamUserStatusError = 807;

  ///  申请成功
  static const teamApplySuccess = 808;

  ///  用户已经在群里了
  static const teamAlreadyIn = 809;

  ///  邀请成功
  static const teamInviteSuccess = 810;

  ///  部分邀请成功，同时会有失败列表
  static const teamInvitePartSuccess = 813;

  ///  部分请求成功，同时会有失败列表
  static const teamInfoPartSuccess = 816;

  ///  装包失败，内部错误
  static const packetError = 999;

  ///  解包失败，内部错误
  static const unPacketError = 998;

  ///  被接收方加入黑名单
  static const inBlackList = 7101;
}
