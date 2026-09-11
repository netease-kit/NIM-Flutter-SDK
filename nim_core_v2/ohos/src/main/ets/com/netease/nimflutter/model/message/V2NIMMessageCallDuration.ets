import { V2NIMMessageCallDuration } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageCallDuration(argumentsMap: Map<string, Any>): V2NIMMessageCallDuration {
  let messageCallDuration: V2NIMMessageCallDuration = {
    accountId: "",
    duration: 0
  };

  if (argumentsMap.get("accountId") !== undefined && argumentsMap.get("accountId") !== null) {
    messageCallDuration.accountId = argumentsMap.get("accountId") as string;
  }

  if (argumentsMap.get("duration") !== undefined && argumentsMap.get("duration") !== null) {
    messageCallDuration.duration = argumentsMap.get("duration") as number;
  }

  return messageCallDuration;
}