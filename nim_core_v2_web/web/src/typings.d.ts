declare module '*.json'

declare global {
  interface Window {
    __yx_emit__: <T>(
      serviceName: ServiceName,
      methodName: string,
      params: T
    ) => any

    s3: any
  }
}

export {}
