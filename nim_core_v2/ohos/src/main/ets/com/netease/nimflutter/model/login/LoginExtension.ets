/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import { V2NIMDataSyncDetail, V2NIMKickedOfflineDetail, V2NIMLoginClient, V2NIMLoginClientType } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function loginClientToJson(client: V2NIMLoginClient): Map<string, Any> {
  const clientMap: Map<string, Any> = new Map<string, Any>();
  clientMap.set('type', client.type.valueOf());
  clientMap.set('os', client.os);
  clientMap.set('timestamp', client.timestamp);
  if (client.customTag !== undefined) {
    clientMap.set('customTag', client.customTag);
  }
  if (client.customClientType !== undefined) {
    clientMap.set('customClientType', client.customClientType);
  }
  clientMap.set('clientId', client.clientId);
  if (client.clientIP !== undefined) {
    clientMap.set('clientIP', client.clientIP);
  }
  return clientMap;
}

export function dataSyncDetailToJson(client: V2NIMDataSyncDetail): Map<string, Any> {
  const clientMap: Map<string, Any> = new Map<string, Any>();
  clientMap.set('type', client.type.valueOf());
  clientMap.set('state', client.state.valueOf());
  return clientMap;
}

export function fromJsonLoginClient(map: Map<string, Any> | null | undefined): V2NIMLoginClient {
  // 初始化所有字段的默认值
  let clientType: V2NIMLoginClientType = V2NIMLoginClientType.V2NIM_LOGIN_CLIENT_TYPE_UNKNOWN;
  let os: string = '';
  let timestamp: number = 0;
  let clientId: string = '';
  let customTag: string | undefined = undefined;
  let customClientType: number | undefined = undefined;
  let clientIP: string | undefined = undefined;

  if (map) {
    // 处理type字段（枚举类型）
    const typeValue = map.get('type') as number | undefined;
    if (typeValue !== undefined && Object.values(V2NIMLoginClientType).includes(typeValue as V2NIMLoginClientType)) {
      clientType = typeValue as V2NIMLoginClientType;
    }

    // 处理timestamp字段（数字类型）
    const timestampRaw = map.get('timestamp') as number;
    timestamp = typeof timestampRaw === 'number' ? timestampRaw : Number(timestampRaw) || 0;

    // 处理os字段（字符串类型）
    const osRaw = map.get('os') as string | undefined;
    os = osRaw !== undefined ? osRaw : '';

    // 处理clientId字段（字符串类型）
    const clientIdRaw = map.get('clientId') as string | undefined;
    clientId = clientIdRaw !== undefined ? clientIdRaw : '';

    // 处理customTag（可选字符串）
    if (map.has('customTag')) {
      const tagRaw = map.get('customTag') as string | undefined;
      customTag = tagRaw !== undefined ? tagRaw : undefined;
    }

    // 处理customClientType（可选数字）
    if (map.has('customClientType')) {
      customClientType = map.get('customClientType') as number | undefined;
    }

    // 处理clientIP（可选字符串）
    if (map.has('clientIP')) {
      const ipRaw = map.get('clientIP') as string | undefined;
      clientIP = ipRaw !== undefined ? ipRaw : undefined;
    }
  }

  // 构建并返回V2NIMLoginClient对象
  return {
    type: clientType,
    os: os,
    timestamp: timestamp,
    clientId: clientId,
    customTag: customTag,
    customClientType: customClientType,
    clientIP: clientIP
  };
}

/**
 * 将V2NIMKickedOfflineDetail对象转换为Map
 * @param detail 待转换的下线详情对象
 * @returns 转换后的Map<string, any>
 */
export function convertKickedOfflineDetailToMap(detail: V2NIMKickedOfflineDetail): Map<string, Any> {
  // 初始化Map
  const detailMap: Map<string, Any> = new Map<string, Any>();

  // if (detail || detail == null) {
  //   return detailMap;
  // }
  // 处理reason字段（枚举类型，存储其数值）
  let reasonValue: number = 0;
  reasonValue = detail.reason.valueOf();
  detailMap.set('reason', reasonValue);

  // 处理reasonDesc字段（字符串类型）
  let reasonDesc: string = '';
  reasonDesc = detail.reasonDesc;
  detailMap.set('reasonDesc', reasonDesc);

  // 处理clientType字段（枚举类型，存储其数值）
  let clientTypeValue: number = 0;
  clientTypeValue = detail.clientType.valueOf();
  detailMap.set('clientType', clientTypeValue);

  // 处理customClientType字段（数字类型）
  let customClientType: number = 0;
  customClientType = detail.customClientType;
  detailMap.set('customClientType', customClientType);

  return detailMap;
}
