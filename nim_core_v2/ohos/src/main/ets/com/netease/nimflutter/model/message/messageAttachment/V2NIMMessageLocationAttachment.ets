import { V2NIMMessageLocationAttachment, V2NIMMessageType } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageLocationAttachment(argumentsMap: Map<string, Any>): V2NIMMessageLocationAttachment {
  let messageAttachment: V2NIMMessageLocationAttachment = {
    raw: undefined,
    latitude: 0,
    longitude: 0,
    address: ""
  };

  if (argumentsMap.get("raw") !== undefined && argumentsMap.get("raw") !== null) {
    messageAttachment.raw = argumentsMap.get("raw") as string;
  }

  if (argumentsMap.get("latitude") !== undefined && argumentsMap.get("latitude") !== null) {
    messageAttachment.latitude = argumentsMap.get("latitude") as number;
  }

  if (argumentsMap.get("longitude") !== undefined && argumentsMap.get("longitude") !== null) {
    messageAttachment.longitude = argumentsMap.get("longitude") as number;
  }

  if (argumentsMap.get("address") !== undefined && argumentsMap.get("address") !== null) {
    messageAttachment.address = argumentsMap.get("address") as string;
  }

  return messageAttachment;
}

export function convertMessageLocationAttachment2Map(result: V2NIMMessageLocationAttachment): Map<string, Any> {
  return new Map<string, Any>(Object.entries(result)).set("nimCoreMessageType",
    V2NIMMessageType.V2NIM_MESSAGE_TYPE_LOCATION)
}