// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTStorageService.h"

#include "../NimResult.h"
#include "FLTMessageService.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"

struct NIMUploadFileProgress {
  std::string taskId;
  std::int32_t progress;
};

struct NIMDownloadFileProgress {
  std::string url;
  std::int32_t progress;
};

struct NIMDownloadMessageAttachmentProgress {
  v2::V2NIMDownloadMessageAttachmentParams downloadParam;
  int32_t progress;
};

flutter::EncodableMap convertStorageScene(const v2::V2NIMStorageScene object);
v2::V2NIMUploadFileParams getUploadFileParams(
    const flutter::EncodableMap* arguments);
flutter::EncodableMap convertUploadFileParams(
    const v2::V2NIMUploadFileParams object);
v2::V2NIMUploadFileTask getUploadFileTask(
    const flutter::EncodableMap* arguments);
flutter::EncodableMap convertUploadFileTask(
    const v2::V2NIMUploadFileTask object);
v2::V2NIMSize getNIMSize(const flutter::EncodableMap* arguments);
flutter::EncodableMap convertNIMSize(
    const nstd::optional<v2::V2NIMSize> object);
v2::V2NIMDownloadMessageAttachmentParams getDownloadMessageAttachmentParams(
    const flutter::EncodableMap* arguments);
flutter::EncodableMap convertDownloadMessageAttachmentParams(
    const v2::V2NIMDownloadMessageAttachmentParams object);
flutter::EncodableMap convertUploadFileProgress(
    const NIMUploadFileProgress object);
NIMUploadFileProgress getUploadFileProgress(
    const flutter::EncodableMap* arguments);
flutter::EncodableMap convertDownloadFileProgress(
    const NIMDownloadFileProgress object);
NIMDownloadFileProgress getDownloadFileProgress(
    const flutter::EncodableMap* arguments);
NIMDownloadMessageAttachmentProgress getDownloadMessageAttachmentProgress(
    const flutter::EncodableMap* arguments);
flutter::EncodableMap convertDownloadMessageAttachmentProgress(
    const NIMDownloadMessageAttachmentProgress object);
flutter::EncodableMap convertGetMediaResourceInfoResult(
    const v2::V2NIMGetMediaResourceInfoResult object);

FLTStorageService::FLTStorageService() { m_serviceName = "StorageService"; }

FLTStorageService::~FLTStorageService() {}

void FLTStorageService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  switch (utils::hash_(method.c_str())) {
    case "addCustomStorageScene"_hash:
      addCustomStorageScene(arguments, result);
      return;
    case "getStorageSceneList"_hash:
      getStorageSceneList(arguments, result);
      return;
    case "createUploadFileTask"_hash:
      createUploadFileTask(arguments, result);
      return;
    case "uploadFile"_hash:
      uploadFile(arguments, result);
      return;
    case "cancelUploadFile"_hash:
      cancelUploadFile(arguments, result);
      return;
      //    case "downloadFile"_hash:
      //      downloadFile(arguments, result);
      //      return;
      //    case "downloadAttachment"_hash:
      //      downloadAttachment(arguments, result);
      //      return;
    case "shortUrlToLong"_hash:
      shortUrlToLong(arguments, result);
      return;
    case "getImageThumbUrl"_hash:
      getImageThumbUrl(arguments, result);
      return;
    case "getVideoCoverUrl"_hash:
      getVideoCoverUrl(arguments, result);
      return;
    case "imageThumbUrl"_hash:
      imageThumbUrl(arguments, result);
      return;
    case "videoCoverUrl"_hash:
      videoCoverUrl(arguments, result);
      return;

    default:
      break;
  }
  if (result) result->NotImplemented();
}

void FLTStorageService::addCustomStorageScene(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string sceneName = "";
  std::int64_t expireTime = 0;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("sceneName")) {
      sceneName = std::get<std::string>(iter->second);
      std::cout << "sceneName: " << sceneName << std::endl;
    } else if (iter->first == flutter::EncodableValue("expireTime")) {
      expireTime = iter->second.LongValue();
      std::cout << "expireTime: " << expireTime << std::endl;
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& storageService = instance.getStorageService();
  storageService.addCustomStorageScene(sceneName, expireTime);
  result->Success(NimResult::getSuccessResult());
}

void FLTStorageService::getStorageSceneList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  auto& instance = v2::V2NIMClient::get();
  auto& storageService = instance.getStorageService();
  std::vector<v2::V2NIMStorageScene> storageSceneList =
      storageService.getStorageSceneList();

  flutter::EncodableList storageSceneListMap;
  for (auto storageScene : storageSceneList) {
    storageSceneListMap.emplace_back(convertStorageScene(storageScene));
  }
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("sceneList", storageSceneListMap));
  result->Success(NimResult::getSuccessResult(resultMap));
}

void FLTStorageService::createUploadFileTask(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMUploadFileParams fileParams;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("fileParams")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      fileParams = getUploadFileParams(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& storageService = instance.getStorageService();
  v2::V2NIMUploadFileTask task =
      storageService.createUploadFileTask(fileParams);

  flutter::EncodableMap resultMap = convertUploadFileTask(task);
  result->Success(NimResult::getSuccessResult(resultMap));
}

void FLTStorageService::uploadFile(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMUploadFileTask fileTask;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("fileTask")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      fileTask = getUploadFileTask(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& storageService = instance.getStorageService();
  storageService.uploadFile(
      fileTask,
      [result](std::string url) {
        result->Success(NimResult::getSuccessResult(url));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      },
      [=](uint32_t progress) {
        NIMUploadFileProgress fileProgress;
        fileProgress.taskId = fileTask.taskId;
        fileProgress.progress = progress;
        flutter::EncodableMap ret = convertUploadFileProgress(fileProgress);
        notifyEvent("onFileUploadProgress", ret);
      });
}

void FLTStorageService::cancelUploadFile(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMUploadFileTask fileTask;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("fileTask")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      fileTask = getUploadFileTask(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& storageService = instance.getStorageService();
  storageService.cancelUploadFile(
      fileTask, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTStorageService::downloadFile(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string url = "";
  std::string filePath = "";

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("url")) {
      url = std::get<std::string>(iter->second);
      std::cout << "url: " << url << std::endl;
    } else if (iter->first == flutter::EncodableValue("filePath")) {
      filePath = std::get<std::string>(iter->second);
      std::cout << "filePath: " << filePath << std::endl;
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& storageService = instance.getStorageService();
  storageService.downloadFile(
      url, filePath,
      [result](nstd::string path) {
        std::string pathStr = path;
        result->Success(NimResult::getSuccessResult(pathStr));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      },
      [=](uint32_t progress) {
        NIMDownloadFileProgress fileProgress;
        fileProgress.url = url;
        fileProgress.progress = progress;
        flutter::EncodableMap ret = convertDownloadFileProgress(fileProgress);
        notifyEvent("onFileDownloadProgress", ret);
      });
}

void FLTStorageService::downloadAttachment(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMDownloadMessageAttachmentParams downloadParam;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("downloadParam")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      downloadParam = getDownloadMessageAttachmentParams(&paramsMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& storageService = instance.getStorageService();
  storageService.downloadAttachment(
      downloadParam,
      [result](std::string filePath) {
        result->Success(NimResult::getSuccessResult(filePath));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      },
      [=](uint32_t progress) {
        NIMDownloadMessageAttachmentProgress downloadMessageAttachmentProgress;
        downloadMessageAttachmentProgress.downloadParam = downloadParam;
        downloadMessageAttachmentProgress.progress = progress;

        flutter::EncodableMap ret = convertDownloadMessageAttachmentProgress(
            downloadMessageAttachmentProgress);
        notifyEvent("onMessageAttachmentDownloadProgress", ret);
      });
}

void FLTStorageService::shortUrlToLong(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string url = "";

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("url")) {
      url = std::get<std::string>(iter->second);
      std::cout << "url: " << url << std::endl;
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& storageService = instance.getStorageService();
  storageService.shortUrlToLong(
      url,
      [result](std::string url) {
        result->Success(NimResult::getSuccessResult(url));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTStorageService::getImageThumbUrl(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMSize thumbSize;
  nstd::shared_ptr<v2::V2NIMMessageAttachment> attachment;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("thumbSize")) {
      auto thumbSizeMap = std::get<flutter::EncodableMap>(iter->second);
      thumbSize = getNIMSize(&thumbSizeMap);
    } else if (iter->first == flutter::EncodableValue("attachment")) {
      auto attachmentMap = std::get<flutter::EncodableMap>(iter->second);
      attachment = getMessageAttachment(&attachmentMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& storageService = instance.getStorageService();
  storageService.getImageThumbUrl(
      attachment, thumbSize,
      [result](v2::V2NIMGetMediaResourceInfoResult infoResult) {
        flutter::EncodableMap resultMap =
            convertGetMediaResourceInfoResult(infoResult);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTStorageService::getVideoCoverUrl(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMSize thumbSize;
  nstd::shared_ptr<v2::V2NIMMessageAttachment> attachment;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("thumbSize")) {
      auto thumbSizeMap = std::get<flutter::EncodableMap>(iter->second);
      thumbSize = getNIMSize(&thumbSizeMap);
    } else if (iter->first == flutter::EncodableValue("attachment")) {
      auto attachmentMap = std::get<flutter::EncodableMap>(iter->second);
      attachment = getMessageAttachment(&attachmentMap);
    }
  }

  auto& instance = v2::V2NIMClient::get();
  auto& storageService = instance.getStorageService();
  storageService.getVideoCoverUrl(
      attachment, thumbSize,
      [result](v2::V2NIMGetMediaResourceInfoResult infoResult) {
        flutter::EncodableMap resultMap =
            convertGetMediaResourceInfoResult(infoResult);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTStorageService::imageThumbUrl(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string url;
  int32_t thumbSize;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("url")) {
      url = std::get<std::string>(iter->second);
      std::cout << "url: " << url << std::endl;
    } else if (iter->first == flutter::EncodableValue("thumbSize")) {
      thumbSize = iter->second.LongValue();
      std::cout << "thumbSize: " << thumbSize << std::endl;
    }
  }

  auto imageThumbUrl = v2::V2NIMStorageUtil::imageThumbUrl(url, thumbSize);
  std::string resultStr = imageThumbUrl;
  result->Success(NimResult::getSuccessResult(resultStr));
}

void FLTStorageService::videoCoverUrl(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  std::string url;
  int32_t offset;
  int32_t thumbSize;
  std::string type;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("url")) {
      url = std::get<std::string>(iter->second);
      std::cout << "url: " << url << std::endl;
    } else if (iter->first == flutter::EncodableValue("offset")) {
      offset = iter->second.LongValue();
      std::cout << "offset: " << offset << std::endl;
    } else if (iter->first == flutter::EncodableValue("thumbSize")) {
      thumbSize = iter->second.LongValue();
      std::cout << "thumbSize: " << thumbSize << std::endl;
    } else if (iter->first == flutter::EncodableValue("type")) {
      type = std::get<std::string>(iter->second);
      std::cout << "type: " << type << std::endl;
    }
  }

  auto videoCoverUrl =
      v2::V2NIMStorageUtil::videoCoverUrl(url, offset, thumbSize, type);
  std::string converUrl = videoCoverUrl;
  result->Success(NimResult::getSuccessResult(converUrl));
}

flutter::EncodableMap convertStorageScene(const v2::V2NIMStorageScene object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("sceneName", object.sceneName));
  resultMap.insert(
      std::make_pair("expireTime", static_cast<int64_t>(object.expireTime)));
  return resultMap;
}

v2::V2NIMUploadFileParams getUploadFileParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMUploadFileParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("filePath")) {
      object.filePath = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sceneName")) {
      object.sceneName = std::get<std::string>(iter->second);
    }
  }
  return object;
}

flutter::EncodableMap convertUploadFileParams(
    const v2::V2NIMUploadFileParams object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("filePath", object.filePath));
  resultMap.insert(std::make_pair("sceneName", object.sceneName));
  return resultMap;
}

v2::V2NIMUploadFileTask getUploadFileTask(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMUploadFileTask object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("taskId")) {
      object.taskId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("uploadParams")) {
      auto uploadParamsMap = std::get<flutter::EncodableMap>(iter->second);
      object.uploadParams = getUploadFileParams(&uploadParamsMap);
    }
  }
  return object;
}

flutter::EncodableMap convertUploadFileTask(
    const v2::V2NIMUploadFileTask object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("taskId", object.taskId));

  flutter::EncodableMap uploadParams =
      convertUploadFileParams(object.uploadParams);
  resultMap.insert(std::make_pair("uploadParams", uploadParams));
  return resultMap;
}

NIMUploadFileProgress getUploadFileProgress(
    const flutter::EncodableMap* arguments) {
  NIMUploadFileProgress object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("taskId")) {
      object.taskId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("progress")) {
      object.progress = std::get<std::int32_t>(iter->second);
    }
  }
  return object;
}

flutter::EncodableMap convertUploadFileProgress(
    const NIMUploadFileProgress object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("taskId", object.taskId));
  resultMap.insert(
      std::make_pair("progress", static_cast<int32_t>(object.progress)));
  return resultMap;
}

NIMDownloadFileProgress getDownloadFileProgress(
    const flutter::EncodableMap* arguments) {
  NIMDownloadFileProgress object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("url")) {
      object.url = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("progress")) {
      object.progress = std::get<std::int32_t>(iter->second);
    }
  }
  return object;
}

flutter::EncodableMap convertDownloadFileProgress(
    const NIMDownloadFileProgress object) {
  flutter::EncodableMap resultMap;
  resultMap.insert(std::make_pair("url", object.url));
  resultMap.insert(
      std::make_pair("progress", static_cast<int32_t>(object.progress)));
  return resultMap;
}

v2::V2NIMDownloadMessageAttachmentParams getDownloadMessageAttachmentParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMDownloadMessageAttachmentParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("attachment")) {
      auto attachmentMap = std::get<flutter::EncodableMap>(iter->second);
      object.attachment = getMessageAttachment(&attachmentMap);
    } else if (iter->first == flutter::EncodableValue("type")) {
      object.type =
          v2::V2NIMDownloadAttachmentType(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("thumbSize")) {
      auto thumbSizeMap = std::get<flutter::EncodableMap>(iter->second);
      object.thumbSize = getNIMSize(&thumbSizeMap);
    } else if (iter->first == flutter::EncodableValue("messageClientId")) {
      object.messageClientId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("saveAs")) {
      object.saveAs = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMSize getNIMSize(const flutter::EncodableMap* arguments) {
  v2::V2NIMSize object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("width")) {
      object.width = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("height")) {
      object.height = iter->second.LongValue();
    }
  }
  return object;
}

NIMDownloadMessageAttachmentProgress getDownloadMessageAttachmentProgress(
    const flutter::EncodableMap* arguments) {
  NIMDownloadMessageAttachmentProgress object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("progress")) {
      object.progress = std::get<std::int32_t>(iter->second);
    } else if (iter->first == flutter::EncodableValue("downloadParam")) {
      auto downloadParamMap = std::get<flutter::EncodableMap>(iter->second);
      object.downloadParam =
          getDownloadMessageAttachmentParams(&downloadParamMap);
    }
  }
  return object;
}

flutter::EncodableMap convertDownloadMessageAttachmentParams(
    const v2::V2NIMDownloadMessageAttachmentParams object) {
  flutter::EncodableMap resultMap;

  if (object.attachment) {
    flutter::EncodableMap attachment =
        convertMessageAttachment(object.attachment);
    resultMap.insert(std::make_pair("attachment", attachment));
  }
  resultMap.insert(std::make_pair("type", object.type));

  if (object.thumbSize.has_value()) {
    flutter::EncodableMap thumbSize = convertNIMSize(object.thumbSize.value());
    resultMap.insert(std::make_pair("thumbSize", thumbSize));
  }
  resultMap.insert(
      std::make_pair("messageClientId", object.messageClientId.value()));
  resultMap.insert(std::make_pair("saveAs", object.saveAs.value()));
  return resultMap;
}

flutter::EncodableMap convertDownloadMessageAttachmentProgress(
    const NIMDownloadMessageAttachmentProgress object) {
  flutter::EncodableMap resultMap;

  flutter::EncodableMap downloadParam =
      convertDownloadMessageAttachmentParams(object.downloadParam);
  resultMap.insert(std::make_pair("downloadParam", downloadParam));
  resultMap.insert(
      std::make_pair("progress", static_cast<int32_t>(object.progress)));
  return resultMap;
}

flutter::EncodableMap convertNIMSize(
    const nstd::optional<v2::V2NIMSize> object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(
      std::make_pair("width", static_cast<int32_t>(object->width)));
  resultMap.insert(
      std::make_pair("height", static_cast<int32_t>(object->height)));
  return resultMap;
}

flutter::EncodableMap convertGetMediaResourceInfoResult(
    const v2::V2NIMGetMediaResourceInfoResult object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair("url", object.url));

  flutter::EncodableMap authHeaders;
  for (auto& it : object.authHeaders) {
    authHeaders.insert(std::make_pair(it.first, it.second));
  }
  resultMap.insert(std::make_pair("authHeaders", authHeaders));
  return resultMap;
}