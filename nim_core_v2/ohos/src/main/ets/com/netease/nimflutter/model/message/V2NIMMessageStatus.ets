import { V2NIMMessageStatus } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageStatus(argumentsMap: Map<string, Any> | undefined): V2NIMMessageStatus {
  let messageStatus: V2NIMMessageStatus = {
    errorCode: 0
  };

  if (argumentsMap === undefined) {
    return messageStatus;
  }

  if (argumentsMap.get("errorCode") !== undefined && argumentsMap.get("errorCode") !== null) {
    messageStatus.errorCode = argumentsMap.get("errorCode") as number;
  }

  if (argumentsMap.get("readReceiptSent") !== undefined && argumentsMap.get("readReceiptSent") !== null) {
    messageStatus.readReceiptSent = argumentsMap.get("readReceiptSent") as boolean;
  }

  return messageStatus;
}