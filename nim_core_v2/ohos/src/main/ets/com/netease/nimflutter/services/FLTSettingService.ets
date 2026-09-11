/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import { V2NIMDndConfig, V2NIMError,
  V2NIMP2PMessageMuteMode,
  V2NIMTeamMessageMuteMode, V2NIMTeamType } from '@nimsdk/base';
import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';

export class FLTSettingService extends FLTService {
  get serviceName(): string {
    return "SettingsService";
  }

  onInitialized(): void {
    // notifyEvent
    Log.d(this.serviceName, "onInitialized");
    this.nim.settingService?.on("onTeamMessageMuteModeChanged", (teamId: string,
      teamType: V2NIMTeamType,
      muteMode: V2NIMTeamMessageMuteMode) => {
      Log.d(this.serviceName, "onTeamMessageMuteModeChanged:" + teamId)
      this.notifyEvent("onTeamMessageMuteModeChanged", new Map<string, Any>(
        [
          ["teamId", teamId],
          ["teamType", teamType.valueOf()],
          ["muteMode", muteMode.valueOf()],
        ]
      )
      )
    });
    this.nim.settingService?.on("onP2PMessageMuteModeChanged", (accountId: string,
      muteMode: V2NIMP2PMessageMuteMode) => {
      Log.d(this.serviceName, "onP2PMessageMuteModeChanged:" + accountId)
      this.notifyEvent("onP2PMessageMuteModeChanged", new Map<string, Any>(
        [
          ["accountId", accountId],
          ["muteMode", muteMode.valueOf()],
        ]
      )
      )
    });
    this.nim.settingService?.on("onPushMobileOnDesktopOnline", (need: boolean) => {
      Log.d(this.serviceName, "onPushMobileOnDesktopOnline:" + need)
      this.notifyEvent("onPushMobileOnDesktopOnline", new Map<string, Any>(
        [
          ["need", need]
        ]
      )
      )
    });
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    switch (method) {
      case "getDndConfig":
        this.getDndConfig(args, result);
        break;
      case "getConversationMuteStatus":
        this.getConversationMuteStatus(args, result);
        break;
      case "getP2PMessageMuteList":
        this.getP2PMessageMuteList(args, result);
        break;
      case "getP2PMessageMuteMode":
        this.getP2PMessageMuteMode(args, result);
        break;
      case "getTeamMessageMuteMode":
        this.getTeamMessageMuteMode(args, result);
        break;
      case "setDndConfig":
        this.setDndConfig(args, result);
        break;
      case "setP2PMessageMuteMode":
        this.setP2PMessageMuteMode(args, result);
        break;
      case "setPushMobileOnDesktopOnline":
        this.setPushMobileOnDesktopOnline(args, result);
        break;
      case "getPushMobileOnDesktopOnline":
        this.getPushMobileOnDesktopOnline(args, result);
        break;
      case "setTeamMessageMuteMode":
        this.setTeamMessageMuteMode(args, result);
        break;
    }
  }

  private getDndConfig(argument:Map<string, Any>, result: MethodResult){
    this.nim.settingService?.getDndConfig().then((config) => {
      this.onSuccess(result, new Map(Object.entries(config)));
    })
    .catch((e: V2NIMError) => {
      this.onError(result, e)
    })
  }

  
  private getConversationMuteStatus(argument:Map<string, Any>, result: MethodResult){
    let conversationId = argument.get("conversationId") as string;
    this.nim.settingService?.getConversationMuteStatus(conversationId).then((mute) => {
      this.onSuccess(result, mute)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private getP2PMessageMuteList(argument:Map<string, Any>, result: MethodResult){
    this.nim.settingService?.getP2PMessageMuteList().then((muteList) => {
      this.onSuccess(result, {"muteList":muteList})
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private getP2PMessageMuteMode(argument:Map<string, Any>, result: MethodResult){
    let accountId = argument.get("accountId") as string;
    this.nim.settingService?.getP2PMessageMuteMode(accountId).then((muteMode) => {
      this.onSuccess(result, { "muteMode":muteMode })
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private getTeamMessageMuteMode(argument:Map<string, Any>, result: MethodResult){
    let teamId = argument.get("teamId") as string;
    let teamType = argument.get("teamType") as number;
    this.nim.settingService?.getTeamMessageMuteMode(teamId,teamType).then((muteMode) => {
      this.onSuccess(result, { "muteMode":muteMode })
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private setDndConfig(argument:Map<string, Any>, result: MethodResult){
    let configMap = argument.get("config") as Map<string, string | boolean | number | undefined>;
    let config:V2NIMDndConfig = {};
    if(configMap.get("showDetail") !== undefined && configMap.get("showDetail") !== null){
      config.showDetail = configMap.get("showDetail") as boolean;
    }
    if(configMap.get("dndOn") !== undefined && configMap.get("dndOn") !== null){
      config.dndOn = configMap.get("dndOn") as boolean;
    }
    if(configMap.get("fromH") !== undefined && configMap.get("fromH") !== null){
      config.fromH = configMap.get("fromH") as number;
    }
    if(configMap.get("fromM") !== undefined && configMap.get("fromM") !== null){
      config.fromM = configMap.get("fromM") as number;
    }
    if(configMap.get("toH") !== undefined && configMap.get("toH") !== null){
      config.toH = configMap.get("toH") as number;
    }
    if(configMap.get("toM") !== undefined && configMap.get("toM") !== null){
      config.toM = configMap.get("toM") as number;
    }
    this.nim.settingService?.setDndConfig(config).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private setP2PMessageMuteMode(argument:Map<string, Any>, result: MethodResult){
    let accountId = argument.get("accountId") as string;
    let muteMode = argument.get("muteMode") as number;
    this.nim.settingService?.setP2PMessageMuteMode(accountId,muteMode).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private setPushMobileOnDesktopOnline(argument:Map<string, Any>, result: MethodResult){
    let need = argument.get("need") as boolean;
    this.nim.settingService?.setPushMobileOnDesktopOnline(need).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private getPushMobileOnDesktopOnline(argument:Map<string, Any>, result: MethodResult){
    this.nim.settingService?.getPushMobileOnDesktopOnline().then((need) => {
      this.onSuccess(result,need)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private setTeamMessageMuteMode(argument:Map<string, Any>, result: MethodResult){
    let teamId = argument.get("teamId") as string;
    let teamType = argument.get("teamType") as number;
    let muteMode = argument.get("muteMode") as number;
    this.nim.settingService?.setTeamMessageMuteMode(teamId,teamType,muteMode).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

}