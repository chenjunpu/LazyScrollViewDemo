//
//  LazyScrollView.h
//  LazyScrollView
//
//  Created by chenjunpu on 2016/10/1.
//  Copyright © 2016年 chenjunpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LazyScrollView, RectModel;

NS_ASSUME_NONNULL_BEGIN

@protocol LazyScrollViewDataSource <NSObject>

@required
/// ScrollView一共展示多少个item
- (NSUInteger)numberOfItemInScrollView:(LazyScrollView *)scrollView;

/// 要求根据index直接返回RectModel
- (RectModel *)scrollView:(LazyScrollView *)scrollView rectModelAtIndex:(NSUInteger)index;

/// 返回下标所对应的view
- (UIView *)scrollView:(LazyScrollView *)scrollView itemByLazyID:(NSString *)lazyID;

@end

@interface LazyScrollView : UIScrollView

/// 数据源
@property (nullable, nonatomic, weak) id<LazyScrollViewDataSource> dataSource;

/**
 刷新dataSource
 */
- (void)reloadData;

/**
 注册view的类型

 @param viewClass  view的Class类型
 @param identifier view的重用ID
 */
- (void)registerClass:(nullable Class)viewClass forViewReuseIdentifier:(NSString *)identifier;

/**
 根据identifier获取可以复用的View，通常配合LazyScrollViewDatasource第三个方法使用

 @param identifier 重用ID

 @return 可以复用的View
 */
- (nullable __kindof UIView *)dequeueReusableItemWithIdentifier:(NSString *)identifier;


@end

NS_ASSUME_NONNULL_END
