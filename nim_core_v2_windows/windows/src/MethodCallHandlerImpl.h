// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef METHODCALLHANDLERIMPL_H
#define METHODCALLHANDLERIMPL_H

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>

#include "NimCore.h"

class MethodCallHandlerImpl {
 public:
  MethodCallHandlerImpl();

  void onMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  flutter::MethodChannel<flutter::EncodableValue>* startListening(
      flutter::PluginRegistrar* registrar);

  void stopListening();

 private:
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>>
      m_methodChannel;
};

#endif  // METHODCALLHANDLERIMPL_H