import { successRes, failRes, emit } from '../utils'
import { NIMResult } from '../types'
import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from '@xkit-yx/utils'
import V2NIM from 'nim-web-sdk-ng'
import { V2NIMError } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/types'
import {
  V2NIMGetMediaResourceInfoResult,
  V2NIMSize,
  V2NIMStorageScene,
  V2NIMUploadFileParams,
  V2NIMUploadFileTask,
} from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMStorageService'
import { NOT_IMPLEMENTED_ERROR } from 'src/constants'

const TAG_NAME = 'StorageService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

class StorageService {
  constructor(private rootService: RootService, private nim: V2NIM) {}

  destroy(): void {
    //
  }

  @loggerDec
  async addCustomStorageScene(params: {
    sceneName: string
    expireTime: number
  }): Promise<NIMResult<V2NIMStorageScene>> {
    try {
      return successRes(
        this.nim.V2NIMStorageService.addCustomStorageScene(
          params.sceneName,
          params.expireTime
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async cancelUploadFile(params: {
    fileTask: V2NIMUploadFileTask
  }): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMStorageService.cancelUploadFile(params.fileTask)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async createUploadFileTask(params: {
    fileParams: V2NIMUploadFileParams
    fileObj: File
  }): Promise<NIMResult<V2NIMUploadFileTask>> {
    try {
      return successRes(
        this.nim.V2NIMStorageService.createUploadFileTask({
          ...params.fileParams,
          fileObj: params.fileObj,
        })
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async downloadAttachment(): Promise<NIMResult<string>> {
    throw NOT_IMPLEMENTED_ERROR
  }

  @loggerDec
  async downloadFile(): Promise<NIMResult<string>> {
    throw NOT_IMPLEMENTED_ERROR
  }

  @loggerDec
  async getImageThumbUrl(params: {
    attachment: any
    thumbSize: V2NIMSize
  }): Promise<NIMResult<V2NIMGetMediaResourceInfoResult>> {
    try {
      return successRes(
        await this.nim.V2NIMStorageService.getImageThumbUrl(
          params.attachment,
          params.thumbSize
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getStorageSceneList(): Promise<
    NIMResult<{ sceneList: V2NIMStorageScene[] }>
  > {
    try {
      return successRes({
        sceneList: this.nim.V2NIMStorageService.getStorageSceneList(),
      })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getVideoCoverUrl(parmas: {
    attachment: any
    thumbSize: V2NIMSize
  }): Promise<NIMResult<V2NIMGetMediaResourceInfoResult>> {
    try {
      return successRes(
        await this.nim.V2NIMStorageService.getVideoCoverUrl(
          parmas.attachment,
          parmas.thumbSize
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async shortUrlToLong(params: { url: string }): Promise<NIMResult<string>> {
    try {
      return successRes(
        await this.nim.V2NIMStorageService.shortUrlToLong(params.url)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async uploadFile(params: {
    fileTask: V2NIMUploadFileTask
    fileObj: File
  }): Promise<NIMResult<string>> {
    try {
      return successRes(
        await this.nim.V2NIMStorageService.uploadFile(
          {
            ...params.fileTask,
            uploadParams: {
              ...params.fileTask.uploadParams,
              fileObj: params.fileObj,
            },
          },
          (progress: number) => {
            emit('StorageService', 'onFileUploadProgress', {
              taskId: params.fileTask.taskId,
              progress,
            })
          }
        )
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async imageThumbUrl(params: {
    url: string
    thumbSize: number
  }): Promise<NIMResult<string>> {
    throw NOT_IMPLEMENTED_ERROR
  }

  @loggerDec
  async videoCoverUrl(params: {
    url: string
    offset: number
  }): Promise<NIMResult<string>> {
    throw NOT_IMPLEMENTED_ERROR
  }
}

export default StorageService
