import { V2NIMFriendAddApplication } from "@nimsdk/base";

export function fromJsonFriendAddApplication(applicationMap: Map<string,undefined|string|boolean|number|null>): V2NIMFriendAddApplication {
  // 实现扩展方法的逻辑
  let application:V2NIMFriendAddApplication = {
    applicantAccountId: applicationMap.get("applicantAccountId") as string,
    recipientAccountId: applicationMap.get("recipientAccountId") as string,
    operatorAccountId: applicationMap.get("operatorAccountId") as string,
    status: applicationMap.get("status") as number,
    timestamp: applicationMap.get("timestamp") as number,
    read: applicationMap.get("read") as boolean,
  };
  if(applicationMap.get("postscript") !== undefined && applicationMap.get("postscript") !== null){
    application.postscript = applicationMap.get("postscript") as string;
  }
  return application;
}