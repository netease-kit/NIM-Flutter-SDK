import {
  successRes,
  failRes,
  emit,
  formatV2Message,
  NIMAIModelRoleType,
  formatAIModelRoleType,
} from '../utils'
import { NIMResult } from '../types'
import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from '@xkit-yx/utils'
import V2NIM from 'nim-web-sdk-ng'
import { V2NIMError } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/types'
import {
  V2NIMAddCollectionParams,
  V2NIMClearHistoryMessageOption,
  V2NIMClearHistoryNotification,
  V2NIMCollection,
  V2NIMCollectionOption,
  V2NIMMessage,
  V2NIMMessageAIConfigParams,
  V2NIMMessageDeletedNotification,
  V2NIMMessageListOption,
  V2NIMMessagePin,
  V2NIMMessagePinNotification,
  V2NIMMessageQuickComment,
  V2NIMMessageQuickCommentNotification,
  V2NIMMessageQuickCommentPushConfig,
  V2NIMMessageRefer,
  V2NIMMessageRevokeNotification,
  V2NIMMessageRevokeParams,
  V2NIMMessageSearchParams,
  V2NIMP2PMessageReadReceipt,
  V2NIMSendMessageParams,
  V2NIMSendMessageResult,
  V2NIMTeamMessageReadReceipt,
  V2NIMTeamMessageReadReceiptDetail,
  V2NIMThreadMessageListOption,
  V2NIMThreadMessageListResult,
  V2NIMVoiceToTextParams,
} from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMMessageService'
import { NOT_IMPLEMENTED_ERROR } from 'src/constants'
import { V2NIMAIModelCallMessage } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMAIService'

const TAG_NAME = 'MessageService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

class MessageService {
  constructor(private rootService: RootService, private nim: V2NIM) {
    this._onReceiveMessages = this._onReceiveMessages.bind(this)
    this._onClearHistoryNotifications =
      this._onClearHistoryNotifications.bind(this)
    this._onMessageDeletedNotifications =
      this._onMessageDeletedNotifications.bind(this)
    this._onMessagePinNotification = this._onMessagePinNotification.bind(this)
    this._onMessageQuickCommentNotification =
      this._onMessageQuickCommentNotification.bind(this)
    this._onMessageRevokeNotifications =
      this._onMessageRevokeNotifications.bind(this)
    this._onReceiveP2PMessageReadReceipts =
      this._onReceiveP2PMessageReadReceipts.bind(this)
    this._onReceiveTeamMessageReadReceipts =
      this._onReceiveTeamMessageReadReceipts.bind(this)
    this._onSendMessage = this._onSendMessage.bind(this)

    // 收到消息
    nim.V2NIMMessageService.on('onReceiveMessages', this._onReceiveMessages)
    // 清空会话历史消息通知
    nim.V2NIMMessageService.on(
      'onClearHistoryNotifications',
      this._onClearHistoryNotifications
    )
    // 消息被删除通知
    nim.V2NIMMessageService.on(
      'onMessageDeletedNotifications',
      this._onMessageDeletedNotifications
    )
    // 收到消息 pin 状态更新
    nim.V2NIMMessageService.on(
      'onMessagePinNotification',
      this._onMessagePinNotification
    )
    // 收到消息快捷评论更新
    nim.V2NIMMessageService.on(
      'onMessageQuickCommentNotification',
      this._onMessageQuickCommentNotification
    )
    // 收到消息撤回通知
    nim.V2NIMMessageService.on(
      'onMessageRevokeNotifications',
      this._onMessageRevokeNotifications
    )
    // 收到点对点消息的已读回执
    nim.V2NIMMessageService.on(
      'onReceiveP2PMessageReadReceipts',
      this._onReceiveP2PMessageReadReceipts
    )
    // 收到群消息的已读回执
    nim.V2NIMMessageService.on(
      'onReceiveTeamMessageReadReceipts',
      this._onReceiveTeamMessageReadReceipts
    )
    // 本端发送消息状态回调
    nim.V2NIMMessageService.on('onSendMessage', this._onSendMessage)
  }

  destroy(): void {
    this.nim.V2NIMMessageService.off(
      'onReceiveMessages',
      this._onReceiveMessages
    )
    this.nim.V2NIMMessageService.off(
      'onClearHistoryNotifications',
      this._onClearHistoryNotifications
    )
    this.nim.V2NIMMessageService.off(
      'onMessageDeletedNotifications',
      this._onMessageDeletedNotifications
    )
    this.nim.V2NIMMessageService.off(
      'onMessagePinNotification',
      this._onMessagePinNotification
    )
    this.nim.V2NIMMessageService.off(
      'onMessageQuickCommentNotification',
      this._onMessageQuickCommentNotification
    )
    this.nim.V2NIMMessageService.off(
      'onMessageRevokeNotifications',
      this._onMessageRevokeNotifications
    )
    this.nim.V2NIMMessageService.off(
      'onReceiveP2PMessageReadReceipts',
      this._onReceiveP2PMessageReadReceipts
    )
    this.nim.V2NIMMessageService.off(
      'onReceiveTeamMessageReadReceipts',
      this._onReceiveTeamMessageReadReceipts
    )
    this.nim.V2NIMMessageService.off('onSendMessage', this._onSendMessage)
  }

  @loggerDec
  async getMessageList(params: {
    option: V2NIMMessageListOption
  }): Promise<NIMResult<{ messages: V2NIMMessage[] }>> {
    try {
      return successRes({
        messages: (
          await this.nim.V2NIMMessageService.getMessageList(params.option)
        ).map((item) => formatV2Message(item)),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getMessageListByIds(params: {
    messageClientIds: string[]
  }): Promise<NIMResult<{ messages: V2NIMMessage[] }>> {
    throw NOT_IMPLEMENTED_ERROR
  }

  @loggerDec
  async getMessageListByRefers(params: {
    messageRefers: V2NIMMessageRefer[]
  }): Promise<NIMResult<{ messages: V2NIMMessage[] }>> {
    try {
      return successRes({
        messages: (
          await this.nim.V2NIMMessageService.getMessageListByRefers(
            params.messageRefers
          )
        ).map((item) => formatV2Message(item)),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async searchCloudMessages(params: {
    params: V2NIMMessageSearchParams
  }): Promise<NIMResult<{ messages: V2NIMMessage[] }>> {
    try {
      return successRes({
        messages: (
          await this.nim.V2NIMMessageService.searchCloudMessages(params.params)
        ).map((item) => formatV2Message(item)),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getLocalThreadMessageList(params: {
    messageRefer: V2NIMMessageRefer
  }): Promise<NIMResult<{ messages: V2NIMMessage[] }>> {
    throw NOT_IMPLEMENTED_ERROR
  }

  @loggerDec
  async getThreadMessageList(params: {
    option: V2NIMThreadMessageListOption
  }): Promise<NIMResult<V2NIMThreadMessageListResult>> {
    try {
      const res = await this.nim.V2NIMMessageService.getThreadMessageList(
        params.option
      )
      return successRes({ ...res, message: formatV2Message(res.message) })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async insertMessageToLocal(params: any): Promise<NIMResult<V2NIMMessage>> {
    throw NOT_IMPLEMENTED_ERROR
  }

  @loggerDec
  async updateMessageLocalExtension(params: {
    message: V2NIMMessage
    localExtension: string
  }): Promise<NIMResult<void>> {
    throw NOT_IMPLEMENTED_ERROR
  }

  @loggerDec
  async sendMessage(params: {
    message: V2NIMMessage
    conversationId: string
    params?: Omit<V2NIMSendMessageParams, 'aiConfig'> & {
      aiConfig?: Omit<V2NIMMessageAIConfigParams, 'messages'> & {
        messages?: (Omit<V2NIMAIModelCallMessage, 'role'> & {
          role: NIMAIModelRoleType
        })[]
      }
    }
  }): Promise<NIMResult<V2NIMSendMessageResult>> {
    try {
      const messageClientId = params.message.messageClientId
      const msg =
        this.rootService.MessageCreatorService?.msgMap?.get(messageClientId)
      const finalMsg: V2NIMMessage = { ...params.message, ...msg }
      const res = await this.nim.V2NIMMessageService.sendMessage(
        finalMsg,
        params.conversationId,
        {
          ...params.params,
          aiConfig: params.params?.aiConfig
            ? {
                ...params.params.aiConfig,
                messages: params.params.aiConfig.messages?.length
                  ? params.params.aiConfig.messages.map((item) => ({
                      ...item,
                      role: formatAIModelRoleType(item.role),
                    }))
                  : void 0,
              }
            : void 0,
        },
        (percentage: number) => {
          emit('MessageService', 'onSendMessageProgress', {
            messageClientId: messageClientId,
            progress: percentage,
          })
        }
      )
      this.rootService.MessageCreatorService?.msgMap?.delete(messageClientId)
      return successRes({ ...res, message: formatV2Message(res.message) })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async replyMessage(params: {
    message: V2NIMMessage
    replyMessage: V2NIMMessage
    params?: V2NIMSendMessageParams
  }): Promise<NIMResult<V2NIMSendMessageResult>> {
    try {
      const res = await this.nim.V2NIMMessageService.replyMessage(
        params.message,
        params.replyMessage,
        params.params,
        (percentage: number) => {
          emit('MessageService', 'onSendMessageProgress', {
            messageClientId: params.message.messageClientId,
            progress: percentage,
          })
        }
      )
      return successRes({ ...res, message: formatV2Message(res.message) })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async revokeMessage(params: {
    message: V2NIMMessage
    revokeParams?: V2NIMMessageRevokeParams
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.revokeMessage(
          params.message,
          params.revokeParams
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async pinMessage(params: {
    message: V2NIMMessage
    serverExtension?: string
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.pinMessage(
          params.message,
          params.serverExtension
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async unpinMessage(params: {
    messageRefer: V2NIMMessageRefer
    serverExtension?: string
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.unpinMessage(
          params.messageRefer,
          params.serverExtension
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async updatePinMessage(params: {
    message: V2NIMMessage
    serverExtension?: string
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.updatePinMessage(
          params.message,
          params.serverExtension
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getPinnedMessageList(params: {
    conversationId: string
  }): Promise<NIMResult<{ pinMessages: V2NIMMessagePin[] }>> {
    try {
      return successRes({
        pinMessages: await this.nim.V2NIMMessageService.getPinnedMessageList(
          params.conversationId
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async addQuickComment(params: {
    message: V2NIMMessage
    index: number
    serverExtension?: string
    pushConfig?: V2NIMMessageQuickCommentPushConfig
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.addQuickComment(
          params.message,
          params.index,
          params.serverExtension,
          params.pushConfig
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async removeQuickComment(params: {
    messageRefer: V2NIMMessageRefer
    index: number
    serverExtension?: string
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.removeQuickComment(
          params.messageRefer,
          params.index,
          params.serverExtension
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getQuickCommentList(params: {
    messages: V2NIMMessage[]
  }): Promise<
    NIMResult<{ [messageClientId: string]: V2NIMMessageQuickComment[] }>
  > {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.getQuickCommentList(params.messages)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async deleteMessage(params: {
    message: V2NIMMessage
    serverExtension?: string
    onlyDeleteLocal?: boolean
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.deleteMessage(
          params.message,
          params.serverExtension
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async deleteMessages(params: {
    messages: V2NIMMessage[]
    serverExtension?: string
    onlyDeleteLocal?: boolean
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.deleteMessages(
          params.messages,
          params.serverExtension
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async clearHistoryMessage(params: {
    option: V2NIMClearHistoryMessageOption
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.clearHistoryMessage(params.option)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async sendP2PMessageReceipt(params: {
    message: V2NIMMessage
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.sendP2PMessageReceipt(params.message)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getP2PMessageReceipt(params: {
    conversationId: string
  }): Promise<NIMResult<V2NIMP2PMessageReadReceipt>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.getP2PMessageReceipt(
          params.conversationId
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async isPeerRead(params: {
    message: V2NIMMessage
  }): Promise<NIMResult<boolean>> {
    try {
      return successRes(this.nim.V2NIMMessageService.isPeerRead(params.message))
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async sendTeamMessageReceipts(params: {
    messages: V2NIMMessage[]
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.sendTeamMessageReceipts(
          params.messages
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getTeamMessageReceipts(params: {
    messages: V2NIMMessage[]
  }): Promise<NIMResult<{ readReceipts: V2NIMTeamMessageReadReceipt[] }>> {
    try {
      return successRes({
        readReceipts: await this.nim.V2NIMMessageService.getTeamMessageReceipts(
          params.messages
        ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getTeamMessageReceiptDetail(params: {
    message: V2NIMMessage
    memberAccountIds?: string[]
  }): Promise<NIMResult<V2NIMTeamMessageReadReceiptDetail>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.getTeamMessageReceiptDetail(
          params.message,
          params.memberAccountIds
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async addCollection(params: {
    params: V2NIMAddCollectionParams
  }): Promise<NIMResult<V2NIMCollection>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.addCollection(params.params)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async removeCollections(params: {
    collections: V2NIMCollection[]
  }): Promise<NIMResult<number>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.removeCollections(params.collections)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async updateCollectionExtension(params: {
    collection: V2NIMCollection
    serverExtension?: string
  }): Promise<NIMResult<V2NIMCollection>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.updateCollectionExtension(
          params.collection,
          params.serverExtension
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getCollectionListByOption(params: {
    option: V2NIMCollectionOption
  }): Promise<NIMResult<{ collections: V2NIMCollection[] }>> {
    try {
      return successRes({
        collections:
          await this.nim.V2NIMMessageService.getCollectionListByOption(
            params.option
          ),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async voiceToText(params: {
    params: V2NIMVoiceToTextParams
  }): Promise<NIMResult<string>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.voiceToText(params.params)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async cancelMessageAttachmentUpload(params: {
    message: V2NIMMessage
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMMessageService.cancelMessageAttachmentUpload(
          params.message
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  private _onReceiveMessages(messages: V2NIMMessage[]) {
    logger.log('_onReceiveMessages', messages)
    emit('MessageService', 'onReceiveMessages', {
      messages: messages.map((item) => formatV2Message(item)),
    })
  }

  private _onClearHistoryNotifications(
    notification: V2NIMClearHistoryNotification[]
  ) {
    logger.log('_onClearHistoryNotifications', notification)
    emit('MessageService', 'onClearHistoryNotifications', {
      clearHistoryNotifications: notification,
    })
  }

  private _onMessageDeletedNotifications(
    notification: V2NIMMessageDeletedNotification[]
  ): void {
    logger.log('_onMessageDeletedNotifications', notification)
    emit('MessageService', 'onMessageDeletedNotifications', {
      deletedNotifications: notification,
    })
  }

  private _onMessagePinNotification(
    notification: V2NIMMessagePinNotification
  ): void {
    logger.log('_onMessagePinNotification', notification)
    emit('MessageService', 'onMessagePinNotification', notification)
  }

  private _onMessageQuickCommentNotification(
    notification: V2NIMMessageQuickCommentNotification
  ): void {
    logger.log('_onMessageQuickCommentNotification', notification)
    emit('MessageService', 'onMessageQuickCommentNotification', notification)
  }

  private _onMessageRevokeNotifications(
    notification: V2NIMMessageRevokeNotification[]
  ): void {
    logger.log('_onMessageRevokeNotifications', notification)
    emit('MessageService', 'onMessageRevokeNotifications', {
      revokeNotifications: notification,
    })
  }

  private _onReceiveP2PMessageReadReceipts(
    readReceipts: V2NIMP2PMessageReadReceipt[]
  ): void {
    logger.log('_onReceiveP2PMessageReadReceipts', readReceipts)
    emit('MessageService', 'onReceiveP2PMessageReadReceipts', {
      p2pMessageReadReceipts: readReceipts,
    })
  }

  private _onReceiveTeamMessageReadReceipts(
    readReceipts: V2NIMTeamMessageReadReceipt[]
  ): void {
    logger.log('_onReceiveTeamMessageReadReceipts', readReceipts)
    emit('MessageService', 'onReceiveTeamMessageReadReceipts', {
      teamMessageReadReceipts: readReceipts,
    })
  }

  private _onSendMessage(message: V2NIMMessage): void {
    logger.log('_onSendMessage', message)
    emit('MessageService', 'onSendMessage', formatV2Message(message))
  }
}

export default MessageService
