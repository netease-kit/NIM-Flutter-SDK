import { V2NIMClearHistoryMessageOption, V2NIMClearHistoryMode } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2ClearHistoryMessageOption(argumentsMap: Map<string, Any>): V2NIMClearHistoryMessageOption {
  let clearHistoryMessageOption: V2NIMClearHistoryMessageOption = {
    conversationId: ""
  };

  if (argumentsMap.get("conversationId") !== undefined && argumentsMap.get("conversationId") !== null) {
    clearHistoryMessageOption.conversationId = argumentsMap.get("conversationId") as string;
  }

  if (argumentsMap.get("deleteRoam") !== undefined && argumentsMap.get("deleteRoam") !== null) {
    clearHistoryMessageOption.deleteRoam = argumentsMap.get("deleteRoam") as boolean;
  }

  if (argumentsMap.get("onlineSync") !== undefined && argumentsMap.get("onlineSync") !== null) {
    clearHistoryMessageOption.onlineSync = argumentsMap.get("onlineSync") as boolean;
  }

  if (argumentsMap.get("serverExtension") !== undefined && argumentsMap.get("serverExtension") !== null) {
    clearHistoryMessageOption.serverExtension = argumentsMap.get("serverExtension") as string;
  }

  if (argumentsMap.get("clearMode") !== undefined && argumentsMap.get("clearMode") !== null) {
    clearHistoryMessageOption.clearMode = argumentsMap.get("clearMode") as V2NIMClearHistoryMode;
  }

  return clearHistoryMessageOption;
}