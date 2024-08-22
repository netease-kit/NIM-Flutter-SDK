import { successRes, failRes, emit } from '../utils'
import { NIMResult } from '../types'
import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from '@xkit-yx/utils'
import V2NIM from 'nim-web-sdk-ng'
import {
  V2NIMCreateTeamParams,
  V2NIMCreateTeamResult,
  V2NIMTeam,
  V2NIMTeamChatBannedMode,
  V2NIMTeamJoinActionInfo,
  V2NIMTeamJoinActionInfoQueryOption,
  V2NIMTeamJoinActionInfoResult,
  V2NIMTeamMember,
  V2NIMTeamMemberListResult,
  V2NIMTeamMemberQueryOption,
  V2NIMTeamMemberRole,
  V2NIMTeamType,
  V2NIMUpdateSelfMemberInfoParams,
  V2NIMUpdatedTeamInfo,
} from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMTeamService'
import {
  V2NIMAntispamConfig,
  V2NIMError,
} from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/types'
import { NOT_IMPLEMENTED_ERROR } from '../constants'

const TAG_NAME = 'TeamService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

class TeamService {
  constructor(private rootService: RootService, private nim: V2NIM) {
    this._onReceiveTeamJoinActionInfo =
      this._onReceiveTeamJoinActionInfo.bind(this)
    this._onSyncFailed = this._onSyncFailed.bind(this)
    this._onSyncFinished = this._onSyncFinished.bind(this)
    this._onSyncStarted = this._onSyncStarted.bind(this)
    this._onTeamCreated = this._onTeamCreated.bind(this)
    this._onTeamDismissed = this._onTeamDismissed.bind(this)
    this._onTeamInfoUpdated = this._onTeamInfoUpdated.bind(this)
    this._onTeamJoined = this._onTeamJoined.bind(this)
    this._onTeamLeft = this._onTeamLeft.bind(this)
    this._onTeamMemberInfoUpdated = this._onTeamMemberInfoUpdated.bind(this)
    this._onTeamMemberJoined = this._onTeamMemberJoined.bind(this)
    this._onTeamMemberKicked = this._onTeamMemberKicked.bind(this)
    this._onTeamMemberLeft = this._onTeamMemberLeft.bind(this)

    // 群组申请动作回调
    nim.V2NIMTeamService.on(
      'onReceiveTeamJoinActionInfo',
      this._onReceiveTeamJoinActionInfo
    )
    // 群组信息数据同步失败
    nim.V2NIMTeamService.on('onSyncFailed', this._onSyncFailed)
    // 群组信息数据同步完成
    nim.V2NIMTeamService.on('onSyncFinished', this._onSyncFinished)
    // 群组信息数据同步开始
    nim.V2NIMTeamService.on('onSyncStarted', this._onSyncStarted)
    // 创建群组回调
    nim.V2NIMTeamService.on('onTeamCreated', this._onTeamCreated)
    // 解散群组回调
    nim.V2NIMTeamService.on('onTeamDismissed', this._onTeamDismissed)
    // 更新群组信息回调
    nim.V2NIMTeamService.on('onTeamInfoUpdated', this._onTeamInfoUpdated)
    // 自己被邀请后接受邀请， 或申请通过，或直接被拉入群组回调
    nim.V2NIMTeamService.on('onTeamJoined', this._onTeamJoined)
    // 自己主动离开群组或被管理员踢出回调
    nim.V2NIMTeamService.on('onTeamLeft', this._onTeamLeft)
    // 群组成员信息更新回调
    nim.V2NIMTeamService.on(
      'onTeamMemberInfoUpdated',
      this._onTeamMemberInfoUpdated
    )
    // 群组成员加入回调(非自己)
    nim.V2NIMTeamService.on('onTeamMemberJoined', this._onTeamMemberJoined)
    // 群组成员被踢回调(非自己)
    nim.V2NIMTeamService.on('onTeamMemberKicked', this._onTeamMemberKicked)
    // 群组成员离开回调(非自己)
    nim.V2NIMTeamService.on('onTeamMemberLeft', this._onTeamMemberLeft)
  }

  destroy(): void {
    this.nim.V2NIMTeamService.off(
      'onReceiveTeamJoinActionInfo',
      this._onReceiveTeamJoinActionInfo
    )
    this.nim.V2NIMTeamService.off('onSyncFailed', this._onSyncFailed)
    this.nim.V2NIMTeamService.off('onSyncFinished', this._onSyncFinished)
    this.nim.V2NIMTeamService.off('onSyncStarted', this._onSyncStarted)
    this.nim.V2NIMTeamService.off('onTeamCreated', this._onTeamCreated)
    this.nim.V2NIMTeamService.off('onTeamDismissed', this._onTeamDismissed)
    this.nim.V2NIMTeamService.off('onTeamInfoUpdated', this._onTeamInfoUpdated)
    this.nim.V2NIMTeamService.off('onTeamJoined', this._onTeamJoined)
    this.nim.V2NIMTeamService.off('onTeamLeft', this._onTeamLeft)
    this.nim.V2NIMTeamService.off(
      'onTeamMemberInfoUpdated',
      this._onTeamMemberInfoUpdated
    )
    this.nim.V2NIMTeamService.off(
      'onTeamMemberJoined',
      this._onTeamMemberJoined
    )
    this.nim.V2NIMTeamService.off(
      'onTeamMemberKicked',
      this._onTeamMemberKicked
    )
    this.nim.V2NIMTeamService.off('onTeamMemberLeft', this._onTeamMemberLeft)
  }

  @loggerDec
  async createTeam(params: {
    createTeamParams: V2NIMCreateTeamParams
    inviteeAccountIds?: string[]
    postscript?: string
    antispamConfig?: V2NIMAntispamConfig
  }): Promise<NIMResult<V2NIMCreateTeamResult>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.createTeam(
          params.createTeamParams,
          params.inviteeAccountIds,
          params.postscript,
          params.antispamConfig
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async updateTeamInfo(params: {
    teamId: string
    teamType: V2NIMTeamType
    updateTeamInfoParams: V2NIMUpdatedTeamInfo
    antispamConfig?: V2NIMAntispamConfig
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.updateTeamInfo(
          params.teamId,
          params.teamType,
          params.updateTeamInfoParams,
          params.antispamConfig
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async leaveTeam(params: {
    teamId: string
    teamType: V2NIMTeamType
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.leaveTeam(
          params.teamId,
          params.teamType
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getTeamInfo(params: {
    teamId: string
    teamType: V2NIMTeamType
  }): Promise<NIMResult<V2NIMTeam>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.getTeamInfo(
          params.teamId,
          params.teamType
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getTeamInfoByIds(params: {
    teamIds: string[]
    teamType: V2NIMTeamType
  }): Promise<NIMResult<{ teamList: V2NIMTeam[] }>> {
    try {
      return successRes({
        teamList: await this.nim.V2NIMTeamService.getTeamInfoByIds(
          params.teamIds,
          params.teamType
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async dismissTeam(params: {
    teamId: string
    teamType: V2NIMTeamType
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.dismissTeam(
          params.teamId,
          params.teamType
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async inviteMember(params: {
    teamId: string
    teamType: V2NIMTeamType
    inviteeAccountIds: string[]
    postscript?: string
  }): Promise<NIMResult<{ failedList: string[] }>> {
    try {
      return successRes({
        failedList: await this.nim.V2NIMTeamService.inviteMember(
          params.teamId,
          params.teamType,
          params.inviteeAccountIds,
          params.postscript
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async acceptInvitation(params: {
    invitationInfo: V2NIMTeamJoinActionInfo
  }): Promise<NIMResult<V2NIMTeam>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.acceptInvitation(params.invitationInfo)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async rejectInvitation(params: {
    invitationInfo: V2NIMTeamJoinActionInfo
    postscript?: string
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.rejectInvitation(
          params.invitationInfo,
          params.postscript
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async kickMember(params: {
    teamId: string
    teamType: V2NIMTeamType
    memberAccountIds?: string[]
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.kickMember(
          params.teamId,
          params.teamType,
          params.memberAccountIds || []
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async applyJoinTeam(params: {
    teamId: string
    teamType: V2NIMTeamType
    postscript?: string
  }): Promise<NIMResult<V2NIMTeam>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.applyJoinTeam(
          params.teamId,
          params.teamType,
          params.postscript
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async acceptJoinApplication(params: {
    joinInfo: V2NIMTeamJoinActionInfo
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.acceptJoinApplication(params.joinInfo)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async rejectJoinApplication(params: {
    joinInfo: V2NIMTeamJoinActionInfo
    postscript?: string
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.rejectJoinApplication(
          params.joinInfo,
          params.postscript
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async updateTeamMemberRole(params: {
    teamId: string
    teamType: V2NIMTeamType
    memberAccountIds: string[]
    memberRole: V2NIMTeamMemberRole
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.updateTeamMemberRole(
          params.teamId,
          params.teamType,
          params.memberAccountIds,
          params.memberRole
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async transferTeamOwner(params: {
    teamId: string
    teamType: V2NIMTeamType
    accountId: string
    leave: boolean
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.transferTeamOwner(
          params.teamId,
          params.teamType,
          params.accountId,
          params.leave
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async updateSelfTeamMemberInfo(params: {
    teamId: string
    teamType: V2NIMTeamType
    memberInfoParams: V2NIMUpdateSelfMemberInfoParams
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.updateSelfTeamMemberInfo(
          params.teamId,
          params.teamType,
          params.memberInfoParams
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async updateTeamMemberNick(params: {
    teamId: string
    teamType: V2NIMTeamType
    accountId: string
    teamNick: string
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.updateTeamMemberNick(
          params.teamId,
          params.teamType,
          params.accountId,
          params.teamNick
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async setTeamChatBannedMode(params: {
    teamId: string
    teamType: V2NIMTeamType
    chatBannedMode: V2NIMTeamChatBannedMode
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.setTeamChatBannedMode(
          params.teamId,
          params.teamType,
          params.chatBannedMode
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async setTeamMemberChatBannedStatus(params: {
    teamId: string
    teamType: V2NIMTeamType
    accountId: string
    chatBanned: boolean
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.setTeamMemberChatBannedStatus(
          params.teamId,
          params.teamType,
          params.accountId,
          params.chatBanned
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getJoinedTeamList(params: {
    teamTypes: V2NIMTeamType[]
  }): Promise<NIMResult<{ teamList: V2NIMTeam[] }>> {
    try {
      return successRes({
        teamList: await this.nim.V2NIMTeamService.getJoinedTeamList(
          params.teamTypes
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getJoinedTeamCount(params: {
    teamTypes: V2NIMTeamType[]
  }): Promise<NIMResult<number>> {
    try {
      return successRes(
        this.nim.V2NIMTeamService.getJoinedTeamCount(params.teamTypes)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getTeamMemberList(params: {
    teamId: string
    teamType: V2NIMTeamType
    queryOption: V2NIMTeamMemberQueryOption
  }): Promise<NIMResult<V2NIMTeamMemberListResult>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.getTeamMemberList(
          params.teamId,
          params.teamType,
          params.queryOption
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getTeamMemberListByIds(params: {
    teamId: string
    teamType: V2NIMTeamType
    accountIds: string[]
  }): Promise<NIMResult<{ memberList: V2NIMTeamMember[] }>> {
    try {
      return successRes({
        memberList: await this.nim.V2NIMTeamService.getTeamMemberListByIds(
          params.teamId,
          params.teamType,
          params.accountIds
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getTeamMemberInvitor(params: {
    teamId: string
    teamType: V2NIMTeamType
    accountIds: string[]
  }): Promise<
    NIMResult<{
      [accountId: string]: string
    }>
  > {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.getTeamMemberInvitor(
          params.teamId,
          params.teamType,
          params.accountIds
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getTeamJoinActionInfoList(params: {
    queryOption: V2NIMTeamJoinActionInfoQueryOption
  }): Promise<NIMResult<V2NIMTeamJoinActionInfoResult>> {
    try {
      return successRes(
        await this.nim.V2NIMTeamService.getTeamJoinActionInfoList(
          params.queryOption
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async searchTeamByKeyword(params: {
    keyword: string
  }): Promise<NIMResult<{ teamList: V2NIMTeam[] }>> {
    try {
      return successRes({
        teamList: await this.nim.V2NIMTeamService.searchTeamByKeyword(
          params.keyword
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async searchTeamMembers(params: {
    searchOption: V2NIMTeamMemberQueryOption
  }): Promise<NIMResult<any>> {
    throw NOT_IMPLEMENTED_ERROR
  }

  private _onReceiveTeamJoinActionInfo(data: V2NIMTeamJoinActionInfo) {
    logger.log('_onReceiveTeamJoinActionInfo: ', data)
    emit('TeamService', 'onReceiveTeamJoinActionInfo', data)
  }

  private _onSyncFailed(data: V2NIMError) {
    logger.log('_onSyncFailed: ', data)
    emit('TeamService', 'onSyncFailed', failRes(data))
  }

  private async _onSyncFinished() {
    logger.log('_onSyncFinished')
    emit('TeamService', 'onSyncFinished', {})
  }

  private _onSyncStarted() {
    logger.log('_onSyncStarted')
    emit('TeamService', 'onSyncStarted', {})
  }

  private _onTeamCreated(data: V2NIMTeam) {
    logger.log('_onTeamCreated: ', data)
    emit('TeamService', 'onTeamCreated', data)
  }

  private _onTeamDismissed(data: V2NIMTeam) {
    logger.log('_onTeamDismissed: ', data)
    emit('TeamService', 'onTeamDismissed', data)
  }

  private _onTeamInfoUpdated(data: V2NIMTeam) {
    logger.log('_onTeamInfoUpdated: ', data)
    emit('TeamService', 'onTeamInfoUpdated', data)
  }

  private _onTeamJoined(data: V2NIMTeam) {
    logger.log('_onTeamJoined: ', data)
    emit('TeamService', 'onTeamJoined', data)
  }

  private async _onTeamLeft(team: V2NIMTeam, isKicked: boolean) {
    logger.log('_onTeamLeft: ', team, isKicked)
    emit('TeamService', 'onTeamLeft', { team, isKicked })
  }

  private _onTeamMemberInfoUpdated(memberList: V2NIMTeamMember[]) {
    logger.log('_onTeamMemberInfoUpdated: ', memberList)
    emit('TeamService', 'onTeamMemberInfoUpdated', { memberList })
  }

  private async _onTeamMemberJoined(data: V2NIMTeamMember[]) {
    logger.log('_onTeamMemberJoined: ', data)
    emit('TeamService', 'onTeamMemberJoined', data)
  }

  private async _onTeamMemberKicked(
    operateAccountId: string,
    memberList: V2NIMTeamMember[]
  ) {
    logger.log('_onTeamMemberKicked: ', operateAccountId, memberList)
    emit('TeamService', 'onTeamMemberKicked', { operateAccountId, memberList })
  }

  private async _onTeamMemberLeft(memberList: V2NIMTeamMember[]) {
    logger.log('_onTeamMemberLeft: ', memberList)
    emit('TeamService', 'onTeamMemberLeft', { memberList })
  }
}

export default TeamService
