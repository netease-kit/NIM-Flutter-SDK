export type ServiceName =
  | 'InitializeService'
    | 'LoginService'
    | 'MessageService'
    | 'SettingsService'
    | 'UserService'
    | 'FriendService'
    | 'TeamService'
    | 'ConversationService'
    | 'StorageService'
    | 'MessageCreatorService'
    | 'NotificationService'
    | 'ConversationUtil'
    | 'SubscriptionService'
    | 'AIService'
    | 'SignallingService'

export interface NIMResult<T> {
  code: number
  data?: T
  errorDetails?: string
  errorMsg?: any
}
