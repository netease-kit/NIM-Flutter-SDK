import {
  successRes,
  failRes,
  emit,
  formatV2ConversationLastMessage,
} from '../utils'
import { NIMResult } from '../types'
import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from '@xkit-yx/utils'
import V2NIM from 'nim-web-sdk-ng'
import { V2NIMError } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/types'
import {
  V2NIMConversation,
  V2NIMConversationFilter,
  V2NIMConversationOperationResult,
  V2NIMConversationOption,
  V2NIMConversationResult,
  V2NIMConversationType,
  V2NIMConversationUpdate,
} from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMConversationService'

const TAG_NAME = 'ConversationService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

class ConversationService {
  constructor(private rootService: RootService, private nim: V2NIM) {
    this._onConversationChanged = this._onConversationChanged.bind(this)
    this._onConversationCreated = this._onConversationCreated.bind(this)
    this._onConversationDeleted = this._onConversationDeleted.bind(this)
    this._onConversationReadTimeUpdated =
      this._onConversationReadTimeUpdated.bind(this)
    this._onSyncFailed = this._onSyncFailed.bind(this)
    this._onSyncFinished = this._onSyncFinished.bind(this)
    this._onSyncStarted = this._onSyncStarted.bind(this)
    this._onTotalUnreadCountChanged = this._onTotalUnreadCountChanged.bind(this)
    this._onUnreadCountChangedByFilter =
      this._onUnreadCountChangedByFilter.bind(this)

    nim.V2NIMConversationService.on(
      'onConversationChanged',
      this._onConversationChanged
    )
    nim.V2NIMConversationService.on(
      'onConversationCreated',
      this._onConversationCreated
    )
    nim.V2NIMConversationService.on(
      'onConversationDeleted',
      this._onConversationDeleted
    )
    nim.V2NIMConversationService.on(
      'onConversationReadTimeUpdated',
      this._onConversationReadTimeUpdated
    )
    nim.V2NIMConversationService.on('onSyncFailed', this._onSyncFailed)
    nim.V2NIMConversationService.on('onSyncFinished', this._onSyncFinished)
    nim.V2NIMConversationService.on('onSyncStarted', this._onSyncStarted)
    nim.V2NIMConversationService.on(
      'onTotalUnreadCountChanged',
      this._onTotalUnreadCountChanged
    )
    nim.V2NIMConversationService.on(
      'onUnreadCountChangedByFilter',
      this._onUnreadCountChangedByFilter
    )
  }

  destroy(): void {
    this.nim.V2NIMConversationService.off(
      'onConversationChanged',
      this._onConversationChanged
    )
    this.nim.V2NIMConversationService.off(
      'onConversationCreated',
      this._onConversationCreated
    )
    this.nim.V2NIMConversationService.off(
      'onConversationDeleted',
      this._onConversationDeleted
    )
    this.nim.V2NIMConversationService.off(
      'onConversationReadTimeUpdated',
      this._onConversationReadTimeUpdated
    )
    this.nim.V2NIMConversationService.off('onSyncFailed', this._onSyncFailed)
    this.nim.V2NIMConversationService.off(
      'onSyncFinished',
      this._onSyncFinished
    )
    this.nim.V2NIMConversationService.off('onSyncStarted', this._onSyncStarted)
    this.nim.V2NIMConversationService.off(
      'onTotalUnreadCountChanged',
      this._onTotalUnreadCountChanged
    )
    this.nim.V2NIMConversationService.off(
      'onUnreadCountChangedByFilter',
      this._onUnreadCountChangedByFilter
    )
  }

  @loggerDec
  async getConversationList(params: {
    offset: number
    limit: number
  }): Promise<NIMResult<V2NIMConversationResult>> {
    try {
      const res = await this.nim.V2NIMConversationService.getConversationList(
        params.offset,
        params.limit
      )
      return successRes({
        ...res,
        conversationList: res.conversationList.map((item) =>
          formatV2ConversationLastMessage(item)
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getConversationListByOption(params: {
    option: V2NIMConversationOption
    offset: number
    limit: number
  }): Promise<NIMResult<V2NIMConversationResult>> {
    try {
      const res =
        await this.nim.V2NIMConversationService.getConversationListByOption(
          params.offset,
          params.limit,
          params.option
        )
      return successRes({
        ...res,
        conversationList: res.conversationList.map((item) =>
          formatV2ConversationLastMessage(item)
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getConversation(params: {
    conversationId: string
  }): Promise<NIMResult<V2NIMConversation>> {
    try {
      return successRes(
        formatV2ConversationLastMessage(
          await this.nim.V2NIMConversationService.getConversation(
            params.conversationId
          )
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getConversationListByIds(params: {
    conversationIdList: string[]
  }): Promise<NIMResult<{ conversationList: V2NIMConversation[] }>> {
    try {
      return successRes({
        conversationList: (
          await this.nim.V2NIMConversationService.getConversationListByIds(
            params.conversationIdList
          )
        ).map((item) => formatV2ConversationLastMessage(item)),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async createConversation(params: {
    conversationId: string
  }): Promise<NIMResult<V2NIMConversation>> {
    try {
      return successRes(
        formatV2ConversationLastMessage(
          await this.nim.V2NIMConversationService.createConversation(
            params.conversationId
          )
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async deleteConversation(params: {
    conversationId: string
    clearMessage: boolean
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMConversationService.deleteConversation(
          params.conversationId,
          params.clearMessage
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async deleteConversationListByIds(params: {
    conversationIdList: string[]
    clearMessage: boolean
  }): Promise<
    NIMResult<{
      conversationOperationResult: V2NIMConversationOperationResult[]
    }>
  > {
    try {
      return successRes({
        conversationOperationResult:
          await this.nim.V2NIMConversationService.deleteConversationListByIds(
            params.conversationIdList,
            params.clearMessage
          ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async stickTopConversation(params: {
    conversationId: string
    stickTop: boolean
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMConversationService.stickTopConversation(
          params.conversationId,
          params.stickTop
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async updateConversation(params: {
    conversationId: string
    updateInfo: V2NIMConversationUpdate
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMConversationService.updateConversation(
          params.conversationId,
          params.updateInfo
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async updateConversationLocalExtension(params: {
    conversationId: string
    localExtension?: string
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMConversationService.updateConversationLocalExtension(
          params.conversationId,
          params.localExtension || ''
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getTotalUnreadCount(): Promise<NIMResult<number>> {
    try {
      return successRes(this.nim.V2NIMConversationService.getTotalUnreadCount())
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getUnreadCountByIds(params: {
    conversationIdList: string[]
  }): Promise<NIMResult<number>> {
    try {
      return successRes(
        await this.nim.V2NIMConversationService.getUnreadCountByIds(
          params.conversationIdList
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getUnreadCountByFilter(
    params: V2NIMConversationFilter
  ): Promise<NIMResult<number>> {
    try {
      return successRes(
        await this.nim.V2NIMConversationService.getUnreadCountByFilter(params)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async clearTotalUnreadCount(): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMConversationService.clearTotalUnreadCount()
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async clearUnreadCountByIds(params: {
    conversationIdList: string[]
  }): Promise<
    NIMResult<{
      conversationOperationResult: V2NIMConversationOperationResult[]
    }>
  > {
    try {
      return successRes({
        conversationOperationResult:
          await this.nim.V2NIMConversationService.clearUnreadCountByIds(
            params.conversationIdList
          ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async clearUnreadCountByGroupId(params: {
    groupId: string
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMConversationService.clearUnreadCountByGroupId(
          params.groupId
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async clearUnreadCountByTypes(params: {
    conversationTypeList: V2NIMConversationType[]
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMConversationService.clearUnreadCountByTypes(
          params.conversationTypeList
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async subscribeUnreadCountByFilter(params: {
    filter: V2NIMConversationFilter
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        this.nim.V2NIMConversationService.subscribeUnreadCountByFilter(
          params.filter
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async unsubscribeUnreadCountByFilter(params: {
    filter: V2NIMConversationFilter
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        this.nim.V2NIMConversationService.unsubscribeUnreadCountByFilter(
          params.filter
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getConversationReadTime(params: {
    conversationId: string
  }): Promise<NIMResult<number>> {
    try {
      return successRes(
        await this.nim.V2NIMConversationService.getConversationReadTime(
          params.conversationId
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async markConversationRead(params: {
    conversationId: string
  }): Promise<NIMResult<number>> {
    try {
      return successRes(
        await this.nim.V2NIMConversationService.markConversationRead(
          params.conversationId
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  private _onConversationChanged(conversationList: V2NIMConversation[]): void {
    logger.log('_onConversationChanged', conversationList)
    emit('ConversationService', 'onConversationChanged', {
      conversationList: conversationList.map((item) =>
        formatV2ConversationLastMessage(item)
      ),
    })
  }

  private _onConversationCreated(conversation: V2NIMConversation): void {
    logger.log('_onConversationCreated', conversation)
    emit(
      'ConversationService',
      'onConversationCreated',
      formatV2ConversationLastMessage(conversation)
    )
  }

  private _onConversationDeleted(conversationIds: string[]): void {
    logger.log('_onConversationDeleted', conversationIds)
    emit('ConversationService', 'onConversationDeleted', {
      conversationIdList: conversationIds,
    })
  }

  private _onConversationReadTimeUpdated(
    conversationId: string,
    readTime: number
  ): void {
    logger.log('_onConversationReadTimeUpdated', conversationId, readTime)
    emit('ConversationService', 'onConversationReadTimeUpdated', {
      conversationId,
      readTime,
    })
  }

  private _onSyncFailed(error: V2NIMError): void {
    logger.log('_onSyncFailed', error)
    emit('ConversationService', 'onSyncFailed', {})
  }

  private _onSyncFinished(): void {
    logger.log('_onSyncFinished')
    emit('ConversationService', 'onSyncFinished', {})
  }

  private _onSyncStarted(): void {
    logger.log('_onSyncStarted')
    emit('ConversationService', 'onSyncStarted', {})
  }

  private _onTotalUnreadCountChanged(unreadCount: number): void {
    logger.log('_onTotalUnreadCountChanged', unreadCount)
    emit('ConversationService', 'onTotalUnreadCountChanged', {
      unreadCount,
    })
  }

  private _onUnreadCountChangedByFilter(
    filter: V2NIMConversationFilter & {
      equals: (filter: V2NIMConversationFilter) => boolean
    },
    unreadCount: number
  ): void {
    logger.log('_onUnreadCountChangedByFilter', unreadCount, filter)
    emit('ConversationService', 'onUnreadCountChangedByFilter', {
      unreadCount,
      conversationFilter: filter,
    })
  }
}

export default ConversationService
