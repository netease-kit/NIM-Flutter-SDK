import { V2NIMCloudMessageListOption, V2NIMMessageType, V2NIMQueryDirection } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertMap2Message } from './V2NIMMessage';

export function convertMap2CloudMessageListOption(argumentsMap: Map<string, Any>): V2NIMCloudMessageListOption {
  let cloudMessageListOption: V2NIMCloudMessageListOption = {
    conversationId: ""
  };

  if (argumentsMap.get("conversationId") !== undefined && argumentsMap.get("conversationId") !== null) {
    cloudMessageListOption.conversationId = argumentsMap.get("conversationId") as string;
  }

  if (argumentsMap.get("messageTypes") !== undefined && argumentsMap.get("messageTypes") !== null) {
    cloudMessageListOption.messageTypes = argumentsMap.get("messageTypes") as V2NIMMessageType[];
  }

  if (argumentsMap.get("beginTime") !== undefined && argumentsMap.get("beginTime") !== null) {
    cloudMessageListOption.beginTime = argumentsMap.get("beginTime") as number;
  }

  if (argumentsMap.get("endTime") !== undefined && argumentsMap.get("endTime") !== null) {
    cloudMessageListOption.endTime = argumentsMap.get("endTime") as number;
  }

  if (argumentsMap.get("limit") !== undefined && argumentsMap.get("limit") !== null) {
    cloudMessageListOption.limit = argumentsMap.get("limit") as number;
  }

  if (argumentsMap.get("anchorMessage") !== undefined && argumentsMap.get("anchorMessage") !== null) {
    cloudMessageListOption.anchorMessage = convertMap2Message(argumentsMap.get("anchorMessage") as Map<string, Any>);
  }

  if (argumentsMap.get("direction") !== undefined && argumentsMap.get("direction") !== null) {
    cloudMessageListOption.direction = argumentsMap.get("direction") as V2NIMQueryDirection;
  }

  return cloudMessageListOption;
}