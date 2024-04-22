import NIMSDK from '../sdk/NIM_Web_SDK_v9.1.2.js'
import RootService from './rootService'
import { NIMLoginInfo } from './initializeService'
import {
  KNIMAuthStatus,
  NIMResult,
  NIMSDKClient,
  NIMWebMarkedUserInfo,
} from '../types'
import {
  formatNIMEventToFlutter,
  formatNIMMessageWebToFlutter,
  formatNIMFriendWebToFlutter,
  formatNIMUserWebToFlutter,
  formatNIMSystemMessageWebToFlutter,
  formatNIMSessionWebToFlutter,
  formatNIMMessagePinWebToFlutter,
  formartNIMBroadcastMessageWebToFlutter,
  formatNIMStickTopSessionInfoWebToFlutter,
  formatNIMHandleQuickCommentOptionWebToFlutter,
  formatNIMRecentSessionWebToFlutter,
} from '../format'
import { successRes, failRes, emit } from '../utils'
import { NIMClientType } from 'src/types/enums'
import { logger } from '../logger'
import { createLoggerDecorator } from 'yunxin-log-debug'
import { deleteMsgMap } from '../types/enums'
import {
  NIMRevokeMessage,
  NIMSDKMessage,
  NIMWebPinMsgChangeResult,
  NIMWebQuickComment,
  NIMWebSession,
  NIMStickTopSessionInfo,
  NIMSession,
  NIMMessageReceipt,
  NIMWebSystemMessage,
  RecentSession,
  NIMWebCloudSession,
} from '../types/message'
import { NIMFriend, NIMFriendProfile } from './userService.js'
import { SystemMessage, CustomNotification } from './systemMessageService.js'
import {
  formatClientTypeFlutterToWeb,
  formatClientTypeWebToFlutter,
} from 'src/formats/message.js'

const TAG_NAME = 'AuthService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

export interface NIMOnlineClient {
  /// 系统信息字符串
  os: string

  /// 客户端类型
  /// [NIMClientType]
  clientType: NIMClientType

  /// 登录时间
  loginTime: number

  /// 自定义字段
  customTag?: string
}

export interface NIMPassThroughNotifyData {
  fromAccid?: string

  /// 透传内容
  body?: string

  /// 发送时间时间戳
  time?: number
}

class AuthService {
  constructor(private rootService: RootService, private nim: any) {}

  @loggerDec
  login(loginInfo: NIMLoginInfo): Promise<NIMResult<void>> {
    const finalInitOptions = this.formatNIMInitOptionsToWeb(loginInfo)
    // 初始化登录中状态
    emit<{ status: KNIMAuthStatus }>('AuthService', 'onAuthStatusChanged', {
      status: 'logging',
    })
    return new Promise((resolve, reject) => {
      const nim = NIMSDK.NIM.getInstance({
        ...finalInitOptions,
        // Auth相关
        onconnect: () => {
          logger.log(TAG_NAME, 'onconnect')
          // connectionId: "ef7e3300-9a09-439c-9ed6-c63d28b37b68"
          // country: ""
          // customTag: ""
          // ip: "115.236.119.140"
          // lastLoginDeviceId: ""
          // port: "63848"
          emit<{ status: KNIMAuthStatus }>(
            'AuthService',
            'onAuthStatusChanged',
            {
              status: 'loggedIn',
              // ...params,
            }
          )
        },
        // 当前登录帐号在其它端的状态发生改变了，登录端列表
        onloginportschange: (params: NIMSDKClient[]) => {
          logger.log(TAG_NAME, 'onloginportschange', params)
          // account: "cs1"
          // connectionId: "366f0999-2f06-4975-b41d-2612b931881f"
          // deviceId: "3ce19b7b9b33899cb65bf4ebc4e92325"
          // ip: "115.236.119.141"
          // mac: ""
          // online: true
          // os: "Windows 10 64-bit"
          // time: 1662358532615
          // type: "Web"
          // {
          //   required this.os,
          //   required this.clientType,
          //   required this.loginTime,
          //   this.customTag,
          // }
          let onlineClients = window.__yx_flutter_online_clients_ || []
          params.forEach((client) => {
            // 下线
            if (!client.online) {
              onlineClients = onlineClients.filter(
                (item) => item.deviceId !== client.deviceId
              )
            } else {
              const index = onlineClients.findIndex(
                (item) => item.deviceId === client.deviceId
              )
              if (index !== -1) {
                onlineClients[index] = client
              } else {
                onlineClients.push(client)
              }
            }
          })
          //eslint-disable-next-line
          window.__yx_flutter_online_clients_ = onlineClients
          emit<{ clients: NIMOnlineClient[] }>(
            'AuthService',
            'onOnlineClientsUpdated',
            {
              clients: onlineClients.map((client) => {
                return {
                  customTag: client.customTag,
                  os: client.os,
                  clientType: formatClientTypeWebToFlutter(client.type),
                  loginTime: client.time,
                }
              }),
            }
          )
        },
        ondisconnect: (error: any) => {
          logger.log(TAG_NAME, 'ondisconnect', error)
          emit<{ status: KNIMAuthStatus }>(
            'AuthService',
            'onAuthStatusChanged',
            {
              status: 'unLogin',
            }
          )
          if (error) {
            switch (error.code) {
              // 账号或者密码错误, 请跳转到登录页面并提示错误
              case 302:
                emit<{ status: KNIMAuthStatus }>(
                  'AuthService',
                  'onAuthStatusChanged',
                  {
                    status: 'pwdError',
                  }
                )
                break
              case 403:
                emit<{ status: KNIMAuthStatus }>(
                  'AuthService',
                  'onAuthStatusChanged',
                  {
                    status: 'forbidden',
                  }
                )
                break
              case 422:
                emit<{ status: KNIMAuthStatus }>(
                  'AuthService',
                  'onAuthStatusChanged',
                  {
                    status: 'forbidden',
                  }
                )
                break
              // 重复登录, 已经在其它端登录了, 请跳转到登录页面并提示错误
              case 417:
                // emit<{ status: KNIMAuthStatus }>(
                //   'AuthService',
                //   'onAuthStatusChanged',
                //   {
                //     status: 'unLogin',
                //   }
                // )
                break
              // 被踢, 请提示错误后跳转到登录页面
              case 'kicked': {
                // reason: 被踢的原因
                // samePlatformKick: 不允许同一个帐号在多个地方同时登录
                // serverKick: 被服务器踢了
                // otherPlatformKick: 被其它端踢了
                // message: 文字描述的被踢的原因
                // custom：被服务器踢的扩展字段，调用服务器API踢用户时可以自定义
                // from: 踢人操作方的客户端类型，有以下几种：Android, iOS, PC, Web, Server, Mac, WindowsPhone,
                // customClientType: 踢人操作方的自定义客户端类型，仅当操作方登录时指定了自定义客户端类型时才有
                emit<{ status: KNIMAuthStatus }>(
                  'AuthService',
                  'onAuthStatusChanged',
                  {
                    // 这里可能比其他端多触发，所以多给一些东西
                    status: 'kickOut',
                    clientType: error.from,
                    ...error,
                  }
                )
                if (error?.reason === 'otherPlatformKick') {
                  emit<{ status: KNIMAuthStatus }>(
                    'AuthService',
                    'onAuthStatusChanged',
                    {
                      status: 'kickOutByOtherClient',
                    }
                  )
                } else if (error?.reason === 'serverKick') {
                } else if (error?.reason === 'samePlatformKick') {
                }
                break
              }
              default:
                // emit<{ status: KNIMAuthStatus }>(
                //   'AuthService',
                //   'onAuthStatusChanged',
                //   {
                //     status: 'netBroken',
                //     ...error,
                //   }
                // )
                break
            }
          } else {
            emit<{ status: KNIMAuthStatus }>(
              'AuthService',
              'onAuthStatusChanged',
              {
                status: 'unknown',
                ...error,
              }
            )
          }
          reject(failRes(error))
        },
        onwillreconnect: (params: any) => {
          logger.log(TAG_NAME, 'onwillreconnect', params)
          // duration: 1602
          // retryCount: 1
          emit<{ status: KNIMAuthStatus }>(
            'AuthService',
            'onAuthStatusChanged',
            {
              status: 'connecting',
              ...params,
            }
          )
        },
        onsyncdone: () => {
          resolve(successRes())
          logger.log(TAG_NAME, 'onsyncdone')
          emit<{ status: KNIMAuthStatus }>(
            'AuthService',
            'onAuthStatusChanged',
            {
              status: 'dataSyncFinish',
            }
          )
        },

        // message相关
        onmsg: (params: any) => {
          logger.log(TAG_NAME, 'onmsg', params)
          const msg = formatNIMMessageWebToFlutter(params)
          msg.isRemoteRead = nim.isMsgRemoteRead(params)
          emit('MessageService', 'onMessage', {
            messageList: [msg],
          })
        },
        // onMessageStatus:() => {},
        // onMessageReceipt:() => {},

        // 同步到离线广播消息的回调
        onbroadcastmsg: (params: any) => {
          logger.log(TAG_NAME, 'onbroadcastmsg', params)
          emit(
            'MessageService',
            'onBroadcastMessage',
            formartNIMBroadcastMessageWebToFlutter(params)
          )
        },
        // 监听服务端会话更新，sdk不支持 先在api层实现
        // onMySessionUpdate() {},
        // 本地会话更新
        // onupdatesession(session) {
        //   // emit('onSessionDelete', params)
        //   // TODO 会话更新 这块后续需要sdk优化，目前无法确切的知道哪些事件更新了
        //   emit("MessageService", "onSessionUpdate", {
        //     data: [formatNIMSessionWebToFlutter(session)]
        //   });
        // },
        onupdatesession: (session: NIMWebSession) => {
          logger.log(TAG_NAME, 'onupdatesession', session)
          /*
          const stickTopSessionInfo =
            formatNIMStickTopSessionInfoWebToFlutter(session)
          if (session.isTop !== void 0) {
            emit<NIMStickTopSessionInfo>(
              'MessageService',
              'onStickTopSessionUpdate',
              stickTopSessionInfo
            )
          }
          // 这里用全等，isTop 字段不存在时，当做与置顶会话无关的事件，只有该字段存在时才触发 onStickTopSessionUpdate
          if (session.isTop === true) {
            emit<NIMStickTopSessionInfo>(
              'MessageService',
              'onStickTopSessionAdd',
              stickTopSessionInfo
            )
          } else if (session.isTop === false) {
            emit<NIMStickTopSessionInfo>(
              'MessageService',
              'onStickTopSessionRemove',
              stickTopSessionInfo
            )
          }
          */
          const flutterSession = formatNIMSessionWebToFlutter(session)
          emit<{ data: NIMSession[] }>('MessageService', 'onSessionUpdate', {
            data: [flutterSession],
          })
        },
        // 若定义了该回调，onupdatesession 不会触发，SDK 逻辑。用上面那个
        // onupdatesessions: (sessions: NIMWebSession[]) => {
        //   logger.log(TAG_NAME, 'onupdatesessions', sessions)
        //   emit('MessageService', 'onSessionUpdate', {
        //     data: sessions.map((session) =>
        //       formatNIMSessionWebToFlutter(session)
        //     ),
        //   })
        // },
        // 返回session数组
        onStickTopSessions: (sessions: NIMWebSession[]) => {
          logger.log(TAG_NAME, 'onStickTopSessions', sessions)
          emit('MessageService', 'onSyncStickTopSession', {
            data: sessions.map(formatNIMStickTopSessionInfoWebToFlutter),
          })
        },
        // 监听服务端会话更新，sdk不支持
        onSyncUpdateServerSession: (session: NIMWebCloudSession) => {
          logger.log(TAG_NAME, 'onSyncUpdateServerSession', session)
          emit<RecentSession>(
            'MessageService',
            'onMySessionUpdate',
            formatNIMRecentSessionWebToFlutter(session)
          )
        },
        // pin消息改变
        onPinMsgChange: (
          data: NIMWebPinMsgChangeResult,
          action: 'add' | 'update' | 'delete'
        ) => {
          logger.log(TAG_NAME, 'onPinMsgChange', data)
          const pinRes = formatNIMMessagePinWebToFlutter(data)
          switch (action) {
            case 'add':
              emit('MessageService', 'onMessagePinAdded', pinRes)
              break
            case 'delete':
              emit('MessageService', 'onMessagePinRemoved', pinRes)
              break
            case 'update':
              emit('MessageService', 'onMessagePinUpdated', pinRes)
              break
          }
        },
        onQuickComment: (
          data: Pick<
            NIMSDKMessage,
            'scene' | 'from' | 'time' | 'idServer' | 'idClient' | 'to'
          >,
          comment: NIMWebQuickComment
        ) => {
          logger.log(TAG_NAME, 'onQuickComment', data, comment)
          emit(
            'MessageService',
            'onQuickCommentAdd',
            formatNIMHandleQuickCommentOptionWebToFlutter(data, comment)
          )
        },
        onDeleteQuickComment: (
          data: Pick<
            NIMSDKMessage,
            'scene' | 'from' | 'time' | 'idServer' | 'idClient' | 'to'
          >,
          comment: NIMWebQuickComment
        ) => {
          logger.log(TAG_NAME, 'onDeleteQuickComment', data)
          emit(
            'MessageService',
            'onQuickCommentRemove',
            formatNIMHandleQuickCommentOptionWebToFlutter(data, comment)
          )
        },
        // onsessions: (sessions) => {
        //   emit("MessageService", "sessions", sessions);
        // },

        // systemMessage
        // 系统消息未读消息数更新
        onupdatesysmsgunread: (obj: any) => {
          logger.log(TAG_NAME, 'onUpdateSysMsgUnread', obj)
          emit('SystemMessageService', 'onUnreadCountChange', {
            result: obj.total,
          })
        },
        // 收到自定义系统通知 这个接口确实如此，sdk 的定义有问题
        oncustomsysmsg: (sysMsg: NIMWebSystemMessage) => {
          logger.log(TAG_NAME, 'onCustomSysMsg', sysMsg)
          const {
            from,
            to,
            scene,
            content,
            time,
            isPushable,
            needPushNick,
            isUnreadable,
            pushPayload,
            // @ts-ignore
            env = '',
            apnsText,
          } = sysMsg

          let finalPushPayload = {}

          try {
            finalPushPayload = JSON.parse(pushPayload || '{}')
          } catch (error) {
            //
          }

          emit<CustomNotification>(
            'SystemMessageService',
            'onCustomNotification',
            {
              sessionId: to === nim.account ? from : to,
              sessionType: scene,
              fromAccount: from,
              time,
              content,
              apnsText,
              pushPayload: finalPushPayload,
              config: {
                enablePush: isPushable,
                enablePushNick: needPushNick,
                enableUnreadCount: !isUnreadable,
              },
              // antiSpamOption: {},
              env,
            }
          )
        },
        // onofflinesysmsgs: onOfflineSysMsgs,
        // onsysmsg: onSysMsg,
        // onsysmsgunread: onSysMsgUnread,
        // onupdatesysmsgunread: onUpdateSysMsgUnread,
        // // onofflinecustomsysmsgs: onOfflineCustomSysMsgs,
        // oncustomsysmsg: onCustomSysMsg,

        // case 'onReceiveSystemMsg':
        // {this.messageId,
        //   this.type,
        //   this.fromAccount,
        //   this.targetId,
        //   this.time,
        //   this.status,
        //   this.content,
        //   this.attach,
        //   this.attachObject,
        //   this.unread,
        //   this.customInfo});

        /* ===user=== */
        onupdateuser: (user: any) => {
          logger.log(TAG_NAME, 'onupdateuser', user)
          emit('UserService', 'onUserInfoChanged', {
            //  List<NIMUser>
            changedUserInfoList: [formatNIMUserWebToFlutter(user)],
          })
        },
        onupdatemyinfo: (user: any) => {
          logger.log(TAG_NAME, 'onupdatemyinfo', user)
          emit('UserService', 'onUserInfoChanged', {
            //  List<NIMUser>
            changedUserInfoList: [formatNIMUserWebToFlutter(user)],
          })
        },
        // TODO 多端同步接口，暂时用不到
        onsyncfriendaction: (obj: {
          account?: string
          friend?: NIMFriendProfile
          type:
            | 'addFriend'
            | 'applyFriend'
            | 'passFriendApply'
            | 'rejectFriendApply'
            | 'deleteFriend'
            | 'updateFriend'
        }) => {
          logger.log(TAG_NAME, 'onsyncfriendaction', obj)
          // switch (obj.type) {
          //   case 'addFriend':
          //     logger.log(TAG_NAME, '你在其它端直接加了一个好友' + obj)
          //     emit('UserService', 'onFriendAddedOrUpdated', {
          //       // List<NIMFriend>
          //       addedOrUpdatedFriendList: obj.friend
          //         ? [formatNIMFriendWebToFlutter(obj.friend)]
          //         : [],
          //     })
          //     break
          //   case 'applyFriend':
          //     logger.log(TAG_NAME, '你在其它端申请加了一个好友' + obj)
          //     break
          //   case 'passFriendApply':
          //     logger.log(TAG_NAME, '你在其它端通过了一个好友申请' + obj)
          //     break
          //   case 'rejectFriendApply':
          //     logger.log(TAG_NAME, '你在其它端拒绝了一个好友申请' + obj)
          //     break
          //   case 'deleteFriend':
          //     logger.log(TAG_NAME, '你在其它端删了一个好友' + obj, obj.account)
          //     emit('UserService', 'onFriendAccountDeleted', {
          //       //  List<dynamic>
          //       deletedFriendAccountList: [obj.account],
          //     })
          //     break
          //   case 'updateFriend':
          //     logger.log(TAG_NAME, '你在其它端更新了一个好友', obj)
          //     emit('UserService', 'onFriendAddedOrUpdated', {
          //       //  List<NIMFriend>
          //       addedOrUpdatedFriendList: obj.friend
          //         ? [formatNIMFriendWebToFlutter(obj.friend)]
          //         : [],
          //     })
          //     break
          // }
        },
        onblacklist: (blacklist: NIMWebMarkedUserInfo[]) => {
          logger.log(TAG_NAME, 'onblacklist', blacklist)
          emit('UserService', 'onBlackListChanged', {})
        },
        onsyncmarkinblacklist: (blacklist: NIMWebMarkedUserInfo[]) => {
          logger.log(TAG_NAME, 'onsyncmarkinblacklist', blacklist)
          emit('UserService', 'onBlackListChanged', {})
        },
        onmutelist: (mutelist: NIMWebMarkedUserInfo[]) => {
          logger.log(TAG_NAME, 'onmutelist', mutelist)
          mutelist.map((item) => {
            emit<{ account: string; mute: boolean }>(
              'UserService',
              'onMuteListChanged',
              {
                account: item.account,
                mute: !!item.isMuted,
              }
            )
          })
        },
        onfriends: (data: NIMFriendProfile[]) => {
          logger.log(TAG_NAME, 'onfriends', data)
          emit<{
            addedOrUpdatedFriendList: NIMFriend[]
          }>('UserService', 'onFriendAddedOrUpdated', {
            addedOrUpdatedFriendList: data.map((item) =>
              formatNIMFriendWebToFlutter(item)
            ),
          })
        },
        onsyncmarkinmutelist: (mutelist: NIMWebMarkedUserInfo[]) => {
          logger.log(TAG_NAME, 'onsyncmarkinmutelist', mutelist)
          mutelist.map((item) => {
            emit<{ account: string; mute: boolean }>(
              'UserService',
              'onMuteListChanged',
              {
                account: item.account,
                mute: !!item.isMuted,
              }
            )
          })
        },
        // // 用户名片
        // onmyinfo(params = {}) {
        //   logger.log(TAG_NAME, "收到我的名片", params);
        //   emit("updateMyNameCard", {
        //     ...params,
        //   });
        // },
        // onupdatemyinfo(params = {}) {
        //   logger.log(TAG_NAME, "我的名片更新了", params);
        //   emit("onupdatemyinfo", {
        //     ...params,
        //   });
        // },
        // onusers(params = {}) {
        //   logger.log(TAG_NAME, "收到用户名片列表", params);
        //   emit("onUsers", {
        //     ...params,
        //   });
        // },
        onsysmsg: (data: NIMWebSystemMessage) => {
          logger.log(TAG_NAME, 'onsysmsg', data)
          this._handleSysMsg(data)
        },
        onupdatesysmsg: (data: NIMWebSystemMessage) => {
          logger.log(TAG_NAME, 'onupdatesysmsg', data)
          this._handleSysMsg(data)
        },
        onpushevents: (params: any) => {
          logger.log(TAG_NAME, 'onpushevents', params)
          emit('EventSubscribeService', 'observeEventChanged', {
            eventList: params.msgEvents.map(formatNIMEventToFlutter),
          })
        },
        onProxyMsg: (params: { body: string }) => {
          emit('PassThroughService', 'onPassthrough', {
            passthroughNotifyData: params as NIMPassThroughNotifyData,
          })
        },
      })
      Object.assign(this.nim, nim)
      Object.setPrototypeOf(this.nim, Object.getPrototypeOf(nim))
    })
  }

  @loggerDec
  logout(): Promise<NIMResult<void>> {
    if (!this.nim.isConnected()) {
      logger.log(TAG_NAME, 'logout success with not connected')
      return Promise.resolve(successRes())
    }
    return new Promise((resolve) => {
      this.nim.destroy({
        done: () => {
          resolve(successRes())
          logger.log(TAG_NAME, 'logout success')
        },
      })
    })
  }

  // 踢当前用户登录的其它端
  @loggerDec
  kickOutOtherOnlineClient(client: NIMOnlineClient): Promise<NIMResult<void>> {
    return new Promise((resolve, reject) => {
      const deviceIds = window.__yx_flutter_online_clients_
        .filter(
          (item) =>
            item.type === formatClientTypeFlutterToWeb(client.clientType) &&
            item.os === client.os &&
            item.time === client.loginTime &&
            (!client.customTag || item.customTag === client.customTag)
        )
        .map((item) => item.deviceId)
      if (!deviceIds.length) {
        return reject(failRes('没有找到对应的在线客户端'))
      }
      this.nim.kick({
        deviceIds,
        done: (error: any) => {
          logger.log(TAG_NAME, '踢其它端' + (!error ? '成功' : '失败'))
          if (error) {
            return reject(failRes(error))
          }
          resolve(successRes())
        },
      })
    })
  }

  private formatNIMInitOptionsToWeb(loginInfo: NIMLoginInfo) {
    return {
      appKey: this.rootService.InitializeService.initOptions?.appKey,
      logLevel: 'debug',
      sdkHumanVersion:
        this.rootService.InitializeService.initOptions?.extras?.versionName,
      customClientType:
        this.rootService.InitializeService.initOptions?.customClientType,
      // Login 的 customClientType 优先级高
      ...loginInfo,
      db:
        this.rootService.InitializeService.initOptions?.enableDatabaseBackup ||
        false, // api层有很多local的接口，需要开启db才可以用
      customTag: this.rootService.InitializeService.initOptions?.loginCustomTag,
      syncSessionUnread:
        this.rootService.InitializeService.initOptions?.shouldSyncUnreadCount ||
        false,
      rollbackDelMsgUnread:
        this.rootService.InitializeService.initOptions
          ?.shouldConsiderRevokedMessageUnreadCount || false,
      syncMsgReceipts:
        this.rootService.InitializeService.initOptions
          ?.enableTeamMessageReadReceipt || false,
      shouldCountNotifyUnread:
        this.rootService.InitializeService.initOptions
          ?.shouldTeamNotificationMessageMarkUnread || false,
      thumbnailToStatic:
        this.rootService.InitializeService.initOptions
          ?.enableAnimatedImageThumbnail || false,
      syncStickTopSessions:
        this.rootService.InitializeService.initOptions
          ?.shouldSyncStickTopSessionInfos || false,
      logReport:
        this.rootService.InitializeService.initOptions
          ?.enableReportLogAutomatically || false,
      // nim_core 接口层加个 web 专用的登录接口来透传这个私有化字段
      privateConf:
        this.rootService.InitializeService.initOptions
          ?.assetServerAddressConfig,
    }
  }

  private _handleSysMsg(data: NIMWebSystemMessage): void {
    const { type } = data
    // 收到系统消息，flutter不包含deleteMsg、custom
    if (!['deleteMsg', 'custom'].includes(type)) {
      const sysMsg = formatNIMSystemMessageWebToFlutter(data)
      if (sysMsg.type !== undefined) {
        emit<SystemMessage>(
          'SystemMessageService',
          'onReceiveSystemMsg',
          formatNIMSystemMessageWebToFlutter(data)
        )
      }
    }

    switch (type) {
      // 直接加某个用户为好友后, 对方不需要确认, 直接成为当前登录用户的好友
      case 'addFriend':
        emit<{
          addedOrUpdatedFriendList: NIMFriend[]
        }>('UserService', 'onFriendAddedOrUpdated', {
          addedOrUpdatedFriendList: data.friend
            ? [formatNIMFriendWebToFlutter(data.friend)]
            : [{ userId: data.from }],
        })
        break
      // 申请加某个用户为好友后, 对方会收到一条类型为'applyFriend'的系统通知, 此类系统通知的from字段的值为申请方的帐号, to字段的值为接收方的账号, 用户在收到好友申请后, 可以选择通过或者拒绝好友申请。
      case 'applyFriend':
        // emit<{
        //   addedOrUpdatedFriendList: NIMFriend[]
        // }>('UserService', 'onFriendAddedOrUpdated', {
        //   addedOrUpdatedFriendList: [
        //     formatNIMFriendWebToFlutter({
        //       account: data.from,
        //       valid: true,
        //       updateTime: data.time,
        //       createTime: data.time,
        //     }),
        //   ],
        // })
        break
      // case 'updateFriend':
      //   emit<{
      //     addedOrUpdatedFriendList: NIMFriend[]
      //   }>('UserService', 'onFriendAddedOrUpdated', {
      //     addedOrUpdatedFriendList: [{ userId: data.account }],
      //   })
      //   break
      // 通过好友申请
      case 'passFriendApply':
        emit<{
          addedOrUpdatedFriendList: NIMFriend[]
        }>('UserService', 'onFriendAddedOrUpdated', {
          addedOrUpdatedFriendList: data.friend
            ? [formatNIMFriendWebToFlutter(data.friend)]
            : [{ userId: data.from }],
        })
        break
      // 通过好友申请
      case 'rejectFriendApply':
        break
      case 'deleteFriend':
        emit<{
          deletedFriendAccountList: string[]
        }>('UserService', 'onFriendAccountDeleted', {
          deletedFriendAccountList: [data.from],
        })
        break
      // 高级群的群主和管理员在邀请成员加入群（通过操作创建群或拉人入群）之后, 被邀请的人会收到一条类型为'teamInvite'的系统通知
      // case 'teamInvite':
      //     break
      // // 如果接受入群邀请, 那么该群的所有群成员会收到一条类型为'acceptTeamInvite'的群通知消息
      // case 'acceptTeamInvite':
      //     break
      // // 如果拒绝入群邀请, 那么邀请你的人会收到一条类型为'rejectTeamInvite'的系统通知
      // case 'rejectTeamInvite':
      //     break
      // // 用户可以主动申请加入高级群, 目标群的群主和管理员会收到一条类型为'applyTeam'的系统通知
      // case 'applyTeam':
      // break;
      // // 通过入群申请, 那么该群的所有群成员会收到一条类型为'passTeamApply'的群通知消息
      // case 'passTeamApply':
      // break;
      // // 拒绝入群申请, 那么申请人会收到一条类型为'rejectTeamApply'的系统通知
      // case 'rejectTeamApply':
      // break;
      // // 主动申请加入高级群, 目标群的群主和管理员会收到一条类型为'applySuperTeam'的系统通知
      // case 'applySuperTeam':
      // break;
      // // 通过入群申请, 那么该群的所有群成员会收到一条类型为'passSuperTeamApply'的群通知消息
      // case 'passSuperTeamApply':
      // break;
      // case 'rejectSuperTeamApply':
      // break;
      // // 超大群的群主和管理员在邀请成员加入群（通过操作创建群或拉人入群）之后, 被邀请的人会收到一条类型为'superTeamInvite'的系统通知
      // case 'superTeamInvite':
      // break;
      // // 接受入群邀请, 那么该群的所有群成员会收到一条类型为'acceptSuperTeamInvite'的群通知消息
      // case 'acceptSuperTeamInvite':
      // break;
      // // 拒绝入群邀请, 那么邀请你的人会收到一条类型为'rejectSuperTeamInvite'的系统通知
      // case 'rejectSuperTeamInvite':
      // break;
      // 撤回消息
      case 'deleteMsg':
        // 撤回消息类型
        // const RevokeMessageType = {
        //   undefined: "undefined",
        //   // 点对点双向撤回
        //   p2pDeleteMsg,
        //   // 群双向撤回
        //   teamDeleteMsg,
        //   // 超大群双向撤回
        //   superTeamDeleteMsg,
        //   // 点对点单向撤回
        //   p2pOneWayDeleteMsg,
        //   // 群单向撤回
        //   teamOneWayDeleteMsg,
        // };
        // @ts-ignore
        const { msg, opeAccount, scene, from } = data
        const message = formatNIMMessageWebToFlutter(msg)
        message.isRemoteRead = this.nim.isMsgRemoteRead(msg)
        const deleMsg: NIMRevokeMessage = {
          message,
          // attach,
          revokeAccount: opeAccount || from,
          // customInfo,
          // notificationType,
          revokeType: deleteMsgMap[scene || ''],
          // callbackExt,
        }
        emit<NIMRevokeMessage>('MessageService', 'onMessageRevoked', deleMsg)
        break
      // 系统自定义消息
      case 'custom':
        break
      default:
        break
    }
  }
}

export default AuthService
