// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'dart:async';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

class MethodChannelTeamService extends TeamServicePlatform {
  @override
  Future onEvent(String method, dynamic arguments) {
    switch (method) {
      case 'onSyncStarted':
        TeamServicePlatform.instance.onSyncStarted.add(null);
        break;
      case 'onSyncFinished':
        TeamServicePlatform.instance.onSyncFinished.add(null);
        break;
      case 'onSyncFailed':
        TeamServicePlatform.instance.onSyncFailed.add(
            NIMResult.fromMap(Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onTeamCreated':
        TeamServicePlatform.instance.onTeamCreated
            .add(NIMTeam.fromJson(Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onTeamDismissed':
        TeamServicePlatform.instance.onTeamDismissed
            .add(NIMTeam.fromJson(Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onTeamJoined':
        TeamServicePlatform.instance.onTeamJoined
            .add(NIMTeam.fromJson(Map<String, dynamic>.from(arguments as Map)));
        break;
      case 'onTeamLeft':
        final result = TeamLeftReuslt.fromJson(
            Map<String, dynamic>.from(arguments as Map));
        TeamServicePlatform.instance.onTeamLeft.add(result);
        break;

      case 'onTeamInfoUpdated':
        TeamServicePlatform.instance.onTeamInfoUpdated
            .add(NIMTeam.fromJson(Map<String, dynamic>.from(arguments as Map)));
        break;

      case 'onTeamMemberJoined':
        final memberList = arguments['memberList'] as List<dynamic>?;
        List<NIMTeamMember>? list = memberList
            ?.map((e) => NIMTeamMember.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null) {
          TeamServicePlatform.instance.onTeamMemberJoined.add(list);
        }
        break;

      case 'onTeamMemberKicked':
        final operatorAccountId = arguments['operatorAccountId'] as String?;
        final memberList = arguments['memberList'] as List<dynamic>?;
        List<NIMTeamMember>? list = memberList
            ?.map((e) => NIMTeamMember.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null && operatorAccountId != null) {
          final result = TeamMemberKickedResult(
              teamMembers: list, operatorAccountId: operatorAccountId);
          TeamServicePlatform.instance.onTeamMemberKicked.add(result);
        }
        break;

      case 'onReceiveTeamJoinActionInfo':
        var info = NIMTeamJoinActionInfo.fromJson(
            Map<String, dynamic>.from(arguments as Map));
        TeamServicePlatform.instance.onReceiveTeamJoinActionInfo.add(info);
        break;

      case 'onTeamMemberLeft':
        final memberList = arguments['memberList'] as List<dynamic>?;
        List<NIMTeamMember>? list = memberList
            ?.map((e) => NIMTeamMember.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null) {
          TeamServicePlatform.instance.onTeamMemberLeft.add(list);
        }
        break;

      case 'onTeamMemberInfoUpdated':
        final memberList = arguments['memberList'] as List<dynamic>?;
        List<NIMTeamMember>? list = memberList
            ?.map((e) => NIMTeamMember.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null) {
          TeamServicePlatform.instance.onTeamMemberInfoUpdated.add(list);
        }
        break;
    }

    return Future.value(null);
  }

  @override
  String get serviceName => 'TeamService';

  @override
  Future<NIMResult<NIMCreateTeamResult>> createTeam(
      NIMCreateTeamParams createTeamParams,
      List<String>? inviteeAccountIds,
      String? postscript,
      NIMAntispamConfig? antispamConfig) async {
    return NIMResult<NIMCreateTeamResult>.fromMap(
        await invokeMethod('createTeam', arguments: {
          'createTeamParams': createTeamParams.toJson(),
          'inviteeAccountIds': inviteeAccountIds,
          'postscript': postscript,
          'antispamConfig': antispamConfig?.toJson()
        }),
        convert: (json) => NIMCreateTeamResult.fromJson(json));
  }

  /**
   *  更新群组
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param updateTeamInfoParams 更新参数
   *  @param antispamConfig 反垃圾配置
   */

  Future<NIMResult<void>> updateTeamInfo(
      String teamId,
      NIMTeamType teamType,
      NIMUpdateTeamInfoParams updateTeamInfoParams,
      NIMAntispamConfig? antispamConfig) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('updateTeamInfo', arguments: {
      'teamId': teamId,
      'teamType': NIMTeamTypeClass(teamType).toValue(),
      'updateTeamInfoParams': updateTeamInfoParams.toJson(),
      'antispamConfig': antispamConfig?.toJson()
    }));
  }

  /**
   *  退出群组
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param success 成功回调
   *  @param failure 失败回调
   */

  Future<NIMResult<void>> leaveTeam(String teamId, NIMTeamType teamType) async {
    return NIMResult<void>.fromMap(await invokeMethod('leaveTeam', arguments: {
      'teamId': teamId,
      'teamType': NIMTeamTypeClass(teamType).toValue()
    }));
  }

  /**
   *  获取群组信息
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   */
  Future<NIMResult<NIMTeam>> getTeamInfo(
      String teamId, NIMTeamType teamType) async {
    return NIMResult<NIMTeam>.fromMap(
        await invokeMethod('getTeamInfo', arguments: {
          'teamId': teamId,
          'teamType': NIMTeamTypeClass(teamType).toValue()
        }),
        convert: (json) => NIMTeam.fromJson(json));
  }

  /**
   *  根据群组id获取群组信息
   *
   *  @param teamIds 群组Id列表
   *  @param teamType 群组类型
   */
  Future<NIMResult<List<NIMTeam>>> getTeamInfoByIds(
      List<String> teamIds, NIMTeamType teamType) async {
    return NIMResult<List<NIMTeam>>.fromMap(
        await invokeMethod('getTeamInfoByIds', arguments: {
          'teamIds': teamIds,
          'teamType': NIMTeamTypeClass(teamType).toValue()
        }),
        convert: (json) => json['teamList']
            .map<NIMTeam>((e) => NIMTeam.fromJson(Map<String, dynamic>.from(e)))
            .toList());
  }

  /**
   *  解散群组
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  Future<NIMResult<void>> dismissTeam(
      String teamId, NIMTeamType teamType) async {
    return NIMResult<void>.fromMap(await invokeMethod('dismissTeam',
        arguments: {
          'teamId': teamId,
          'teamType': NIMTeamTypeClass(teamType).toValue()
        }));
  }

  /**
   *  邀请成员加入群组
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param inviteeAccountIds 邀请加入账号id列表
   *  @param postscript 邀请入群的附言
   */
  Future<NIMResult<List<String>>> inviteMember(
      String teamId,
      NIMTeamType teamType,
      List<String> inviteeAccountIds,
      String? postscript) async {
    return NIMResult<List<String>>.fromMap(
        await invokeMethod('inviteMember', arguments: {
          'teamId': teamId,
          'teamType': NIMTeamTypeClass(teamType).toValue(),
          'inviteeAccountIds': inviteeAccountIds,
          'postscript': postscript
        }),
        convert: (json) => List<String>.from(json['failedList']));
  }

  /**
   *  同意邀请入群
   *
   *  @param invitationInfo 邀请信息
   */
  Future<NIMResult<NIMTeam>> acceptInvitation(
      NIMTeamJoinActionInfo invitationInfo) async {
    return NIMResult<NIMTeam>.fromMap(
        await invokeMethod('acceptInvitation',
            arguments: {'invitationInfo': invitationInfo.toJson()}),
        convert: (json) => NIMTeam.fromJson(json));
  }

  /**
   *  拒绝邀请入群请求
   *
   *  @param invitationInfo 邀请信息
   *  @param postscript 拒绝邀请入群的附言
   */
  Future<NIMResult<void>> rejectInvitation(
      NIMTeamJoinActionInfo invitationInfo, String? postscript) async {
    return NIMResult<void>.fromMap(await invokeMethod('rejectInvitation',
        arguments: {
          'invitationInfo': invitationInfo.toJson(),
          'postscript': postscript
        }));
  }

  /**
   *  踢出群组成员
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param memberAccountIds 踢出群组的成员账号列表
   */
  Future<NIMResult<void>> kickMember(String teamId, NIMTeamType teamType,
      List<String>? memberAccountIds) async {
    return NIMResult<void>.fromMap(await invokeMethod('kickMember', arguments: {
      'teamId': teamId,
      'teamType': NIMTeamTypeClass(teamType).toValue(),
      'memberAccountIds': memberAccountIds
    }));
  }

  /**
   *  申请加入群组
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param postscript 申请入群的附言
   */
  Future<NIMResult<NIMTeam>> applyJoinTeam(
      String teamId, NIMTeamType teamType, String? postscript) async {
    return NIMResult<NIMTeam>.fromMap(
        await invokeMethod('applyJoinTeam', arguments: {
          'teamId': teamId,
          'teamType': NIMTeamTypeClass(teamType).toValue(),
          'postscript': postscript
        }),
        convert: (json) => NIMTeam.fromJson(json));
  }

  /**
   *  接受入群申请请求
   *
   *  @param applicationInfo 申请信息
   */
  Future<NIMResult<void>> acceptJoinApplication(
      NIMTeamJoinActionInfo applicationInfo) async {
    return NIMResult<void>.fromMap(await invokeMethod('acceptJoinApplication',
        arguments: {'joinInfo': applicationInfo.toJson()}));
  }

  /**
   *  拒绝入群申请
   *
   *  @param applicationInfo 申请信息
   *  @param postscript 拒绝申请加入的附言
   */
  Future<NIMResult<void>> rejectJoinApplication(
      NIMTeamJoinActionInfo applicationInfo, String? postscript) async {
    return NIMResult<void>.fromMap(await invokeMethod('rejectJoinApplication',
        arguments: {
          'joinInfo': applicationInfo.toJson(),
          'postscript': postscript
        }));
  }

  /**
   *  设置成员角色
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param memberAccountIds 设置成员角色的账号id列表
   *  @param memberRole 设置新的角色类型
   */
  Future<NIMResult<void>> updateTeamMemberRole(
      String teamId,
      NIMTeamType teamType,
      List<String> memberAccountIds,
      NIMTeamMemberRole memberRole) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('updateTeamMemberRole', arguments: {
      'teamId': teamId,
      'teamType': NIMTeamTypeClass(teamType).toValue(),
      'memberAccountIds': memberAccountIds,
      'memberRole': NIMTeamMemberRoleClass(memberRole).toValue()
    }));
  }

  /**
   *  移交群主
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param accountId 新群主的账号id
   *  @param leave 转让群主后，是否同时退出该群
   */
  Future<NIMResult<void>> transferTeamOwner(
      String teamId, NIMTeamType teamType, String accountId, bool leave) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('transferTeamOwner', arguments: {
      'teamId': teamId,
      'teamType': NIMTeamTypeClass(teamType).toValue(),
      'accountId': accountId,
      'leave': leave
    }));
  }

  /**
   *  修改自己的群成员信息
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param memberInfoParams 更新参数
   */
  Future<NIMResult<void>> updateSelfTeamMemberInfo(
      String teamId,
      NIMTeamType teamType,
      NIMUpdateSelfMemberInfoParams memberInfoParams) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('updateSelfTeamMemberInfo', arguments: {
      'teamId': teamId,
      'teamType': NIMTeamTypeClass(teamType).toValue(),
      'memberInfoParams': memberInfoParams.toJson()
    }));
  }

  /**
   *  修改群成员昵称
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param accountId 被修改成员的账号id
   *  @param teamNick 被修改成员新的昵称
   */
  Future<NIMResult<void>> updateTeamMemberNick(String teamId,
      NIMTeamType teamType, String accountId, String teamNick) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('updateTeamMemberNick', arguments: {
      'teamId': teamId,
      'teamType': NIMTeamTypeClass(teamType).toValue(),
      'accountId': accountId,
      'teamNick': teamNick
    }));
  }

  /**
   *  设置群组聊天禁言模式
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param chatBannedMode 群组禁言模式
   */
  Future<NIMResult<void>> setTeamChatBannedMode(String teamId,
      NIMTeamType teamType, NIMTeamChatBannedMode chatBannedMode) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('setTeamChatBannedMode', arguments: {
      'teamId': teamId,
      'teamType': NIMTeamTypeClass(teamType).toValue(),
      'chatBannedMode': NIMTeamChatBannedModeClass(chatBannedMode).toValue()
    }));
  }

  /**
   *  设置群组成员聊天禁言状态
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param accountId 群成员账号id
   *  @param chatBanned 群组中聊天是否被禁言
   */
  Future<NIMResult<void>> setTeamMemberChatBannedStatus(String teamId,
      NIMTeamType teamType, String accountId, bool chatBanned) async {
    return NIMResult<void>.fromMap(
        await invokeMethod('setTeamMemberChatBannedStatus', arguments: {
      'teamId': teamId,
      'teamType': NIMTeamTypeClass(teamType).toValue(),
      'accountId': accountId,
      'chatBanned': chatBanned
    }));
  }

  /**
   *  获取当前已经加入的群组列表
   *
   *  @param teamTypes 群类型列表，nil或空列表表示获取所有
   */
  Future<NIMResult<List<NIMTeam>>> getJoinedTeamList(
      List<NIMTeamType> teamTypes) async {
    return NIMResult<List<NIMTeam>>.fromMap(
        await invokeMethod('getJoinedTeamList',
            arguments: {'teamTypes': teamTypes.map((e) => e.index).toList()}),
        convert: (json) => json['teamList']
            .map<NIMTeam>((e) => NIMTeam.fromJson(Map<String, dynamic>.from(e)))
            .toList());
  }

  /**
   *  获取当前已经加入的群组个数
   *
   *  @param teamTypes 群类型列表，nil或空列表表示获取所有
   */
  Future<NIMResult<int>> getJoinedTeamCount(List<NIMTeamType> teamTypes) async {
    return NIMResult<int>.fromMap(await invokeMethod('getJoinedTeamCount',
        arguments: {'teamTypes': teamTypes.map((e) => e.index).toList()}));
  }

  /**
   *  获取群组成员列表
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param queryOption 群组成员查询选项
   */
  Future<NIMResult<NIMTeamMemberListResult>> getTeamMemberList(String teamId,
      NIMTeamType teamType, NIMTeamMemberQueryOption queryOption) async {
    return NIMResult<NIMTeamMemberListResult>.fromMap(
        await invokeMethod('getTeamMemberList', arguments: {
          'teamId': teamId,
          'teamType': NIMTeamTypeClass(teamType).toValue(),
          'queryOption': queryOption.toJson()
        }),
        convert: (json) => NIMTeamMemberListResult.fromJson(json));
  }

  /**
   *  根据账号id列表获取群组成员列表
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param accountIds 账号id列表
   */
  Future<NIMResult<List<NIMTeamMember>>> getTeamMemberListByIds(
      String teamId, NIMTeamType teamType, List<String> accountIds) async {
    return NIMResult<List<NIMTeamMember>>.fromMap(
        await invokeMethod('getTeamMemberListByIds', arguments: {
          'teamId': teamId,
          'teamType': NIMTeamTypeClass(teamType).toValue(),
          'accountIds': accountIds
        }),
        convert: (json) => json['memberList']
            .map<NIMTeamMember>(
                (e) => NIMTeamMember.fromJson(Map<String, dynamic>.from(e)))
            .toList());
  }

  /**
   *  根据账号id列表获取群组成员邀请人
   *
   *  @param teamId 群组Id
   *  @param teamType 群组类型
   *  @param accountIds 账号id列表
   */
  Future<NIMResult<Map<String, String>>> getTeamMemberInvitor(
      String teamId, NIMTeamType teamType, List<String> accountIds) async {
    return NIMResult<Map<String, String>>.fromMap(
        await invokeMethod('getTeamMemberInvitor', arguments: {
          'teamId': teamId,
          'teamType': NIMTeamTypeClass(teamType).toValue(),
          'accountIds': accountIds
        }),
        convert: (json) =>
            json.map((key, value) => MapEntry(key, value as dynamic)));
  }

  /**
   *  获取群加入相关信息
   *
   *  @param queryOption 查询参数
   */
  Future<NIMResult<NIMTeamJoinActionInfoResult>> getTeamJoinActionInfoList(
      NIMTeamJoinActionInfoQueryOption queryOption) async {
    return NIMResult<NIMTeamJoinActionInfoResult>.fromMap(
        await invokeMethod('getTeamJoinActionInfoList',
            arguments: {'queryOption': queryOption.toJson()}),
        convert: (json) => NIMTeamJoinActionInfoResult.fromJson(json));
  }

  /**
   *  根据关键字搜索群信息
   *
   *  @param keyword 关键字
   */
  Future<NIMResult<List<NIMTeam>>> searchTeamByKeyword(String keyword) async {
    return NIMResult<List<NIMTeam>>.fromMap(
        await invokeMethod('searchTeamByKeyword',
            arguments: {'keyword': keyword}),
        convert: (json) => json['teamList']
            .map<NIMTeam>((e) => NIMTeam.fromJson(Map<String, dynamic>.from(e)))
            .toList());
  }

  /**
   *  根据关键字搜索群成员
   *
   *  @param searchOption 搜索参数
   *  @param success 成功回调
   *  @param failure 失败回调
   */
  Future<NIMResult<NIMTeamMemberListResult>> searchTeamMembers(
      NIMTeamMemberSearchOption searchOption) async {
    return NIMResult<NIMTeamMemberListResult>.fromMap(
        await invokeMethod('searchTeamMembers',
            arguments: {'searchOption': searchOption.toJson()}),
        convert: (json) => NIMTeamMemberListResult.fromJson(json));
  }
}
