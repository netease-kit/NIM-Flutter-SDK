import { V2NIMMessageRevokeParams } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageRevokeParams(argumentsMap: Map<string, Any>): V2NIMMessageRevokeParams {
  let object: V2NIMMessageRevokeParams = {};

  if (argumentsMap.get("postscript") !== undefined && argumentsMap.get("postscript") !== null) {
    object.postscript = argumentsMap.get("postscript") as string;
  }

  if (argumentsMap.get("serverExtension") !== undefined && argumentsMap.get("serverExtension") !== null) {
    object.serverExtension = argumentsMap.get("serverExtension") as string;
  }

  if (argumentsMap.get("pushContent") !== undefined && argumentsMap.get("pushContent") !== null) {
    object.pushContent = argumentsMap.get("pushContent") as string;
  }

  if (argumentsMap.get("pushPayload") !== undefined && argumentsMap.get("pushPayload") !== null) {
    object.pushPayload = argumentsMap.get("pushPayload") as string;
  }

  if (argumentsMap.get("env") !== undefined && argumentsMap.get("env") !== null) {
    object.env = argumentsMap.get("env") as string;
  }

  return object;
}