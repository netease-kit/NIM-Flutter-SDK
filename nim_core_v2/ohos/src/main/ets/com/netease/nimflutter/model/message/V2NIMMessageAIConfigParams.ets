import {
  V2NIMAIModelCallContent,
  V2NIMAIModelCallMessage,
  V2NIMAIModelConfigParams,
  V2NIMAIModelRoleType,
  V2NIMAIRAGInfo, V2NIMMessageAIConfig,
  V2NIMMessageAIConfigParams,
  V2NIMMessageAIStatus, V2NIMMessageAIStreamStatus } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertMap2MessageAIStreamChunk } from './V2NIMMessageAIStreamChunk';

function convertMap2AIModelCallContent(argumentsMap: Map<string, Any>): V2NIMAIModelCallContent {
	let content:V2NIMAIModelCallContent = {
    msg:"",
    type:0
  }
  if(argumentsMap.get("msg") !== undefined && argumentsMap.get("msg") !== null){
    content.msg = argumentsMap.get("msg") as string
  }
  if(argumentsMap.get("type") !== undefined && argumentsMap.get("type") !== null)
  {
    content.type = argumentsMap.get("type") as number;
  }
  return content
}

function  convertMap2NIMAIModelConfigParams(argumentsMap:Map<string,Any>):V2NIMAIModelConfigParams{
  let configParams:V2NIMAIModelConfigParams = {}

  if(argumentsMap.get("prompt") !== undefined && argumentsMap.get("prompt") !== null){
    configParams.prompt = argumentsMap.get("prompt") as string
  }

  if(argumentsMap.get("topP") !== undefined && argumentsMap.get("topP") !== null){
    configParams.topP = argumentsMap.get("topP") as number
  }

  if(argumentsMap.get("temperature") !== undefined && argumentsMap.get("temperature") !== null){
    configParams.temperature = argumentsMap.get("temperature") as number
  }
  if(argumentsMap.get("maxTokens") !== undefined && argumentsMap.get("maxTokens") !== null){
    configParams.maxTokens = argumentsMap.get("maxTokens") as number
  }

  return configParams;
}

function  convertToV2NIMAIModelRoleType(role: number | undefined | null) {
  if (role == 0) {
    return V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_SYSTEM
  } else if (role == 1) {
    return V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_USER
  } else if (role == 2) {
    return V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_ASSISTANT
  } else {
    return V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_SYSTEM
  }
}

function  convertToAIModelCallMessage(map: Map<string, Any>): V2NIMAIModelCallMessage {
  return {
    role: convertToV2NIMAIModelRoleType(map.get("role") as number),
    msg: map.get("msg") as string,
    type: map.get("type") as number
  };
}

export function convertMap2MessageAIConfigParams(argumentsMap: Map<string, Any>): V2NIMMessageAIConfigParams {
  let messageAIConfig: V2NIMMessageAIConfigParams = {
    accountId: "",
    aiStream: false,
  };

  if (argumentsMap.get("accountId") !== undefined && argumentsMap.get("accountId") !== null) {
    messageAIConfig.accountId = argumentsMap.get("accountId") as string;
  }

  if (argumentsMap.get("content") !== undefined && argumentsMap.get("content") !== null) {
    messageAIConfig.content =  convertMap2AIModelCallContent(argumentsMap.get("content") as Map<string, Any>);
  }

  if (argumentsMap.get("messages") !== undefined && argumentsMap.get("messages") !== null) {
    messageAIConfig.messages = (argumentsMap.get("messages") as Array<Map<string, object>>).map(msg => convertToAIModelCallMessage(msg));
  }

  if (argumentsMap.get("promptVariables") !== undefined && argumentsMap.get("promptVariables") !== null) {
    messageAIConfig.promptVariables = argumentsMap.get("promptVariables") as string;
  }

  if (argumentsMap.get("modelConfigParams") !== undefined && argumentsMap.get("modelConfigParams") !== null) {
    messageAIConfig.modelConfigParams = convertMap2NIMAIModelConfigParams(argumentsMap.get("modelConfigParams") as Map<string, Any>);
  }

  if (argumentsMap.get("aiStream") !== undefined && argumentsMap.get("aiStream") !== null) {
    messageAIConfig.aiStream = argumentsMap.get("aiStream") as boolean;
  }

  return messageAIConfig;
}