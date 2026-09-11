import {
  V2NIMTeamJoinActionInfo,
  V2NIMTeamJoinActionStatus,
  V2NIMTeamJoinActionType,
  V2NIMTeamType
} from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2TeamJoinActionInfo(argumentsMap: Map<string, Any>): V2NIMTeamJoinActionInfo {
  let teamJoinActionInfo: V2NIMTeamJoinActionInfo = {
    actionType: V2NIMTeamJoinActionType.V2NIM_TEAM_JOIN_ACTION_TYPE_APPLICATION,
    teamId: "",
    teamType: V2NIMTeamType.V2NIM_TEAM_TYPE_NORMAL,
    operatorAccountId: "",
    postscript: undefined,
    timestamp: 0,
    actionStatus: V2NIMTeamJoinActionStatus.V2NIM_TEAM_JOIN_ACTION_STATUS_INIT,
    serverExtension: undefined,
    read: false
  };

  if (argumentsMap.get("actionType") !== undefined && argumentsMap.get("actionType") !== null) {
    teamJoinActionInfo.actionType = argumentsMap.get("actionType") as V2NIMTeamJoinActionType;
  }

  if (argumentsMap.get("teamId") !== undefined && argumentsMap.get("teamId") !== null) {
    teamJoinActionInfo.teamId = argumentsMap.get("teamId") as string;
  }

  if (argumentsMap.get("teamType") !== undefined && argumentsMap.get("teamType") !== null) {
    teamJoinActionInfo.teamType = argumentsMap.get("teamType") as V2NIMTeamType;
  }

  if (argumentsMap.get("operatorAccountId") !== undefined && argumentsMap.get("operatorAccountId") !== null) {
    teamJoinActionInfo.operatorAccountId = argumentsMap.get("operatorAccountId") as string;
  }

  if (argumentsMap.get("postscript") !== undefined && argumentsMap.get("postscript") !== null) {
    teamJoinActionInfo.postscript = argumentsMap.get("postscript") as string;
  }

  if (argumentsMap.get("timestamp") !== undefined && argumentsMap.get("timestamp") !== null) {
    teamJoinActionInfo.timestamp = argumentsMap.get("timestamp") as number;
  }

  if (argumentsMap.get("actionStatus") !== undefined && argumentsMap.get("actionStatus") !== null) {
    teamJoinActionInfo.actionStatus = argumentsMap.get("actionStatus") as V2NIMTeamJoinActionStatus;
  }

  if (argumentsMap.get("serverExtension") !== undefined && argumentsMap.get("serverExtension") !== null) {
    teamJoinActionInfo.serverExtension = argumentsMap.get("serverExtension") as string;
  }

  if (argumentsMap.get("read") !== undefined && argumentsMap.get("read") !== null) {
    teamJoinActionInfo.read = argumentsMap.get("read") as boolean;
  }

  return teamJoinActionInfo;
}