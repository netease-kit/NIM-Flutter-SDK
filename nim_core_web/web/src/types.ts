import { NIMSDKClientType } from './types/enums'

export type ServiceName =
  | 'InitializeService'
  | 'AuthService'
  | 'MessageService'
  | 'SettingService'
  | 'SystemMessageService'
  | 'UserService'
  | 'NOSService'
  | 'EventSubscribeService'
  | 'PassThroughService'

export type NIMSDKClient = {
  account: string
  connectionId: string
  customTag: string
  deviceId: string
  ip: string
  mac: string
  online: boolean
  os: string
  time: number
  type: NIMSDKClientType
}
declare global {
  interface Window {
    __yx_emit__: <T>(
      serviceName: ServiceName,
      methodName: string,
      params: T
    ) => void
    __yx_flutter_online_clients_: NIMSDKClient[]
  }
}

export interface NIMResult<T> {
  code: number
  data?: T
  errorDetails?: string
}

export interface NIMSDKPushEvent {
  account: string
  clientType: NIMSDKClientType
  custom: string | Record<string, any>
  idClient: string
  idServer: string
  time: string
  type: string
  value: string
}

export interface NIMWebMarkedUserInfo {
  account: string
  createTime: number
  isBlack?: boolean
  isMuted?: boolean
  updateTime: number
}

export interface IObj {
  [key: string]: any
}

/// 登录/登出状态事件
export enum NIMAuthStatus {
  /// 未知状态
  unknown,

  /// 未登录 或 登录失败
  unLogin,

  /// 正在连接服务器
  connecting,

  /// 正在登录中
  logging,

  /// 已成功登录
  loggedIn,

  /// 被服务器拒绝连接，403，422
  forbidden,

  /// 网络连接已断开 web sdk 没有 TODO
  netBroken,

  /// 客户端版本错误 web sdk 没有
  versionError,

  /// 用户名或密码错误
  pwdError,

  /// 被其他端的登录踢掉
  kickOut,

  /// 被同时在线的其他端主动踢掉
  kickOutByOtherClient,

  /// 数据同步开始
  ///
  /// 同步开始时，SDK 数据库中的数据可能还是旧数据。
  ///（如果是首次登录，那么 SDK 数据库中还没有数据，
  /// 重新登录时 SDK 数据库中还是上一次退出时保存的数据）
  /// 在同步过程中，SDK 数据的更新会通过相应的监听接口发出数据变更通知。
  dataSyncStart, // web sdk 没有

  /// 数据同步完成
  dataSyncFinish,
}

export type KNIMAuthStatus = keyof typeof NIMAuthStatus
