import { V2NIMError } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/types'
import { logger } from './logger'
import { NIMResult, ServiceName } from './types'
import { V2NIMMessage } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMMessageService'
import { V2NIMConversation } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMConversationService'
import { V2NIMAIModelRoleType } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMAIService'
import { V2NIMConst } from 'nim-web-sdk-ng'

export const successRes = <T>(data?: T): NIMResult<T> => {
  return {
    code: 0,
    data,
  }
}

export const failRes = (error: V2NIMError): NIMResult<never> => {
  return {
    code: error.code ?? -1,
    errorDetails: error.desc + '' || '',
    errorMsg: error.toString ? error.toString() : error,
  }
}

export const formatV2Message = (msg: V2NIMMessage): V2NIMMessage => {
  return {
    ...msg,
    attachment: msg.attachment
      ? {
          ...msg.attachment,
          nimCoreMessageType: msg.messageType,
        }
      : void 0,
  }
}

export const formatV2ConversationLastMessage = (
  conversation: V2NIMConversation
): V2NIMConversation => {
  return {
    ...conversation,
    lastMessage: conversation.lastMessage
      ? {
          ...conversation.lastMessage,
          attachment: conversation.lastMessage.attachment
            ? {
                ...conversation.lastMessage.attachment,
                nimCoreMessageType: conversation.lastMessage.messageType,
              }
            : void 0,
        }
      : void 0,
  }
}

export const enum NIMAIModelRoleType {
  system = 0,
  user = 1,
  assistant = 2,
}

export const formatAIModelRoleType = (
  role: NIMAIModelRoleType
): V2NIMAIModelRoleType => {
  switch (role) {
    case NIMAIModelRoleType.system:
      return V2NIMConst.V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_SYSTEM
    case NIMAIModelRoleType.user:
      return V2NIMConst.V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_USER
    case NIMAIModelRoleType.assistant:
      return V2NIMConst.V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_ASSISTANT
  }
}

export const emit = <T>(
  serviceName: ServiceName,
  methodName: string,
  params: T
) => {
  logger.log('emit: ', { serviceName, methodName, params })
  if (!window.__yx_emit__) {
    window.__yx_emit__ = (serviceName, methodName, params) => {
      return { serviceName, methodName, params }
    }
  }
  return window.__yx_emit__(serviceName, methodName, params)
}
