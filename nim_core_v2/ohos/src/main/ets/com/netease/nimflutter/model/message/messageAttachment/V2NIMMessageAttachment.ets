import {
  V2NIMMessageAttachment,
  V2NIMMessageAudioAttachment,
  V2NIMMessageCallAttachment,
  V2NIMMessageFileAttachment,
  V2NIMMessageImageAttachment,
  V2NIMMessageLocationAttachment,
  V2NIMMessageNotificationAttachment,
  V2NIMMessageType,
  V2NIMMessageVideoAttachment
} from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertMessageAudioAttachment2Map } from './V2NIMMessageAudioAttachment';
import { convertMessageCallAttachment2Map } from './V2NIMMessageCallAttachment';
import { convertMessageFileAttachment2Map } from './V2NIMMessageFileAttachment';
import { convertMessageImageAttachment2Map } from './V2NIMMessageImageAttachment';
import { convertMessageLocationAttachment2Map } from './V2NIMMessageLocationAttachment';
import { convertMessageNotificationAttachment2Map } from './V2NIMMessageNotificationAttachment';
import { convertMessageVideoAttachment2Map } from './V2NIMMessageVideoAttachment';

export function convertMap2MessageAttachment(argumentsMap: Map<string, Any>): V2NIMMessageAttachment {
  let messageAttachment: V2NIMMessageAttachment = {
    raw: undefined
  };

  if (argumentsMap.get("raw") !== undefined && argumentsMap.get("raw") !== null) {
    messageAttachment.raw = argumentsMap.get("raw") as string;
  }

  return messageAttachment;
}

export function convertAttachmentToMap(attachment?: V2NIMMessageAttachment,
  messageType?: V2NIMMessageType): Map<string, Any> | undefined {
  if (!attachment) {
    return undefined;
  }

  const map: Map<string, Any> = new Map<string, Any>();
  // 基础附件字段
  map.set("raw", attachment.raw);

  if (messageType) {
    switch (messageType) {
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_AUDIO:
        let audioAttach = attachment as V2NIMMessageAudioAttachment
        return convertMessageAudioAttachment2Map(audioAttach)
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_IMAGE:
        let imageAttach = attachment as V2NIMMessageImageAttachment
        return convertMessageImageAttachment2Map(imageAttach)
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_VIDEO:
        let videoAttach = attachment as V2NIMMessageVideoAttachment
        return convertMessageVideoAttachment2Map(videoAttach)
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_FILE:
        let fileAttach = attachment as V2NIMMessageFileAttachment
        return convertMessageFileAttachment2Map(fileAttach)
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_LOCATION:
        let locationAttach = attachment as V2NIMMessageLocationAttachment
        return convertMessageLocationAttachment2Map(locationAttach)
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_CALL:
        let callAttach = attachment as V2NIMMessageCallAttachment
        return convertMessageCallAttachment2Map(callAttach)
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_NOTIFICATION:
        let notiAttach = attachment as V2NIMMessageNotificationAttachment
        return convertMessageNotificationAttachment2Map(notiAttach)
    }
  }

  return map;
}