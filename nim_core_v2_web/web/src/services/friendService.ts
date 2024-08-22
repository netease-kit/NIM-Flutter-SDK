import { failRes, successRes, emit } from '../utils'
import { NIMResult } from '../types'
import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from '@xkit-yx/utils'
import V2NIM, { V2NIMConst } from 'nim-web-sdk-ng'
import {
  V2NIMCheckFriendResult,
  V2NIMFriend,
  V2NIMFriendAddApplication,
  V2NIMFriendAddApplicationQueryOption,
  V2NIMFriendAddApplicationResult,
  V2NIMFriendAddParams,
  V2NIMFriendDeleteParams,
  V2NIMFriendDeletionType,
  V2NIMFriendSearchOption,
  V2NIMFriendSetParams,
} from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMFriendService'
import { V2NIMError } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/types'

const TAG_NAME = 'FriendService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

class FriendService {
  constructor(private rootService: RootService, private nim: V2NIM) {
    this._onFriendAdded = this._onFriendAdded.bind(this)
    this._onFriendDeleted = this._onFriendDeleted.bind(this)
    this._onFriendAddApplication = this._onFriendAddApplication.bind(this)
    this._onFriendAddRejected = this._onFriendAddRejected.bind(this)
    this._onFriendInfoChanged = this._onFriendInfoChanged.bind(this)

    nim.V2NIMFriendService.on('onFriendAdded', this._onFriendAdded)
    nim.V2NIMFriendService.on('onFriendDeleted', this._onFriendDeleted)
    // 申请添加好友的相关信息，其他端向本端发送好友申请,会触发该事件
    nim.V2NIMFriendService.on(
      'onFriendAddApplication',
      this._onFriendAddApplication
    )
    // 对端拒绝本端好友申请，本端会触发该事件
    nim.V2NIMFriendService.on('onFriendAddRejected', this._onFriendAddRejected)
    // 好友信息更新回调，返回变更的好友信息，包括本端直接更新的好友信息和其他端同步更新的好友信息
    nim.V2NIMFriendService.on('onFriendInfoChanged', this._onFriendInfoChanged)
  }

  destroy(): void {
    this.nim.V2NIMFriendService.off('onFriendAdded', this._onFriendAdded)
    this.nim.V2NIMFriendService.off('onFriendDeleted', this._onFriendDeleted)
    this.nim.V2NIMFriendService.off(
      'onFriendAddApplication',
      this._onFriendAddApplication
    )
    this.nim.V2NIMFriendService.off(
      'onFriendAddRejected',
      this._onFriendAddRejected
    )
    this.nim.V2NIMFriendService.off(
      'onFriendInfoChanged',
      this._onFriendInfoChanged
    )
  }

  @loggerDec
  async addFriend(params: {
    accountId: string
    params?: V2NIMFriendAddParams
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMFriendService.addFriend(
          params.accountId,
          params.params || {
            addMode: V2NIMConst.V2NIMFriendAddMode.V2NIM_FRIEND_MODE_TYPE_ADD,
            postscript: '',
          }
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async deleteFriend(params: {
    accountId: string
    params?: V2NIMFriendDeleteParams
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMFriendService.deleteFriend(
          params.accountId,
          params.params || {
            deleteAlias: true,
          }
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async acceptAddApplication(params: {
    application: V2NIMFriendAddApplication
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMFriendService.acceptAddApplication(
          params.application
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async rejectAddApplication(params: {
    application: V2NIMFriendAddApplication
    postscript: string
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMFriendService.rejectAddApplication(
          params.application,
          params.postscript
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async setFriendInfo(params: {
    accountId: string
    params: V2NIMFriendSetParams
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMFriendService.setFriendInfo(
          params.accountId,
          params.params
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getFriendList(): Promise<NIMResult<{ friendList: V2NIMFriend[] }>> {
    try {
      return successRes({
        friendList: await this.nim.V2NIMFriendService.getFriendList(),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getFriendByIds(params: {
    accountIds: string[]
  }): Promise<NIMResult<{ friendList: V2NIMFriend[] }>> {
    try {
      return successRes({
        friendList: await this.nim.V2NIMFriendService.getFriendByIds(
          params.accountIds
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async checkFriend(params: {
    accountIds: string[]
  }): Promise<NIMResult<{ result: V2NIMCheckFriendResult }>> {
    try {
      return successRes({
        result: await this.nim.V2NIMFriendService.checkFriend(
          params.accountIds
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getAddApplicationList(params: {
    option: V2NIMFriendAddApplicationQueryOption
  }): Promise<NIMResult<V2NIMFriendAddApplicationResult>> {
    try {
      return successRes(
        await this.nim.V2NIMFriendService.getAddApplicationList(params.option)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getAddApplicationUnreadCount(): Promise<NIMResult<number>> {
    try {
      return successRes(
        await this.nim.V2NIMFriendService.getAddApplicationUnreadCount()
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async setAddApplicationRead(): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMFriendService.setAddApplicationRead()
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async searchFriendByOption(params: {
    friendSearchOption: V2NIMFriendSearchOption
  }): Promise<NIMResult<{ friendList: V2NIMFriend[] }>> {
    try {
      return successRes({
        friendList: await this.nim.V2NIMFriendService.searchFriendByOption(
          params.friendSearchOption
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  /**
   * 监听添加好友
   */
  private _onFriendAdded(friend: V2NIMFriend) {
    logger.log('_onFriendAdded', friend)
    emit('FriendService', 'onFriendAdded', friend)
  }

  /**
   * 监听删除好友
   */
  private _onFriendDeleted(
    accountId: string,
    deletionType: V2NIMFriendDeletionType
  ) {
    logger.log('_onFriendDeleted', accountId)
    emit('FriendService', 'onFriendDeleted', { accountId, deletionType })
  }
  /**
   * 申请添加好友的相关信息，其他端向本端发送好友申请,会触发该事件
   */
  private _onFriendAddApplication(application: V2NIMFriendAddApplication) {
    logger.log('_onFriendAddApplication', application)
    emit('FriendService', 'onFriendAddApplication', application)
  }

  /**
   * 对端拒绝本端好友申请，本端会触发该事件
   */
  private _onFriendAddRejected(rejection: V2NIMFriendAddApplication) {
    logger.log('_onFriendAddRejected', rejection)
    emit('FriendService', 'onFriendAddRejected', rejection)
  }

  /**
   * 好友信息更新回调，返回变更的好友信息，包括本端直接更新的好友信息和其他端同步更新的好友信息
   */
  private _onFriendInfoChanged(friend: V2NIMFriend) {
    logger.log('_onFriendInfoChanged', friend)
    emit('FriendService', 'onFriendInfoChanged', friend)
  }
}

export default FriendService
