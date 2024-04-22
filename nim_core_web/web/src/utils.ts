import { logger } from './logger'
import { NIMResult, ServiceName } from './types'

export const successRes = <T>(data?: T): NIMResult<T> => {
  return {
    code: 0,
    data,
  }
}

export const failRes = (error: any): NIMResult<never> => {
  return {
    code: error.code ?? -1,
    errorDetails: error.message ?? error,
  }
}

export function addUrlSearch(url: string, search: string) {
  const urlObj = new URL(url)
  urlObj.search += (urlObj.search.startsWith('?') ? '&' : '?') + search
  return urlObj.href
}

export function downloadFile(url: string, filename: string) {
  const eleLink = document.createElement('a')
  eleLink.download = filename
  eleLink.style.display = 'none'
  eleLink.href = addUrlSearch(url, filename)
  eleLink.target = '_blank'
  document.body.appendChild(eleLink)
  eleLink.click()
  setTimeout(function () {
    document.body.removeChild(eleLink)
  }, 0)
}

export const emit = <T>(
  serviceName: ServiceName,
  methodName: string,
  params: T
) => {
  logger.log('emit: ', { serviceName, methodName, params })
  if (!window.__yx_emit__) {
    window.__yx_emit__ = (serviceName, methodName, params) => {
      return { serviceName, methodName, params }
    }
  }
  return window.__yx_emit__(serviceName, methodName, params)
}
