//
//  MLTop10TableViewController.m
//  MyLily
//
//  Created by rgc on 15/9/9.
//  Copyright (c) 2015年 rgc. All rights reserved.
//  十大

#import "MLTop10ViewController.h"
#import "MLTopicDetailViewController.h"

#import "MLPost.h"

#import "MLTop10Cell.h"

#import "MLNetTool.h"
#import "Common.h"
#import "TFHpple.h"
#import "MLHppleParser.h"
#import "MLPostFrame.h"
#import "MJRefresh.h"
#import "MLTopicPageViewController.h"

@interface MLTop10ViewController ()

@property (nonatomic, strong) NSMutableArray *postFrames;

@end

@implementation MLTop10ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置界面
    [self buildUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 1.加载数据
//    [self loadData];
}

- (void)buildUI {
    // 1.添加刷新控件
    [self addRefreshViews];
    
}

- (void)addRefreshViews {
    // 1.下拉刷新控件
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.header.automaticallyChangeAlpha = YES;
    // 开始刷新
    [self.tableView.header beginRefreshing];
    
}

/**
 *  加载最新数据
 */
- (void)loadNewData {
    // 1.加载数据
    NSData *top10HtmlData = [MLNetTool loadHtmlDataFromUrl:kTOP10URL];
    
    // 2.解析数据
    [self parseData:top10HtmlData];
    
    // 3.停止刷新控件
    [self.tableView.header endRefreshing];
}

/**
 *  解析html数据
 *
 *  @param data html返回数据
 */
- (void)parseData:(NSData *)data {
    
    // 1. 从HTML中搜索tr节点
    TFHpple *doc = [TFHpple hppleWithHTMLData:data];
    
    NSString *top10ArticlesXpathQueryString = @"//table/tr";
    NSArray *top10Nodes = [doc searchWithXPathQuery:top10ArticlesXpathQueryString];
    
    _postFrames = [[NSMutableArray alloc] init];
    
    // 2. 遍历十大节点
    for (int i = 1; i < top10Nodes.count; i ++) { // 第一行是title跳过
        TFHppleElement *element = [top10Nodes objectAtIndex:i];
        MLPost *post = [MLHppleParser parseTop10Element:element];
        MLPostFrame *postFrame = [[MLPostFrame alloc] init];
        [postFrame setPost:post];
        [_postFrames addObject:postFrame];
    }
    
    // 3.刷新TableView数据
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_postFrames count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"Top10Cell";
    MLTop10Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[MLTop10Cell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    
    MLPostFrame *postFrame = self.postFrames[indexPath.row];
    [cell setPostFrame:postFrame];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLPostFrame *postFrame = self.postFrames[indexPath.row];
    return postFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLPostFrame *postFrame = self.postFrames[indexPath.row];
    MLPost *post = postFrame.post;
    MLTopicPageViewController *topicDetailVC = [[MLTopicPageViewController alloc] init];
    topicDetailVC.title = post.title;
    topicDetailVC.topicUrl = post.url;
    topicDetailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:topicDetailVC animated:YES];
}

@end
