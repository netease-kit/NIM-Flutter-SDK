import {
  V2NIMMessageSearchExParams,
  V2NIMMessageType,
  V2NIMSearchDirection,
  V2NIMSearchKeywordMathType,
  V2NIMSearchStrategy
} from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageSearchExParams(argumentsMap: Map<string, Any>): V2NIMMessageSearchExParams {
  let messageSearchExParams: V2NIMMessageSearchExParams = {};

  if (argumentsMap.get("conversationId") !== undefined && argumentsMap.get("conversationId") !== null) {
    messageSearchExParams.conversationId = argumentsMap.get("conversationId") as string;
  }

  if (argumentsMap.get("keywordList") !== undefined && argumentsMap.get("keywordList") !== null) {
    messageSearchExParams.keywordList = argumentsMap.get("keywordList") as string[];
  }

  if (argumentsMap.get("keywordMatchType") !== undefined && argumentsMap.get("keywordMatchType") !== null) {
    messageSearchExParams.keywordMatchType = argumentsMap.get("keywordMatchType") as V2NIMSearchKeywordMathType;
  }

  if (argumentsMap.get("senderAccountIds") !== undefined && argumentsMap.get("senderAccountIds") !== null) {
    messageSearchExParams.senderAccountIds = argumentsMap.get("senderAccountIds") as string[];
  }

  if (argumentsMap.get("messageTypes") !== undefined && argumentsMap.get("messageTypes") !== null) {
    messageSearchExParams.messageTypes = argumentsMap.get("messageTypes") as V2NIMMessageType[];
  }

  if (argumentsMap.get("messageSubtypes") !== undefined && argumentsMap.get("messageSubtypes") !== null) {
    messageSearchExParams.messageSubtypes = argumentsMap.get("messageSubtypes") as number[];
  }

  if (argumentsMap.get("searchStartTime") !== undefined && argumentsMap.get("searchStartTime") !== null) {
    messageSearchExParams.searchStartTime = argumentsMap.get("searchStartTime") as number;
  }

  if (argumentsMap.get("searchTimePeriod") !== undefined && argumentsMap.get("searchTimePeriod") !== null) {
    messageSearchExParams.searchTimePeriod = argumentsMap.get("searchTimePeriod") as number;
  }

  if (argumentsMap.get("limit") !== undefined && argumentsMap.get("limit") !== null) {
    messageSearchExParams.limit = argumentsMap.get("limit") as number;
  }

  if (argumentsMap.get("direction") !== undefined && argumentsMap.get("direction") !== null) {
    messageSearchExParams.direction = argumentsMap.get("direction") as V2NIMSearchDirection;
  }

  if (argumentsMap.get("strategy") !== undefined && argumentsMap.get("strategy") !== null) {
    messageSearchExParams.strategy = argumentsMap.get("strategy") as V2NIMSearchStrategy;
  }

  if (argumentsMap.get("pageToken") !== undefined && argumentsMap.get("pageToken") !== null) {
    messageSearchExParams.pageToken = argumentsMap.get("pageToken") as string;
  }

  return messageSearchExParams;
}