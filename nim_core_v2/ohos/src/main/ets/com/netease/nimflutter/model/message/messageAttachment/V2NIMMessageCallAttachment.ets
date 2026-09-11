import { V2NIMMessageCallAttachment, V2NIMMessageType } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertMap2MessageCallDuration } from '../V2NIMMessageCallDuration';

export function convertMap2MessageCallAttachment(argumentsMap: Map<string, Any>): V2NIMMessageCallAttachment {
  let messageAttachment: V2NIMMessageCallAttachment = {
    raw: undefined,
    type: 0,
    channelId: "",
    status: 0,
    durations: []
  };

  if (argumentsMap.get("raw") !== undefined && argumentsMap.get("raw") !== null) {
    messageAttachment.raw = argumentsMap.get("raw") as string;
  }

  if (argumentsMap.get("type") !== undefined && argumentsMap.get("type") !== null) {
    messageAttachment.type = argumentsMap.get("type") as number;
  }

  if (argumentsMap.get("channelId") !== undefined && argumentsMap.get("channelId") !== null) {
    messageAttachment.channelId = argumentsMap.get("channelId") as string;
  }

  if (argumentsMap.get("status") !== undefined && argumentsMap.get("status") !== null) {
    messageAttachment.status = argumentsMap.get("status") as number;
  }

  if (argumentsMap.get("durations") !== undefined && argumentsMap.get("durations") !== null) {
    messageAttachment.durations =
      (argumentsMap.get("durations") as Map<string, Any>[]).map((innerMap: Map<string, Any>) => convertMap2MessageCallDuration(innerMap));
  }

  return messageAttachment;
}

export function convertMessageCallAttachment2Map(result: V2NIMMessageCallAttachment): Map<string, Any> {
  let resultMap:Map<string, Any> = new Map<string, Any>(Object.entries(result)).set("nimCoreMessageType",
    V2NIMMessageType.V2NIM_MESSAGE_TYPE_CALL)
  resultMap.set("channelId",result.channelId + "")
  return resultMap
}