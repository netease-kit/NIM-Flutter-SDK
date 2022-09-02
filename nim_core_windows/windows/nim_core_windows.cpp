// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "include/nim_core_windows/nim_core_windows.h"

#include <flutter/plugin_registrar_windows.h>

#include "nim_core_plugin.h"

void NimCoreWindowsRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  nim_core_plugin::NimCorePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
