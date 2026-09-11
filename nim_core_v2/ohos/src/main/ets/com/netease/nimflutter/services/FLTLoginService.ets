/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */
import {
  V2NIMConnectStatus,
  V2NIMDataSyncLevelValues,
  V2NIMDataSyncState,
  V2NIMDataSyncType,
  V2NIMError,
  V2NIMKickedOfflineDetail,
  V2NIMLoginAuthTypeValues,
  V2NIMLoginClient,
  V2NIMLoginClientChange,
  V2NIMLoginExtensionProvider,
  V2NIMLoginOption,
  V2NIMLoginStatus,
  V2NIMReconnectDelayProvider,
  V2NIMRouteConfig,
  V2NIMTokenProvider
} from '@nimsdk/base';
import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';
import { fromJsonLoginClient } from '../model/login/LoginExtension';

export class FLTLoginService extends FLTService {
  get serviceName(): string {
    return "LoginService";
  }

  onInitialized(): void {
    Log.d(this.serviceName, "onInitialized")
    this.nim.loginService.on("onAccountReady", (account: string) => {
      Log.d(this.serviceName, "onAccountReady:" + account)
      this.notifyEvent("onAccountReady", new Map<string, Any>().set("accountId", account))
    })
    this.nim.loginService.on("onLoginStatus", (status: V2NIMLoginStatus) => {
      Log.d(this.serviceName, "onLoginStatus:" + status.toString())
      this.notifyEvent("onLoginStatus", new Map<string, Any>().set("status", status.valueOf()))
    })
    this.nim.loginService.on("onLoginFailed", (error: V2NIMError) => {
      Log.d(this.serviceName, "onLoginStatus:" + error.desc)
      this.notifyEvent("onLoginFailed", this.nimErrorMap(error))
    })
    this.nim.loginService.on("onKickedOffline", (detail: V2NIMKickedOfflineDetail) => {
      this.notifyEvent("onKickedOffline", new Map<string, Any>(Object.entries(detail)))
    })
    this.nim.loginService.on("onLoginClientChanged", (change: V2NIMLoginClientChange, clients: V2NIMLoginClient[]) => {
      let resultData: Map<string, Any> = new Map<string, Any>();
      resultData.set("change", change.valueOf());
      resultData.set("clients", clients?.map(client => new Map(Object.entries(client))))
      this.notifyEvent("onLoginClientChanged", resultData)
    })
    this.nim.loginService.on("onConnectStatus", (status: V2NIMConnectStatus) => {
      Log.d(this.serviceName, "onConnectStatus:" + status.toString())
      this.notifyEvent("onConnectStatus", new Map<string, Any>().set("status", status.valueOf()))
    })
    this.nim.loginService.on("onDisconnected", (error: V2NIMError) => {
      Log.d(this.serviceName, "onDisconnected:" + error.desc)
      this.notifyEvent("onDisconnected", this.nimErrorMap(error))
    })
    this.nim.loginService.on("onConnectFailed", (error: V2NIMError) => {
      Log.d(this.serviceName, "onConnectFailed:" + error.desc)
      this.notifyEvent("onConnectFailed", this.nimErrorMap(error))
    })
    this.nim.loginService.on("onDataSync", (
      type: V2NIMDataSyncType,
      state: V2NIMDataSyncState,
      error?: V2NIMError) => {
      Log.d(this.serviceName, "onDataSync:" + type.toString())
      let resultData: Map<string, Any> = new Map<string, Any>();
      resultData.set("type", type.valueOf());
      resultData.set("state", state.valueOf())
      if (error) {
        resultData.set("error", this.nimErrorMap(error))
      }
      this.notifyEvent("onDataSync", resultData)
    })
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    if (method === "login") {
      this.login(args, result);
    } else if (method === "logout") {
      this.logout(args, result);
    } else if (method === "getLoginUser") {
      this.getLoginUser(args, result);
    } else if (method === "getLoginStatus") {
      this.getLoginStatus(args, result);
    } else if (method === "getLoginClients") {
      this.getLoginClients(args, result);
    } else if (method === "kickOffline") {
      this.kickOffline(args, result);
    } else if (method === "getKickedOfflineDetail") {
      this.getKickedOfflineDetail(args, result);
    } else if (method === "getConnectStatus") {
      this.getConnectStatus(args, result);
    } else if (method === "getDataSync") {
      this.getDataSync(args, result);
    } else if (method === "getChatroomLinkAddress") {
      this.getChatroomLinkAddress(args, result);
    } else if (method === "setReconnectDelayProvider") {
      this.setReconnectDelayProvider(args, result);
    } else if (method === "getCurrentLoginClient") {
      this.getCurrentLoginClient(args, result);
    } else {
      // 处理未匹配的方法
      result.notImplemented();
    }
  }

  private login(args: Map<string, Any>, result: MethodResult): void {
    Log.d(this.serviceName, "login")
    // 提取并验证必要参数
    const account = this.getMapValue(args, "accountId", "");
    const token = this.getMapValue(args, "token", "");

    // 验证账号和令牌
    if (!account || !token) {
      return this.onErrorWithCode(result, 199414, "accountId or token is empty");
    }

    // 获取登录选项配置
    let loginOptionMap: Map<string, Any> =
      args.has("option") ? args.get("option") as Map<string, Any> : new Map<string, Any>()

    // 构建登录选项
    let loginOption: V2NIMLoginOption = this.buildLoginOption(loginOptionMap);

    this.nim.loginService?.login(account, token, loginOption).then((value: void) => {
      this.onSuccess(result, value)
    }).catch((e: V2NIMError) => this.onError(result, e))
  }

  private logout(args: Map<string, Any>, result: MethodResult): void {
    Log.d(this.serviceName, "logout")
    this.nim.loginService?.logout()
    this.onSuccess(result)
  }

  private getLoginUser(args: Map<string, Any>, result: MethodResult): void {
    Log.d(this.serviceName, "getLoginUser")
    let user = this.nim.loginService?.getLoginUser()
    this.onSuccess(result, user)
  }

  private getLoginStatus(args: Map<string, Any>, result: MethodResult): void {
    Log.d(this.serviceName, "getLoginStatus")
    let userStatus = this.nim.loginService?.getLoginStatus()
    this.onSuccess(result, {
      "status": userStatus.valueOf()
    })
  }

  private getLoginClients(args: Map<string, Any>, result: MethodResult): void {
    Log.d(this.serviceName, "getLoginClients")
    let clients: V2NIMLoginClient[] = this.nim.loginService?.getLoginClients()
    let clientsArray: Any[] = clients.map(client => new Map(Object.entries(client)))
    this.onSuccess(result, new Map<string, Any>().set("loginClient", clientsArray))
  }

  private getCurrentLoginClient(args: Map<string, Any>, result: MethodResult): void {
    Log.d(this.serviceName, "getCurrentLoginClient")
    let client = this.nim.loginService?.getCurrentLoginClient()
    this.onSuccess(result,
      client != null ? new Map<string, Any>(Object.entries(client as V2NIMLoginClient)) : null
    )
  }

  private kickOffline(args: Map<string, Any>, result: MethodResult): void {
    Log.d(this.serviceName, "kickOffline")
    let client: V2NIMLoginClient = fromJsonLoginClient(args.get("client") as Map<string, Any>);
    this.nim.loginService?.kickOffline(client).then((value: void) => {
      this.onSuccess(result)
    }).catch((e: V2NIMError) => this.onError(result, e))
  }

  private getKickedOfflineDetail(args: Map<string, Any>, result: MethodResult): void {
    Log.d(this.serviceName, "getKickedOfflineDetail")
    let detail = this.nim.loginService?.getKickedOfflineDetail();
    if (detail === null) {
      this.onSuccess(result)
    } else {
      this.onSuccess(result, new Map<string, Any>(Object.entries(detail)))
    }
  }

  private getConnectStatus(args: Map<string, Any>, result: MethodResult): void {
    Log.d(this.serviceName, "getConnectStatus")
    let clients = this.nim.loginService?.getConnectStatus()
    this.onSuccess(result, {
      "status": clients.valueOf()
    })
  }

  private getDataSync(args: Map<string, Any>, result: MethodResult): void {
    Log.d(this.serviceName, "getDataSync")
    let clients = this.nim.loginService?.getDataSync()
    let syncClients:Any[] = []
    if (clients != null) {
      syncClients = clients?.map(client => new Map(Object.entries(client)))
    }
    this.onSuccess(result, new Map<string, Any>().set("dataSync", syncClients))
  }

  private getChatroomLinkAddress(args: Map<string, Any>, result: MethodResult): void {
    Log.d(this.serviceName, "getChatroomLinkAddress")
    const roomId = this.getMapValue(args, "roomId", "");
    this.nim.loginService?.getChatroomLinkAddress(roomId).then((value: string[]) => {
      this.onSuccess(result, new Map<string, Any>().set("linkAddress", value))
    }).catch((e: V2NIMError) => this.onError(result, e))
  }

  private setReconnectDelayProvider(args: Map<string, Any>, result: MethodResult): void {
    Log.d(this.serviceName, "setReconnectDelayProvider")
    this.nim.loginService?.setReconnectDelayProvider(this.delayProvider)
    this.onSuccess(result);
  }

  //todo
  private delayProvider: V2NIMReconnectDelayProvider = (delay: number): number => {
    // let data = await this.notifyEventPromise<number>("getReconnectDelay", new Map<string, Any>().set("delay", delay));
    return 1000;
  }
  private loginExtProvider: V2NIMLoginExtensionProvider = (accountId: string): Promise<string> | string => {
    Log.d(this.serviceName, "getLoginExtension")
    return this.notifyEventPromise<string>("getLoginExtension", new Map<string, Any>().set("accountId", accountId))
  };
  private loginTokenProvider: V2NIMTokenProvider = (accountId: string): Promise<string> | string => {
    Log.d(this.serviceName, "getToken")
    return this.notifyEventPromise<string>("getToken", new Map<string, Any>().set("accountId", accountId))
  };

  /**
   * 从Map中获取值的工具方法
   * @param map 数据源Map
   * @param key 键名
   * @param defaultValue 默认值
   * @returns 获取到的值或默认值
   */
  private getMapValue<T>(map: Map<string, Any>, key: string, defaultValue: T): T {
    if (map.has(key)) {
      let value = map.get(key) as object;
      if (value != null) {
        return value as T;
      }
    }
    return defaultValue;
  }

  /**
   * 构建登录选项对象
   * @param optionMap 包含登录选项的Map
   * @returns 构建好的V2NIMLoginOption对象
   */
  private buildLoginOption(optionMap: Map<string, Any>): V2NIMLoginOption {
    // 处理基础参数
    const hasExtensionProvider = this.getMapValue(optionMap, "extensionProvider", false);
    const hasTokenProvider = this.getMapValue(optionMap, "tokenProvider", false);

    // 处理路由配置
    const routeConfig = this.buildRouteConfig(optionMap);
    // 处理枚举类型参数（先转为数字再映射为枚举值）
    const authTypeNum = this.getMapValue(optionMap, "authType", undefined) as number | undefined;
    const authType = authTypeNum !== undefined ? V2NIMLoginAuthTypeValues[authTypeNum] : undefined;

    const syncLevelNum = this.getMapValue(optionMap, "syncLevel", undefined) as number | undefined;
    const syncLevel = syncLevelNum !== undefined ? V2NIMDataSyncLevelValues[syncLevelNum] : undefined;
    return {
      loginExtensionProvider: hasExtensionProvider ? this.loginExtProvider : undefined,
      tokenProvider: hasTokenProvider ? this.loginTokenProvider : undefined,
      retryCount: this.getMapValue(optionMap, "retryCount", undefined),
      forceMode: this.getMapValue(optionMap, "forceMode", undefined),
      timeout: this.getMapValue(optionMap, "timeout", undefined),
      authType: authType,
      syncLevel: syncLevel,
      routeConfig: routeConfig
    };
  }

  /**
   * 构建路由配置对象
   * @param optionMap 包含登录选项的Map
   * @returns 构建好的V2NIMRouteConfig对象或undefined
   */
  private buildRouteConfig(optionMap: Map<string, Any>): V2NIMRouteConfig | undefined {
    const routeConfigRaw = optionMap.get("routeConfig") as V2NIMRouteConfig;

    if (!routeConfigRaw || typeof routeConfigRaw !== 'object') {
      return undefined;
    }

    return {
      routeEnabled: routeConfigRaw.routeEnabled as boolean | undefined,
      routeEnvironment: routeConfigRaw.routeEnvironment as string | undefined
    };
  }
}
