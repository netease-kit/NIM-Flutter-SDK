// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

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
        // var teamList = arguments['team'] as List<dynamic>?;
        // List<NIMTeam>? list = teamList
        //     ?.map((e) => NIMTeam.fromMap(Map<String, dynamic>.from(e)))
        //     .toList();
        final team = arguments['team'] as Map?;
        if (team != null) {
          TeamServicePlatform.instance.onTeamListRemove.add(
            [NIMTeam.fromMap(Map<String, dynamic>.from(team))],
          );
        }
        break;

      case 'onTeamMemberUpdate':
        var teamMemberList = arguments['teamMemberList'] as List<dynamic>?;
        List<NIMTeamMember>? list = teamMemberList
            ?.map((e) => NIMTeamMember.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null)
          TeamServicePlatform.instance.onTeamMemberUpdate.add(list);
        break;

      case 'onTeamMemberRemove':
        var teamMemberList = arguments['teamMemberList'] as List<dynamic>?;
        List<NIMTeamMember>? list = teamMemberList
            ?.map((e) => NIMTeamMember.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null)
          TeamServicePlatform.instance.onTeamMemberRemove.add(list);
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
  Future<NIMResult<void>> rejectApply(
      String teamId, String account, String reason) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['account'] = account
      ..['reason'] = reason;
    return NIMResult<void>.fromMap(await invokeMethod(
      'rejectApply',
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
        var teamMemberExList = map['teamMemberExList'] as List<dynamic>?;
        return teamMemberExList?.map((e) => e as String).toList();
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
  Future<NIMResult<void>> declineInvite(
      String teamId, String inviter, String reason) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['inviter'] = inviter
      ..['reason'] = reason;
    return NIMResult<void>.fromMap(await invokeMethod(
      'declineInvite',
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

    var mapResult = await invokeMethod(
      'getMemberInvitor',
      arguments: arguments,
    );

    mapResult['data'] = (mapResult['data'] as Map?)?.cast<String, String>();
    return NIMResult<Map<String, String>>.fromMap(mapResult);
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
        var teamMemberList = map['teamMemberList'] as List<dynamic>?;
        return teamMemberList?.map((e) {
          return NIMTeamMember.fromMap(Map<String, dynamic>.from(e));
        }).toList();
      },
    );
  }

  @override
  Future<NIMResult<void>> updateTeamFields(
      String teamId, NIMTeamUpdateFieldRequest request) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['request'] = request.toMap();
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
      ..['notifyType'] = NIMTeamMessageNotifyTypeEnumEnumMap[notifyType];
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
        var teamList = map['teamNameList'] as List<dynamic>?;
        return teamList?.map((e) => e as String).toList();
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

  @override
  Future<NIMResult<void>> updateMyTeamNick(String teamId, String nick) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['nick'] = nick;
    return NIMResult<List<NIMTeam>>.fromMap(await invokeMethod(
      'updateMyTeamNick',
      arguments: arguments,
    ));
  }
}
