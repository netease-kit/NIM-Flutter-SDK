import { V2NIMMessageAIRegenOpType, V2NIMMessageAIRegenParams } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageAIRegenParams(argumentsMap: Map<string, Any>): V2NIMMessageAIRegenParams {
  let messageAIRegenParams: V2NIMMessageAIRegenParams = {
    operationType: V2NIMMessageAIRegenOpType.V2NIM_MESSAGE_AI_REGEN_OP_UPDATE
  };

  if (argumentsMap.get("operationType") !== undefined && argumentsMap.get("operationType") !== null) {
    messageAIRegenParams.operationType = argumentsMap.get("operationType") as V2NIMMessageAIRegenOpType;
  }

  return messageAIRegenParams;
}