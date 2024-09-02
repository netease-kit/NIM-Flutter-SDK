import { successRes } from '../utils'
import { NIMResult } from '../types'
import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from '@xkit-yx/utils'
import V2NIM from 'nim-web-sdk-ng'
import { V2NIMConversationType } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMConversationService'
import { NOT_IMPLEMENTED_ERROR } from 'src/constants'

const TAG_NAME = 'ConversationUtil'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

class ConversationUtil {
  constructor(private rootService: RootService, private nim: V2NIM) {
    //
  }

  destroy(): void {
    //
  }

  @loggerDec
  async conversationId(params: {
    targetId: string
    conversationType: V2NIMConversationType
  }): Promise<NIMResult<string>> {
    throw NOT_IMPLEMENTED_ERROR
  }

  @loggerDec
  async p2pConversationId(params: {
    accountId: string
  }): Promise<NIMResult<string>> {
    return successRes(
      this.nim.V2NIMConversationIdUtil.p2pConversationId(params.accountId)
    )
  }

  @loggerDec
  async teamConversationId(params: {
    teamId: string
  }): Promise<NIMResult<string>> {
    return successRes(
      this.nim.V2NIMConversationIdUtil.teamConversationId(params.teamId)
    )
  }

  @loggerDec
  async superTeamConversationId(params: {
    superTeamId: string
  }): Promise<NIMResult<string>> {
    return successRes(
      this.nim.V2NIMConversationIdUtil.superTeamConversationId(
        params.superTeamId
      )
    )
  }

  @loggerDec
  async conversationType(params: {
    conversationId: string
  }): Promise<NIMResult<{ conversationType: V2NIMConversationType }>> {
    return successRes({
      conversationType: this.nim.V2NIMConversationIdUtil.parseConversationType(
        params.conversationId
      ),
    })
  }

  @loggerDec
  async conversationTargetId(params: {
    conversationId: string
  }): Promise<NIMResult<string>> {
    return successRes(
      this.nim.V2NIMConversationIdUtil.parseConversationTargetId(
        params.conversationId
      )
    )
  }

  @loggerDec
  async isConversationIdValid(params: {
    conversationId: string
  }): Promise<NIMResult<boolean>> {
    throw NOT_IMPLEMENTED_ERROR
  }

  @loggerDec
  async sessionTypeV1(params: any): Promise<NIMResult<any>> {
    throw NOT_IMPLEMENTED_ERROR
  }
}

export default ConversationUtil
