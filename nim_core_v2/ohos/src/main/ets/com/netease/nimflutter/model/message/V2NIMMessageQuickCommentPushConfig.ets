import { V2NIMMessageQuickCommentPushConfig } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageQuickCommentPushConfig(argumentsMap: Map<string, Any>): V2NIMMessageQuickCommentPushConfig {
  let object: V2NIMMessageQuickCommentPushConfig = {};

  if (argumentsMap.get("pushEnabled") !== undefined && argumentsMap.get("pushEnabled") !== null) {
    object.pushEnabled = argumentsMap.get("pushEnabled") as boolean;
  }

  if (argumentsMap.get("needBadge") !== undefined && argumentsMap.get("needBadge") !== null) {
    object.needBadge = argumentsMap.get("needBadge") as boolean;
  }

  if (argumentsMap.get("title") !== undefined && argumentsMap.get("title") !== null) {
    object.title = argumentsMap.get("title") as string;
  }

  if (argumentsMap.get("pushContent") !== undefined && argumentsMap.get("pushContent") !== null) {
    object.pushContent = argumentsMap.get("pushContent") as string;
  }

  if (argumentsMap.get("pushPayload") !== undefined && argumentsMap.get("pushPayload") !== null) {
    object.pushPayload = argumentsMap.get("pushPayload") as string;
  }

  return object;
}