import { V2NIMAddCollectionParams } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2AddCollectionParams(argumentsMap: Map<string, Any>): V2NIMAddCollectionParams {
  let addCollectionParams: V2NIMAddCollectionParams = {
    collectionType: 0,
    collectionData: ''
  };

  if (argumentsMap.get("collectionType") !== undefined && argumentsMap.get("collectionType") != null) {
    addCollectionParams.collectionType = argumentsMap.get("collectionType") as number;
  }

  if (argumentsMap.get("collectionData") !== undefined && argumentsMap.get("collectionData") != null) {
    addCollectionParams.collectionData = argumentsMap.get("collectionData") as string;
  }

  if (argumentsMap.get("serverExtension") !== undefined && argumentsMap.get("serverExtension") != null) {
    addCollectionParams.serverExtension = argumentsMap.get("serverExtension") as string;
  }

  if (argumentsMap.get("uniqueId") !== undefined && argumentsMap.get("uniqueId") != null) {
    addCollectionParams.uniqueId = argumentsMap.get("uniqueId") as string;
  }

  return addCollectionParams;
}