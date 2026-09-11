import { V2NIMQueryDirection, V2NIMThreadMessageListOption } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertMap2MessageRefer } from './V2NIMMessageRefer';

export function convertMap2ThreadMessageListOption(argumentsMap: Map<string, Any>): V2NIMThreadMessageListOption {
  let threadMessageListOption: V2NIMThreadMessageListOption = {
    messageRefer: convertMap2MessageRefer(argumentsMap),
    beginTime: undefined,
    endTime: undefined,
    limit: undefined,
    direction: undefined,
    excludeMessageServerId: undefined
  };

  if (argumentsMap.get("messageRefer") !== undefined && argumentsMap.get("messageRefer") !== null) {
    threadMessageListOption.messageRefer =
      convertMap2MessageRefer(argumentsMap.get("messageRefer") as Map<string, Any>);
  }

  if (argumentsMap.get("beginTime") !== undefined && argumentsMap.get("beginTime") !== null) {
    threadMessageListOption.beginTime = argumentsMap.get("beginTime") as number;
  }

  if (argumentsMap.get("endTime") !== undefined && argumentsMap.get("endTime") !== null) {
    threadMessageListOption.endTime = argumentsMap.get("endTime") as number;
  }

  if (argumentsMap.get("limit") !== undefined && argumentsMap.get("limit") !== null) {
    threadMessageListOption.limit = argumentsMap.get("limit") as number;
  }

  if (argumentsMap.get("direction") !== undefined && argumentsMap.get("direction") !== null) {
    threadMessageListOption.direction = argumentsMap.get("direction") as V2NIMQueryDirection;
  }

  if (argumentsMap.get("excludeMessageServerId") !== undefined && argumentsMap.get("excludeMessageServerId") !== null) {
    threadMessageListOption.excludeMessageServerId = argumentsMap.get("excludeMessageServerId") as string;
  }

  return threadMessageListOption;
}