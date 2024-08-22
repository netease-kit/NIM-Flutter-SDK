import InitializeService from './initializeService'
import LoginService from './loginService'
import SettingsService from './settingsService'
import MessageService from './messageService'
import UserService from './userService'
import FriendService from './friendService'
import TeamService from './teamService'
import ConversationService from './conversationService'
import StorageService from './storageService'
import MessageCreatorService from './messageCreatorService'
import NotificationService from './notificationService'
import ConversationUtil from './conversationUtil'
import AIService from './aiService'
import V2NIM from 'nim-web-sdk-ng'

class RootService {
  private initializeService: InitializeService
  private loginService?: LoginService
  private settingsService?: SettingsService
  private messageService?: MessageService
  private userService?: UserService
  private friendService?: FriendService
  private teamService?: TeamService
  private conversationService?: ConversationService
  private storageService?: StorageService
  private messageCreatorService?: MessageCreatorService
  private notificationService?: NotificationService
  private conversationUtil?: ConversationUtil
  private aiService?: AIService

  private nim: V2NIM = {} as V2NIM

  constructor() {
    this.initializeService = new InitializeService(this, this.nim)
  }

  public init() {
    this.loginService = new LoginService(this, this.nim)
    this.settingsService = new SettingsService(this, this.nim)
    this.messageService = new MessageService(this, this.nim)
    this.userService = new UserService(this, this.nim)
    this.friendService = new FriendService(this, this.nim)
    this.teamService = new TeamService(this, this.nim)
    this.conversationService = new ConversationService(this, this.nim)
    this.storageService = new StorageService(this, this.nim)
    this.messageCreatorService = new MessageCreatorService(this, this.nim)
    this.notificationService = new NotificationService(this, this.nim)
    this.conversationUtil = new ConversationUtil(this, this.nim)
    this.aiService = new AIService(this, this.nim)
  }

  public destroy() {
    this.initializeService.destroy()
    this.loginService?.destroy()
    this.settingsService?.destroy()
    this.messageService?.destroy()
    this.userService?.destroy()
    this.friendService?.destroy()
    this.teamService?.destroy()
    this.conversationService?.destroy()
    this.storageService?.destroy()
    this.messageCreatorService?.destroy()
    this.notificationService?.destroy()
    this.conversationUtil?.destroy()
    this.aiService?.destroy()
  }

  get InitializeService() {
    return this.initializeService
  }

  get LoginService() {
    return this.loginService
  }

  get SettingsService() {
    return this.settingsService
  }

  get MessageService() {
    return this.messageService
  }

  get UserService() {
    return this.userService
  }

  get FriendService() {
    return this.friendService
  }

  get TeamService() {
    return this.teamService
  }

  get ConversationService() {
    return this.conversationService
  }

  get StorageService() {
    return this.storageService
  }

  get MessageCreatorService() {
    return this.messageCreatorService
  }

  get NotificationService() {
    return this.notificationService
  }

  get ConversationIdUtil() {
    return this.conversationUtil
  }

  get AIService() {
    return this.aiService
  }
}

export default RootService
