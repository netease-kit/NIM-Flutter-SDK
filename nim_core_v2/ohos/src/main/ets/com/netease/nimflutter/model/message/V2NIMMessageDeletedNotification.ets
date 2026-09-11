import { V2NIMMessageDeletedNotification } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertMap2MessageRefer } from './V2NIMMessageRefer';

export function convertMap2ClearHistoryNotification(argumentsMap: Map<string, Any>): V2NIMMessageDeletedNotification {
  let notification: V2NIMMessageDeletedNotification = {
    messageRefer: convertMap2MessageRefer(argumentsMap),
    deleteTime: 0,
    serverExtension: undefined,
  };

  if (argumentsMap.get("messageRefer") !== undefined && argumentsMap.get("messageRefer") !== null) {
    notification.messageRefer = convertMap2MessageRefer(argumentsMap.get("messageRefer") as Map<string, Any>);
  }

  if (argumentsMap.get("deleteTime") !== undefined && argumentsMap.get("deleteTime") !== null) {
    notification.deleteTime = argumentsMap.get("deleteTime") as number;
  }

  if (argumentsMap.get("serverExtension") !== undefined && argumentsMap.get("serverExtension") !== null) {
    notification.serverExtension = argumentsMap.get("serverExtension") as string;
  }

  return notification;
}