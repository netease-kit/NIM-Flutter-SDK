import { V2NIMError } from '@nimsdk/base'
import { NIMResult } from './types'


export const successRes = <T>(data?: T): NIMResult<T> => {
  return {
    code: 0,
    data,
  }
}

export const failRes = (error: V2NIMError): NIMResult<never> => {
  return {
    code: error.code ?? -1,
    errorDetails: error.desc + '' || '',
    errorMsg: error.toString ? error.toString() : error,
  }
}
