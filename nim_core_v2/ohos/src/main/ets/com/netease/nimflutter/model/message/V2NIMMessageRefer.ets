import { V2NIMConversationType, V2NIMMessageRefer } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageRefer(argumentsMap: Map<string, Any> | undefined): V2NIMMessageRefer {
  let messageRefer: V2NIMMessageRefer = {
    senderId: "",
    receiverId: "",
    messageClientId: "",
    messageServerId: "",
    createTime: 0,
    conversationType: V2NIMConversationType.V2NIM_CONVERSATION_TYPE_UNKNOWN,
    conversationId: ""
  };

  if (argumentsMap === undefined) {
    return messageRefer;
  }

  if (argumentsMap.get("senderId") !== undefined && argumentsMap.get("senderId") !== null) {
    messageRefer.senderId = argumentsMap.get("senderId") as string;
  }

  if (argumentsMap.get("receiverId") !== undefined && argumentsMap.get("receiverId") !== null) {
    messageRefer.receiverId = argumentsMap.get("receiverId") as string;
  }

  if (argumentsMap.get("messageClientId") !== undefined && argumentsMap.get("messageClientId") !== null) {
    messageRefer.messageClientId = argumentsMap.get("messageClientId") as string;
  }

  if (argumentsMap.get("messageServerId") !== undefined && argumentsMap.get("messageServerId") !== null) {
    messageRefer.messageServerId = argumentsMap.get("messageServerId") as string;
  }

  if (argumentsMap.get("createTime") !== undefined && argumentsMap.get("createTime") !== null) {
    messageRefer.createTime = argumentsMap.get("createTime") as number;
  }

  if (argumentsMap.get("conversationType") !== undefined && argumentsMap.get("conversationType") !== null) {
    messageRefer.conversationType = argumentsMap.get("conversationType") as V2NIMConversationType;
  }

  if (argumentsMap.get("conversationId") !== undefined && argumentsMap.get("conversationId") !== null) {
    messageRefer.conversationId = argumentsMap.get("conversationId") as string;
  }

  return messageRefer;
}