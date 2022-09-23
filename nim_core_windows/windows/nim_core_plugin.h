// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <windows.h>

class MethodCallHandlerImpl;
namespace nim_core_plugin {
class NimCorePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrar* registrar);

  // Creates a plugin instance.
  NimCorePlugin();

  virtual ~NimCorePlugin();

  // Disallow copy and move.
  NimCorePlugin(const NimCorePlugin&) = delete;
  NimCorePlugin& operator=(const NimCorePlugin&) = delete;

  // Called when a method is called on the plugin channel.
  void HandleMethodCall(const flutter::MethodCall<>& method_call,
                        std::unique_ptr<flutter::MethodResult<>> result);

 public:
  std::unique_ptr<MethodCallHandlerImpl> m_channel;
};

}  // namespace nim_core_plugin
