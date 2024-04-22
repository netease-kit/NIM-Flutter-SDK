import RootService from './rootService'
import { successRes, failRes } from '../utils'
import { formatNIMSubEventToFlutter } from '../format'
import { NIMResult } from '../types'
import { logger } from '../logger'
import { createLoggerDecorator } from 'yunxin-log-debug'
import { NIMClientType } from 'src/types/enums'

const TAG_NAME = 'EventSubscribeService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

export interface NIMSubEvent {
  subscribeTime: string
  time: string
  to: string
  type: string
}

export interface NIMEvent {
  //事件ID
  eventId?: string

  //事件类型，1-99999 为云信保留类型
  eventType?: number

  //事件的状态值
  eventValue?: number

  // 事件的扩展字段，最大长度为 256 字节，由事件发布客户端配置
  config?: string

  //事件的有效期，范围为 60s 到 7days，数值单位为秒
  expiry?: number

  //是否只广播给在线用户，若为 false，事件支持在线广播和登录后同步
  broadcastOnlineOnly?: boolean

  //是否支持多端同步
  syncSelfEnable?: boolean

  //事件发布者的云信账号
  publisherAccount?: string

  //事件发布的时间
  publishTime?: number

  //事件发布者客户端类型 @see ClientType
  publisherClientType?: number

  //多端 config 配置
  multiClientConfig?: string

  //解析 multiClientConfig 的多端 config 配置 map
  multiClientConfigMap?: { [key: number]: string }

  //预定义事件中服务端配置项,仅仅对预留事件有效
  nimConfig?: string
}

export interface EventSubscribeResult {
  //事件类型，1-99999 为云信保留类型
  eventType?: number

  //事件的有效期，范围为 60s 到 7days，数值单位为秒
  expiry?: number

  //事件发布的时间
  time?: number

  //事件发布者的账号
  publisherAccount?: string
}

export interface EventSubscribeRequest {
  //事件类型，1-99999 为云信保留类型，自定义的订阅事件请选择此范围意外的值，在 web 中表示 type，并且只能传 1
  eventType: number

  //订阅的有效期，范围为 60s 到 30days，数值单位为秒
  expiry: number

  //订阅后是否立刻同步事件状态值，默认为 false，如果填 true，则会收到事件状态回调
  syncCurrentValue?: boolean

  //事件发布者的账号集合
  publishers: string[]

  // createEventSubscribe: (params: {
  //   expiry: number;
  //   syncCurrentValue?: boolean;
  //   publishers: string[];
  // }) => {
  //   eventType: number;
  //   expiry: number;
  //   syncCurrentValue?: boolean;
  //   publishers: string[];
  // };
}

class EventSubscribeService {
  constructor(private rootService: RootService, private nim: any) {}

  @loggerDec
  registerEventSubscribe(
    request: EventSubscribeRequest
  ): Promise<NIMResult<{ resultList: string[] }>> {
    return new Promise((resolve, reject) => {
      this.nim.subscribeEvent({
        type: request.eventType,
        accounts: request.publishers,
        subscribeTime: request.expiry,
        sync:
          request.syncCurrentValue === undefined
            ? false
            : request.syncCurrentValue,
        done: (err: any, obj: any) => {
          if (err) {
            return reject(failRes(err))
          }
          resolve(
            successRes({
              resultList: obj.failedAccounts || [],
            })
          )
        },
      })
    })
  }

  @loggerDec
  batchUnSubscribeEvent(
    request: EventSubscribeRequest
  ): Promise<NIMResult<void>> {
    return new Promise((resolve, reject) => {
      this.nim.unSubscribeEventsByType({
        type: request.eventType,
        done: (err: any, obj: any) => {
          if (err) {
            return reject(failRes(err))
          }
          resolve(successRes())
        },
      })
    })
  }

  @loggerDec
  unregisterEventSubscribe(
    request: EventSubscribeRequest
  ): Promise<NIMResult<void>> {
    return new Promise((resolve, reject) => {
      this.nim.unSubscribeEventsByAccounts({
        type: request.eventType,
        accounts: request.publishers,
        done: (err: any, obj: any) => {
          if (err) {
            return reject(failRes(err))
          }
          resolve(successRes())
        },
      })
    })
  }

  @loggerDec
  publishEvent(event: NIMEvent): Promise<NIMResult<void>> {
    return new Promise((resolve, reject) => {
      this.nim.publishEvent({
        type: event.eventType,
        value: event.eventValue,
        custom: event.config,
        validTime: event.expiry,
        broadcastType: event.broadcastOnlineOnly ? 1 : 2,
        sync: event.syncSelfEnable === undefined ? false : event.syncSelfEnable,
        done: (err: any, obj: any) => {
          if (err) {
            return reject(failRes(err))
          }
          resolve(successRes())
        },
      })
    })
  }

  @loggerDec
  querySubscribeEvent(
    request: EventSubscribeRequest
  ): Promise<NIMResult<{ eventSubscribeResultList: EventSubscribeResult[] }>> {
    return new Promise((resolve, reject) => {
      if (request.publishers) {
        this.nim.querySubscribeEventsByAccounts({
          type: request.eventType,
          accounts: request.publishers,
          done: (err: any, obj: { msgEventSubscribes: NIMSubEvent[] }) => {
            if (err) {
              return reject(failRes(err))
            }
            resolve(
              successRes({
                eventSubscribeResultList:
                  obj.msgEventSubscribes.map(formatNIMSubEventToFlutter) || [],
              })
            )
          },
        })
      } else {
        this.nim.querySubscribeEventsByType({
          type: request.eventType,
          done: (err: any, obj: { msgEventSubscribes: NIMSubEvent[] }) => {
            if (err) {
              return reject(failRes(err))
            }
            resolve(
              successRes({
                eventSubscribeResultList:
                  obj.msgEventSubscribes.map(formatNIMSubEventToFlutter) || [],
              })
            )
          },
        })
      }
    })
  }
}

export default EventSubscribeService
