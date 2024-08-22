import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from '@xkit-yx/utils'
import { NIMResult } from '../types'
import { failRes, successRes, emit } from '../utils'
import V2NIM from 'nim-web-sdk-ng'
import {
  V2NIMP2PMessageMuteMode,
  V2NIMTeamMessageMuteMode,
} from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMSettingService'
import { V2NIMTeamType } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMTeamService'
import { NOT_IMPLEMENTED_ERROR } from '../constants'
import { V2NIMError } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/types'

const TAG_NAME = 'SettingsService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

class SettingsService {
  constructor(private rootService: RootService, private nim: V2NIM) {
    this._onP2PMessageMuteModeChanged =
      this._onP2PMessageMuteModeChanged.bind(this)
    this._onTeamMessageMuteModeChanged =
      this._onTeamMessageMuteModeChanged.bind(this)

    this.nim.V2NIMSettingService.on(
      'onP2PMessageMuteModeChanged',
      this._onP2PMessageMuteModeChanged
    )
    this.nim.V2NIMSettingService.on(
      'onTeamMessageMuteModeChanged',
      this._onTeamMessageMuteModeChanged
    )
  }

  destroy(): void {
    this.nim.V2NIMSettingService.off(
      'onP2PMessageMuteModeChanged',
      this._onP2PMessageMuteModeChanged
    )
    this.nim.V2NIMSettingService.off(
      'onTeamMessageMuteModeChanged',
      this._onTeamMessageMuteModeChanged
    )
  }

  @loggerDec
  async getDndConfig(): Promise<NIMResult<any>> {
    throw NOT_IMPLEMENTED_ERROR
  }

  @loggerDec
  async getConversationMuteStatus(params: {
    conversationId: string
  }): Promise<NIMResult<boolean>> {
    try {
      return successRes(
        this.nim.V2NIMSettingService.getConversationMuteStatus(
          params.conversationId
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async setTeamMessageMuteMode(params: {
    teamId: string
    teamType: V2NIMTeamType
    muteMode: V2NIMTeamMessageMuteMode
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMSettingService.setTeamMessageMuteMode(
          params.teamId,
          params.teamType,
          params.muteMode
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getTeamMessageMuteMode(params: {
    teamId: string
    teamType: V2NIMTeamType
  }): Promise<NIMResult<{ muteMode: V2NIMTeamMessageMuteMode }>> {
    try {
      return successRes({
        muteMode: this.nim.V2NIMSettingService.getTeamMessageMuteMode(
          params.teamId,
          params.teamType
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async setP2PMessageMuteMode(params: {
    accountId: string
    muteMode: V2NIMP2PMessageMuteMode
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMSettingService.setP2PMessageMuteMode(
          params.accountId,
          params.muteMode
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getP2PMessageMuteMode(params: {
    accountId: string
  }): Promise<NIMResult<{ muteMode: V2NIMP2PMessageMuteMode }>> {
    try {
      return successRes({
        muteMode: this.nim.V2NIMSettingService.getP2PMessageMuteMode(
          params.accountId
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getP2PMessageMuteList(): Promise<NIMResult<{ muteList: string[] }>> {
    try {
      return successRes({
        muteList: await this.nim.V2NIMSettingService.getP2PMessageMuteList(),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async setAppBackground(params: {
    isBackground: boolean
    badge: number
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMSettingService.setAppBackground(
          params.isBackground,
          params.badge
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async setPushMobileOnDesktopOnline(params: {
    need: boolean
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMSettingService.setPushMobileOnDesktopOnline(
          params.need
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async setDndConfig(params: { config: any }): Promise<NIMResult<void>> {
    throw NOT_IMPLEMENTED_ERROR
  }

  @loggerDec
  async getApnsDndConfig(): Promise<NIMResult<void>> {
    throw NOT_IMPLEMENTED_ERROR
  }

  private _onP2PMessageMuteModeChanged(
    accountId: string,
    muteMode: V2NIMP2PMessageMuteMode
  ): void {
    logger.info('_onP2PMessageMuteModeChanged', accountId, muteMode)
    emit('SettingsService', 'onP2PMessageMuteModeChanged', {
      accountId,
      muteMode,
    })
  }

  private _onTeamMessageMuteModeChanged(
    teamId: string,
    teamType: V2NIMTeamType,
    muteMode: V2NIMTeamMessageMuteMode
  ): void {
    logger.info('_onTeamMessageMuteModeChanged', teamId, teamType, muteMode)
    emit('SettingsService', 'onTeamMessageMuteModeChanged', {
      teamId,
      teamType,
      muteMode,
    })
  }
}

export default SettingsService
