import {
  V2NIMMessageNotificationAttachment, V2NIMMessageNotificationType, V2NIMMessageType
} from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertMap2UpdatedTeamInfo } from '../../team/V2NIMUpdatedTeamInfo';

export function convertMap2MessageNotificationAttachment(argumentsMap: Map<string, Any>): V2NIMMessageNotificationAttachment {
  let messageAttachment: V2NIMMessageNotificationAttachment = {
    raw: undefined,
    type: V2NIMMessageNotificationType.V2NIM_MESSAGE_NOTIFICATION_TYPE_UNDEFINED,
    serverExtension: undefined,
    targetIds: undefined,
    chatBanned: undefined,
    updatedTeamInfo: undefined
  };

  if (argumentsMap.get("raw") !== undefined && argumentsMap.get("raw") !== null) {
    messageAttachment.raw = argumentsMap.get("raw") as string;
  }

  if (argumentsMap.get("type") !== undefined && argumentsMap.get("type") !== null) {
    messageAttachment.type = argumentsMap.get("type") as V2NIMMessageNotificationType;
  }

  if (argumentsMap.get("serverExtension") !== undefined && argumentsMap.get("serverExtension") !== null) {
    messageAttachment.serverExtension = argumentsMap.get("serverExtension") as string;
  }

  if (argumentsMap.get("targetIds") !== undefined && argumentsMap.get("targetIds") !== null) {
    messageAttachment.targetIds = argumentsMap.get("targetIds") as string[];
  }

  if (argumentsMap.get("chatBanned") !== undefined && argumentsMap.get("chatBanned") !== null) {
    messageAttachment.chatBanned = argumentsMap.get("chatBanned") as boolean;
  }

  if (argumentsMap.get("updatedTeamInfo") !== undefined && argumentsMap.get("updatedTeamInfo") !== null) {
    messageAttachment.updatedTeamInfo =
      convertMap2UpdatedTeamInfo(argumentsMap.get("updatedTeamInfo") as Map<string, Any>);
  }

  return messageAttachment;
}

export function convertMessageNotificationAttachment2Map(result: V2NIMMessageNotificationAttachment): Map<string, Any> {
  let resMap: Map<string, Any> = new Map<string, Any>(Object.entries(result))
  resMap.set("nimCoreMessageType", V2NIMMessageType.V2NIM_MESSAGE_TYPE_NOTIFICATION)
  return resMap
}
