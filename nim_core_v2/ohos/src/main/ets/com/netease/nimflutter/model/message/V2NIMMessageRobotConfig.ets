import { V2NIMMessageRobotConfig } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageRobotConfig(argumentsMap: Map<string, Any>): V2NIMMessageRobotConfig {
  let messageRobotConfig: V2NIMMessageRobotConfig = {};

  if (argumentsMap.get("accountId") !== undefined && argumentsMap.get("accountId") !== null) {
    messageRobotConfig.accountId = argumentsMap.get("accountId") as string;
  }

  if (argumentsMap.get("topic") !== undefined && argumentsMap.get("topic") !== null) {
    messageRobotConfig.topic = argumentsMap.get("topic") as string;
  }

  if (argumentsMap.get("function") !== undefined && argumentsMap.get("function") !== null) {
    messageRobotConfig.function = argumentsMap.get("function") as string;
  }

  if (argumentsMap.get("customContent") !== undefined && argumentsMap.get("customContent") !== null) {
    messageRobotConfig.customContent = argumentsMap.get("customContent") as string;
  }

  return messageRobotConfig;
}