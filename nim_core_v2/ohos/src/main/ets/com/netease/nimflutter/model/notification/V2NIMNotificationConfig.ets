import { V2NIMNotificationConfig } from "@nimsdk/base";

export function convertMap2NotificationConfig(argumentsMap: Map<string, undefined  | boolean  | null>): V2NIMNotificationConfig {

  let notification: V2NIMNotificationConfig = {
    offlineEnabled: false,
    unreadEnabled: false
  };

  if (argumentsMap.get("offlineEnabled") !== undefined && argumentsMap.get("offlineEnabled")  !== null){
    notification.offlineEnabled = argumentsMap.get("offlineEnabled") === true;
  }

  if (argumentsMap.get("unreadEnabled") !== undefined && argumentsMap.get("unreadEnabled")  !== null){
    notification.unreadEnabled = argumentsMap.get("unreadEnabled") === true;
  }

  return notification;
}