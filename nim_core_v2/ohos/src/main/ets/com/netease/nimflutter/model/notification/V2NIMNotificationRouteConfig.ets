import { V2NIMAntispamConfig, V2NIMNotificationAntispamConfig, V2NIMNotificationRouteConfig } from "@nimsdk/base";


export function convertMap2NotificationRouteConfig(argumentsMap: Map<string, undefined | string | boolean | number | null>): V2NIMNotificationRouteConfig {

  let routeConfig: V2NIMNotificationRouteConfig = {
    routeEnabled: false,
    routeEnvironment: ""
  };

  if (argumentsMap.get("routeEnabled") !== undefined && argumentsMap.get("routeEnabled") !== null) {
    routeConfig.routeEnabled = argumentsMap.get("routeEnabled") as boolean;
  }

  if (argumentsMap.get("routeEnvironment") !== undefined && argumentsMap.get("routeEnvironment") !== null ) {
    routeConfig.routeEnvironment = argumentsMap.get("routeEnvironment") as string;
  }

  return routeConfig;
}