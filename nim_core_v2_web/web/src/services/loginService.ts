import V2NIM from 'nim-web-sdk-ng'
import RootService from './rootService.js'
import { NIMResult } from '../types.js'
import { successRes, failRes, emit } from '../utils.js'
import { logger } from '../logger.js'
import { createLoggerDecorator } from '@xkit-yx/utils'
import {
  V2NIMConnectStatus,
  V2NIMKickedOfflineDetail,
  V2NIMLoginClient,
  V2NIMLoginClientChange,
  V2NIMLoginOption,
  V2NIMLoginStatus,
} from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMLoginService.js'
import {
  V2NIMDataSyncDetail,
  V2NIMDataSyncState,
  V2NIMDataSyncType,
} from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/SyncServiceInterface.js'
import { V2NIMError } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/types.js'
import { YX_EMIT_RESULT, defaultDelay } from 'src/constants.js'

const TAG_NAME = 'LoginService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

class LoginService {
  constructor(private rootService: RootService, private nim: V2NIM) {
    this._onLoginStatus = this._onLoginStatus.bind(this)
    this._onLoginFailed = this._onLoginFailed.bind(this)
    this._onKickedOffline = this._onKickedOffline.bind(this)
    this._onLoginClientChanged = this._onLoginClientChanged.bind(this)
    this._onConnectStatus = this._onConnectStatus.bind(this)
    this._onDisconnected = this._onDisconnected.bind(this)
    this._onConnectFailed = this._onConnectFailed.bind(this)
    this._onDataSync = this._onDataSync.bind(this)

    // 登录状态变化
    nim.V2NIMLoginService.on('onLoginStatus', this._onLoginStatus)
    // 登录失败
    nim.V2NIMLoginService.on('onLoginFailed', this._onLoginFailed)
    // 被踢下线
    nim.V2NIMLoginService.on('onKickedOffline', this._onKickedOffline)
    // 多端登录回调
    nim.V2NIMLoginService.on('onLoginClientChanged', this._onLoginClientChanged)
    // 连接状态变化
    nim.V2NIMLoginService.on('onConnectStatus', this._onConnectStatus)
    // 登录连接断开
    nim.V2NIMLoginService.on('onDisconnected', this._onDisconnected)
    // 登录连接失败
    nim.V2NIMLoginService.on('onConnectFailed', this._onConnectFailed)
    // 数据同步
    nim.V2NIMLoginService.on('onDataSync', this._onDataSync)
  }

  @loggerDec
  async login(params: {
    accountId: string
    token: string
    option: V2NIMLoginOption
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMLoginService.login(params.accountId, params.token, {
          ...params.option,
          tokenProvider: async (accountId) => {
            const params = { accountId, [YX_EMIT_RESULT]: '' }
            emit('LoginService', 'getToken', params)

            return new Promise((resolve) => {
              setTimeout(() => {
                resolve(params[YX_EMIT_RESULT])
              }, this.rootService.InitializeService.initOptions?.initializeOptions?.tokenProviderDelay || defaultDelay)
            })
          },
          loginExtensionProvider: async (accountId) => {
            const params = { accountId, [YX_EMIT_RESULT]: '' }
            emit('LoginService', 'getLoginExtension', params)

            return new Promise((resolve) => {
              setTimeout(() => {
                resolve(params[YX_EMIT_RESULT])
              }, this.rootService.InitializeService.initOptions?.initializeOptions?.loginExtensionProviderDelay || defaultDelay)
            })
          },
        })
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async logout(): Promise<NIMResult<void>> {
    try {
      return successRes(await this.nim.V2NIMLoginService.logout())
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getLoginUser(): Promise<NIMResult<string>> {
    return successRes(this.nim.V2NIMLoginService.getLoginUser())
  }

  @loggerDec
  async getLoginStatus(): Promise<NIMResult<{ status: V2NIMLoginStatus }>> {
    return successRes({ status: this.nim.V2NIMLoginService.getLoginStatus() })
  }

  @loggerDec
  async getLoginClients(): Promise<
    NIMResult<{ loginClient: V2NIMLoginClient[] }>
  > {
    return successRes({
      loginClient: this.nim.V2NIMLoginService.getLoginClients(),
    })
  }

  @loggerDec
  async kickOffline(params: {
    client: V2NIMLoginClient
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMLoginService.kickOffline(params.client)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getKickedOfflineDetail(): Promise<
    NIMResult<V2NIMKickedOfflineDetail | null>
  > {
    return successRes(this.nim.V2NIMLoginService.getKickedOfflineDetail())
  }

  @loggerDec
  async getConnectStatus(): Promise<NIMResult<{ status: V2NIMConnectStatus }>> {
    return successRes({ status: this.nim.V2NIMLoginService.getConnectStatus() })
  }

  @loggerDec
  async getDataSync(): Promise<NIMResult<{ dataSync: V2NIMDataSyncDetail[] }>> {
    return successRes({
      dataSync: this.nim.V2NIMLoginService.getDataSync() || [],
    })
  }

  @loggerDec
  async getChatroomLinkAddress(params: {
    roomId: string
  }): Promise<NIMResult<{ linkAddress: string[] }>> {
    try {
      return successRes({
        linkAddress: await this.nim.V2NIMLoginService.getChatroomLinkAddress(
          params.roomId,
          false
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async setReconnectDelayProvider(): Promise<NIMResult<void>> {
    return successRes(
      // @ts-ignore
      this.nim.V2NIMLoginService.setReconnectDelayProvider(async (delay) => {
        const params = { delay, [YX_EMIT_RESULT]: 0 }
        emit('LoginService', 'getReconnectDelay', params)

        return new Promise((resolve) => {
          setTimeout(() => {
            // @ts-ignore
            resolve(params[YX_EMIT_RESULT])
          }, this.rootService.InitializeService.initOptions?.initializeOptions?.reconnectDelayProviderDelay || defaultDelay)
        })
      })
    )
  }

  destroy(): void {
    this.nim.V2NIMLoginService.off('onLoginStatus', this._onLoginStatus)
    this.nim.V2NIMLoginService.off('onLoginFailed', this._onLoginFailed)
    this.nim.V2NIMLoginService.off('onKickedOffline', this._onKickedOffline)
    this.nim.V2NIMLoginService.off(
      'onLoginClientChanged',
      this._onLoginClientChanged
    )
    this.nim.V2NIMLoginService.off('onConnectStatus', this._onConnectStatus)
    this.nim.V2NIMLoginService.off('onDisconnected', this._onDisconnected)
    this.nim.V2NIMLoginService.off('onConnectFailed', this._onConnectFailed)
    this.nim.V2NIMLoginService.off('onDataSync', this._onDataSync)
  }

  private _onLoginStatus(status: V2NIMLoginStatus) {
    logger.log('_onLoginStatus', status)
    emit('LoginService', 'onLoginStatus', { status })
  }

  private _onLoginFailed(e: V2NIMError) {
    logger.log('_onLoginFailed', e)
    emit('LoginService', 'onLoginFailed', e)
  }

  private _onKickedOffline(e: V2NIMKickedOfflineDetail) {
    logger.log('_onKickedOffline', e)
    emit('LoginService', 'onKickedOffline', e)
  }

  private _onLoginClientChanged(
    change: V2NIMLoginClientChange,
    clients: V2NIMLoginClient[]
  ) {
    logger.log('_onLoginClientChanged', change, clients)
    emit('LoginService', 'onLoginClientChanged', { change, clients })
  }

  private _onConnectStatus(status: V2NIMConnectStatus) {
    logger.log('_onConnectStatus', status)
    emit('LoginService', 'onConnectStatus', { status })
  }

  private _onDisconnected(e: V2NIMError) {
    logger.log('_onDisconnected', e)
    emit('LoginService', 'onDisconnected', e)
  }

  private _onConnectFailed(e: V2NIMError) {
    logger.log('_onConnectFailed', e)
    emit('LoginService', 'onConnectFailed', e)
  }

  private _onDataSync(
    type: V2NIMDataSyncType,
    state: V2NIMDataSyncState,
    error?: V2NIMError | undefined
  ) {
    logger.log('_onDataSync', { type, state, error })
    emit('LoginService', 'onDataSync', { type, state, error })
  }
}

export default LoginService
