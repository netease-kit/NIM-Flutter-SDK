import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from 'yunxin-log-debug'
import { NIMResult } from '../types'
import { failRes, successRes } from '../utils'

const TAG_NAME = 'PassThroughService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

export interface NIMPassThroughProxyData {
  /// 映射一个视频云upstream host，不传用默认配置
  zone?: string

  /// url中除了host的path
  path?: string

  /// 选填，数字常量(1-get, 2-post, 3-put, 4-delete)，默认post，
  ///[PassThroughMethod]
  method: number

  /// json格式
  header?: string

  /// 格式自定，透传， post时，body不能为空
  body?: string
}

class PassThroughService {
  constructor(private rootService: RootService, private nim: any) {}

  @loggerDec
  httpProxy(params: {
    passThroughProxyData: NIMPassThroughProxyData
  }): Promise<NIMResult<NIMPassThroughProxyData>> {
    const passThroughProxyData = params.passThroughProxyData
    return new Promise((resovle, reject) => {
      this.nim.httpRequestProxy({
        ...passThroughProxyData,
        method: String(passThroughProxyData.method),
        done: (err: any, obj: any) => {
          if (err) {
            return reject(failRes(err))
          }
          resovle(successRes(passThroughProxyData))
        },
      })
    })
  }
}

export default PassThroughService
