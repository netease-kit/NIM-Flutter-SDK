import {
  successRes,
  failRes,
  emit,
  NIMAIModelRoleType,
  formatAIModelRoleType,
} from '../utils'
import { NIMResult } from '../types'
import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from '@xkit-yx/utils'
import V2NIM from 'nim-web-sdk-ng'
import { V2NIMError } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/types'
import {
  V2NIMAIModelCallMessage,
  V2NIMAIModelCallResponse,
  V2NIMAIUser,
  V2NIMProxyAIModelCallParams,
} from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMAIService'

const TAG_NAME = 'AIService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

class AIService {
  constructor(private rootService: RootService, private nim: V2NIM) {
    this._onProxyAIModelCall = this._onProxyAIModelCall.bind(this)

    nim.V2NIMAIService.on('onProxyAIModelCall', this._onProxyAIModelCall)
  }

  destroy(): void {
    this.nim.V2NIMAIService.off('onProxyAIModelCall', this._onProxyAIModelCall)
  }

  @loggerDec
  async getAIUserList(): Promise<NIMResult<{ userList: V2NIMAIUser[] }>> {
    try {
      return successRes({
        userList: await this.nim.V2NIMAIService.getAIUserList(),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async proxyAIModelCall(params: {
    params: Omit<V2NIMProxyAIModelCallParams, 'messages'> & {
      messages?: (Omit<V2NIMAIModelCallMessage, 'role'> & {
        role: NIMAIModelRoleType
      })[]
    }
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMAIService.proxyAIModelCall({
          ...params.params,
          messages: params.params.messages?.length
            ? params.params.messages.map((item) => ({
                ...item,
                role: formatAIModelRoleType(item.role),
              }))
            : void 0,
        })
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  private _onProxyAIModelCall(data: V2NIMAIModelCallResponse): void {
    logger.log('_onProxyAIModelCall', data)
    emit('AIService', 'onProxyAIModelCall', data)
  }
}

export default AIService
