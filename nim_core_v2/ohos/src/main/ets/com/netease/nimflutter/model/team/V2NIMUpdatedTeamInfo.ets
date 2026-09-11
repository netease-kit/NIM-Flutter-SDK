import {
  V2NIMTeamAgreeMode,
  V2NIMTeamChatBannedMode,
  V2NIMTeamInviteMode,
  V2NIMTeamJoinMode,
  V2NIMTeamUpdateExtensionMode,
  V2NIMTeamUpdateInfoMode,
  V2NIMUpdatedTeamInfo
} from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2UpdatedTeamInfo(argumentsMap: Map<string, Any>): V2NIMUpdatedTeamInfo {
  let updatedTeamInfo: V2NIMUpdatedTeamInfo = {
    name: undefined,
    memberLimit: undefined,
    intro: undefined,
    announcement: undefined,
    avatar: undefined,
    serverExtension: undefined,
    joinMode: V2NIMTeamJoinMode.V2NIM_TEAM_JOIN_MODE_FREE,
    agreeMode: V2NIMTeamAgreeMode.V2NIM_TEAM_AGREE_MODE_AUTH,
    inviteMode: V2NIMTeamInviteMode.V2NIM_TEAM_INVITE_MODE_MANAGER,
    updateInfoMode: V2NIMTeamUpdateInfoMode.V2NIM_TEAM_UPDATE_INFO_MODE_MANAGER,
    updateExtensionMode: V2NIMTeamUpdateExtensionMode.V2NIM_TEAM_UPDATE_EXTENSION_MODE_MANAGER,
    chatBannedMode: V2NIMTeamChatBannedMode.V2NIM_TEAM_CHAT_BANNED_MODE_UNBAN,
    customerExtension: undefined
  };

  if (argumentsMap.get("name") !== undefined && argumentsMap.get("name") !== null) {
    updatedTeamInfo.name = argumentsMap.get("name") as string;
  }

  if (argumentsMap.get("memberLimit") !== undefined && argumentsMap.get("memberLimit") !== null) {
    updatedTeamInfo.memberLimit = argumentsMap.get("memberLimit") as number;
  }

  if (argumentsMap.get("intro") !== undefined && argumentsMap.get("intro") !== null) {
    updatedTeamInfo.intro = argumentsMap.get("intro") as string;
  }

  if (argumentsMap.get("announcement") !== undefined && argumentsMap.get("announcement") !== null) {
    updatedTeamInfo.announcement = argumentsMap.get("announcement") as string;
  }

  if (argumentsMap.get("avatar") !== undefined && argumentsMap.get("avatar") !== null) {
    updatedTeamInfo.avatar = argumentsMap.get("avatar") as string;
  }

  if (argumentsMap.get("serverExtension") !== undefined && argumentsMap.get("serverExtension") !== null) {
    updatedTeamInfo.serverExtension = argumentsMap.get("serverExtension") as string;
  }

  if (argumentsMap.get("joinMode") !== undefined && argumentsMap.get("joinMode") !== null) {
    updatedTeamInfo.joinMode = argumentsMap.get("joinMode") as V2NIMTeamJoinMode;
  }

  if (argumentsMap.get("agreeMode") !== undefined && argumentsMap.get("agreeMode") !== null) {
    updatedTeamInfo.agreeMode = argumentsMap.get("agreeMode") as V2NIMTeamAgreeMode;
  }

  if (argumentsMap.get("inviteMode") !== undefined && argumentsMap.get("inviteMode") !== null) {
    updatedTeamInfo.inviteMode = argumentsMap.get("inviteMode") as V2NIMTeamInviteMode;
  }

  if (argumentsMap.get("updateInfoMode") !== undefined && argumentsMap.get("updateInfoMode") !== null) {
    updatedTeamInfo.updateInfoMode = argumentsMap.get("updateInfoMode") as V2NIMTeamUpdateInfoMode;
  }

  if (argumentsMap.get("updateExtensionMode") !== undefined && argumentsMap.get("updateExtensionMode") !== null) {
    updatedTeamInfo.updateExtensionMode = argumentsMap.get("updateExtensionMode") as V2NIMTeamUpdateExtensionMode;
  }

  if (argumentsMap.get("chatBannedMode") !== undefined && argumentsMap.get("chatBannedMode") !== null) {
    updatedTeamInfo.chatBannedMode = argumentsMap.get("chatBannedMode") as V2NIMTeamChatBannedMode;
  }

  if (argumentsMap.get("customerExtension") !== undefined && argumentsMap.get("customerExtension") !== null) {
    updatedTeamInfo.customerExtension = argumentsMap.get("customerExtension") as string;
  }

  return updatedTeamInfo;
}