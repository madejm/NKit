#import <objc/runtime.h>
#import <Foundation/Foundation.h>

extern void setupNKit(void);

@interface NKitHook : NSObject

@end

@implementation NKitHook

+ (void)load {
    setupNKit();
}

@end
