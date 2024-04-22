import {
  formatNIMFriendWebToFlutter,
  formatNIMUserWebToFlutter,
  formatNIMUserFlutterToWeb,
} from '../format'

import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from 'yunxin-log-debug'
import { NIMResult, NIMWebMarkedUserInfo } from '../types'
import { failRes, successRes, emit } from '../utils'

const TAG_NAME = 'UserService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)
import { NimUserGender, NIMVerifyType } from '../types/enums'

export type KNIMUserGender = keyof typeof NimUserGender

export interface NIMFriend {
  userId?: string
  alias?: string
  // ext
  extension?: string
  // serverExt
  serverExtension?: string
}

export interface NIMUser {
  userId?: string
  nick?: string
  signature?: string
  avatar?: string
  gender?: KNIMUserGender
  email?: string
  birthday?: string
  mobile?: string
  extension?: string
}

/**
 * 好友的信息定义
 */
export type NIMFriendProfile = {
  /**
   * 账号 account ID
   */
  account: string
  /**
   * 更新时间
   */
  updateTime: number
  /**
   * 创建时间
   */
  createTime: number
  /**
   * 是否有效，默认 true。为 true 代表是双方是彼此的朋友
   */
  valid: boolean
  /**
   * 备注
   */
  alias?: string
  /**
   * 扩展字段
   */
  custom?: string
}

export type NIMSDKUser = {
  /**
   * 昵称
   */
  nick?: string
  /**
   * 头像
   */
  avatar?: string
  /**
   * 签名
   */
  sign?: string
  /**
   * 性别
   */
  gender?: KNIMUserGender
  /**
   * 邮箱
   */
  email?: string
  /**
   * 出生日期
   */
  birth?: string
  /**
   * 电话
   */
  tel?: string
  /**
   * 扩展字段
   */
  custom?: string
  /**
   * 用户配置的对某些资料内容另外的反垃圾的业务ID
   */
  antiSpamBusinessId?: string
}

export type NIMUserNameCard = {
  /**
   * account ID
   */
  account: string
  /**
   * 昵称
   */
  nick?: string
  /**
   * 头像
   */
  avatar?: string
  /**
   * 签名
   */
  sign?: string
  /**
   * 性别
   */
  gender?: KNIMUserGender
  /**
   * 邮箱
   */
  email?: string
  /**
   * 出生日期
   */
  birth?: string
  /**
   * 电话
   */
  tel?: string
  /**
   * 扩展字段
   */
  custom?: string
  createTime?: number
  updateTime?: number
}

class UserService {
  constructor(private rootService: RootService, private nim: any) {}

  // <NIMUser> 从本地数据库中获取用户资料
  @loggerDec
  async getUserInfo(params: { userId: string }): Promise<NIMResult<NIMUser>> {
    return new Promise((resolve, reject) => {
      this.nim.getUser({
        account: params.userId,
        sync: false, // 是否去服务器上获取，为 true 则从服务器获取，默认从本地 db 获取
        done(error, user) {
          if (error) {
            return reject(successRes(error))
          }
          resolve(successRes(formatNIMUserWebToFlutter(user)))
        },
      })
    })
  }

  getUserInfoListAndroid() {
    throw Error('not implemented.')
  }

  getAllUserInfoAndroid() {
    throw Error('not implemented.')
  }

  // <userInfoList, List<NIMUser>> 从云端获取用户资料
  @loggerDec
  async fetchUserInfoList(params: {
    userIdList: string[]
  }): Promise<NIMResult<{ userInfoList: NIMUser[] }>> {
    return new Promise((resolve, reject) => {
      this.nim.getUsers({
        accounts: params.userIdList,
        sync: true,
        done(error, users) {
          if (error) {
            return reject(error)
          }
          resolve(
            successRes({
              userInfoList: users.map((user) =>
                formatNIMUserWebToFlutter(user)
              ),
            })
          )
        },
      })
    })
  }

  // void
  @loggerDec
  async updateMyUserInfo(params: NIMUser): Promise<NIMResult<void>> {
    return new Promise((resolve, reject) => {
      this.nim.updateMyInfo({
        ...formatNIMUserFlutterToWeb(params),
        done: (error, user: NIMUserNameCard) => {
          if (error) {
            return reject(failRes(error))
          }
          // 给自己发一个，对齐安卓
          emit('UserService', 'onUserInfoChanged', {
            changedUserInfoList: [formatNIMUserWebToFlutter(user)],
          })
          resolve(successRes())
        },
      })
    })
  }

  // <userIdList, List<String>>
  @loggerDec
  async searchUserIdListByNick(params: {
    nick: string
  }): Promise<NIMResult<{ userIdList: string[] }>> {
    try {
      const { users } = await this._searchLocal({
        keyword: params.nick,
        keyPath: 'user.nick',
      })
      return successRes({ userIdList: users.map((user) => user.account) })
    } catch (error) {
      throw failRes(error)
    }
  }

  // <userInfoList, <List<NIMUser>>
  @loggerDec
  async searchUserInfoListByKeyword(params: {
    keyword: string
  }): Promise<NIMResult<{ userInfoList: NIMUser[] }>> {
    try {
      const { users } = await this._searchLocal({
        keyword: params.keyword,
      })

      return successRes({
        userInfoList: users.map((user) => formatNIMUserWebToFlutter(user)),
      })
    } catch (error) {
      throw failRes(error)
    }
  }

  // void
  @loggerDec
  async addFriend(params: {
    userId: string
    message?: string
    verifyType: NIMVerifyType
  }): Promise<NIMResult<void>> {
    return new Promise((resolve, reject) => {
      const { userId, verifyType } = params
      if (verifyType === 0) {
        this.nim.addFriend({
          account: userId,
          done: (error) => {
            if (error) {
              return reject(error)
            }
            emit<{
              addedOrUpdatedFriendList: NIMFriend[]
            }>('UserService', 'onFriendAddedOrUpdated', {
              addedOrUpdatedFriendList: [
                {
                  userId,
                  extension: params.message,
                },
              ],
            })
            resolve(successRes())
          },
        })
      } else {
        this.nim.applyFriend({
          account: userId,
          done: (error) => {
            if (error) {
              return reject(error)
            }
            resolve(successRes())
          },
        })
      }
    })
  }

  // void
  @loggerDec
  async ackAddFriend(params: {
    userId: string
    isAgree: boolean
    idServer?: string
  }): Promise<NIMResult<void>> {
    const param = {
      idServer: String(params.idServer || '123'),
      account: params.userId,
    }
    return new Promise((resolve, reject) => {
      if (params.isAgree) {
        this.nim.passFriendApply({
          ...param,
          done: (error) => {
            if (error) {
              return reject(failRes(error))
            }
            resolve(successRes())
          },
        })
        emit<{
          addedOrUpdatedFriendList: NIMFriend[]
        }>('UserService', 'onFriendAddedOrUpdated', {
          addedOrUpdatedFriendList: [{ userId: params.userId }],
        })
      } else {
        this.nim.rejectFriendApply({
          ...param,
          done: (error) => {
            if (error) {
              return reject(failRes(error))
            }
            resolve(successRes())
          },
        })
      }
    })
  }
  // <friendList, <List<NIMFriend>>
  @loggerDec
  async getFriendList(): Promise<NIMResult<{ friendList: NIMFriend[] }>> {
    const friends = await this._getFriends()
    return successRes({
      friendList: friends.map((friend) => formatNIMFriendWebToFlutter(friend)),
    })
  }
  // <NIMFriend>
  @loggerDec
  async getFriend(params: { userId: string }): Promise<NIMResult<NIMFriend>> {
    const friends = await this._getFriends()
    const friend = friends.find((friend) => friend.account === params.userId)
    if (!friend) {
      return successRes({})
    }
    return successRes(formatNIMFriendWebToFlutter(friend))
  }

  // void
  @loggerDec
  async deleteFriend(params: {
    userId: string
    includeAlias: boolean
  }): Promise<NIMResult<void>> {
    return new Promise((resolve, reject) => {
      this.nim.deleteFriend({
        account: params.userId,
        delAlias: params.includeAlias,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          // 与其他端确认后，本端也需要
          emit<{
            deletedFriendAccountList: string[]
          }>('UserService', 'onFriendAccountDeleted', {
            deletedFriendAccountList: [params.userId],
          })
          resolve(successRes())
        },
      })
    })
  }

  // bool
  @loggerDec
  async isMyFriend(params: { userId: string }): Promise<NIMResult<boolean>> {
    return new Promise((resolve, reject) => {
      this.nim.isMyFriend({
        account: params.userId,
        done(error, isFriend) {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes(isFriend))
        },
      })
    })
  }

  // void
  @loggerDec
  async updateFriend(params: {
    userId: string
    alias: string
  }): Promise<NIMResult<void>> {
    return new Promise((resolve, reject) => {
      this.nim.updateFriend({
        account: params.userId,
        alias: params.alias,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          emit<{
            addedOrUpdatedFriendList: NIMFriend[]
          }>('UserService', 'onFriendAddedOrUpdated', {
            addedOrUpdatedFriendList: [
              {
                userId: params.userId,
                alias: params.alias,
              },
            ],
          })
          resolve(successRes())
        },
      })
    })
  }

  // List<String> userIdList
  @loggerDec
  async getBlackList(): Promise<NIMResult<{ userIdList: string[] }>> {
    try {
      const { blacklist } = await this._getRelations()
      return successRes({ userIdList: blacklist.map((user) => user.account) })
    } catch (error) {
      throw failRes(error)
    }
  }

  // void
  @loggerDec
  async addToBlackList(params: { userId: string }): Promise<NIMResult<void>> {
    return new Promise((resolve, reject) => {
      this.nim.addToBlacklist({
        account: params.userId,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  // void
  @loggerDec
  async removeFromBlackList(params: {
    userId: string
  }): Promise<NIMResult<void>> {
    return new Promise((resolve, reject) => {
      this.nim.removeFromBlacklist({
        account: params.userId,
        done: (error) => {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  // bool
  @loggerDec
  async isInBlackList(params: { userId: string }): Promise<NIMResult<boolean>> {
    return new Promise((resolve, reject) => {
      this.nim.isUserInBlackList({
        account: params.userId,
        done(error, isInBlackList) {
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes(isInBlackList))
        },
      })
    })
  }

  // <userIdList, List<String>>
  @loggerDec
  async getMuteList(): Promise<NIMResult<{ userIdList: string[] }>> {
    try {
      const { mutelist } = await this._getRelations()
      return successRes({ userIdList: mutelist.map((user) => user.account) })
    } catch (error) {
      throw failRes(error)
    }
  }
  // void
  @loggerDec
  async setMute(params: {
    userId: string
    isMute: boolean
  }): Promise<NIMResult<void>> {
    return new Promise((resolve, reject) => {
      if (params.isMute) {
        this.nim.addToMutelist({
          account: params.userId,
          done: (err) => {
            if (err) {
              return reject(failRes(err))
            }
            resolve(successRes())
          },
        })
      } else {
        this.nim.removeFromMutelist({
          account: params.userId,
          done: (err) => {
            if (err) {
              return reject(failRes(err))
            }
            resolve(successRes())
          },
        })
      }
    })
  }
  // bool
  @loggerDec
  async isMute(params: { userId: string }): Promise<NIMResult<boolean>> {
    try {
      const { mutelist } = await this._getRelations()
      return successRes(mutelist.some((item) => item.account === params.userId))
    } catch (error) {
      throw failRes(error)
    }
  }

  private _searchLocal(options: {
    keyword: string
    keyPath?: string
  }): Promise<{
    users: any[]
    sessions: any[]
    msg: any
  }> {
    return new Promise((resolve, reject) => {
      this.nim.searchLocal({
        ...options,
        done: (error, obj) => {
          if (error) {
            return reject(error)
          }
          resolve(obj)
        },
      })
    })
  }

  private _getFriends(options = {}): Promise<any[]> {
    return new Promise((resolve, reject) => {
      this.nim.getFriends({
        ...options,
        done(error, friends) {
          if (error) {
            return reject(error)
          }
          resolve(friends)
        },
      })
    })
  }

  private _getRelations(): Promise<{
    blacklist: NIMWebMarkedUserInfo[]
    mutelist: NIMWebMarkedUserInfo[]
  }> {
    return new Promise((resolve, reject) => {
      this.nim.getRelations({
        done: (error, obj) => {
          if (error) {
            return reject(error)
          }
          resolve(obj)
        },
      })
    })
  }
}

export default UserService
