//
//  MLTabBar.h
//  MyLily
//
//  Created by rgc on 15/9/9.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLTabBar;
@protocol MLTabBarDelegate <NSObject>

@optional
- (void)tabBar:(MLTabBar *)tabBar didSelectedButtomFrom:(int)from to:(int)to;

@end

@interface MLTabBar : UIView

- (void)addTabBarButtonWithItem:(UITabBarItem *)item;
@property (nonatomic, weak) id<MLTabBarDelegate> delegate;
@end
