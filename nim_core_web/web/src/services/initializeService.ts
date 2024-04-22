import { successRes } from '../utils'
import { NIMResult } from '../types'
import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from 'yunxin-log-debug'

const TAG_NAME = 'InitializeService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

export enum NIMAuthType {
  authTypeDefault,
  authTypeDynamic,
  authTypeThirdParty,
}

export interface NIMLoginInfo {
  /// 账号
  account: string

  /// 令牌
  token: string

  /// 认证类型
  authType: NIMAuthType

  ///
  /// 登录自定义字段
  ///
  /// [authType]为[NIMAuthType.authTypeThirdParty]时使用该字段内容去第三方服务器鉴权
  loginExt?: string

  /// 自定义客户端类型，为空、小于等于0视为没有自定义类型
  customClientType?: number
}

export interface NIMSDKOptions {
  /// app key
  appKey: string

  /// 自定义客户端类型，小于等于0视为没有自定义类型
  customClientType?: number

  /// cdn统计回调触发间隔。触发cdn拉流前设置，触发拉流后改动将不生效
  /// windows&macos&web 暂不支持
  cdnTrackInterval?: number

  /// 是否开启数据库备份功能，默认关闭
  enableDatabaseBackup?: boolean

  /// 登录时的自定义字段，登陆成功后会同步给其他端
  loginCustomTag?: string

  /// 是否开启会话已读多端同步，支持多端同步会话未读数，默认关闭
  shouldSyncUnreadCount?: boolean

  /// 开启时，如果被撤回的消息本地还未读，那么当消息发生撤回时，
  /// 对应会话的未读计数将减 1 以保持最近会话未读数的一致性。默认关闭
  shouldConsiderRevokedMessageUnreadCount?: boolean

  /// 是否启用群消息已读功能，默认关闭
  enableTeamMessageReadReceipt?: boolean

  /// 群通知消息是否计入未读数，默认不计入未读
  shouldTeamNotificationMessageMarkUnread?: boolean

  /// 默认情况下，从服务器获取原图缩略图时，如果原图为动图，我们将返回原图第一帧的缩略图。
  /// 而开启这个选项后，我们将返回缩略图后的动图。
  /// 这个选项只影响从服务器获取的缩略图，不影响本地生成的缩略图。默认关闭
  enableAnimatedImageThumbnail?: boolean

  /// 是否需要SDK自动预加载多媒体消息的附件。
  /// 如果打开，SDK收到多媒体消息后，图片和视频会自动下载缩略图，音频会自动下载文件。
  /// 如果关闭，第三方APP可以只有决定要不要下载以及何时下载附件内容，典型时机为消息列表第一次滑动到
  /// 这条消息时，才触发下载，以节省用户流量。
  /// 默认打开。
  /// web 暂不支持
  enablePreloadMessageAttachment?: boolean

  /// 是否同步置顶会话记录，默认关闭
  shouldSyncStickTopSessionInfos?: boolean

  /// 是否开启IM日志自动上报，默认关闭
  enableReportLogAutomatically?: boolean

  /// 是否使用自定义服务器地址配置文件
  useAssetServerAddressConfig?: boolean

  /// 仅 web 有，私有化配置
  assetServerAddressConfig?: any

  /// web 暂不支持
  autoLoginInfo?: NIMLoginInfo

  extras: {
    versionName: string
    versionCode: string
  }
}

class InitializeService {
  initOptions?: NIMSDKOptions

  constructor(private rootService: RootService, private nim: any) {}

  // 用户初始化传参保存
  @loggerDec
  initialize(options: NIMSDKOptions): Promise<NIMResult<void>> {
    this.initOptions = options

    // 如果这里参数有 debug 级别，就在这里设置
    // logger.setLevel()
    return Promise.resolve(successRes())
  }
}

export default InitializeService
