import {
  NIMEvent,
  NIMSubEvent,
  EventSubscribeResult,
} from './services/eventSubscribeService'
import { NIMSDKPushEvent } from './types'
import {
  NIMMessageType,
  NIMWebMsgType,
  deleteMsgMap,
  NIMSDKClientType,
  NIMSessionType,
} from './types/enums'

import {
  NIMMessage,
  NIMSession,
  NIMMessageKey,
  NIMSDKMessage,
  NIMStickTopSessionInfo,
  NIMCollectInfo,
  NIMMessagePin,
  RecentSession,
  NIMQuickCommentOptionWrapper,
  KNIMMessageType,
  KNIMWebMsgType,
  NIMBroadcastMessage,
  NIMHandleQuickCommentOption,
  NIMWebQuickCommentsResult,
  NIMWebCloudSession,
  KNIMSessionType,
  NIMWebSession,
  NIMWebPinMsgChangeResult,
  NIMWebQuickComment,
  NIMWebSystemMessage,
  NIMWebCollectInfo,
  NIMWebBroadcastMessage,
  NIMWebPinGetResultPinInfo,
  KSystemMessageType,
  KSystemMessageStatus,
  KWebSystemMessageType,
  KWebSystemMessageStatus,
} from './types/message'

import {
  NIMFriend,
  NIMUser,
  NIMFriendProfile,
  NIMUserNameCard,
  NIMSDKUser,
} from './services/userService'
import { SystemMessage } from './services/systemMessageService'
import {
  formatClientTypeFlutterToWeb,
  formatClientTypeWebToFlutter,
  formatNIMMessageAttachmentFlutterToWeb,
  formatNIMMessageAttachmentWebToFlutter,
} from './formats/message'
import { logger } from './logger'

export interface FileAttachInfo {
  ext: string
  h: number
  w: number
  dur: number
  name: string
  size: number
  url: string
}
export const SystemMessageTypeWebToFlutterMap: {
  [K in KWebSystemMessageType]: KSystemMessageType
} = {
  addFriend: 'addFriend',
  applyFriend: 'addFriend',
  applySuperTeam: 'superTeamApply',
  applyTeam: 'applyJoinTeam',
  custom: undefined,
  deleteFriend: undefined,
  deleteMsg: undefined,
  passFriendApply: 'addFriend',
  rejectFriendApply: 'addFriend',
  rejectSuperTeamApply: 'superTeamApplyReject',
  rejectSuperTeamInvite: 'superTeamInviteReject',
  rejectTeamApply: 'rejectTeamApply',
  rejectTeamInvite: 'declineTeamInvite',
  superTeamInvite: 'superTeamInvite',
  teamInvite: 'teamInvite',
}

export const SystemMessageStateMap: {
  [key in KWebSystemMessageStatus]: KSystemMessageStatus
} = {
  init: 'init',
  passed: 'passed',
  rejected: 'declined',
  ignored: 'declined',
  expired: 'expired',
}
export const messageStringTypeMap: {
  [key in KNIMMessageType]: KNIMWebMsgType
} = {
  audio: 'audio',
  custom: 'custom',
  file: 'file',
  image: 'image',
  location: 'geo',
  netcall: 'g2',
  notification: 'notification',
  robot: 'robot',
  text: 'text',
  tip: 'tip',
  video: 'video',
  // 以下几个属性没对齐
  undef: 'unknow',
  appCustom: 'unknow',
  avchat: 'unknow',
  qiyuCustom: 'unknow',
}

export const messageIntTypeMap: { [key in NIMMessageType]: KNIMWebMsgType } = {
  [NIMMessageType.audio]: 'audio',
  [NIMMessageType.custom]: 'custom',
  [NIMMessageType.file]: 'file',
  [NIMMessageType.image]: 'image',
  [NIMMessageType.location]: 'geo',
  [NIMMessageType.netcall]: 'g2',
  [NIMMessageType.notification]: 'notification',
  [NIMMessageType.robot]: 'robot',
  [NIMMessageType.text]: 'text',
  [NIMMessageType.tip]: 'tip',
  [NIMMessageType.video]: 'video',
  // 以下几个属性没对齐
  [NIMMessageType.undef]: 'unknow',
  [NIMMessageType.appCustom]: 'unknow',
  [NIMMessageType.avchat]: 'unknow',
  [NIMMessageType.qiyuCustom]: 'unknow',
}

export function formatNIMSubTypeFlutterToWeb(
  subType?: number
): number | undefined {
  if (subType === void 0 || subType <= 0) {
    return void 0
  }
  return subType
}

export function formatNIMSubTypeWebToFlutter(subType?: number): number {
  if (subType === void 0 || subType <= 0) {
    return 0
  }
  return subType
}

export function formatNIMTypeWebToFlutter(
  type: KNIMWebMsgType
): KNIMMessageType {
  // @ts-ignore
  return Object.keys(messageStringTypeMap).find(
    (item) => messageStringTypeMap[item] === type
  )
}

export function formatNIMTypeFlutterToWeb(
  type: KNIMMessageType
): KNIMWebMsgType {
  return messageStringTypeMap[type]
}

export const getClientType = (clientType: NIMSDKClientType): number => {
  switch (clientType) {
    case NIMSDKClientType.Web:
      return 16
    case NIMSDKClientType.PC:
      return 4
    case NIMSDKClientType.Android:
      return 1
    case NIMSDKClientType.iOS:
      return 2
    case NIMSDKClientType.WindowsPhone:
      return 8
    default:
      return 0
  }
}

export const formatNIMEventToFlutter = (params: NIMSDKPushEvent): NIMEvent => {
  return {
    eventId: params.idClient,
    eventType: Number(params.type),
    eventValue: Number(params.value),
    config:
      typeof params.custom === 'object' ? JSON.stringify(params.custom) : '',
    publisherAccount: params.account,
    publishTime: Number(params.time),
    publisherClientType: getClientType(params.clientType),
  }
}

export const formatNIMSubEventToFlutter = (
  params: NIMSubEvent
): EventSubscribeResult => {
  return {
    eventType: Number(params.type),
    expiry: Number(params.subscribeTime),
    time: Number(params.time),
    publisherAccount: params.to,
  }
}

// Extra
export function formMessageExtraFlutterToWeb(message: NIMMessage) {
  const {
    messageSubType,
    callbackExtension,
    localExtension,
    pushPayload,
    pushContent,
    isInBlackList,
  } = message
  // const data: IObj = {}
  // typeof messageSubType === 'number' && (data.subType = messageSubType)
  // callbackExtension && (data.callbackExt = JSON.stringify(callbackExtension))
  // localExtension && (data.localCustom = JSON.stringify(localExtension))
  // pushPayload && (data.pushPayload = JSON.stringify(pushPayload))
  // pushContent && (data.pushContent = pushContent)
  // typeof isInBlackList === 'boolean' && (data.isInBlackList = isInBlackList)
  return {
    localCustom: localExtension && JSON.stringify(localExtension),
    pushPayload: pushPayload && JSON.stringify(pushPayload),
    callbackExt: callbackExtension,
    pushContent,
    isInBlackList,
  }
}

// config
function formMessageConfigFlutterToWeb(config) {
  return {
    isHistoryable: !!config.enableHistory, // 该消息是否要保存到服务器
    isRoamingable: !!config.enableRoaming, // 该消息是否需要漫游
    isSyncable: !!config.enableSelfSync,
    isPushable: !!config.enablePush,
    needPushNick: !!config.enablePushNick,
    isUnreadable: !!config.enableUnreadCount, // 该消息是否要计入未读数，如果为true，那么对方收到消息后，最近联系人列表中未读数加1
    isOfflinable: !!config.enablePersist, // 该消息是否要存离线
  }
}

export function formatNIMMessageFlutterToWeb(
  myAccount: string,
  message: NIMMessage,
  resend?: boolean
): NIMSDKMessage {
  logger.log('formatNIMMessageFlutterToWeb', message, resend)
  const { sessionType, sessionId = '', content, messageType } = message
  let data: NIMSDKMessage = {
    flow: message.messageDirection === 'received' ? 'in' : 'out',
    scene: sessionType,
    from: message.fromAccount || '',
    to: message.messageDirection === 'received' ? myAccount : sessionId,
    type: formatNIMTypeFlutterToWeb(messageType),
    subType: formatNIMSubTypeFlutterToWeb(message.messageSubType),
    idClient: message.uuid || message.messageId || '',
    idServer: message.serverId !== void 0 ? String(message.serverId) : void 0, // flutter是int
    fromNick: message.fromNickname || '',
    status: message.status,
    fromClientType:
      message.senderClientType &&
      formatClientTypeFlutterToWeb(message.senderClientType),
    time: message.timestamp,
    target:
      message.messageDirection === 'received'
        ? message.fromAccount || ''
        : sessionId,
    sessionId:
      message.messageDirection === 'received'
        ? `${sessionType}-${message.fromAccount}`
        : `${sessionType}-${sessionId}`,
    resend: message.resend || resend,
    yidunAntiSpamRes: '',
    userUpdateTime: 0,
  }

  switch (messageType) {
    case 'tip':
      data.tip = content
      break
    case 'custom':
      data.text = content
      break
    case 'text':
      data.text = content
      break
    case 'notification':
      data.content = content
  }

  data = {
    ...data,
    ...formMessageExtraFlutterToWeb(message),
  }

  const { config } = message
  if (config) {
    data = {
      ...data,
      ...formMessageConfigFlutterToWeb(config),
    }
  }

  const { memberPushOption } = message
  if (memberPushOption) {
    data.apns = {
      accounts: memberPushOption?.forcePushList,
      content: memberPushOption?.forcePushContent,
      forcePush: memberPushOption?.isForcePush,
    }
  }

  const { messageAttachment } = message
  if (messageAttachment) {
    const attach = formatNIMMessageAttachmentFlutterToWeb(message, resend)
    if (messageType === 'custom') {
      data.content = JSON.stringify(messageAttachment)
    } else if (messageType === 'location') {
      // web中的location信息不放置于attach中，要在geo中
      data.geo = {
        ...attach,
      }
    } else {
      data = {
        ...data,
        ...attach,
      }
    }
  }
  return data
}

// apns
export function formatMessageApnsWebToFlutter(apns) {
  const { accounts, content, forcePush } = apns
  return {
    forcePushList: accounts, // 强制推送的账号列表
    forcePushContent: content, // 强制推送的文案
    isForcePush: !!forcePush, // 是否强制推送
  }
}

// config
export function formMessageConfigWebToFlutter(message) {
  const {
    isHistoryable = true,
    isRoamingable = true,
    isSyncable = true,
    isPushable = true,
    needPushNick = true,
    isUnreadable = true,
    isOfflinable = true,
  } = message
  return {
    enableHistory: !!isHistoryable, // 该消息是否要保存到服务器
    enableRoaming: !!isRoamingable, // 该消息是否需要漫游
    enableSelfSync: !!isSyncable,
    enablePush: !!isPushable,
    enablePushNick: !!needPushNick,
    enableUnreadCount: !!isUnreadable, // 该消息是否要计入未读数，如果为true，那么对方收到消息后，最近联系人列表中未读数加1
    enablePersist: !!isOfflinable, // 该消息是否要存离线
    enableRoute: true, // 不支持消息路由
  }
}

// thead
export function formatMessageThreadOptionWebToFlutter(message: NIMSDKMessage) {
  return {
    replyMessageFromAccount: message.replyMsgFromAccount ?? '',
    replyMessageToAccount: message.replyMsgToAccount ?? '',
    replyMessageTime: message.replyMsgTime ?? 0,
    replyMessageIdServer: message.replyMsgIdServer
      ? Number(message.replyMsgIdServer)
      : 0,
    replyMessageIdClient: message.replyMsgIdClient ?? '',
    threadMessageFromAccount: message.threadMsgFromAccount ?? '',
    threadMessageToAccount: message.threadMsgToAccount ?? '',
    threadMessageTime: message.threadMsgTime ?? 0,
    threadMessageIdServer: message.threadMsgIdServer
      ? Number(message.threadMsgIdServer)
      : 0,
    threadMessageIdClient: message.threadMsgIdClient ?? '',
  }
}

export function formatNIMMessageWebToFlutter(
  message: NIMSDKMessage
): NIMMessage {
  logger.log('formatNIMMessageWebToFlutter', message)
  const messageId = message.idClient || '-1'
  const data: NIMMessage = {
    messageId,
    sessionType: message.scene,
    uuid: messageId,
    sessionId: message.flow === 'in' ? message.from : message.to,
    status: message.status,
    messageType: formatNIMTypeWebToFlutter(message.type),
    messageSubType: formatNIMSubTypeWebToFlutter(message.subType),
    messageDirection: message.flow === 'in' ? 'received' : 'outgoing',
    fromAccount: message.from,
    senderClientType:
      message.fromClientType &&
      formatClientTypeWebToFlutter(message.fromClientType),
    content: message.text,
    serverId: message.idServer ? Number(message.idServer) : 0,
    timestamp: message.time,
    env: message.env,
    fromNickname: message.fromNick,
    isInBlackList: !!message.isInBlackList,
    isDeleted: !!message.delete,
    clientAntiSpam: !!message.yidunAntiSpamRes,
    callbackExtension: message.callbackExt ?? 'null', //对齐android返回结果
    yidunAntiCheating: message.yidunAntiCheating ?? {},
    // 暂不支持群，目前也没发现web会返回这些字段，先默认填上
    quickCommentUpdateTime: 0,
    messageAck: false, // 群消息已读
    hasSendAck: false,
    ackCount: 0,
    unAckCount: 0,
    isChecked: false, // 消息选中状态 默认值
    sessionUpdate: true, // 息是否需要刷新到session服务 默认值
    remoteExtension: {}, // 远端扩展字段 暂时也没找到字段
    // attachmentStatus: NIMMessageAttachmentStatus.initial, // 附件状态，web端没有找到这个字段
  }

  data.messageThreadOption = formatMessageThreadOptionWebToFlutter(message)

  data.messageAttachment = formatNIMMessageAttachmentWebToFlutter(message)

  data.config = formMessageConfigWebToFlutter(message)

  if (message.type === NIMWebMsgType.notification) {
    data.content = message.content
  }

  if (message.type === NIMWebMsgType.tip) {
    data.content = message.tip
  }

  if (message.apns) {
    data.memberPushOption = formatMessageApnsWebToFlutter(message.apns)
  }

  if (message.localCustom) {
    data.localExtension = {}
    try {
      data.localExtension = JSON.parse(message.localCustom || '{}')
    } catch (error) {
      console.log('localCustom parse error', error)
    }
  }

  const { pushPayload, pushContent } = message
  pushContent && (data.pushContent = pushContent)
  if (pushPayload) {
    data.pushPayload = {}
    try {
      data.pushPayload = JSON.parse(pushPayload || '{}')
    } catch (error) {
      console.log('pushPayload parse error', error)
    }
  }

  return data
}

/* === boradcastMessage=== */
export function formartNIMBroadcastMessageWebToFlutter(
  broadcastMessage: NIMWebBroadcastMessage
): NIMBroadcastMessage {
  const { broadcastId, fromAccid, time, body } = broadcastMessage
  return {
    /// 广播id
    id: broadcastId,
    fromAccount: fromAccid,
    time,
    content: body,
  }
}

/* === systemMessage=== */
export function formatNIMSystemMessageWebToFlutter(
  sysMessage: NIMWebSystemMessage
): SystemMessage {
  const vtMap = {
    addFriend: 1,
    applyFriend: 2,
    passFriendApply: 3,
    rejectFriendApply: 4,
  }
  const { type, time, content } = sysMessage
  let { attach } = sysMessage
  //当type为 addFriend applyFriend passFriendApply rejectFriendApply 需要将vtMap 放入attach中
  if (Object.keys(vtMap).includes(type)) {
    attach = { ...attach, vt: vtMap[type] }
  }
  return {
    // category,
    messageId: Number(sysMessage.idServer),
    type: SystemMessageTypeWebToFlutterMap[type],
    fromAccount: sysMessage.from,
    targetId: sysMessage.to,
    time,
    status: SystemMessageStateMap[sysMessage.state || ''],
    content: content ?? '',
    attach: JSON.stringify(attach),
    // Flutter 不需要该字段
    // attachObject,
    unread: !sysMessage.read,
    customInfo: sysMessage.localCustom ?? '',
  }
}

/* === NIMSession=== */
export function formatNIMSessionWebToFlutter(
  session: NIMWebSession
): NIMSession {
  const { id } = session
  const [scene, to] = id.split('-') || []
  const data: NIMSession = {
    sessionForWeb: session, // web session 扩展传到 flutter
    sessionId: session.to || to || '', // 最近联系人的ID（好友帐号，群ID等）
    sessionType: session.scene || scene || 'none',
    unreadCount: session.unread || 0,

    // extension: {},
  }
  if (session.lastMsg) {
    const lastMsg = session.lastMsg
    const { type } = lastMsg
    data.lastMessageId = lastMsg.idClient // 最近一条消息的消息ID [NIMMessage.uuid]
    data.lastMessageType = formatNIMTypeWebToFlutter(type) // 获取最近一条消息的消息类型
    data.lastMessageStatus = lastMsg.status // 获取最近一条消息状态
    data.lastMessageContent = lastMsg.content || lastMsg.text // 对于其他消息，返回一个简单的说明内容
    data.lastMessageTime = lastMsg.time // 获取最近一条消息的时间，单位为ms
    data.lastMessageAttachment = {}
    // 是flutter附件信息相关类型并且会返回file信息才需要转换
    if (['file', 'image', 'audio', 'video', 'geo', 'custom'].includes(type)) {
      data.lastMessageAttachment =
        formatNIMMessageAttachmentWebToFlutter(lastMsg)
    }
    data.senderAccount = lastMsg.from || '' // 获取与该联系人的最后一条消息的发送方的帐号
    data.senderNickname = lastMsg.fromNick || '' // 获取与该联系人的最后一条消息的发送方的昵称
  }
  //session自定义字段 需要回传给flutter
  if (session.localCustom) {
    data.extension = {}
    try {
      data.extension = JSON.parse(session.localCustom || '{}')
    } catch (error) {
      console.log('session extension parse error', error)
    }
  }
  return data
}

// NIMQuickCommentOptionWrapper
export function formatNIMQuickCommentOptionWrapperWebToFlutter({
  idClient,
  idServer,
  commentTimetag,
  comments,
}: NIMWebQuickCommentsResult): NIMQuickCommentOptionWrapper {
  const key: NIMMessageKey = {
    serverId: Number(idServer),
    uuid: idClient,
    sessionType: 'p2p', // TODO sdk未返回scene，dart层写的是可选参数，但是最后又强制传，web先写死p2p
  }
  return {
    key,
    time: commentTimetag,
    quickCommentList: comments.map((comment) => {
      const { from, custom, body, time } = comment
      let pushPayload = {}
      try {
        pushPayload = JSON.parse(comment.pushPayload || '{}')
      } catch (error) {
        //
      }
      return {
        fromAccount: from,
        replyType: body,
        time,
        ext: custom,
        needBadge: !!comment.needBadge,
        needPush: !!comment.needPush,
        pushTitle: comment.pushTitle,
        pushContent: comment.apnsText,
        pushPayload,
      }
    }),
  }
}
// quickComment
export function formatNIMHandleQuickCommentOptionWebToFlutter(
  data: Pick<
    NIMSDKMessage,
    // 这里其实 sdk 的定义没有 to，但是我们假装他有，即使真的没有，传空给 flutter
    'scene' | 'from' | 'time' | 'idServer' | 'idClient' | 'to'
  >,
  comment: NIMWebQuickComment
): NIMHandleQuickCommentOption {
  //   {
  //     "scene": "p2p",
  //     "to": "cs8",
  //     "from": "cs1",
  //     "time": 1663643569465,
  //     "idClient": "342324234324324",
  //     "idServer": "2342234324"
  // }
  const { scene, to, from, time, idClient, idServer } = data
  let pushPayload = {}
  try {
    pushPayload = JSON.parse(comment.pushPayload || '{}')
  } catch (error) {
    //
  }
  return {
    key: {
      sessionType: scene,
      fromAccount: from,
      toAccount: to,
      time,
      serverId: Number(idServer),
      uuid: idClient,
    },
    commentOption: {
      replyType: comment.body,
      fromAccount: from,
      time,
      ext: comment.custom,
      needPush: !!comment.needPush,
      needBadge: !!comment.needBadge,
      pushTitle: comment.pushTitle,
      pushContent: comment.apnsText,
      pushPayload,
    },
  }
}

// collect
export function formaNIMCollectInfoWebToFlutter(
  collectInfo: NIMWebCollectInfo
): NIMCollectInfo {
  const { id, createTime, type, data, custom, uniqueId, updateTime } =
    collectInfo
  return {
    id: Number(id),
    type,
    data,
    ext: custom,
    uniqueId,
    createTime,
    updateTime,
  }
}

export function formatNIMMessagePinGetResultWebToFlutter({
  scene,
  from,
  to,
  idClient,
  idServer,
  pinFrom,
  pinCustom,
  time,
}: NIMWebPinGetResultPinInfo): NIMMessagePin {
  return {
    sessionId: to,
    sessionType: scene as KNIMSessionType,
    messageFromAccount: from,
    messageToAccount: to,
    messageUuid: idClient,
    messageId: idClient,
    // pinId: '', web 没有 pinId
    messageServerId: Number(idServer),
    pinOperatorAccount: pinFrom,
    pinExt: pinCustom,
    // 这边只能取到这么一个 time，如果不符合期望就给 SDK 提需求
    pinCreateTime: time,
    pinUpdateTime: time,
  }
}

// pin message
export function formatNIMMessagePinWebToFlutter(
  data: NIMWebPinMsgChangeResult
): NIMMessagePin {
  const { scene, from, to, idClient, idServer } = data.msg
  const { pinFrom, pinCustom, createTime, updateTime } = data.pinTag
  return {
    sessionId: to,
    sessionType: scene,
    messageFromAccount: from,
    messageToAccount: to,
    messageUuid: idClient,
    messageId: idClient,
    // pinId: '', web 没有 pinId
    messageServerId: Number(idServer),
    pinOperatorAccount: pinFrom,
    pinExt: pinCustom,
    pinCreateTime: createTime,
    pinUpdateTime: updateTime,
  }
}

// recentSession
export function formatNIMRecentSessionWebToFlutter(
  session: NIMWebCloudSession
): RecentSession {
  // lastMsgType 1是系统通知 0是消息
  const [scene, to] = session.id.split('-') || []
  const data: RecentSession = {
    sessionId: to,
    lastMsgType: Number(session.lastMsgType), // int类型
    sessionType: scene as KNIMSessionType,
    ext: session.ext,
    updateTime: session.updateTime,
    sessionTypePair: to,
    recentSession: {
      sessionId: to,
      sessionType: scene as KNIMSessionType,
      lastMessageTime: session.lastMsg?.time,
    },
    // revokeNotification,
  }

  if (session.lastMsg) {
    if (session.lastMsg.type === 'deleteMsg') {
      data.revokeNotification = {
        // 最后一条消息是撤回消息时，flutter 需要这个字段，类似是 NIMMessage，但是 web 此时只有 systemMessage，转不了
        // message: formatNIMSystemMessageWebToFlutter(session.lastMsg),
        revokeAccount: session.lastMsg.from,
        revokeType: deleteMsgMap[scene],
      }
    } else {
      // 因为 flutter 要求 NIMMessage，所以这边只能不是撤回消息时才有以下字段
      data.lastMsg = JSON.stringify(
        formatNIMMessageWebToFlutter(session.lastMsg as NIMSDKMessage)
      )
      data.recentSession = formatNIMSessionWebToFlutter({
        ...session,
        scene: scene as KNIMSessionType,
        to,
        unread: 0,
        lastMsg: session.lastMsg as NIMSDKMessage,
      })
    }
  }
  return data
}

// stickTopSession
export function formatNIMStickTopSessionInfoWebToFlutter(
  stickTopSession: NIMWebSession
): NIMStickTopSessionInfo {
  // id: "p2p-account"
  // isTop: true
  // scene: "p2p"
  // to: "account"
  // topCustom: ""
  // unread: 0
  const { to, scene, topCustom, updateTime } = stickTopSession
  return {
    sessionId: to,
    sessionType: scene,
    ext: topCustom,
    // 随便给个当前时间先，跟安卓对齐
    createTime: Date.now(),
    updateTime: updateTime,
  }
}

/* === NIMUser=== */
export function formatNIMUserWebToFlutter(userInfo: NIMUserNameCard): NIMUser {
  const {
    account = '',
    nick = '',
    tel = '',
    avatar = '',
    sign = '',
    gender = '',
    email = '',
    birth = '',
    custom = '', // 扩展字段, 推荐使用JSON格式构建, 非JSON格式的话, Web端会正常接收, 但是会被其它端丢弃
  } = userInfo
  return {
    userId: account,
    nick,
    avatar,
    signature: sign,
    gender: gender || 'unknown',
    email,
    birthday: birth,
    mobile: tel,
    extension: custom,
  }
}

export function formatNIMUserFlutterToWeb(userInfo: NIMUser): NIMSDKUser {
  const { nick, avatar, gender, email } = userInfo
  return {
    nick,
    avatar,
    sign: userInfo.signature,
    gender,
    email,
    birth: userInfo.birthday,
    tel: userInfo.mobile,
    custom: userInfo.extension,
  }
}

export function formatNIMFriendWebToFlutter(
  friendInfo: NIMFriendProfile
): NIMFriend {
  const { alias, account, custom } = friendInfo
  return {
    userId: account,
    alias,
    extension: custom,
    serverExtension: '',
  }
}
