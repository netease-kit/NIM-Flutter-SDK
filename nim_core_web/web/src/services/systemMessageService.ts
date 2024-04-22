import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from 'yunxin-log-debug'
import { IObj, NIMResult } from '../types'
import { failRes, successRes } from '../utils'
import { WebSystemMessageType, NIMSessionType } from '../types/enums'
import {
  NIMWebSystemMessage,
  KSystemMessageStatus,
  KSystemMessageType,
  NIMAntiSpamOption,
} from '../types/message'
import {
  formatNIMSystemMessageWebToFlutter,
  SystemMessageTypeWebToFlutterMap,
} from '../format'

const TAG_NAME = 'SystemMessageService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

export interface CustomNotificationConfig {
  // default true
  enablePush?: boolean
  // default false
  enablePushNick?: boolean
  // default true
  enableUnreadCount?: boolean
}

export interface CustomNotification {
  sessionId?: string
  sessionType?: keyof typeof NIMSessionType
  fromAccount?: string
  time?: number
  content?: string
  // 默认 true
  sendToOnlineUserOnly?: boolean
  apnsText?: string
  pushPayload?: IObj
  config?: CustomNotificationConfig
  antiSpamOption?: NIMAntiSpamOption
  env?: string
}

export interface SystemMessage {
  messageId?: number
  type?: KSystemMessageType
  fromAccount?: string
  targetId?: string
  time?: number
  status?: KSystemMessageStatus
  content?: string
  attach?: string
  attachObject?: IObj
  unread?: boolean
  customInfo?: string
}

class SystemMessageService {
  constructor(private rootService: RootService, private nim: any) {}

  // <systemMessageList, List<SystemMessage>> 获取系统消息未读数据
  @loggerDec
  async querySystemMessageUnread(): Promise<
    NIMResult<{ systemMessageList: SystemMessage[] }>
  > {
    try {
      const sysMsgs = await this._getLocalSysMsgs({
        read: false,
      })
      const systemMessageList = sysMsgs
        .map((sysMsg) => formatNIMSystemMessageWebToFlutter(sysMsg))
        .filter((item) => item.type !== undefined)
      return successRes({
        systemMessageList,
      })
    } catch (error) {
      throw failRes(error)
    }
  }

  // int
  @loggerDec
  async querySystemMessageUnreadCount(): Promise<NIMResult<number>> {
    try {
      // TODO: 100 条
      let sysMsgs = await this._getLocalSysMsgs({
        read: false,
      })
      sysMsgs = sysMsgs.filter(
        (item) => SystemMessageTypeWebToFlutterMap[item.type] !== undefined
      )
      return successRes(sysMsgs.length)
    } catch (error) {
      throw failRes(error)
    }
  }

  // int
  @loggerDec
  async querySystemMessageUnreadCountByType(params: {
    systemMessageTypeList: KSystemMessageType[]
  }): Promise<NIMResult<number>> {
    try {
      let sysMsgs = await this._getLocalSysMsgs({
        read: false,
      })
      sysMsgs = sysMsgs.filter(
        (item) => SystemMessageTypeWebToFlutterMap[item.type] !== undefined
      )
      const { systemMessageTypeList } = params
      if (systemMessageTypeList.length) {
        return successRes(
          sysMsgs.filter((item) =>
            systemMessageTypeList.includes(
              SystemMessageTypeWebToFlutterMap[item.type]
            )
          ).length
        )
      }
      return successRes(sysMsgs.length)
    } catch (error) {
      throw failRes(error)
    }
  }

  // void 标记所有通知为已读
  @loggerDec
  async resetSystemMessageUnreadCount(): Promise<NIMResult<void>> {
    try {
      const sysMsgs = await this._getLocalSysMsgs({
        read: false,
      })
      await this._markSysMsgRead(sysMsgs)
      return successRes()
    } catch (error) {
      throw failRes(error)
    }
  }

  // void 根据类型设置未读数
  @loggerDec
  async resetSystemMessageUnreadCountByType(params: {
    systemMessageTypeList: KSystemMessageType[]
  }): Promise<NIMResult<void>> {
    try {
      // TODO: 100条开外的消息
      const sysMsgs = await this._getLocalSysMsgs({
        read: false,
      })
      const { systemMessageTypeList = [] } = params
      const msgs = sysMsgs.filter((item) =>
        systemMessageTypeList.includes(
          SystemMessageTypeWebToFlutterMap[item.type]
        )
      )
      await this._markSysMsgRead(msgs)
      return successRes()
    } catch (error) {
      throw failRes(error)
    }
  }

  // 设置单条系统通知为已读
  // <NIMResult<void> [messageId] 系统通知ID，暂时先查了系统消息，然后再拿到所有消息体传入，
  // 会有获取不到的风险，sdk接口默认只查询100个
  @loggerDec
  async setSystemMessageRead(params: {
    messageId: number
  }): Promise<NIMResult<void>> {
    try {
      const sysMsgs = await this._getLocalSysMsgs({
        read: false,
      })
      const sysMsg = sysMsgs.find(
        (item) => item.idServer === String(params.messageId)
      )
      if (sysMsg) {
        await this._markSysMsgRead([sysMsg])
      }
      return successRes()
    } catch (error) {
      throw failRes(error)
    }
  }

  // void 删除所有系统通知
  @loggerDec
  async clearSystemMessages(): Promise<NIMResult<void>> {
    try {
      await this._deleteAllLocalSysMsgs()
      return successRes()
    } catch (error) {
      throw failRes(error)
    }
  }

  // void 根据类型删除系统消息
  @loggerDec
  async clearSystemMessagesByType(params: {
    systemMessageTypeList: KSystemMessageType[]
  }): Promise<NIMResult<void>> {
    try {
      const sysMsgs = await this._getLocalSysMsgs()
      const { systemMessageTypeList } = params
      // 类型未空，删除所有的
      if (!systemMessageTypeList.length) {
        await this._deleteAllLocalSysMsgs()
        return successRes()
      }

      // 类型存在先过滤再针对性删除
      const idServers = sysMsgs
        .filter((item) =>
          systemMessageTypeList.includes(
            SystemMessageTypeWebToFlutterMap[item.type]
          )
        )
        .map((item) => item.idServer)
        .filter((item) => !!item) as string[]
      if (idServers.length === 0) {
        return successRes()
      }
      await this._deleteLocalSysMsg(idServers)
      return successRes()
    } catch (error) {
      throw failRes(error)
    }
  }

  // void
  @loggerDec
  async deleteSystemMessage(params: {
    messageId: number
  }): Promise<NIMResult<void>> {
    try {
      await this._deleteLocalSysMsg(String(params.messageId))
      return successRes()
    } catch (error) {
      throw failRes(error)
    }
  }

  // void
  @loggerDec
  async setSystemMessageStatus(params: {
    systemMessageStatus: KSystemMessageStatus
    messageId: number
  }): Promise<NIMResult<void>> {
    const { systemMessageStatus, messageId } = params
    // 'init': 未处理状态
    // 'passed': 已通过
    // 'rejected': 已拒绝
    // 'error': 错误
    return new Promise((resolve, reject) => {
      this.nim.updateLocalSysMsg({
        idServer: String(messageId),
        state:
          systemMessageStatus === 'declined' ? 'rejected' : systemMessageStatus,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  // void 发送自定义系统通知
  @loggerDec
  async sendCustomNotification(params: {
    customNotification: CustomNotification
  }): Promise<NIMResult<void>> {
    const {
      sessionId = '',
      sessionType = '',
      content = '',
      apnsText = '',
      pushPayload = {},
      config = {},
      sendToOnlineUserOnly = true,
      // fromAccount,
      // time,
      // antiSpamOption,
      env = '',
    } = params.customNotification
    const {
      enablePush = true,
      enablePushNick = false,
      enableUnreadCount,
    } = config

    return new Promise((resolve, reject) => {
      this.nim.sendCustomSysMsg({
        scene: sessionType,
        to: sessionId,
        content,
        apnsText,
        pushPayload: JSON.stringify(pushPayload),
        env,
        isPushable: enablePush,
        needPushNick: enablePushNick,
        sendToOnlineUsersOnly: sendToOnlineUserOnly,
        // cc 没找到该字段
        done: function (error) {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  // 查询未读的系统消息
  private _getLocalSysMsgs(
    options?: Partial<{
      category: 'team' | 'friend'
      type: keyof typeof WebSystemMessageType
      read: boolean
      lastIdServer: string
      limit: number
      reverse: boolean
    }>
  ): Promise<NIMWebSystemMessage[]> {
    return new Promise((resolve, reject) => {
      // TODO: 100条的限制
      this.nim.getLocalSysMsgs({
        ...options,
        done: (error, obj) => {
          if (error) {
            return reject(error)
          }
          resolve(obj.sysMsgs || [])
        },
      })
    })
  }

  // 标记系统通知为已收到
  private _markSysMsgRead(sysMsgs: NIMWebSystemMessage[]): Promise<void> {
    if (!sysMsgs.length) {
      return Promise.resolve()
    }
    return new Promise((resolve, reject) => {
      this.nim.markSysMsgRead({
        sysMsgs,
        done: (error) => {
          if (error) {
            return reject(error)
          }
          resolve()
        },
      })
    })
  }

  // 删除所有本地系统通知
  private _deleteAllLocalSysMsgs(): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      // 如果未开启db，手动先resolve
      // if (
      //   !this.rootService.InitializeService.initOptions?.enableDatabaseBackup
      // ) {
      //   resolve()
      // }
      this.nim.deleteAllLocalSysMsgs({
        done: (error) => {
          if (error) {
            return reject(error)
          }
          resolve()
        },
      })
    })
  }

  // 删除本地系统通知
  private _deleteLocalSysMsg(idServer: string | string[]): Promise<void> {
    return new Promise((resolve, reject) => {
      this.nim.deleteLocalSysMsg({
        idServer, // String | Array.<String>
        done: (error) => {
          if (error) {
            return reject(error)
          }
          resolve()
        },
      })
    })
  }
}

export default SystemMessageService
