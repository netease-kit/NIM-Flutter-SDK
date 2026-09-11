// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTCONVERT_H
#define FLTCONVERT_H
#include "../FLTService.h"
#include "nim_cpp_wrapper/api/nim_cpp_client.h"
#include "singleton.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_enum.hpp"
#include "v2_nim_def_struct.hpp"
class FLTNIMConvert {
 public:
  SINGLETONG(FLTNIMConvert)

  //   v2::V2NIMBasicOption convertToBasicOption(
  //       const flutter::EncodableMap* arguments) const;

  //   v2::V2NIMLinkOption convertToLinkOption(
  //       const flutter::EncodableMap* arguments) const;

  //   v2::V2NIMFCSOption convertToFCSOption(
  //       const flutter::EncodableMap* arguments) const;

  //   v2::V2NIMPrivateServerOption convertToPrivateServerOption(
  //       const flutter::EncodableMap* arguments) const;

  //   v2::V2NIMDatabaseOption convertToDatabaseOption(
  //       const flutter::EncodableMap* arguments) const;

  //   v2::V2NIMAntispamConfig convertToAntispamConfig(
  //       const flutter::EncodableMap* arguments) const;

  //   v2::V2NIMLocationInfo convertToLocationInfo(
  //       const flutter::EncodableMap* params) const;

  //   v2::V2NIMChatroomLocationConfig convertToLocationConfig(
  //       const flutter::EncodableMap* params) const;

  //   v2::V2NIMChatroomTagConfig convertToTagConfig(
  //       const flutter::EncodableMap* params) const;
  //   v2::V2NIMChatroomLoginOption convertToLoginOption(
  //       const flutter::EncodableMap* params) const;

 private:
  FLTNIMConvert();
};

#endif
// FLTCONVERT_H
