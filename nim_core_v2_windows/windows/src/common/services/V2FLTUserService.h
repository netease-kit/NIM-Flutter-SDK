
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef V2FTLUserService_H
#define V2FTLUserService_H

#include "../FLTService.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_enum.hpp"
#include "v2_nim_def_struct.hpp"

flutter::EncodableMap convertNIMUser2Map(
    const nstd::optional<v2::V2NIMUser> object);

class V2FLTUserService : public FLTService {
 public:
  V2FLTUserService();
  virtual ~V2FLTUserService();
  virtual void onMethodCalled(
      const std::string& method, const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
      override;

 private:
  void getUserList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void updateSelfUserProfile(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void addUserToBlockList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void removeUserFromBlockList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getBlockList(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void getUserListFromCloud(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void searchUserByOption(
      const flutter::EncodableMap* arguments,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  v2::V2NIMUserListener userListener;
};
#endif /* V2FTLUserService_hpp */
