import { V2NIMLastMessage } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';


export function convertLastMessage2Map(result: V2NIMLastMessage,
  attachment: Map<string, Any> | undefined): Map<string, Any> {
  if (attachment) {
    return new Map<string, Any>(Object.entries(result)).set("attachment", attachment)
  }
  return new Map<string, Any>(Object.entries(result))
}