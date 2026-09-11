/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { V2NIMChatroomClient, V2NIMChatroomQueueElement, V2NIMChatroomQueueOfferParams } from '@nimsdk/chatroom';
import { FLTService } from '../FLTService'; // 假设基础服务类路径
import CRQueueServiceInternal from '@nimsdk/chatroom/src/main/ets/chatroom/internal/CRQueueServiceInternal';

export class FLTChatroomQueueService extends FLTService {
  private serviceNameTag: string = "V2NIMChatroomQueueService";

  get serviceName(): string {
    return this.serviceNameTag;
  }

  onInitialized(): void {
    Log.d(this.serviceName, "onInitialized");
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    Log.d(this.serviceName, `onMethodCall: ${method}`);
    switch (method) {
      case "addQueueListener":
        this.addQueueListener(args, result);
        break;
      case "removeQueueListener":
        this.removeQueueListener(args, result);
        break;
      case "queueOffer":
        this.queueOffer(args, result);
        break;
      case "queuePoll":
        this.queuePoll(args, result);
        break;
      case "queueList":
        this.queueList(args, result);
        break;
      case "queuePeek":
        this.queuePeek(args, result);
        break;
      case "queueDrop":
        this.queueDrop(args, result);
        break;
      case "queueInit":
        this.queueInit(args, result);
        break;
      case "queueBatchUpdate":
        this.queueBatchUpdate(args, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private addQueueListener(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId = args.get("instanceId") as number;
      if (instanceId === undefined) {
        this.onErrorWithCode(result, -1, "Invalid instanceId");
        return;
      }

      const chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.queueService;
      if (!chatroomQueueService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }
      this.createQueueListener(instanceId, chatroomQueueService);
      this.onSuccess(result, null);
    } catch (e) {
      this.onError(result, e);
    }
  }

  private removeQueueListener(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId = args.get("instanceId") as number;
      if (instanceId === undefined) {
        this.onErrorWithCode(result, -1, "Invalid instanceId");
        return;
      }

      const chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.queueService;
      if (!chatroomQueueService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }
      this.offQueueListener(instanceId, chatroomQueueService)
      this.onSuccess(result, null);
    } catch (e) {
      this.onError(result, e);
    }
  }

  private queueOffer(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId = args.get("instanceId") as number;
      const offerParamsMap: Map<string, Any> = args.get("offerParams") as Map<string, Any>;

      if (instanceId === undefined || !offerParamsMap) {
        this.onErrorWithCode(result, -1, "Invalid queue params");
        return;
      }

      const chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.queueService;
      if (!chatroomQueueService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const offerParams = this.convertToOfferParams(offerParamsMap);

      chatroomQueueService.queueOffer(offerParams)
        .then(() => this.onSuccess(result, null))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private queuePoll(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId = args.get("instanceId") as number;
      const elementKey = args.get("elementKey") as string;

      if (instanceId === undefined) {
        this.onErrorWithCode(result, -1, "Invalid queue params");
        return;
      }

      const chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.queueService;
      if (!chatroomQueueService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      chatroomQueueService.queuePoll(elementKey)
        .then((element) => this.onSuccess(result, new Map(Object.entries(element))))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private queueList(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId = args.get("instanceId") as number;
      if (instanceId === undefined) {
        this.onErrorWithCode(result, -1, "Invalid queue params");
        return;
      }

      const chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.queueService;
      if (!chatroomQueueService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      chatroomQueueService.queueList()
        .then((elements) => {
          let elData: Any[] = elements.map(element => new Map(Object.entries(element)))
          this.onSuccess(result, new Map<string, Any>().set("elements", elData));
        })
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private queuePeek(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId = args.get("instanceId") as number;
      if (instanceId === undefined) {
        this.onErrorWithCode(result, -1, "Invalid queue params");
        return;
      }

      const chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.queueService;
      if (!chatroomQueueService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      chatroomQueueService.queuePeek()
        .then((element) => this.onSuccess(result, new Map(Object.entries(element))))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private queueDrop(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId = args.get("instanceId") as number;
      if (instanceId === undefined) {
        this.onErrorWithCode(result, -1, "Invalid queue params");
        return;
      }

      const chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.queueService;
      if (!chatroomQueueService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      chatroomQueueService.queueDrop()
        .then(() => this.onSuccess(result, null))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private queueInit(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId = args.get("instanceId") as number;
      const size = args.get("size") as number;

      if (instanceId === undefined || size === undefined) {
        this.onErrorWithCode(result, -1, "Invalid queue params");
        return;
      }

      const chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.queueService;
      if (!chatroomQueueService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      chatroomQueueService.queueInit(size)
        .then(() => this.onSuccess(result, null))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private queueBatchUpdate(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId = args.get("instanceId") as number;
      const elementsMap: Array<Map<string, Any>> = args.get("elements") as Array<Map<string, Any>>;
      const notificationEnabled = args.get("notificationEnabled") as boolean ?? true;
      const notificationExtension = args.get("notificationExtension") as string;

      if (instanceId === undefined || !elementsMap) {
        this.onErrorWithCode(result, -1, "Invalid queue params");
        return;
      }

      const chatroomQueueService = V2NIMChatroomClient.getInstance(instanceId)?.queueService;
      if (!chatroomQueueService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const elements: V2NIMChatroomQueueElement[] = [];
      elementsMap.map((el: Map<string, Any>) => {
        elements.push(this.convertToQueueElement(el))
      })

      chatroomQueueService.queueBatchUpdate(elements, notificationEnabled, notificationExtension)
        .then((notExistKeys) => {
          this.onSuccess(result, new Map<string, Any>().set("notExistKeys", notExistKeys));
        })
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  // 创建队列监听器并转发事件
  private createQueueListener(instanceId: number, queueService: CRQueueServiceInternal) {
    queueService.on("onChatroomQueueOffered", (element: V2NIMChatroomQueueElement) => {
      let resultMap: Map<string, Any> = new Map<string, Any>();
      resultMap.set("instanceId", instanceId);
      resultMap.set("element", new Map(Object.entries(element)));
      this.notifyEvent("onChatroomQueueOffered", resultMap);
    })
    queueService.on("onChatroomQueuePolled", (element: V2NIMChatroomQueueElement) => {
      let resultMap: Map<string, Any> = new Map<string, Any>();
      resultMap.set("instanceId", instanceId);
      resultMap.set("element", new Map(Object.entries(element)));
      this.notifyEvent("onChatroomQueuePolled", resultMap);
    })
    queueService.on("onChatroomQueueDropped", () => {
      let resultMap: Map<string, Any> = new Map<string, Any>();
      resultMap.set("instanceId", instanceId);
      this.notifyEvent("onChatroomQueueDropped", resultMap);
    })
    queueService.on("onChatroomQueuePartCleared", (elements: V2NIMChatroomQueueElement[]) => {
      let resultMap: Map<string, Any> = new Map<string, Any>();
      resultMap.set("instanceId", instanceId);
      resultMap.set("elements", elements.map(e => new Map(Object.entries(e))));
      this.notifyEvent("onChatroomQueuePartCleared", resultMap);
    })
    queueService.on("onChatroomQueueBatchUpdated", (elements: V2NIMChatroomQueueElement[]) => {
      let resultMap: Map<string, Any> = new Map<string, Any>();
      resultMap.set("instanceId", instanceId);
      resultMap.set("elements", elements.map(e => new Map(Object.entries(e))));
      this.notifyEvent("onChatroomQueueBatchUpdated", resultMap);
    })
    queueService.on("onChatroomQueueBatchOffered", (elements: V2NIMChatroomQueueElement[]) => {
      let resultMap: Map<string, Any> = new Map<string, Any>();
      resultMap.set("instanceId", instanceId);
      resultMap.set("elements", elements.map(e => new Map(Object.entries(e))));
      this.notifyEvent("onChatroomQueueBatchOffered", resultMap);
    }
    )
  }

  // 创建队列监听器并转发事件
  private offQueueListener(instanceId: number, queueService: CRQueueServiceInternal) {
    queueService.off("onChatroomQueueOffered", null)
    queueService.off("onChatroomQueuePolled", null)
    queueService.off("onChatroomQueueDropped", null)
    queueService.off("onChatroomQueuePartCleared", null)
    queueService.off("onChatroomQueueBatchUpdated", null)
    queueService.off("onChatroomQueueBatchOffered", null)
  }

  /**
   * 转换为聊天室队列元素对象
   * @param map 包含队列元素数据的Map
   * @returns 类型安全的V2NIMChatroomQueueElement对象
   */
  private convertToQueueElement(map: Map<string, Any>): V2NIMChatroomQueueElement {
    // 显式初始化所有属性为undefined，匹配接口定义
    const queueElement: V2NIMChatroomQueueElement = {
      key: '',
      value: ''
    };

    // 处理队列元素key
    if (map.get("key") !== undefined && map.get("key") !== null) {
      queueElement.key = map.get("key") as string;
    }

    // 处理队列元素value
    if (map.get("value") !== undefined && map.get("value") !== null) {
      queueElement.value = map.get("value") as string;
    }

    // 处理账号ID
    if (map.get("accountId") !== undefined && map.get("accountId") !== null) {
      queueElement.accountId = map.get("accountId") as string;
    }

    // 处理昵称
    if (map.get("nick") !== undefined && map.get("nick") !== null) {
      queueElement.nick = map.get("nick") as string;
    }

    return queueElement;
  }

  /**
   * 转换为入队参数对象
   * @param map 包含入队参数数据的Map
   * @returns 类型安全的V2NIMChatroomQueueOfferParams对象
   */
  private convertToOfferParams(map: Map<string, Any>): V2NIMChatroomQueueOfferParams {
    // 显式初始化所有属性，可选属性设为undefined，有默认值的属性设为默认值
    const offerParams: V2NIMChatroomQueueOfferParams = {
      elementKey: '',
      elementValue: ''
    };

    // 处理元素key
    if (map.get("elementKey") !== undefined && map.get("elementKey") !== null) {
      offerParams.elementKey = map.get("elementKey") as string;
    }

    // 处理元素value
    if (map.get("elementValue") !== undefined && map.get("elementValue") !== null) {
      offerParams.elementValue = map.get("elementValue") as string;
    }

    // 处理transient属性（保留默认值，仅当有有效值时覆盖）
    if (map.get("transient") !== undefined && map.get("transient") !== null) {
      offerParams.transient = map.get("transient") as boolean;
    }

    // 处理元素所有者账号ID
    if (map.get("elementOwnerAccountId") !== undefined && map.get("elementOwnerAccountId") !== null) {
      offerParams.elementOwnerAccountId = map.get("elementOwnerAccountId") as string;
    }

    return offerParams;
  }
}