import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from 'yunxin-log-debug'

const TAG_NAME = 'AudioRecorderService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

class AudioRecorderService {
  constructor(private rootService: RootService, private nim: any) {}

  startAudioRecord() {
    throw Error('not implemented.')
  }

  stopAudioRecord() {
    throw Error('not implemented.')
  }

  cancelAudioRecord() {
    throw Error('not implemented.')
  }

  isAudioRecording() {
    throw Error('not implemented.')
  }

  getAmplitude() {
    throw Error('not implemented.')
  }
}

export default AudioRecorderService
