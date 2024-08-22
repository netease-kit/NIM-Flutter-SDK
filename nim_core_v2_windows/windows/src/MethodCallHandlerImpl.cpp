// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "MethodCallHandlerImpl.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>

#include "NimCore.h"

MethodCallHandlerImpl::MethodCallHandlerImpl() {}

void MethodCallHandlerImpl::onMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  const auto* arguments =
      std::get_if<flutter::EncodableMap>(method_call.arguments());
  if (arguments) {
    NimCore::getInstance()->onMethodCall(method_call.method_name(), arguments,
                                         result);
  } else {
    if (result) {
      result->NotImplemented();
    }
  }
}

flutter::MethodChannel<flutter::EncodableValue>*
MethodCallHandlerImpl::startListening(flutter::PluginRegistrar* registrar) {
  m_methodChannel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "flutter.yunxin.163.com/nim_core",
          &flutter::StandardMethodCodec::GetInstance());
  NimCore::getInstance()->setMethodChannel(m_methodChannel.get());
  return m_methodChannel.get();
}

void MethodCallHandlerImpl::stopListening() {
  NimCore::getInstance()->setMethodChannel(nullptr);
}