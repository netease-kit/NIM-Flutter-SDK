import {
  rawToAttachment,
  V2NIMDownloadMessageAttachmentParams,
  V2NIMMessageAttachment,
  V2NIMSize,
  V2NIMUploadFileParams, V2NIMUploadFileTask } from '@nimsdk/base';

export function convertMap2DownloadMessageAttachmentParams(argumentsMap: Map<string, undefined | number | string | object | null>): V2NIMDownloadMessageAttachmentParams {

  let type = argumentsMap.get("type") as number;

  let attachmentMap = argumentsMap.get("attachment") as Map<string,undefined | number | string | object | null>;

  let raw = attachmentMap.get("raw") as string;

  let messageType = attachmentMap.get("nimCoreMessageType") as number

  let attachment = rawToAttachment(raw,messageType) as V2NIMMessageAttachment;

  let params: V2NIMDownloadMessageAttachmentParams = {
    attachment: attachment,
    type: type
  };

  if (argumentsMap.get("messageClientId") !== undefined && argumentsMap.get("messageClientId")  !== null){
    params.messageClientId = argumentsMap.get("messageClientId") as string;
  }

  if (argumentsMap.get("saveAs") !== undefined && argumentsMap.get("saveAs")  !== null){
    params.saveAs = argumentsMap.get("saveAs") as string;
  }

  if (argumentsMap.get("thumbSize") !== undefined && argumentsMap.get("thumbSize")  !== null){
    let thumbSizeMap = argumentsMap.get("thumbSize") as Map<string,undefined | null | number>
    let thumbSize:V2NIMSize = {
    }
    if(thumbSizeMap.get("width") !== undefined && thumbSizeMap.get("width")  !== null){
      thumbSize.width = thumbSizeMap.get("width") as number
    }
    if(thumbSizeMap.get("height") !== undefined && thumbSizeMap.get("height")  !== null){
      thumbSize.height = thumbSizeMap.get("height") as number
    }
    params.thumbSize = thumbSize;
  }

  return params;
}

export function convertMap2Attachment(attachmentMap:Map<string,undefined | number | string | object | null>):V2NIMMessageAttachment {
  let raw = attachmentMap.get("raw") as string;

  let messageType = attachmentMap.get("nimCoreMessageType") as number

  let attachment = rawToAttachment(raw,messageType) as V2NIMMessageAttachment;
  return attachment;
}

export function convertMap2NIMSize(thumbSizeMap: Map<string, undefined | number | null>): V2NIMSize {

  let thumbSize:V2NIMSize = {
  }
  if(thumbSizeMap.get("width") !== undefined && thumbSizeMap.get("width")  !== null){
    thumbSize.width = thumbSizeMap.get("width") as number
  }
  if(thumbSizeMap.get("height") !== undefined && thumbSizeMap.get("height")  !== null){
    thumbSize.height = thumbSizeMap.get("height") as number
  }

  return thumbSize;
}