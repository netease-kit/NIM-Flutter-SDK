import { NIMResult } from './types'

export const NOT_IMPLEMENTED_ERROR: NIMResult<never> = {
  code: -1,
  errorDetails: 'Not Implemented',
}

export const YX_EMIT_RESULT = '__yx_result__'

export const defaultDelay = 500
