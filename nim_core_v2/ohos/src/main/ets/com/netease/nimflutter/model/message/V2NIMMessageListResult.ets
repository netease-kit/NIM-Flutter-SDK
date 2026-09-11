import { V2NIMMessageListResult } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertMessage2Map } from './V2NIMMessage';


export function convertMessageListResult2Map(result: V2NIMMessageListResult): Map<string, Any> {
  let resMap: Map<string, Any> = new Map<string, Any>(Object.entries(result))
  resMap.set("messages", result.messages.map((message) => convertMessage2Map(message)))
  if (result.anchorMessage) {
    resMap.set("anchorMessage", convertMessage2Map(result.anchorMessage))
  }
  return resMap
}