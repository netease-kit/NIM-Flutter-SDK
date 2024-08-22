import { successRes, failRes } from '../utils'
import { NIMResult } from '../types'
import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from '@xkit-yx/utils'
import V2NIM from 'nim-web-sdk-ng'
import { V2NIMError } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/types'
import {
  V2NIMMessage,
  V2NIMMessageCallDuration,
} from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMMessageService'

const TAG_NAME = 'MessageCreatorService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

class MessageCreatorService {
  msgMap: Map<string, V2NIMMessage> = new Map()

  constructor(private rootService: RootService, private nim: V2NIM) {}

  destroy(): void {
    this.msgMap.clear()
  }

  @loggerDec
  async createTextMessage(params: {
    text: string
  }): Promise<NIMResult<V2NIMMessage>> {
    try {
      const msg = this.nim.V2NIMMessageCreator.createTextMessage(params.text)
      this.msgMap.set(msg.messageClientId, msg)
      return successRes(msg)
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async createImageMessage(params: {
    imageObj: File | string
    name?: string
    sceneName?: string
    width: number
    height: number
  }): Promise<NIMResult<V2NIMMessage>> {
    try {
      const msg = this.nim.V2NIMMessageCreator.createImageMessage(
        params.imageObj,
        params.name,
        params.sceneName,
        params.width,
        params.height
      )
      this.msgMap.set(msg.messageClientId, msg)
      return successRes(msg)
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async createAudioMessage(params: {
    audioObj: File | string
    name?: string
    sceneName?: string
    duration: number
  }): Promise<NIMResult<V2NIMMessage>> {
    try {
      const msg = this.nim.V2NIMMessageCreator.createAudioMessage(
        params.audioObj,
        params.name,
        params.sceneName,
        params.duration
      )
      this.msgMap.set(msg.messageClientId, msg)
      return successRes(msg)
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async createVideoMessage(params: {
    videoObj: File | string
    name?: string
    sceneName?: string
    duration: number
    width: number
    height: number
  }): Promise<NIMResult<V2NIMMessage>> {
    try {
      const msg = this.nim.V2NIMMessageCreator.createVideoMessage(
        params.videoObj,
        params.name,
        params.sceneName,
        params.duration,
        params.width,
        params.height
      )
      this.msgMap.set(msg.messageClientId, msg)
      return successRes(msg)
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async createFileMessage(params: {
    fileObj: File | string
    name?: string
    sceneName?: string
  }): Promise<NIMResult<V2NIMMessage>> {
    try {
      const msg = this.nim.V2NIMMessageCreator.createFileMessage(
        params.fileObj,
        params.name,
        params.sceneName
      )
      this.msgMap.set(msg.messageClientId, msg)
      return successRes(msg)
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async createLocationMessage(params: {
    latitude: number
    longitude: number
    address: string
  }): Promise<NIMResult<V2NIMMessage>> {
    try {
      const msg = this.nim.V2NIMMessageCreator.createLocationMessage(
        params.latitude,
        params.longitude,
        params.address
      )
      this.msgMap.set(msg.messageClientId, msg)
      return successRes(msg)
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async createCustomMessage(params: {
    text: string
    rawAttachment: string
  }): Promise<NIMResult<V2NIMMessage>> {
    try {
      const msg = this.nim.V2NIMMessageCreator.createCustomMessage(
        params.text,
        params.rawAttachment
      )
      this.msgMap.set(msg.messageClientId, msg)
      return successRes(msg)
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async createTipsMessage(params: {
    text: string
  }): Promise<NIMResult<V2NIMMessage>> {
    try {
      const msg = this.nim.V2NIMMessageCreator.createTipsMessage(params.text)
      this.msgMap.set(msg.messageClientId, msg)
      return successRes(msg)
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async createForwardMessage(params: {
    message: V2NIMMessage
  }): Promise<NIMResult<V2NIMMessage>> {
    const res = this.nim.V2NIMMessageCreator.createForwardMessage(
      params.message
    )
    if (res) {
      this.msgMap.set(res.messageClientId, res)
      return successRes(res)
    }
    throw failRes({
      code: 1,
      message: 'createForwardMessage failed',
      desc: 'createForwardMessage failed',
      detail: {},
      name: '',
    })
  }

  @loggerDec
  async createCallMessage(params: {
    type: number
    channelId: string
    status: number
    durations: V2NIMMessageCallDuration[]
    text: string
  }): Promise<NIMResult<V2NIMMessage>> {
    try {
      const msg = this.nim.V2NIMMessageCreator.createCallMessage(
        params.type,
        params.channelId,
        params.status,
        params.durations,
        params.text
      )
      this.msgMap.set(msg.messageClientId, msg)
      return successRes(msg)
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }
}

export default MessageCreatorService
