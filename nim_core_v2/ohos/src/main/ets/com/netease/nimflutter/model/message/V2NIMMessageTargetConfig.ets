import { V2NIMMessageTargetConfig } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageTargetConfig(argumentsMap: Map<string, Any>): V2NIMMessageTargetConfig {
  let messageTargetConfig: V2NIMMessageTargetConfig = {
    receiverIds: [],
    inclusive: false,
    newMemberVisible: undefined
  };

  if (argumentsMap.get("receiverIds") !== undefined && argumentsMap.get("receiverIds") !== null) {
    messageTargetConfig.receiverIds = argumentsMap.get("receiverIds") as string[];
  }

  if (argumentsMap.get("inclusive") !== undefined && argumentsMap.get("inclusive") !== null) {
    messageTargetConfig.inclusive = argumentsMap.get("inclusive") as boolean;
  }

  if (argumentsMap.get("newMemberVisible") !== undefined && argumentsMap.get("newMemberVisible") !== null) {
    messageTargetConfig.newMemberVisible = argumentsMap.get("newMemberVisible") as boolean;
  }

  return messageTargetConfig;
}