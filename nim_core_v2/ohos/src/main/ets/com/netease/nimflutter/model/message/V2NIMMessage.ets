import {
  V2NIMConversationType,
  V2NIMMessage,
  V2NIMMessageAttachmentUploadState,
  V2NIMMessageSendingState,
  V2NIMMessageType,
  V2NIMLoginClientType
} from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertMap2MessageAttachment } from './messageAttachment/V2NIMMessageAttachment';
import { convertMap2MessageAudioAttachment } from './messageAttachment/V2NIMMessageAudioAttachment';
import { convertMap2MessageCallAttachment } from './messageAttachment/V2NIMMessageCallAttachment';
import { convertMap2MessageFileAttachment } from './messageAttachment/V2NIMMessageFileAttachment';
import { convertMap2MessageImageAttachment } from './messageAttachment/V2NIMMessageImageAttachment';
import { convertMap2MessageLocationAttachment } from './messageAttachment/V2NIMMessageLocationAttachment';
import { convertMap2MessageNotificationAttachment } from './messageAttachment/V2NIMMessageNotificationAttachment';
import { convertMap2MessageVideoAttachment } from './messageAttachment/V2NIMMessageVideoAttachment';
import { convertMap2MessageAIConfig } from './V2NIMMessageAIConfig';
import { convertMap2MessageAntispamConfig } from './V2NIMMessageAntispamConfig';
import { convertMap2MessageConfig } from './V2NIMMessageConfig';
import { convertMap2MessagePushConfig } from './V2NIMMessagePushConfig';
import { convertMap2MessageRefer } from './V2NIMMessageRefer';
import { convertMap2MessageRobotConfig } from './V2NIMMessageRobotConfig';
import { convertMap2MessageRouteConfig } from './V2NIMMessageRouteConfig';
import { convertMap2MessageStatus } from './V2NIMMessageStatus';
import { convertMap2MessageStreamConfig } from './V2NIMMessageStreamConfig';
import { convertAttachmentToMap } from '../message/messageAttachment/V2NIMMessageAttachment';

export function convertMap2Message(argumentsMap: Map<string, Any> | undefined): V2NIMMessage {
  let message: V2NIMMessage = {
    messageClientId: "",
    messageServerId: "",
    createTime: 0,
    senderId: "",
    receiverId: "",
    conversationType: V2NIMConversationType.V2NIM_CONVERSATION_TYPE_UNKNOWN,
    conversationId: "",
    isSelf: false,
    sendingState: V2NIMMessageSendingState.V2NIM_MESSAGE_SENDING_STATE_UNKNOWN,
    messageType: V2NIMMessageType.V2NIM_MESSAGE_TYPE_INVALID,
    messageStatus: {
      errorCode: 0
    },
    fromClientType: V2NIMLoginClientType.V2NIM_LOGIN_CLIENT_TYPE_UNKNOWN
  }

  if (argumentsMap === undefined || argumentsMap === null) {
    return message
  }

  if (argumentsMap.get("messageClientId") !== undefined && argumentsMap.get("messageClientId") != null) {
    message.messageClientId = argumentsMap.get("messageClientId") as string
  }
  if (argumentsMap.get("messageClientId") !== undefined && argumentsMap.get("messageClientId") != null) {
    message.messageClientId = argumentsMap.get("messageClientId") as string
  }

  if (argumentsMap.get("messageServerId") !== undefined && argumentsMap.get("messageServerId") != null) {
    message.messageServerId = argumentsMap.get("messageServerId") as string
  }

  if (argumentsMap.get("createTime") !== undefined && argumentsMap.get("createTime") != null) {
    message.createTime = argumentsMap.get("createTime") as number
  }

  if (argumentsMap.get("senderId") !== undefined && argumentsMap.get("senderId") != null) {
    message.senderId = argumentsMap.get("senderId") as string
  }

  if (argumentsMap.get("receiverId") !== undefined && argumentsMap.get("receiverId") != null) {
    message.receiverId = argumentsMap.get("receiverId") as string
  }

  if (argumentsMap.get("conversationType") !== undefined && argumentsMap.get("conversationType") != null) {
    message.conversationType = argumentsMap.get("conversationType") as V2NIMConversationType
  }

  if (argumentsMap.get("conversationId") !== undefined && argumentsMap.get("conversationId") != null) {
    message.conversationId = argumentsMap.get("conversationId") as string
  }

  if (argumentsMap.get("isSelf") !== undefined && argumentsMap.get("isSelf") != null) {
    message.isSelf = argumentsMap.get("isSelf") as boolean
  }

  if (argumentsMap.get("attachmentUploadState") !== undefined && argumentsMap.get("attachmentUploadState") != null) {
    message.attachmentUploadState = argumentsMap.get("attachmentUploadState") as V2NIMMessageAttachmentUploadState
  }

  if (argumentsMap.get("sendingState") !== undefined && argumentsMap.get("sendingState") != null) {
    message.sendingState = argumentsMap.get("sendingState") as V2NIMMessageSendingState
  }

  if (argumentsMap.get("messageType") !== undefined && argumentsMap.get("messageType") != null) {
    message.messageType = argumentsMap.get("messageType") as number
  }

  if (argumentsMap.get("subType") !== undefined && argumentsMap.get("subType") != null) {
    message.subType = argumentsMap.get("subType") as number
  }

  if (argumentsMap.get("text") !== undefined && argumentsMap.get("text") != null) {
    message.text = argumentsMap.get("text") as string
  }

  if (argumentsMap.get("attachment") !== undefined && argumentsMap.get("attachment") != null) {
    let attachmentMap: Map<string, Any> = argumentsMap.get("attachment") as Map<string, Any>
    switch (message.messageType) {
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_AUDIO:
        message.attachment = convertMap2MessageAudioAttachment(attachmentMap)
        break
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_FILE:
        message.attachment = convertMap2MessageFileAttachment(attachmentMap)
        break
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_IMAGE:
        message.attachment = convertMap2MessageImageAttachment(attachmentMap)
        break
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_VIDEO:
        message.attachment = convertMap2MessageVideoAttachment(attachmentMap)
        break
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_LOCATION:
        message.attachment = convertMap2MessageLocationAttachment(attachmentMap)
        break
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_NOTIFICATION:
        message.attachment = convertMap2MessageNotificationAttachment(attachmentMap)
        break
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_CALL:
        message.attachment = convertMap2MessageCallAttachment(attachmentMap)
        break
      default:
        message.attachment = convertMap2MessageAttachment(attachmentMap)
        break
    }
  }

  if (argumentsMap.get("serverExtension") !== undefined && argumentsMap.get("serverExtension") != null) {
    message.serverExtension = argumentsMap.get("serverExtension") as string
  }

  if (argumentsMap.get("localExtension") !== undefined && argumentsMap.get("localExtension") != null) {
    message.localExtension = argumentsMap.get("localExtension") as string
  }

  if (argumentsMap.get("callbackExtension") !== undefined && argumentsMap.get("callbackExtension") != null) {
    message.callbackExtension = argumentsMap.get("callbackExtension") as string
  }

  if (argumentsMap.get("modifyTime") !== undefined && argumentsMap.get("modifyTime") != null) {
    message.modifyTime = argumentsMap.get("modifyTime") as number
  }

  if (argumentsMap.get("modifyAccountId") !== undefined && argumentsMap.get("modifyAccountId") != null) {
    message.modifyAccountId = argumentsMap.get("modifyAccountId") as string
  }

  if (argumentsMap.get("messageConfig") !== undefined && argumentsMap.get("messageConfig") != null) {
    message.messageConfig = convertMap2MessageConfig(argumentsMap.get("messageConfig") as Map<string, Any>)
  }

  if (argumentsMap.get("pushConfig") !== undefined && argumentsMap.get("pushConfig") != null) {
    message.pushConfig = convertMap2MessagePushConfig(argumentsMap.get("pushConfig") as Map<string, Any>)
  }

  if (argumentsMap.get("routeConfig") !== undefined && argumentsMap.get("routeConfig") != null) {
    message.routeConfig = convertMap2MessageRouteConfig(argumentsMap.get("routeConfig") as Map<string, Any>)
  }

  if (argumentsMap.get("antispamConfig") !== undefined && argumentsMap.get("antispamConfig") != null) {
    message.antispamConfig = convertMap2MessageAntispamConfig(argumentsMap.get("antispamConfig") as Map<string, Any>)
  }

  if (argumentsMap.get("robotConfig") !== undefined && argumentsMap.get("robotConfig") != null) {
    message.robotConfig = convertMap2MessageRobotConfig(argumentsMap.get("robotConfig") as Map<string, Any>)
  }

  if (argumentsMap.get("threadRoot") !== undefined && argumentsMap.get("threadRoot") != null) {
    message.threadRoot = convertMap2MessageRefer(argumentsMap.get("threadRoot") as Map<string, Any>)
  }

  if (argumentsMap.get("threadReply") !== undefined && argumentsMap.get("threadReply") != null) {
    message.threadReply = convertMap2MessageRefer(argumentsMap.get("threadReply") as Map<string, Any>)
  }

  if (argumentsMap.get("messageStatus") !== undefined && argumentsMap.get("messageStatus") != null) {
    message.messageStatus = convertMap2MessageStatus(argumentsMap.get("messageStatus") as Map<string, Any>)
  }

  if (argumentsMap.get("aiConfig") !== undefined && argumentsMap.get("aiConfig") != null) {
    message.aiConfig = convertMap2MessageAIConfig(argumentsMap.get("aiConfig") as Map<string, Any>)
  }

  if (argumentsMap.get("streamConfig") !== undefined && argumentsMap.get("streamConfig") != null) {
    message.streamConfig = convertMap2MessageStreamConfig(argumentsMap.get("streamConfig") as Map<string, Any>)
  }

  if (argumentsMap.get("fromClientType") !== undefined && argumentsMap.get("fromClientType") != null) {
    message.fromClientType = argumentsMap.get("fromClientType") as number
  }

  return message;
}

export function convertMessage2Map(result: V2NIMMessage): Map<string, Any> {
  if(result.messageConfig && result.messageConfig?.lastMessageUpdateEnabled === undefined ||
    result.messageConfig?.lastMessageUpdateEnabled === null){
    result.messageConfig.lastMessageUpdateEnabled = true
  }
  if(result.threadRoot != undefined && result.threadRoot != null){
    result.threadRoot.messageServerId = result.threadRoot.messageServerId + ""
  }

  if(result.threadReply != undefined && result.threadReply != null){
    result.threadReply.messageServerId = result.threadReply.messageServerId + ""
  }
  if(typeof result.pushConfig?.forcePushAccountIds === 'string' || typeof result.pushConfig?.forcePushAccountIds === 'number'){
    result.pushConfig.forcePushAccountIds = [result.pushConfig?.forcePushAccountIds + '']
  }
  let res: Map<string, Any> = new Map<string, Any>(Object.entries(result))
  if (result.attachment) {
    const attachment: Map<string, Any> | undefined =
      convertAttachmentToMap(result.attachment, result.messageType)
    if (attachment) {
      res.set("attachment", attachment)
    }
  }
  if(result.messageServerId !== undefined && result.messageServerId !== null){
    res.set("messageServerId",result.messageServerId + "")
  }
  return res
}