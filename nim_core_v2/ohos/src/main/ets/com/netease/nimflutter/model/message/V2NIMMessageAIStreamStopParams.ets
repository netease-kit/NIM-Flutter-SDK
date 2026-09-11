import { V2NIMMessageAIStreamStopOpType, V2NIMMessageAIStreamStopParams } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageAIStreamStopParams(argumentsMap: Map<string, Any>): V2NIMMessageAIStreamStopParams {
  let messageAIStreamStopParams: V2NIMMessageAIStreamStopParams = {
    operationType: V2NIMMessageAIStreamStopOpType.V2NIM_MESSAGE_AI_STREAM_STOP_OP_DEFAULT
  };

  if (argumentsMap.get("updateContent") !== undefined && argumentsMap.get("updateContent") !== null) {
    messageAIStreamStopParams.updateContent = argumentsMap.get("updateContent") as string;
  }

  if (argumentsMap.get("operationType") !== undefined && argumentsMap.get("operationType") !== null) {
    messageAIStreamStopParams.operationType = argumentsMap.get("operationType") as V2NIMMessageAIStreamStopOpType;
  }

  return messageAIStreamStopParams;
}