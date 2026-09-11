import { V2NIMMessageConfig } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageConfig(argumentsMap: Map<string, Any>): V2NIMMessageConfig {
  let messageConfig: V2NIMMessageConfig = {
    readReceiptEnabled: undefined,
    historyEnabled: undefined,
    roamingEnabled: undefined,
    onlineSyncEnabled: undefined,
    offlineEnabled: undefined,
    lastMessageUpdateEnabled: undefined,
    unreadEnabled: undefined,
  };

  if (argumentsMap.get("readReceiptEnabled") !== undefined && argumentsMap.get("readReceiptEnabled") !== null) {
    messageConfig.readReceiptEnabled = argumentsMap.get("readReceiptEnabled") as boolean;
  }

  if (argumentsMap.get("historyEnabled") !== undefined && argumentsMap.get("historyEnabled") !== null) {
    messageConfig.historyEnabled = argumentsMap.get("historyEnabled") as boolean;
  }

  if (argumentsMap.get("roamingEnabled") !== undefined && argumentsMap.get("roamingEnabled") !== null) {
    messageConfig.roamingEnabled = argumentsMap.get("roamingEnabled") as boolean;
  }

  if (argumentsMap.get("onlineSyncEnabled") !== undefined && argumentsMap.get("onlineSyncEnabled") !== null) {
    messageConfig.onlineSyncEnabled = argumentsMap.get("onlineSyncEnabled") as boolean;
  }

  if (argumentsMap.get("offlineEnabled") !== undefined && argumentsMap.get("offlineEnabled") !== null) {
    messageConfig.offlineEnabled = argumentsMap.get("offlineEnabled") as boolean;
  }

  if (argumentsMap.get("lastMessageUpdateEnabled") !== undefined &&
    argumentsMap.get("lastMessageUpdateEnabled") !== null) {
    messageConfig.lastMessageUpdateEnabled = argumentsMap.get("lastMessageUpdateEnabled") as boolean;
  }

  if (argumentsMap.get("unreadEnabled") !== undefined && argumentsMap.get("unreadEnabled") !== null) {
    messageConfig.unreadEnabled = argumentsMap.get("unreadEnabled") as boolean;
  }

  return messageConfig;
}