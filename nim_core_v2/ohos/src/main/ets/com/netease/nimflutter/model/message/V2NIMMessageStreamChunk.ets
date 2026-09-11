import { V2NIMMessageStreamChunk } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageStreamChunk(argumentsMap: Map<string, Any>): V2NIMMessageStreamChunk {
  let messageStreamChunk: V2NIMMessageStreamChunk = {
    content: "",
    messageTime: 0,
    chunkTime: 0,
    type: 0,
    index: 0
  };

  if (argumentsMap.get("content") !== undefined && argumentsMap.get("content") !== null) {
    messageStreamChunk.content = argumentsMap.get("content") as string;
  }

  if (argumentsMap.get("messageTime") !== undefined && argumentsMap.get("messageTime") !== null) {
    messageStreamChunk.messageTime = argumentsMap.get("messageTime") as number;
  }

  if (argumentsMap.get("chunkTime") !== undefined && argumentsMap.get("chunkTime") !== null) {
    messageStreamChunk.chunkTime = argumentsMap.get("chunkTime") as number;
  }

  if (argumentsMap.get("type") !== undefined && argumentsMap.get("type") !== null) {
    messageStreamChunk.type = argumentsMap.get("type") as number;
  }

  if (argumentsMap.get("index") !== undefined && argumentsMap.get("index") !== null) {
    messageStreamChunk.index = argumentsMap.get("index") as number;
  }

  return messageStreamChunk;
}