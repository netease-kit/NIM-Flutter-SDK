/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */
import {
  V2NIMError,
  V2NIMFriend,
  V2NIMFriendAddApplication,
  V2NIMFriendAddApplicationQueryOption,
  V2NIMFriendAddParams,
  V2NIMFriendAddRejection,
  V2NIMFriendDeleteParams,
  V2NIMFriendDeletionType,
  V2NIMFriendSearchOption,
  V2NIMFriendSetParams
} from '@nimsdk/base';
import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';
import { fromJsonFriendAddApplication } from '../model/friend/FriendExtension';
import { V2NIMFriendImpl } from '@nimsdk/friend/src/main/ets/nim/services/service/V2NIMFriendImpl';

export class FLTFriendService extends FLTService {
  get serviceName(): string {
    return "FriendService";
  }

  onInitialized(): void {
    // notifyEvent
    Log.d(this.serviceName, "onInitialized");
    this.nim.friendService?.on("onFriendAdded", (friend: V2NIMFriend) => {
      Log.d(this.serviceName, "onFriendAdded:" + friend.accountId)
      this.notifyEvent("onFriendAdded", new Map(Object.entries((friend as V2NIMFriendImpl).toJSON()))
      )
    });
    this.nim.friendService?.on("onFriendDeleted", (accountId: string,
      deletionType: V2NIMFriendDeletionType) => {
      Log.d(this.serviceName, "onFriendDeleted:" + accountId)
      this.notifyEvent("onFriendDeleted", new Map<string, Any>(
        [
          ["accountId", accountId],
          ["deletionType", deletionType.valueOf()],
        ]
      )
      )
    });
    this.nim.friendService?.on("onFriendInfoChanged", (friend: V2NIMFriend) => {
      Log.d(this.serviceName, "onFriendInfoChanged:" + friend.accountId)
      this.notifyEvent("onFriendInfoChanged", new Map(Object.entries((friend as V2NIMFriendImpl).toJSON()))
      )
    });
    this.nim.friendService?.on("onFriendAddApplication", (application: V2NIMFriendAddApplication) => {
      Log.d(this.serviceName, "onFriendAddApplication:" + application.applicantAccountId)
      this.notifyEvent("onFriendAddApplication",
        new Map(Object.entries(application))
      )
    });
    this.nim.friendService?.on("onFriendAddRejected", (rejection: V2NIMFriendAddRejection) => {
      Log.d(this.serviceName, "onFriendAddRejected:" + rejection.operatorAccountId)
      this.notifyEvent("onFriendAddRejected",
        new Map(Object.entries(rejection))
      )
    });

  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    switch (method) {
      case "addFriend":
        this.addFriend(args, result)
        break;
      case "deleteFriend":
        this.deleteFriend(args, result)
        break;
      case "acceptAddApplication":
        this.acceptAddApplication(args, result)
        break;
      case "rejectAddApplication":
        this.rejectAddApplication(args, result)
        break;
      case "setFriendInfo":
        this.setFriendInfo(args, result)
        break;
      case "getFriendList":
        this.getFriendList(args, result)
        break;
      case "getFriendByIds":
        this.getFriendByIds(args, result)
        break;
      case "checkFriend":
        this.checkFriend(args, result)
        break;
      case "getAddApplicationList":
        this.getAddApplicationList(args, result)
        break;
      case "getAddApplicationUnreadCount":
        this.getAddApplicationUnreadCount(args, result)
        break;
      case "setAddApplicationRead":
        this.setAddApplicationRead(args, result)
        break;
      case "clearAllAddApplication":
        this.clearAllAddApplication(args, result)
        break;
      case "searchFriendByOption":
        this.searchFriendByOption(args, result)
        break;
      case "deleteAddApplication":
        this.deleteAddApplication(args, result)
        break;
      default:
        result.notImplemented();
        break;
    }

  }


  private addFriend(argument: Map<string, Any>, result: MethodResult) {
    let accountId = argument.get("accountId") as string;
    let paramsMap = argument.get("params") as Map<string, string | undefined | number | null> | null;
    let params: V2NIMFriendAddParams = {
      addMode: 1,
      postscript: ""
    };
    if (paramsMap !== null && paramsMap !== undefined) {
      if (paramsMap.get("addMode") !== null && paramsMap.get("addMode") !== undefined) {
        params.addMode = paramsMap.get("addMode") as number
      }
      if (paramsMap.get("postscript") !== null && paramsMap.get("postscript") !== undefined) {
        params.postscript = paramsMap.get("postscript") as string
      }
    }

    this.nim.friendService?.addFriend(accountId, params).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }


  private deleteFriend(argument: Map<string, Any>, result: MethodResult) {
    let accountId = argument.get("accountId") as string;
    let paramsMap = argument.get("params") as Map<string, string | undefined | boolean | null> | null;
    let params: V2NIMFriendDeleteParams = {
      deleteAlias: false
    };
    if (paramsMap !== null && paramsMap !== undefined) {
      if (paramsMap.get("deleteAlias") !== null && paramsMap.get("deleteAlias") !== undefined) {
        params.deleteAlias = paramsMap.get("deleteAlias") as boolean
      }
    }
    this.nim.friendService?.deleteFriend(accountId, params).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private acceptAddApplication(argument: Map<string, Any>, result: MethodResult) {
    let applicationMap = argument.get("application") as Map<string, undefined | string | boolean | number | null>;
    let application = fromJsonFriendAddApplication(applicationMap);
    this.nim.friendService?.acceptAddApplication(application).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private deleteAddApplication(argument: Map<string, Any>, result: MethodResult) {
    let applicationMap = argument.get("application") as Map<string, undefined | string | boolean | number | null>;
    let application = fromJsonFriendAddApplication(applicationMap);
    this.nim.friendService?.deleteAddApplication(application).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private rejectAddApplication(argument: Map<string, Any>, result: MethodResult) {
    let applicationMap = argument.get("application") as Map<string, undefined | string | boolean | number | null>;
    let application = fromJsonFriendAddApplication(applicationMap);
    let postscript = argument.get("postscript") as string | undefined;
    this.nim.friendService?.rejectAddApplication(application, postscript).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private setFriendInfo(argument: Map<string, Any>, result: MethodResult) {
    let accountId = argument.get("accountId") as string;
    let paramsMap = argument.get("params") as Map<string, string | undefined | null>;
    let params: V2NIMFriendSetParams = {}
    if (paramsMap.get("alias") !== undefined && paramsMap.get("alias") !== null) {
      params.alias = paramsMap.get("alias") as string;
    }

    if (paramsMap.get("serverExtension") !== undefined && paramsMap.get("serverExtension") !== null) {
      params.serverExtension = paramsMap.get("serverExtension") as string;
    }
    this.nim.friendService?.setFriendInfo(accountId, params).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private getFriendList(argument: Map<string, Any>, result: MethodResult) {
    this.nim.friendService?.getFriendList().then((friendList) => {
      this.onSuccess(result,
        {
          "friendList": friendList.map(friend => (friend as V2NIMFriendImpl).toJSON())
        })
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private getFriendByIds(argument: Map<string, Any>, result: MethodResult) {
    let accountIds = argument.get("accountIds") as string[];
    this.nim.friendService?.getFriendByIds(accountIds).then((friendList) => {
      this.onSuccess(result,
        {
          "friendList": friendList.map(friend => (friend as V2NIMFriendImpl).toJSON())
        })
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private checkFriend(argument: Map<string, Any>, result: MethodResult) {
    let accountIds = argument.get("accountIds") as string[];
    this.nim.friendService?.checkFriend(accountIds).then((friendResult) => {
      this.onSuccess(result,
        { "result": friendResult })
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private getAddApplicationList(argument: Map<string, Any>, result: MethodResult) {
    let optionMap = argument.get("option") as Map<string, string | undefined | number | null | []>;
    let option: V2NIMFriendAddApplicationQueryOption = {
      status: []
    };

    if (optionMap.get("offset") !== undefined && optionMap.get("offset") !== null) {
      option.offset = optionMap.get("offset") as number;
    }

    if (optionMap.get("limit") !== undefined && optionMap.get("limit") !== null) {
      option.limit = optionMap.get("limit") as number;
    }

    if (optionMap.get("status") !== undefined && optionMap.get("status") !== null) {
      option.status = optionMap.get("status") as number[];
    }

    this.nim.friendService?.getAddApplicationList(option).then((applicationResult) => {
      this.onSuccess(result,
        applicationResult)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private getAddApplicationUnreadCount(argument: Map<string, Any>, result: MethodResult) {
    this.nim.friendService?.getAddApplicationUnreadCount().then((count) => {
      this.onSuccess(result,
        count)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private setAddApplicationRead(argument: Map<string, Any>, result: MethodResult) {
    this.nim.friendService?.setAddApplicationRead().then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private clearAllAddApplication(argument: Map<string, Any>, result: MethodResult) {
    this.nim.friendService?.clearAllAddApplication().then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private searchFriendByOption(argument: Map<string, Any>, result: MethodResult) {
    let optionMap = argument.get("friendSearchOption") as Map<string, string | boolean | undefined | null>;
    let option: V2NIMFriendSearchOption = {
      keyword: optionMap.get("keyword") as string
    };
    if (optionMap.get("searchAlias") !== undefined && optionMap.get("searchAlias") !== null) {
      option.searchAlias = optionMap.get("searchAlias") as boolean;
    }
    if (optionMap.get("searchAccountId") !== undefined && optionMap.get("searchAccountId") !== null) {
      option.searchAccountId = optionMap.get("searchAccountId") as boolean;
    }
    this.nim.friendService?.searchFriendByOption(option).then((friendList) => {
      this.onSuccess(result,
        { "friendList": friendList.map(friend => (friend as V2NIMFriendImpl).toJSON()) }
      )
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }
}