/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';

export class FLTConversationIdUtil extends FLTService {
  get serviceName(): string {
    return "ConversationIdUtil";
  }

  onInitialized(): void {
    // notifyEvent
    Log.d(this.serviceName, "onInitialized");
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    switch (method) {
      case "p2pConversationId":
        this.p2pConversationId(args, result)
        break
      case "teamConversationId":
        this.teamConversationId(args, result)
        break
      case "superTeamConversationId":
        this.superTeamConversationId(args, result)
        break
      case "conversationType":
        this.conversationType(args, result)
        break
      case "conversationTargetId":
        this.conversationTargetId(args, result)
    }
  }

  private p2pConversationId(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "p2pConversationId")

    let accountId = argument.get("accountId") ? argument.get("accountId") as string : "";

    const res = this.nim.conversationIdUtil.p2pConversationId(accountId)

    this.onSuccess(result, res)
  }

  private teamConversationId(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "teamConversationId")

    let teamId = argument.get("teamId") ? argument.get("teamId") as string : "";

    const res = this.nim.conversationIdUtil.teamConversationId(teamId)

    this.onSuccess(result, res)
  }

  private superTeamConversationId(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "superTeamConversationId")

    let superTeamId = argument.get("superTeamId") ? argument.get("superTeamId") as string : "";

    const res = this.nim.conversationIdUtil.superTeamConversationId(superTeamId)

    this.onSuccess(result, res)
  }

  private conversationType(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "conversationType")

    let conversationId = argument.get("conversationId") ? argument.get("conversationId") as string : "";

    const res = this.nim.conversationIdUtil.parseConversationType(conversationId)

    this.onSuccess(result, new Map<string, Any>().set("conversationType", res.valueOf()))
  }

  private conversationTargetId(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "conversationTargetId")

    let conversationId = argument.get("conversationId") ? argument.get("conversationId") as string : "";

    const res = this.nim.conversationIdUtil.parseConversationTargetId(conversationId)

    this.onSuccess(result, res)
  }
}