import { V2NIMCollection } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';

export function convertMap2Collection(argumentsMap: Map<string, Any> | undefined): V2NIMCollection {
  let collection: V2NIMCollection = {
    collectionId: "",
    collectionType: 0,
    collectionData: "",
    createTime: 0,
    updateTime: 0
  };

  if (argumentsMap === undefined) {
    return collection;
  }

  if (argumentsMap.get("collectionId") !== undefined && argumentsMap.get("collectionId") !== null) {
    collection.collectionId = argumentsMap.get("collectionId") as string;
  }

  if (argumentsMap.get("collectionType") !== undefined && argumentsMap.get("collectionType") !== null) {
    collection.collectionType = argumentsMap.get("collectionType") as number;
  }

  if (argumentsMap.get("collectionData") !== undefined && argumentsMap.get("collectionData") !== null) {
    collection.collectionData = argumentsMap.get("collectionData") as string;
  }

  if (argumentsMap.get("serverExtension") !== undefined && argumentsMap.get("serverExtension") !== null) {
    collection.serverExtension = argumentsMap.get("serverExtension") as string;
  }

  if (argumentsMap.get("createTime") !== undefined && argumentsMap.get("createTime") !== null) {
    collection.createTime = argumentsMap.get("createTime") as number;
  }

  if (argumentsMap.get("updateTime") !== undefined && argumentsMap.get("updateTime") !== null) {
    collection.updateTime = argumentsMap.get("updateTime") as number;
  }

  if (argumentsMap.get("uniqueId") !== undefined && argumentsMap.get("uniqueId") !== null) {
    collection.uniqueId = argumentsMap.get("uniqueId") as string;
  }

  return collection;
}