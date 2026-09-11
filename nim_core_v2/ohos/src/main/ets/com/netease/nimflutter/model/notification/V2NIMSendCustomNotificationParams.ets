import { V2NIMAntispamConfig, V2NIMSendCustomNotificationParams } from "@nimsdk/base";
import { Any } from "@ohos/flutter_ohos";
import { convertMap2NotificationAntispamConfig } from "./V2NIMNotificationAntispamConfig";
import { convertMap2NotificationConfig } from "./V2NIMNotificationConfig";
import { convertMap2NotificationPushConfig } from "./V2NIMNotificationPushConfig";
import { convertMap2NotificationRouteConfig } from "./V2NIMNotificationRouteConfig";

export function convertMap2CustomNotificationParams(argumentsMap: Map<string, object>): V2NIMSendCustomNotificationParams {
   let sendCustomNotificationParams:V2NIMSendCustomNotificationParams = {}
  if (argumentsMap.get("notificationConfig") !== undefined && argumentsMap.get("notificationConfig")  !== null) {
    let notificationConfigMap:Map<string, boolean | undefined | null>
      = argumentsMap.get("notificationConfig") as Map<string, boolean | undefined | null>;
    sendCustomNotificationParams.notificationConfig = convertMap2NotificationConfig(notificationConfigMap);
  }

  if (argumentsMap.get("pushConfig") !== undefined && argumentsMap.get("pushConfig")  !== null) {
    let pushConfigMap:Map<string, boolean | undefined |string|[]| null>
      = argumentsMap.get("pushConfig") as Map<string, boolean|string | undefined | []|  null>;
    sendCustomNotificationParams.pushConfig = convertMap2NotificationPushConfig(pushConfigMap);
  }

  if (argumentsMap.get("antispamConfig") !== undefined && argumentsMap.get("antispamConfig")  !== null) {
    let antiSpamConfigMap:Map<string, boolean | undefined |string| null>
      = argumentsMap.get("antispamConfig") as Map<string, boolean|string | undefined | null>;
    sendCustomNotificationParams.antispamConfig = convertMap2NotificationAntispamConfig(antiSpamConfigMap);
  }

  if (argumentsMap.get("routeConfig") !== undefined && argumentsMap.get("routeConfig")  !== null) {
    let routeConfigMap:Map<string, boolean | undefined |string| null>
      = argumentsMap.get("routeConfig") as Map<string, boolean|string | undefined | null>;
    sendCustomNotificationParams.routeConfig = convertMap2NotificationRouteConfig(routeConfigMap);
  }

  return sendCustomNotificationParams;
}