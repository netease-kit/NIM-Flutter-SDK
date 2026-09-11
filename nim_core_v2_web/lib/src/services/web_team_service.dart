// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';

import '../converters/enum_converter.dart';
import '../converters/error_converter.dart';
import '../converters/js_dart_converter.dart';
import '../js_interop/nim_sdk.dart';
import 'web_initialize_service.dart';

/// Web 端群组服务实现
class WebTeamService extends TeamServicePlatform {
  JSObject? _jsService;

  // JS callback 引用
  final Map<String, JSFunction> _jsCallbacks = {};

  WebTeamService() {
    WebInitializeService.registerOnInit(_onNimInit);
    WebInitializeService.registerOnRelease(_onNimRelease);
  }

  void _onNimInit(JSV2NIM nim) {
    _removeListeners();
    final svc = (nim as JSObject).getProperty('V2NIMTeamService'.toJS);
    if (svc != null && svc.isA<JSObject>()) {
      _jsService = svc as JSObject;
      _setupListeners();
    }
  }

  void _onNimRelease() {
    _removeListeners();
    _jsService = null;
  }

  void _on(String event, JSFunction callback) {
    final service = _jsService;
    if (service == null) return;
    _jsCallbacks[event] = callback;
    final on_ = service.getProperty('on'.toJS) as JSFunction;
    on_.callAsFunction(service, event.toJS, callback);
  }

  void _setupListeners() {
    _on(
      'onSyncStarted',
      (() {
        onSyncStarted.add(null);
      }).toJS,
    );
    _on(
      'onSyncFinished',
      (() {
        onSyncFinished.add(null);
      }).toJS,
    );
    _on(
      'onSyncFailed',
      ((JSObject error) {
        final map = jsObjectToMap(error);
        onSyncFailed.add(NIMResult.fromMap(map));
      }).toJS,
    );

    _on(
      'onTeamCreated',
      ((JSObject team) {
        onTeamCreated.add(NIMTeam.fromJson(jsObjectToMap(team)));
      }).toJS,
    );

    _on(
      'onTeamDismissed',
      ((JSObject team) {
        onTeamDismissed.add(NIMTeam.fromJson(jsObjectToMap(team)));
      }).toJS,
    );

    _on(
      'onTeamInfoUpdated',
      ((JSObject team) {
        onTeamInfoUpdated.add(NIMTeam.fromJson(jsObjectToMap(team)));
      }).toJS,
    );

    _on(
      'onTeamJoined',
      ((JSObject team) {
        onTeamJoined.add(NIMTeam.fromJson(jsObjectToMap(team)));
      }).toJS,
    );

    _on(
      'onTeamLeft',
      ((JSObject team, JSBoolean isKicked) {
        onTeamLeft.add(
          TeamLeftReuslt.fromJson({
            'team': jsObjectToMap(team),
            'isKicked': isKicked.toDart,
          }),
        );
      }).toJS,
    );

    _on(
      'onTeamMemberJoined',
      ((JSArray memberList) {
        final list = jsArrayToMapList(memberList);
        onTeamMemberJoined.add(
          list.map((m) => NIMTeamMember.fromJson(m)).toList(),
        );
      }).toJS,
    );

    _on(
      'onTeamMemberKicked',
      ((JSString operatorAccountId, JSArray memberList) {
        final list = jsArrayToMapList(memberList);
        onTeamMemberKicked.add(
          TeamMemberKickedResult.fromJson({
            'operatorAccountId': operatorAccountId.toDart,
            // TeamMemberKickedResult.fromJson 期望的 key 是 'teamMembers'，
            // 而不是 'memberList'，否则 json['teamMembers'] 为 null 导致
            // TypeError: null is not a subtype of List<dynamic>
            'teamMembers': list,
          }),
        );
      }).toJS,
    );

    _on(
      'onTeamMemberLeft',
      ((JSArray memberList) {
        final list = jsArrayToMapList(memberList);
        onTeamMemberLeft.add(
          list.map((m) => NIMTeamMember.fromJson(m)).toList(),
        );
      }).toJS,
    );

    _on(
      'onTeamMemberInfoUpdated',
      ((JSArray memberList) {
        final list = jsArrayToMapList(memberList);
        onTeamMemberInfoUpdated.add(
          list.map((m) => NIMTeamMember.fromJson(m)).toList(),
        );
      }).toJS,
    );

    _on(
      'onReceiveTeamJoinActionInfo',
      ((JSObject data) {
        try {
          final map = jsObjectToMap(data);
          // Web SDK 的 serverId 在无值时返回空字符串 ""，而 Dart 模型期望 int?
          // 若直接 as int? 会抛出 TypeError，需提前转为 null
          if (map['serverId'] is String &&
              (map['serverId'] as String).isEmpty) {
            map['serverId'] = null;
          }
          onReceiveTeamJoinActionInfo.add(
            NIMTeamJoinActionInfo.fromJson(map),
          );
        } catch (e) {
          // 防止解析异常被 NIM SDK 静默吞掉，导致事件永远收不到
          // ignore: avoid_print
          print('[WebTeamService] onReceiveTeamJoinActionInfo parse error: $e');
        }
      }).toJS,
    );
  }

  void _removeListeners() {
    final service = _jsService;
    if (service == null) return;
    final off_ = service.getProperty('off'.toJS) as JSFunction;
    _jsCallbacks.forEach((event, callback) {
      off_.callAsFunction(service, event.toJS, callback);
    });
    _jsCallbacks.clear();
  }

  Future<JSAny?> _callJSAsync(String methodName, List<JSAny?> args) async {
    final service = _jsService;
    if (service == null) throw Exception('NIM SDK not initialized');
    final method = service.getProperty(methodName.toJS) as JSFunction;
    final applyMethod = method.getProperty('apply'.toJS) as JSFunction;
    final result = applyMethod.callAsFunction(method, service, args.toJS);
    if (result != null && result.isA<JSPromise>()) {
      return await (result as JSPromise).toDart;
    }
    return result;
  }

  @override
  String get serviceName => 'TeamService';

  @override
  Future<dynamic> onEvent(String method, dynamic arguments) async => null;

  // ====== API 方法实现 ======

  @override
  Future<NIMResult<NIMCreateTeamResult>> createTeam(
    NIMCreateTeamParams createTeamParams,
    List<String>? inviteeAccountIds,
    String? postscript,
    NIMAntispamConfig? antispamConfig,
  ) async {
    try {
      // inviteeAccountIds/postscript/antispamConfig 均为 Web SDK 位置型可选参数
      // 当某个参数为 null 时，其后的参数也必须省略
      final List<JSAny?> args = [dartMapToJsObject(createTeamParams.toJson())];
      if (inviteeAccountIds != null) args.add(inviteeAccountIds.jsify());
      if (inviteeAccountIds != null && postscript != null) {
        args.add(postscript.toJS);
      } else if (inviteeAccountIds != null) {
        // postscript 为 null，但 antispamConfig 可能有值，需要占位
        if (antispamConfig != null) args.add(null);
      }
      if (inviteeAccountIds != null && antispamConfig != null) {
        args.add(dartMapToJsObject(antispamConfig.toJson()));
      }
      final result = await _callJSAsync('createTeam', args);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject);
        return NIMResult<NIMCreateTeamResult>.fromMap(
          {'code': 0, 'data': map},
          convert: (d) =>
              NIMCreateTeamResult.fromJson(d as Map<String, dynamic>),
        );
      }
      return NIMResult<NIMCreateTeamResult>.fromMap({
        'code': -1,
        'errorDetails': 'createTeam returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMCreateTeamResult>(e);
    }
  }

  @override
  Future<NIMResult<void>> updateTeamInfo(
    String teamId,
    NIMTeamType teamType,
    NIMUpdateTeamInfoParams updateTeamInfoParams,
    NIMAntispamConfig? antispamConfig,
  ) async {
    try {
      // antispamConfig 是 Web SDK 可选参数，为 null 时必须省略，不能传 null
      final List<JSAny?> updateArgs = [
        teamId.toJS,
        teamType.index.toJS,
        dartMapToJsObject(updateTeamInfoParams.toJson()),
      ];
      if (antispamConfig != null) {
        updateArgs.add(dartMapToJsObject(antispamConfig.toJson()));
      }
      await _callJSAsync('updateTeamInfo', updateArgs);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> leaveTeam(String teamId, NIMTeamType teamType) async {
    try {
      await _callJSAsync('leaveTeam', [teamId.toJS, teamType.index.toJS]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<NIMTeam>> getTeamInfo(
    String teamId,
    NIMTeamType teamType,
  ) async {
    try {
      final result = await _callJSAsync('getTeamInfo', [
        teamId.toJS,
        teamType.index.toJS,
      ]);
      if (result != null && result.isA<JSObject>()) {
        return NIMResult<NIMTeam>.fromMap({
          'code': 0,
          'data': jsObjectToMap(result as JSObject),
        }, convert: (d) => NIMTeam.fromJson(d as Map<String, dynamic>));
      }
      return NIMResult<NIMTeam>.fromMap({
        'code': -1,
        'errorDetails': 'getTeamInfo returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMTeam>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMTeam>>> getTeamInfoByIds(
    List<String> teamIds,
    NIMTeamType teamType,
  ) async {
    try {
      final result = await _callJSAsync('getTeamInfoByIds', [
        teamIds.jsify() as JSAny,
        teamType.index.toJS,
      ]);
      if (result != null && result.isA<JSArray>()) {
        final list = jsArrayToMapList(result as JSArray);
        final teams = list.map((m) => NIMTeam.fromJson(m)).toList();
        return NIMResult<List<NIMTeam>>.fromMap(
          {
            'code': 0,
            'data': {'teamList': teams.map((t) => t.toJson()).toList()},
          },
          convert: (d) {
            final l = (d as Map<String, dynamic>)['teamList'] as List;
            return l
                .map(
                  (e) => NIMTeam.fromJson((e as Map).cast<String, dynamic>()),
                )
                .toList();
          },
        );
      }
      return NIMResult<List<NIMTeam>>.fromMap({
        'code': 0,
        'data': {'teamList': []},
      }, convert: (_) => <NIMTeam>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMTeam>>(e);
    }
  }

  @override
  Future<NIMResult<void>> dismissTeam(
    String teamId,
    NIMTeamType teamType,
  ) async {
    try {
      await _callJSAsync('dismissTeam', [teamId.toJS, teamType.index.toJS]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<List<String>>> inviteMember(
    String teamId,
    NIMTeamType teamType,
    List<String> inviteeAccountIds,
    String? postscript,
  ) async {
    try {
      // postscript 是 Web SDK 可选参数，为 null 时必须省略，不能传 null
      final args = postscript != null
          ? [
              teamId.toJS,
              teamType.index.toJS,
              inviteeAccountIds.jsify() as JSAny,
              postscript.toJS
            ]
          : [
              teamId.toJS,
              teamType.index.toJS,
              inviteeAccountIds.jsify() as JSAny
            ];
      final result = await _callJSAsync('inviteMember', args);
      if (result != null && result.isA<JSArray>()) {
        final list = (result as JSArray)
            .toDart
            .map(
              (i) =>
                  i != null && i.isA<JSString>() ? (i as JSString).toDart : '',
            )
            .where((s) => s.isNotEmpty)
            .toList();
        return NIMResult<List<String>>.fromMap(
          {
            'code': 0,
            'data': {'failedList': list},
          },
          convert: (d) => ((d as Map<String, dynamic>)['failedList'] as List)
              .cast<String>(),
        );
      }
      return NIMResult<List<String>>.fromMap({
        'code': 0,
        'data': {'failedList': []},
      }, convert: (_) => <String>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<String>>(e);
    }
  }

  @override
  Future<NIMResult<NIMTeam>> acceptInvitation(
    NIMTeamJoinActionInfo invitationInfo,
  ) async {
    try {
      final result = await _callJSAsync('acceptInvitation', [
        dartMapToJsObject(invitationInfo.toJson()),
      ]);
      if (result != null && result.isA<JSObject>()) {
        return NIMResult<NIMTeam>.fromMap({
          'code': 0,
          'data': jsObjectToMap(result as JSObject),
        }, convert: (d) => NIMTeam.fromJson(d as Map<String, dynamic>));
      }
      return NIMResult<NIMTeam>.fromMap({
        'code': -1,
        'errorDetails': 'acceptInvitation returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMTeam>(e);
    }
  }

  @override
  Future<NIMResult<void>> rejectInvitation(
    NIMTeamJoinActionInfo invitationInfo,
    String? postscript,
  ) async {
    try {
      // postscript 是 Web SDK 可选参数，为 null 时必须省略，不能传 null
      final args = postscript != null
          ? [dartMapToJsObject(invitationInfo.toJson()), postscript.toJS]
          : [dartMapToJsObject(invitationInfo.toJson())];
      await _callJSAsync('rejectInvitation', args);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> kickMember(
    String teamId,
    NIMTeamType teamType,
    List<String>? memberAccountIds,
  ) async {
    try {
      await _callJSAsync('kickMember', [
        teamId.toJS,
        teamType.index.toJS,
        (memberAccountIds ?? []).jsify() as JSAny,
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<NIMTeam>> applyJoinTeam(
    String teamId,
    NIMTeamType teamType,
    String? postscript,
  ) async {
    try {
      // postscript 是 Web SDK 可选参数，为 null 时必须省略，不能传 null
      final args = postscript != null
          ? [teamId.toJS, teamType.index.toJS, postscript.toJS]
          : [teamId.toJS, teamType.index.toJS];
      final result = await _callJSAsync('applyJoinTeam', args);
      if (result != null && result.isA<JSObject>()) {
        return NIMResult<NIMTeam>.fromMap({
          'code': 0,
          'data': jsObjectToMap(result as JSObject),
        }, convert: (d) => NIMTeam.fromJson(d as Map<String, dynamic>));
      }
      return NIMResult<NIMTeam>.fromMap({
        'code': -1,
        'errorDetails': 'applyJoinTeam returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMTeam>(e);
    }
  }

  @override
  Future<NIMResult<void>> acceptJoinApplication(
    NIMTeamJoinActionInfo applicationInfo,
  ) async {
    try {
      await _callJSAsync('acceptJoinApplication', [
        dartMapToJsObject(applicationInfo.toJson()),
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> rejectJoinApplication(
    NIMTeamJoinActionInfo applicationInfo,
    String? postscript,
  ) async {
    try {
      // postscript 是 Web SDK 可选参数，为 null 时必须省略，不能传 null
      final args = postscript != null
          ? [dartMapToJsObject(applicationInfo.toJson()), postscript.toJS]
          : [dartMapToJsObject(applicationInfo.toJson())];
      await _callJSAsync('rejectJoinApplication', args);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> updateTeamMemberRole(
    String teamId,
    NIMTeamType teamType,
    List<String> memberAccountIds,
    NIMTeamMemberRole memberRole,
  ) async {
    try {
      await _callJSAsync('updateTeamMemberRole', [
        teamId.toJS,
        teamType.index.toJS,
        memberAccountIds.jsify() as JSAny,
        memberRole.index.toJS,
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> transferTeamOwner(
    String teamId,
    NIMTeamType teamType,
    String accountId,
    bool leave,
  ) async {
    try {
      await _callJSAsync('transferTeamOwner', [
        teamId.toJS,
        teamType.index.toJS,
        accountId.toJS,
        leave.toJS,
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> updateSelfTeamMemberInfo(
    String teamId,
    NIMTeamType teamType,
    NIMUpdateSelfMemberInfoParams memberInfoParams,
  ) async {
    try {
      await _callJSAsync('updateSelfTeamMemberInfo', [
        teamId.toJS,
        teamType.index.toJS,
        dartMapToJsObject(memberInfoParams.toJson()),
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> updateTeamMemberNick(
    String teamId,
    NIMTeamType teamType,
    String accountId,
    String teamNick,
  ) async {
    try {
      await _callJSAsync('updateTeamMemberNick', [
        teamId.toJS,
        teamType.index.toJS,
        accountId.toJS,
        teamNick.toJS,
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> setTeamChatBannedMode(
    String teamId,
    NIMTeamType teamType,
    NIMTeamChatBannedMode chatBannedMode,
  ) async {
    try {
      await _callJSAsync('setTeamChatBannedMode', [
        teamId.toJS,
        teamType.index.toJS,
        nimTeamChatBannedModeToValue(chatBannedMode).toJS,
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<void>> setTeamMemberChatBannedStatus(
    String teamId,
    NIMTeamType teamType,
    String accountId,
    bool chatBanned,
  ) async {
    try {
      await _callJSAsync('setTeamMemberChatBannedStatus', [
        teamId.toJS,
        teamType.index.toJS,
        accountId.toJS,
        chatBanned.toJS,
      ]);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMTeam>>> getJoinedTeamList(
    List<NIMTeamType> teamTypes,
  ) async {
    try {
      final jsTypes = teamTypes.map((t) => t.index).toList().jsify();
      final result = await _callJSAsync('getJoinedTeamList', [
        jsTypes as JSAny,
      ]);
      if (result != null && result.isA<JSArray>()) {
        final list = jsArrayToMapList(result as JSArray);
        final teams = list.map((m) => NIMTeam.fromJson(m)).toList();
        return NIMResult<List<NIMTeam>>.fromMap(
          {
            'code': 0,
            'data': {'teamList': teams.map((t) => t.toJson()).toList()},
          },
          convert: (d) {
            final l = (d as Map<String, dynamic>)['teamList'] as List;
            return l
                .map(
                  (e) => NIMTeam.fromJson((e as Map).cast<String, dynamic>()),
                )
                .toList();
          },
        );
      }
      return NIMResult<List<NIMTeam>>.fromMap({
        'code': 0,
        'data': {'teamList': []},
      }, convert: (_) => <NIMTeam>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMTeam>>(e);
    }
  }

  @override
  Future<NIMResult<int>> getJoinedTeamCount(List<NIMTeamType> teamTypes) async {
    final service = _jsService;
    if (service == null)
      return NIMResult<int>.fromMap({
        'code': -1,
        'errorDetails': 'NIM SDK not initialized',
      });
    try {
      final jsTypes = teamTypes.map((t) => t.index).toList().jsify();
      final method =
          service.getProperty('getJoinedTeamCount'.toJS) as JSFunction;
      final result = method.callAsFunction(service, jsTypes);
      final count = result != null && result.isA<JSNumber>()
          ? (result as JSNumber).toDartInt
          : 0;
      return NIMResult<int>(0, count, null);
    } catch (e) {
      return convertJSErrorToNIMResult<int>(e);
    }
  }

  @override
  Future<NIMResult<NIMTeamMemberListResult>> getTeamMemberList(
    String teamId,
    NIMTeamType teamType,
    NIMTeamMemberQueryOption queryOption,
  ) async {
    try {
      final result = await _callJSAsync('getTeamMemberList', [
        teamId.toJS,
        teamType.index.toJS,
        dartMapToJsObject(queryOption.toJson()),
      ]);
      if (result != null && result.isA<JSObject>()) {
        return NIMResult<NIMTeamMemberListResult>.fromMap(
          {'code': 0, 'data': jsObjectToMap(result as JSObject)},
          convert: (d) =>
              NIMTeamMemberListResult.fromJson(d as Map<String, dynamic>),
        );
      }
      return NIMResult<NIMTeamMemberListResult>.fromMap({
        'code': -1,
        'errorDetails': 'getTeamMemberList returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMTeamMemberListResult>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMTeamMember>>> getTeamMemberListByIds(
    String teamId,
    NIMTeamType teamType,
    List<String> accountIds,
  ) async {
    try {
      final result = await _callJSAsync('getTeamMemberListByIds', [
        teamId.toJS,
        teamType.index.toJS,
        accountIds.jsify() as JSAny,
      ]);
      if (result != null && result.isA<JSArray>()) {
        final list = jsArrayToMapList(result as JSArray);
        final members = list.map((m) => NIMTeamMember.fromJson(m)).toList();
        return NIMResult<List<NIMTeamMember>>.fromMap(
          {
            'code': 0,
            'data': {'memberList': members.map((m) => m.toJson()).toList()},
          },
          convert: (d) {
            final l = (d as Map<String, dynamic>)['memberList'] as List;
            return l
                .map(
                  (e) => NIMTeamMember.fromJson(
                    (e as Map).cast<String, dynamic>(),
                  ),
                )
                .toList();
          },
        );
      }
      return NIMResult<List<NIMTeamMember>>.fromMap({
        'code': 0,
        'data': {'memberList': []},
      }, convert: (_) => <NIMTeamMember>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMTeamMember>>(e);
    }
  }

  @override
  Future<NIMResult<Map<String, String>>> getTeamMemberInvitor(
    String teamId,
    NIMTeamType teamType,
    List<String> accountIds,
  ) async {
    try {
      final result = await _callJSAsync('getTeamMemberInvitor', [
        teamId.toJS,
        teamType.index.toJS,
        accountIds.jsify() as JSAny,
      ]);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject);
        final invitorMap = map.map((k, v) => MapEntry(k, v?.toString() ?? ''));
        return NIMResult<Map<String, String>>.fromMap({
          'code': 0,
          'data': invitorMap,
        }, convert: (d) => (d as Map).cast<String, String>());
      }
      return NIMResult<Map<String, String>>.fromMap({
        'code': 0,
        'data': {},
      }, convert: (d) => <String, String>{});
    } catch (e) {
      return convertJSErrorToNIMResult<Map<String, String>>(e);
    }
  }

  @override
  Future<NIMResult<NIMTeamJoinActionInfoResult>> getTeamJoinActionInfoList(
    NIMTeamJoinActionInfoQueryOption queryOption,
  ) async {
    try {
      final result = await _callJSAsync('getTeamJoinActionInfoList', [
        dartMapToJsObject(queryOption.toJson()),
      ]);
      if (result != null && result.isA<JSObject>()) {
        final map = jsObjectToMap(result as JSObject);
        // Web SDK 在 serverId 无值时返回空字符串 ""，而 Dart 模型期望 int?
        // 若不处理，(json['serverId'] as num?)?.toInt() 会抛出 TypeError
        // 需要在解析前将 infos 列表中每个 info 的 serverId 空字符串转为 null
        final infos = map['infos'];
        if (infos is List) {
          for (final info in infos) {
            if (info is Map<String, dynamic>) {
              if (info['serverId'] is String &&
                  (info['serverId'] as String).isEmpty) {
                info['serverId'] = null;
              }
            }
          }
        }
        return NIMResult<NIMTeamJoinActionInfoResult>.fromMap(
          {'code': 0, 'data': map},
          convert: (d) => NIMTeamJoinActionInfoResult.fromJson(
            d as Map<String, dynamic>,
          ),
        );
      }
      return NIMResult<NIMTeamJoinActionInfoResult>.fromMap({
        'code': -1,
        'errorDetails': 'getTeamJoinActionInfoList returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMTeamJoinActionInfoResult>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMTeam>>> searchTeamByKeyword(String keyword) async {
    try {
      final result = await _callJSAsync('searchTeamByKeyword', [keyword.toJS]);
      if (result != null && result.isA<JSArray>()) {
        final list = jsArrayToMapList(result as JSArray);
        final teams = list.map((m) => NIMTeam.fromJson(m)).toList();
        return NIMResult<List<NIMTeam>>.fromMap(
          {
            'code': 0,
            'data': {'teamList': teams.map((t) => t.toJson()).toList()},
          },
          convert: (d) {
            final l = (d as Map<String, dynamic>)['teamList'] as List;
            return l
                .map(
                  (e) => NIMTeam.fromJson((e as Map).cast<String, dynamic>()),
                )
                .toList();
          },
        );
      }
      return NIMResult<List<NIMTeam>>.fromMap({
        'code': 0,
        'data': {'teamList': []},
      }, convert: (_) => <NIMTeam>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMTeam>>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMTeam>>> getOwnerTeamList(
      {List<NIMTeamType>? teamTypes}) async {
    try {
      final jsTypes = (teamTypes ?? []).map((t) => t.index).toList().jsify();
      final result = await _callJSAsync('getOwnerTeamList', [
        jsTypes as JSAny,
      ]);
      if (result != null && result.isA<JSArray>()) {
        final list = jsArrayToMapList(result as JSArray);
        final teams = list.map((m) => NIMTeam.fromJson(m)).toList();
        return NIMResult<List<NIMTeam>>.fromMap(
          {
            'code': 0,
            'data': {'teamList': teams.map((t) => t.toJson()).toList()},
          },
          convert: (d) {
            final l = (d as Map<String, dynamic>)['teamList'] as List;
            return l
                .map(
                  (e) => NIMTeam.fromJson((e as Map).cast<String, dynamic>()),
                )
                .toList();
          },
        );
      }
      return NIMResult<List<NIMTeam>>.fromMap({
        'code': 0,
        'data': {'teamList': []},
      }, convert: (_) => <NIMTeam>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMTeam>>(e);
    }
  }

  @override
  Future<NIMResult<List<NIMTeam>>> getManagerTeamList(
      {List<NIMTeamType>? teamTypes}) async {
    try {
      final jsTypes = (teamTypes ?? []).map((t) => t.index).toList().jsify();
      final result = await _callJSAsync('getManagerTeamList', [
        jsTypes as JSAny,
      ]);
      if (result != null && result.isA<JSArray>()) {
        final list = jsArrayToMapList(result as JSArray);
        final teams = list.map((m) => NIMTeam.fromJson(m)).toList();
        return NIMResult<List<NIMTeam>>.fromMap(
          {
            'code': 0,
            'data': {'teamList': teams.map((t) => t.toJson()).toList()},
          },
          convert: (d) {
            final l = (d as Map<String, dynamic>)['teamList'] as List;
            return l
                .map(
                  (e) => NIMTeam.fromJson((e as Map).cast<String, dynamic>()),
                )
                .toList();
          },
        );
      }
      return NIMResult<List<NIMTeam>>.fromMap({
        'code': 0,
        'data': {'teamList': []},
      }, convert: (_) => <NIMTeam>[]);
    } catch (e) {
      return convertJSErrorToNIMResult<List<NIMTeam>>(e);
    }
  }

  @override
  Future<NIMResult<NIMTeam>> getTeamInfoFromCloud(
      {required String teamId, required NIMTeamType teamType}) async {
    try {
      final result = await _callJSAsync('getTeamInfoFromCloud', [
        teamId.toJS,
        teamType.index.toJS,
      ]);
      if (result != null && result.isA<JSObject>()) {
        return NIMResult<NIMTeam>.fromMap({
          'code': 0,
          'data': jsObjectToMap(result as JSObject),
        }, convert: (d) => NIMTeam.fromJson(d as Map<String, dynamic>));
      }
      return NIMResult<NIMTeam>.fromMap({
        'code': -1,
        'errorDetails': 'getTeamInfoFromCloud returned null',
      });
    } catch (e) {
      return convertJSErrorToNIMResult<NIMTeam>(e);
    }
  }

  @override
  Future<NIMResult<NIMTeamMemberListResult>> searchTeamMembers(
    NIMTeamMemberSearchOption searchOption,
  ) async {
    return NIMResult<NIMTeamMemberListResult>.fromMap({
      'code': 199404,
      'errorDetails': 'searchTeamMembers is not supported on Web',
    });
  }

  @override
  Future<NIMResult<Map<NIMTeamRefer, List<NIMTeamMember>>>> searchTeamMembersEx(
    NIMSearchTeamMemberParams params,
  ) async {
    return NIMResult<Map<NIMTeamRefer, List<NIMTeamMember>>>.fromMap({
      'code': 199404,
      'errorDetails': 'searchTeamMembersEx is not supported on Web',
    });
  }

  @override
  Future<NIMResult<void>> clearAllTeamJoinActionInfoEx(
    NIMTeamClearJoinActionInfoOption? option,
  ) async {
    try {
      final args = option != null
          ? <JSAny?>[dartMapToJsObject(option.toJson())]
          : <JSAny?>[];
      await _callJSAsync('clearAllTeamJoinActionInfoEx', args);
      return NIMResult<void>.fromMap({'code': 0});
    } catch (e) {
      return convertJSErrorToNIMResult<void>(e);
    }
  }
}
