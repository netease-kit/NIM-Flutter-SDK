import { V2NIMSignallingPushConfig } from '@nimsdk/base';

export function convertMap2SignallingPushConfig(argumentsMap: Map<string, undefined | boolean | null | string>): V2NIMSignallingPushConfig {

  let pushConfig: V2NIMSignallingPushConfig = {
    pushEnabled: false,
    pushContent: "",
    pushPayload: "",
  };
  if (argumentsMap.get("pushEnabled") !== undefined && argumentsMap.get("pushEnabled") !== null) {
    pushConfig.pushEnabled = argumentsMap.get("pushEnabled") === true;
  }

  if (argumentsMap.get("pushContent") !== undefined && argumentsMap.get("pushContent") !== null) {
    pushConfig.pushContent = argumentsMap.get("pushContent") as string;
  }

  if (argumentsMap.get("pushPayload") !== undefined && argumentsMap.get("pushPayload") !== null) {
    pushConfig.pushPayload = argumentsMap.get("pushPayload") as string;
  }

  if (argumentsMap.get("pushTitle") !== undefined && argumentsMap.get("pushTitle") !== null) {
    pushConfig.pushTitle = argumentsMap.get("pushTitle") as string;
  }


  return pushConfig;
}