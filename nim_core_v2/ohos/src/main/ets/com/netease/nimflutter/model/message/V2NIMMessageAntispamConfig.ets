import { V2NIMMessageAntispamConfig } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageAntispamConfig(argumentsMap: Map<string, Any>): V2NIMMessageAntispamConfig {
  let messageAntispamConfig: V2NIMMessageAntispamConfig = {};

  if (argumentsMap.get("antispamEnabled") !== undefined && argumentsMap.get("antispamEnabled") !== null) {
    messageAntispamConfig.antispamEnabled = argumentsMap.get("antispamEnabled") as boolean;
  }

  if (argumentsMap.get("antispamBusinessId") !== undefined && argumentsMap.get("antispamBusinessId") !== null) {
    messageAntispamConfig.antispamBusinessId = argumentsMap.get("antispamBusinessId") as string;
  }

  if (argumentsMap.get("antispamCustomMessage") !== undefined && argumentsMap.get("antispamCustomMessage") !== null) {
    messageAntispamConfig.antispamCustomMessage = argumentsMap.get("antispamCustomMessage") as string;
  }

  if (argumentsMap.get("antispamCheating") !== undefined && argumentsMap.get("antispamCheating") !== null) {
    messageAntispamConfig.antispamCheating = argumentsMap.get("antispamCheating") as string;
  }

  if (argumentsMap.get("antispamExtension") !== undefined && argumentsMap.get("antispamExtension") !== null) {
    messageAntispamConfig.antispamExtension = argumentsMap.get("antispamExtension") as string;
  }

  return messageAntispamConfig;
}