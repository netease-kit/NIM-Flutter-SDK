
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import "FLTALog.h"
static FLTLog *_log = nil;
@implementation FLTALog
+ (void)setUp {
  FLTLogOptions *options = [[FLTLogOptions alloc] init];
  options.level = FLTLogLevelInfo;
  options.moduleName = @"nim_core_v2";
  _log = [FLTLog setUp:options];
}

+ (void)apiLog:(NSString *)className desc:(NSString *)desc {
  [_log apiLog:className
          desc:[NSString stringWithFormat:@"🚰 %@", [desc stringByRemovingPercentEncoding]]];
}
/// warn类型 log
+ (void)warnLog:(NSString *)className desc:(NSString *)desc {
  [_log warnLog:className
           desc:[NSString stringWithFormat:@"❗️ %@", [desc stringByRemovingPercentEncoding]]];
}
+ (void)successLog:(NSString *)className desc:(NSString *)desc {
  [_log infoLog:className
           desc:[NSString stringWithFormat:@"✅ %@", [desc stringByRemovingPercentEncoding]]];
}
/// error类型 log
+ (void)errorLog:(NSString *)className desc:(NSString *)desc {
  [_log errorLog:className
            desc:[NSString stringWithFormat:@"❌ %@", [desc stringByRemovingPercentEncoding]]];
}
+ (void)messageLog:(NSString *)className desc:(NSString *)desc {
  [_log infoLog:className
           desc:[NSString stringWithFormat:@"✉️ %@", [desc stringByRemovingPercentEncoding]]];
}
+ (void)networkLog:(NSString *)className desc:(NSString *)desc {
  [_log infoLog:className
           desc:[NSString stringWithFormat:@"📶 %@", [desc stringByRemovingPercentEncoding]]];
}
@end
