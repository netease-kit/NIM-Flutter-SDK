/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';
import { NimCore } from '../NimCore';
import {
  V2NIMChatroomClient,
  V2NIMChatroomEnterParams,
  V2NIMChatroomInitParams,
  V2NIMChatroomKickedInfo,
  V2NIMChatroomLocationConfig,
  V2NIMChatroomStatus,
  V2NIMLocationInfo
} from '@nimsdk/chatroom';
import {
  NIMHttpServiceConfig,
  NIMStorageServiceConfig,
  V2NIMAntispamConfig,
  V2NIMError,
  V2NIMLoginAuthType,
  V2NIMRouteConfig
} from '@nimsdk/base';
import { convertToAntispamConfig, convertToLocationConfig } from '../model/chatroom/ChatroomExtension';

@ObservedV2
export class FLTChatroomClientService extends FLTService {
  private serviceNameTag: string = "V2NIMChatroomClient";
  private initParams: V2NIMChatroomInitParams | undefined;
  private static instanceAccountMap: Map<number, string> = new Map<number, string>();

  get serviceName(): string {
    return this.serviceNameTag;
  }

  static accountId(instanceId: number): string | undefined {
    return FLTChatroomClientService.instanceAccountMap.get(instanceId)
  }

  onInitialized(): void {
    Log.d(this.serviceName, "onInitialized");
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    Log.d(this.serviceName, `onMethodCall: ${method}`);
    if (method === "init") {
      this.init(args, result);
    } else if (method === "uninit") {
      this.uninit(args, result);
    } else if (method === "newInstance") {
      this.newInstance(args, result);
    } else if (method === "getInstance") {
      this.getInstance(args, result);
    } else if (method === "getInstanceList") {
      this.getInstanceList(args, result);
    } else if (method === "enter") {
      this.enter(args, result);
    } else if (method === "exit") {
      this.exit(args, result);
    } else if (method === "getChatroomInfo") {
      this.getChatroomInfo(args, result);
    } else if (method === "addChatroomClientListener") {
      this.addChatroomClientListener(args, result);
    } else if (method === "removeChatroomClientListener") {
      this.removeChatroomClientListener(args, result);
    } else if (method === "destroyInstance") {
      this.destroyInstance(args, result);
    } else if (method === "destroyAll") {
      this.destroyAll(args, result);
    }
  }

  private init(args: Map<string, Any>, result: MethodResult): void {
    try {
      this.initParams = this.initChatroomParams(args)
      this.onSuccess(result);
    } catch (e) {
      this.onError(result, e);
    }
  }

  private uninit(args: Map<string, Any>, result: MethodResult): void {
    try {
      this.initParams = undefined
      this.onSuccess(result);
    } catch (e) {
      this.onError(result, e);
    }
  }

  private newInstance(args: Map<string, Any>, result: MethodResult): void {
    try {
      let initParams = this.initParams
      const chatroomService = V2NIMChatroomClient.newInstance(NimCore.getInstance().context, initParams);
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid V2NIMChatroomClient newInstance");
        return;
      }
      this.onSuccess(result, new Map<string, Any>().set("instanceId", chatroomService.instanceId));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private getInstance(args: Map<string, Any>, result: MethodResult): void {
    try {
      if (args.get("instanceId") === undefined || args.get("instanceId") === null) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }
      const instanceId = args.get("instanceId") as number;
      const chatroomService = V2NIMChatroomClient.getInstance(instanceId);
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      this.onSuccess(result, new Map<string, Any>().set("instanceId", chatroomService.instanceId));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private getInstanceList(args: Map<string, Any>, result: MethodResult): void {
    try {
      const chatroomServiceList = V2NIMChatroomClient.getInstanceList();
      const instanceIds = chatroomServiceList.map(service => service.instanceId);
      this.onSuccess(result, new Map<string, Any>().set("instanceList", instanceIds));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private enter(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId = args.get("instanceId") as number | undefined;
      const roomId = args.get("roomId") as string | undefined;
      const enterParamsMap: Map<string, Any> | undefined = args.get("enterParams") as Map<string, Any> | undefined;
      if (instanceId === undefined || !roomId || !enterParamsMap) {
        this.onErrorWithCode(result, -1, "Invalid enter params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId);
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const enterParams = this.convertToChatroomEnterParams(instanceId, enterParamsMap);

      chatroomService.enter(roomId, enterParams)
        .then((res) => {
          FLTChatroomClientService.instanceAccountMap.set(instanceId, res.selfMember.accountId)
          this.onSuccess(result, new Map<string, Any>(Object.entries(res)))
        })
        .catch((err: Any) => this.onError(result, err));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private exit(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId = args.get("instanceId") as number | undefined;
      if (instanceId === undefined) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }
      FLTChatroomClientService.instanceAccountMap.delete(instanceId)
      const chatroomService = V2NIMChatroomClient.getInstance(instanceId);
      chatroomService?.exit();
      this.onSuccess(result, null);
    } catch (e) {
      this.onError(result, e);
    }
  }

  private getChatroomInfo(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId = args.get("instanceId") as number | undefined;
      if (instanceId === undefined) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId);
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const info = chatroomService.getChatroomInfo();
      this.onSuccess(result, info ? new Map<string, Any>(Object.entries(info)) : null);
    } catch (e) {
      this.onError(result, e);
    }
  }

  private addChatroomClientListener(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId = args.get("instanceId") as number | undefined;
      if (instanceId === undefined) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId);
      chatroomService.on("onChatroomStatus", (status: V2NIMChatroomStatus,
        error?: V2NIMError) => {
        const resultMap: Map<string, Any> = new Map<string, Any>();
        resultMap.set("status", status.valueOf())
        resultMap.set("instanceId", instanceId)
        if (error) {
          resultMap.set("error", new Map(Object.entries(error)))
        }
        this.notifyEvent("onChatroomStatus", resultMap)
      })
      chatroomService.on("onChatroomEntered", () => {
        this.notifyEvent("onChatroomEntered", new Map<string, Any>().set("instanceId", instanceId))
      })
      chatroomService.on("onChatroomExited", (error?: V2NIMError) => {
        const resultMap: Map<string, Any> = new Map<string, Any>();
        resultMap.set("instanceId", instanceId)
        if (error) {
          resultMap.set("error", new Map(Object.entries(error)))
        }
        this.notifyEvent("onChatroomExited", resultMap)
      })
      chatroomService.on("onChatroomKicked", (kickedInfo: V2NIMChatroomKickedInfo) => {
        const resultMap: Map<string, Any> = new Map<string, Any>();
        resultMap.set("instanceId", instanceId)
        resultMap.set("kickedInfo", new Map(Object.entries(kickedInfo)))
        this.notifyEvent("onChatroomKicked", resultMap)
      })
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      this.onSuccess(result, null);
    } catch (e) {
      this.onError(result, e);
    }
  }

  private removeChatroomClientListener(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId = args.get("instanceId") as number | undefined;
      if (instanceId === undefined) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId);
      chatroomService.off("onChatroomStatus", null)
      chatroomService.off("onChatroomEntered", null)
      chatroomService.off("onChatroomExited", null)
      chatroomService.off("onChatroomKicked", null)
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }
      this.onSuccess(result, null);
    } catch (e) {
      this.onError(result, e);
    }
  }

  private destroyInstance(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId = args.get("instanceId") as number | undefined;
      if (instanceId === undefined) {
        this.onErrorWithCode(result, -2, "Invalid chatroomService instanceId");
        return;
      }
      V2NIMChatroomClient.destroyInstance(instanceId);
      this.onSuccess(result, null);
    } catch (e) {
      this.onError(result, e);
    }
  }

  private destroyAll(args: Map<string, Any>, result: MethodResult): void {
    try {
      V2NIMChatroomClient.destroyAll();
      FLTChatroomClientService.instanceAccountMap.clear()
      this.onSuccess(result, null);
    } catch (e) {
      this.onError(result, e);
    }
  }

  private initChatroomParams(map: Map<string, Any> | null | undefined): V2NIMChatroomInitParams | undefined {
    // 验证 map 是否有效
    if (!map) {
      return undefined;
    }
    const appkey = map.get("appKey") as string | "";
    // 提取自定义客户端类型（可选）
    let customClientType: number | undefined = undefined;
    if (map.has("customClientType")) {
      const clientTypeRaw = map.get("customClientType") as object;
      if (typeof clientTypeRaw === 'number' && clientTypeRaw > 0) {
        customClientType = clientTypeRaw;
      }
    }
    // 处理 HTTP 服务配置（可选）
    let httpServiceConfig: NIMHttpServiceConfig | undefined = undefined;
    if (map.has("httpServiceConfig")) {
      const httpMap: Map<string, Any> = map.get("httpServiceConfig") as Map<string, Any>;
      httpServiceConfig = {
        services: httpMap.has("services") ? (httpMap.get("services") as string []) : undefined,
        chunkUploadHost: httpMap.has("chunkUploadHost") ? (httpMap.get("chunkUploadHost") as string) : undefined,
        uploadReplaceFormat: httpMap.has("uploadReplaceFormat") ? (httpMap.get("uploadReplaceFormat") as string) :
          undefined
      };
    }
    // 处理存储服务配置（可选）
    let storageServiceConfig: NIMStorageServiceConfig | undefined = undefined;
    if (map.has("storageServiceConfig")) {
      const storageMap: Map<string, Any> = map.get("storageServiceConfig") as Map<string, Any>;
      storageServiceConfig = {
        services: storageMap.has("services") ? (storageMap.get("services") as string []) : undefined,
        downloadHost: storageMap.has("downloadHost") ? (storageMap.get("downloadHost") as string) : undefined,
        downloadReplaceFormat: storageMap.has("downloadReplaceFormat") ?
          (storageMap.get("downloadReplaceFormat") as string) : undefined
      };
    }
    // 构建并返回完整参数对象
    return {
      appkey: appkey,
      customClientType: customClientType,
      httpServiceConfig: httpServiceConfig,
      storageServiceConfig: storageServiceConfig
    };
  }


  /**
   * 从Map<string, Any>中初始化V2NIMChatroomEnterParams实例
   * @param paramsMap 包含聊天室进入参数的Map
   * @param roomId 聊天室ID（用于linkProvider）
   * @returns 初始化后的V2NIMChatroomEnterParams实例
   */
  private initChatroomEnterParams(instanceId: number,
    paramsMap: Map<string, Any>,
  ): V2NIMChatroomEnterParams {
    // 处理基础参数
    const anonymousMode = paramsMap.get('anonymousMode') != null ? (paramsMap.get('anonymousMode') as boolean) : false;
    const accountId = paramsMap.get('accountId') != null ? (paramsMap.get('accountId') as string) : undefined;
    const token = paramsMap.get('token') != null ? (paramsMap.get('token') as string) : undefined;
    const roomNick = paramsMap.get('roomNick') != null ? (paramsMap.get('roomNick') as string) : undefined;
    const roomAvatar = paramsMap.get('roomAvatar') != null ? (paramsMap.get('roomAvatar') as string) : undefined;
    const timeout = paramsMap.get('timeout') != null ? (paramsMap.get('timeout') as number) : 30;
    const serverExtension =
      paramsMap.get('serverExtension') != null ? (paramsMap.get('serverExtension') as string) : undefined;
    const notificationExtension =
      paramsMap.get('notificationExtension') != null ? (paramsMap.get('notificationExtension') as string) : undefined;
    const isHttps = paramsMap.get('isHttps') != null ? (paramsMap.get('isHttps') as boolean) : undefined;

    // 处理loginOption
    let loginOption: Any;
    if (paramsMap.has('authType')) {
      loginOption = {
        authType: V2NIMLoginAuthType.V2NIM_LOGIN_AUTH_TYPE_DEFAULT, //paramsMap.has('authType') ? (paramsMap.get('authType') as V2NIMLoginAuthType) : undefined,
        tokenProvider: (appKey: string, rId: string, aId: string) => {
          let paramsMap: Map<string, Any> = new Map();
          paramsMap.set("roomId", rId);
          paramsMap.set("accountId", aId);
          paramsMap.set("instanceId", instanceId)
          return this.notifyEventPromise<Array<string>>("getToken", paramsMap)
        },
        loginExtensionProvider: (appKey: string, rId: string, aId: string) => {
          let paramsMap: Map<string, Any> = new Map();
          paramsMap.set("roomId", rId);
          paramsMap.set("accountId", aId);
          paramsMap.set("instanceId", instanceId)
          return this.notifyEventPromise<Array<string>>("getLoginExtension", paramsMap)
        },
        routeConfig: paramsMap.has('routeConfig') ? (paramsMap.get('routeConfig') as V2NIMRouteConfig) :
          undefined
      };
    }

    // 处理linkProvider（必选参数）
    const linkProvider: (roomId: string, accountId: string) => Promise<Array<string>> = (roomId, accountId) => {

      let paramsMap: Map<string, Any> = new Map();
      paramsMap.set("roomId", roomId);
      paramsMap.set("accountId", accountId);
      paramsMap.set("instanceId", instanceId)

      return this.notifyEventPromise<Array<string>>("getLinkAddress", paramsMap)
    };

    // 处理tagConfig
    let tagConfig: Any;
    if (paramsMap.get('tagConfig')) {
      const tagMap: Map<string, Any> = paramsMap.get('tagConfig') as Map<string, Any>;
      tagConfig = {
        notifyTargetTags: tagMap.get('notifyTargetTags') as string,
        tags: tagMap.get('tags') as string[]
      };
    }

    // 处理locationConfig
    let locationConfig: V2NIMChatroomLocationConfig | undefined;
    if (paramsMap.get('locationConfig')) {
      const locationMap: Map<string, Any> = paramsMap.get('locationConfig') as Map<string, Any>;
      const locationInfoMap: Map<string, Any> = locationMap.get('locationInfo') as Map<string, Any>;
      const locationInfo: V2NIMLocationInfo = {
        x: locationInfoMap.get('x') ? (locationInfoMap.get('x') as number) : undefined,
        y: locationInfoMap.get('y') ? (locationInfoMap.get('y') as number) : undefined,
        z: locationInfoMap.get('z') ? (locationInfoMap.get('z') as number) : undefined
      };
      locationConfig = {
        locationInfo: locationInfo,
        distance: locationMap.get('distance') as number
      };
    }

    // 处理antispamConfig
    let antispamConfig: V2NIMAntispamConfig | undefined;
    if (paramsMap.get('antispamConfig')) {
      const antispamMap: Map<string, Any> = paramsMap.get('antispamConfig') as Map<string, Any>;
      antispamConfig = {
        antispamBusinessId: antispamMap.get('antispamBusinessId') as string
      };
    }

    return {
      anonymousMode: anonymousMode,
      accountId: accountId,
      token: token,
      roomNick: roomNick,
      roomAvatar: roomAvatar,
      timeout: timeout,
      loginOption: loginOption,
      linkProvider: linkProvider,
      serverExtension: serverExtension,
      notificationExtension: notificationExtension,
      tagConfig: tagConfig,
      locationConfig: locationConfig,
      antispamConfig: antispamConfig,
      isHttps: isHttps
    };
  }

  /**
   * 初始化聊天室进入参数
   * @param instanceId 实例ID
   * @param paramsMap 包含参数的Map对象
   * @returns 类型安全的V2NIMChatroomEnterParams对象
   */
  private convertToChatroomEnterParams(
    instanceId: number,
    paramsMap: Map<string, Any>
  ): V2NIMChatroomEnterParams {
    // 显式初始化所有属性，设置默认值或undefined，严格匹配接口定义
    const enterParams: V2NIMChatroomEnterParams = {
      linkProvider: (roomId: string, accountId: string): Promise<string[]> => {
        throw new Error('Function not implemented.');
      }
    };

    // 处理匿名模式（有默认值，仅当存在有效数据时覆盖）
    if (paramsMap.get('anonymousMode') !== undefined && paramsMap.get('anonymousMode') !== null) {
      enterParams.anonymousMode = paramsMap.get('anonymousMode') as boolean;
    }

    // 处理账号ID
    if (paramsMap.get('accountId') !== undefined && paramsMap.get('accountId') !== null) {
      enterParams.accountId = paramsMap.get('accountId') as string;
    }

    // 处理token
    if (paramsMap.get('token') !== undefined && paramsMap.get('token') !== null) {
      enterParams.token = paramsMap.get('token') as string;
    }

    // 处理房间昵称
    if (paramsMap.get('roomNick') !== undefined && paramsMap.get('roomNick') !== null) {
      enterParams.roomNick = paramsMap.get('roomNick') as string;
    }

    // 处理房间头像
    if (paramsMap.get('roomAvatar') !== undefined && paramsMap.get('roomAvatar') !== null) {
      enterParams.roomAvatar = paramsMap.get('roomAvatar') as string;
    }

    // 处理超时时间（有默认值，仅当存在有效数据时覆盖）
    if (paramsMap.get('timeout') !== undefined && paramsMap.get('timeout') !== null) {
      enterParams.timeout = paramsMap.get('timeout') as number;
    }

    // 处理服务器扩展字段
    if (paramsMap.get('serverExtension') !== undefined && paramsMap.get('serverExtension') !== null) {
      enterParams.serverExtension = paramsMap.get('serverExtension') as string;
    }

    // 处理通知扩展字段
    if (paramsMap.get('notificationExtension') !== undefined && paramsMap.get('notificationExtension') !== null) {
      enterParams.notificationExtension = paramsMap.get('notificationExtension') as string;
    }

    // 处理HTTPS配置
    if (paramsMap.get('isHttps') !== undefined && paramsMap.get('isHttps') !== null) {
      enterParams.isHttps = paramsMap.get('isHttps') as boolean;
    }

    // 处理登录选项
    if (paramsMap.has('authType')) {
      enterParams.loginOption = {
        authType: V2NIMLoginAuthType.V2NIM_LOGIN_AUTH_TYPE_DEFAULT,
        tokenProvider: (appKey: string, rId: string, aId: string) => {
          const tokenParams: Map<string, Any> = new Map<string, Any>();
          tokenParams.set("roomId", rId);
          tokenParams.set("accountId", aId);
          tokenParams.set("instanceId", instanceId);
          return this.notifyEventPromise<string>("getToken", tokenParams);
        },
        loginExtensionProvider: (appKey: string, rId: string, aId: string) => {
          const loginExtParams: Map<string, Any> = new Map<string, Any>();
          loginExtParams.set("roomId", rId);
          loginExtParams.set("accountId", aId);
          loginExtParams.set("instanceId", instanceId);
          return this.notifyEventPromise<string>("getLoginExtension", loginExtParams);
        },
      };

      // 处理登录选项中的路由配置
      if (paramsMap.get('routeConfig') !== undefined && paramsMap.get('routeConfig') !== null) {
        let routConfig: V2NIMRouteConfig = {}
        let configMap: Map<string, Any> = paramsMap.get('routeConfig') as Map<string, Any>;
        if (configMap.get('routeEnabled') !== undefined && configMap.get('routeEnabled') !== null) {
          routConfig.routeEnabled = configMap.get('routeEnabled') as boolean
        }

        if (configMap.get('routeEnvironment') !== undefined && configMap.get('routeEnvironment') !== null) {
          routConfig.routeEnvironment = configMap.get('routeEnvironment') as string
        }

        enterParams.loginOption.routeConfig = routConfig
      }
    }

    // 处理链接提供者（必选参数，直接赋值）
    enterParams.linkProvider = (roomId: string, accountId: string) => {
      const linkParams: Map<string, Any> = new Map<string, Any>();
      linkParams.set("roomId", roomId);
      linkParams.set("accountId", accountId);
      linkParams.set("instanceId", instanceId);
      return this.notifyEventPromise<Array<string>>("getLinkAddress", linkParams);
    };

    // 处理标签配置
    if (paramsMap.get('tagConfig') !== undefined && paramsMap.get('tagConfig') !== null) {
      const tagMap: Map<string, Any> = paramsMap.get('tagConfig') as Map<string, Any>;
      enterParams.tagConfig = {
        notifyTargetTags: '',
        tags: []
      };

      if (tagMap.get('notifyTargetTags') !== undefined && tagMap.get('notifyTargetTags') !== null) {
        enterParams.tagConfig.notifyTargetTags = tagMap.get('notifyTargetTags') as string;
      }

      if (tagMap.get('tags') !== undefined && tagMap.get('tags') !== null) {
        enterParams.tagConfig.tags = tagMap.get('tags') as string[];
      }
    }

    // 处理位置配置
    if (paramsMap.get('locationConfig') !== undefined && paramsMap.get('locationConfig') !== null) {
      const locationMap: Map<string, Any> = paramsMap.get('locationConfig') as Map<string, Any>;
      enterParams.locationConfig = convertToLocationConfig(locationMap)
    }

    // 处理反垃圾配置
    if (paramsMap.get('antispamConfig') !== undefined && paramsMap.get('antispamConfig') !== null) {
      const antispamMap: Map<string, Any> = paramsMap.get('antispamConfig') as Map<string, Any>;
      enterParams.antispamConfig = convertToAntispamConfig(antispamMap);
    }

    return enterParams;
  }
}