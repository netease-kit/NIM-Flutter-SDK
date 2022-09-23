// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef STABLE_H
#define STABLE_H

#if defined __cplusplus

// std
#include <any>
#include <filesystem>
#include <functional>
#include <iostream>
#include <list>
#include <map>
#include <memory>
#include <mutex>
#include <optional>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

#include "nim_chatroom_cpp_wrapper/nim_cpp_chatroom_api.h"
#include "nim_cpp_wrapper/api/nim_cpp_pass_through_proxy.h"
#include "nim_cpp_wrapper/nim_cpp_api.h"
#ifdef _WIN32
#include "nim_tools_cpp_wrapper/nim_audio_cpp.h"
#endif
#include "utils/singleton.h"
#include "utils/stringHash.hpp"

// third parties
#include "alog.h"
#define YXLOGEnd ALOGEnd
#define YXLOG(level) ALOG_DIY("nim_core_plugin", LogNormal, level)
#define YXLOG_API(level) ALOG_DIY("nim_core_plugin", LogApi, level)

#endif

#endif  // STABLE_H
