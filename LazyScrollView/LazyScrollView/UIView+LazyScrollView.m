//
//  UIView+LazyScrollView.m
//  LazyScrollView
//
//  Created by chenjunpu on 2016/10/1.
//  Copyright © 2016年 Tmall. All rights reserved.
//

#import "UIView+LazyScrollView.h"
#import <objc/runtime.h>

const void * reuseIdentifierKey = "reuseIdentifierKey";
const void * lazyIDKey = "lazyIDkey";

@implementation UIView (LazyScrollView)

- (void)setLazyID:(NSString *)lazyID {
    objc_setAssociatedObject(self, lazyIDKey, lazyID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)lazyID {
    return objc_getAssociatedObject(self, lazyIDKey);
}

- (void)setReuseIdentifier:(NSString *)reuseIdentifier {
    objc_setAssociatedObject(self, reuseIdentifierKey, reuseIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)reuseIdentifier {
    return objc_getAssociatedObject(self, reuseIdentifierKey);
}

+ (UIView *)viewWithLazyID:(NSString *)lazyID reuseIdentifier:(NSString *)reuseIdentifier {
    
    UIView *view = [[self alloc] init];
    view.lazyID = lazyID;
    view.reuseIdentifier = reuseIdentifier;
    
    return view;
}

@end
