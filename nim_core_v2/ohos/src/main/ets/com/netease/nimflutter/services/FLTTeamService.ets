/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import {
  V2NIMCreateTeamParams,
  V2NIMError,
  V2NIMQueryDirection,
  V2NIMSortOrder,
  V2NIMTeam,
  V2NIMTeamAgreeMode,
  V2NIMTeamChatBannedMode,
  V2NIMTeamInviteMode,
  V2NIMTeamInviteParams,
  V2NIMTeamJoinActionInfo,
  V2NIMTeamJoinActionInfoQueryOption,
  V2NIMTeamJoinActionStatus,
  V2NIMTeamJoinActionType,
  V2NIMTeamJoinMode,
  V2NIMTeamMember,
  V2NIMTeamMemberQueryOption,
  V2NIMTeamMemberRole,
  V2NIMTeamMemberRoleQueryType,
  V2NIMTeamMemberSearchOption,
  V2NIMTeamType,
  V2NIMTeamUpdateExtensionMode,
  V2NIMTeamUpdateInfoMode,
  V2NIMUpdateMemberNickParams,
  V2NIMUpdateSelfMemberInfoParams,
  V2NIMUpdateTeamInfoParams
} from '@nimsdk/base';
import { V2NIMTeamMemberImpl } from '@nimsdk/team/src/main/ets/nim/services/member/V2NIMTeamMemberImpl';
import { V2NIMTeamImpl } from '@nimsdk/team/src/main/ets/nim/services/team/V2NIMTeamImpl';
import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';
import { convertMap2AntispamConfig } from '../model/message/V2NIMAntispamConfig';
import { convertMap2TeamJoinActionInfo } from '../model/team/V2NIMTeamJoinActionInfo';

export class FLTTeamService extends FLTService {
  get serviceName(): string {
    return "TeamService";
  }

  onInitialized(): void {
    // notifyEvent
    Log.d(this.serviceName, "onInitialized");
    this.nim.teamService?.on("onSyncStarted", () => {
      Log.d(this.serviceName, "onSyncStarted")
      this.notifyEvent("onSyncStarted", new Map())
    });
    this.nim.teamService?.on("onSyncFinished", () => {
      Log.d(this.serviceName, "onSyncFinished")
      this.notifyEvent("onSyncFinished", new Map())
    });
    this.nim.teamService?.on("onSyncFailed", (error: V2NIMError) => {
      Log.d(this.serviceName, `onSyncFailed:${error}`)
      let resultMap = new Map<string, Object>();
      resultMap.set("code", error.code);
      resultMap.set("errorDetails", error.desc)
      this.notifyEvent("onSyncFailed", resultMap)
    });
    this.nim.teamService?.on("onTeamCreated", (team: V2NIMTeam) => {
      Log.d(this.serviceName, `onTeamCreated:${team}`)
      this.notifyEvent("onTeamCreated", new Map(Object.entries((team as V2NIMTeamImpl).toJSON())))
    });
    this.nim.teamService?.on("onTeamDismissed", (team: V2NIMTeam) => {
      Log.d(this.serviceName, `onTeamDismissed:${team}`)
      this.notifyEvent("onTeamDismissed", new Map(Object.entries((team as V2NIMTeamImpl).toJSON())))
    });
    this.nim.teamService?.on("onTeamJoined", (team: V2NIMTeam) => {
      Log.d(this.serviceName, `onTeamJoined:${team}`)
      this.notifyEvent("onTeamJoined", new Map(Object.entries((team as V2NIMTeamImpl).toJSON())))
    });
    this.nim.teamService?.on("onTeamLeft", (team: V2NIMTeam, isKicked: boolean) => {
      Log.d(this.serviceName, `onTeamLeft:${team} isKicked:${isKicked}`)
      this.notifyEvent("onTeamLeft",
        new Map().set("team", (team as V2NIMTeamImpl).toJSON()).set("isKicked", isKicked))
    });
    this.nim.teamService?.on("onTeamInfoUpdated", (team: V2NIMTeam) => {
      Log.d(this.serviceName, `onTeamInfoUpdated:${team}`)
      this.notifyEvent("onTeamInfoUpdated", new Map(Object.entries((team as V2NIMTeamImpl).toJSON())))
    });
    this.nim.teamService?.on("onTeamMemberJoined", (teamMembers: V2NIMTeamMember[]) => {
      Log.d(this.serviceName, `onTeamMemberJoined, teamMembers:${teamMembers}`)
      this.notifyEvent("onTeamMemberJoined", new Map<string, Any>().set(
        "memberList", teamMembers.map(teamMember => (teamMember as V2NIMTeamMemberImpl).toJSON())
      )
      )
    });
    this.nim.teamService?.on("onTeamMemberKicked", (operateAccountId: string, teamMembers: V2NIMTeamMember[]) => {
      Log.d(this.serviceName, `onTeamMemberKicked, operateAccountId:${operateAccountId} teamMembers:${teamMembers}`)
      this.notifyEvent("onTeamMemberKicked", new Map<string, Any>().set(
        "memberList", teamMembers.map(teamMember => (teamMember as V2NIMTeamMemberImpl).toJSON())
      ).set("operatorAccountId", operateAccountId)
      )
    });
    this.nim.teamService?.on("onTeamMemberLeft", (teamMembers: V2NIMTeamMember[]) => {
      Log.d(this.serviceName, `onTeamMemberLeft, teamMembers:${teamMembers}`)
      this.notifyEvent("onTeamMemberLeft", new Map<string, Any>().set(
        "memberList", teamMembers.map(teamMember => (teamMember as V2NIMTeamMemberImpl).toJSON())
      )
      )
    });
    this.nim.teamService?.on("onTeamMemberInfoUpdated", (teamMembers: V2NIMTeamMember[]) => {
      Log.d(this.serviceName, `onTeamMemberInfoUpdated, teamMembers:${teamMembers}`)
      this.notifyEvent("onTeamMemberInfoUpdated", new Map<string, Any>().set(
        "memberList", teamMembers.map(teamMember => (teamMember as V2NIMTeamMemberImpl).toJSON())
      )
      )
    });
    this.nim.teamService?.on("onReceiveTeamJoinActionInfo", (joinActionInfo: V2NIMTeamJoinActionInfo) => {
      Log.d(this.serviceName, `onReceiveTeamJoinActionInfo, joinActionInfo:${joinActionInfo}`)
      this.notifyEvent("onReceiveTeamJoinActionInfo", new Map<string, Any>(Object.entries(joinActionInfo)))
    });
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    switch (method) {
      case "createTeam":
        this.createTeam(args, result);
        break;
      case "updateTeamInfo":
        this.updateTeamInfo(args, result);
        break;
      case "leaveTeam":
        this.leaveTeam(args, result);
        break;
      case "getTeamInfo":
        this.getTeamInfo(args, result);
        break;
      case "getJoinedTeamList":
        this.getJoinedTeamList(args, result);
        break;
      case "getJoinedTeamCount":
        this.getJoinedTeamCount(args, result);
        break;
      case "getTeamInfoByIds":
        this.getTeamInfoByIds(args, result);
        break;
      case "dismissTeam":
        this.dismissTeam(args, result);
        break;
      case "inviteMember":
        this.inviteMember(args, result);
        break;
      case "acceptInvitation":
        this.acceptInvitation(args, result);
        break;
      case "rejectInvitation":
        this.rejectInvitation(args, result);
        break;
      case "kickMember":
        this.kickMember(args, result);
        break;
      case "applyJoinTeam":
        this.applyJoinTeam(args, result);
        break;
      case "acceptJoinApplication":
        this.acceptJoinApplication(args, result);
        break;
      case "rejectJoinApplication":
        this.rejectJoinApplication(args, result);
        break;
      case "updateTeamMemberRole":
        this.updateTeamMemberRole(args, result);
        break;
      case "transferTeamOwner":
        this.transferTeamOwner(args, result);
        break;
      case "updateSelfTeamMemberInfo":
        this.updateSelfTeamMemberInfo(args, result);
        break;
      case "updateTeamMemberNick":
        this.updateTeamMemberNick(args, result);
        break;
      case "updateTeamMemberNickEx":
        this.updateTeamMemberNickEx(args, result);
        break;
      case "setTeamChatBannedMode":
        this.setTeamChatBannedMode(args, result);
        break;
      case "setTeamMemberChatBannedStatus":
        this.setTeamMemberChatBannedStatus(args, result);
        break;
      case "getTeamMemberList":
        this.getTeamMemberList(args, result);
        break;
      case "getTeamMemberListByIds":
        this.getTeamMemberListByIds(args, result);
        break;
      case "getTeamMemberInvitor":
        this.getTeamMemberInvitor(args, result);
        break;
      case "getTeamJoinActionInfoList":
        this.getTeamJoinActionInfoList(args, result);
        break;
      case "searchTeamByKeyword":
        this.searchTeamByKeyword(args, result);
        break;
      case "searchTeamMembers":
        this.searchTeamMembers(args, result);
        break;
      case "addTeamMembersFollow":
        this.addTeamMembersFollow(args, result);
        break;
      case "removeTeamMembersFollow":
        this.removeTeamMembersFollow(args, result);
        break;
      case "clearAllTeamJoinActionInfo":
        this.clearAllTeamJoinActionInfo(args, result);
        break;
      case "deleteTeamJoinActionInfo":
        this.deleteTeamJoinActionInfo(args, result);
        break;
      case "inviteMemberEx":
        this.inviteMemberEx(args, result);
        break;
      case "getJoinedTeamMembers":
        this.getJoinedTeamMembers(args, result);
        break;
      case "setTeamJoinActionInfoRead":
        this.setTeamJoinActionInfoRead(args, result);
        break;
      case "getTeamJoinActionInfoUnreadCount":
        this.getTeamJoinActionInfoUnreadCount(args, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private createTeam(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "createTeam")

    let createTeamParams: V2NIMCreateTeamParams = {
      name: "",
      teamType: V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL,
      memberLimit: undefined,
      intro: undefined,
      announcement: undefined,
      avatar: undefined,
      serverExtension: undefined,
      joinMode: undefined,
      agreeMode: undefined,
      inviteMode: undefined,
      updateInfoMode: undefined,
      updateExtensionMode: undefined,
      chatBannedMode: undefined
    }

    let createTeamParamsMap: Map<String, Any> =
      argument.get("createTeamParams") ? argument.get("createTeamParams") as Map<String, Any> : new Map<String, Any>()
    if (createTeamParamsMap.get("name") !== undefined && createTeamParamsMap.get("name") !== null) {
      createTeamParams.name = createTeamParamsMap.get("name") as string;
    }
    if (createTeamParamsMap.get("teamType") !== undefined && createTeamParamsMap.get("teamType") !== null) {
      createTeamParams.teamType = createTeamParamsMap.get("teamType") as V2NIMTeamType;
    }
    if (createTeamParamsMap.get("memberLimit") !== undefined &&
      createTeamParamsMap.get("memberLimit") !== null) {
      createTeamParams.memberLimit = createTeamParamsMap.get("memberLimit") as number;
    }
    if (createTeamParamsMap.get("intro") !== undefined && createTeamParamsMap.get("intro") !== null) {
      createTeamParams.intro = createTeamParamsMap.get("intro") as string;
    }
    if (createTeamParamsMap.get("announcement") !== undefined &&
      createTeamParamsMap.get("announcement") !== null) {
      createTeamParams.announcement = createTeamParamsMap.get("announcement") as string;
    }
    if (createTeamParamsMap.get("avatar") !== undefined && createTeamParamsMap.get("avatar") !== null) {
      createTeamParams.avatar = createTeamParamsMap.get("avatar") as string;
    }
    if (createTeamParamsMap.get("serverExtension") !== undefined &&
      createTeamParamsMap.get("serverExtension") !== null) {
      createTeamParams.serverExtension = createTeamParamsMap.get("serverExtension") as string;
    }
    if (createTeamParamsMap.get("joinMode") !== undefined && createTeamParamsMap.get("joinMode") !== null) {
      createTeamParams.joinMode = createTeamParamsMap.get("joinMode") as V2NIMTeamJoinMode;
    }
    if (createTeamParamsMap.get("agreeMode") !== undefined && createTeamParamsMap.get("agreeMode") !== null) {
      createTeamParams.agreeMode = createTeamParamsMap.get("agreeMode") as V2NIMTeamAgreeMode;
    }
    if (createTeamParamsMap.get("inviteMode") !== undefined && createTeamParamsMap.get("inviteMode") !== null) {
      createTeamParams.inviteMode = createTeamParamsMap.get("inviteMode") as V2NIMTeamInviteMode;
    }
    if (createTeamParamsMap.get("updateInfoMode") !== undefined &&
      createTeamParamsMap.get("updateInfoMode") !== null) {
      createTeamParams.updateInfoMode = createTeamParamsMap.get("updateInfoMode") as V2NIMTeamUpdateInfoMode;
    }
    if (createTeamParamsMap.get("updateExtensionMode") !== undefined &&
      createTeamParamsMap.get("updateExtensionMode") !== null) {
      createTeamParams.updateExtensionMode =
        createTeamParamsMap.get("updateExtensionMode") as V2NIMTeamUpdateExtensionMode;
    }
    if (createTeamParamsMap.get("chatBannedMode") !== undefined &&
      createTeamParamsMap.get("chatBannedMode") !== null) {
      createTeamParams.chatBannedMode =
        createTeamParamsMap.get("chatBannedMode") as V2NIMTeamChatBannedMode;
    }

    let inviteeAccountIds =
      argument.get("inviteeAccountIds") ? argument.get("inviteeAccountIds") as string[] : undefined;
    let postscript = argument.get("postscript") ? argument.get("postscript") as string : undefined;

    let antispamConfig =
      argument.get("antispamConfig") ? convertMap2AntispamConfig(argument.get("antispamConfig") as Map<string, Any>) :
        undefined

    this.nim.teamService?.createTeam(createTeamParams, inviteeAccountIds, postscript,
      antispamConfig).then((createTeamResult) => {
      this.onSuccess(result, {
        "team": (createTeamResult.team as V2NIMTeamImpl).toJSON(),
        "failedList": createTeamResult.failedList
      })
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private updateTeamInfo(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "updateTeamInfo")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType =
      argument.get("teamType") !== null && argument.get("teamType") !== undefined ? argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;

    let updateTeamInfoParams: V2NIMUpdateTeamInfoParams = {
      name: undefined,
      memberLimit: undefined,
      intro: undefined,
      announcement: undefined,
      avatar: undefined,
      serverExtension: undefined,
      joinMode: undefined,
      agreeMode: undefined,
      inviteMode: undefined,
      updateInfoMode: undefined,
      updateExtensionMode: undefined,
    }

    let updateTeamInfoParamsMap: Map<String, Any> =
      argument.get("updateTeamInfoParams") ? argument.get("updateTeamInfoParams") as Map<String, Any> :
      new Map<String, Any>()
    if (updateTeamInfoParamsMap.get("name") !== undefined && updateTeamInfoParamsMap.get("name") !== null) {
      updateTeamInfoParams.name = updateTeamInfoParamsMap.get("name") as string;
    }
    if (updateTeamInfoParamsMap.get("memberLimit") !== undefined &&
      updateTeamInfoParamsMap.get("memberLimit") !== null) {
      updateTeamInfoParams.memberLimit = updateTeamInfoParamsMap.get("memberLimit") as number;
    }
    if (updateTeamInfoParamsMap.get("intro") !== undefined && updateTeamInfoParamsMap.get("intro") !== null) {
      updateTeamInfoParams.intro = updateTeamInfoParamsMap.get("intro") as string;
    }
    if (updateTeamInfoParamsMap.get("announcement") !== undefined &&
      updateTeamInfoParamsMap.get("announcement") !== null) {
      updateTeamInfoParams.announcement = updateTeamInfoParamsMap.get("announcement") as string;
    }
    if (updateTeamInfoParamsMap.get("avatar") !== undefined && updateTeamInfoParamsMap.get("avatar") !== null) {
      updateTeamInfoParams.avatar = updateTeamInfoParamsMap.get("avatar") as string;
    }
    if (updateTeamInfoParamsMap.get("serverExtension") !== undefined &&
      updateTeamInfoParamsMap.get("serverExtension") !== null) {
      updateTeamInfoParams.serverExtension = updateTeamInfoParamsMap.get("serverExtension") as string;
    }
    if (updateTeamInfoParamsMap.get("joinMode") !== undefined && updateTeamInfoParamsMap.get("joinMode") !== null) {
      updateTeamInfoParams.joinMode = updateTeamInfoParamsMap.get("joinMode") as V2NIMTeamJoinMode;
    }
    if (updateTeamInfoParamsMap.get("agreeMode") !== undefined && updateTeamInfoParamsMap.get("agreeMode") !== null) {
      updateTeamInfoParams.agreeMode = updateTeamInfoParamsMap.get("agreeMode") as V2NIMTeamAgreeMode;
    }
    if (updateTeamInfoParamsMap.get("inviteMode") !== undefined && updateTeamInfoParamsMap.get("inviteMode") !== null) {
      updateTeamInfoParams.inviteMode = updateTeamInfoParamsMap.get("inviteMode") as V2NIMTeamInviteMode;
    }
    if (updateTeamInfoParamsMap.get("updateInfoMode") !== undefined &&
      updateTeamInfoParamsMap.get("updateInfoMode") !== null) {
      updateTeamInfoParams.updateInfoMode = updateTeamInfoParamsMap.get("updateInfoMode") as V2NIMTeamUpdateInfoMode;
    }
    if (updateTeamInfoParamsMap.get("updateExtensionMode") !== undefined &&
      updateTeamInfoParamsMap.get("updateExtensionMode") !== null) {
      updateTeamInfoParams.updateExtensionMode =
        updateTeamInfoParamsMap.get("updateExtensionMode") as V2NIMTeamUpdateExtensionMode;
    }


    let antispamConfig =
      argument.get("antispamConfig") ? convertMap2AntispamConfig(argument.get("antispamConfig") as Map<string, Any>) :
        undefined

    this.nim.teamService?.updateTeamInfo(teamId, teamType, updateTeamInfoParams, antispamConfig).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private leaveTeam(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "leaveTeam")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType = argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
        argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;

    this.nim.teamService?.leaveTeam(teamId, teamType).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getTeamInfo(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getTeamInfo")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType = argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
        argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;

    this.nim.teamService?.getTeamInfo(teamId, teamType).then((team) => {
      this.onSuccess(result, (team as V2NIMTeamImpl).toJSON())
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getJoinedTeamList(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getJoinedTeamList")

    let teamTypes = argument.get("teamTypes") ? argument.get("teamTypes") as V2NIMTeamType[] : undefined;

    this.nim.teamService?.getJoinedTeamList(teamTypes).then((teams) => {
      this.onSuccess(result,
        new Map<string, Any>().set("teamList", teams.map(team => (team as V2NIMTeamImpl).toJSON())))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getJoinedTeamCount(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getJoinedTeamCount")

    let teamTypes = argument.get("teamTypes") ? argument.get("teamTypes") as V2NIMTeamType[] : undefined;

    this.nim.teamService?.getJoinedTeamCount(teamTypes).then((count) => {
      this.onSuccess(result, count)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getTeamInfoByIds(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getTeamInfoByIds")

    let teamIds = argument.get("teamIds") ? argument.get("teamIds") as string[] : [];
    let teamType = argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
        argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;

    this.nim.teamService?.getTeamInfoByIds(teamIds, teamType).then((teams) => {
      this.onSuccess(result,
        new Map<string, Any>().set("teamList", teams.map(team => (team as V2NIMTeamImpl).toJSON())))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private dismissTeam(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "dismissTeam")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType = argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
      argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;

    this.nim.teamService?.dismissTeam(teamId, teamType).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private inviteMember(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "inviteMember")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType = argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
        argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;
    let inviteeAccountIds = argument.get("inviteeAccountIds") ? argument.get("inviteeAccountIds") as string[] : [];
    let postscript = argument.get("postscript") ? argument.get("postscript") as string : undefined;

    this.nim.teamService?.inviteMember(teamId, teamType, inviteeAccountIds, postscript).then((failedList) => {
      this.onSuccess(result, new Map<string, Any>().set("failedList", failedList))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private acceptInvitation(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "acceptInvitation")

    let invitationInfo =
      argument.get("invitationInfo") ? convertMap2TeamJoinActionInfo(argument.get("invitationInfo")) : undefined

    this.nim.teamService?.acceptInvitation(invitationInfo).then((team) => {
      this.onSuccess(result, (team as V2NIMTeamImpl).toJSON())
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private rejectInvitation(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "rejectInvitation")

    let invitationInfo =
      argument.get("invitationInfo") ? convertMap2TeamJoinActionInfo(argument.get("invitationInfo")) : undefined
    let postscript = argument.get("postscript") ? argument.get("postscript") as string : undefined;

    this.nim.teamService?.rejectInvitation(invitationInfo, postscript).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private kickMember(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "kickMember")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType =
      argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
        argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;
    let memberAccountIds = argument.get("memberAccountIds") ? argument.get("memberAccountIds") as string[] : [];

    this.nim.teamService?.kickMember(teamId, teamType, memberAccountIds).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private applyJoinTeam(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "applyJoinTeam")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType = argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
        argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;
    let postscript = argument.get("postscript") ? argument.get("postscript") as string : undefined;

    this.nim.teamService?.applyJoinTeam(teamId, teamType, postscript).then((team) => {
      this.onSuccess(result, (team as V2NIMTeamImpl).toJSON())
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private acceptJoinApplication(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "acceptJoinApplication")

    let applicationInfo = argument.get("joinInfo") ? convertMap2TeamJoinActionInfo(argument.get("joinInfo")) : undefined

    this.nim.teamService?.acceptJoinApplication(applicationInfo).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private rejectJoinApplication(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "rejectJoinApplication")

    let applicationInfo = argument.get("joinInfo") ? convertMap2TeamJoinActionInfo(argument.get("joinInfo")) : undefined
    let postscript = argument.get("postscript") ? argument.get("postscript") as string : undefined;

    this.nim.teamService?.rejectJoinApplication(applicationInfo, postscript).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private updateTeamMemberRole(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "updateTeamMemberRole")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType = argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
        argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;
    let memberAccountIds = argument.get("memberAccountIds") ? argument.get("memberAccountIds") as string[] : [];
    let memberRole = argument.get("memberRole") ? argument.get("memberRole") as V2NIMTeamMemberRole :
    V2NIMTeamMemberRole.V2NIM_TEAM_MEMBER_ROLE_NORMAL;

    this.nim.teamService?.updateTeamMemberRole(teamId, teamType, memberAccountIds, memberRole).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private transferTeamOwner(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "transferTeamOwner")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType =
      argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
        argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;
    let accountId = argument.get("accountId") ? argument.get("accountId") as string : "";
    let leave = argument.get("leave") ? argument.get("leave") as boolean : undefined;

    this.nim.teamService?.transferTeamOwner(teamId, teamType, accountId, leave).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private updateSelfTeamMemberInfo(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "updateSelfTeamMemberInfo")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType =
      argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
        argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;

    let updateSelfMemberInfoParams: V2NIMUpdateSelfMemberInfoParams = {
      teamNick: undefined,
      serverExtension: undefined,
      antispamConfig: undefined
    }

    let updateSelfMemberInfoParamsMap: Map<String, Any> =
      argument.get("memberInfoParams") ? argument.get("memberInfoParams") as Map<String, Any> : new Map<String, Any>()
    if (updateSelfMemberInfoParamsMap.get("teamNick") !== undefined &&
      updateSelfMemberInfoParamsMap.get("teamNick") !== null) {
      updateSelfMemberInfoParams.teamNick = updateSelfMemberInfoParamsMap.get("teamNick") as string;
    }
    if (updateSelfMemberInfoParamsMap.get("serverExtension") !== undefined &&
      updateSelfMemberInfoParamsMap.get("serverExtension") !== null) {
      updateSelfMemberInfoParams.serverExtension = updateSelfMemberInfoParamsMap.get("serverExtension") as string;
    }
    if (updateSelfMemberInfoParamsMap.get("antispamConfig") !== undefined &&
      updateSelfMemberInfoParamsMap.get("antispamConfig") !== null) {
      updateSelfMemberInfoParams.antispamConfig =
        convertMap2AntispamConfig(updateSelfMemberInfoParamsMap.get("antispamConfig") as Map<string, Any>)
    }

    this.nim.teamService?.updateSelfTeamMemberInfo(teamId, teamType, updateSelfMemberInfoParams).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private updateTeamMemberNick(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "updateTeamMemberNick")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType =
      argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
        argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;
    let accountId = argument.get("accountId") ? argument.get("accountId") as string : "";
    let nick = argument.get("teamNick") ? argument.get("teamNick") as string : "";

    this.nim.teamService?.updateTeamMemberNick(teamId, teamType, accountId, nick).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private updateTeamMemberNickEx(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "updateTeamMemberNickEx")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType =
      argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
        argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;

    let nickParams: V2NIMUpdateMemberNickParams = {
      accountId: "",
      teamNick: "",
      antispamConfig: undefined
    }

    let nickParamsMap: Map<String, Any> =
      argument.get("nickParams") ? argument.get("nickParams") as Map<String, Any> : new Map<String, Any>()
    if (nickParamsMap.get("accountId") !== undefined && nickParamsMap.get("accountId") !== null) {
      nickParams.accountId = nickParamsMap.get("accountId") as string;
    }
    if (nickParamsMap.get("teamNick") !== undefined && nickParamsMap.get("teamNick") !== null) {
      nickParams.teamNick = nickParamsMap.get("teamNick") as string;
    }
    if (nickParamsMap.get("antispamConfig") !== undefined && nickParamsMap.get("antispamConfig") !== null) {
      nickParams.antispamConfig = convertMap2AntispamConfig(nickParamsMap.get("antispamConfig") as Map<string, Any>)
    }

    this.nim.teamService?.updateTeamMemberNickEx(teamId, teamType, nickParams).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private setTeamChatBannedMode(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "setTeamChatBannedMode")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType =
      argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
        argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;
    let chatBannedMode = argument.get("chatBannedMode") ? argument.get("chatBannedMode") as V2NIMTeamChatBannedMode :
    V2NIMTeamChatBannedMode.V2NIM_TEAM_CHAT_BANNED_MODE_UNBAN;

    this.nim.teamService?.setTeamChatBannedMode(teamId, teamType, chatBannedMode).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private setTeamMemberChatBannedStatus(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "setTeamMemberChatBannedStatus")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType =
      argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
        argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;
    let accountId = argument.get("accountId") ? argument.get("accountId") as string : "";
    let chatBanned = argument.get("chatBanned") ? argument.get("chatBanned") as boolean : false;

    this.nim.teamService?.setTeamMemberChatBannedStatus(teamId, teamType, accountId, chatBanned).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getTeamMemberList(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getTeamMemberList")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType =
      argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
        argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;

    let queryOption: V2NIMTeamMemberQueryOption = {
      roleQueryType: undefined,
      onlyChatBanned: undefined,
      direction: undefined,
      limit: undefined,
      nextToken: undefined
    }

    let queryOptionMap: Map<String, Any> =
      argument.get("queryOption") ? argument.get("queryOption") as Map<String, Any> : new Map<String, Any>()
    if (queryOptionMap.get("roleQueryType") !== undefined && queryOptionMap.get("roleQueryType") !== null) {
      queryOption.roleQueryType = queryOptionMap.get("roleQueryType") as V2NIMTeamMemberRoleQueryType
    }
    if (queryOptionMap.get("onlyChatBanned") !== undefined && queryOptionMap.get("onlyChatBanned") !== null) {
      queryOption.onlyChatBanned = queryOptionMap.get("onlyChatBanned") as boolean
    }
    if (queryOptionMap.get("direction") !== undefined && queryOptionMap.get("direction") !== null) {
      queryOption.direction = queryOptionMap.get("direction") as V2NIMQueryDirection
    }
    if (queryOptionMap.get("limit") !== undefined && queryOptionMap.get("limit") !== null) {
      queryOption.limit = queryOptionMap.get("limit") as number
    }
    if (queryOptionMap.get("nextToken") !== undefined && queryOptionMap.get("nextToken") !== null) {
      queryOption.nextToken = queryOptionMap.get("nextToken") as string
    }

    this.nim.teamService?.getTeamMemberList(teamId, teamType, queryOption).then((res) => {
      this.onSuccess(result, {
        "finished": res.finished,
        "nextToken": res.nextToken,
        "memberList": res.memberList.map(member => (member as V2NIMTeamMemberImpl).toJSON())
      })
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getTeamMemberListByIds(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getTeamMemberListByIds")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType =
      argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
        argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;
    let accountIds = argument.get("accountIds") ? argument.get("accountIds") as string[] : [];

    this.nim.teamService?.getTeamMemberListByIds(teamId, teamType, accountIds).then((res) => {
      this.onSuccess(result,
        new Map<string, Any>().set("memberList", res.map(member => (member as V2NIMTeamMemberImpl).toJSON())))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getTeamMemberInvitor(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getTeamMemberInvitor")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType = argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
      argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;
    let accountIds = argument.get("accountIds") ? argument.get("accountIds") as string[] : [];

    this.nim.teamService?.getTeamMemberInvitor(teamId, teamType, accountIds).then((res) => {
      this.onSuccess(result, res)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getTeamJoinActionInfoList(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getTeamJoinActionInfoList")

    let queryOption: V2NIMTeamJoinActionInfoQueryOption = {
      types: undefined,
      status: undefined,
      offset: undefined,
      limit: undefined,
    }

    let queryOptionMap: Map<String, Any> =
      argument.get("queryOption") ? argument.get("queryOption") as Map<String, Any> : new Map<String, Any>()
    if (queryOptionMap.get("types") !== undefined && queryOptionMap.get("types") !== null) {
      queryOption.types = queryOptionMap.get("types") as V2NIMTeamJoinActionType[]
    }
    if (queryOptionMap.get("status") !== undefined && queryOptionMap.get("status") !== null) {
      queryOption.status = queryOptionMap.get("status") as V2NIMTeamJoinActionStatus[]
    }
    if (queryOptionMap.get("offset") !== undefined && queryOptionMap.get("offset") !== null) {
      queryOption.offset = queryOptionMap.get("offset") as number
    }
    if (queryOptionMap.get("limit") !== undefined && queryOptionMap.get("limit") !== null) {
      queryOption.limit = queryOptionMap.get("limit") as number
    }

    this.nim.teamService?.getTeamJoinActionInfoList(queryOption).then((res) => {
      this.onSuccess(result, res)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private searchTeamByKeyword(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "searchTeamByKeyword")

    let keyword = argument.get("keyword") ? argument.get("keyword") as string : "";

    this.nim.teamService?.searchTeamByKeyword(keyword).then((teams) => {
      this.onSuccess(result,
        new Map<string, Any>().set("teamList", teams.map(team => (team as V2NIMTeamImpl).toJSON())))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private searchTeamMembers(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "searchTeamMembers")

    let searchOption: V2NIMTeamMemberSearchOption = {
      keyword: "",
      teamType: V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL,
      teamId: undefined,
      nextToken: "",
      order: undefined,
      limit: undefined,
      searchAccountId: undefined,
    }

    let searchOptionMap: Map<String, Any> =
      argument.get("searchOption") ? argument.get("searchOption") as Map<String, Any> : new Map<String, Any>()
    if (searchOptionMap.get("teamId") !== undefined && searchOptionMap.get("teamId") !== null) {
      searchOption.teamId = searchOptionMap.get("teamId") as string
    }
    if (searchOptionMap.get("keyword") !== undefined && searchOptionMap.get("keyword") !== null) {
      searchOption.keyword = searchOptionMap.get("keyword") as string
    }
    if (searchOptionMap.get("nextToken") !== undefined && searchOptionMap.get("nextToken") !== null) {
      searchOption.nextToken = searchOptionMap.get("nextToken") as string
    }
    if (searchOptionMap.get("teamType") !== undefined && searchOptionMap.get("teamType") !== null) {
      searchOption.teamType = searchOptionMap.get("teamType") as V2NIMTeamType
    }
    if (searchOptionMap.get("order") !== undefined && searchOptionMap.get("order") !== null) {
      searchOption.order = searchOptionMap.get("order") as V2NIMSortOrder
    }
    if (searchOptionMap.get("searchAccountId") !== undefined && searchOptionMap.get("searchAccountId") !== null) {
      searchOption.searchAccountId = searchOptionMap.get("searchAccountId") as boolean
    }
    if (searchOptionMap.get("limit") !== undefined && searchOptionMap.get("limit") !== null) {
      searchOption.limit = searchOptionMap.get("limit") as number
    }

    this.nim.teamService?.searchTeamMembers(searchOption).then((res) => {
      this.onSuccess(result, {
        "memberList": res.memberList.map(member => (member as V2NIMTeamMemberImpl).toJSON()),
        "nextToken": res.nextToken,
        "finished": res.finished
      })
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private addTeamMembersFollow(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "addTeamMembersFollow")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType = argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
      argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;
    let accountIds = argument.get("accountIds") ? argument.get("accountIds") as string[] : undefined;

    this.nim.teamService?.addTeamMembersFollow(teamId, teamType, accountIds).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private removeTeamMembersFollow(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "removeTeamMembersFollow")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType = argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
        argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;
    let accountIds = argument.get("accountIds") ? argument.get("accountIds") as string[] : undefined;

    this.nim.teamService?.removeTeamMembersFollow(teamId, teamType, accountIds).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private clearAllTeamJoinActionInfo(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "clearAllTeamJoinActionInfo")

    this.nim.teamService?.clearAllTeamJoinActionInfo().then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private deleteTeamJoinActionInfo(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "deleteTeamJoinActionInfo")

    let application =
      argument.get("application") ? convertMap2TeamJoinActionInfo(argument.get("application")) : undefined

    this.nim.teamService?.deleteTeamJoinActionInfo(application).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private inviteMemberEx(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "inviteMemberEx")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";
    let teamType = argument.get("teamType") !== null && argument.get("teamType") !== undefined ?
      argument.get("teamType") as V2NIMTeamType : V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL;

    let inviteeParams: V2NIMTeamInviteParams = {
      inviteeAccountIds: [],
      postscript: undefined,
      serverExtension: undefined,
    }

    let inviteeParamsMap: Map<String, Any> =
      argument.get("inviteeParams") ? argument.get("inviteeParams") as Map<String, Any> : new Map<String, Any>()
    if (inviteeParamsMap.get("inviteeAccountIds") !== undefined && inviteeParamsMap.get("inviteeAccountIds") !== null) {
      inviteeParams.inviteeAccountIds = inviteeParamsMap.get("inviteeAccountIds") as string[];
    }
    if (inviteeParamsMap.get("postscript") !== undefined && inviteeParamsMap.get("postscript") !== null) {
      inviteeParams.postscript = inviteeParamsMap.get("postscript") as string;
    }
    if (inviteeParamsMap.get("serverExtension") !== undefined && inviteeParamsMap.get("serverExtension") !== null) {
      inviteeParams.serverExtension = inviteeParamsMap.get("serverExtension") as string;
    }

    this.nim.teamService?.inviteMemberEx(teamId, teamType, inviteeParams).then((failedList) => {
      this.onSuccess(result, new Map<string, Any>().set("failedList", failedList))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getJoinedTeamMembers(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getJoinedTeamMembers")

    let teamTypes = argument.get("teamTypes") ? argument.get("teamTypes") as V2NIMTeamType[] : [];

    this.nim.teamService?.getJoinedTeamMembers(teamTypes).then((teamMembers) => {
      this.onSuccess(result,
        new Map<string, Any>().set("teamMembers", teamMembers.map(member => (member as V2NIMTeamMemberImpl).toJSON())))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private setTeamJoinActionInfoRead(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "setTeamJoinActionInfoRead")

    let applicationInfo =
      argument.get("applicationInfo") ? convertMap2TeamJoinActionInfo(argument.get("applicationInfo")) : undefined

    this.nim.teamService?.setTeamJoinActionInfoRead(applicationInfo).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getTeamJoinActionInfoUnreadCount(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getTeamJoinActionInfoUnreadCount")

    this.nim.teamService?.getTeamJoinActionInfoUnreadCount().then((count) => {
      this.onSuccess(result, count)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }
}