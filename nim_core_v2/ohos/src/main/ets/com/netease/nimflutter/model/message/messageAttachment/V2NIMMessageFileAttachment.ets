import { V2NIMMessageAttachmentUploadState, V2NIMMessageFileAttachment, V2NIMMessageType } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2MessageFileAttachment(argumentsMap: Map<string, Any>): V2NIMMessageFileAttachment {
  let messageAttachment: V2NIMMessageFileAttachment = {
    raw: undefined,
    path: undefined,
    size: undefined,
    url: undefined,
    md5: undefined,
    ext: undefined,
    name: undefined,
    sceneName: undefined,
    uploadState: V2NIMMessageAttachmentUploadState.V2NIM_MESSAGE_ATTACHMENT_UPLOAD_STATE_UNKNOWN
  };

  if (argumentsMap.get("raw") !== undefined && argumentsMap.get("raw") !== null) {
    messageAttachment.raw = argumentsMap.get("raw") as string;
  }

  if (argumentsMap.get("path") !== undefined && argumentsMap.get("path") !== null) {
    messageAttachment.path = argumentsMap.get("path") as string;
  }

  if (argumentsMap.get("size") !== undefined && argumentsMap.get("size") !== null) {
    messageAttachment.size = argumentsMap.get("size") as number;
  }

  if (argumentsMap.get("url") !== undefined && argumentsMap.get("url") !== null) {
    messageAttachment.url = argumentsMap.get("url") as string;
  }

  if (argumentsMap.get("md5") !== undefined && argumentsMap.get("md5") !== null) {
    messageAttachment.md5 = argumentsMap.get("md5") as string;
  }

  if (argumentsMap.get("ext") !== undefined && argumentsMap.get("ext") !== null) {
    messageAttachment.ext = argumentsMap.get("ext") as string;
  }

  if (argumentsMap.get("name") !== undefined && argumentsMap.get("name") !== null) {
    messageAttachment.name = argumentsMap.get("name") as string;
  }

  if (argumentsMap.get("sceneName") !== undefined && argumentsMap.get("sceneName") !== null) {
    messageAttachment.sceneName = argumentsMap.get("sceneName") as string;
  }

  if (argumentsMap.get("uploadState") !== undefined && argumentsMap.get("uploadState") !== null) {
    messageAttachment.uploadState = argumentsMap.get("uploadState") as V2NIMMessageAttachmentUploadState;
  }

  return messageAttachment;
}

export function convertMessageFileAttachment2Map(result: V2NIMMessageFileAttachment): Map<string, Any> {
  return new Map<string, Any>(Object.entries(result)).set("nimCoreMessageType",
    V2NIMMessageType.V2NIM_MESSAGE_TYPE_FILE)
}