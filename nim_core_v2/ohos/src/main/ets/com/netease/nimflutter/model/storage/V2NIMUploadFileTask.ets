import { V2NIMUploadFileParams, V2NIMUploadFileTask } from '@nimsdk/base';

export function convertMap2UploadFileTask(argumentsMap: Map<string, undefined | number | string | object | null>): V2NIMUploadFileTask {

  let task: V2NIMUploadFileTask = {
    taskId: argumentsMap.get("taskId") as string,
    uploadParams: convertMap2UploadFileParams(argumentsMap.get("uploadParams") as Map<string, undefined | string | boolean | null>)
  };

  return task;
}

export function convertMap2UploadFileParams(argumentsMap: Map<string, undefined | string | boolean | null>): V2NIMUploadFileParams {

  let params: V2NIMUploadFileParams = {
    filePath: argumentsMap.get("filePath") as string,
    sceneName: argumentsMap.get("sceneName") as string
  };

  return params;
}