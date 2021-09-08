// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core_platform_interface/src/platform_interface/nim_base.dart';
import 'package:nim_core_platform_interface/src/platform_interface/team/create_team_options.dart';
import 'package:nim_core_platform_interface/src/platform_interface/team/platform_interface_team_service.dart';
import 'package:nim_core_platform_interface/src/platform_interface/team/team.dart';
import 'package:nim_core_platform_interface/src/platform_interface/team/team_member.dart';

import '../../nim_core_platform_interface.dart';

class MethodChannelTeamService extends TeamServicePlatform {
  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onTeamListUpdate':
        var teamList = arguments['teamList'] as List<dynamic>?;
        List<NIMTeam>? list = teamList
            ?.map((e) => NIMTeam.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null)
          TeamServicePlatform.instance.onTeamListUpdate.add(list);
        break;
      case 'onTeamListRemove':
        var teamList = arguments['team'] as List<dynamic>?;
        List<NIMTeam>? list = teamList
            ?.map((e) => NIMTeam.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null)
          TeamServicePlatform.instance.onTeamListRemove.add(list);
        break;
    }
    return Future.value(null);
  }

  @override
  String get serviceName => 'TeamService';

  @override
  Future<NIMResult<NIMCreateTeamResult>> createTeam(
      NIMCreateTeamOptions createTeamOptions, List<String> members) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['createTeamOptions'] = createTeamOptions.toMap()
      ..['members'] = members;
    return NIMResult<NIMCreateTeamResult>.fromMap(
      await invokeMethod(
        'createTeam',
        arguments: arguments,
      ),
      convert: (map) => NIMCreateTeamResult.fromMap(map),
    );
  }

  @override
  Future<NIMResult<List<NIMTeam>>> queryTeamList() async {
    return NIMResult<List<NIMTeam>>.fromMap(
      await invokeMethod(
        'queryTeamList',
      ),
      convert: (map) {
        var teamList = map['teamList'] as List<dynamic>?;
        return teamList?.map((e) {
          return NIMTeam.fromMap(Map<String, dynamic>.from(e));
        }).toList();
      },
    );
  }

  @override
  Future<NIMResult<NIMTeam>> queryTeam(String teamId) async {
    final arguments = <String, dynamic>{};
    arguments..['teamId'] = teamId;
    return NIMResult<NIMTeam>.fromMap(
      await invokeMethod(
        'queryTeam',
        arguments: arguments,
      ),
      convert: (json) => NIMTeam.fromMap(json),
    );
  }

  @override
  Future<NIMResult<NIMTeam>> searchTeam(String teamId) async {
    final arguments = <String, dynamic>{};
    arguments..['teamId'] = teamId;
    return NIMResult<NIMTeam>.fromMap(
      await invokeMethod(
        'searchTeam',
        arguments: arguments,
      ),
      convert: (json) => NIMTeam.fromMap(json),
    );
  }

  @override
  Future<NIMResult<void>> dismissTeam(String teamId) async {
    final arguments = <String, dynamic>{};
    arguments..['teamId'] = teamId;
    return NIMResult<void>.fromMap(await invokeMethod(
      'dismissTeam',
      arguments: arguments,
    ));
  }

  @override
  Future<NIMResult<NIMTeam>> applyJoinTeam(
      String teamId, String postscript) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['postscript'] = postscript;
    return NIMResult<NIMTeam>.fromMap(
      await invokeMethod(
        'applyJoinTeam',
        arguments: arguments,
      ),
      convert: (json) => NIMTeam.fromMap(json),
    );
  }

  @override
  Future<NIMResult<void>> passApply(String teamId, String account) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['account'] = account;
    return NIMResult<void>.fromMap(await invokeMethod(
      'passApply',
      arguments: arguments,
    ));
  }

  @override
  Future<NIMResult<List<String>>> addMembersEx(String teamId,
      List<String> accounts, String msg, String customInfo) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['accounts'] = accounts
      ..['msg'] = msg
      ..['customInfo'] = customInfo;
    return NIMResult<List<String>>.fromMap(
      await invokeMethod(
        'addMembersEx',
        arguments: arguments,
      ),
      convert: (map) {
        var teamMemberExList = map['teamMemberExList'] as List<String>?;
        return teamMemberExList?.map((e) => e).toList();
      },
    );
  }

  @override
  Future<NIMResult<void>> acceptInvite(String teamId, String inviter) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['inviter'] = inviter;
    return NIMResult<void>.fromMap(await invokeMethod(
      'acceptInvite',
      arguments: arguments,
    ));
  }

  @override
  Future<NIMResult<Map<String, String>>> getMemberInvitor(
      String teamId, List<String> accids) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['accids'] = accids;
    return NIMResult<Map<String, String>>.fromMap(
      await invokeMethod(
        'getMemberInvitor',
        arguments: arguments,
      ),
    );
  }

  @override
  Future<NIMResult<void>> removeMembers(
      String teamId, List<String> members) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['members'] = members;
    return NIMResult<void>.fromMap(await invokeMethod(
      'removeMembers',
      arguments: arguments,
    ));
  }

  @override
  Future<NIMResult<void>> quitTeam(String teamId) async {
    final arguments = <String, dynamic>{};
    arguments..['teamId'] = teamId;
    return NIMResult<void>.fromMap(await invokeMethod(
      'quitTeam',
      arguments: arguments,
    ));
  }

  @override
  Future<NIMResult<List<NIMTeamMember>>> queryMemberList(String teamId) async {
    final arguments = <String, dynamic>{};
    arguments..['teamId'] = teamId;

    return NIMResult<List<NIMTeamMember>>.fromMap(
      await invokeMethod(
        'queryMemberList',
        arguments: arguments,
      ),
      convert: (map) {
        var teamMemberList = map['teamMemberList'] as List<dynamic>?;
        return teamMemberList?.map((e) {
          return NIMTeamMember.fromMap(Map<String, dynamic>.from(e));
        }).toList();
      },
    );
  }

  @override
  Future<NIMResult<NIMTeamMember>> queryTeamMember(
      String teamId, String account) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['account'] = account;
    return NIMResult<NIMTeamMember>.fromMap(
        await invokeMethod(
          'queryTeamMember',
          arguments: arguments,
        ),
        convert: (map) => NIMTeamMember.fromMap(map));
  }

  @override
  Future<NIMResult<void>> updateMemberNick(
      String teamId, String account, String nick) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['account'] = account
      ..['nick'] = nick;
    return NIMResult<void>.fromMap(await invokeMethod(
      'updateMemberNick',
      arguments: arguments,
    ));
  }

  @override
  Future<NIMResult<void>> updateMyMemberExtension(
      String teamId, Map<String, Object> extension) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['extension'] = extension;
    return NIMResult<void>.fromMap(await invokeMethod(
      'updateMyMemberExtension',
      arguments: arguments,
    ));
  }

  @override
  Future<NIMResult<List<NIMTeamMember>>> transferTeam(
      String teamId, String account, bool quit) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['account'] = account
      ..['quit'] = quit;
    return NIMResult<List<NIMTeamMember>>.fromMap(
      await invokeMethod(
        'transferTeam',
        arguments: arguments,
      ),
      convert: (map) {
        var teamMemberList = map['teamMemberList'] as List<dynamic>?;
        return teamMemberList?.map((e) {
          return NIMTeamMember.fromMap(Map<String, dynamic>.from(e));
        }).toList();
      },
    );
  }

  @override
  Future<NIMResult<List<NIMTeamMember>>> addManagers(
      String teamId, List<String> accounts) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['accounts'] = accounts;
    return NIMResult<List<NIMTeamMember>>.fromMap(
      await invokeMethod(
        'addManagers',
        arguments: arguments,
      ),
      convert: (map) {
        var teamMemberList = map['teamMemberList'] as List<dynamic>?;
        return teamMemberList?.map((e) {
          return NIMTeamMember.fromMap(Map<String, dynamic>.from(e));
        }).toList();
      },
    );
  }

  @override
  Future<NIMResult<List<NIMTeamMember>>> removeManagers(
      String teamId, List<String> managers) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['managers'] = managers;
    return NIMResult<List<NIMTeamMember>>.fromMap(
      await invokeMethod(
        'removeManagers',
        arguments: arguments,
      ),
      convert: (map) {
        var teamMemberList = map['teamMemberList'] as List<dynamic>?;
        return teamMemberList?.map((e) {
          return NIMTeamMember.fromMap(Map<String, dynamic>.from(e));
        }).toList();
      },
    );
  }

  @override
  Future<NIMResult<void>> muteTeamMember(
      String teamId, String account, bool mute) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['account'] = account
      ..['mute'] = mute;
    return NIMResult<Map<String, String>>.fromMap(await invokeMethod(
      'muteTeamMember',
      arguments: arguments,
    ));
  }

  @override
  Future<NIMResult<void>> muteAllTeamMember(String teamId, bool mute) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['mute'] = mute;
    return NIMResult<Map<String, String>>.fromMap(await invokeMethod(
      'muteAllTeamMember',
      arguments: arguments,
    ));
  }

  @override
  Future<NIMResult<List<NIMTeamMember>>> queryMutedTeamMembers(
      String teamId) async {
    final arguments = <String, dynamic>{};
    arguments..['teamId'] = teamId;
    return NIMResult<List<NIMTeamMember>>.fromMap(
      await invokeMethod(
        'queryMutedTeamMembers',
        arguments: arguments,
      ),
      convert: (map) {
        var teamMemberList = map as List<dynamic>?;
        return teamMemberList?.map((e) {
          return NIMTeamMember.fromMap(Map<String, dynamic>.from(e));
        }).toList();
      },
    );
  }

  @override
  Future<NIMResult<void>> updateTeam(
      String teamId, NIMTeamFieldEnum field, String value) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['field'] = NIMTeamFieldEnumEnumMap[field.index]
      ..['value'] = value;
    return NIMResult<void>.fromMap(await invokeMethod(
      'updateTeam',
      arguments: arguments,
    ));
  }

  @override
  Future<NIMResult<void>> updateTeamFields(
      String teamId, Map<NIMTeamFieldEnum, String> fields) async {
    final arguments = <String, dynamic>{};
    final _fields = <int, dynamic>{};
    fields.keys.forEach((element) {
      _fields[element.index] = fields[element];
    });
    arguments
      ..['teamId'] = teamId
      ..['fields'] = _fields;
    return NIMResult<void>.fromMap(await invokeMethod(
      'updateTeamFields',
      arguments: arguments,
    ));
  }

  @override
  Future<NIMResult<void>> muteTeam(
      String teamId, NIMTeamMessageNotifyTypeEnum notifyType) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['notifyType'] = notifyType.index;
    return NIMResult<Map<String, String>>.fromMap(await invokeMethod(
      'muteTeam',
      arguments: arguments,
    ));
  }

  @override
  Future<NIMResult<List<String>>> searchTeamIdByName(String name) async {
    final arguments = <String, dynamic>{};
    arguments..['name'] = name;
    return NIMResult<List<String>>.fromMap(
      await invokeMethod(
        'searchTeamIdByName',
        arguments: arguments,
      ),
      convert: (map) {
        var teamList = map['teamNameList'] as List<String>?;
        return teamList?.map((e) => e).toList();
      },
    );
  }

  @override
  Future<NIMResult<List<NIMTeam>>> searchTeamsByKeyword(String keyword) async {
    final arguments = <String, dynamic>{};
    arguments..['keyword'] = keyword;
    return NIMResult<List<NIMTeam>>.fromMap(
      await invokeMethod(
        'searchTeamsByKeyword',
        arguments: arguments,
      ),
      convert: (map) {
        var teamList = map['teamList'] as List<dynamic>?;
        return teamList?.map((e) {
          return NIMTeam.fromMap(Map<String, dynamic>.from(e));
        }).toList();
      },
    );
  }
}
