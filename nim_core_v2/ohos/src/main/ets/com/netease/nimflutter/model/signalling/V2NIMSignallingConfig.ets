import { V2NIMSignallingConfig } from '@nimsdk/base';

export function convertMap2SignallingConfig(argumentsMap: Map<string, undefined | number | boolean | null>): V2NIMSignallingConfig {

  let config: V2NIMSignallingConfig = {};

  if (argumentsMap.get("offlineEnabled") !== undefined && argumentsMap.get("offlineEnabled") !== null) {
    config.offlineEnabled = argumentsMap.get("offlineEnabled") === true;
  }

  if (argumentsMap.get("unreadEnabled") !== undefined && argumentsMap.get("unreadEnabled") !== null) {
    config.unreadEnabled = argumentsMap.get("unreadEnabled") === true;
  }

  if (argumentsMap.get("selfUid") !== undefined && argumentsMap.get("selfUid") !== null) {
    config.selfUid = argumentsMap.get("selfUid") as number;
  }

  return config;
}