import { V2NIMVoiceToTextParams } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2VoiceToTextParams(argumentsMap: Map<string, Any>): V2NIMVoiceToTextParams {
  let voiceToTextParams: V2NIMVoiceToTextParams = {
    voicePath: undefined,
    voiceUrl: undefined,
    duration: 0,
    mimeType: undefined,
    sampleRate: undefined,
    sceneName: undefined
  };

  if (argumentsMap.get("voicePath") !== undefined && argumentsMap.get("voicePath") !== null) {
    voiceToTextParams.voicePath = argumentsMap.get("voicePath") as string;
  }

  if (argumentsMap.get("voiceUrl") !== undefined && argumentsMap.get("voiceUrl") !== null) {
    voiceToTextParams.voiceUrl = argumentsMap.get("voiceUrl") as string;
  }

  if (argumentsMap.get("duration") !== undefined && argumentsMap.get("duration") !== null) {
    voiceToTextParams.duration = argumentsMap.get("duration") as number;
  }

  if (argumentsMap.get("mimeType") !== undefined && argumentsMap.get("mimeType") !== null) {
    voiceToTextParams.mimeType = argumentsMap.get("mimeType") as string;
  }

  if (argumentsMap.get("sampleRate") !== undefined && argumentsMap.get("sampleRate") !== null) {
    voiceToTextParams.sampleRate = argumentsMap.get("sampleRate") as string;
  }

  if (argumentsMap.get("sceneName") !== undefined && argumentsMap.get("sceneName") !== null) {
    voiceToTextParams.sceneName = argumentsMap.get("sceneName") as string;
  }

  return voiceToTextParams;
}