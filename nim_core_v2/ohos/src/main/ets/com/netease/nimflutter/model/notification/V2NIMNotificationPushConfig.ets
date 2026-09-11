import { V2NIMNotificationConfig, V2NIMNotificationPushConfig } from "@nimsdk/base";

export function convertMap2NotificationPushConfig(argumentsMap: Map<string, undefined | boolean | [] | null | string>): V2NIMNotificationPushConfig {

  let pushConfig: V2NIMNotificationPushConfig = {
    pushEnabled: false,
    pushNickEnabled: false,
    pushContent: "",
    pushPayload: "",
    forcePush: false,
    forcePushContent: "",
    forcePushAccountIds: []
  };

  if (argumentsMap.get("forcePush") !== undefined && argumentsMap.get("forcePush")  !== null){
    pushConfig.forcePush = argumentsMap.get("forcePush") === true;
  }

  if (argumentsMap.get("pushEnabled") !== undefined && argumentsMap.get("pushEnabled")  !== null){
    pushConfig.pushEnabled = argumentsMap.get("pushEnabled") === true;
  }

  if (argumentsMap.get("pushNickEnabled") !== undefined && argumentsMap.get("pushNickEnabled")  !== null){
    pushConfig.pushNickEnabled = argumentsMap.get("pushNickEnabled") === true;
  }

  if (argumentsMap.get("pushContent") !== undefined && argumentsMap.get("pushContent")  !== null){
    pushConfig.pushContent = argumentsMap.get("pushContent") as string;
  }

  if (argumentsMap.get("pushPayload") !== undefined && argumentsMap.get("pushPayload")  !== null){
    pushConfig.pushPayload = argumentsMap.get("pushPayload") as string;
  }

  if (argumentsMap.get("forcePushContent") !== undefined && argumentsMap.get("forcePushContent")  !== null){
    pushConfig.forcePushContent = argumentsMap.get("forcePushContent") as string;
  }

  if (argumentsMap.get("forcePushAccountIds") !== undefined && argumentsMap.get("forcePushAccountIds")  !== null){
    pushConfig.forcePushAccountIds = argumentsMap.get("forcePushAccountIds") as string[];
  }

  return pushConfig;
}