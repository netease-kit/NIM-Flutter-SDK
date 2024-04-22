import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from 'yunxin-log-debug'
import { NIMResult, IObj } from '../types'
import { failRes, successRes, downloadFile, emit } from '../utils'
import {
  formaNIMCollectInfoWebToFlutter,
  formatNIMMessageFlutterToWeb,
  formatNIMMessagePinGetResultWebToFlutter,
  formatNIMMessageWebToFlutter,
  formatNIMQuickCommentOptionWrapperWebToFlutter,
  formatNIMRecentSessionWebToFlutter,
  formatNIMSessionWebToFlutter,
  formatNIMStickTopSessionInfoWebToFlutter,
  formatNIMTypeFlutterToWeb,
  formatNIMSubTypeFlutterToWeb,
} from '../format'
import {
  SearchOrder,
  NIMMessageStatus,
  NIMSessionDeleteType,
  NIMSessionType,
} from '../types/enums'

import {
  NIMMessage,
  NIMSession,
  NIMSessionInfo,
  MessageSearchOption,
  NIMCollectInfo,
  NIMMessagePin,
  NIMMySessionKey,
  MessageKeywordSearchConfig,
  NIMThreadTalkHistory,
  NIMStickTopSessionInfo,
  RecentSession,
  RecentSessionList,
  NIMLocationAttachment,
  NIMFileAttachment,
  KNIMMessageType,
  NIMQuickCommentOptionWrapper,
  NIMCollectInfoQueryResult,
  KNIMSessionType,
  NIMSDKMessage,
  KNIMWebMsgType,
  NIMWebSession,
  NIMWebCloudSession,
  NIMWebQuickCommentsResult,
  NIMWebPinMsgGetResult,
  NIMWebCollectInfo,
} from '../types/message'

const TAG_NAME = 'MessageService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

class MessageService {
  constructor(private rootService: RootService, private nim: any) {}

  @loggerDec
  sendMessage(params: NIMMessage): Promise<NIMResult<NIMMessage>> {
    return this._sendMessage(params, undefined, params.resend)
  }

  // void
  @loggerDec
  sendMessageReceipt(params: NIMMessage): Promise<NIMResult<void>> {
    return new Promise((resolve, reject) => {
      this.nim.sendMsgReceipt({
        msg: formatNIMMessageFlutterToWeb(this.nim.account, params),
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  sendTeamMessageReceipt() {
    throw Error('not implemented.')
  }

  // <NIMMessage>
  @loggerDec
  saveMessage(params: NIMMessage): Promise<NIMResult<NIMMessage>> {
    return new Promise((resolve, reject) => {
      this.nim.saveMsgsToLocal({
        msgs: [formatNIMMessageFlutterToWeb(this.nim.account, params)], // 要存储的消息
        done: (error, msgs = []) => {
          if (error) {
            return reject(failRes(error))
          }
          if (!msgs.length) {
            return resolve(successRes(params))
          }
          resolve(successRes(this._formatNIMMessageWebToFlutter(msgs[0])))
        },
      })
    })
  }

  // web 没有创建消息方法 所以暂时直接返回了消息
  @loggerDec
  createMessage(params: NIMMessage): Promise<NIMResult<NIMMessage>> {
    return new Promise((resolve) => {
      const messageAttachment = params.messageAttachment
      const msg = formatNIMMessageWebToFlutter(
        formatNIMMessageFlutterToWeb(this.nim.account, params)
      )
      msg.messageAttachment = messageAttachment
      msg.isRemoteRead = false
      resolve(successRes(msg))
    })
  }

  // void 下载地址url
  @loggerDec
  downloadAttachment(
    params: NIMMessage & { thumb: string }
  ): Promise<NIMResult<void>> {
    const { messageAttachment = {}, thumb } = params
    const { url = '', name = '' } = messageAttachment as NIMFileAttachment
    return new Promise((resolve) => {
      downloadFile(url || thumb, name)
      resolve(successRes())
    })
  }

  cancelUploadAttachment() {
    throw Error('not implemented.')
  }

  // void 撤回消息
  @loggerDec
  revokeMessage(
    params: NIMMessage & {
      customApnsText?: string
      pushPayload?: IObj
      // 是否需要更新未读数，Web SDK 只能在初始化时确定，在调用该 API 时，无法修改
      shouldNotifyBeCount?: boolean
      postscript?: string
      attach?: string
    }
  ): Promise<NIMResult<void>> {
    const { customApnsText, pushPayload, postscript, attach } = params
    return new Promise((resolve, reject) => {
      this.nim.recallMsg({
        msg: formatNIMMessageFlutterToWeb(this.nim.account, params),
        // 自定义推送文案
        apnsText: customApnsText,
        // 第三方自定义的推送属性，限制json字符串，长度最大2048
        pushPayload: JSON.stringify(pushPayload || {}),
        attach,
        ps: postscript,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  // void 更新消息，只能更新本地扩展字段
  @loggerDec
  updateMessage(params: NIMMessage): Promise<NIMResult<void>> {
    return new Promise((resolve, reject) => {
      this.nim.updateLocalMsg({
        idClient: params.messageId,
        localCustom: JSON.stringify(params.localExtension),
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  refreshTeamMessageReceipt() {
    throw Error('not implemented.')
  }

  fetchTeamMessageReceiptDetail() {
    throw Error('not implemented.')
  }

  queryTeamMessageReceiptDetail() {
    throw Error('not implemented.')
  }

  // void 转发消息
  @loggerDec
  forwardMessage(params: NIMMessage): Promise<NIMResult<void>> {
    const { sessionId = '', sessionType = '' } = params
    return new Promise((resolve, reject) => {
      this.nim.forwardMsg({
        msg: formatNIMMessageFlutterToWeb(this.nim.account, params),
        scene: sessionType,
        to: sessionId,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  // string 音频文件转文本
  @loggerDec
  voiceToText(params: NIMMessage): Promise<NIMResult<string>> {
    const { messageAttachment = {} } = params
    const { url } = messageAttachment as NIMFileAttachment
    return new Promise((resolve, reject) => {
      this.nim.audioToText({
        url,
        done: (error, obj) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes(obj.text))
        },
      })
    })
  }

  // <List<NIMMessage>> 查询与这个账户本地聊天历史消息
  @loggerDec
  async queryMessageList(params: {
    account: string
    sessionType: KNIMSessionType
    limit: number
  }): Promise<NIMResult<{ messageList: NIMMessage[] }>> {
    const { account, sessionType, limit } = params
    try {
      const msgs = await this._getLocalMsgs({
        sessionId: `${sessionType}-${account}`,
        limit,
      })
      return successRes({
        messageList: msgs.map((msg) => this._formatNIMMessageWebToFlutter(msg)),
      })
    } catch (error) {
      throw failRes(error)
    }
  }

  // <List<NIMMessage>> 根据锚点查询本地历史消息
  @loggerDec
  async queryMessageListEx(params: {
    message: NIMMessage
    direction: number
    limit: number
  }): Promise<NIMResult<{ messageList: NIMMessage[] }>> {
    const { message, direction, limit } = params
    const { sessionId, sessionType, timestamp } = message
    try {
      // timestamp 锚点
      // direction  0 查询比锚点时间更早的消息  1 查询比锚点时间更晚的消息
      // start开始时间 end结束时间  desc为 true 表示从 end 开始查, false 表示从 begin 开始查
      const msgs = await this._getLocalMsgs({
        sessionId: `${sessionType}-${sessionId}`,
        limit,
        desc: !direction,
        start: !direction ? 0 : timestamp + 1,
        end: !direction ? timestamp - 1 : Infinity,
      })
      if (!direction) {
        msgs.reverse()
      }
      return successRes({
        messageList: msgs.map((msg) => this._formatNIMMessageWebToFlutter(msg)),
      })
    } catch (error) {
      throw failRes(error)
    }
  }

  // <NIMMessage> 获取最近一条消息
  @loggerDec
  async queryLastMessage(params: {
    account: string
    sessionType: KNIMSessionType
  }): Promise<NIMResult<NIMMessage>> {
    const { account, sessionType } = params
    const session = await this._getLocalSession(`${sessionType}-${account}`)
    if (!session?.lastMsg) {
      return successRes()
    }
    return new Promise((resolve) => {
      this.nim.getLocalMsgByIdClient({
        idClient: session.lastMsg.idClient,
        done: (error, data) => {
          if (data && data.msg) {
            resolve(successRes(this._formatNIMMessageWebToFlutter(data.msg)))
          } else {
            successRes(this._formatNIMMessageWebToFlutter(session.lastMsg))
          }
        },
      })
    })
  }

  // <List<NIMMessage>> 按消息uuid【idClient】查询
  @loggerDec
  queryMessageListByUuid(params: {
    uuidList: string[]
    sessionId: string
    sessionType: KNIMSessionType
  }): Promise<NIMResult<{ messageList: NIMMessage[] }>> {
    const { uuidList, sessionId, sessionType } = params
    // 对齐移动端，如果uuidList为空，返回空数组了，不再返回错误
    if (uuidList && uuidList.length === 0) {
      return Promise.resolve(successRes({ messageList: [] }))
    }
    return new Promise((resolve, reject) => {
      this.nim.getLocalMsgsByIdClients({
        idClients: uuidList,
        done: (error, obj) => {
          if (error) {
            return reject(failRes(error))
          }
          const msgs = (obj.msgs || []).filter((msg) => {
            const msgSessionId = msg.flow === 'in' ? msg.from : msg.to
            return msg.scene === sessionType && msgSessionId === sessionId
          })
          resolve(
            successRes({
              messageList: msgs.map((msg) =>
                this._formatNIMMessageWebToFlutter(msg)
              ),
            })
          )
        },
      })
    })
  }

  // void 删除一条消息记录
  @loggerDec
  async deleteChattingHistory(params: {
    message: NIMMessage
    ignore: boolean
  }): Promise<NIMResult<void>> {
    try {
      await this._deleteLocalMsg(
        formatNIMMessageFlutterToWeb(this.nim.account, params.message)
      )
      return successRes()
    } catch (error) {
      throw failRes(error)
    }
  }

  // void 指定多条消息进行本地删除
  @loggerDec
  async deleteChattingHistoryList(params: {
    messageList: NIMMessage[]
    ignore: boolean // true 本地不记录清除操作; false: 本地记录清除操作
  }): Promise<NIMResult<void>> {
    try {
      // 目前只有根据会话id删除，没有看到根据多个idClient删除，需要多次一起删除
      await Promise.all(
        params.messageList.map((msg) => {
          return this._deleteLocalMsg(
            formatNIMMessageFlutterToWeb(this.nim.account, msg)
          )
        })
      )
      return successRes()
    } catch (error) {
      throw failRes(error)
    }
  }

  // void 删除指定会话内消息
  @loggerDec
  clearChattingHistory(params: {
    account: string
    sessionType: KNIMSessionType
  }): Promise<NIMResult<void>> {
    const { sessionType, account } = params
    return new Promise((resolve, reject) => {
      this.nim.deleteLocalMsgsBySession({
        scene: sessionType,
        to: account,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  // void 删除所有消息【删除所有会话聊过的消息...】
  @loggerDec
  async clearMsgDatabase(params: {
    clearRecent: boolean
  }): Promise<NIMResult<void>> {
    //[clearRecent] 是否同时清除本地最近会话列表
    try {
      await this._deleteAllLocalMsgs()
      if (params.clearRecent) {
        const sessions = await this._getLocalSessions()
        if (sessions.length) {
          await this._deleteLocalSession({
            id: sessions.map((session) => session.id),
          })
        }
      }
      return successRes()
    } catch (error) {
      throw failRes(error)
    }
  }

  // <List<NIMMessage> 从服务器拉取消息历史记录，可以指定查询的消息类型，结果不存本地消息数据库。
  @loggerDec
  async pullMessageHistoryExType(params: {
    message: NIMMessage
    toTime: number
    limit: number
    direction: number
    messageTypeList: KNIMMessageType[]
    persist: boolean // 通过该接口获取的漫游消息记录，要不要保存到本地消息数据库。
  }): Promise<NIMResult<{ messageList: NIMMessage[] }>> {
    // 查询方向，QUERY_OLD 按结束时间点逆序查询，逆序排列；QUERY_NEW 按起始时间点正序起查，正序排列
    const {
      direction,
      message,
      toTime,
      limit,
      messageTypeList = [],
      persist,
    } = params
    const { sessionId = '', sessionType, timestamp } = message
    // direction: QUERY_NEW : 1 QUERY_OLD : 0
    try {
      const msgs = await this._getHistoryMsgs({
        scene: sessionType,
        to: sessionId,
        reverse: !!direction,
        beginTime: !!direction ? timestamp + 1 : toTime,
        endTime: !!direction ? toTime : timestamp,
        // lastMsgId: String(serverId),
        limit,
        msgTypes: messageTypeList.map((msgType) =>
          formatNIMTypeFlutterToWeb(msgType)
        ),
        persist,
      })
      return successRes({
        messageList: msgs.map((msg) => this._formatNIMMessageWebToFlutter(msg)),
      })
    } catch (error) {
      throw failRes(error)
    }
  }

  // <List<NIMMessage> 下拉服务端历史记录
  @loggerDec
  async pullMessageHistory(params: {
    message: NIMMessage
    limit: number
    persist: boolean
  }): Promise<NIMResult<{ messageList: NIMMessage[] }>> {
    try {
      const { message, limit = 100, persist } = params
      const { sessionId = '', sessionType, timestamp } = message
      const msgs = await this._getHistoryMsgs({
        scene: sessionType,
        to: sessionId,
        endTime: timestamp - 1,
        beginTime: 0,
        reverse: false,
        limit,
        persist,
      })
      return successRes({
        messageList: msgs.map((msg) => this._formatNIMMessageWebToFlutter(msg)),
      })
    } catch (error) {
      throw failRes(error)
    }
  }

  // void 删除会话服务器聊天记录 [sync] 是否同步给其他端
  @loggerDec
  clearServerHistory(params: {
    sessionId: string
    sessionType: KNIMSessionType
    sync: boolean
  }): Promise<NIMResult<void>> {
    const { sessionId, sessionType, sync } = params
    return new Promise((resolve, reject) => {
      this.nim.clearServerHistoryMsgsWithSync({
        to: sessionId,
        scene: sessionType,
        isSyncSelf: sync,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  // int
  @loggerDec
  deleteMsgSelf(params: {
    message: NIMMessage
    ext: string
  }): Promise<NIMResult<number>> {
    return new Promise((resolve, reject) => {
      this.nim.deleteMsgSelf({
        msg: formatNIMMessageFlutterToWeb(this.nim.account, params.message),
        custom: params.ext,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes(1))
        },
      })
    })
  }

  // int
  @loggerDec
  deleteMsgListSelf(params: {
    messageList: NIMMessage[]
    ext: string
  }): Promise<NIMResult<number>> {
    const { messageList, ext } = params
    return Promise.all(
      messageList.map((msg) => this.deleteMsgSelf({ message: msg, ext }))
    ).then(() => {
      return successRes(messageList.length)
    })
  }

  // List<NIMMessage> 从本地消息数据库搜索消息历史。
  @loggerDec
  async searchMessage(params: {
    sessionType: KNIMSessionType
    sessionId: string
    searchOption: MessageSearchOption
  }): Promise<NIMResult<{ messageList: NIMMessage[] }>> {
    const { sessionType, sessionId, searchOption = {} } = params
    const {
      startTime,
      endTime,
      limit = 100,
      order = '',
      msgTypeList = [],
      messageSubTypes = [],
      allMessageTypes = false,
      searchContent = '',
      fromIds = [],
    } = searchOption
    //   //起始时间点单位毫秒
    //   int? startTime = 0;
    //   //结束时间点单位毫秒
    //   int? endTime = 0;
    //   //本次查询的消息条数上限(默认100条)
    //   int? limit = 100;
    //   //检索方向
    //   SearchOrder? order = SearchOrder.DESC;
    // 从新消息往旧消息查
    //   DESC,
    //   从旧消息往新消息查
    //   ASC
    //   //消息类型组合
    //   List<NIMMessageType>? msgTypeList;
    //   //消息子类型组合
    //   List<int>? messageSubTypes;
    //   //是否搜索全部消息类型
    //   bool? allMessageTypes = false;
    //   //搜索文本内容
    //   String? searchContent;
    //   //消息说话者帐号列表
    //   List<String>? fromIds;
    //   //将搜索文本中的正则特殊字符转义，默认 true
    //   bool? enableContentTransfer = true;
    try {
      const msgs = await this._getLocalMsgs({
        start: startTime || 0,
        end: endTime || Date.now(),
        desc: order === 'DESC', // true 表示从 end 开始查, false 表示从 begin 开始查
        sessionId: `${sessionType}-${sessionId}`,
        types: allMessageTypes
          ? void 0
          : msgTypeList.map(formatNIMTypeFlutterToWeb),
        subTypes: messageSubTypes
          .map(formatNIMSubTypeFlutterToWeb)
          .filter((item) => item !== void 0) as number[],
        keyword: searchContent,
        limit,
      })
      return successRes({
        messageList: msgs
          .filter((msg) => fromIds.some((item) => msg.from === item))
          .map((msg) => this._formatNIMMessageWebToFlutter(msg)),
      })
    } catch (error) {
      throw failRes(error)
    }
  }

  // List<NIMMessage> 从本地消息数据库全局搜索消息历史。
  @loggerDec
  async searchAllMessage(params: {
    searchOption: MessageSearchOption
  }): Promise<NIMResult<{ messageList: NIMMessage[] }>> {
    const { searchOption = {} } = params
    const {
      startTime,
      endTime,
      limit = 100,
      order,
      msgTypeList = [],
      messageSubTypes = [],
      searchContent = '',
      fromIds = [],
      allMessageTypes = false,
    } = searchOption
    try {
      const msgs = await this._getLocalMsgs({
        start: startTime,
        end: endTime,
        desc: order === 'DESC', // true 表示从 end 开始查, false 表示从 begin 开始查
        types: allMessageTypes
          ? void 0
          : msgTypeList.map(formatNIMTypeFlutterToWeb),
        subTypes: messageSubTypes
          .map(formatNIMSubTypeFlutterToWeb)
          .filter((item) => item !== void 0) as number[],
        keyword: searchContent,
        limit,
      })
      return successRes({
        messageList: msgs
          .filter((msg) => fromIds.some((item) => msg.from === item))
          .map((msg) => this._formatNIMMessageWebToFlutter(msg)),
      })
    } catch (error) {
      throw failRes(error)
    }
  }

  // <List<NIMMessage>> 云端单聊天记录关键词查询
  @loggerDec
  async searchRoamingMsg(params: {
    otherAccid: string
    fromTime: number
    endTime: number
    keyword: string
    limit: number
    reverse: boolean
  }): Promise<NIMResult<{ messageList: NIMMessage[] }>> {
    const { otherAccid, fromTime, endTime, keyword, limit, reverse } = params
    try {
      const msgs = await this._searchHistoryMsgs({
        p2pList: [otherAccid],
        fromTime,
        toTime: endTime,
        keyword,
        msgLimit: limit,
        order: reverse ? 'ASC' : 'DESC',
      })
      return successRes({
        messageList: msgs.map((msg) => this._formatNIMMessageWebToFlutter(msg)),
      })
    } catch (error) {
      throw failRes(error)
    }
  }

  // List<NIMMessage> 云端历史消息全文检索
  @loggerDec
  async searchCloudMessageHistory(params: {
    messageKeywordSearchConfig: MessageKeywordSearchConfig
  }): Promise<NIMResult<{ messageList: NIMMessage[] }>> {
    const {
      fromTime,
      toTime,
      keyword = '',
      sessionLimit = 10,
      msgLimit = 5,
      p2pList = [],
      // 群范围，如果只查询指定群中的消息，则输入这些群的ID
      teamList = [],
      // 发送方列表
      senderList = [],
      // 消息类型列表
      msgTypeList = [],
      // 消息子类型列表
      msgSubtypeList = [],
    } = params.messageKeywordSearchConfig
    try {
      const msgs = await this._searchHistoryMsgs({
        p2pList,
        msgLimit,
        sessionLimit,
        teamList,
        senderList,
        msgTypeList: msgTypeList.map(formatNIMTypeFlutterToWeb),
        msgSubTypeList: msgSubtypeList
          .map(formatNIMSubTypeFlutterToWeb)
          .filter((item) => item !== void 0) as number[],
        keyword,
        fromTime,
        toTime,
      })

      return successRes({
        messageList: msgs.map((msg) => this._formatNIMMessageWebToFlutter(msg)),
      })
      // let msgList = [...msgs]
      // if (p2pList.length) {
      //   msgList = msgList.filter((msg) => p2pList.includes(msg.to))
      // }
      // if (teamList.length) {
      //   msgList = msgList.filter((msg) => teamList.includes(msg.to))
      // }
      // if (senderList.length) {
      //   msgList = msgList.filter((msg) => senderList.includes(msg.from))
      // }
      // if (msgTypeList.length) {
      //   const typeList = msgTypeList.map((msgType) =>
      //     formatNIMTypeFlutterToWeb(msgType)
      //   )
      //   msgList = msgList.filter((msg) => typeList.includes(msg.type))
      // }
      // if (msgSubtypeList.length) {
      //   msgList = msgList.filter((msg) => msgSubtypeList.includes(msg.subType))
      // }
      // if (msgLimit) {
      //   msgList.length = msgLimit
      // }
      // return successRes({
      //   messageList: msgList.map((msg) => formatNIMMessageWebToFlutter(msg)),
      // })
    } catch (error) {
      throw failRes(error)
    }
  }

  // <List<NIMSession>>
  @loggerDec
  async querySessionList(params: {
    limit?: number
  }): Promise<NIMResult<{ resultList: NIMSession[] }>> {
    try {
      const sessions = await this._getLocalSessions({
        limit: params.limit || 100,
      })
      return successRes({
        resultList: sessions.map((session) =>
          formatNIMSessionWebToFlutter(session)
        ),
      })
    } catch (error) {
      throw failRes(error)
    }
  }

  // 当希望返回的会话的最近一条消息不是某一类消息时，可以使用以下过滤接口。
  // 如希望最近一条消息为非文本消息时，使用该接口的返回的会话，将取最近的一条非文本的消息作为最近一条消息。
  // List<NIMSession> [filterMessageType] 过滤消息类型
  @loggerDec
  querySessionListFiltered(params: {
    filterMessageTypeList: KNIMMessageType[]
  }): Promise<NIMResult<{ resultList: NIMSession[] }>> {
    return new Promise((resolve, reject) => {
      // TODO 这个接口废弃了，后面要换成 getLocalSessions
      this.nim.getLocalSessionsByMsgType({
        exclude: params.filterMessageTypeList.map((msgType) =>
          formatNIMTypeFlutterToWeb(msgType)
        ),
        done: (error, obj) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(
            successRes({
              resultList: obj.sessions?.map((session) =>
                formatNIMSessionWebToFlutter(session)
              ),
            })
          )
        },
      })
    })
  }

  // <NIMSession>
  @loggerDec
  async querySession(params: {
    sessionId: string
    sessionType: KNIMSessionType
  }): Promise<NIMResult<NIMSession>> {
    //flutter 层没有查到返回null
    const { sessionId, sessionType } = params
    const id = `${sessionType}-${sessionId}`
    try {
      const session = await this._getLocalSession(id)
      return session
        ? successRes(formatNIMSessionWebToFlutter(session))
        : successRes(session)
    } catch (error) {
      throw failRes(error)
    }
  }

  // <NIMSession>
  @loggerDec
  createSession(params: {
    sessionId: string
    sessionType: KNIMSessionType
    tag?: number
    time: number
    linkToLastMessage?: boolean
  }): Promise<NIMResult<NIMSession>> {
    const {
      sessionId,
      sessionType,
      tag = 0,
      time,
      linkToLastMessage = false, // 暂不支持，如果当前会话存在最后一条消息，新创建的会话与最后一条消息关联
    } = params

    return new Promise((resolve, reject) => {
      this.nim.insertLocalSession({
        scene: sessionType,
        to: sessionId,
        updateTime: time,
        done: (error, obj) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes(formatNIMSessionWebToFlutter(obj.session)))
        },
      })
    })
  }

  // void 更新会话对象 [needNotify] 是否需要发送通知 仅支持修改 tag 以及 extension
  //needNotify 在这里不需要处理 因为websdk updateLocalSession 会自动触发 onSessionUpdate
  @loggerDec
  updateSession(params: {
    session: NIMSession
    needNotify: boolean
  }): Promise<NIMResult<void>> {
    const { session, needNotify = false } = params
    const { sessionId, sessionType, extension = '' } = session
    return new Promise((resolve, reject) => {
      this.nim.updateLocalSession({
        id: `${sessionType}-${sessionId}`,
        localCustom: JSON.stringify(extension),
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  // void 使用消息更新会话对象
  @loggerDec
  updateSessionWithMessage(params: {
    message: NIMMessage
    needNotify: boolean
  }): Promise<NIMResult<void>> {
    const { message, needNotify } = params
    return new Promise((resolve, reject) => {
      // 更新漫游消息不全的会话的漫游时间戳
      const msg = formatNIMMessageFlutterToWeb(this.nim.account, message)
      this.nim.updateSessionsWithMoreRoaming({
        msg,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          if (needNotify) {
            this._getLocalSession(msg.sessionId).then((session) => {
              emit<{ data: NIMSession[] }>(
                'MessageService',
                'onSessionUpdate',
                {
                  data: [formatNIMSessionWebToFlutter(session)],
                }
              )
            })
          }
          resolve(successRes())
        },
      })
    })
  }

  // int SDK  暂不支持 获取所有会话类型的未读总数
  queryTotalUnreadCount() {
    // // 所有类型
    // all,
    // // 仅通知消息
    // notifyOnly,
    // // 仅免打扰消息
    // noDisturbOnly
    throw Error('not implemented.')
  }

  // void 设置当前会话，Android平台可用 调用以下接口重置当前会话，SDK会自动管理消息的未读数。 该接口会自动调用clearUnreadCount(String, SessionTypeEnum)将正在聊天对象的未读数清零
  @loggerDec
  setChattingAccount(params: {
    sessionId: string
    sessionType: KNIMSessionType
  }): Promise<NIMResult<void>> {
    try {
      const { sessionId, sessionType } = params
      this.nim.setCurrSession(`${sessionType}-${sessionId}`)
      return Promise.resolve(successRes())
    } catch (error) {
      throw failRes(error)
    }
  }

  // <List<NIMSessionInfo> ===本地会话===
  @loggerDec
  async clearSessionUnreadCount(params: {
    requestList: NIMSessionInfo[]
  }): Promise<NIMResult<{ failList: NIMSessionInfo[] }>> {
    const failList: NIMSessionInfo[] = []
    const superTeamList = params.requestList.filter(
      (item) => item.sessionType === 'superTeam'
    )
    const p2pAndTeamList = params.requestList.filter((item) =>
      ['p2p', 'team'].includes(item.sessionType)
    )
    try {
      const res = await Promise.allSettled([
        this._resetSessionsUnread(
          p2pAndTeamList.map((item) => `${item.sessionType}-${item.sessionId}`)
        ),
        this._resetSuperTeamSessionsUnread(
          superTeamList.map((item) => `${item.sessionType}-${item.sessionId}`)
        ),
      ])
      if (res[0].status === 'rejected') {
        failList.push(...p2pAndTeamList)
      }
      if (res[1].status === 'rejected') {
        failList.push(...superTeamList)
      }
      return successRes({
        failList,
      })
    } catch (error) {
      throw failRes(error)
    }
  }

  // void
  @loggerDec
  clearAllSessionUnreadCount(): Promise<NIMResult<void>> {
    this.nim.resetAllSessionUnread()
    return Promise.resolve(successRes())
  }

  // void 删除最近会话
  @loggerDec
  async deleteSession(params: {
    sessionInfo: NIMSessionInfo
    deleteType: keyof typeof NIMSessionDeleteType
    sendAck: boolean
  }): Promise<NIMResult<void>> {
    // sendAck: 删除最近联系人记录。
    // 调用该接口后，会触发{@link MsgServiceObserve#observeRecentContactDeleted(Observer, boolean)}通知 会话ID 会话类型，只能选{@link SessionTypeEnum#P2P}和{@link SessionTypeEnum#Team}会删漫游消息 删除类型，
    // 决定是否删除本地记录和漫游记录， 如果为null，视为{@link DeleteTypeEnum#REMAIN} 如果参数合法，是否向其他端标记此会话为已读
    const { sessionInfo, deleteType, sendAck } = params
    const { sessionType, sessionId } = sessionInfo
    try {
      await this._deleteLocalSession({
        id: `${sessionType}-${sessionId}`,
        isLogic: sendAck,
        isDeleteRoaming: ['remote', 'localAndRemote'].includes(deleteType),
      })
      if (deleteType === 'local' || deleteType === 'localAndRemote') {
        emit<NIMSessionInfo>('MessageService', 'onSessionDelete', {
          sessionId,
          sessionType,
        })
      }
      return successRes()
    } catch (error) {
      throw failRes(error)
    }
  }

  // void 回复消息
  @loggerDec
  async replyMessage(params: {
    message: NIMMessage
    replyMsg: NIMMessage
    resend: boolean
  }): Promise<NIMResult<void>> {
    const { message, replyMsg, resend = false } = params
    try {
      await this._sendMessage(message, replyMsg, resend)
      return successRes()
    } catch (error) {
      throw failRes(error)
    }
  }

  // <NIMCollectInfo>
  @loggerDec
  addCollect(params: {
    type: number
    data: string
    ext?: string
    uniqueId?: string
  }): Promise<NIMResult<NIMCollectInfo>> {
    return new Promise((resolve, reject) => {
      this.nim.addCollect({
        custom: params.ext,
        ...params,
        done: (error, obj) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes(formaNIMCollectInfoWebToFlutter(obj.collect)))
        },
      })
    })
  }

  // int [NIMCollectInfo] 中 [id] 和 [createTime] 为必填字段
  @loggerDec
  removeCollect(params: {
    collects: NIMCollectInfo[]
  }): Promise<NIMResult<number>> {
    return new Promise((resolve, reject) => {
      this.nim.deleteCollects({
        collectList: (params.collects || []).map((item) => {
          return { ...item, id: String(item.id) }
        }),
        done: (error, obj) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes(obj.deleteNum))
        },
      })
    })
  }

  // <NIMCollectInfo>
  @loggerDec
  updateCollect(params: NIMCollectInfo): Promise<NIMResult<NIMCollectInfo>> {
    const { id, type, data, ext, uniqueId, createTime, updateTime } = params
    return new Promise((resolve, reject) => {
      this.nim.updateCollect({
        collect: {
          id: String(id),
          createTime,
          custom: ext,
        },
        done: (error, obj) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes(formaNIMCollectInfoWebToFlutter(obj.collect)))
        },
      })
    })
  }

  // <NIMCollectInfoQueryResult>
  @loggerDec
  async queryCollect(params: {
    anchor?: NIMCollectInfo
    toTime: number
    type?: number
    limit: number
    direction: number
  }): Promise<NIMResult<NIMCollectInfoQueryResult>> {
    const { anchor, toTime, type, limit, direction } = params
    return new Promise((resolve, reject) => {
      // type	Number	<optional>
      // 要查询的收藏类型，缺省表示所有类型
      // beginTime	Number	<optional>
      // 时间戳, 开始时间, 精确到ms, 默认为0
      // endTime	Number	<optional>
      // 时间戳, 结束时间, 精确到ms, 默认为服务器的最新时间
      // lastId	String	<optional>
      // 上次查询的最后一条收藏的id, 第一次可不填
      // limit	Number	<optional>
      // 100
      // 本次查询的消息数量限制, 最多100条, 默认100条
      // reverse	Boolean	<optional>
      // false
      // 默认false表示从endTime开始往前查找历史消息，true表示从beginTime开始往后查找历史消息
      // anchor 当anchor不传的时候，即没有锚点，beginTime和endTime都不传 让sdk取默认值,传的时候 根据direction  createTime toTime来确定查找的startTime和endTime
      const lastId =
        typeof anchor?.id === 'number' ? String(anchor?.id) : undefined // message:  "参数\"lastId\"类型错误, 合法的类型包括: [\"string\"]"
      /* direction
       0 QUERY_OLD 查询比锚点时间更早的消息
       1 QUERY_NEW 查询比锚点时间更晚的消
    */
      const beginTime = anchor ? (!!direction ? anchor.createTime : toTime) : 0
      const endTime = anchor
        ? !!direction
          ? toTime
          : anchor.createTime - 1
        : toTime
      this.nim.getCollects({
        type: type, // 收藏的类型
        reverse: !!direction,
        beginTime: beginTime,
        endTime: endTime,
        // lastId,
        limit,
        done: (
          error,
          obj: { collectList: NIMWebCollectInfo[]; total: number }
        ) => {
          if (error) {
            return reject(failRes(error))
          }
          const { total = 0, collectList = [] } = obj
          if (!!direction) {
            collectList.reverse()
          }
          resolve(
            successRes({
              totalCount: total,
              collects: collectList.map((collect) =>
                formaNIMCollectInfoWebToFlutter(collect)
              ),
            })
          )
        },
      })
    })
  }

  // void
  @loggerDec
  addMessagePin(params: {
    message: NIMMessage
    ext?: string
  }): Promise<NIMResult<void>> {
    const { message, ext } = params
    return new Promise((resolve, reject) => {
      this.nim.addMsgPin({
        msg: formatNIMMessageFlutterToWeb(this.nim.account, message),
        pinCustom: ext,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  // void
  @loggerDec
  updateMessagePin(params: {
    message: NIMMessage
    ext?: string
  }): Promise<NIMResult<void>> {
    const { message, ext = '' } = params
    return new Promise((resolve, reject) => {
      this.nim.updateMsgPin({
        msg: formatNIMMessageFlutterToWeb(this.nim.account, message),
        pinCustom: ext,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  // void
  @loggerDec
  removeMessagePin(params: {
    message: NIMMessage
    ext?: string
  }): Promise<NIMResult<void>> {
    const { message, ext = '' } = params
    return new Promise((resolve, reject) => {
      this.nim.deleteMsgPin({
        msg: formatNIMMessageFlutterToWeb(this.nim.account, message),
        pinCustom: ext,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  // <List<NIMMessagePin>>
  @loggerDec
  queryMessagePinForSession(params: {
    sessionType: KNIMSessionType
    sessionId: string
  }): Promise<NIMResult<{ pinList: NIMMessagePin[] }>> {
    const { sessionType, sessionId } = params
    return new Promise((resolve, reject) => {
      this.nim.getMsgPins({
        id: `${sessionType}-${sessionId}`,
        done: (error, obj: NIMWebPinMsgGetResult) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(
            successRes({
              pinList: (obj.pins || []).map((pinMessage) =>
                formatNIMMessagePinGetResultWebToFlutter(pinMessage)
              ),
            })
          )
        },
      })
    })
  }

  // int 本地获取某 thread 消息的回复消息的条数
  queryReplyCountInThreadTalkBlock() {
    throw Error('not implemented.')
  }

  // <NIMThreadTalkHistory> 请求Thread聊天里的消息列表得到的信息 TODO 检查
  @loggerDec
  queryThreadTalkHistory(params: {
    message: NIMMessage
    fromTime: number
    toTime: number
    limit: number
    direction: number
    persist: boolean
  }): Promise<NIMResult<NIMThreadTalkHistory>> {
    const { message, fromTime, toTime, limit, direction } = params
    const {
      messageId,
      sessionId = '',
      timestamp = Date.now(),
      sessionType = '',
      fromAccount = '',
      serverId,
    } = message
    return new Promise((resolve, reject) => {
      this.nim.getThreadMsgs({
        scene: sessionType,
        threadMsgFromAccount: fromAccount,
        threadMsgToAccount: sessionId,
        threadMsgIdServer: String(serverId),
        threadMsgTime: timestamp,
        beginTime: fromTime,
        endTime: toTime,
        lastMsgId: messageId,
        limit,
        reverse: !!direction,
        done: (
          error: any,
          obj: {
            msgs: NIMSDKMessage[]
            threadMsg: NIMSDKMessage
            timetag: string
            total: string
          }
        ) => {
          if (error) {
            return reject(failRes(error))
          }
          const { msgs = [], threadMsg } = obj
          resolve(
            successRes({
              thread: this._formatNIMMessageWebToFlutter(threadMsg),
              time: msgs[0]?.time || 0,
              replyList: msgs.map((msg) =>
                this._formatNIMMessageWebToFlutter(msg)
              ),
            })
          )
        },
      })
    })
  }

  checkLocalAntiSpam() {
    throw Error('not implemented.')
  }

  // @loggerDec
  // checkLocalAntiSpam(params: {
  //   content: string;
  //   replacement: string;
  // }): Promise<NIMResult<NIMLocalAntiSpamResult>> {
  //   const { content, replacement } = params;
  //   return new Promise((resolve, reject) => {
  //     const res = this.nim.filterClientAntispam({
  //       content,
  //       //  antispamLexicon,
  //     });
  //     if (res.errmsg) {
  //       reject(failRes(res.errmsg));
  //     }
  //     // 未命中
  //     // static const int pass = 0;
  //     // 客户端替换。
  //     // 将命中反垃圾的词语替换成指定的文本，再将替换后的消息发送给服务器
  //     // clientReplace = 1;
  //     // // 客户端拦截。
  //     // // 命中后，开发者不应发送此消息
  //     // clientIntercept = 2;
  //     // // 服务端拦截。
  //     // // 开发者将消息相应属性配置为已命中服务端拦截库，再将消息发送给服务器（发送者能看到该消息发送，但是云信服务器不会投递该消息，接收者不会收到该消息）
  //     // erverIntercept = 3;
  //     // 命中的垃圾词操作类型，0：未命中；1：客户端替换；2：客户端拦截；3：服务器拦截；
  //     // switch (res.type) {
  //     //   case 0:
  //     //     logger.log(TAG_NAME, '没有命中反垃圾词库', res.result);
  //     //     break;
  //     //   case 1:
  //     //     logger.log(TAG_NAME, '已对特殊字符做了过滤', res.result);
  //     //     break;
  //     //   case 2:
  //     //     logger.log(TAG_NAME, '建议拒绝发送', res.result);
  //     //     break;
  //     //   case 3:
  //     //     logger.log(
  //     //       TAG_NAME,
  //     //       '建议服务器处理反垃圾，发消息带上字段clientAntiSpam',
  //     //       res.result
  //     //     );
  //     //     break;
  //     // }
  //     resolve(
  //       successRes({
  //         operator: res.type,
  //         content: res.result,
  //       })
  //     );
  //   });
  // }

  // 服务端会话列表 NIMResult<RecentSessionList>
  @loggerDec
  queryMySessionList(params: {
    minTimestamp: number
    maxTimestamp: number
    needLastMsg: number
    limit: number
    hasMore: number
  }): Promise<NIMResult<{ mySessionList: RecentSessionList }>> {
    const { minTimestamp, maxTimestamp, needLastMsg, limit } = params
    return new Promise((resolve, reject) => {
      this.nim.getServerSessions({
        minTimestamp,
        maxTimestamp,
        needLastMsg: !!needLastMsg,
        limit,
        done: (
          error,
          {
            sessionList = [],
            hasMore,
          }: { sessionList: NIMWebCloudSession[]; hasMore: boolean }
        ) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(
            successRes({
              mySessionList: {
                hasMore,
                sessionList: sessionList.map((session) =>
                  formatNIMRecentSessionWebToFlutter(session)
                ),
              },
            })
          )
        },
      })
    })
  }

  // RecentSession
  @loggerDec
  async queryMySession(params: {
    sessionId: string
    sessionType: KNIMSessionType
  }): Promise<NIMResult<{ recentSession: RecentSession }>> {
    const { sessionId, sessionType } = params
    try {
      const session = await this._getServerSession({
        to: sessionId,
        scene: sessionType,
      })
      return successRes({
        recentSession: formatNIMRecentSessionWebToFlutter(session),
      })
    } catch (error) {
      throw failRes(error)
    }
  }

  // void
  @loggerDec
  updateMySession(params: {
    sessionId: string
    sessionType: KNIMSessionType
    ext?: string
  }): Promise<NIMResult<void>> {
    const { sessionId, sessionType, ext } = params

    return new Promise((resolve, reject) => {
      this.nim.updateServerSession({
        scene: sessionType,
        to: sessionId,
        extra: ext,
        done: async (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  // void
  @loggerDec
  deleteMySession(params: {
    sessionList: NIMMySessionKey[]
  }): Promise<NIMResult<void>> {
    const sessions = params.sessionList.map((session) => {
      return {
        scene: session.sessionType,
        to: session.sessionId,
      }
    })
    return new Promise((resolve, reject) => {
      this.nim.deleteServerSessions({
        sessions,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  // int
  @loggerDec
  addQuickComment(params: {
    msg: NIMMessage
    replyType: number
    needPush: boolean
    needBadge: boolean
    ext: string
    pushTitle: string
    pushContent: string
    pushPayload: IObj
  }): Promise<NIMResult<{ result: number }>> {
    return new Promise((resolve, reject) => {
      this.nim.addQuickComment({
        msg: formatNIMMessageFlutterToWeb(this.nim.account, params.msg),
        body: params.replyType,
        custom: params.ext,
        needPush: params.needPush,
        needBadge: params.needBadge,
        pushTitle: params.pushTitle,
        apnsText: params.pushContent,
        pushPayload: params.pushPayload,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(
            successRes({
              result: Date.now(),
            })
          )
        },
      })
    })
  }

  // void
  @loggerDec
  removeQuickComment(params: {
    msg: NIMMessage
    replyType: number
    needPush: boolean
    needBadge: boolean
    ext: string
    pushTitle: string
    pushContent: string
    pushPayload: IObj
  }): Promise<NIMResult<void>> {
    return new Promise((resolve, reject) => {
      this.nim.deleteQuickComment({
        msg: formatNIMMessageFlutterToWeb(this.nim.account, params.msg),
        body: params.replyType,
        custom: params.ext,
        needPush: params.needPush,
        needBadge: params.needBadge,
        pushTitle: params.pushTitle,
        apnsText: params.pushContent,
        pushPayload: params.pushPayload,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  // <List<NIMQuickCommentOptionWrapper>>
  @loggerDec
  queryQuickComment(params: {
    msgList: NIMMessage[]
  }): Promise<
    NIMResult<{ quickCommentOptionWrapperList: NIMQuickCommentOptionWrapper[] }>
  > {
    return new Promise((resolve, reject) => {
      this.nim.getQuickComments({
        msgs: params.msgList.map((msg) =>
          formatNIMMessageFlutterToWeb(this.nim.account, msg)
        ),
        done: (error: any, commentList: NIMWebQuickCommentsResult[] = []) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(
            successRes({
              quickCommentOptionWrapperList: commentList.map((item) =>
                formatNIMQuickCommentOptionWrapperWebToFlutter(item)
              ),
            })
          )
        },
      })
    })
  }

  // 置顶 NIMStickTopSessionInfo
  @loggerDec
  addStickTopSession(params: {
    sessionId: string
    sessionType: KNIMSessionType
    ext: string
  }): Promise<NIMResult<{ stickTopSessionInfo: NIMStickTopSessionInfo }>> {
    const { sessionId, sessionType, ext } = params
    return new Promise((resolve, reject) => {
      this.nim.addStickTopSession({
        id: `${sessionType}-${sessionId}`,
        topCustom: ext,
        done: (error, obj) => {
          //   {
          //     "stickTopSession": {
          //         "id": "p2p-cs8",
          //         "scene": "p2p",
          //         "to": "cs8",
          //         "topCustom": "",
          //         "isTop": true,
          //         "unread": 0
          //     }
          // }
          if (error) {
            return reject(failRes(error))
          }
          const stickTopSessionInfo = formatNIMStickTopSessionInfoWebToFlutter(
            obj.stickTopSession
          )
          resolve(
            successRes({
              stickTopSessionInfo,
            })
          )
        },
      })
    })
  }

  // 移除置顶 void
  @loggerDec
  removeStickTopSession(params: {
    sessionId: string
    sessionType: KNIMSessionType
    ext: string
  }): Promise<NIMResult<void>> {
    const { sessionId, sessionType, ext } = params
    return new Promise((resolve, reject) => {
      this.nim.deleteStickTopSession({
        id: `${sessionType}-${sessionId}`,
        done: (error: any, obj: any) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }
  // 更新置顶 void
  @loggerDec
  updateStickTopSession(params: {
    sessionId: string
    sessionType: KNIMSessionType
    ext: string
  }): Promise<NIMResult<void>> {
    const { sessionId, sessionType, ext } = params
    return new Promise((resolve, reject) => {
      this.nim.updateStickTopSession({
        id: `${sessionType}-${sessionId}`,
        topCustom: ext,
        done: (error: any) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  // <List<NIMStickTopSessionInfo>> 查询置顶
  @loggerDec
  queryStickTopSession(): Promise<
    NIMResult<{ stickTopSessionInfoList: NIMStickTopSessionInfo[] }>
  > {
    return new Promise((resolve, reject) => {
      this.nim.getStickTopSessions({
        findDelete: false, // 是否显示已删除的会话，默认false不显示
        done: (error, sessions: NIMWebSession[] = []) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(
            successRes({
              stickTopSessionInfoList: sessions.map((session) =>
                formatNIMStickTopSessionInfoWebToFlutter(session)
              ),
            })
          )
        },
      })
    })
  }

  private _resetSessionsUnread(sessionIds: string[]): Promise<void> {
    return new Promise((resolve, reject) => {
      this.nim.resetSessionsUnread(sessionIds, (err: any) => {
        if (err) {
          reject(err)
        } else {
          resolve()
        }
      })
    })
  }

  private _resetSuperTeamSessionsUnread(sessionIds: string[]): Promise<void> {
    return new Promise((resolve, reject) => {
      this.nim.resetSuperTeamSessionsUnread(sessionIds, (err: any) => {
        if (err) {
          reject(err)
        } else {
          resolve()
        }
      })
    })
  }

  // 处理发送消息前函数
  private _sendMessageBeforeHandler(msg: NIMSDKMessage): void {
    emit<NIMMessage>('MessageService', 'onMessageStatus', {
      ...this._formatNIMMessageWebToFlutter(msg),
      status: NIMMessageStatus.sending,
    })
  }

  // 处理发送消息done函数
  private _sendMessageDoneHandler(
    error: Error,
    msg: NIMSDKMessage,
    resolve: (value: NIMResult<NIMMessage>) => void,
    reject: (value: NIMResult<any>) => void
  ): void {
    if (error) {
      emit<NIMMessage>('MessageService', 'onMessageStatus', {
        ...this._formatNIMMessageWebToFlutter(msg),
        status: NIMMessageStatus.fail,
      })
      return reject(failRes(error))
    }
    const newMsg = this._formatNIMMessageWebToFlutter(msg)
    emit<NIMMessage>('MessageService', 'onMessageStatus', newMsg)
    // @ts-ignore
    delete newMsg.serviceName
    resolve(successRes(newMsg))
  }

  /* ==== 调用nim方法 ===== */
  private _sendMessage(
    message: NIMMessage,
    replyMsg?: NIMMessage,
    resend?: boolean
  ): Promise<NIMResult<NIMMessage>> {
    /*
        发送文件入参
        通过参数fileInput传入文件选择 dom 节点或者节点 ID, SDK 会读取该节点下的文件, 在上传完成前请不要操作该节点下的文件
        通过参数blob传入 Blob 对象
        通过参数dataURL传入包含 MIME type 和 base64 数据的 data URL, 此用法需要浏览器支持 Blob
      */
    return new Promise((resolve, reject) => {
      const formatMessage = formatNIMMessageFlutterToWeb(
        this.nim.account,
        message,
        resend
      )
      const params = {
        ...formatMessage,
      }
      // const fileInfo = new File([md5], 'test.txt', {type: 'text/plain'});
      // 添加 resend 标记
      // if (resend) {
      //   params.resend = resend
      // } else {
      //   delete params.status
      // }
      if (replyMsg) {
        params.replyMsg = formatNIMMessageFlutterToWeb(
          this.nim.account,
          replyMsg
        )
      }
      const messageType = message.messageType

      switch (messageType) {
        case 'text':
          {
            const msg = this.nim.sendText({
              ...params,
              done: (error, msg) => {
                this._sendMessageDoneHandler(error, msg, resolve, reject)
              },
            })
            this._sendMessageBeforeHandler(msg)
          }
          break
        case 'custom':
          {
            const msg = this.nim.sendCustomMsg({
              ...params,
              done: (error, msg) => {
                this._sendMessageDoneHandler(error, msg, resolve, reject)
              },
            })
            this._sendMessageBeforeHandler(msg)
          }
          break
        case 'audio':
        case 'video':
        case 'file':
        case 'image':
          this.nim.sendFile({
            ...params,
            beforesend: (msg) => {
              this._sendMessageBeforeHandler(msg)
            },
            done: (error, msg) => {
              this._sendMessageDoneHandler(error, msg, resolve, reject)
            },
          })
          break
        case 'tip':
          {
            const msg = this.nim.sendTipMsg({
              ...params,
              done: (error, msg) => {
                this._sendMessageDoneHandler(error, msg, resolve, reject)
              },
            })
            this._sendMessageBeforeHandler(msg)
          }
          break
        case 'location':
          {
            const { lat, lng, title } =
              message.messageAttachment as NIMLocationAttachment
            const msg = this.nim.sendGeo({
              ...params,
              geo: {
                lat,
                lng,
                title,
              },
              done: (error, msg) => {
                this._sendMessageDoneHandler(error, msg, resolve, reject)
              },
            })
            this._sendMessageBeforeHandler(msg)
          }
          break
        default:
          return reject('The sending type is not supported!')
      }
    })
  }

  // 获取本地历史记录
  private _getLocalMsgs(options: {
    start?: number
    end?: number
    desc?: boolean // true 表示从 end 开始查, false 表示从 begin 开始查
    sessionId?: string // 'p2p-account'
    type?: string
    types?: string[]
    subTypes?: number[]
    keyword?: string
    limit?: number
    filterFunc?: any
  }): Promise<NIMSDKMessage[]> {
    // 对齐移动端的 limit 为 < 1 时，返回空数组
    if (typeof options.limit === 'number' && options.limit < 1) {
      return Promise.resolve([])
    }
    return new Promise((resolve, reject) => {
      this.nim.getLocalMsgs({
        ...options,
        done: (error, obj) => {
          if (error) {
            return reject(error)
          }
          resolve(obj.msgs || [])
        },
      })
    })
  }

  // 获取云端历史记录
  private _getHistoryMsgs(options: {
    scene: NIMSessionType
    to: string
    reverse?: boolean
    beginTime?: number
    endTime?: number
    lastMsgId?: string
    limit?: number
    msgTypes?: string[]
    persist?: boolean
  }): Promise<NIMSDKMessage[]> {
    return new Promise((resolve, reject) => {
      this.nim.getHistoryMsgs({
        ...options,
        done: (error, obj) => {
          if (error) {
            return reject(error)
          }
          const msgs = obj.msgs || []
          if (msgs.length > 0 && options.persist) {
            this.nim.saveMsgsToLocal({
              msgs,
              done: (error) => {
                if (error) {
                  return reject(error)
                }
                resolve(obj.msgs || [])
              },
            })
          } else {
            resolve(obj.msgs || [])
          }
        },
      })
    })
  }

  private _deleteLocalMsg(msg) {
    return new Promise((resolve, reject) => {
      this.nim.deleteLocalMsg({
        msg,
        done: (error, obj) => {
          if (error) {
            return reject(error)
          }
          resolve(obj)
        },
      })
    })
  }

  private _deleteAllLocalMsgs() {
    return new Promise((resolve, reject) => {
      this.nim.deleteAllLocalMsgs({
        done: (error, obj) => {
          if (error) {
            return reject(error)
          }
          resolve(obj)
        },
      })
    })
  }

  // 获取云端历史记录
  private _searchHistoryMsgs(options: {
    fromTime?: number
    toTime?: number
    keyword: string
    msgLimit?: number
    sessionLimit?: number
    msgSubTypeList?: number[]
    msgTypeList?: KNIMWebMsgType[]
    order?: keyof typeof SearchOrder
    p2pList?: string[]
    senderList?: string[]
    teamList?: string[]
  }): Promise<NIMSDKMessage[]> {
    return new Promise((resolve, reject) => {
      this.nim.msgFtsInServer({
        ...options,
        done: (error, obj) => {
          if (error) {
            return reject(error)
          }
          resolve(obj.msgs || [])
        },
      })
    })
  }

  private _getLocalSession(sessionId: string): Promise<NIMWebSession> {
    return new Promise((resolve, reject) => {
      this.nim.getLocalSession({
        sessionId,
        done: (error, obj) => {
          if (error) {
            return reject(error)
          }
          resolve(obj)
        },
      })
    })
  }

  private _getLocalSessions(options?: {
    lastSessionId?: string
    limit?: number
    reverse?: boolean
  }): Promise<NIMWebSession[]> {
    return new Promise((resolve, reject) => {
      this.nim.getLocalSessions({
        ...options,
        done: (error, obj) => {
          if (error) {
            return reject(error)
          }
          resolve(obj.sessions || [])
        },
      })
    })
  }

  private _deleteLocalSession(options: {
    id: string | string[]
    isLogic?: boolean
    isDeleteRoaming?: boolean
  }) {
    return new Promise<void>((resolve, reject) => {
      this.nim.deleteLocalSession({
        ...options,
        done: (error, obj) => {
          if (error) {
            return reject(error)
          }
          resolve(obj)
        },
      })
    })
  }

  private _getServerSession(options: {
    scene: string
    to: string
  }): Promise<NIMWebCloudSession> {
    return new Promise((resolve, reject) => {
      this.nim.getServerSession({
        ...options,
        done: (error, obj) => {
          if (error) {
            return reject(error)
          }
          resolve(obj)
        },
      })
    })
  }

  private _formatNIMMessageWebToFlutter(message: NIMSDKMessage): NIMMessage {
    const msg = formatNIMMessageWebToFlutter(message)
    msg.isRemoteRead = this.nim.isMsgRemoteRead(message) ?? false
    return msg
  }
}

export default MessageService
