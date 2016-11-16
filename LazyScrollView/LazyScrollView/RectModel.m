//
//  RectModel.m
//  LazyScrollView
//
//  Created by chenjunpu on 2016/10/1.
//  Copyright © 2016年 Tmall. All rights reserved.
//

#import "RectModel.h"

@implementation RectModel

- (RectModel *)initWithRect:(CGRect)absRect lazyID:(NSString *)lazyID {
    self = [super init];
    if (self) {
        self.absRect = absRect;
        self.lazyID = lazyID;
    }
    return self;
}

+ (RectModel *)modelWithRect:(CGRect)absRect lazyID:(NSString *)lazyID {
    return [[self alloc] initWithRect:absRect lazyID:lazyID];
}

@end
