// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import "nim_core_macos_plugin.h"
#import <FlutterMacOS/FlutterMacOS.h>
#import <Foundation/Foundation.h>

#include <iostream>
#include "FLTConvert.h"
#include "NimCore.h"
#include "stable.h"

@implementation FLTNimCoreMacosPlugin

+ (void)registerWithRegistrar:(nonnull id<FlutterPluginRegistrar>)registrar {
  std::string filePath = getenv("HOME");
  std::string filePathApp;
  if (!filePath.empty()) {
    filePath.append("/Library/Application Support/Netease/NIMCorePlugin");
  } else {
    std::cout << "log filePath empty!" << std::endl;
  }
  filePathApp = filePath;
  filePathApp.append("/app");
  ALog::CreateInstance(filePathApp, "nim_core_plugin", Info);
  ALog::GetInstance()->setShortFileName(true);

  NimCore::getInstance()->setLogDir(filePath);
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"flutter.yunxin.163.com/nim_core"
                                  binaryMessenger:[registrar messenger]];
  FLTNimCoreMacosPlugin *instance = [[FLTNimCoreMacosPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  NimCore::getInstance()->setMethodChannel((__bridge void *)channel);
}

- (void)handleMethodCall:(nonnull FlutterMethodCall *)call result:(nonnull FlutterResult)result {
  // NSLog(@"method name: %@",call.method);
  // NSLog(@"method arguments: %@", call.arguments);

  NSString *jsonString = nil;
  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:call.arguments
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&error];
  if (!jsonData) {
    NSLog(@"Got an error: %@", error);
  } else {
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  }

  std::string strArguments = [jsonString UTF8String];
  flutter::EncodableMap arguments;
  Convert::getInstance()->convertJson2Map(arguments, nim::GetJsonValueFromJsonString(strArguments));

  NimCore::getInstance()->onMethodCall(
      [call.method UTF8String], arguments,
      [=](const flutter::EncodableValue *resultData, bool bNotImplemented) {
        if (bNotImplemented) {
          result(FlutterMethodNotImplemented);
          return;
        }

        nim_cpp_wrapper_util::Json::Value value;
        flutter::EncodableMap map = std::get<flutter::EncodableMap>(*resultData);
        Convert::getInstance()->convertMap2Json(&map, value);
        std::string strvalue = nim::GetJsonStringWithNoStyled(value);

        NSString *str = [NSString stringWithCString:strvalue.c_str() encoding:NSUTF8StringEncoding];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        // NSLog(@"dic%@", dic);
        result(dic);
      });
};

@end
