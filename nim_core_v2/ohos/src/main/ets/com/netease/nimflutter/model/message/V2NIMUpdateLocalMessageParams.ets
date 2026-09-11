import {
  V2NIMMessageSendingState, V2NIMMessageType, V2NIMUpdateLocalMessageParams
} from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertMap2MessageAttachment } from './messageAttachment/V2NIMMessageAttachment';
import { convertMap2MessageAudioAttachment } from './messageAttachment/V2NIMMessageAudioAttachment';
import { convertMap2MessageCallAttachment } from './messageAttachment/V2NIMMessageCallAttachment';
import { convertMap2MessageFileAttachment } from './messageAttachment/V2NIMMessageFileAttachment';
import { convertMap2MessageImageAttachment } from './messageAttachment/V2NIMMessageImageAttachment';
import { convertMap2MessageLocationAttachment } from './messageAttachment/V2NIMMessageLocationAttachment';
import { convertMap2MessageNotificationAttachment } from './messageAttachment/V2NIMMessageNotificationAttachment';
import { convertMap2MessageVideoAttachment } from './messageAttachment/V2NIMMessageVideoAttachment';

export function convertMap2UpdateLocalMessageParams(argumentsMap: Map<string, Any>): V2NIMUpdateLocalMessageParams {
  let updateLocalMessageParams: V2NIMUpdateLocalMessageParams = {
    subType: undefined,
    text: undefined,
    attachment: undefined,
    sendingState: undefined,
    localExtension: undefined
  };

  if (argumentsMap.get("subType") !== undefined && argumentsMap.get("subType") !== null) {
    updateLocalMessageParams.subType = argumentsMap.get("subType") as number;
  }

  if (argumentsMap.get("text") !== undefined && argumentsMap.get("text") !== null) {
    updateLocalMessageParams.text = argumentsMap.get("text") as string;
  }

  if (argumentsMap.get("attachment") !== undefined && argumentsMap.get("attachment") !== null) {
    let attachmentMap: Map<string, Any> = argumentsMap.get("attachment") as Map<string, Any>;
    let messageType = (argumentsMap.get("messageType") !== undefined && argumentsMap.get("messageType") !== null) ?
      argumentsMap.get("messageType") as V2NIMMessageType : V2NIMMessageType.V2NIM_MESSAGE_TYPE_INVALID;

    switch (messageType) {
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_AUDIO:
        updateLocalMessageParams.attachment = convertMap2MessageAudioAttachment(attachmentMap);
        break;
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_FILE:
        updateLocalMessageParams.attachment = convertMap2MessageFileAttachment(attachmentMap);
        break;
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_IMAGE:
        updateLocalMessageParams.attachment = convertMap2MessageImageAttachment(attachmentMap);
        break;
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_VIDEO:
        updateLocalMessageParams.attachment = convertMap2MessageVideoAttachment(attachmentMap);
        break;
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_LOCATION:
        updateLocalMessageParams.attachment = convertMap2MessageLocationAttachment(attachmentMap);
        break;
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_NOTIFICATION:
        updateLocalMessageParams.attachment = convertMap2MessageNotificationAttachment(attachmentMap);
        break;
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_CALL:
        updateLocalMessageParams.attachment = convertMap2MessageCallAttachment(attachmentMap);
        break;
      default:
        updateLocalMessageParams.attachment = convertMap2MessageAttachment(attachmentMap);
        break;
    }
  }

  if (argumentsMap.get("sendingState") !== undefined && argumentsMap.get("sendingState") !== null) {
    updateLocalMessageParams.sendingState = argumentsMap.get("sendingState") as V2NIMMessageSendingState;
  }

  if (argumentsMap.get("localExtension") !== undefined && argumentsMap.get("localExtension") !== null) {
    updateLocalMessageParams.localExtension = argumentsMap.get("localExtension") as string;
  }

  return updateLocalMessageParams;
}