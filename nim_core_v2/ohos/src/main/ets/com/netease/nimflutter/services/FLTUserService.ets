/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import { V2NIMError, V2NIMUser, V2NIMUserSearchOption, V2NIMUserUpdateParams } from '@nimsdk/base';
import { V2NIMUserImpl } from '@nimsdk/user/src/main/ets/nim/services/model/V2NIMUserImpl';
import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';

export class FLTUserService extends FLTService {
  get serviceName(): string {
    return "UserService";
  }

  onInitialized(): void {
    // notifyEvent
    Log.d(this.serviceName, "onInitialized");
    this.nim.userService?.on("onUserProfileChanged", (users: V2NIMUser[]) => {
      Log.d(this.serviceName, "onUserProfileChanged:" + users.length)
      this.notifyEvent("onUserProfileChanged", new Map<string, Any>().set(
        "userInfoList", users.map(user => (user as V2NIMUserImpl).toJSON())
      )
      )
    });
    this.nim.userService?.on("onBlockListAdded", (user: V2NIMUser) => {
      Log.d(this.serviceName, "onBlockListAdded:" + user.accountId)
      this.notifyEvent("onBlockListAdded", new Map(Object.entries((user as V2NIMUserImpl).toJSON())))
    });
    this.nim.userService?.on("onBlockListRemoved", (accountId: string) => {
      Log.d(this.serviceName, "onBlockListRemoved:" + accountId)
      this.notifyEvent("onBlockListRemoved", new Map<string, Any>().set("userId", accountId));
    });
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    switch (method) {
      case "getUserListFromCloud":
        this.getUserListFromCloud(args, result);
        break;
      case "getUserList":
        this.getUserList(args, result);
        break;
      case "updateSelfUserProfile":
        this.updateSelfUserProfile(args, result);
        break;
      case "addUserToBlockList":
        this.addUserToBlockList(args, result);
        break;
      case "removeUserFromBlockList":
        this.removeUserFromBlockList(args, result);
        break;
      case "getBlockList":
        this.getBlockList(args, result);
        break;
      case "searchUserByOption":
        this.searchUserByOption(args, result);
        break;
      case "checkBlock":
        this.checkBlock(args, result);
        break;
    }
  }

  private getUserList(argument: Map<string, Any>, result: MethodResult) {
    let userIdList = argument.get("userIdList") as string[];
    this.nim.userService?.getUserList(userIdList).then((users) => {
      this.onSuccess(result, {
        "userInfoList": users.map(user => (user as V2NIMUserImpl).toJSON())
      })
    })
      .catch((e: V2NIMError) => {
        this.onError(result, e)
      })
  }


  private getUserListFromCloud(argument: Map<string, Any>, result: MethodResult) {
    let userIdList = argument.get("userIdList") as string[];
    this.nim.userService?.getUserListFromCloud(userIdList).then((users) => {
      this.onSuccess(result, {
        "userInfoList": users.map(user => (user as V2NIMUserImpl).toJSON())
      })
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private updateSelfUserProfile(argument: Map<string, Any>, result: MethodResult) {
    let updateParamsMap = argument.get("updateParam") as Map<string, string | number | undefined>;
    let updateParams: V2NIMUserUpdateParams = {};
    if (updateParamsMap.get("name") !== undefined && updateParamsMap.get("name") !== null) {
      updateParams.name = updateParamsMap.get("name") as string;
    }
    if (updateParamsMap.get("avatar") !== undefined && updateParamsMap.get("avatar") !== null) {
      updateParams.avatar = updateParamsMap.get("avatar") as string;
    }
    if (updateParamsMap.get("gender") !== undefined && updateParamsMap.get("gender") !== null) {
      updateParams.gender = updateParamsMap.get("gender") as number;
    }
    if (updateParamsMap.get("email") !== undefined && updateParamsMap.get("email") !== null) {
      updateParams.email = updateParamsMap.get("email") as string;
    }
    if (updateParamsMap.get("birthday") !== undefined && updateParamsMap.get("birthday") !== null) {
      updateParams.birthday = updateParamsMap.get("birthday") as string;
    }
    if (updateParamsMap.get("mobile") !== undefined && updateParamsMap.get("mobile") !== null) {
      updateParams.mobile = updateParamsMap.get("mobile") as string;
    }
    if (updateParamsMap.get("serverExtension") !== undefined && updateParamsMap.get("serverExtension") !== null) {
      updateParams.serverExtension = updateParamsMap.get("serverExtension") as string;
    }
    if (updateParamsMap.get("sign") !== undefined && updateParamsMap.get("sign") !== null) {
      updateParams.sign = updateParamsMap.get("sign") as string;
    }
    this.nim.userService?.updateSelfUserProfile(updateParams).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private addUserToBlockList(argument: Map<string, Any>, result: MethodResult) {
    let accountId = argument.get("userId") as string;
    this.nim.userService?.addUserToBlockList(accountId).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private removeUserFromBlockList(argument: Map<string, Any>, result: MethodResult) {
    let accountId = argument.get("userId") as string;
    this.nim.userService?.removeUserFromBlockList(accountId).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private getBlockList(argument: Map<string, Any>, result: MethodResult) {
    this.nim.userService?.getBlockList().then((userIdList) => {
      this.onSuccess(result, {
        "userIdList": userIdList
      })
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private checkBlock(argument: Map<string, Any>, result: MethodResult) {
    let accountIds = argument.get("accountIds") as string[];
    this.nim.userService?.checkBlock(accountIds).then((resMap) => {
      this.onSuccess(result, resMap)
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private searchUserByOption(argument: Map<string, Any>, result: MethodResult) {
    let userSearchOptionMap = argument.get("userSearchOption") as Map<string, string | boolean | undefined | null>;
    let userSearchOption: V2NIMUserSearchOption = {
      keyword: userSearchOptionMap.get("keyword") as string,
    };

    if (userSearchOptionMap.get("searchName") !== undefined && userSearchOptionMap.get("searchName") !== null) {
      userSearchOption.searchName = userSearchOptionMap.get("searchName") as boolean;
    }

    if (userSearchOptionMap.get("searchAccountId") !== undefined &&
      userSearchOptionMap.get("searchAccountId") !== null) {
      userSearchOption.searchAccountId = userSearchOptionMap.get("searchAccountId") as boolean;
    }

    if (userSearchOptionMap.get("searchMobile") !== undefined && userSearchOptionMap.get("searchMobile") !== null) {
      userSearchOption.searchMobile = userSearchOptionMap.get("searchMobile") as boolean;
    }

    this.nim.userService?.searchUserByOption(userSearchOption).then((users) => {
      this.onSuccess(result,
        { "userInfoList": users.map(user => (user as V2NIMUserImpl).toJSON()) })
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }
}