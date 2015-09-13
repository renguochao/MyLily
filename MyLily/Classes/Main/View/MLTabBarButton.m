//
//  MLTabBarButton.m
//  MyLily
//
//  Created by rgc on 15/9/10.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#define kMLTabBarButtonImageRatio 0.6

#import "MLTabBarButton.h"

@implementation MLTabBarButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    }
    return self;
}

/**
 *  取消点击高亮
 */
- (void)setHighlighted:(BOOL)highlighted {
    
}

// 设置item
- (void)setItem:(UITabBarItem *)item {
    _item = item;
    
    // 设置文字
    [self setTitle:item.title forState:UIControlStateNormal];
    // 设置图片
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    // 设置提醒数字
    
}

// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * kMLTabBarButtonImageRatio;
    return CGRectMake(0, 0, imageW, imageH);
}

// 内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleY = contentRect.size.height * kMLTabBarButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height * (1 - kMLTabBarButtonImageRatio);
    
    return CGRectMake(0, titleY, titleW, titleH);
}

@end
