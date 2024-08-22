//
//  YYModel.h
//  YYModel <https://github.com/ibireme/YYModel>
//
//  Created by ibireme on 15/5/10.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

#if __has_include(<YXModel/YXModel.h>)
FOUNDATION_EXPORT double YXModelVersionNumber;
FOUNDATION_EXPORT const unsigned char YXModelVersionString[];
#import <YXModel/NSObject+YXModel.h>
#import <YXModel/YXClassInfo.h>
#else
#import "NSObject+YXModel.h"
#import "YXClassInfo.h"
#endif
