import { V2NIMMessageType, V2NIMModifyMessageParams } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertMap2MessageAttachment } from './messageAttachment/V2NIMMessageAttachment';
import { convertMap2MessageAudioAttachment } from './messageAttachment/V2NIMMessageAudioAttachment';
import { convertMap2MessageCallAttachment } from './messageAttachment/V2NIMMessageCallAttachment';
import { convertMap2MessageFileAttachment } from './messageAttachment/V2NIMMessageFileAttachment';
import { convertMap2MessageImageAttachment } from './messageAttachment/V2NIMMessageImageAttachment';
import { convertMap2MessageLocationAttachment } from './messageAttachment/V2NIMMessageLocationAttachment';
import { convertMap2MessageNotificationAttachment } from './messageAttachment/V2NIMMessageNotificationAttachment';
import { convertMap2MessageVideoAttachment } from './messageAttachment/V2NIMMessageVideoAttachment';
import { convertMap2MessageAntispamConfig } from './V2NIMMessageAntispamConfig';
import { convertMap2MessagePushConfig } from './V2NIMMessagePushConfig';
import { convertMap2MessageRouteConfig } from './V2NIMMessageRouteConfig';

export function convertMap2ModifyMessageParams(argumentsMap: Map<string, Any>): V2NIMModifyMessageParams {
  let modifyMessageParams: V2NIMModifyMessageParams = {
    subType: undefined,
    text: undefined,
    attachment: undefined,
    serverExtension: undefined,
    antispamConfig: undefined,
    routeConfig: undefined,
    pushConfig: undefined,
    clientAntispamEnabled: undefined,
    clientAntispamReplace: undefined
  };

  if (argumentsMap.get("subType") !== undefined && argumentsMap.get("subType") !== null) {
    modifyMessageParams.subType = argumentsMap.get("subType") as number;
  }

  if (argumentsMap.get("text") !== undefined && argumentsMap.get("text") !== null) {
    modifyMessageParams.text = argumentsMap.get("text") as string;
  }

  if (argumentsMap.get("attachment") !== undefined && argumentsMap.get("attachment") !== null) {
    const attachmentMap: Map<string, Any> = argumentsMap.get("attachment") as Map<string, Any>;
    let messageType = (argumentsMap.get("messageType") !== undefined && argumentsMap.get("messageType") !== null) ?
      argumentsMap.get("messageType") as V2NIMMessageType : V2NIMMessageType.V2NIM_MESSAGE_TYPE_INVALID;

    switch (messageType) {
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_AUDIO:
        modifyMessageParams.attachment = convertMap2MessageAudioAttachment(attachmentMap);
        break;
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_FILE:
        modifyMessageParams.attachment = convertMap2MessageFileAttachment(attachmentMap);
        break;
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_IMAGE:
        modifyMessageParams.attachment = convertMap2MessageImageAttachment(attachmentMap);
        break;
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_VIDEO:
        modifyMessageParams.attachment = convertMap2MessageVideoAttachment(attachmentMap);
        break;
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_LOCATION:
        modifyMessageParams.attachment = convertMap2MessageLocationAttachment(attachmentMap);
        break;
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_NOTIFICATION:
        modifyMessageParams.attachment = convertMap2MessageNotificationAttachment(attachmentMap);
        break;
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_CALL:
        modifyMessageParams.attachment = convertMap2MessageCallAttachment(attachmentMap);
        break;
      default:
        modifyMessageParams.attachment = convertMap2MessageAttachment(attachmentMap);
        break;
    }
  }

  if (argumentsMap.get("serverExtension") !== undefined && argumentsMap.get("serverExtension") !== null) {
    modifyMessageParams.serverExtension = argumentsMap.get("serverExtension") as string;
  }

  if (argumentsMap.get("antispamConfig") !== undefined && argumentsMap.get("antispamConfig") !== null) {
    modifyMessageParams.antispamConfig =
      convertMap2MessageAntispamConfig(argumentsMap.get("antispamConfig") as Map<string, Any>);
  }

  if (argumentsMap.get("routeConfig") !== undefined && argumentsMap.get("routeConfig") !== null) {
    modifyMessageParams.routeConfig =
      convertMap2MessageRouteConfig(argumentsMap.get("routeConfig") as Map<string, Any>);
  }

  if (argumentsMap.get("pushConfig") !== undefined && argumentsMap.get("pushConfig") !== null) {
    modifyMessageParams.pushConfig = convertMap2MessagePushConfig(argumentsMap.get("pushConfig") as Map<string, Any>);
  }

  if (argumentsMap.get("clientAntispamEnabled") !== undefined && argumentsMap.get("clientAntispamEnabled") !== null) {
    modifyMessageParams.clientAntispamEnabled = argumentsMap.get("clientAntispamEnabled") as boolean;
  }

  if (argumentsMap.get("clientAntispamReplace") !== undefined && argumentsMap.get("clientAntispamReplace") !== null) {
    modifyMessageParams.clientAntispamReplace = argumentsMap.get("clientAntispamReplace") as string;
  }

  return modifyMessageParams;
}