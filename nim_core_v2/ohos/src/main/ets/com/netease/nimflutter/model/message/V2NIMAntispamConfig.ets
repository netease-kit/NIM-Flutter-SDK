import { V2NIMAntispamConfig } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2AntispamConfig(argumentsMap: Map<string, Any>): V2NIMAntispamConfig {
  let antispamConfig: V2NIMAntispamConfig = {
    antispamBusinessId: ""
  };

  if (argumentsMap.get("antispamBusinessId") !== undefined && argumentsMap.get("antispamBusinessId") !== null) {
    antispamConfig.antispamBusinessId = argumentsMap.get("antispamBusinessId") as string;
  }

  return antispamConfig;
}