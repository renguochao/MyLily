//
//  MLPostDetailViewController.m
//  MyLily
//
//  Created by rgc on 15/9/14.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import "MLTopicDetailViewController.h"

#import "MLPost.h"
#import "MLAuthor.h"

#import "MLNetTool.h"
#import "TFHpple.h"
#import "Common.h"
#import "MLPostDetailFrame.h"
#import "MLTopicDetailCell.h"
#import "MJRefresh.h"

#define TEST_DOCUMENT_NAME          @"topicDetail"
#define TEST_DOCUMENT_EXTENSION     @"html"

@interface MLTopicDetailViewController ()

@property (nonatomic, strong) NSMutableArray *postDetailFrames;

@property (nonatomic, assign) NSInteger page;

@end

@implementation MLTopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 设置界面
    [self buildUI];
    
    // 2. 加载数据
//    [self loadData];
}

- (void)buildUI {
    // 1.初始化变量
    self.page = 1;
    self.postDetailFrames = [NSMutableArray array];
    
    // 2.添加刷新控件
    [self addRefreshViews];
}

- (void)addRefreshViews {
    // 1.下拉刷新控件
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.header.automaticallyChangeAlpha = YES;
    // 开始刷新
    [self.tableView.header beginRefreshing];
    
    // 2.上拉刷新控件
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/**
 *  加载最新数据
 */
- (void)loadNewData {
    // 1. 获取Data
    NSData *postDetailHtmlData = [MLNetTool loadHtmlDataFromUrl:self.topicUrl];
    
    // 2.解析数据
    [self parseNewData:postDetailHtmlData];
    
    // 3.停止刷新控件
    [self.tableView.header endRefreshing];
}

/**
 *  加载更多数据
 */
- (void)loadMoreData {
    // 1. 获取Data
    NSString *moreTopicUrl = [NSString stringWithFormat:@"%@&start=%ld", self.topicUrl, self.page * 30];
    NSData *postDetailHtmlData = [MLNetTool loadHtmlDataFromUrl:moreTopicUrl];
    
    // 2.解析数据
    if (postDetailHtmlData) {
        [self parseMoreData:postDetailHtmlData];
    }
    
    // 3.停止刷新控件
    [self.tableView.footer endRefreshing];
}

/**
 *  加载第一页数据
 */
- (void)parseNewData:(NSData *)data {
    // 1. 从HTML中搜索tbody节点
    TFHpple *doc = [TFHpple hppleWithHTMLData:data];
    
    NSString *postsXpathQueryString = @"//table[@class='main']";
    NSArray *postsNodes = [doc searchWithXPathQuery:postsXpathQueryString];
    
    for (int i = 0; i < [postsNodes count]; i ++) {
        MLPost *post = [[MLPost alloc] initWithTFHppleElement:[postsNodes objectAtIndex:i]];
        post.level = i;
        MLPostDetailFrame *postDetailFrame = [[MLPostDetailFrame alloc] init];
        [postDetailFrame setPost:post];
        [_postDetailFrames addObject:postDetailFrame];
    }
    
    // 2.刷新TableView数据
    [self.tableView reloadData];
}

/**
 *  加载下一页数据
 */
- (void)parseMoreData:(NSData *)data {
    // 1.从HTML中搜索tbody节点
    TFHpple *doc = [TFHpple hppleWithHTMLData:data];
    
    NSString *postsXpathQueryString = @"//table[@class='main']";
    NSMutableArray *postsNodes = [[NSMutableArray alloc] initWithArray:[doc searchWithXPathQuery:postsXpathQueryString]];
    
    // 2.移除第一个元素
    if ([postsNodes count] > 1) {
        self.page = self.page + 1;
    }
    
    // 加载更多帖子时移除原帖
    if ([postsNodes count] > 0) {
        [postsNodes removeObjectAtIndex:0];
    }
    
    if ([postsNodes count] > 0) {
        
        int levelNum = [_postDetailFrames count];
        
        for (TFHppleElement *element in postsNodes) {
            MLPost *post = [[MLPost alloc] initWithTFHppleElement:element];
            post.level = levelNum ++;
            MLPostDetailFrame *postDetailFrame = [[MLPostDetailFrame alloc] init];
            [postDetailFrame setPost:post];
            [_postDetailFrames addObject:postDetailFrame];
        }
        
        // 3.刷新TableView数据
        [self.tableView reloadData];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_postDetailFrames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"TopicDetail";
    MLTopicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[MLTopicDetailCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MLPostDetailFrame *postDetailFrame = self.postDetailFrames[indexPath.row];
    cell.postDetailFrame = postDetailFrame;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLPostDetailFrame *postDetailFrame = self.postDetailFrames[indexPath.row];
    return postDetailFrame.cellHeight;
}

@end
