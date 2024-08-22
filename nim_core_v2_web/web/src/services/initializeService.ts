import { successRes } from '../utils'
import { NIMResult } from '../types'
import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from '@xkit-yx/utils'
import {
  NIMInitializeOptions,
  NIMOtherOptions,
} from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/NIMInterface'
import V2NIM from 'nim-web-sdk-ng'

const TAG_NAME = 'InitializeService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

export interface NIMSDKOptions {
  initializeOptions: NIMInitializeOptions & {
    loginExtensionProviderDelay?: number
    tokenProviderDelay?: number
    reconnectDelayProviderDelay?: number
  }
  otherOptions: NIMOtherOptions
}

class InitializeService {
  initOptions?: NIMSDKOptions

  constructor(private rootService: RootService, private nim: V2NIM) {}

  // 用户初始化传参保存
  @loggerDec
  async initialize(options: NIMSDKOptions): Promise<NIMResult<void>> {
    this.initOptions = options

    const nim = V2NIM.getInstance(options.initializeOptions, {
      ...options.otherOptions,
      cloudStorageConfig: {
        ...options.otherOptions?.cloudStorageConfig,
        s3: options.otherOptions?.cloudStorageConfig?.s3 ? window.s3 : void 0,
      },
    })

    Object.assign(this.nim, nim)

    // 如果这里参数有 debug 级别，就在这里设置
    if (
      options.initializeOptions.debugLevel &&
      options.initializeOptions.debugLevel !== 'off'
    ) {
      logger.setLevel(options.initializeOptions.debugLevel)
    } else {
      logger.setLevel('silent')
    }

    this.rootService.init()

    return successRes()
  }

  @loggerDec
  async releaseDesktop(): Promise<NIMResult<void>> {
    this.rootService.destroy()

    return successRes()
  }

  destroy(): void {
    //
  }
}

export default InitializeService
