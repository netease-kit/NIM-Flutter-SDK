import { V2NIMLocalConversationResult } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertLocalConversation2Map } from './V2NIMLocalConversation';


export function convertLocalConversationResult2Map(result: V2NIMLocalConversationResult): Map<string, Any> {
  return new Map<string, Any>()
    .set("offset", result.offset)
    .set("finished", result.finished)
    .set("conversationList",
      result.conversationList.map(conversation => convertLocalConversation2Map(conversation)))
}