import { V2NIMSendMessageParams } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertMap2MessageAIConfig } from './V2NIMMessageAIConfig';
import { convertMap2MessageAIConfigParams } from './V2NIMMessageAIConfigParams';
import { convertMap2MessageAntispamConfig } from './V2NIMMessageAntispamConfig';
import { convertMap2MessageConfig } from './V2NIMMessageConfig';
import { convertMap2MessagePushConfig } from './V2NIMMessagePushConfig';
import { convertMap2MessageRobotConfig } from './V2NIMMessageRobotConfig';
import { convertMap2MessageRouteConfig } from './V2NIMMessageRouteConfig';
import { convertMap2MessageTargetConfig } from './V2NIMMessageTargetConfig';

export function convertMap2SendMessageParams(argumentsMap: Map<string, Any>): V2NIMSendMessageParams {
  let sendMessageParams: V2NIMSendMessageParams = {
    messageConfig: undefined,
    pushConfig: undefined,
    routeConfig: undefined,
    antispamConfig: undefined,
    robotConfig: undefined,
    aiConfig: undefined,
    targetConfig: undefined,
    clientAntispamEnabled: undefined,
    clientAntispamReplace: undefined
  };

  if (argumentsMap.get("messageConfig") !== undefined && argumentsMap.get("messageConfig") !== null) {
    sendMessageParams.messageConfig = convertMap2MessageConfig(argumentsMap.get("messageConfig") as Map<string, Any>);
  }

  if (argumentsMap.get("pushConfig") !== undefined && argumentsMap.get("pushConfig") !== null) {
    sendMessageParams.pushConfig = convertMap2MessagePushConfig(argumentsMap.get("pushConfig") as Map<string, Any>);
  }

  if (argumentsMap.get("routeConfig") !== undefined && argumentsMap.get("routeConfig") !== null) {
    sendMessageParams.routeConfig = convertMap2MessageRouteConfig(argumentsMap.get("routeConfig") as Map<string, Any>);
  }

  if (argumentsMap.get("antispamConfig") !== undefined && argumentsMap.get("antispamConfig") !== null) {
    sendMessageParams.antispamConfig =
      convertMap2MessageAntispamConfig(argumentsMap.get("antispamConfig") as Map<string, Any>);
  }

  if (argumentsMap.get("robotConfig") !== undefined && argumentsMap.get("robotConfig") !== null) {
    sendMessageParams.robotConfig = convertMap2MessageRobotConfig(argumentsMap.get("robotConfig") as Map<string, Any>);
  }

  if (argumentsMap.get("aiConfig") !== undefined && argumentsMap.get("aiConfig") !== null) {
    sendMessageParams.aiConfig = convertMap2MessageAIConfigParams(argumentsMap.get("aiConfig") as Map<string, Any>);
  }

  if (argumentsMap.get("targetConfig") !== undefined && argumentsMap.get("targetConfig") !== null) {
    sendMessageParams.targetConfig =
      convertMap2MessageTargetConfig(argumentsMap.get("targetConfig") as Map<string, Any>);
  }

  if (argumentsMap.get("clientAntispamEnabled") !== undefined && argumentsMap.get("clientAntispamEnabled") !== null) {
    sendMessageParams.clientAntispamEnabled = argumentsMap.get("clientAntispamEnabled") as boolean;
  }

  if (argumentsMap.get("clientAntispamReplace") !== undefined && argumentsMap.get("clientAntispamReplace") !== null) {
    sendMessageParams.clientAntispamReplace = argumentsMap.get("clientAntispamReplace") as string;
  }

  return sendMessageParams;
}