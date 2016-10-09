//
//  ViewController.m
//  LazyScrollView
//
//  Created by chenjunpu on 2016/10/1.
//  Copyright © 2016年 chenjunpu. All rights reserved.
//

#import "ViewController.h"

#import "LazyScrollView.h"
#import "HomeView.h"

#import "RectModel.h"

#import "UIView+LazyScrollView.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *viewIdentifier = @"reuseIdentifier";

@interface ViewController ()<LazyScrollViewDataSource>

@property (null_resettable, nonatomic) LazyScrollView *lazyScrollView;

@property (nullable, nonatomic) NSArray<RectModel *> *rectDatas;

@property (nullable, nonatomic) NSDictionary *viewsData;

@end

NS_ASSUME_NONNULL_END;

@implementation ViewController

#pragma mark - life cycle

- (void)loadView {
    [super loadView];
    
    [self loadDatas];
    [self setupUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ***** Custom Delegate *****

#pragma mark - LazyScrollViewDataSource

- (NSUInteger)numberOfItemInScrollView:(LazyScrollView *)scrollView {
    return self.rectDatas.count;
}

- (RectModel *)scrollView:(LazyScrollView *)scrollView rectModelAtIndex:(NSUInteger)index {
    
    return self.rectDatas[index];
}

- (UIView *)scrollView:(LazyScrollView *)scrollView itemByLazyID:(NSString *)lazyID {
    
    HomeView *view = [self.lazyScrollView dequeueReusableItemWithIdentifier:viewIdentifier];
    
    view.data = self.viewsData[lazyID];
    
    return view;
}

#pragma mark - ***** UI *****

#pragma mark - ConfigureUI

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.lazyScrollView];
    self.lazyScrollView.frame = self.view.bounds;
    
}

#pragma mark - ***** Data *****

#pragma mark Handle Data

- (void)loadDatas {
    
    // 测试用例 1
//    RectModel *model0 = [RectModel modelWithRect:CGRectMake(25, 15, 156, 150) lazyID:@"0/0"];
//    RectModel *model1 = [RectModel modelWithRect:CGRectMake(194, 15, 156, 150) lazyID:@"0/1"];
//    RectModel *model2 = [RectModel modelWithRect:CGRectMake(25, 180, 156, 150) lazyID:@"0/2"];
//    RectModel *model3 = [RectModel modelWithRect:CGRectMake(194, 180, 156, 150) lazyID:@"0/3"];
//    RectModel *model4 = [RectModel modelWithRect:CGRectMake(5, 360, 177.5, 150) lazyID:@"1/0"];
//    RectModel *model5 = [RectModel modelWithRect:CGRectMake(192.5, 426, 84, 84) lazyID:@"1/1"];
//    RectModel *model6 = [RectModel modelWithRect:CGRectMake(192.5, 360, 177.5, 56) lazyID:@"1/2"];
//    RectModel *model7 = [RectModel modelWithRect:CGRectMake(286.5, 426, 83.5, 84) lazyID:@"1/3"];
//    RectModel *model8 = [RectModel modelWithRect:CGRectMake(25, 530, 325, 150) lazyID:@"2/0"];
//    RectModel *model9 = [RectModel modelWithRect:CGRectMake(25, 695, 325, 150) lazyID:@"2/1"];
//    RectModel *model10 = [RectModel modelWithRect:CGRectMake(25, 860, 325, 150) lazyID:@"2/2"];
    
    // 测试用例 2
    RectModel *model0 = [RectModel modelWithRect:CGRectMake(25, 15, 150, 150) lazyID:@"0/0"];
    RectModel *model1 = [RectModel modelWithRect:CGRectMake(25, 180, 150, 150) lazyID:@"0/1"];
    RectModel *model2 = [RectModel modelWithRect:CGRectMake(25, 345, 150, 150) lazyID:@"0/2"];
    RectModel *model3 = [RectModel modelWithRect:CGRectMake(25, 510, 150, 150) lazyID:@"0/3"];
    RectModel *model4 = [RectModel modelWithRect:CGRectMake(25, 675, 150, 150) lazyID:@"1/0"];
    RectModel *model5 = [RectModel modelWithRect:CGRectMake(25, 840, 150, 150) lazyID:@"1/1"];
    RectModel *model6 = [RectModel modelWithRect:CGRectMake(25, 1005, 150, 150) lazyID:@"1/2"];
    RectModel *model7 = [RectModel modelWithRect:CGRectMake(25, 1170, 150, 150) lazyID:@"1/3"];
    RectModel *model8 = [RectModel modelWithRect:CGRectMake(25, 1335, 150, 150) lazyID:@"2/0"];
    RectModel *model9 = [RectModel modelWithRect:CGRectMake(25, 1500, 150, 150) lazyID:@"2/1"];
    RectModel *model10 = [RectModel modelWithRect:CGRectMake(25, 1665, 150, 150) lazyID:@"2/2"];

    self.rectDatas = @[model0, model1, model2, model3, model4, model5, model6, model7, model8, model9, model10];
    
    // 各个view的data
    self.viewsData = @{@"0/0" : @"0/0",
                       @"0/1" : @"0/1",
                       @"0/2" : @"0/2",
                       @"0/3" : @"0/3",
                       @"1/0" : @"1/0",
                       @"1/1" : @"1/1",
                       @"1/2" : @"1/2",
                       @"1/3" : @"1/3",
                       @"2/0" : @"2/0",
                       @"2/1" : @"2/1",
                       @"2/2" : @"2/2"};

}


#pragma mark - getter

- (LazyScrollView *)lazyScrollView {
    if (!_lazyScrollView) {
        _lazyScrollView = [LazyScrollView new];
        _lazyScrollView.dataSource = self;
        _lazyScrollView.backgroundColor = [UIColor grayColor];
        [_lazyScrollView registerClass:[HomeView class] forViewReuseIdentifier:viewIdentifier];
    }
    return _lazyScrollView;
}

- (NSArray<RectModel *> *)rectDatas {
    if (!_rectDatas) {
        _rectDatas = [NSArray array];
    }
    return _rectDatas;
}

- (NSDictionary *)viewsData {
    if (!_viewsData) {
        _viewsData = [NSDictionary dictionary];
    }
    return _viewsData;
}

@end
