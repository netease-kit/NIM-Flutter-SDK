import { V2NIMAntispamConfig, V2NIMNotificationAntispamConfig } from "@nimsdk/base";


export function convertMap2NotificationAntispamConfig(argumentsMap: Map<string, undefined | string | boolean | number | null>): V2NIMNotificationAntispamConfig {

  let antispamConfig: V2NIMNotificationAntispamConfig = {
    antispamEnabled: false,
    antispamCustomNotification: ""
  };

  if (argumentsMap.get("antispamEnabled") !== undefined && argumentsMap.get("antispamEnabled") !== null) {
    antispamConfig.antispamEnabled = argumentsMap.get("antispamEnabled") as boolean;
  }

  if (argumentsMap.get("antispamCustomNotification") !== undefined && argumentsMap.get("antispamCustomNotification") !== null ) {
    antispamConfig.antispamCustomNotification = argumentsMap.get("antispamCustomNotification") as string;
  }

  return antispamConfig;
}