import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from 'yunxin-log-debug'
import { NIMResult } from '../types'
import { failRes, successRes } from '../utils'

const TAG_NAME = 'SettingsService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

class SettingsService {
  constructor(private rootService: RootService, private nim: any) {}

  // void 更新多端推送配置选项
  @loggerDec
  enableMobilePushWhenPCOnline(params: {
    enable: boolean
  }): Promise<NIMResult<void>> {
    return new Promise((resolve, reject) => {
      this.nim.updatePushNotificationMultiportConfig({
        shouldPushNotificationWhenPCOnline: params.enable,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  // void 获取当前多端推送配置选项
  isMobilePushEnabledWhenPCOnline() {
    throw Error('not implemented.')
  }

  enableNotificationAndroid() {
    throw Error('not implemented.')
  }

  updateNotificationConfigAndroid() {
    throw Error('not implemented.')
  }

  enablePushServiceAndroid() {
    throw Error('not implemented.')
  }

  isPushServiceEnabledAndroid() {
    throw Error('not implemented.')
  }

  getPushNoDisturbConfig() {
    throw Error('not implemented.')
  }

  setPushNoDisturbConfig() {
    throw Error('not implemented.')
  }

  isPushShowDetailEnabled() {
    throw Error('not implemented.')
  }

  enablePushShowDetail() {
    throw Error('not implemented.')
  }

  updateAPNSTokenIOS() {
    throw Error('not implemented.')
  }

  archiveLogs() {
    throw Error('not implemented.')
  }

  uploadLogs() {
    throw Error('not implemented.')
  }

  clearDirCache() {
    throw Error('not implemented.')
  }

  getSizeOfDirCache() {
    throw Error('not implemented.')
  }
}

export default SettingsService
