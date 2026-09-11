/*
 *
 *  * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 *  * Use of this source code is governed by a MIT license that can be
 *  * found in the LICENSE file.
 *
 *
 */
import { HashMap } from '@kit.ArkTS';
import { NIMInterface } from '@nimsdk/base';
import { Any, Log, MethodCall, MethodChannel, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from './FLTService';
import { FLTLoginService } from './services/FLTLoginService';
import { common } from '@kit.AbilityKit';
import { FLTInitializeService } from './services/FLTInitializeService';
import { FLTUserService } from './services/FLTUserService';
import { FLTFriendService } from './services/FLTFriendService';
import { FLTTeamService } from './services/FLTTeamService';
import { FLTConversationService } from './services/FLTConversationService';
import { FLTLocalConversationService } from './services/FLTLocalConversationService';
import { FLTSettingService } from './services/FLTSettingService';
import { FLTNotificationService } from './services/FLTNotificationService';
import { FLTSubscriptionService } from './services/FLTSubscriptionService';
import { FLTMessageService } from './services/FLTMessageService';
import { FLTChatroomClientService } from './services/FLTChatroomClientService';
import { FLTChatroomMessageCreatorService } from './services/FLTChatroomMessageCreatorService';
import { FLTChatroomQueueService } from './services/FLTChatroomQueueService';
import { FLTChatroomService } from './services/FLTChatroomService';
import { FLTMessageCreatorService } from './services/FLTMessageCreatorService';
import { FLTConversationIdUtil } from './services/FLTConversationIdUtil';
import { FLTAIService } from './services/FLTAIService';
import { FLTSignallingService } from './services/FLTSignallingService';
import { FLTStorageService } from './services/FLTStorageService';
import { FLTConversationGroupService } from './services/FLTConversationGroupService';
import { FLTPushService } from './services/FLTPushService';

// 定义一个单例类
export class NimCore {
  // 类的方法
  private static instance: NimCore
  private serviceNameTag: string = "serviceName";
  private servicesMap: HashMap<string, FLTService> = new HashMap();
  private nim: NIMInterface | undefined;
  private applicationContext: common.Context | undefined;
  private initService: FLTInitializeService | undefined;
  private methodChannel: MethodChannel | undefined = undefined;

  // 私有构造函数，防止外部实例化
  private constructor() {
    // 初始化操作
    this.init();
  }

  public get context(): common.Context {
    return this.applicationContext!!;
  }

  public get channel(): MethodChannel | undefined {
    return this.methodChannel
  }

  public get nimInterface(): NIMInterface {
    return this.nim!!
  }

  public set nimInterface(nim: NIMInterface) {
    this.nim = nim;
  }

  // 静态方法，提供全局访问点
  public static getInstance(): NimCore {
    if (!NimCore.instance) {
      NimCore.instance = new NimCore();
    }
    return NimCore.instance;
  }

  public initContext(context: common.Context, channel: MethodChannel): void {
    this.applicationContext = context
    this.methodChannel = channel
  }

  public clear(): void {
    this.servicesMap.clear()
  }

  public onInitialized() {
    for (let service of this.servicesMap.values()) {
      service.onInitialized()
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    Log.d('NimCoreV2Plugin', 'MethodChannelImpl onMethodCall step in');
    if (!call.hasArgument(this.serviceNameTag)) {
      result.notImplemented
      return
    }
    let serviceName = call.argument(this.serviceNameTag) as string
    let fltService = this.servicesMap.get(serviceName) as FLTService
    let argsMap: Map<string, Any> = new Map<string, Any>()
    if ((this.initService && this.initService.hasInitialize) ||
      fltService instanceof FLTInitializeService) {
      if (call.args instanceof Map) {
        argsMap = call.args as Map<string, Any>
      }
      if (fltService) {
        fltService.onMethodCall(call.method, argsMap, result)
      } else {
        result.notImplemented()
      }
    } else {
      let map = new Map<string, Object>();
      map.set("code", -1);
      map.set("errorDetails", "SDK Uninitialized")
      result.success(map);
    }

  }

  // 初始化方法
  private init(): void {
    // 可以在这里进行一些初始化操作
    console.log('NimCore initialized');
    this.registerService(new FLTLoginService())
    this.registerService(new FLTInitializeService())
    this.registerService(new FLTUserService())
    this.registerService(new FLTFriendService())
    this.registerService(new FLTTeamService())
    this.registerService(new FLTConversationIdUtil())
    this.registerService(new FLTConversationService())
    this.registerService(new FLTLocalConversationService())
    this.registerService(new FLTSettingService())
    this.registerService(new FLTNotificationService())
    this.registerService(new FLTSubscriptionService())
    this.registerService(new FLTMessageCreatorService())
    this.registerService(new FLTMessageService())
    this.registerService(new FLTChatroomClientService())
    this.registerService(new FLTChatroomMessageCreatorService())
    this.registerService(new FLTChatroomQueueService())
    this.registerService(new FLTChatroomService())
    this.registerService(new FLTAIService())
    this.registerService(new FLTSignallingService())
    this.registerService(new FLTStorageService())
    this.registerService(new FLTConversationGroupService())
    this.registerService(new FLTPushService())
  }

  private registerService(clazz: FLTService): void {
    this.servicesMap.set(clazz.serviceName, clazz);
    if (clazz instanceof FLTInitializeService) {
      this.initService = clazz
    }
  }
}
