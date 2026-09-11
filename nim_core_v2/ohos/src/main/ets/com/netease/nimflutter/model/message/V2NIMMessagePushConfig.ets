import { V2NIMMessagePushConfig } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessagePushConfig(argumentsMap: Map<string, Any>): V2NIMMessagePushConfig {
  let messagePushConfig: V2NIMMessagePushConfig = {};

  if (argumentsMap.get("pushEnabled") !== undefined && argumentsMap.get("pushEnabled") !== null) {
    messagePushConfig.pushEnabled = argumentsMap.get("pushEnabled") as boolean;
  }

  if (argumentsMap.get("pushNickEnabled") !== undefined && argumentsMap.get("pushNickEnabled") !== null) {
    messagePushConfig.pushNickEnabled = argumentsMap.get("pushNickEnabled") as boolean;
  }

  if (argumentsMap.get("pushContent") !== undefined && argumentsMap.get("pushContent") !== null) {
    messagePushConfig.pushContent = argumentsMap.get("pushContent") as string;
  }

  if (argumentsMap.get("pushPayload") !== undefined && argumentsMap.get("pushPayload") !== null) {
    messagePushConfig.pushPayload = argumentsMap.get("pushPayload") as string;
  }

  if (argumentsMap.get("forcePush") !== undefined && argumentsMap.get("forcePush") !== null) {
    messagePushConfig.forcePush = argumentsMap.get("forcePush") as boolean;
  }

  if (argumentsMap.get("forcePushContent") !== undefined && argumentsMap.get("forcePushContent") !== null) {
    messagePushConfig.forcePushContent = argumentsMap.get("forcePushContent") as string;
  }

  if (argumentsMap.get("forcePushAccountIds") !== undefined && argumentsMap.get("forcePushAccountIds") !== null) {
    messagePushConfig.forcePushAccountIds = argumentsMap.get("forcePushAccountIds") as string[];
  }

  return messagePushConfig;
}