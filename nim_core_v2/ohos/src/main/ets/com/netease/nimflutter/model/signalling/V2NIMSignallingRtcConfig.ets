import { V2NIMSignallingRtcConfig } from '@nimsdk/base';

export function convertMap2SignallingRtcConfig(argumentsMap: Map<string, undefined | boolean | number | null | string>): V2NIMSignallingRtcConfig {

  let rtcConfig: V2NIMSignallingRtcConfig = {};


  if (argumentsMap.get("rtcChannelName") !== undefined && argumentsMap.get("rtcChannelName") !== null) {
    rtcConfig.rtcChannelName = argumentsMap.get("rtcChannelName") as string;
  }

  if (argumentsMap.get("rtcParams") !== undefined && argumentsMap.get("rtcParams") !== null) {
    rtcConfig.rtcParams = argumentsMap.get("rtcParams") as string;
  }

  if (argumentsMap.get("rtcTokenTtl") !== undefined && argumentsMap.get("rtcTokenTtl") !== null) {
    rtcConfig.rtcTokenTtl = argumentsMap.get("rtcTokenTtl") as number;
  }


  return rtcConfig;
}