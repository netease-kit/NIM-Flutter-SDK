// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import "FLTLogOptions.h"

@implementation FLTLogOptions
- (instancetype)init {
  self = [super init];
  if (self) {
    self.level = FLTLogLevelNone;
  }
  return self;
}
@end
