//
//  UIView+LazyScrollView.h
//  LazyScrollView
//
//  Created by chenjunpu on 2016/10/1.
//  Copyright © 2016年 chenjunpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LazyScrollView)

/// 索引过的标识，在LazyScrollView范围内唯一
@property (nonatomic, copy) NSString *lazyID;
/// 重用的ID
@property (nonatomic, copy) NSString *reuseIdentifier;


/**
 初始化

 @param lazyID          索引过的标识
 @param reuseIdentifier 重用的ID

 @return UIView
 */
+ (__kindof UIView *)viewWithLazyID:(NSString *)lazyID reuseIdentifier:(NSString *)reuseIdentifier;

@end
