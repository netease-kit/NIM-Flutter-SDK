/*
 *
 *  * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 *  * Use of this source code is governed by a MIT license that can be
 *  * found in the LICENSE file.
 *
 *
 */
import {
  DatabaseOptions,
  DataReporterConfig,
  ABTConfig,
  LogLevel,
  NIMFriendServiceConfig,
  NIMHttpServiceConfig,
  NIMInitializeOptions,
  NIMLoginServiceConfig,
  NIMMessageServiceConfig,
  NIMPushServiceConfig,
  NIMServiceOptions,
  NIMStorageServiceConfig,
  V2NIMConversationConfig,
  V2NIMLocalConversationConfig,
  V2NIMProtocolFamily,
  V2NIMSearchConfig,
  V2NIMTeamConfig,
  V2NIMProvidedServiceType
} from '@nimsdk/base';
import { V2NIMConversationServiceImpl } from '@nimsdk/conversation';
import { V2NIMFriendServiceImpl } from '@nimsdk/friend';
import { V2NIMLocalConversationServiceImpl } from '@nimsdk/localconversation';
import { V2NIMClientAntispamUtil, V2NIMMessageServiceImpl } from '@nimsdk/message';
import { NIMSdk } from '@nimsdk/nim';
import { V2NIMSearchServiceImpl } from '@nimsdk/search';
import { V2NIMSignallingServiceImpl } from '@nimsdk/signalling';
import { V2NIMTeamServiceImpl } from '@nimsdk/team';
import { V2NIMUserServiceImpl } from '@nimsdk/user';
import { Any, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';
import { NimCore } from '../NimCore';

@ObservedV2
export class FLTInitializeService extends FLTService {
  private serviceNameTag: string = "InitializeService";
  private isInitialize: boolean = false;

  _onInitializedSuccess() {
    this.isInitialize = true;
    NimCore.getInstance().onInitialized()
  }

  get serviceName(): string {
    return this.serviceNameTag;
  }

  get hasInitialize(): boolean {
    if (this.isInitialize) {
      return true;
    }
    if (NimCore.getInstance().nimInterface != null) {
      this.isInitialize = true;
      return true;
    }
    return this.isInitialize;
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    if (method == "initialize") {
      this.initializeService(args, result);
    } else if (method == "getInstance") {
      this.getInstance(args, result);
    } else if (method == "destroyInstance") {
      this.destroyInstance(args, result);
    } else if (method == "releaseDesktop") {
      this.destroy(args, result);
    } else {
      this.onErrorWithCode(result, -1, "has not implement")
    }
  }


  private initializeService(args: Map<string, Any>, result: MethodResult): void {
    // 初始化操作
    console.log('InitializeService initialized');
    let sdkVersion = "";
    if(args.get("extras") !== null && args.get("extras") !== undefined){
      let extras = args.get("extras") as Map<string,string | number>;
      if(extras.get("versionName") !== undefined && extras.get("versionName") !== null){
        sdkVersion = extras.get("versionName") as string
      }
    }
    let initializeOptions: NIMInitializeOptions = {
      appkey: args.get("appKey") as string,
      // 可选参数：日志级别，从Map获取并转换为LogLevel类型
      logLevel: args.has("logLevel")
        ? (args.get("logLevel") as LogLevel)
        : undefined,
      flutterSDKVersion:sdkVersion,
      // 可选参数：xhr连接超时时间
      xhrConnectTimeout: args.has("xhrConnectTimeout")
        ? (Number(args.get("xhrConnectTimeout")))
        : undefined,

      // 可选参数：socket长连接超时时间
      socketConnectTimeout: args.has("socketConnectTimeout")
        ? (Number(args.get("socketConnectTimeout")))
        : undefined,

      // 可选参数：是否输出SDK日志到控制台
      isOpenConsoleLog: args.has("isOpenConsoleLog")
        ? (args.get("isOpenConsoleLog") === 'true' || args.get("isOpenConsoleLog") === true)
        : undefined,

      // 可选参数：是否过滤输出到日志文件的信息
      isFilteringLog: args.has("isFilteringLog")
        ? (args.get("isFilteringLog") === 'true' || args.get("isFilteringLog") === true)
        : undefined
    };
    // 组装完整的服务配置选项
    let serviceOptions: NIMServiceOptions | undefined = undefined;
    if (args.get("serverOptions") !== null && args.get("serverOptions") !== undefined) {
      serviceOptions = this.convertToNIMServiceOptions(args.get("serverOptions") as Map<string, Any>)
    }

    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_TEAM,
      (core, serviceName, serviceConfig) => new V2NIMTeamServiceImpl(core, serviceName, serviceConfig))
    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_CLIENT_ANTISPAM_UTIL,
      (core, serviceName, serviceConfig) => new V2NIMClientAntispamUtil(core, serviceName, serviceConfig));
    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_LOCAL_CONVERSATION,
      (core, serviceName, serviceConfig) => new V2NIMLocalConversationServiceImpl(core, serviceName, serviceConfig));
    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_CONVERSATION,
      (core, serviceName, serviceConfig) => new V2NIMConversationServiceImpl(core, serviceName, serviceConfig));
    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_MESSAGE,
      (core, serviceName, serviceConfig) => new V2NIMMessageServiceImpl(core, serviceName, serviceConfig));
    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_USER,
      (core, serviceName, serviceConfig) => new V2NIMUserServiceImpl(core, serviceName, serviceConfig));
    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_FRIEND,
      (core, serviceName, serviceConfig) => new V2NIMFriendServiceImpl(core, serviceName, serviceConfig));
    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_SIGNALLING,
      (core, serviceName, serviceConfig) => new V2NIMSignallingServiceImpl(core, serviceName, serviceConfig));
    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_SEARCH,
      (core, serviceName, serviceConfig) => new V2NIMSearchServiceImpl(core, serviceName, serviceConfig));

    try {
      NimCore.getInstance().nimInterface =
        NIMSdk.newInstance(NimCore.getInstance().context, initializeOptions, serviceOptions)
      this._onInitializedSuccess();
      this.onSuccess(result)
    } catch (e) {
      this.onError(result, e)
    }
  }

  private getInstance(args: Map<string, Any>, result: MethodResult): void {
    const instanceId = args.get("instanceId") as string;
    let nim = NIMSdk.getInstance(instanceId)
    if (nim) {
      NimCore.getInstance().nimInterface = nim
      this.onSuccess(result)
    } else {
      this.onErrorWithCode(result, -1, "instance not exit")
    }
  }

  private destroyInstance(args: Map<string, Any>, result: MethodResult): void {
    const instanceId = args.get("instanceId") as string;
    NIMSdk.destroyInstance(instanceId)
    this.onSuccess(result)
  }

  private destroy(args: Map<string, Any>, result: MethodResult): void {
    NIMSdk.destroy()
    this.isInitialize = false
    this.onSuccess(result)
  }

  private convertToNIMServiceOptions(args: Map<string, Any>): NIMServiceOptions {
    let loginServiceConfig: NIMLoginServiceConfig | undefined = undefined;
    let loginServiceConfigMap: Map<string, Any> | undefined = this.getConfigMap(args, "loginServiceConfig");
    if (loginServiceConfigMap) {
      loginServiceConfig = this.convertToNIMLoginServiceConfig(loginServiceConfigMap)
    }


    // 补充本地会话配置（空接口，仅处理存在性）TODO
    let messageServiceConfig: NIMMessageServiceConfig | undefined = undefined;
    let messageServiceMap: Map<string, Any> | undefined = this.getConfigMap(args, "messageServiceConfig");
    if (messageServiceMap) {
      messageServiceConfig = {
        services: this.getStringArray(messageServiceMap, "services")
      };
    }

    let friendServiceConfig: NIMFriendServiceConfig | undefined = undefined;
    let friendMap: Map<string, Any> | undefined = this.getConfigMap(args, "friendServiceConfig");
    if (friendMap) {
      friendServiceConfig = {
        services: this.getStringArray(friendMap, "services"),
        enableServerV2FriendAddApplication: this.getBoolean(friendMap, "enableServerV2FriendAddApplication")
      };
    }

    let pushServiceConfig: NIMPushServiceConfig | undefined = undefined;
    let pushMap: Map<string, Any> | undefined = this.getConfigMap(args, "pushServiceConfig");
    if (pushMap) {
      pushServiceConfig = {
        services: this.getStringArray(pushMap, "services"),
        harmonyCertificateName: this.getString(pushMap, "harmonyCertificateName"),
        customPushContentType: this.getString(pushMap, "customPushContentType")
      }
    }

    // 补充 HTTP 服务配置
    let httpServiceConfig: NIMHttpServiceConfig | undefined = undefined;
    let httpMap: Map<string, Any> | undefined = this.getConfigMap(args, "httpServiceConfig");
    if (httpMap) {
      httpServiceConfig = {
        services: this.getStringArray(httpMap, "services"),
        chunkUploadHost: this.getString(httpMap, "chunkUploadHost"),
        uploadReplaceFormat: this.getString(httpMap, "uploadReplaceFormat")
      };
    }
    // 补充数据库服务配置
    let databaseServiceConfig: DatabaseOptions | undefined = undefined;
    let dbMap: Map<string, Any> | undefined = this.getConfigMap(args, "databaseServiceConfig", "databaseOptions");
    if (dbMap) {
      if (dbMap.has("appKey")) { // 确保必填项存在
        databaseServiceConfig = {
          appKey: dbMap.get("appKey") as string,
          securityLevel: this.getNumber(dbMap, "securityLevel"),
          encrypt: this.getBoolean(dbMap, "encrypt"),
          services: this.getStringArray(dbMap, "services"),
          backupEnabled: this.getBoolean(dbMap, "backupEnabled"),
          backupRetentionCount: this.getNumber(dbMap, "backupRetentionCount"),
          backupIntervalHours: this.getNumber(dbMap, "backupIntervalHours"),
          healthCheckOnOpen: this.getBoolean(dbMap, "healthCheckOnOpen"),
          autoRecoverOnOpenFailure: this.getBoolean(dbMap, "autoRecoverOnOpenFailure")
        };
      }
    }

    // 补充存储服务配置
    let storageServiceConfig: NIMStorageServiceConfig | undefined = undefined;
    let storageMap: Map<string, Any> | undefined = this.getConfigMap(args, "storageServiceConfig");
    if (storageMap) {
      storageServiceConfig = {
        services: this.getStringArray(storageMap, "services"),
        downloadHost: this.getString(storageMap, "downloadHost"),
        downloadReplaceFormat: this.getString(storageMap, "downloadReplaceFormat"),
        httpRequestDownload: this.getBoolean(storageMap, "httpRequestDownload")
      };
    }

    // 补充云端会话配置
    let conversationServiceConfig: V2NIMConversationConfig | undefined = undefined;
    let conversationMap: Map<string, Any> | undefined =
      this.getConfigMap(args, "conversationServiceConfig", "conversationConfig");
    if (conversationMap) {
      conversationServiceConfig = {
        services: this.getStringArray(conversationMap, "services"),
        loadHistoryConversationLimit: this.getNumber(conversationMap, "loadHistoryConversationLimit"),
        enableV2ConversationIncrementalSyncNotify:
          this.getBoolean(conversationMap, "enableV2ConversationIncrementalSyncNotify")
      };
    }

    // 补充本地会话配置（空接口，仅处理存在性）
    let localConversationServiceConfig: V2NIMLocalConversationConfig | undefined = undefined;
    let localConversationMap: Map<string, Any> | undefined =
      this.getConfigMap(args, "localConversationServiceConfig", "localConversationConfig");
    if (localConversationMap) {
      localConversationServiceConfig = {
        services: this.getStringArray(localConversationMap, "services"),
        useLastMessageOnRevoke: this.getBoolean(localConversationMap, "useLastMessageOnRevoke"),
        clearUnreadAfterDeleteConversation: this.getBoolean(localConversationMap, "clearUnreadAfterDeleteConversation")
      };
    }

    let teamServiceConfig: V2NIMTeamConfig | undefined = undefined;
    let teamMap: Map<string, Any> | undefined = this.getConfigMap(args, "teamServiceConfig");
    if (teamMap) {
      teamServiceConfig = {
        services: this.getStringArray(teamMap, "services"),
        enableServerV2TeamJoinActionInfo: this.getBoolean(teamMap, "enableServerV2TeamJoinActionInfo")
      };
    }

    let searchServiceConfig: V2NIMSearchConfig | undefined = undefined;
    let searchMap: Map<string, Any> | undefined = this.getConfigMap(args, "searchServiceConfig");
    if (searchMap) {
      searchServiceConfig = {
        services: this.getStringArray(searchMap, "services"),
        searchAccountIdEnabled: this.getBoolean(searchMap, "searchAccountIdEnabled")
      };
    }

    // 补充数据上报配置
    let dataReporterConfig: DataReporterConfig | undefined = undefined;
    let reporterMap: Map<string, Any> | undefined = this.getConfigMap(args, "dataReporterConfig");
    if (reporterMap) {
      // 确保必填字段存在
      if (reporterMap.has("isCloseDataReporter")) {
        dataReporterConfig = {
          services: this.getStringArray(reporterMap, "services"),
          isCloseDataReporter: reporterMap.get("isCloseDataReporter") as boolean,
          dataReporterAddress: this.getString(reporterMap, "dataReporterAddress")
        };
      }
    }

    let abtServiceConfig: ABTConfig | undefined = undefined;
    let abtMap: Map<string, Any> | undefined = this.getConfigMap(args, "abtServiceConfig");
    if (abtMap && abtMap.has("abtUrl")) {
      abtServiceConfig = {
        services: this.getStringArray(abtMap, "services"),
        abtUrl: abtMap.get("abtUrl") as string
      };
    }

    // 组装完整的服务配置选项
    return {
      loginServiceConfig: loginServiceConfig,
      messageServiceConfig: messageServiceConfig,
      friendServiceConfig: friendServiceConfig,
      pushServiceConfig: pushServiceConfig,
      httpServiceConfig: httpServiceConfig,
      databaseServiceConfig: databaseServiceConfig,
      storageServiceConfig: storageServiceConfig,
      conversationServiceConfig: conversationServiceConfig,
      localConversationServiceConfig: localConversationServiceConfig,
      teamServiceConfig: teamServiceConfig,
      searchServiceConfig: searchServiceConfig,
      dataReporterConfig: dataReporterConfig,
      abtServiceConfig: abtServiceConfig
    };
  }

  /**
   * 将Map<string, Any>转换为NIMLoginServiceConfig接口实例（优化类型断言）
   * @param map 包含登录服务配置的Map，可为null或undefined
   * @returns 转换后的NIMLoginServiceConfig实例
   */
  private convertToNIMLoginServiceConfig(map: Map<string, Any> | undefined): NIMLoginServiceConfig {
    // 初始化所有字段为默认值（可选字段默认为undefined）
    let lbsUrls: string[] | undefined = undefined;
    let linkUrl: string | undefined = undefined;
    let customClientType: number | undefined = undefined;
    let customTag: string | undefined = undefined;
    let isHttps: boolean | undefined = undefined;
    let supportProtocolFamily: V2NIMProtocolFamily | undefined = undefined;
    let lbsCacheExpirationInterval: number | undefined = undefined;
    let lbsCacheRefreshInterval: number | undefined = undefined;

    if (map) {
      let services: string[] | undefined = this.getStringArray(map, "services");
      // 处理lbsUrls（字符串数组）- 明确类型断言为unknown[]避免编译器报错
      const lbsUrlsRaw = map.get('lbsUrls') as object;
      if (lbsUrlsRaw !== null && lbsUrlsRaw !== undefined && Array.isArray(lbsUrlsRaw)) {
        // 过滤数组中的非字符串元素
        let urlArray = lbsUrlsRaw as string[];
        if (urlArray.length > 0) {
          lbsUrls = urlArray
        }
      }

      // 处理linkUrl（字符串）- 明确类型断言
      const linkUrlRaw = map.get('linkUrl') as object;
      if (typeof linkUrlRaw === 'string') {
        linkUrl = linkUrlRaw;
      }

      // 处理customClientType（大于0的数字）- 明确类型断言
      const customClientTypeRaw = map.get('customClientType') as object;
      if (typeof customClientTypeRaw === 'number' && customClientTypeRaw > 0) {
        customClientType = customClientTypeRaw;
      }

      // 处理customTag（最大32个字符的字符串）- 明确类型断言
      const customTagRaw = map.get('customTag') as object;
      if (typeof customTagRaw === 'string') {
        customTag = customTagRaw;
      }

      // 处理isHttps（布尔值）- 明确类型断言
      const isHttpsRaw = map.get('isHttps') as object;
      if (typeof isHttpsRaw === 'boolean') {
        isHttps = isHttpsRaw;
      }

      // 处理supportProtocolFamily（枚举类型）- 明确类型断言
      const protocolFamilyRaw = map.get('supportProtocolFamily') as number | undefined;
      if (typeof protocolFamilyRaw === 'number') {
        // 验证是否为有效的枚举值
        const validValues = Object.values(V2NIMProtocolFamily)
          .filter(value => typeof value === 'number') as V2NIMProtocolFamily[];

        if (validValues.includes(protocolFamilyRaw)) {
          supportProtocolFamily = protocolFamilyRaw;
        }
      }

      lbsCacheExpirationInterval = this.getNumber(map, "lbsCacheExpirationInterval");
      lbsCacheRefreshInterval = this.getNumber(map, "lbsCacheRefreshInterval");

      return {
        services: services,
        lbsUrls: lbsUrls,
        linkUrl: linkUrl,
        customClientType: customClientType,
        customTag: customTag,
        isHttps: isHttps,
        supportProtocolFamily: supportProtocolFamily,
        lbsCacheExpirationInterval: lbsCacheExpirationInterval,
        lbsCacheRefreshInterval: lbsCacheRefreshInterval
      };
    }
    // 构建并返回配置对象
    return {
      lbsUrls: lbsUrls,
      linkUrl: linkUrl,
      customClientType: customClientType,
      customTag: customTag,
      isHttps: isHttps,
      supportProtocolFamily: supportProtocolFamily,
      lbsCacheExpirationInterval: lbsCacheExpirationInterval,
      lbsCacheRefreshInterval: lbsCacheRefreshInterval
    };
  }

  private getConfigMap(args: Map<string, Any>, key: string, fallbackKey?: string): Map<string, Any> | undefined {
    let value: Any = args.get(key);
    if ((value === null || value === undefined) && fallbackKey !== undefined) {
      value = args.get(fallbackKey);
    }
    if (value !== null && value !== undefined) {
      return value as Map<string, Any>;
    }
    return undefined;
  }

  private getStringArray(map: Map<string, Any>, key: string): string[] | undefined {
    const value = map.get(key) as object;
    if (value !== null && value !== undefined && Array.isArray(value)) {
      return value as string[];
    }
    return undefined;
  }

  private getString(map: Map<string, Any>, key: string): string | undefined {
    const value = map.get(key) as object;
    return typeof value === 'string' ? value : undefined;
  }

  private getNumber(map: Map<string, Any>, key: string): number | undefined {
    const value = map.get(key) as object;
    return typeof value === 'number' ? value : undefined;
  }

  private getBoolean(map: Map<string, Any>, key: string): boolean | undefined {
    const value = map.get(key) as object;
    return typeof value === 'boolean' ? value : undefined;
  }
}
