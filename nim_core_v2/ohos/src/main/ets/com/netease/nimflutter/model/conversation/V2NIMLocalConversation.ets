import { V2NIMLocalConversation } from '@nimsdk/base';
import {
  V2NIMLocalConversationImpl
} from '@nimsdk/localconversation/src/main/ets/nim/services/localconversation/impl/V2NIMLocalConversationImpl';
import { Any } from '@ohos/flutter_ohos';
import { convertAttachmentToMap } from '../message/messageAttachment/V2NIMMessageAttachment';
import { convertLastMessage2Map } from './V2NIMLastMessage';


export function convertLocalConversation2Map(result: V2NIMLocalConversation): Map<string, Any> {
  let res: Map<string, Any> = new Map<string, Any>(Object.entries((result as V2NIMLocalConversationImpl).toJSON()))
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