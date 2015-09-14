//
//  MLTabBarViewController.m
//  MyLily
//
//  Created by rgc on 15/9/9.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import "MLTabBarViewController.h"
#import "MLBoardsViewController.h"
#import "MLHotTopicsViewController.h"
#import "MLMessageViewController.h"
#import "MLTop10ViewController.h"

#import "MLTabBar.h"

@interface MLTabBarViewController () <MLTabBarDelegate>
/**
 *  自定义tabbar
 */
@property (nonatomic, weak) MLTabBar *customTabBar;

@end

@implementation MLTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化tabbar
    [self setupTabbar];
    
    // 初始化所有子控制器
    [self setupAllChildViewControllers];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    NSLog(@"%@", self.tabBar.subviews);
    
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

/**
 *  初始化tabbar
 */
- (void)setupTabbar {
    MLTabBar *customTabBar = [[MLTabBar alloc] init];
    customTabBar.delegate = self;
//    customTabBar.backgroundColor = [UIColor blackColor];
    customTabBar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

/**
 *  监听tabbar按钮的改变
 *
 *  @param from   原来选择的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(MLTabBar *)tabBar didSelectedButtomFrom:(int)from to:(int)to {
//    NSLog(@"---%d---%d", from, to);
    self.selectedIndex = to;
}

/**
 *  初始化所有子控制器
 */
- (void)setupAllChildViewControllers {
    // 1. 十大
    MLTop10ViewController *top10 = [[MLTop10ViewController alloc] init];
    [self setupAllChildViewControllers:top10 title:@"十大" imageName:@"icon_tab_home_nor" selectedImageName:@"icon_tab_home_pre"];
    
    // 2. 热门话题
    MLHotTopicsViewController *hotTopics = [[MLHotTopicsViewController alloc] init];
    [self setupAllChildViewControllers:hotTopics title:@"热门话题" imageName:@"icon_tab_home_nor" selectedImageName:@"icon_tab_home_pre"];
    
    // 3.浏览版面
    MLBoardsViewController *boards = [[MLBoardsViewController alloc] init];
    [self setupAllChildViewControllers:boards title:@"浏览版面" imageName:@"icon_tab_home_nor" selectedImageName:@"icon_tab_home_pre"];
    
    // 4.查看私信
    MLMessageViewController *message = [[MLMessageViewController alloc] init];
    [self setupAllChildViewControllers:message title:@"私信" imageName:@"icon_tab_home_nor" selectedImageName:@"icon_tab_home_pre"];
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中图标
 */
- (void)setupAllChildViewControllers:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    // 1. 设置控制器属性
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置选中的图标
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 2. 包装一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    // 3. 添加tabbar内部按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}



@end
