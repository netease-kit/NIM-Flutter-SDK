import { V2NIMMessageAIStreamChunk } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageAIStreamChunk(argumentsMap: Map<string, Any>): V2NIMMessageAIStreamChunk {
  let messageAIStreamChunk: V2NIMMessageAIStreamChunk = {
    content: "",
    messageTime: 0,
    chunkTime: 0,
    type: 0,
    index: 0
  };

  if (argumentsMap.get("content") !== undefined && argumentsMap.get("content") !== null) {
    messageAIStreamChunk.content = argumentsMap.get("content") as string;
  }

  if (argumentsMap.get("messageTime") !== undefined && argumentsMap.get("messageTime") !== null) {
    messageAIStreamChunk.messageTime = argumentsMap.get("messageTime") as number;
  }

  if (argumentsMap.get("chunkTime") !== undefined && argumentsMap.get("chunkTime") !== null) {
    messageAIStreamChunk.chunkTime = argumentsMap.get("chunkTime") as number;
  }

  if (argumentsMap.get("type") !== undefined && argumentsMap.get("type") !== null) {
    messageAIStreamChunk.type = argumentsMap.get("type") as number;
  }

  if (argumentsMap.get("index") !== undefined && argumentsMap.get("index") !== null) {
    messageAIStreamChunk.index = argumentsMap.get("index") as number;
  }

  return messageAIStreamChunk;
}