import { V2NIMMessageSearchItem } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertMessage2Map } from './V2NIMMessage';


export function convertMessageSearchItem2Map(result: V2NIMMessageSearchItem): Map<string, Any> {
  let res: Map<string, Any> = new Map<string, Any>(Object.entries(result))
  res.set("messages", result.messages.map((message) => convertMessage2Map(message)))
  return res
}