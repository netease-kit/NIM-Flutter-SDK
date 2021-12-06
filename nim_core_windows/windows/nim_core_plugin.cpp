// Copyright (c) 2021 NetEase, Inc.  All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "nim_core_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>

#include "./src/MethodCallHandlerImpl.h"
#include "src/utils/dump/appDump.h"

namespace nim_core_plugin {

// static
void NimCorePlugin::RegisterWithRegistrar(flutter::PluginRegistrar *registrar) {
    std::string filePath = getenv("LOCALAPPDATA");
    std::string filePathApp;
    if (!filePath.empty()) {
        filePath.append("/NetEase/NIMCorePlugin");
    } else {
        std::cout << "log filePath empty!" << std::endl;
    }
    filePathApp = filePath;
    filePathApp.append("/app");
    ALog::CreateInstance(filePathApp, "nim_core_plugin", Info);
    ALog::GetInstance()->setShortFileName(true);
    InitDumpInfo("");

    NimCore::getInstance()->setLogDir(filePath);
    auto plugin = std::make_unique<NimCorePlugin>();
    auto methonChannel = plugin->m_channel->startListening(registrar);
    methonChannel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto &call, auto result) { plugin_pointer->HandleMethodCall(call, std::move(result)); });
    registrar->AddPlugin(std::move(plugin));
}

NimCorePlugin::NimCorePlugin() {
    m_channel = std::make_unique<MethodCallHandlerImpl>();
}

NimCorePlugin::~NimCorePlugin() {
    m_channel.reset(nullptr);
}

void NimCorePlugin::HandleMethodCall(const flutter::MethodCall<flutter::EncodableValue> &method_call,
                                     std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    m_channel->onMethodCall(method_call, std::move(result));
}

}  // namespace nim_core_plugin
