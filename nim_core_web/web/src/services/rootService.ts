import EventSubscribeService from './eventSubscribeService'
import NosService from './nosService'
import InitializeService from './initializeService'
import AuthService from './authService'
import AudioRecorderService from './audioRecorderService'
import PassThroughService from './passThroughService'
import SettingsService from './settingsService'
import MessageService from './messageService'
import SystemMessageService from './systemMessageService'
import UserService from './userService'

class RootService {
  private eventSubscribeService: EventSubscribeService
  private nosService: NosService
  private initializeService: InitializeService
  private authService: AuthService
  private audioRecorderService: AudioRecorderService
  private passThroughService: PassThroughService
  private settingsService: SettingsService
  private messageService: MessageService
  private systemMessageService: SystemMessageService
  private userService: UserService

  private nim: any = {}

  constructor() {
    this.eventSubscribeService = new EventSubscribeService(this, this.nim)
    this.nosService = new NosService(this, this.nim)
    this.initializeService = new InitializeService(this, this.nim)
    this.authService = new AuthService(this, this.nim)
    this.audioRecorderService = new AudioRecorderService(this, this.nim)
    this.passThroughService = new PassThroughService(this, this.nim)
    this.settingsService = new SettingsService(this, this.nim)
    this.messageService = new MessageService(this, this.nim)
    this.systemMessageService = new SystemMessageService(this, this.nim)
    this.userService = new UserService(this, this.nim)
  }

  get InitializeService() {
    return this.initializeService
  }

  get AuthService() {
    return this.authService
  }

  get EventSubscribeService() {
    return this.eventSubscribeService
  }

  get NOSService() {
    return this.nosService
  }

  get AudioRecorderService() {
    return this.audioRecorderService
  }

  get PassThroughService() {
    return this.passThroughService
  }

  get SettingsService() {
    return this.settingsService
  }

  get MessageService() {
    return this.messageService
  }

  get SystemMessageService() {
    return this.systemMessageService
  }

  get UserService() {
    return this.userService
  }
}

export default RootService
