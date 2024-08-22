import { logDebug } from '@xkit-yx/utils'
import packageJson from '../package.json'

export const logger = logDebug({
  level: 'debug',
  version: packageJson.version,
  appName: packageJson.name,
})
