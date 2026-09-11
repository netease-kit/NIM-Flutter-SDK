import { V2NIMMessageStreamConfig, V2NIMMessageStreamStatus } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertMap2MessageStreamChunk } from './V2NIMMessageStreamChunk';

export function convertMap2MessageStreamConfig(argumentsMap: Map<string, Any>): V2NIMMessageStreamConfig {
  let messageStreamConfig: V2NIMMessageStreamConfig = {
    status: V2NIMMessageStreamStatus.V2NIM_MESSAGE_STREAM_STATUS_NONE,
    lastChunk: undefined
  };

  if (argumentsMap.get("status") !== undefined && argumentsMap.get("status") !== null) {
    messageStreamConfig.status = argumentsMap.get("status") as V2NIMMessageStreamStatus;
  }

  if (argumentsMap.get("lastChunk") !== undefined && argumentsMap.get("lastChunk") !== null) {
    const lastChunkMap: Map<string, Any> = argumentsMap.get("lastChunk") as Map<string, Any>;
    messageStreamConfig.lastChunk = convertMap2MessageStreamChunk(lastChunkMap);
  }

  return messageStreamConfig;
}