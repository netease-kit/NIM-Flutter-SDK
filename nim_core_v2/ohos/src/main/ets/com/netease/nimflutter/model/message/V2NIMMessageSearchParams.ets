import { V2NIMMessageSearchParams, V2NIMMessageType, V2NIMSortOrder } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageSearchParams(argumentsMap: Map<string, Any>): V2NIMMessageSearchParams {
  let messageSearchParams: V2NIMMessageSearchParams = {
    keyword: "",
    senderAccountIds: []
  };

  if (argumentsMap.get("keyword") !== undefined && argumentsMap.get("keyword") !== null) {
    messageSearchParams.keyword = argumentsMap.get("keyword") as string;
  }

  if (argumentsMap.get("beginTime") !== undefined && argumentsMap.get("beginTime") !== null) {
    messageSearchParams.beginTime = argumentsMap.get("beginTime") as number;
  }

  if (argumentsMap.get("endTime") !== undefined && argumentsMap.get("endTime") !== null) {
    messageSearchParams.endTime = argumentsMap.get("endTime") as number;
  }

  if (argumentsMap.get("conversationLimit") !== undefined && argumentsMap.get("conversationLimit") !== null) {
    messageSearchParams.conversationLimit = argumentsMap.get("conversationLimit") as number;
  }

  if (argumentsMap.get("messageLimit") !== undefined && argumentsMap.get("messageLimit") !== null) {
    messageSearchParams.messageLimit = argumentsMap.get("messageLimit") as number;
  }

  if (argumentsMap.get("sortOrder") !== undefined && argumentsMap.get("sortOrder") !== null) {
    messageSearchParams.sortOrder = argumentsMap.get("sortOrder") as V2NIMSortOrder;
  }

  if (argumentsMap.get("p2pAccountIds") !== undefined && argumentsMap.get("p2pAccountIds") !== null) {
    messageSearchParams.p2pAccountIds = argumentsMap.get("p2pAccountIds") as string[];
  }

  if (argumentsMap.get("teamIds") !== undefined && argumentsMap.get("teamIds") !== null) {
    messageSearchParams.teamIds = argumentsMap.get("teamIds") as string[];
  }

  if (argumentsMap.get("senderAccountIds") !== undefined && argumentsMap.get("senderAccountIds") !== null) {
    messageSearchParams.senderAccountIds = argumentsMap.get("senderAccountIds") as string[];
  }

  if (argumentsMap.get("messageTypes") !== undefined && argumentsMap.get("messageTypes") !== null) {
    messageSearchParams.messageTypes = argumentsMap.get("messageTypes") as V2NIMMessageType[];
  }

  if (argumentsMap.get("messageSubtypes") !== undefined && argumentsMap.get("messageSubtypes") !== null) {
    messageSearchParams.messageSubtypes = argumentsMap.get("messageSubtypes") as number[];
  }

  return messageSearchParams;
}