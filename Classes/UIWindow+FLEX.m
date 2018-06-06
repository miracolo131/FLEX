//
//  UIWindow+FLEX.m
//  FLEX
//
//  Created by Miracolo Bosco on 2018/6/6.
//  Copyright © 2018年 Flipboard. All rights reserved.
//

#import "UIWindow+FLEX.h"
#import "FLEXManager.h"
#import <FLEXRuntimeUtility.h>

@implementation UIWindow (FLEX)

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)  {
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    // class_addMethod will fail if original method already exists
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    // the method doesn’t exist and we just added one
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load {
    swizzleMethod([self class], @selector(becomeKeyWindow), @selector(swizzled_becomeKeyWindow));
}

- (void)swizzled_becomeKeyWindow {
    // call original implementation
    [self swizzled_becomeKeyWindow];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.numberOfTouchesRequired = 2;
    tap.numberOfTapsRequired = 3;
    [self addGestureRecognizer:tap];
    
}

- (void)tap {
    [[FLEXManager sharedManager] showExplorer];
}


@end
