import { V2NIMConversationFilter, V2NIMConversationType } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2ConversationFilter(argumentsMap: Map<string, Any>): V2NIMConversationFilter {
  let filter: V2NIMConversationFilter = {
  };

  if (argumentsMap.get("conversationTypes") !== undefined && argumentsMap.get("conversationTypes") !== null) {
    filter.conversationTypes = argumentsMap.get("conversationTypes") as V2NIMConversationType[];
  }

  if (argumentsMap.get("conversationGroupId") !== undefined && argumentsMap.get("conversationGroupId") !== null) {
    filter.conversationGroupId = argumentsMap.get("conversationGroupId") as string;
  }

  if (argumentsMap.get("ignoreMuted") !== undefined && argumentsMap.get("ignoreMuted") !== null) {
    filter.ignoreMuted = argumentsMap.get("ignoreMuted") as boolean;
  }

  return filter;
}