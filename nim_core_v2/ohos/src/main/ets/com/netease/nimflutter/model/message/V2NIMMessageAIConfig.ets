import { V2NIMAIRAGInfo, V2NIMMessageAIConfig, V2NIMMessageAIStatus, V2NIMMessageAIStreamStatus } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertMap2MessageAIStreamChunk } from './V2NIMMessageAIStreamChunk';

export function convertMap2MessageAIConfig(argumentsMap: Map<string, Any>): V2NIMMessageAIConfig {
  let messageAIConfig: V2NIMMessageAIConfig = {
    accountId: "",
    aiStatus: V2NIMMessageAIStatus.V2NIM_MESSAGE_AI_STATUS_UNKNOWN,
    aiStream: false,
    aiStreamStatus: V2NIMMessageAIStreamStatus.V2NIM_MESSAGE_AI_STREAM_STATUS_NONE
  };

  if (argumentsMap.get("accountId") !== undefined && argumentsMap.get("accountId") !== null) {
    messageAIConfig.accountId = argumentsMap.get("accountId") as string;
  }

  if (argumentsMap.get("aiStatus") !== undefined && argumentsMap.get("aiStatus") !== null) {
    messageAIConfig.aiStatus = argumentsMap.get("aiStatus") as V2NIMMessageAIStatus;
  }

  if (argumentsMap.get("aiRAGs") !== undefined && argumentsMap.get("aiRAGs") !== null) {
    messageAIConfig.aiRAGs = argumentsMap.get("aiRAGs") as V2NIMAIRAGInfo[];
  }

  if (argumentsMap.get("aiStream") !== undefined && argumentsMap.get("aiStream") !== null) {
    messageAIConfig.aiStream = argumentsMap.get("aiStream") as boolean;
  }

  if (argumentsMap.get("aiStreamStatus") !== undefined && argumentsMap.get("aiStreamStatus") !== null) {
    messageAIConfig.aiStreamStatus = argumentsMap.get("aiStreamStatus") as V2NIMMessageAIStreamStatus;
  }

  if (argumentsMap.get("aiStreamLastChunk") !== undefined && argumentsMap.get("aiStreamLastChunk") !== null) {
    messageAIConfig.aiStreamLastChunk =
      convertMap2MessageAIStreamChunk(argumentsMap.get("aiStreamLastChunk") as Map<string, Any>);
  }

  return messageAIConfig;
}