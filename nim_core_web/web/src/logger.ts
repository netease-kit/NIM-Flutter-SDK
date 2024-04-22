import logDebug from 'yunxin-log-debug'
import packageJson from '../package.json'

export const logger = logDebug({
  level: 'debug',
  version: packageJson.version,
  appName: packageJson.name,
})
