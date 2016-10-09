//
//  RectModel.h
//  LazyScrollView
//
//  Created by chenjunpu on 2016/10/1.
//  Copyright © 2016年 chenjunpu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RectModel : NSObject

/// 转换后的绝对值rect
@property (nonatomic, assign) CGRect absRect;
/// 业务下标
@property (nonatomic, copy) NSString *lazyID;


/**
 初始化

 @param absRect 转换后的绝对值rect
 @param lazyID  业务下标

 @return RectModel
 */
- (__kindof RectModel *)initWithRect:(CGRect)absRect lazyID:(NSString *)lazyID;
+ (__kindof RectModel *)modelWithRect:(CGRect)absRect lazyID:(NSString *)lazyID;

@end

NS_ASSUME_NONNULL_END
