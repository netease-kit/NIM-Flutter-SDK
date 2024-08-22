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
  | 'AIService'

export interface NIMResult<T> {
  code: number
  data?: T
  errorDetails?: string
  errorMsg?: any
}
