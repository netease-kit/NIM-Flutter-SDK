// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>
#import "FLTLogOptions.h"

@interface FLTLog : NSObject

+ (FLTLog *)setUp:(FLTLogOptions *)options;

- (void)apiLog:(NSString *)className desc:(NSString *)desc;

- (void)infoLog:(NSString *)className desc:(NSString *)desc;

- (void)warnLog:(NSString *)className desc:(NSString *)desc;

- (void)errorLog:(NSString *)className desc:(NSString *)desc;
@end
