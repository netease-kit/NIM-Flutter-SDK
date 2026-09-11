/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import { V2NIMDownloadMessageAttachmentParams, V2NIMError, V2NIMUploadFileParams } from '@nimsdk/base';
import { V2NIMChatroomClient } from '@nimsdk/chatroom';
import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';
import {
  convertMap2Attachment,
  convertMap2DownloadMessageAttachmentParams,
  convertMap2NIMSize
} from '../model/storage/V2NIMDownloadMessageAttachmentParams';
import { convertMap2UploadFileTask } from '../model/storage/V2NIMUploadFileTask';

export class FLTStorageService extends FLTService {
  get serviceName(): string {
    return "StorageService";
  }

  onInitialized(): void {
    // notifyEvent
    Log.d(this.serviceName, "onInitialized");
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    switch (method) {
      case "addCustomStorageScene":
        this.addCustomStorageScene(args, result);
        break;
      case "createUploadFileTask":
        this.createUploadFileTask(args, result);
        break;
      case "cancelUploadFile":
        this.cancelUploadFile(args, result);
        break;
      case "getStorageSceneList":
        this.getStorageSceneList(args, result);
        break;
      case "shortUrlToLong":
        this.shortUrlToLong(args, result);
        break;
      case "downloadFile":
        this.downloadFile(args, result);
        break;
      case "downloadAttachment":
        this.downloadAttachment(args, result);
        break;
      case "uploadFile":
        this.uploadFile(args, result);
        break;
      case "getImageThumbUrl":
        this.getImageThumbUrl(args, result);
        break;
      case "getVideoCoverUrl":
        this.getVideoCoverUrl(args, result);
        break;
      case "imageThumbUrl":
        this.imageThumbUrl(args, result);
        break;
      case "videoCoverUrl":
        this.videoCoverUrl(args, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private addCustomStorageScene(argument: Map<string, Any>, result: MethodResult) {
    let sceneName = argument.get("sceneName") as string;
    let expireTime = argument.get("expireTime") as number;
    let instanceId = argument.get("instanceId") as number | undefined | null;
    if (instanceId !== undefined && instanceId != null) {
      const storageServiceCr = V2NIMChatroomClient.getInstance(instanceId)?.storageService;
      if (!storageServiceCr) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }
      let sceneCr = storageServiceCr.addCustomStorageScene(sceneName, expireTime);
      if (sceneCr) {
        this.onSuccess(result, new Map(Object.entries(sceneCr)))
      } else {
        this.onErrorWithCode(result, -1, "addCustomStorageScene failed!");
      }
      return;
    }
    let scene = this.nim.storageService?.addCustomStorageScene(sceneName, expireTime);
    if (scene) {
      this.onSuccess(result, new Map(Object.entries(scene)))
    } else {
      this.onErrorWithCode(result, -1, "addCustomStorageScene failed!");
    }
  }

  private createUploadFileTask(argument: Map<string, Any>, result: MethodResult) {
    let fileParamsMap = argument.get("fileParams") as Map<string, string | undefined | null>;
    let instanceId = argument.get("instanceId") as number | undefined | null;
    let fileParams: V2NIMUploadFileParams = {
      filePath: fileParamsMap.get("filePath") as string,
      sceneName: (fileParamsMap.get("sceneName") === null || fileParamsMap.get("sceneName") === undefined) ?
        "nim_default_profile_icon" : fileParamsMap.get("sceneName") as string
    }
    if (instanceId !== undefined && instanceId != null) {
      const storageServiceCr = V2NIMChatroomClient.getInstance(instanceId)?.storageService;
      if (!storageServiceCr) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }
      let fileTaskCr = storageServiceCr.createUploadFileTask(fileParams);
      if (fileTaskCr != undefined && fileTaskCr != null) {
        this.onSuccess(result, new Map(Object.entries(fileTaskCr)))
      } else {
        this.onErrorWithCode(result, -1, "addCustomStorageScene failed!");
      }
      return;
    }
    let fileTask = this.nim.storageService?.createUploadFileTask(fileParams);
    if (fileTask != undefined && fileTask != null) {
      this.onSuccess(result, new Map(Object.entries(fileTask)))
    } else {
      this.onErrorWithCode(result, -1, "addCustomStorageScene failed!");
    }
  }

  private cancelUploadFile(argument: Map<string, Any>, result: MethodResult) {
    let fileTaskMap = argument.get("fileTask") as Map<string, undefined | number | string | object | null>;
    let instanceId = argument.get("instanceId") as number | undefined | null;
    let fileTask = convertMap2UploadFileTask(fileTaskMap)
    if (instanceId !== undefined && instanceId != null) {
      const storageServiceCr = V2NIMChatroomClient.getInstance(instanceId)?.storageService;
      if (!storageServiceCr) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }
      storageServiceCr.cancelUploadFile(fileTask).then(() => {
        this.onSuccess(result)
      })
        .catch((e: V2NIMError) => {
          this.onError(result, e)
        })

      return;
    }
    this.nim.storageService?.cancelUploadFile(fileTask).then(() => {
      this.onSuccess(result)
    })
      .catch((e: V2NIMError) => {
        this.onError(result, e)
      })
  }

  private getStorageSceneList(argument: Map<string, Any>, result: MethodResult) {
    let instanceId = argument.get("instanceId") as number | undefined | null;
    if (instanceId !== undefined && instanceId != null) {
      const storageServiceCr = V2NIMChatroomClient.getInstance(instanceId)?.storageService;
      if (!storageServiceCr) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }
      let sceneListCr = storageServiceCr.getStorageSceneList();
      if (sceneListCr) {
        this.onSuccess(result, new Map<string, Any>().set(
          "sceneList", sceneListCr
        ))
      } else {
        this.onErrorWithCode(result, -1, "addCustomStorageScene failed!");
      }
      return;
    }
    let sceneList = this.nim.storageService?.getStorageSceneList();
    if (sceneList) {
      this.onSuccess(result, new Map<string, Any>().set(
        "sceneList", sceneList
      ))
    } else {
      this.onErrorWithCode(result, -1, "addCustomStorageScene failed!");
    }
  }

  private shortUrlToLong(argument: Map<string, Any>, result: MethodResult) {
    let url = argument.get("url") as string;
    let instanceId = argument.get("instanceId") as number | undefined | null;
    if (instanceId !== undefined && instanceId != null) {
      const storageServiceCr = V2NIMChatroomClient.getInstance(instanceId)?.storageService;
      if (!storageServiceCr) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }
      storageServiceCr.shortUrlToLong(url).then((urlS) => {
        this.onSuccess(result, urlS)
      })
        .catch((e: V2NIMError) => {
          this.onError(result, e)
        })

      return;
    }
    this.nim.storageService?.shortUrlToLong(url).then((urlS) => {
      this.onSuccess(result, urlS)
    })
      .catch((e: V2NIMError) => {
        this.onError(result, e)
      })
  }

  private downloadFile(argument: Map<string, Any>, result: MethodResult) {
    let url = argument.get("url") as string;
    let filePath = argument.get("filePath") as string;
    let instanceId = argument.get("instanceId") as number | undefined | null;
    if (instanceId !== undefined && instanceId != null) {
      const storageServiceCr = V2NIMChatroomClient.getInstance(instanceId)?.storageService;
      if (!storageServiceCr) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }
      storageServiceCr.downloadFile(url, filePath, (progress: number) => {
        this.notifyEvent("onFileDownloadProgress", new Map<string, Any>().set(
          "progress", progress
        ).set(
          "url", url
        ).set(
          "instanceId", instanceId
        )
        )
      }).then((urlS) => {
        this.onSuccess(result, urlS)
      })
        .catch((e: V2NIMError) => {
          this.onError(result, e)
        })

      return;
    }
    this.nim.storageService?.downloadFile(url, filePath, (progress: number) => {
      this.notifyEvent("onFileDownloadProgress", new Map<string, Any>().set(
        "progress", progress
      ).set(
        "url", url
      )
      )
    }).then((urlS) => {
      this.onSuccess(result, urlS)
    })
      .catch((e: V2NIMError) => {
        this.onError(result, e)
      })
  }

  private downloadAttachment(argument: Map<string, Any>, result: MethodResult) {
    let downloadParamMap = argument.get("downloadParam") as Map<string, undefined | null | object | string>;
    let instanceId = argument.get("instanceId") as number | undefined | null;
    let downloadParam: V2NIMDownloadMessageAttachmentParams
      = convertMap2DownloadMessageAttachmentParams(downloadParamMap)
    if (instanceId !== undefined && instanceId != null) {
      const storageServiceCr = V2NIMChatroomClient.getInstance(instanceId)?.storageService;
      if (!storageServiceCr) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }
      storageServiceCr.downloadAttachment(downloadParam, (progress: number) => {
        this.notifyEvent("onMessageAttachmentDownloadProgress", new Map<string, Any>().set(
          "progress", progress
        ).set(
          "downloadParam", downloadParamMap
        ).set(
          "instanceId", instanceId
        )
        )
      }).then((urlS) => {
        this.onSuccess(result, urlS)
      })
        .catch((e: V2NIMError) => {
          this.onError(result, e)
        })

      return;
    }
    this.nim.storageService?.downloadAttachment(downloadParam, (progress: number) => {
      this.notifyEvent("onMessageAttachmentDownloadProgress", new Map<string, Any>().set(
        "progress", progress
      ).set(
        "downloadParam", downloadParamMap,
      )
      )
    }).then((urlS) => {
      this.onSuccess(result, urlS)
    })
      .catch((e: V2NIMError) => {
        this.onError(result, e)
      })
  }

  private uploadFile(argument: Map<string, Any>, result: MethodResult) {
    let fileTaskMap = argument.get("fileTask") as Map<string, undefined | number | string | object | null>;
    let instanceId = argument.get("instanceId") as number | undefined | null;
    let fileTask = convertMap2UploadFileTask(fileTaskMap)
    if (instanceId !== undefined && instanceId != null) {
      const storageServiceCr = V2NIMChatroomClient.getInstance(instanceId)?.storageService;
      if (!storageServiceCr) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }
      storageServiceCr.uploadFile(fileTask, (progress: number) => {
        this.notifyEvent("onFileUploadProgress",
          new Map<string, Any>().set(
            "progress", progress
          ).set(
            "taskId", fileTask.taskId
          ).set(
            "instanceId", instanceId
          ))
      }).then((url: string) => {
        this.onSuccess(result, url)
      })
        .catch((e: V2NIMError) => {
          this.onError(result, e)
        })

      return;
    }
    this.nim.storageService?.uploadFile(fileTask, (progress: number) => {
      this.notifyEvent("onFileUploadProgress",
        new Map<string, Any>().set(
          "progress", progress
        ).set(
          "taskId", fileTask.taskId
        ))
    }).then((url: string) => {
      this.onSuccess(result, url)
    })
      .catch((e: V2NIMError) => {
        this.onError(result, e)
      })
  }

  private getImageThumbUrl(argument: Map<string, Any>, result: MethodResult) {
    let thumbSizeMap = argument.get("thumbSize") as Map<string, undefined | null | number>;
    let thumbSize = convertMap2NIMSize(thumbSizeMap);
    let attachment =
      convertMap2Attachment(argument.get("attachment") as Map<string, undefined | number | string | object | null>);
    let instanceId = argument.get("instanceId") as number | undefined | null;
    if (instanceId !== undefined && instanceId != null) {
      const storageServiceCr = V2NIMChatroomClient.getInstance(instanceId)?.storageService;
      if (!storageServiceCr) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }
      storageServiceCr.getImageThumbUrl(attachment, thumbSize).then((infoResult) => {
        this.onSuccess(result, new Map(Object.entries(infoResult)))
      })
        .catch((e: V2NIMError) => {
          this.onError(result, e)
        })

      return;
    }
    this.nim.storageService?.getImageThumbUrl(attachment, thumbSize).then((infoResult) => {
      this.onSuccess(result, new Map(Object.entries(infoResult)))
    })
      .catch((e: V2NIMError) => {
        this.onError(result, e)
      })
  }

  private getVideoCoverUrl(argument: Map<string, Any>, result: MethodResult) {
    let thumbSizeMap = argument.get("thumbSize") as Map<string, undefined | null | number>;
    let thumbSize = convertMap2NIMSize(thumbSizeMap);
    let attachment =
      convertMap2Attachment(argument.get("attachment") as Map<string, undefined | number | string | object | null>);
    let instanceId = argument.get("instanceId") as number | undefined | null;
    if (instanceId !== undefined && instanceId != null) {
      const storageServiceCr = V2NIMChatroomClient.getInstance(instanceId)?.storageService;
      if (!storageServiceCr) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }
      storageServiceCr.getVideoCoverUrl(attachment, thumbSize).then((infoResult) => {
        this.onSuccess(result, new Map(Object.entries(infoResult)))
      })
        .catch((e: V2NIMError) => {
          this.onError(result, e)
        })

      return;
    }
    this.nim.storageService?.getVideoCoverUrl(attachment, thumbSize).then((infoResult) => {
      this.onSuccess(result, new Map(Object.entries(infoResult)))
    })
      .catch((e: V2NIMError) => {
        this.onError(result, e)
      })
  }

  private imageThumbUrl(argument: Map<string, Any>, result: MethodResult) {
    let url = argument.get("url") as string;
    let thumbSize = argument.get("thumbSize") as number
    let resultUrl = this.nim.storageUtil?.imageThumbUrl(url, thumbSize);
    this.onSuccess(result, resultUrl)
  }

  private videoCoverUrl(argument: Map<string, Any>, result: MethodResult) {
    let url = argument.get("url") as string;
    let offset = argument.get("offset") as number
    let resultUrl = this.nim.storageUtil?.videoCoverUrl(url, offset);
    this.onSuccess(result, resultUrl)
  }
}