// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import '../../nim_core_platform_interface.dart';

class MethodChannelSuperTeamService extends SuperTeamServicePlatform {
  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onSuperTeamMemberUpdate':
        var teamList = arguments['teamMemberList'] as List<dynamic>?;
        List<NIMSuperTeamMember>? list = teamList
            ?.map(
                (e) => NIMSuperTeamMember.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null)
          SuperTeamServicePlatform.instance.onMemberUpdate.add(list);
        break;
      case 'onSuperTeamMemberRemove':
        var teamList = arguments['teamMemberList'] as List<dynamic>?;
        List<NIMSuperTeamMember>? list = teamList
            ?.map(
                (e) => NIMSuperTeamMember.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null)
          SuperTeamServicePlatform.instance.onMemberRemove.add(list);
        break;

      case 'onSuperTeamUpdate':
        var teamList = arguments['teamList'] as List<dynamic>?;
        List<NIMSuperTeam>? list = teamList
            ?.map((e) => NIMSuperTeam.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        if (list != null)
          SuperTeamServicePlatform.instance.onSuperTeamUpdate.add(list);
        break;
      case 'onSuperTeamRemove':
        var team = NIMSuperTeam.fromMap(arguments['team']);
        SuperTeamServicePlatform.instance.onSuperTeamRemove.add(team);
        break;
    }
    return Future.value(null);
  }

  @override
  String get serviceName => 'SuperTeamService';

  @override
  Future<NIMResult<List<NIMSuperTeam>>> queryTeamList() async {
    return NIMResult<List<NIMSuperTeam>>.fromMap(
      await invokeMethod(
        'queryTeamList',
      ),
      convert: (map) {
        var teamList = map['teamList'] as List<dynamic>?;
        return teamList?.map((e) {
          return NIMSuperTeam.fromMap(Map<String, dynamic>.from(e));
        }).toList();
      },
    );
  }

  @override
  Future<NIMResult<List<NIMSuperTeam>>> queryTeamListById(
      List<String> idList) async {
    final arguments = <String, dynamic>{};
    arguments..['teamIdList'] = idList.map((e) => e.toString()).toList();
    return NIMResult<List<NIMSuperTeam>>.fromMap(
      await invokeMethod(
        'queryTeamListById',
        arguments: arguments,
      ),
      convert: (map) {
        var teamList = map['teamList'] as List<dynamic>?;
        return teamList?.map((e) {
          return NIMSuperTeam.fromMap(Map<String, dynamic>.from(e));
        }).toList();
      },
    );
  }

  @override
  Future<NIMResult<NIMSuperTeam>> queryTeam(String teamId) async {
    final arguments = <String, dynamic>{};
    arguments..['teamId'] = teamId;
    return NIMResult<NIMSuperTeam>.fromMap(
      await invokeMethod(
        'queryTeam',
        arguments: arguments,
      ),
      convert: (json) => NIMSuperTeam.fromMap(json),
    );
  }

  @override
  Future<NIMResult<NIMSuperTeam>> searchTeam(String teamId) async {
    final arguments = <String, dynamic>{};
    arguments..['teamId'] = teamId;
    return NIMResult<NIMSuperTeam>.fromMap(
      await invokeMethod(
        'searchTeam',
        arguments: arguments,
      ),
      convert: (json) => NIMSuperTeam.fromMap(json),
    );
  }

  @override
  Future<NIMResult<NIMSuperTeam>> applyJoinTeam(
      String teamId, String postscript) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['postscript'] = postscript;
    return NIMResult<NIMSuperTeam>.fromMap(
      await invokeMethod(
        'applyJoinTeam',
        arguments: arguments,
      ),
      convert: (json) => NIMSuperTeam.fromMap(json),
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
  Future<NIMResult<List<String>>> addMembers(
      String teamId, List<String> accountList, String msg) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['accountList'] = accountList
      ..['msg'] = msg;
    return NIMResult<List<String>>.fromMap(
      await invokeMethod(
        'addMembers',
        arguments: arguments,
      ),
      convert: (map) {
        var teamMemberList = map['teamMemberList'] as List<dynamic>?;
        return teamMemberList?.map((e) => e as String).toList();
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
  Future<NIMResult<List<NIMSuperTeamMember>>> queryMemberList(
      String teamId) async {
    final arguments = <String, dynamic>{};
    arguments..['teamId'] = teamId;

    return NIMResult<List<NIMSuperTeamMember>>.fromMap(
      await invokeMethod(
        'queryMemberList',
        arguments: arguments,
      ),
      convert: (map) {
        var teamMemberList = map['teamMemberList'] as List<dynamic>?;
        return teamMemberList?.map((e) {
          return NIMSuperTeamMember.fromMap(Map<String, dynamic>.from(e));
        }).toList();
      },
    );
  }

  @override
  Future<NIMResult<NIMSuperTeamMember>> queryTeamMember(
      String teamId, String account) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['account'] = account;
    return NIMResult<NIMSuperTeamMember>.fromMap(
        await invokeMethod(
          'queryTeamMember',
          arguments: arguments,
        ),
        convert: (map) => NIMSuperTeamMember.fromMap(map));
  }

  @override
  Future<NIMResult<List<NIMSuperTeamMember>>> queryMemberListByPage(
      String teamId, int offset, int limit) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['offset'] = offset
      ..['limit'] = limit;
    return NIMResult<List<NIMSuperTeamMember>>.fromMap(
        await invokeMethod(
          'queryMemberListByPage',
          arguments: arguments,
        ), convert: (map) {
      var teamMemberList = map['teamMemberList'] as List<dynamic>?;
      return teamMemberList?.map((e) {
        return NIMSuperTeamMember.fromMap(Map<String, dynamic>.from(e));
      }).toList();
    });
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
  Future<NIMResult<void>> updateMyTeamNick(String teamId, String nick) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['nick'] = nick;
    return NIMResult<void>.fromMap(await invokeMethod(
      'updateMyTeamNick',
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
  Future<NIMResult<List<NIMSuperTeamMember>>> transferTeam(
      String teamId, String account, bool quit) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['account'] = account
      ..['quit'] = quit;
    return NIMResult<List<NIMSuperTeamMember>>.fromMap(
      await invokeMethod(
        'transferTeam',
        arguments: arguments,
      ),
      convert: (map) {
        var teamMemberList = map['teamMemberList'] as List<dynamic>?;
        return teamMemberList?.map((e) {
          return NIMSuperTeamMember.fromMap(Map<String, dynamic>.from(e));
        }).toList();
      },
    );
  }

  @override
  Future<NIMResult<List<NIMSuperTeamMember>>> addManagers(
      String teamId, List<String> accountList) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['accountList'] = accountList;
    return NIMResult<List<NIMSuperTeamMember>>.fromMap(
      await invokeMethod(
        'addManagers',
        arguments: arguments,
      ),
      convert: (map) {
        var teamMemberList = map['teamMemberList'] as List<dynamic>?;
        return teamMemberList?.map((e) {
          return NIMSuperTeamMember.fromMap(Map<String, dynamic>.from(e));
        }).toList();
      },
    );
  }

  @override
  Future<NIMResult<List<NIMSuperTeamMember>>> removeManagers(
      String teamId, List<String> accountList) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['accountList'] = accountList;
    return NIMResult<List<NIMSuperTeamMember>>.fromMap(
      await invokeMethod(
        'removeManagers',
        arguments: arguments,
      ),
      convert: (map) {
        var teamMemberList = map['teamMemberList'] as List<dynamic>?;
        return teamMemberList?.map((e) {
          return NIMSuperTeamMember.fromMap(Map<String, dynamic>.from(e));
        }).toList();
      },
    );
  }

  @override
  Future<NIMResult<void>> muteTeamMember(
      String teamId, List<String> accountList, bool mute) async {
    final arguments = <String, dynamic>{};
    arguments
      ..['teamId'] = teamId
      ..['accountList'] = accountList
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
  Future<NIMResult<List<NIMSuperTeamMember>>> queryMutedTeamMembers(
      String teamId) async {
    final arguments = <String, dynamic>{};
    arguments..['teamId'] = teamId;
    return NIMResult<List<NIMSuperTeamMember>>.fromMap(
      await invokeMethod(
        'queryMutedTeamMembers',
        arguments: arguments,
      ),
      convert: (map) {
        var teamMemberList = map['teamMemberList'] as List<dynamic>?;
        return teamMemberList?.map((e) {
          return NIMSuperTeamMember.fromMap(Map<String, dynamic>.from(e));
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
  Future<NIMResult<List<NIMSuperTeam>>> searchTeamsByKeyword(
      String keyword) async {
    final arguments = <String, dynamic>{};
    arguments..['keyword'] = keyword;
    return NIMResult<List<NIMSuperTeam>>.fromMap(
      await invokeMethod(
        'searchTeamsByKeyword',
        arguments: arguments,
      ),
      convert: (map) {
        var teamList = map['teamList'] as List<dynamic>?;
        return teamList?.map((e) {
          return NIMSuperTeam.fromMap(Map<String, dynamic>.from(e));
        }).toList();
      },
    );
  }
}
