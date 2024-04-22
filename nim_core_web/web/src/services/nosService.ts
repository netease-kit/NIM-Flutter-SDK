import RootService from './rootService'
import { successRes, failRes } from '../utils'
import { downloadFile, emit } from '../utils'
import { NIMResult } from '../types'
import { logger } from '../logger'
import { createLoggerDecorator } from 'yunxin-log-debug'

const TAG_NAME = 'NosService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

export interface NIMNOSTransferStatus {
  transferType?: 'upload' | 'download'
  path?: string
  md5?: string
  url?: string
  size?: number
  status?: 'def' | 'transferring' | 'transferred' | 'fail'
  extension?: string
}

class NosService {
  constructor(private rootService: RootService, private nim: any) {}

  // filePath web 不支持，当做 base64 使用
  @loggerDec
  upload(params: {
    filePath: string
    mimeType?: string
    sceneKey?: string
  }): Promise<NIMResult<string>> {
    return new Promise((resolve, reject) => {
      emit<NIMNOSTransferStatus>('NOSService', 'onNOSTransferStatus', {
        transferType: 'upload',
        path: params.filePath,
        status: 'def',
      })
      this.nim.previewFile({
        type: params.mimeType,
        dataURL: params.filePath,
        uploadprogress: (obj: any) => {
          emit<{ progress: number }>('NOSService', 'onNOSTransferProgress', {
            progress: obj.percentage,
          })
          emit<NIMNOSTransferStatus>('NOSService', 'onNOSTransferStatus', {
            transferType: 'upload',
            path: params.filePath,
            size: obj.loaded,
            status: 'transferring',
          })
        },
        done: (err: any, file: File & { url: string }) => {
          if (err) {
            emit<NIMNOSTransferStatus>('NOSService', 'onNOSTransferStatus', {
              transferType: 'upload',
              path: params.filePath,
              size: file.size,
              status: 'fail',
            })
            return reject(failRes(err))
          }
          emit<NIMNOSTransferStatus>('NOSService', 'onNOSTransferStatus', {
            transferType: 'upload',
            path: params.filePath,
            size: file.size,
            url: file.url,
            status: 'transferred',
          })
          resolve(successRes(file.url))
        },
      })
    })
  }

  // 第二个参数为 fileName
  @loggerDec
  download(params: { url: string; path?: string }): Promise<NIMResult<void>> {
    downloadFile(params.url, params.path || params.url.slice(-8))
    return Promise.resolve(successRes())
  }
}

export default NosService
