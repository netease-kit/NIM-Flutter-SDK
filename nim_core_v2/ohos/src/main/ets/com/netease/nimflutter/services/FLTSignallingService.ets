/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import {
  V2NIMError,
  V2NIMSignallingAcceptInviteParams,
  V2NIMSignallingCallParams,
  V2NIMSignallingCallSetupParams,
  V2NIMSignallingCancelInviteParams,
  V2NIMSignallingChannelType,
  V2NIMSignallingEvent,
  V2NIMSignallingInviteParams,
  V2NIMSignallingJoinParams,
  V2NIMSignallingRejectInviteParams,
  V2NIMSignallingRoomInfo
} from '@nimsdk/base';
import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';
import { convertMap2SignallingConfig } from '../model/signalling/V2NIMSignallingConfig';
import { convertMap2SignallingPushConfig } from '../model/signalling/V2NIMSignallingPushConfig';
import { convertMap2SignallingRtcConfig } from '../model/signalling/V2NIMSignallingRtcConfig';

export class FLTSignallingService extends FLTService {
  get serviceName(): string {
    return "SignallingService";
  }

  onInitialized(): void {
    // notifyEvent
    Log.d(this.serviceName, "onInitialized");
    this.nim.signallingService?.on("onOnlineEvent", (event: V2NIMSignallingEvent) => {
      Log.d(this.serviceName, "onOnlineEvent:" + event.operatorAccountId)
      this.notifyEvent("onOnlineEvent", new Map(Object.entries(event))
      )
    });
    this.nim.signallingService?.on("onOfflineEvent", (eventList: V2NIMSignallingEvent[]) => {
      Log.d(this.serviceName, "onOfflineEvent:")
      this.notifyEvent("onOfflineEvent", new Map<string, Any>().set(
        "offlineEvents", eventList
      )
      )
    });
    this.nim.signallingService?.on("onMultiClientEvent", (event: V2NIMSignallingEvent) => {
      Log.d(this.serviceName, "onMultiClientEvent:" + event.operatorAccountId)
      this.notifyEvent("onMultiClientEvent", new Map(Object.entries(event))
      )
    });

    this.nim.signallingService?.on("onSyncRoomInfoList", (roomInfoList: V2NIMSignallingRoomInfo[]) => {
      Log.d(this.serviceName, "onSyncRoomInfoList:")
      this.notifyEvent("onSyncRoomInfoList", new Map<string, Any>().set(
        "syncRoomInfoList", roomInfoList
      )
      )
    });
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    switch (method) {
      case "call":
        this.call(args, result);
        break;
      case "callSetup":
        this.callSetup(args, result);
        break;
      case "createRoom":
        this.createRoom(args, result);
        break;
      case "closeRoom":
        this.closeRoom(args, result);
        break;
      case "joinRoom":
        this.joinRoom(args, result);
        break;
      case "leaveRoom":
        this.leaveRoom(args, result);
        break;
      case "invite":
        this.invite(args, result);
        break;
      case "cancelInvite":
        this.cancelInvite(args, result);
        break;
      case "rejectInvite":
        this.rejectInvite(args, result);
        break;
      case "acceptInvite":
        this.acceptInvite(args, result);
        break;
      case "sendControl":
        this.sendControl(args, result);
        break;
      case "getRoomInfoByChannelName":
        this.getRoomInfoByChannelName(args, result);
        break;
    }
  }

  private call(argument: Map<string, Any>, result: MethodResult) {
    let paramsMap = argument.get("params") as Map<string, string | number | undefined | object>;
    let params: V2NIMSignallingCallParams = {
      calleeAccountId: '',
      requestId: '',
      channelType: V2NIMSignallingChannelType.V2NIM_SIGNALLING_CHANNEL_TYPE_AUDIO
    };
    if (paramsMap.get("channelType") !== undefined && paramsMap.get("channelType") !== null) {
      params.channelType = paramsMap.get("channelType") as number;
    }
    if (paramsMap.get("calleeAccountId") !== undefined && paramsMap.get("calleeAccountId") !== null) {
      params.calleeAccountId = paramsMap.get("calleeAccountId") as string;
    }
    if (paramsMap.get("requestId") !== undefined && paramsMap.get("requestId") !== null) {
      params.requestId = paramsMap.get("requestId") as string;
    }
    if (paramsMap.get("channelName") !== undefined && paramsMap.get("channelName") !== null) {
      params.channelName = paramsMap.get("channelName") as string;
    }
    if (paramsMap.get("channelExtension") !== undefined && paramsMap.get("channelExtension") !== null) {
      params.channelExtension = paramsMap.get("channelExtension") as string;
    }
    if (paramsMap.get("serverExtension") !== undefined && paramsMap.get("serverExtension") !== null) {
      params.serverExtension = paramsMap.get("serverExtension") as string;
    }

    if (paramsMap.get("signallingConfig") !== undefined && paramsMap.get("signallingConfig") !== null) {
      let signallingConfigMap: Map<string, undefined | number | boolean | null>
        = paramsMap.get("signallingConfig") as Map<string, undefined | number | boolean | null>;
      params.signallingConfig = convertMap2SignallingConfig(signallingConfigMap);
    }

    if (paramsMap.get("pushConfig") !== undefined && paramsMap.get("pushConfig") !== null) {
      let pushConfigMap: Map<string, undefined | string | boolean | null>
        = paramsMap.get("pushConfig") as Map<string, undefined | string | boolean | null>;
      params.pushConfig = convertMap2SignallingPushConfig(pushConfigMap);
    }

    if (paramsMap.get("rtcConfig") !== undefined && paramsMap.get("rtcConfig") !== null) {
      let rtcConfigMap: Map<string, undefined | string | boolean | null>
        = paramsMap.get("rtcConfig") as Map<string, undefined | string | boolean | null>;
      params.rtcConfig = convertMap2SignallingRtcConfig(rtcConfigMap);
    }

    this.nim.signallingService?.call(params).then((callResult) => {
      this.onSuccess(result, new Map(Object.entries(callResult)))
    })
      .catch((e: V2NIMError) => {
        this.onError(result, e)
      })
  }


  private callSetup(argument: Map<string, Any>, result: MethodResult) {
    let paramsMap = argument.get("params") as Map<string, string | number | undefined | null | object>;
    let params: V2NIMSignallingCallSetupParams = {
      channelId: '',
      callerAccountId: '',
      requestId: ''
    };
    if (paramsMap.get("channelId") !== undefined && paramsMap.get("channelId") !== null) {
      params.channelId = paramsMap.get("channelId") as string;
    }
    if (paramsMap.get("callerAccountId") !== undefined && paramsMap.get("callerAccountId") !== null) {
      params.callerAccountId = paramsMap.get("callerAccountId") as string;
    }
    if (paramsMap.get("requestId") !== undefined && paramsMap.get("requestId") !== null) {
      params.requestId = paramsMap.get("requestId") as string;
    }

    if (paramsMap.get("serverExtension") !== undefined && paramsMap.get("serverExtension") !== null) {
      params.serverExtension = paramsMap.get("serverExtension") as string;
    }

    if (paramsMap.get("signallingConfig") !== undefined && paramsMap.get("signallingConfig") !== null) {
      let signallingConfigMap: Map<string, undefined | number | boolean | null>
        = paramsMap.get("signallingConfig") as Map<string, undefined | number | boolean | null>;
      params.signallingConfig = convertMap2SignallingConfig(signallingConfigMap);
    }

    if (paramsMap.get("rtcConfig") !== undefined && paramsMap.get("rtcConfig") !== null) {
      let rtcConfigMap: Map<string, undefined | string | boolean | null>
        = paramsMap.get("rtcConfig") as Map<string, undefined | string | boolean | null>;
      params.rtcConfig = convertMap2SignallingRtcConfig(rtcConfigMap);
    }
    this.nim.signallingService?.callSetup(params).then((callResult) => {
      if (typeof callResult.rtcInfo?.rtcTokenTtl === 'string') {
        callResult.rtcInfo.rtcTokenTtl = Number.parseInt(callResult.rtcInfo.rtcTokenTtl);
      }
      this.onSuccess(result, new Map(Object.entries(callResult)))
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private createRoom(argument: Map<string, Any>, result: MethodResult) {
    let channelType = argument.get("channelType") as number;
    let channelName = argument.get("channelName") as string | null | undefined;
    let channelExtension = argument.get("channelExtension") as string | null | undefined;
    this.nim.signallingService?.createRoom(channelType, channelName === null ? undefined : channelName,
      channelExtension === null ? undefined : channelExtension).then((channelInfo) => {
      this.onSuccess(result, new Map(Object.entries(channelInfo)))
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private closeRoom(argument: Map<string, Any>, result: MethodResult) {
    let channelId = argument.get("channelId") as string;
    let offlineEnabled = argument.get("offlineEnabled") as boolean | null | undefined;
    let serverExtension = argument.get("serverExtension") as string | null | undefined;
    this.nim.signallingService?.closeRoom(channelId, offlineEnabled === null ? undefined : offlineEnabled,
      serverExtension === null ? undefined : serverExtension).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private joinRoom(argument: Map<string, Any>, result: MethodResult) {
    let paramsMap = argument.get("params") as Map<string, string | number | undefined | null | object>;
    let params: V2NIMSignallingJoinParams = {
      channelId: ''
    };
    if (paramsMap.get("channelId") !== undefined && paramsMap.get("channelId") !== null) {
      params.channelId = paramsMap.get("channelId") as string;
    }

    if (paramsMap.get("serverExtension") !== undefined && paramsMap.get("serverExtension") !== null) {
      params.serverExtension = paramsMap.get("serverExtension") as string;
    }

    if (paramsMap.get("signallingConfig") !== undefined && paramsMap.get("signallingConfig") !== null) {
      let signallingConfigMap: Map<string, undefined | number | boolean | null>
        = paramsMap.get("signallingConfig") as Map<string, undefined | number | boolean | null>;
      params.signallingConfig = convertMap2SignallingConfig(signallingConfigMap);
    }

    if (paramsMap.get("rtcConfig") !== undefined && paramsMap.get("rtcConfig") !== null) {
      let rtcConfigMap: Map<string, undefined | string | boolean | null>
        = paramsMap.get("rtcConfig") as Map<string, undefined | string | boolean | null>;
      params.rtcConfig = convertMap2SignallingRtcConfig(rtcConfigMap);
    }
    this.nim.signallingService?.joinRoom(params).then((callResult) => {
      if (typeof callResult.rtcInfo.rtcTokenTtl === 'string') {
        callResult.rtcInfo.rtcTokenTtl = Number.parseInt(callResult.rtcInfo.rtcTokenTtl);
      }
      this.onSuccess(result, new Map(Object.entries(callResult)))
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private leaveRoom(argument: Map<string, Any>, result: MethodResult) {
    let channelId = argument.get("channelId") as string;
    let offlineEnabled = argument.get("offlineEnabled") as boolean | null | undefined;
    let serverExtension = argument.get("serverExtension") as string | null | undefined;
    this.nim.signallingService?.leaveRoom(channelId, offlineEnabled === null?undefined:offlineEnabled,
      serverExtension === null ? undefined:serverExtension).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private invite(argument: Map<string, Any>, result: MethodResult) {
    let paramsMap = argument.get("params") as Map<string, string | number | undefined | null | object>;
    let params: V2NIMSignallingInviteParams = {
      channelId: '',
      inviteeAccountId: '',
      requestId: ''
    };
    if (paramsMap.get("channelId") !== undefined && paramsMap.get("channelId") !== null) {
      params.channelId = paramsMap.get("channelId") as string;
    }
    if (paramsMap.get("inviteeAccountId") !== undefined && paramsMap.get("inviteeAccountId") !== null) {
      params.inviteeAccountId = paramsMap.get("inviteeAccountId") as string;
    }
    if (paramsMap.get("requestId") !== undefined && paramsMap.get("requestId") !== null) {
      params.requestId = paramsMap.get("requestId") as string;
    }
    if (paramsMap.get("serverExtension") !== undefined && paramsMap.get("serverExtension") !== null) {
      params.serverExtension = paramsMap.get("serverExtension") as string;
    }

    if (paramsMap.get("signallingConfig") !== undefined && paramsMap.get("signallingConfig") !== null) {
      let signallingConfigMap: Map<string, undefined | number | boolean | null>
        = paramsMap.get("signallingConfig") as Map<string, undefined | number | boolean | null>;
      params.signallingConfig = convertMap2SignallingConfig(signallingConfigMap);
    }

    if (paramsMap.get("pushConfig") !== undefined && paramsMap.get("pushConfig") !== null) {
      let pushConfigMap: Map<string, undefined | string | boolean | null>
        = paramsMap.get("pushConfig") as Map<string, undefined | string | boolean | null>;
      params.pushConfig = convertMap2SignallingPushConfig(pushConfigMap);
    }

    this.nim.signallingService?.invite(params).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private cancelInvite(argument: Map<string, Any>, result: MethodResult) {
    let paramsMap = argument.get("params") as Map<string, string | number | undefined | null | object | boolean>;
    let params: V2NIMSignallingCancelInviteParams = {
      channelId: '',
      inviteeAccountId: '',
      requestId: ''
    };
    if (paramsMap.get("channelId") !== undefined && paramsMap.get("channelId") !== null) {
      params.channelId = paramsMap.get("channelId") as string;
    }
    if (paramsMap.get("inviteeAccountId") !== undefined && paramsMap.get("inviteeAccountId") !== null) {
      params.inviteeAccountId = paramsMap.get("inviteeAccountId") as string;
    }
    if (paramsMap.get("requestId") !== undefined && paramsMap.get("requestId") !== null) {
      params.requestId = paramsMap.get("requestId") as string;
    }
    if (paramsMap.get("serverExtension") !== undefined && paramsMap.get("serverExtension") !== null) {
      params.serverExtension = paramsMap.get("serverExtension") as string;
    }

    if (paramsMap.get("offlineEnabled") !== undefined && paramsMap.get("offlineEnabled") !== null) {
      params.offlineEnabled = paramsMap.get("offlineEnabled") as boolean;
    }

    if (paramsMap.get("pushConfig") !== undefined && paramsMap.get("pushConfig") !== null) {
      let pushConfigMap: Map<string, undefined | string | boolean | null>
        = paramsMap.get("pushConfig") as Map<string, undefined | string | boolean | null>;
      params.pushConfig = convertMap2SignallingPushConfig(pushConfigMap);
    }

    this.nim.signallingService?.cancelInvite(params).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private rejectInvite(argument: Map<string, Any>, result: MethodResult) {
    let paramsMap = argument.get("params") as Map<string, string | number | undefined | null | object | boolean>;
    let params: V2NIMSignallingRejectInviteParams = {
      channelId: '',
      inviterAccountId: '',
      requestId: ''
    };
    if (paramsMap.get("channelId") !== undefined && paramsMap.get("channelId") !== null) {
      params.channelId = paramsMap.get("channelId") as string;
    }
    if (paramsMap.get("inviterAccountId") !== undefined && paramsMap.get("inviterAccountId") !== null) {
      params.inviterAccountId = paramsMap.get("inviterAccountId") as string;
    }
    if (paramsMap.get("requestId") !== undefined && paramsMap.get("requestId") !== null) {
      params.requestId = paramsMap.get("requestId") as string;
    }
    if (paramsMap.get("serverExtension") !== undefined && paramsMap.get("serverExtension") !== null) {
      params.serverExtension = paramsMap.get("serverExtension") as string;
    }

    if (paramsMap.get("offlineEnabled") !== undefined && paramsMap.get("offlineEnabled") !== null) {
      params.offlineEnabled = paramsMap.get("offlineEnabled") as boolean;
    }

    this.nim.signallingService?.rejectInvite(params).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private acceptInvite(argument: Map<string, Any>, result: MethodResult) {
    let paramsMap = argument.get("params") as Map<string, string | number | undefined | null | object | boolean>;
    let params: V2NIMSignallingAcceptInviteParams = {
      channelId: '',
      inviterAccountId: '',
      requestId: ''
    };
    if (paramsMap.get("channelId") !== undefined && paramsMap.get("channelId") !== null) {
      params.channelId = paramsMap.get("channelId") as string;
    }
    if (paramsMap.get("inviterAccountId") !== undefined && paramsMap.get("inviterAccountId") !== null) {
      params.inviterAccountId = paramsMap.get("inviterAccountId") as string;
    }
    if (paramsMap.get("requestId") !== undefined && paramsMap.get("requestId") !== null) {
      params.requestId = paramsMap.get("requestId") as string;
    }
    if (paramsMap.get("serverExtension") !== undefined && paramsMap.get("serverExtension") !== null) {
      params.serverExtension = paramsMap.get("serverExtension") as string;
    }

    if (paramsMap.get("offlineEnabled") !== undefined && paramsMap.get("offlineEnabled") !== null) {
      params.offlineEnabled = paramsMap.get("offlineEnabled") as boolean;
    }

    this.nim.signallingService?.acceptInvite(params).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private sendControl(argument: Map<string, Any>, result: MethodResult) {
    let channelId = argument.get("channelId") as string;
    let receiverAccountId = argument.get("receiverAccountId") as string | null | undefined;
    let serverExtension = argument.get("serverExtension") as string | null | undefined;
    this.nim.signallingService?.sendControl(channelId, receiverAccountId, serverExtension).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private getRoomInfoByChannelName(argument: Map<string, Any>, result: MethodResult) {
    let channelName = argument.get("channelName") as string;
    this.nim.signallingService?.getRoomInfoByChannelName(channelName).then((roomInfo) => {
      this.onSuccess(result, new Map(Object.entries(roomInfo)))
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }
}