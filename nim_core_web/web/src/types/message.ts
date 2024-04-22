import { NIMFriendProfile } from 'src/services/userService'
import { IObj } from '../types'
import {
  RevokeMessageType,
  NIMSessionType,
  NIMMessageType,
  NIMMessageStatus,
  SearchOrder,
  NIMWebMsgType,
  NIMMessageDirection,
  WebSystemMessageType,
  NIMClientType,
  NIMSDKClientType,
  NIMSDKSessionType,
  NIMSDKMessageStatus,
  SystemMessageStatus,
  SystemMessageType,
  WebSystemMessageStatus,
} from './enums'

// TODO 类似以下枚举这些，需要检查确认并修复，关键字 keyof typeof
export type KNIMMessageType = keyof typeof NIMMessageType
export type KNIMSessionType = Exclude<
  keyof typeof NIMSessionType,
  'none' | 'system' | 'ysf' | 'chatRoom'
>
export type KNIMMessageStatus = keyof typeof NIMMessageStatus
export type KNIMWebMsgType = keyof typeof NIMWebMsgType
export type KSystemMessageStatus = keyof typeof SystemMessageStatus
export type KWebSystemMessageStatus = keyof typeof WebSystemMessageStatus
export type KSystemMessageType = keyof typeof SystemMessageType | undefined
export type KWebSystemMessageType = keyof typeof WebSystemMessageType
export interface NIMCustomMessageConfig {
  /// 该消息是否要保存到服务器
  enableHistory: boolean
  /// 该消息是否需要漫游
  enableRoaming: boolean
  /// 多端同时登录时，发送一条自定义消息后，是否要同步到其他同时登录的客户端
  enableSelfSync: boolean
  /// 该消息是否要消息提醒，如果为true，那么对方收到消息后，系统通知栏会有提醒
  enablePush: boolean
  /// 该消息是否需要推送昵称（针对iOS客户端有效），如果为true，那么对方收到消息后，iOS端将显示推送昵称
  enablePushNick: boolean
  /// 该消息是否要计入未读数，如果为true，那么对方收到消息后，最近联系人列表中未读数加1
  enableUnreadCount: boolean
  /// 该消息是否支持路由，如果为true，默认按照app的路由开关（如果有配置抄送地址则将抄送该消息）
  enableRoute: boolean
  /// 该消息是否要存离线
  enablePersist: boolean
}

export interface NIMMemberPushOption {
  /// 强制推送的账号列表
  forcePushList?: string[]
  /// 强制推送的文案
  forcePushContent?: string
  /// 是否强制推送
  // @JsonKey(defaultValue: true)
  isForcePush: boolean
}

/// 消息附件接收/发送状态
export enum NIMMessageAttachmentStatus {
  /// 初始状态，需要上传或下载
  initial = 'initial',

  /// 上传/下载失败
  failed = 'failed',

  /// 上传/下载中
  transferring = 'transferring',

  /// 附件上传/下载成功/无附件
  transferred = 'transferred',

  /// 取消
  cancel = 'cancel',
}

export interface NIMMessageThreadOption {
  ///被回复消息的消息发送者
  replyMessageFromAccount: string
  ///被回复消息的消息接受者，群的话是tid
  replyMessageToAccount: string
  /// 被回复消息的消息发送时间
  replyMessageTime?: number
  /// 被回复消息的消息ServerID
  replyMessageIdServer?: number
  /// 被回复消息的UUID
  replyMessageIdClient: string
  /// thread消息的消息发送者
  threadMessageFromAccount: string
  /// thread消息的消息接受者，群的话是tid
  threadMessageToAccount: string
  /// thread消息的消息发送时间
  threadMessageTime?: number
  /// thread消息的消息ServerID
  threadMessageIdServer?: number
  /// thread消息的UUID
  threadMessageIdClient: string
}

export interface NIMAntiSpamOption {
  /// 是否过易盾反垃圾，对于已开通易盾的用户有效，默认为true
  /// 如果应用已经开了易盾，默认消息都会走易盾，如果对单条消息设置 enable 为false，则此消息不会走易盾反垃圾，而是走通用反垃圾
  // @JsonKey(defaultValue: false)
  enable: boolean
  /// 开发者自定义的反垃圾字段，content 必须是 json 格式，仅适用于自定义消息类型
  content?: string
  /// 易盾反垃圾配置id，指定此消息选择过哪一个反垃圾配置
  antiSpamConfigId?: string
}

export interface NIMMessageKey {
  sessionType?: keyof typeof NIMSessionType
  fromAccount?: string
  toAccount?: string
  time?: number
  serverId?: number
  uuid?: string
}

export interface NIMWebQuickComment {
  body: number
  custom?: string
  from: string
  time: number
  needPush?: boolean
  needBadge?: boolean
  pushPayload?: string
  pushTitle?: string
  apnsText?: string
}

export interface NIMWebQuickCommentsResult {
  commentTimetag: number
  comments: NIMWebQuickComment[]
  idClient: string
  idServer: string
}

// 离线广播消息
export interface NIMWebBroadcastMessage {
  /// 广播id
  broadcastId: number
  fromAccid: string
  fromUid: string
  time: number
  timestamp: number
  body: string
}
export interface NIMBroadcastMessage {
  /// 广播id
  id?: number
  fromAccount?: string
  time: number
  content?: string
}

export interface NIMSessionInfo {
  /// 会话id ，对方帐号或群组id。
  sessionId: string
  /// 会话类型
  sessionType: keyof typeof NIMSessionType
}

export interface NIMFileAttachment {
  /// 文件路径
  path?: string
  /// 文件下载地址
  url?: string
  /// 端文件base64信息
  base64?: string
  /// 文件大小
  size?: number
  ///文件内容的MD5
  md5?: string
  /// 文件显示名: displayName
  name?: string
  /// 文件后缀名: extension
  ext?: string
  /// 过期时间
  expire?: number

  /// 上传文件时用的对token对应的场景，默认 [NIMNosScenes.defaultIm] nosScene
  sen?: string
  /// 如果服务器存在相同的附件文件，是否强制重新上传 ， 默认false forceUpload
  force_upload: boolean
}

export type NIMAudioAttachment = NIMFileAttachment & {
  /// 语音时长，毫秒为单位
  dur?: number
  /// 是否自动转换为文本消息发送
  autoTransform?: boolean
  /// 文本内容
  text?: string
}

export type NIMVideoAttachment = NIMFileAttachment & {
  /// 语音时长，毫秒为单位
  dur?: number
  /// 视频宽度
  w?: number
  /// 视频高度
  h?: number
  /// 缩略本地路径
  thumbPath?: string
  /// 缩略远程路径
  thumbUrl?: string
}

export type NIMImageAttachment = NIMFileAttachment & {
  /// 缩略本地路径
  thumbPath?: string
  /// 缩略远程路径
  thumbUrl?: string
  /// 图片宽度
  w?: number
  /// 图片高度
  h?: number
}

export interface NIMLocationAttachment {
  /// 纬度
  lat: number
  /// 经度
  lng: number
  /// 地理位置描述
  title: string
}

export interface NIMCustomMessageAttachment {
  [key: string]: any
}

export type NIMMessageAttachment =
  | NIMAudioAttachment
  | NIMVideoAttachment
  | NIMFileAttachment
  | NIMImageAttachment
  | NIMLocationAttachment
  | NIMCustomMessageAttachment

export interface NIMSession {
  /// 最近联系人的ID（好友帐号，群ID等）
  sessionId: string
  /// 获取与该联系人的最后一条消息的发送方的帐号
  senderAccount?: string
  /// 获取与该联系人的最后一条消息的发送方的昵称
  senderNickname?: string
  /// 获取会话类型
  sessionType: keyof typeof NIMSessionType
  /// 最近一条消息的消息ID [NIMMessage.uuid]
  lastMessageId?: string
  /// 获取最近一条消息的消息类型
  lastMessageType?: KNIMMessageType
  /// 获取最近一条消息状态
  lastMessageStatus?: KNIMMessageStatus
  /// 获取最近一条消息的缩略内容。<br>
  /// 对于文本消息，返回文本内容。<br>
  /// 对于其他消息，返回一个简单的说明内容
  lastMessageContent?: string
  /// 获取最近一条消息的时间，单位为ms
  lastMessageTime?: number
  /// 如果最近一条消息是扩展消息类型，获取消息的附件内容. <br>
  /// 在最近消息列表，第三方app可据此自主定义显示的缩略语
  lastMessageAttachment?: NIMMessageAttachment
  /// 获取该联系人的未读消息条数
  unreadCount?: number
  /// 扩展字段
  // @JsonKey(fromJson: castPlatformMapToDartMap)
  extension?: IObj
  /// 设置一个标签，用于做联系人置顶、最近会话列表排序等扩展用途。 SDK不关心tag的意义。 <br>
  /// 第三方app需要事先规划好可能的用途
  tag?: number
  /// 会话扩展字段
  sessionForWeb?: IObj
}

/// 本地反垃圾检测结果
/// 反垃圾词库由开发者在云信后台管理配置，SDK 内负责下载并管理这个词库。垃圾词汇命中后支持三种替换规则：
///
/// 客户端替换：将命中反垃圾的词语替换成指定的文本，再将替换后的消息发送给服务器 <p>
/// 客户端拦截：命中后，开发者不应发送此消息 <p>
/// 服务器处理：开发者将消息相应属性配置为已命中服务端拦截库，再将消息发送给服务器（发送者能看到该消息发送，但是云信服务器不会投递该消息，接收者不会收到该消息），配置方法请见下文描述。
export interface NIMLocalAntiSpamResult {
  // /// 未命中
  // pass: 0;
  // /// 客户端替换。
  // /// 将命中反垃圾的词语替换成指定的文本，再将替换后的消息发送给服务器
  // clientReplace: 1;
  // /// 客户端拦截。
  // /// 命中后，开发者不应发送此消息
  // clientIntercept: 2;
  // /// 服务端拦截。
  // /// 开发者将消息相应属性配置为已命中服务端拦截库，再将消息发送给服务器（发送者能看到该消息发送，但是云信服务器不会投递该消息，接收者不会收到该消息）
  // serverIntercept: 3;
  /// 命中的垃圾词操作类型，0：未命中；1：客户端替换；2：客户端拦截；3：服务器拦截；
  operator: 0 | 1 | 2 | 3
  /// 将垃圾词替换后的文本
  content?: string
}

export type NIMSDKUploadFileResult = {
  /**
   * 文件名
   */
  name: string
  /**
   * 文件 url
   */
  url: string
  /**
   * 文件后缀
   */
  ext: string
  /**
   * 文件大小，单位字节
   */
  size?: number
  /**
   * 宽度。
   */
  w?: number
  /**
   * 高度
   */
  h?: number
  /**
   * 音频/视频 文件的时长
   */
  dur?: number
  /**
   * 图片的转向
   */
  orientation?: string
  /**
   * 音频解码格式
   */
  audioCodec?: string
  /**
   * 视频解码格式
   */
  videoCodec?: string
  /**
   * 音视频文件的容器
   */
  container?: string
  /**
   * 文件短链
   */
  // _url_safe?: string
}

export type NIMSDKMsgGeo = {
  /**
   * 地点名
   */
  title?: string
  /**
   * 纬度坐标
   */
  lat?: number
  /**
   * 经度坐标
   */
  lng?: number
}

export interface NIMSDKMessage {
  /**
   * 场景
   */
  scene: NIMSDKSessionType
  /**
   * 消息发送方, 帐号
   */
  from: string
  /**
   * 消息发送方的昵称
   */
  fromNick?: string
  /**
   * 发送方的设备类型
   */
  fromClientType?: NIMSDKClientType
  /**
   * 发送端设备id
   */
  fromDeviceId?: string
  /**
   * 消息接收方, 帐号或群id
   */
  to: string
  /**
   * 时间戳
   */
  time: number
  /**
   * 发送方信息更新时间
   */
  userUpdateTime: number

  replyMsg?: NIMSDKMessage
  /**
   * 消息类型
   */
  type: KNIMWebMsgType
  /**
   * 消息所属的会话的ID
   */
  sessionId: string
  /**
   * 聊天对象, 账号或者群id
   */
  target: string

  /**
   * 消息的流向
   *
   * 'in' 代表这是收到的消息.
   * 'out' 代表这是发出的消息
   */
  flow: string
  /**
   * 消息发送状态
   *
   * 'sending' 发送中
   * 'success' 发送成功
   * 'fail' 发送失败
   */
  status: NIMSDKMessageStatus

  /**
   * 端测生成的消息id, 可作为消息唯一主键使用。
   */
  idClient: string
  /**
   * 服务器用于区分消息用的ID, 用于获取历史消息和获取包含关键词的历史消息。
   *
   * 注：此字段可能没有, 比如说消息被反垃圾过滤了。
   */
  idServer?: string
  /**
   * 文本消息的文本内容. 当 type 为 text 时存在
   */
  text?: string
  /**
   * 文件消息的文件对象. 当 type 为 image, audio, video, file 时，且 status 为 success 时存在
   */
  file?: NIMSDKUploadFileResult
  /**
   * 地理位置消息的地理位置对象. 当 type 为 geo 时存在
   */
  geo?: NIMSDKMsgGeo
  /**
   * 提醒消息的内容. 当 type 为 tip 时存在
   */
  tip?: string
  /**
   * 自定义消息的消息内容, 开发者可以自行扩展, 建议封装成 JSON 序列化后的字符串. 当 type 为 custom 时存在
   */
  content?: string
  /**
   * 群通知消息的附加信息。当 type 为 notification 时存在
   */
  attach?: IObj

  /**
   * 该消息在接收方是否应该被静音
   */
  isMuted?: boolean
  /**
   * 是否是重发的消息，默认是 false
   */
  resend?: boolean
  /**
   * 扩展字段
   *
   * 注：推荐传入 JSON 序列化的字符串
   */
  custom?: string
  /**
   * 自定义推送文案
   */
  pushContent?: string
  /**
   * 自定义的推送属性
   *
   * 注：推荐传入 JSON 序列化的字符串
   */
  pushPayload?: string
  /**
   * 特殊推送选项, 只在群会话中使用
   */
  apns?: {
    /**
     * 需要特殊推送的账号列表, 此字段不存在的话表示推送给当前会话内的所有用户
     */
    accounts?: string[]
    /**
     * 需要特殊推送的文案
     */
    content?: string
    /**
     * 是否强制推送, 默认 false
     *
     * true 表示即使推送列表中的用户屏蔽了当前会话（如静音）, 仍能够推送当前这条内容给相应用户
     */
    forcePush?: boolean
  }
  /**
   * 本地数据库自定义扩展字段，开启 db 时有效。
   */
  localCustom?: string
  /**
   * 发送方 'from' 是否在接收方 'to' 的黑名单列表中
   */
  isInBlackList?: boolean
  /**
   * 是否存储云端历史，默认 true
   */
  isHistoryable?: boolean
  /**
   * 是否支持漫游，默认 true
   */
  isRoamingable?: boolean
  /**
   * 是否支持发送者多端同步，默认 true
   */
  isSyncable?: boolean
  /**
   * 是否支持抄送，默认 true
   */
  cc?: boolean
  /**
   * 是否需要推送，默认 true
   */
  isPushable?: boolean
  /**
   * 是否要存离线，默认 true
   */
  isOfflinable?: boolean
  /**
   * 是否计入消息未读数，默认 true
   */
  isUnreadable?: boolean
  /**
   * 是否为应答消息（用于机器人等类似场景等应答消息内容）
   */
  isReplyMsg?: boolean
  /**
   * 群已读消息快照大小（即消息发送时的群人数-1）
   */
  tempTeamMemberCount?: number
  /**
   * 是否需要推送昵称
   */
  needPushNick?: boolean
  /**
   * 是否是本地数据库消息, 默认 false
   */
  isLocal?: boolean
  /**
   * 被回复消息的发送者账号
   */
  replyMsgFromAccount?: string
  /**
   * 被回复消息的接受者账号
   */
  replyMsgToAccount?: string
  /**
   * 被回复消息的时间
   */
  replyMsgTime?: number
  /**
   * 被回复消息的 idServer
   */
  replyMsgIdServer?: string
  /**
   * 被回复消息的 idClient
   */
  replyMsgIdClient?: string
  /**
   * thread 消息的发送者账号
   */
  threadMsgFromAccount?: string
  /**
   * thread消息的接受者账号
   */
  threadMsgToAccount?: string
  /**
   * thread消息的时间
   */
  threadMsgTime?: number
  /**
   * thread消息的idServer
   */
  threadMsgIdServer?: string
  /**
   * thread消息的idClient
   */
  threadMsgIdClient?: string
  /**
   * 该消息是否已被撤回或单向删除，获取 thread 消息列表时会用到
   */
  delete?: boolean
  /**
   * 服务器第三方回调的扩展字段
   */
  callbackExt?: string
  /**
   * 开发者自定义的消息子类型，格式为大于0的整数
   */
  subType?: number
  /**
   * 环境变量，用于指向不同的抄送、第三方回调等配置
   */
  env?: string
  /**
   * 易盾反垃圾字段
   */
  yidunAntiCheating?: IObj
  /**
   * 易盾反垃圾结果。
   *
   * 注：若开启了易盾反垃圾，并且针对文本或图片如果被反垃圾策略匹配中，端测会透传此反垃圾结果字段。
   */
  yidunAntiSpamRes: string
}

export interface NIMWebSystemMessage {
  apnsText?: string
  attach?: { custom?: string; vt?: number }
  category?: string
  cc?: boolean
  content?: string
  error?: any
  from: string
  idServer?: string
  isPushable?: boolean
  localCustom?: string
  needPushNick?: boolean
  isUnreadable?: boolean
  ps?: string
  pushPayload?: string
  read?: boolean
  friend?: NIMFriendProfile
  // TODO 确认这个参数对不对
  scene?: KNIMSessionType
  sendToOnlineUsersOnly?: boolean
  state?: string
  time: number
  to: string
  type: KWebSystemMessageType
}

export interface NIMStickTopSessionInfo {
  sessionId: string
  sessionType?: keyof typeof NIMSessionType
  ext?: string
  createTime?: number
  updateTime?: number
}

export interface NIMMySessionKey {
  /// 会话ID
  sessionId: string
  /// 会话类型
  sessionType: keyof typeof NIMSessionType
}

/// 收藏信息
export interface NIMWebCollectInfo {
  createTime: number
  custom?: string
  data: string
  id: string
  type: number
  uniqueId: string
  updateTime: number
}
export interface NIMCollectInfo {
  /// 此收藏的ID，由服务端生成，具有唯一性
  id: number
  /// 收藏的类型
  type?: number
  /// 数据，最大20480
  data?: string
  /// 扩展字段，最大1024
  /// 该字段可以更新
  ext?: string
  /// 去重ID，如果多个收藏具有相同的去重ID，则视为同一条收藏
  uniqueId?: string
  /// 创建时间，单位为秒
  createTime: number
  /// 更新时间，单位为 秒
  updateTime?: number
}

/// 收藏信息查询结果
export interface NIMCollectInfoQueryResult {
  totalCount: number
  collects?: NIMCollectInfo[]
}

/// 消息PIN
export interface NIMMessagePin {
  /// 会话ID
  sessionId: string
  /// 会话类型
  sessionType: keyof typeof NIMSessionType
  /// 消息发送方帐号
  messageFromAccount?: string
  /// 消息接收方账号
  messageToAccount?: string
  /// 消息ID,唯一标识，iOS 可用
  // @JsonKey(defaultValue: '-1')
  messageId?: string
  /// 消息 uuid ，Android & Windows & macOS可用
  messageUuid?: string
  /// 被pin的消息唯一标识，Windows&macOS可用
  // @JsonKey(defaultValue: '-1')
  pinId?: string
  /// 消息 ServerID
  messageServerId?: number
  /// 操作者账号，不传表示当前登录者
  pinOperatorAccount?: string
  /// 扩展字段，string，最大512
  pinExt?: string
  /// 创建时间，单位为秒
  pinCreateTime: number
  /// 更新时间，单位为 秒
  pinUpdateTime: number
}

export interface MessageKeywordSearchConfig {
  // 关键词
  keyword?: string
  // 起始时间
  fromTime?: number
  // 终止时间
  toTime?: number
  // 会话数量上限
  sessionLimit?: number
  // 会话数量下限
  msgLimit?: number
  // 消息排序规则，默认false
  asc?: boolean
  // P2P范围，要查询的会话范围是此参数与{@link MsgFullKeywordSearchConfig#teamList} 的并集
  p2pList?: string[]
  // 群范围，如果只查询指定群中的消息，则输入这些群的ID
  teamList?: string[]
  // 发送方列表
  senderList?: string[]
  // 消息类型列表
  msgTypeList?: KNIMMessageType[]
  // 消息子类型列表
  msgSubtypeList?: number[]
}

export interface NIMQuickCommentOption {
  fromAccount?: string
  replyType?: number
  time?: number
  ext?: string
  needPush?: boolean
  needBadge?: boolean
  pushTitle?: string
  pushContent?: string
  pushPayload?: IObj
}

export interface NIMQuickCommentOptionWrapper {
  key?: NIMMessageKey
  quickCommentList?: NIMQuickCommentOption[]
  modify?: boolean
  time?: number
}

export interface NIMHandleQuickCommentOption {
  key?: NIMMessageKey
  commentOption?: NIMQuickCommentOption
}

export interface MessageSearchOption {
  //起始时间点单位毫秒
  startTime?: number
  //结束时间点单位毫秒
  endTime?: number
  //本次查询的消息条数上限(默认100条)
  limit?: number
  //检索方向
  order?: keyof typeof SearchOrder
  //消息类型组合
  msgTypeList?: KNIMMessageType[]
  //消息子类型组合
  messageSubTypes?: number[]
  //是否搜索全部消息类型
  allMessageTypes?: boolean
  //搜索文本内容
  searchContent?: string
  //消息说话者帐号列表
  fromIds?: string[]
  //将搜索文本中的正则特殊字符转义，默认 true
  enableContentTransfer?: boolean
}

export interface NIMMessageReceipt {
  /// 会话ID（聊天对方账号）
  sessionId: string
  /// 该会话最后一条已读消息的时间，比该时间早的消息都视为已读
  time: number
}

export interface NIMMessage {
  /// 消息ID,唯一标识
  messageId?: string
  /// 会话ID,如果当前session为team,则sessionId为teamId,如果是P2P则为对方帐号
  sessionId?: string
  /// 会话类型,当前仅支持P2P,Team和Chatroom
  // @JsonKey(unknownEnumValue: NIMSessionType.p2p)
  sessionType: NIMSessionType
  // /// 消息类型
  // @JsonKey(
  //     unknownEnumValue: NIMMessageType.undef,
  //     defaultValue: NIMMessageType.undef)
  messageType: KNIMMessageType
  // /// 消息子类型
  // @JsonKey(unknownEnumValue: NIMMessageType.undef)
  messageSubType?: number
  /// 消息状态
  // @JsonKey(unknownEnumValue: NIMMessageStatus.sending)
  status: NIMMessageStatus
  // /// 发送消息或者接收到消息
  // @JsonKey(unknownEnumValue: NIMMessageDirection.outgoing)
  messageDirection: keyof typeof NIMMessageDirection
  /// 消息发送方帐号
  fromAccount?: string
  /// 消息文本
  /// 消息中除 [IMMessageType.text] 和 [IMMessageType.tip]  外，其他消息 [text] 字段都为 null
  content?: string
  /// 消息发送时间
  /// 本地存储消息可以通过修改时间戳来调整其在会话列表中的位置，发完服务器的消息时间戳将被服务器自动修正
  timestamp: number

  resend?: boolean
  // /// 消息附件内容
  // @JsonKey(
  //     fromJson: NIMMessageAttachment._fromMap,
  //     toJson: NIMMessageAttachment._toMap)
  // NIMMessageAttachment? messageAttachment;
  messageAttachment?: NIMMessageAttachment
  // /// 消息附件下载状态 仅针对收到的消息
  // @JsonKey(unknownEnumValue: NIMMessageAttachmentStatus.transferred)
  attachmentStatus?: NIMMessageAttachmentStatus
  /// 消息UUID
  uuid?: string
  /// 消息 ServerID
  serverId?: number

  /// 消息配置
  config?: NIMCustomMessageConfig

  // / 消息拓展字段
  // / 服务器下发的消息拓展字段，并不在本地做持久化，目前只有聊天室中的消息才有该字段
  // @JsonKey(fromJson: castPlatformMapToDartMap)
  remoteExtension?: IObj

  /// 本地扩展字段（仅本地有效）
  // @JsonKey(fromJson: castPlatformMapToDartMap)
  localExtension?: IObj

  /// 第三方回调回来的自定义扩展字段
  callbackExtension?: string

  ///消息推送Payload
  /// @discussion iOS 上支持字段参考苹果技术文档,长度限制 2K,撤回消息时该字段无效
  // Map<string, dynamic>? pushPayload;
  pushPayload?: IObj
  /// 消息推送文案,长度限制200字节
  pushContent?: string
  /// 指定成员推送选项
  // @JsonKey(
  //     fromJson: NIMMemberPushOption._fromMap,
  //     toJson: NIMMemberPushOption._toMap)
  memberPushOption?: NIMMemberPushOption
  // 发送者客户端类型
  // @JsonKey(unknownEnumValue: NIMClientType.unknown)
  senderClientType?: NIMClientType

  /// 易盾反垃圾配置项
  antiSpamOption?: NIMAntiSpamOption
  /// 是否需要消息已读（主要针对群消息）
  messageAck: boolean
  /// 是否已经发送过群消息已读回执
  // @JsonKey(defaultValue: false)
  // bool hasSendAck;
  hasSendAck: boolean
  /// 群消息已读回执的已读数
  // @JsonKey(defaultValue: 0)
  // int ackCount;
  ackCount: number
  /// 群消息已读回执的未读数
  // @JsonKey(defaultValue: 0)
  unAckCount: number
  /// 命中了客户端反垃圾，服务器处理
  // @JsonKey(defaultValue: false)
  clientAntiSpam: boolean
  /// 发送消息给对方， 是不是被对方拉黑了（消息本身是发送成功的）
  // @JsonKey(defaultValue: false)
  isInBlackList: boolean
  ///消息的选中状态
  // @JsonKey(defaultValue: false)
  isChecked: boolean
  ///消息是否需要刷新到session服务
  ///只有消息存离线的情况下，才会判断该参数，默认：是
  // @JsonKey(defaultValue: true)
  sessionUpdate: boolean
  ///消息的thread信息
  // @JsonKey(
  //     fromJson: NIMMessageThreadOption._fromMap,
  //     toJson: NIMMessageThreadOption._toMap)
  messageThreadOption?: NIMMessageThreadOption
  ///快捷评论的最后更新时间
  quickCommentUpdateTime?: number
  /// 消息是否标记为已删除
  /// 已删除的消息在获取本地消息列表时会被过滤掉，只有根据 messageId
  /// 获取消息的接口可能会返回已删除消息。聊天室消息里，此字段无效。
  // @JsonKey(defaultValue: false)
  isDeleted: boolean
  ///  易盾反垃圾增强反作弊专属字段
  // @JsonKey(fromJson: castPlatformMapToDartMap)
  yidunAntiCheating?: IObj

  ///环境变量
  ///用于指向不同的抄送，第三方回调等配置
  ///注意：数据库不会保存此字段
  env?: string
  /// 消息发送方昵称
  fromNickname?: string
  /// 判断自己发送的消息对方是否已读
  /// 只有当当前消息为 [NIMSessionType.p2p] 消息且 [NIMMessageDirection.outgoing] 为 `true`
  isRemoteRead?: boolean
}

export interface NIMThreadTalkHistory {
  /// 获取Thread消息
  thread?: NIMMessage
  /// 获取thread聊天里最后一条消息的时间戳
  time: number
  /// 获取thread聊天里的总回复数，thread消息不计入总数
  replyList: NIMMessage[]
}

export interface NIMRevokeMessage {
  message?: NIMMessage
  attach?: string
  revokeAccount?: string
  customInfo?: string
  notificationType?: number
  // @JsonKey(unknownEnumValue: RevokeMessageType.undefined)
  revokeType?: keyof typeof RevokeMessageType
  callbackExt?: string
}

export interface RecentSession {
  sessionId: string
  updateTime?: number
  ext?: string
  lastMsg?: string
  lastMsgType?: number
  recentSession?: NIMSession
  sessionType?: keyof typeof NIMSessionType
  sessionTypePair?: string
  revokeNotification?: NIMRevokeMessage
}

export interface RecentSessionList {
  hasMore: boolean
  sessionList?: RecentSession[]
}

export interface NIMWebCloudSession {
  ext?: string
  id: string
  lastMsg?: NIMSDKMessage | NIMWebSystemMessage
  lastMsgType?: string
  updateTime: number
}

export interface NIMWebSession {
  id: string
  isTop?: boolean
  lastMsg: NIMSDKMessage
  localCustom?: string
  msgReceiptTime?: number
  scene: KNIMSessionType
  to: string
  topCustom?: string
  unread: number
  updateTime: number
}

export type NIMWebPinMsg = Required<
  Pick<
    NIMSDKMessage,
    'scene' | 'from' | 'to' | 'time' | 'idServer' | 'idClient' | 'sessionId'
  >
>

export type NIMWebPinGetResultPinInfo = NIMWebPinMsg & {
  pinCustom: string
  pinFrom: string
}

export interface NIMWebPinMsgChangeResult {
  msg: NIMWebPinMsg
  pinTag: {
    createTime: number
    pinCustom?: string
    pinFrom: string
    updateTime: number
  }
}

export interface NIMWebPinMsgGetResult {
  id: string
  pins: NIMWebPinGetResultPinInfo[]
}
