import { V2NIMConversation } from '@nimsdk/base';
import { V2NIMConversationImpl } from '@nimsdk/conversation/src/main/ets/nim/services/impl/V2NIMConversationImpl';
import { Any } from '@ohos/flutter_ohos';
import { convertAttachmentToMap } from '../message/messageAttachment/V2NIMMessageAttachment';
import { convertLastMessage2Map } from './V2NIMLastMessage';


export function convertConversation2Map(result: V2NIMConversation): Map<string, Any> {
  let res: Map<string, Any> = new Map<string, Any>(Object.entries((result as V2NIMConversationImpl).toJSON()))
  if(res.get("mute") === undefined){
    res.set("mute",false)
  }
  res.set("lastReadTime", result.lastReadTime)
  let lastMessage: Any = res.get("lastMessage")
  if (lastMessage) {
    if (result.lastMessage?.attachment) {
      const attachment: Map<string, Any> | undefined =
        convertAttachmentToMap(result.lastMessage?.attachment, result.lastMessage?.messageType)
      res.set("lastMessage", convertLastMessage2Map(result.lastMessage, attachment))
    }
  }
  return res
}
