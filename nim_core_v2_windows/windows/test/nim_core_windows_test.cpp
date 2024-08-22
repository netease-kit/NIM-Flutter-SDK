// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include <flutter/method_call.h>
#include <flutter/method_result_functions.h>
#include <flutter/standard_method_codec.h>
#include <gmock/gmock.h>
#include <gtest/gtest.h>
#include <windows.h>

#include <memory>
#include <string>

#include "../src/NimResult.h"
#include "nim_core_plugin.h"

namespace nim_core_plugin {
namespace test {

namespace {
using flutter::EncodableMap;
using flutter::EncodableValue;
using ::testing::DoAll;
using ::testing::Pointee;
using ::testing::Return;
using ::testing::SetArgPointee;

class MockMethodResult : public flutter::MethodResult<> {
 public:
  MOCK_METHOD(void, SuccessInternal, (const EncodableValue* result),
              (override));
  MOCK_METHOD(void, ErrorInternal,
              (const std::string& error_code, const std::string& error_message,
               const EncodableValue* details),
              (override));
  MOCK_METHOD(void, NotImplementedInternal, (), (override));

  /*virtual void MockMethodResult::ErrorInternal(const std::string& error_code,
  const std::string& error_message, const EncodableValue* details) override {
  }

  virtual void MockMethodResult::NotImplementedInternal() override {
  }

  virtual void MockMethodResult::SuccessInternal(const EncodableValue* result)
  override { const auto* arguments = std::get_if<EncodableMap>(result); auto
  codeIt = arguments->find(EncodableValue("code")); if (codeIt !=
  arguments->end()) { auto code = std::get<int>(codeIt->second); std::cout <<
  "MockMethodResult::SuccessInternal, code: " << std::to_string(code) <<
  std::endl;
      }

      auto errorDetailsIt = arguments->find(EncodableValue("errorDetails"));
      if (errorDetailsIt != arguments->end()) {
          auto errorDetails = std::get<std::string>(errorDetailsIt->second);
          std::cout << "MockMethodResult::SuccessInternal, errorDetails: " <<
  errorDetails << std::endl;
      }

      auto dataIt = arguments->find(EncodableValue("data"));
      if (dataIt != arguments->end()) {
          auto data = std::get<std::string>(dataIt->second);
          std::cout << "MockMethodResult::SuccessInternal, data: " << data <<
  std::endl;
      }
  }*/
};

std::unique_ptr<EncodableValue> createArguments() {
  EncodableMap args = {
      {EncodableValue("serviceName"), EncodableValue("InitializeService")},
  };
  return std::make_unique<EncodableValue>(args);
}
}  // namespace

TEST(NimCorePlugin, InitializeService_initialize) {
  std::unique_ptr<MockMethodResult> result =
      std::make_unique<MockMethodResult>();
  // Expect a success response.
  EXPECT_CALL(*result, SuccessInternal(Pointee(NimResult::getSuccessResult())));
  NimCorePlugin plugin;
  plugin.HandleMethodCall(flutter::MethodCall("initialize", createArguments()),
                          std::move(result));
}
}  // namespace test
}  // namespace nim_core_plugin
