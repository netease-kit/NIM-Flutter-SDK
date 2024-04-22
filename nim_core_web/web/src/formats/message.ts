import { formatNIMTypeWebToFlutter } from 'src/format'
import { NIMClientType, NIMSDKClientType, NIMWebMsgType } from 'src/types/enums'
import {
  KNIMMessageType,
  NIMAudioAttachment,
  NIMCustomMessageAttachment,
  NIMFileAttachment,
  NIMImageAttachment,
  NIMLocationAttachment,
  NIMMessage,
  NIMMessageAttachment,
  NIMSDKMessage,
  NIMVideoAttachment,
} from 'src/types/message'

export function formatClientTypeFlutterToWeb(
  clientType: NIMClientType
): NIMSDKClientType {
  switch (clientType) {
    case NIMClientType.android:
      return NIMSDKClientType.Android
    case NIMClientType.ios:
      return NIMSDKClientType.iOS
    case NIMClientType.windows:
      return NIMSDKClientType.PC
    case NIMClientType.wp:
      return NIMSDKClientType.WindowsPhone
    case NIMClientType.web:
      return NIMSDKClientType.Web
    default:
      return NIMSDKClientType.Unknown
  }
}

export function formatClientTypeWebToFlutter(
  clientType: NIMSDKClientType
): NIMClientType {
  switch (clientType) {
    case NIMSDKClientType.Android:
      return NIMClientType.android
    case NIMSDKClientType.iOS:
      return NIMClientType.ios
    case NIMSDKClientType.PC:
      return NIMClientType.windows
    case NIMSDKClientType.WindowsPhone:
      return NIMClientType.wp
    case NIMSDKClientType.Web:
      return NIMClientType.web
    default:
      return NIMClientType.unknown
  }
}

export function formatNIMMessageAttachmentWebToFlutter(
  message: NIMSDKMessage
):
  | (NIMMessageAttachment & { messageType: KNIMMessageType })
  | Record<string, unknown> {
  const messageType = formatNIMTypeWebToFlutter(message.type)
  if (message.file) {
    const { size, url, name, ext, dur, w, h } = message.file
    const fileAttachment: Required<NIMFileAttachment> = {
      size: size ?? 0,
      url,
      name,
      ext,
      // web 未知
      sen: 'defaultIm',
      expire: 0,
      base64: '',
      md5: '',
      path: '',
      //eslint-disable-next-line
      force_upload: false,
    }
    if (message.type === NIMWebMsgType.audio) {
      const res: Required<NIMAudioAttachment> = {
        ...fileAttachment,
        dur: dur ?? 0,
        // web 未知
        autoTransform: false,
        text: '',
      }
      return {
        ...res,
        messageType,
      }
    } else if (message.type === NIMWebMsgType.video) {
      const res: Required<NIMVideoAttachment> = {
        ...fileAttachment,
        dur: dur ?? 0,
        w: w ?? 0,
        h: h ?? 0,
        // web 未知
        thumbPath: '',
        thumbUrl: '',
      }
      return {
        ...res,
        messageType,
      }
    } else if (message.type === NIMWebMsgType.file) {
      return {
        ...fileAttachment,
        messageType,
      }
    } else if (message.type === NIMWebMsgType.image) {
      const res: Required<NIMImageAttachment> = {
        ...fileAttachment,
        w: w ?? 0,
        h: h ?? 0,
        // 以下是web没有的属性
        thumbPath: '',
        thumbUrl: '',
      }
      return {
        ...res,
        messageType,
      }
    }
  }
  if (message.geo && message.type === NIMWebMsgType.geo) {
    return {
      lat: message.geo.lat ?? 0,
      lng: message.geo.lng ?? 0,
      title: message.geo.title ?? '',
      messageType,
    }
  }
  if (message.type === NIMWebMsgType.custom) {
    let res: NIMCustomMessageAttachment = {}
    try {
      res = JSON.parse(message.content ?? '{}')
      res = typeof res === 'object' ? res : {}
    } catch {}
    return {
      ...res,
      messageType,
    }
  }
  if (message.type === NIMWebMsgType.notification) {
    return {}
  }
  return {}
}

export function formatNIMMessageAttachmentFlutterToWeb(
  message: NIMMessage,
  resend?: boolean
) {
  const getFileInfo = (fileAttachment: NIMFileAttachment) => {
    const { size, ext = '', name = '', url = '' } = fileAttachment
    return {
      size,
      ext,
      name,
      url,
    }
  }
  const messageAttachment = message.messageAttachment
  if (messageAttachment) {
    const messageType = message.messageType
    if (messageType === 'location') {
      const { lat, lng, title } = messageAttachment as NIMLocationAttachment
      return {
        lat,
        lng,
        title,
      }
    }
    const { base64 } = messageAttachment as NIMFileAttachment
    if (!resend && base64) {
      return { dataURL: base64 }
    }
    switch (messageType) {
      case 'audio': {
        const audioAttachment = messageAttachment as NIMAudioAttachment
        const { dur, autoTransform, text } = audioAttachment
        return {
          file: {
            dur, /// 语音时长，毫秒为单位
            autoTransform, /// 是否自动转换为文本消息发送
            text, /// 文本内容
            ...getFileInfo(audioAttachment),
          },
        }
      }
      case 'video': {
        const videoAttachment = messageAttachment as NIMVideoAttachment
        const { dur, thumbPath, thumbUrl, w, h } = videoAttachment
        return {
          file: {
            dur, /// 语音时长，毫秒为单位
            w, /// 视频宽度
            h, /// 视频高度
            thumbPath, /// 缩略本地路径
            thumbUrl, /// 缩略远程路径
            ...getFileInfo(videoAttachment),
          },
        }
      }
      case 'file': {
        const fileAttachment = messageAttachment as NIMFileAttachment
        const { base64 } = fileAttachment
        return {
          file: {
            ...getFileInfo(fileAttachment),
          },
        }
      }
      case 'image': {
        const imageAttachment = messageAttachment as NIMImageAttachment
        const { base64, thumbPath, thumbUrl, w, h } = imageAttachment
        return {
          file: {
            w, /// 视频宽度
            h, /// 视频高度
            thumbPath, /// 缩略本地路径
            thumbUrl, /// 缩略远程路径
            ...getFileInfo(imageAttachment),
          },
        }
      }
    }
  }
}
