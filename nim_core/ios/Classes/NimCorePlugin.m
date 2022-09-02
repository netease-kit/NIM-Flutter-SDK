// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import "NimCorePlugin.h"
#if __has_include(<nim_core/nim_core-Swift.h>)
#import <nim_core/nim_core-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "nim_core-Swift.h"
#endif

#import <NIMSDK/NIMMessage.h>

@implementation NimCorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  [SwiftNimCorePlugin registerWithRegistrar:registrar];
}
@end
