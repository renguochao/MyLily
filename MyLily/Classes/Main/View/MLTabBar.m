//
//  MLTabBar.m
//  MyLily
//
//  Created by rgc on 15/9/9.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import "MLTabBar.h"
#import "MLTabBarButton.h"

@interface MLTabBar()

@property (nonatomic, strong) MLTabBarButton *selectedButton;

@end

@implementation MLTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)item {
    // 1. 创建按钮
    MLTabBarButton *button = [MLTabBarButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    
    // 2. 设置数据
    button.item = item;
    
    // 3. 监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    // 4. 默认选中第0个按钮
    if (self.subviews.count == 1) {
        [self buttonClick:button];
    }
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(MLTabBarButton *)button {
    
    // 1. 通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtomFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtomFrom:self.selectedButton.tag to:button.tag];
    }
    
    // 2. 设置按钮状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonW = self.frame.size.width / self.subviews.count;
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonY = 0;
    
    for (int index = 0; index < self.subviews.count; index ++) {
        // 1. 取出按钮
        MLTabBarButton *button = self.subviews[index];
        
        // 2. 设置frame
        CGFloat buttonX = buttonW * index;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 3. 绑定tag
        button.tag = index;
    }
}

@end
