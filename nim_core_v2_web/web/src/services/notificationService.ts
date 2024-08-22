import { successRes, failRes, emit } from '../utils'
import { NIMResult } from '../types'
import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from '@xkit-yx/utils'
import V2NIM from 'nim-web-sdk-ng'
import { V2NIMError } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/types'
import {
  V2NIMBroadcastNotification,
  V2NIMCustomNotification,
  V2NIMSendCustomNotificationParams,
} from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMNotificationService'

const TAG_NAME = 'NotificationService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

class NotificationService {
  constructor(private rootService: RootService, private nim: V2NIM) {
    this._onReceiveBroadcastNotifications =
      this._onReceiveBroadcastNotifications.bind(this)
    this._onReceiveCustomNotifications =
      this._onReceiveCustomNotifications.bind(this)

    // 收到广播通知
    nim.V2NIMNotificationService.on(
      'onReceiveBroadcastNotifications',
      this._onReceiveBroadcastNotifications
    )
    // 收到自定义通知
    nim.V2NIMNotificationService.on(
      'onReceiveCustomNotifications',
      this._onReceiveCustomNotifications
    )
  }

  destroy(): void {
    this.nim.V2NIMNotificationService.off(
      'onReceiveBroadcastNotifications',
      this._onReceiveBroadcastNotifications
    )
    this.nim.V2NIMNotificationService.off(
      'onReceiveCustomNotifications',
      this._onReceiveCustomNotifications
    )
  }

  @loggerDec
  async sendCustomNotification(params: {
    conversationId: string
    content: string
    params: V2NIMSendCustomNotificationParams
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMNotificationService.sendCustomNotification(
          params.conversationId,
          params.content,
          params.params
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  private _onReceiveBroadcastNotifications(
    broadcastNotification: V2NIMBroadcastNotification[]
  ): void {
    logger.log('_onReceiveBroadcastNotifications', broadcastNotification)
    emit('NotificationService', 'onReceiveBroadcastNotifications', {
      broadcastNotifications: broadcastNotification,
    })
  }

  private _onReceiveCustomNotifications(
    customNotification: V2NIMCustomNotification[]
  ): void {
    logger.log('_onReceiveCustomNotifications', customNotification)
    emit('NotificationService', 'onReceiveCustomNotifications', {
      customNotifications: customNotification,
    })
  }
}

export default NotificationService
