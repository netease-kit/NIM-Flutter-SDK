import { V2NIMMessageRouteConfig } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageRouteConfig(argumentsMap: Map<string, Any>): V2NIMMessageRouteConfig {
  let messageRouteConfig: V2NIMMessageRouteConfig = {};

  if (argumentsMap.get("routeEnabled") !== undefined && argumentsMap.get("routeEnabled") !== null) {
    messageRouteConfig.routeEnabled = argumentsMap.get("routeEnabled") as boolean;
  }

  if (argumentsMap.get("routeEnvironment") !== undefined && argumentsMap.get("routeEnvironment") !== null) {
    messageRouteConfig.routeEnvironment = argumentsMap.get("routeEnvironment") as string;
  }

  return messageRouteConfig;
}