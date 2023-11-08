#ifdef __OBJC__
#import <Cocoa/Cocoa.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "nim_core_macos_plugin.h"

FOUNDATION_EXPORT double nim_core_macosVersionNumber;
FOUNDATION_EXPORT const unsigned char nim_core_macosVersionString[];

