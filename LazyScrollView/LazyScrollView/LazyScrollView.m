//
//  LazyScrollView.m
//  LazyScrollView
//
//  Created by chenjunpu on 2016/10/1.
//  Copyright © 2016年 Tmall. All rights reserved.
//

#import "LazyScrollView.h"
#import "UIView+LazyScrollView.h"
#import "RectModel.h"

#define LAZY_TOP self.contentOffset.y
#define LAZY_BOTTOM self.contentOffset.y + self.bounds.size.height
#define BUFFER 20

NS_ASSUME_NONNULL_BEGIN

@interface LazyScrollView ()

/// 重用池
@property (nullable, nonatomic) NSMutableDictionary<NSString *, NSMutableArray *> *reuserDict;
/// 所有的View的RectModel
@property (nullable, nonatomic) NSMutableArray<RectModel *> *allModels;
/// 注册的View的Classes类型
@property (nullable, nonatomic) NSMutableDictionary<NSString *, Class> *registerClasses;
/// 当前屏幕已经显示的Views
@property (nullable, nonatomic) NSMutableArray<UIView *> *visibleViews;

@end

NS_ASSUME_NONNULL_END

@implementation LazyScrollView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    [self allModelCount];
}

#pragma mark - Public Methods

- (void)reloadData {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.visibleViews removeAllObjects];
    
    [self allModelCount];
    
    // TODO (还有待改善）
    
    NSMutableArray *newVisibleModels = [self visibleRectModelInScreen];
    
    // 获取当前屏幕需要显示的RectModel的LazyID组成数组
    NSMutableArray *newVisibleLazyIDs = [newVisibleModels valueForKey:@"lazyID"];
    
    // 拿当前显示的View的lazyID和需要显示的view的Model的lazyID做对比，可以知道当前显示的View哪些应该被回收
    NSMutableArray *toRemove = [NSMutableArray array];
    
    for (UIView *view in self.visibleViews) {
        
        if (![newVisibleLazyIDs containsObject:view.lazyID]) {
            [toRemove addObject:view];
        }
    }
    
    for (UIView *view in toRemove) {
        
        [self.visibleViews removeObject:view];
        
        [self enqueueReusableView:view];
        
        view.hidden = YES;
    }
    
    // 获取屏幕上已经添加并显示的view的lazyID组成数组和需要显示的view的Model的lazyID做对比，可以知道哪些应该添加
    NSMutableArray *alreadyVisibles = [self.visibleViews valueForKey:@"lazyID"];
    
    for (RectModel *model in newVisibleModels) {
        
        // 已经添加就不需要再添加
        if ([alreadyVisibles containsObject:model.lazyID]) {
            continue;
        }
        
        UIView *view = [self.dataSource scrollView:self itemByLazyID:model.lazyID];
        
        view.frame = model.absRect;
        
        view.lazyID = model.lazyID;
        
        [self.visibleViews addObject:view];
        
        [self addSubview:view];
    }
}

- (void)registerClass:(Class)viewClass forViewReuseIdentifier:(NSString *)identifier {
    [self.registerClasses setValue:viewClass forKey:identifier];
}

- (UIView *)dequeueReusableItemWithIdentifier:(NSString *)identifier {
    
    UIView *view = [self getViewFromReuserDictWithIdentifier:identifier];
    
    // 能取出view,并且veiw的标示符正确
    if (view) {
        // 从缓存池中获取
        view.hidden = NO;
        
        [self.reuserDict removeObjectForKey: identifier];
        
        return view;
        
    }else {
        
        Class viewClass = [self.registerClasses objectForKey:identifier];
        
        view = [viewClass new];
        
        view.reuseIdentifier = identifier;
        
    }
    
    return view;

}

#pragma mark - Set up UI

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Example:
    // old:            0 1 2 3 4 5 6 7
    // new:                2 3 4 5 6 7 8 9
    // to remove:      0 1
    // already visible     2 3 4 5 6 7
    // to add:                         8 9
    
    NSMutableArray *newVisibleModels = [self visibleRectModelInScreen];
    
    // 获取当前屏幕需要显示的RectModel的LazyID组成数组
    NSMutableArray *newVisibleLazyIDs = [newVisibleModels valueForKey:@"lazyID"];
    
    // 拿当前显示的View的lazyID和需要显示的view的Model的lazyID做对比，可以知道当前显示的View哪些应该被回收
    NSMutableArray *toRemove = [NSMutableArray array];

    for (UIView *view in self.visibleViews) {
        
        if (![newVisibleLazyIDs containsObject:view.lazyID]) {
            [toRemove addObject:view];
        }
    }
    
    for (UIView *view in toRemove) {
        
        [self.visibleViews removeObject:view];
        
        [self enqueueReusableView:view];
        
        view.hidden = YES;
    }
    
    // 获取屏幕上已经添加并显示的view的lazyID组成数组和需要显示的view的Model的lazyID做对比，可以知道哪些应该添加
    NSMutableArray *alreadyVisibles = [self.visibleViews valueForKey:@"lazyID"];

    for (RectModel *model in newVisibleModels) {
        
        // 已经添加就不需要再添加
        if ([alreadyVisibles containsObject:model.lazyID]) {
            continue;
        }
        
        UIView *view = [self.dataSource scrollView:self itemByLazyID:model.lazyID];
        
        view.frame = model.absRect;
        
        view.lazyID = model.lazyID;
        
        [self.visibleViews addObject:view];
        
        [self addSubview:view];
    }
    
}

#pragma mark - Private Methods

/// 计算可见区域Rect（暂时没有使用）
- (CGRect)visibleRect {
    return CGRectMake(self.contentOffset.x, LAZY_TOP, self.bounds.size.width, self.bounds.size.height);
}

/// 获取所有的RectModel
- (void)allModelCount {
    
    [self.allModels removeAllObjects];
    NSUInteger count = [self.dataSource numberOfItemInScrollView:self];
    
    for (NSUInteger i = 0; i < count; ++i) {
        RectModel *model = [self.dataSource scrollView:self rectModelAtIndex:i];
        
        [self.allModels addObject:model];
    }
    
    RectModel *model = self.allModels.lastObject;
    
    self.contentSize = CGSizeMake(self.bounds.size.width, model.absRect.origin.y + model.absRect.size.height + 15);
    
}


/**
 当前屏幕需要显示的RectModel

 @return 需要显示的RectModel数组
 */
- (NSMutableArray<RectModel *> *)visibleRectModelInScreen {
    
    NSMutableSet *ascendSet = [self ascendYAndFindGreaterThanTop];
    
    NSMutableSet *descendSet = [self descendYAppendHeightAndFindLessThanBottom];
    
    [ascendSet intersectSet:descendSet];

    NSMutableArray *result = [NSMutableArray arrayWithArray: ascendSet.allObjects];


    
//  曾尝试二分查找
//    NSRange searchRange = NSMakeRange(0, [ascendY count]);
//    NSUInteger findIndex = [ascendY indexOfObject:bottom
//                                    inSortedRange:searchRange
//                                          options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(RectModel *obj1, NSNumber *obj2)
//    {
//        
//        return obj1.absRect.origin.y < [obj2 floatValue];
//                                            
//    }];
//    
//    NSArray *array1 = [ascendY subarrayWithRange:NSMakeRange(findIndex, ascendY.count - findIndex)];
//    NSSet *ascendSet = [NSSet setWithArray:array1];
//
//    NSRange searchRange1 = NSMakeRange(0, [ascendYHeight count]);
//    NSUInteger findIndex1 = [ascendYHeight indexOfObject:top
//                                    inSortedRange:searchRange1
//                                                options:NSBinarySearchingInsertionIndex
//                                        usingComparator:^NSComparisonResult(RectModel *obj1, NSNumber *obj2)
//                            {
//                                
//                                return obj1.absRect.origin.y > [obj2 floatValue];
//                                
//                            }];
//    
//    NSArray *array2 = [ascendYHeight subarrayWithRange:NSMakeRange(findIndex1, ascendYHeight.count - findIndex1)];
//    NSSet *descendSet = [NSSet setWithArray:array2];
//    
//    [ascendSet intersectsSet:descendSet];
//    
//    
//    
//    NSMutableArray *result = [NSMutableArray arrayWithArray: ascendSet.allObjects];
    
//    NSLog(@"findIndex = %d ,findIndex = %d",[[NSNumber numberWithUnsignedInteger:findIndex] intValue], [[NSNumber numberWithUnsignedInteger:findIndex1] intValue]);
    
    return result;
}


/**
 将所有的RectModel按顶边(y)升序排序

 @return 所有底边y大于top的model
 */
- (NSMutableSet *)ascendYAndFindGreaterThanTop {
    
    // 根据顶边(y)升序排序
    NSMutableArray *ascendY = [NSMutableArray arrayWithArray:self.allModels];
    
    [ascendY sortUsingComparator:^NSComparisonResult(RectModel *obj1, RectModel *obj2) {
        
        return obj1.absRect.origin.y > obj2.absRect.origin.y ? NSOrderedDescending : NSOrderedAscending;
        
    }];
    
    // 找到所有底边y大于top的model
    NSNumber *top = [NSNumber numberWithFloat: LAZY_TOP - BUFFER];
    
    NSArray *array;
    for (int i = 0; i < ascendY.count; ++i) {
        RectModel *model = ascendY[i];
        
        if (model.absRect.origin.y + model.absRect.size.height > [top floatValue]) {
            array = [ascendY subarrayWithRange:NSMakeRange(i, ascendY.count - i)];
            
            break;
        }
    }

    NSMutableSet *ascendSet = [NSMutableSet setWithArray:array];
    
    return ascendSet;
}


/**
 将所有的RectModel按底边(y+height)降序排序
 
 @return 所有顶边y小于bottom的model
 */
- (NSMutableSet *)descendYAppendHeightAndFindLessThanBottom {
    
    // 根据底边(y+height)降序排序
    NSMutableArray *dscendYHeight = [NSMutableArray arrayWithArray:self.allModels];
    
    [dscendYHeight sortUsingComparator:^NSComparisonResult(RectModel *obj1, RectModel *obj2) {
        
        return obj1.absRect.origin.y + obj1.absRect.size.height > obj2.absRect.origin.y + obj2.absRect.size.height ? NSOrderedAscending : NSOrderedDescending;
        
    }];
    
    // 找到所有顶边y小于bottom的model
    NSNumber *bottom = [NSNumber numberWithFloat: LAZY_BOTTOM + BUFFER];
    
    NSArray *array;
    
    for (int i = 0; i < dscendYHeight.count; ++i) {
        
        RectModel *model = dscendYHeight[i];
        
        if ((model.absRect.origin.y) < [bottom floatValue]) {
            array = [dscendYHeight subarrayWithRange:NSMakeRange(i, dscendYHeight.count - i)];
            break;
            
        }
    }
    
    NSMutableSet *descendSet = [NSMutableSet setWithArray:array];
    
    return descendSet;
}



/**
 将view添加到重用池

 @param view 要重用的view
 */
- (void)enqueueReusableView:(UIView *)view {
    
    if (!view.reuseIdentifier) {
        return;
    }
    
    NSString *identifier = view.reuseIdentifier;
    
    NSMutableArray *reuseArray = self.reuserDict[identifier];
    
    if (!reuseArray) {
        reuseArray = [NSMutableArray array];
        [self.reuserDict setValue:reuseArray forKey:identifier];
    }
    
    [reuseArray addObject:view];
}


/**
 从重用池中取view

 @param identifier view的重用ID

 @return 可重用的view
 */
- (nullable UIView *)getViewFromReuserDictWithIdentifier:(NSString *)identifier {
    
    if (!identifier) {
        return nil;
    }
    
    NSMutableArray *reuseArray = self.reuserDict[identifier];
    
    if (reuseArray && reuseArray.lastObject) {
        
        UIView *view = reuseArray.lastObject;
        
        return view;
    }
    
    return nil;
    
}

#pragma mark - getter

- (NSMutableDictionary<NSString *,NSMutableArray *> *)reuserDict {
    if (!_reuserDict) {
        _reuserDict = [NSMutableDictionary dictionary];
    }
    return _reuserDict;
}

- (NSMutableArray<RectModel *> *)allModels {
    if (!_allModels) {
        _allModels = [NSMutableArray array];
    }
    return _allModels;
}

- (NSMutableDictionary<NSString *,Class> *)registerClasses {
    if (!_registerClasses) {
        _registerClasses = [NSMutableDictionary dictionary];
    }
    return _registerClasses;
}

- (NSMutableArray<UIView *> *)visibleViews {
    if (!_visibleViews) {
        _visibleViews = [NSMutableArray array];
    }
    return _visibleViews;
}

@end
