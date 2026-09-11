import { V2NIMClearHistoryNotification } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2ClearHistoryNotification(argumentsMap: Map<string, Any>): V2NIMClearHistoryNotification {
  let clearHistoryNotification: V2NIMClearHistoryNotification = {
    conversationId: "",
    deleteTime: 0
  };

  if (argumentsMap.get("conversationId") !== undefined && argumentsMap.get("conversationId") !== null) {
    clearHistoryNotification.conversationId = argumentsMap.get("conversationId") as string;
  }

  if (argumentsMap.get("deleteTime") !== undefined && argumentsMap.get("deleteTime") !== null) {
    clearHistoryNotification.deleteTime = argumentsMap.get("deleteTime") as number;
  }

  if (argumentsMap.get("serverExtension") !== undefined && argumentsMap.get("serverExtension") !== null) {
    clearHistoryNotification.serverExtension = argumentsMap.get("serverExtension") as string;
  }

  return clearHistoryNotification;
}