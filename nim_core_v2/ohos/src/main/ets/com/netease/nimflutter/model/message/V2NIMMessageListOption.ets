import { V2NIMMessageListOption, V2NIMMessageType, V2NIMQueryDirection } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertMap2Message } from './V2NIMMessage';

export function convertMap2MessageListOption(argumentsMap: Map<string, Any>): V2NIMMessageListOption {
  let object: V2NIMMessageListOption = {
    conversationId: "",
    messageTypes: [],
  };

  if (argumentsMap.get("conversationId") !== undefined && argumentsMap.get("conversationId") !== null) {
    object.conversationId = argumentsMap.get("conversationId") as string;
  }

  if (argumentsMap.get("messageTypes") !== undefined && argumentsMap.get("messageTypes") !== null) {
    object.messageTypes = argumentsMap.get("messageTypes") as V2NIMMessageType[];
  }

  if (argumentsMap.get("beginTime") !== undefined && argumentsMap.get("beginTime") !== null) {
    object.beginTime = argumentsMap.get("beginTime") as number;
  }

  if (argumentsMap.get("endTime") !== undefined && argumentsMap.get("endTime") !== null) {
    object.endTime = argumentsMap.get("endTime") as number;
  }

  if (argumentsMap.get("limit") !== undefined && argumentsMap.get("limit") !== null) {
    object.limit = argumentsMap.get("limit") as number;
  }

  if (argumentsMap.get("anchorMessage") !== undefined && argumentsMap.get("anchorMessage") !== null) {
    object.anchorMessage = convertMap2Message(argumentsMap.get("anchorMessage") as Map<string, Any>);
  }

  if (argumentsMap.get("direction") !== undefined && argumentsMap.get("direction") !== null) {
    object.direction = argumentsMap.get("direction") as V2NIMQueryDirection;
  }

  if (argumentsMap.get("strictMode") !== undefined && argumentsMap.get("strictMode") !== null) {
    object.strictMode = argumentsMap.get("strictMode") as boolean;
  }

  if (argumentsMap.get("onlyQueryLocal") !== undefined && argumentsMap.get("onlyQueryLocal") !== null) {
    object.onlyQueryLocal = argumentsMap.get("onlyQueryLocal") as boolean;
  }

  return object;
}