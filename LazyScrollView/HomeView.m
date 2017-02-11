//
//  HomeView.m
//  LazyScrollView
//
//  Created by chenjunpu on 2016/10/2.
//  Copyright © 2016年 chenjunpu. All rights reserved.
//

#import "HomeView.h"
#import "UIView+LazyScrollView.h"
#import "RectModel.h"

@interface HomeView ()

@property (nonatomic) UILabel *title;

@end

@implementation HomeView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - set up UI 

- (void)setupUI {
    
    self.backgroundColor = [self randomColor];
    
    [self addSubview:self.title];
    
    self.title.frame = CGRectMake(0, 0, 50, 50);
}

- (UIColor *) randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

#pragma mark - setter

- (void)setData:(NSString *)data {
    _data = data;
    
    self.title.text = data;
}

#pragma mark - getter

- (UILabel *)title {
    if (!_title) {
        _title = [UILabel new];
    }
    return _title;
}

@end
