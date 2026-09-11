import { V2NIMCollectionOption, V2NIMQueryDirection } from '@nimsdk/base';
import { Any } from '@ohos/flutter_ohos';
import { convertMap2Collection } from './V2NIMCollection';

export function convertMap2CollectionOption(argumentsMap: Map<string, Any>): V2NIMCollectionOption {
  let collectionOption: V2NIMCollectionOption = {
    collectionType: 0
  };

  if (argumentsMap.get("beginTime") !== undefined && argumentsMap.get("beginTime") !== null) {
    collectionOption.beginTime = argumentsMap.get("beginTime") as number;
  }

  if (argumentsMap.get("endTime") !== undefined && argumentsMap.get("endTime") !== null) {
    collectionOption.endTime = argumentsMap.get("endTime") as number;
  }

  if (argumentsMap.get("anchorCollection") !== undefined && argumentsMap.get("anchorCollection") !== null) {
    const anchorCollectionMap: Map<string, Any> = argumentsMap.get("anchorCollection") as Map<string, Any>
    if (anchorCollectionMap && anchorCollectionMap.get("collectionId") !== null) {
      collectionOption.anchorCollection = convertMap2Collection(anchorCollectionMap)
    }
  }

  if (argumentsMap.get("direction") !== undefined && argumentsMap.get("direction") !== null) {
    collectionOption.direction = argumentsMap.get("direction") as V2NIMQueryDirection;
  }

  if (argumentsMap.get("limit") !== undefined && argumentsMap.get("limit") !== null) {
    collectionOption.limit = argumentsMap.get("limit") as number;
  }

  if (argumentsMap.get("collectionType") !== undefined && argumentsMap.get("collectionType") !== null) {
    collectionOption.collectionType = argumentsMap.get("collectionType") as number;
  }

  return collectionOption;
}