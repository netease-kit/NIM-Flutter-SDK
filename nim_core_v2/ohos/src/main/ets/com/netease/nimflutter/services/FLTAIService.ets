/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import {
  V2NIMAIModelCallContent,
  V2NIMAIModelCallMessage,
  V2NIMAIModelCallResult,
  V2NIMAIModelConfigParams,
  V2NIMAIModelRoleType,
  V2NIMAIModelStreamCallResult,
  V2NIMAIModelStreamCallStopParams,
  V2NIMProxyAICallAntispamConfig,
  V2NIMProxyAIModelCallParams
} from '@nimsdk/base';
import { V2NIMError } from '@nimsdk/base/Index';
import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';

export class FLTAIService extends FLTService {
  private serviceNameTag: string = "AIService";

  get serviceName(): string {
    return this.serviceNameTag;
  }

  onInitialized(): void {
    Log.d(this.serviceName, "onInitialized");
    this.createAIListener();
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    Log.d(this.serviceName, `onMethodCall: ${method}`);
    switch (method) {
      case "getAIUserList":
        this.getAIUserList(args, result);
        break;
      case "proxyAIModelCall":
        this.proxyAIModelCall(args, result);
        break;
      case "stopAIModelStreamCall":
        this.stopAIModelStreamCall(args, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private getAIUserList(args: Map<string, Any>, result: MethodResult): void {
    try {
      const aiService = this.nim.aiService;
      if (!aiService) {
        this.onErrorWithCode(result, -1, "Invalid aiService instance");
        return;
      }

      aiService.getAIUserList()
        .then((users) => {
          const userList: Any[] = users.map(user => new Map(Object.entries(user)))
          this.onSuccess(result, new Map<string, Any>().set("userList", userList));
        })
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private proxyAIModelCall(args: Map<string, Any>, result: MethodResult): void {
    try {
      const paramsMap: Map<string, Any> = args.get("params") as Map<string, Any>;

      if (!paramsMap) {
        this.onErrorWithCode(result, -1, "Invalid proxyAIModelCall params");
        return;
      }

      const aiService = this.nim.aiService;
      if (!aiService) {
        this.onErrorWithCode(result, -1, "Invalid aiService instance");
        return;
      }

      const params = this.convertToProxyAIModelCallParams(paramsMap);

      aiService.proxyAIModelCall(params)
        .then(() => this.onSuccess(result, null))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private stopAIModelStreamCall(args: Map<string, Any>, result: MethodResult): void {
    try {
      const paramsMap: Map<string, Any> = args.get("params") as Map<string, Any>;

      if (!paramsMap) {
        this.onErrorWithCode(result, -1, "Invalid stopAIModelStreamCall params");
        return;
      }

      const aiService = this.nim.aiService;
      if (!aiService) {
        this.onErrorWithCode(result, -1, "Invalid aiService instance");
        return;
      }

      const params = this.convertToAIModelStreamCallStopParams(paramsMap);

      aiService.stopAIModelStreamCall(params)
        .then(() => this.onSuccess(result, null))
        .catch((error: V2NIMError) => this.onError(result, error));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private createAIListener() {
    const aiService = this.nim.aiService;
    if (!aiService) {
      return;
    }
    aiService.on("onProxyAIModelCall", (response: V2NIMAIModelCallResult) => {
      this.notifyEvent("onProxyAIModelCall", new Map(Object.entries(response)));
    });

    aiService.on("onProxyAIModelStreamCall", (data: V2NIMAIModelStreamCallResult) => {
      this.notifyEvent("onProxyAIModelStreamCall", new Map(Object.entries(data)));
    });
  }

  private offAIListener() {
    const aiService = this.nim.aiService;
    if (!aiService) {
      return;
    }
    aiService.off("onProxyAIModelCall", null);
    aiService.off("onProxyAIModelStreamCall", null);
  }


  private convertToProxyAIModelCallParams(map: Map<string, Any>): V2NIMProxyAIModelCallParams {

    let promptVariables: string | undefined
    if (map.get("promptVariables")) {
      promptVariables = map.get("promptVariables") as string
    }

    return {
      accountId: map.get("accountId") as string,
      requestId: map.get("requestId") as string,
      content: this.convertToAIModelCallContent(map.get("content") as Map<string, Any>),
      messages: map.get("messages") ?
      (map.get("messages") as Array<Map<string, object>>).map(msg => this.convertToAIModelCallMessage(msg)) : undefined,
      promptVariables: promptVariables,
      modelConfigParams: map.get("modelConfigParams") ?
      this.convertToAIModelConfigParams(map.get("modelConfigParams") as Map<string, Any>) : undefined,
      antispamConfig: map.get("antispamConfig") ?
      this.convertToProxyAICallAntispamConfig(map.get("antispamConfig") as Map<string, Any>) : undefined,
      aiStream: map.get("aiStream") as boolean ?? false
    };
  }

  private convertToAIModelCallContent(map: Map<string, Any>): V2NIMAIModelCallContent {
    return {
      msg: map.get("msg") as string,
      type: map.get("type") as number
    };
  }

  private convertToAIModelCallMessage(map: Map<string, Any>): V2NIMAIModelCallMessage {
    return {
      role: this.convertToV2NIMAIModelRoleType(map.get("role") as number),
      msg: map.get("msg") as string,
      type: map.get("type") as number
    };
  }

  private convertToV2NIMAIModelRoleType(role: number | undefined | null) {
    if (role == 0) {
      return V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_SYSTEM
    } else if (role == 1) {
      return V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_USER
    } else if (role == 2) {
      return V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_ASSISTANT
    } else {
      return V2NIMAIModelRoleType.V2NIM_AI_MODEL_ROLE_TYPE_SYSTEM
    }
  }

  private convertToAIModelConfigParams(map: Map<string, Any>): V2NIMAIModelConfigParams {
    let maxToken: number | undefined
    if (map.get("maxTokens")) {
      maxToken = map.get("maxTokens") as number
    }
    let topP: number | undefined
    if (map.get("topP")) {
      topP = map.get("topP") as number
    }
    let temperature: number | undefined
    if (map.get("temperature")) {
      temperature = map.get("temperature") as number
    }

    return {
      prompt: map.get("prompt") as string,
      maxTokens: maxToken,
      topP: topP,
      temperature: temperature
    };
  }

  private convertToProxyAICallAntispamConfig(map: Map<string, Any>): V2NIMProxyAICallAntispamConfig {
    return {
      antispamEnabled: map.get("antispamEnabled") as boolean,
      antispamBusinessId: map.get("antispamBusinessId") as string
    };
  }

  private convertToAIModelStreamCallStopParams(map: Map<string, Any>): V2NIMAIModelStreamCallStopParams {
    return {
      accountId: map.get("accountId") as string,
      requestId: map.get("requestId") as string
    };
  }
}