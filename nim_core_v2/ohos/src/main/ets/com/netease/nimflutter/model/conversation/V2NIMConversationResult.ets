import { V2NIMConversationResult } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertConversation2Map } from './V2NIMConversation';


export function convertConversationResult2Map(result: V2NIMConversationResult): Map<string, Any> {
  return new Map<string, Any>()
    .set("offset", result.offset)
    .set("finished", result.finished)
    .set("conversationList",
      result.conversationList.map(conversation => convertConversation2Map(conversation)))
}