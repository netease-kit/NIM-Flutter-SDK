import { successRes, failRes, emit } from '../utils'
import { NIMResult } from '../types'
import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from '@xkit-yx/utils'
import V2NIM from 'nim-web-sdk-ng'
import {
  V2NIMUser,
  V2NIMUserSearchOption,
  V2NIMUserUpdateParams,
} from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMUserService'
import { V2NIMError } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/types'

const TAG_NAME = 'UserService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

class UserService {
  constructor(private rootService: RootService, private nim: V2NIM) {
    this._onBlockListAdded = this._onBlockListAdded.bind(this)
    this._onBlockListRemoved = this._onBlockListRemoved.bind(this)
    this._onUserProfileChanged = this._onUserProfileChanged.bind(this)

    nim.V2NIMUserService.on('onBlockListAdded', this._onBlockListAdded)
    nim.V2NIMUserService.on('onBlockListRemoved', this._onBlockListRemoved)
    nim.V2NIMUserService.on('onUserProfileChanged', this._onUserProfileChanged)
  }

  destroy(): void {
    this.nim.V2NIMUserService.off('onBlockListAdded', this._onBlockListAdded)
    this.nim.V2NIMUserService.off(
      'onBlockListRemoved',
      this._onBlockListRemoved
    )
    this.nim.V2NIMUserService.off(
      'onUserProfileChanged',
      this._onUserProfileChanged
    )
  }

  @loggerDec
  async getUserList(params: {
    userIdList: string[]
  }): Promise<NIMResult<{ userInfoList: V2NIMUser[] }>> {
    try {
      return successRes({
        userInfoList: await this.nim.V2NIMUserService.getUserList(
          params.userIdList
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getUserListFromCloud(params: {
    userIdList: string[]
  }): Promise<NIMResult<{ userInfoList: V2NIMUser[] }>> {
    try {
      return successRes({
        userInfoList: await this.nim.V2NIMUserService.getUserListFromCloud(
          params.userIdList
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async updateSelfUserProfile(params: {
    updateParam: V2NIMUserUpdateParams
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMUserService.updateSelfUserProfile(
          params.updateParam
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async addUserToBlockList(params: {
    userId: string
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMUserService.addUserToBlockList(params.userId)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async removeUserFromBlockList(params: {
    userId: string
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMUserService.removeUserFromBlockList(params.userId)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getBlockList(): Promise<NIMResult<{ userIdList: string[] }>> {
    try {
      return successRes({
        userIdList: await this.nim.V2NIMUserService.getBlockList(),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async searchUserByOption(params: {
    userSearchOption: V2NIMUserSearchOption
  }): Promise<NIMResult<{ userInfoList: V2NIMUser[] }>> {
    try {
      return successRes({
        userInfoList: await this.nim.V2NIMUserService.searchUserByOption(
          params.userSearchOption
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  private _onBlockListAdded(user: V2NIMUser): void {
    logger.log('_onBlockListAdded', user)
    emit('UserService', 'onBlockListAdded', user)
  }

  private _onBlockListRemoved(accountId: string): void {
    logger.log('_onBlockListRemoved', accountId)
    emit('UserService', 'onBlockListRemoved', { userId: accountId })
  }

  private _onUserProfileChanged(users: V2NIMUser[]): void {
    logger.log('_onUserProfileChanged', users)
    emit('UserService', 'onUserProfileChanged', { userInfoList: users })
  }
}

export default UserService
